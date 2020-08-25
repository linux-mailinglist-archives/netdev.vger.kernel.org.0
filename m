Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8F0FC251CC6
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 18:01:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726940AbgHYQBT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 12:01:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47822 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726635AbgHYQBH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Aug 2020 12:01:07 -0400
Received: from mail-wm1-x32e.google.com (mail-wm1-x32e.google.com [IPv6:2a00:1450:4864:20::32e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BC66FC061574;
        Tue, 25 Aug 2020 09:01:06 -0700 (PDT)
Received: by mail-wm1-x32e.google.com with SMTP id z9so2593812wmk.1;
        Tue, 25 Aug 2020 09:01:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=GqlIVjTW1iaRrj2Ldn6FQUjE2Jdk0+FHiegdjOOHybA=;
        b=pnkRHHhjAEBgWY5x+eFMW0t4S3RoXd5RHnqQGlhZoXxep60UGQHt7wTohTUiQsPki0
         X8cDYP4xt9w6NvEx73OjO4kL1scbrZ0ZZxvqoC475VSDoWUe1Wz32ocDVhc7tuVcL5oJ
         Ui9OHteyR8XB+qvfjZWVzDrTrvPgM8dI4A1XL916iY3N6OZidPQ0neqBYePhHiF6OCpR
         JojLpl9eNGX4VxU9pZOO2FyyhqOXE5h6wZJXyQXZpRwIxZMFmipmBMpuyOuFjEc2TgnK
         fpeSbb+v1L8rALNpGZfIShoW6t3wKqoZTtggAJK8fPXvNotwJw6m4Hh1XcEKwc5eX7em
         Omww==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=GqlIVjTW1iaRrj2Ldn6FQUjE2Jdk0+FHiegdjOOHybA=;
        b=eaDQkLeM7BQTd37cU68rXiuUnrFRe7vefWC5IGnu86ZOFZCn45VuVHyEqDhmnhl/+z
         AenhjyulOZGkydZqm4w0G77M1IgGUzGZVpyo2LHxBhGthEcfwn/zOudWt0EHrJircy7H
         9BHIfqAjgeD9qf/bxgrYbBiLIIy4/0UDkD31lTOXWCbhxpdnZXjtPT7IkI9iCzd+/o+z
         IwYVepY/7KiqGNHauCU8ZNcOEHzLFiLWY0u+kBJ6Hk6Sft+3Azu0lxvJO9R4BJVzqgCv
         uj1lkU/41ro6j7J25lMeFqt5a3dhfwXb5d9KXIj/m1MAFoV69fpvJljMpYLsWTFwxS3A
         scOg==
X-Gm-Message-State: AOAM531QAks9TliJ7LDhRj6dwZaJ2/FgNRihrFtMboNny6d+M6OEDqE5
        mfaHkC1bJPGALcifsCiBDZCPkl1wTLcNqw==
X-Google-Smtp-Source: ABdhPJyr+wKSpdwL2axhfuYsxNLZXt1R/iWLIuhO2Upcy75aWXozRyxdK/K2P9E7GQ0stfcziCvOFg==
X-Received: by 2002:a05:600c:514:: with SMTP id i20mr2762605wmc.102.1598371263990;
        Tue, 25 Aug 2020 09:01:03 -0700 (PDT)
Received: from [10.55.3.147] ([173.38.220.45])
        by smtp.gmail.com with ESMTPSA id y26sm6672788wmj.23.2020.08.25.09.01.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 25 Aug 2020 09:01:03 -0700 (PDT)
Subject: Re: [net-next v5 2/2] seg6: Add documentation for
 seg6_inherit_inner_ipv4_dscp sysctl
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jonathan Corbet <corbet@lwn.net>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        andrea.mayer@uniroma2.it
References: <20200825121844.1576-1-ahabdels@gmail.com>
 <20200825085127.50ba9c82@kicinski-fedora-PC1C0HJN>
From:   Ahmed Abdelsalam <ahabdels@gmail.com>
Message-ID: <ad5dfe4a-da8e-aed2-4a32-cd617ad795b2@gmail.com>
Date:   Tue, 25 Aug 2020 18:01:01 +0200
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:68.0)
 Gecko/20100101 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200825085127.50ba9c82@kicinski-fedora-PC1C0HJN>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 25/08/2020 17:51, Jakub Kicinski wrote:
> On Tue, 25 Aug 2020 12:18:44 +0000 Ahmed Abdelsalam wrote:
>> +	Enable the SRv6 encapsulation to inherit the DSCP value of the inner IPv4 packet.
>> +
>> +	Default: FALSE (Do not inherit DSCP)
>> +
>>   ``conf/default/*``:
>>   	Change the interface-specific default settings.
>>   
> 
> Checkpatch complains about whitespace:
> 
> ERROR: trailing whitespace
> #24: FILE: Documentation/networking/ip-sysctl.rst:1802:
> +seg6_inherit_inner_ipv4_dscp - BOOLEAN                                                                                                                                                                                                                                                                                                        $
> 
sorry forgot to run checkpatch on this one before sending.

patch fixed and resent.
