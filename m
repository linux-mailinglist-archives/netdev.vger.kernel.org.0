Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 87A8679A75
	for <lists+netdev@lfdr.de>; Mon, 29 Jul 2019 22:57:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729682AbfG2U5n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jul 2019 16:57:43 -0400
Received: from mail-pg1-f177.google.com ([209.85.215.177]:42101 "EHLO
        mail-pg1-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729662AbfG2U5l (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Jul 2019 16:57:41 -0400
Received: by mail-pg1-f177.google.com with SMTP id t132so28838943pgb.9
        for <netdev@vger.kernel.org>; Mon, 29 Jul 2019 13:57:41 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=uHzDQ9ZwY5LoconqOHezwnxbRpx8IYZOgoapva8LiCk=;
        b=ra3yvP9N+8mJcS6kbPBmgqz0fAmeCqLkp/GAjd1HB3lPpVo85A6IgO0rZ+uHL7Sx3r
         91NrNDndciGlr/doesu9cmVQfhfOXERtpV0MZmZKlgBkz6WdPC47ijdjgi/5vWxbDqcM
         IkUNzO5rH3ufnPiKnSjhNY6vSc1M16zxnOpNnjUVrTqZ5haL/+oT2EBvLxKPEnxN9ilf
         zaFaMBatfzyWb9wKz3zWbeRl1S4GQt1NuNUogAcfV/mZiIObEL1TrXxekRQrlDkKg0hC
         /x10LcUkr2OZn5ThOGmn6zPuF2fjodLwt6mYIhaBg++4m5ZDIg/9AY/6cNinR24cdf8u
         gCug==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=uHzDQ9ZwY5LoconqOHezwnxbRpx8IYZOgoapva8LiCk=;
        b=XGDqpZeN/McVWGlSRrG0Uyg2qwVB+GoKCxPRFjVluNl2M+DfpYTAUphGlEo7SY1hut
         BDay68Lxe31UQyePOeIR8nXMDZ6mCWT3V0fUgvt7NEZ4/5P4ijmY6nc0oKfoUXE/Gcpg
         ufSxmcGRg/ZeZXaH4uUXT4GUWqB76Gkc7chLahjGXeEvU53iw8JSSCD7ZLSwYbK6VduD
         hH6cxvxUkor4wdBktUm8cQ0ZtSbJ7xqCJRVksNKfoyGzjk/qpCioWvuPM9CaO1cwxwBf
         vSoRrPUYXp4iIoGw1ugKssysnZp26dSXMSwukUgRjQHPP0zcr5MmkcjkTbIMJbCFP3hM
         eTAg==
X-Gm-Message-State: APjAAAXNYWrBj9JV4iTLXaI6K42+Q0IIuvMkf9wEBIyzcr9tbUZGFmGw
        eDJpkljSm1u5n7lgA8l0b+jevqB9
X-Google-Smtp-Source: APXvYqzNriR/qWzgIaoOSUDsVL1yrwj9E9bNk5RO6JkLCbbXDyPDpoeBOurymr1IK+cOKMRj0+1BrQ==
X-Received: by 2002:a62:8344:: with SMTP id h65mr38511708pfe.85.1564433860727;
        Mon, 29 Jul 2019 13:57:40 -0700 (PDT)
Received: from [172.27.227.219] ([216.129.126.118])
        by smtp.googlemail.com with ESMTPSA id v12sm55445072pgr.86.2019.07.29.13.57.38
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Mon, 29 Jul 2019 13:57:39 -0700 (PDT)
Subject: Re: ip route JSON format is unparseable for "unreachable" routes
To:     Michael Ziegler <ich@michaelziegler.name>, netdev@vger.kernel.org
References: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <0e475b1e-7a4a-753a-85b1-9dd051313ccc@gmail.com>
Date:   Mon, 29 Jul 2019 14:57:36 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.14; rv:52.0)
 Gecko/20100101 Thunderbird/52.9.1
MIME-Version: 1.0
In-Reply-To: <6e88311b-5edc-4c62-1581-0f5b160a5f4e@michaelziegler.name>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/28/19 5:09 AM, Michael Ziegler wrote:
> Hi,
> 
> I created a couple "unreachable" routes on one of my systems, like such:
> 
>> ip route add unreachable 10.0.0.0/8     metric 255
>> ip route add unreachable 192.168.0.0/16 metric 255
> 
> Unfortunately this results in unparseable JSON output from "ip":
> 
>> # ip -j route show  | jq .
>> parse error: Objects must consist of key:value pairs at line 1, column 84
> 
> The offending JSON objects are these:
> 
>> {"unreachable","dst":"10.0.0.0/8","metric":255,"flags":[]}
>> {"unreachable","dst":"192.168.0.0/16","metric":255,"flags":[]}
> "unreachable" cannot appear on its own here, it needs to be some kind of
> field.
> 
> The manpage says to report here, thus I do :) I've searched the
> archives, but I wasn't able to find any existing bug reports about this.
> I'm running version
> 

it's a problem printing the route type in general - any route not of
type 'unicast'. I will send a patch
