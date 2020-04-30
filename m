Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CD1141BED44
	for <lists+netdev@lfdr.de>; Thu, 30 Apr 2020 02:58:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726431AbgD3A64 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Apr 2020 20:58:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47272 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726279AbgD3A6z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Apr 2020 20:58:55 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9FF58C035494
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:58:55 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id j1so4812048wrt.1
        for <netdev@vger.kernel.org>; Wed, 29 Apr 2020 17:58:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=LAom/5XyfNYEYu4U1V0uLnMQO5Pw8EeSU5KUZrwVz1g=;
        b=WvCljVypvx+AObl2uAEmHvYJKwk6XD7OuI8ZbJ3ZqogNIT1tNwE1S9zdlzPgtEf6b8
         9WnYf7meEWmXbA0Qx+KmDUraekGx7T8Eh31+woUI5TB3L5SF9EIEoSL2KHxROJeVo+JK
         LHEl7iiSL5TdBY4LSLe/PfetnymNtcckNatQ8=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=LAom/5XyfNYEYu4U1V0uLnMQO5Pw8EeSU5KUZrwVz1g=;
        b=J/S7TAKffdw8Xan5i/Fi8p/aG4ayKwS0vHGbUGn25KMhaeh6FLctH+3DBLfXG3IJzj
         o3T6yPTN01/eEX5daN0Pam8VAgZegi6JMxoCl0O95GpsuPT4i7hjY2ZBvlqxwW+5yeAx
         TuC5bHOhWUfltG+a65GCtHxVjs3K9HjY3hJHG7hgHtua8NS18FKiZY8wrslgWg5VkO+E
         3i9N0V37s7DmuqWcJlbk9Ars4Ca81MK5bHfW+bOfSxfjUxmfTfj+FNasKorME22JshNs
         rHv/B5YBKvGSnA0BwhB8m/8EU7WUgKAdcybjq9OjHogHCSbyEiW3mXEGPWOTeZsujJLJ
         oauw==
X-Gm-Message-State: AGi0Pub1bpGHi8taTUt6RSBsatpkFrFxqKOcpHL+HEDvzd/XYwxyZc2W
        3mwDn31nLVXydtCEL4lieZBq5WjCQxEzSw==
X-Google-Smtp-Source: APiQypIYkKWfc9cAkSgL8IsAYWdUdb/KpksLmeCRIXqFrxbH2tuJYkPmGkK4kEY2GSWsMZ0KsJcWfA==
X-Received: by 2002:adf:f750:: with SMTP id z16mr751269wrp.115.1588208333385;
        Wed, 29 Apr 2020 17:58:53 -0700 (PDT)
Received: from [192.168.0.112] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.googlemail.com with ESMTPSA id b22sm10548865wmj.1.2020.04.29.17.58.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Apr 2020 17:58:52 -0700 (PDT)
Subject: Re: [PATCH iproute2 1/7] bridge: Use the same flag names in input and
 output
To:     Benjamin Poirier <bpoirier@cumulusnetworks.com>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
Cc:     netdev <netdev@vger.kernel.org>
References: <20200427235051.250058-1-bpoirier@cumulusnetworks.com>
 <20200427235051.250058-2-bpoirier@cumulusnetworks.com>
 <CAJieiUh0c1LCud2ZNuD5MygrBO=Yb1OgqHawxjgkX1j+6NHMrQ@mail.gmail.com>
 <20200430002216.GA76853@f3>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <a2fc6935-555f-b881-1ff2-f824bd08d6ae@cumulusnetworks.com>
Date:   Thu, 30 Apr 2020 03:58:51 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200430002216.GA76853@f3>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 4/30/20 3:22 AM, Benjamin Poirier wrote:
> On 2020-04-29 08:12 -0700, Roopa Prabhu wrote:
>> On Mon, Apr 27, 2020 at 4:51 PM Benjamin Poirier
>> <bpoirier@cumulusnetworks.com> wrote:
>>>
>>> Output the same names for vlan flags as the ones accepted in command input.
>>>
>>> Signed-off-by: Benjamin Poirier <bpoirier@cumulusnetworks.com>
>>> ---
>>
>> Benjamin, It's a good change,  but this will break existing users ?.
> 
> Nikolay voiced the same concern. The current output looks like
> 
> ben@f3:~$ bridge vlan
> port    vlan ids
> br0     None
> tap0     1 PVID Egress Untagged
> 
> tap1     1 PVID Egress Untagged
> 
> docker0  1 PVID Egress Untagged
> 
> ben@f3:~$
> 
> "PVID Egress Untagged" look like 3 flags to me. Anything we can do to
> improve it?
> 

Put a "," after PVID ? :-)
The bigger problem is that "Egress Untagged" is also used as a flag in the json output.
Anyone parsing that and looking at the flags would be broken. In addition
this has been described in many of HowTos and docs over the years.

I'd just drop this change.

Thanks,
  Nik

