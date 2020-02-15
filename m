Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7237C15FDCF
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 10:22:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726090AbgBOJWG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 04:22:06 -0500
Received: from mail-lj1-f194.google.com ([209.85.208.194]:38665 "EHLO
        mail-lj1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725963AbgBOJWF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 04:22:05 -0500
Received: by mail-lj1-f194.google.com with SMTP id w1so13364836ljh.5
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 01:22:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=1U/LNVpKMYnVUhWX8fEzic20b0IIkrtdYyOFlbts6aY=;
        b=gIsoN3QIZNhBlWI9iZUOR+qLE5CQK9a1q7bN7uSPoNHV24YqnN+QrdCJ3j+EJziusl
         CbJsYBiVLCL62rl/j0onJL2SwsaSXhU2+YStz1BxbbQFggIy0jbQ002Q0myFJxFtNnAz
         KcrcoRdYAHi/vvT1qTwOFmX5ooV8ysWoS0sgBCtUZN3KbPIeASSRZD9Xy/gsv1PiVLQi
         uFnoTCbYgaDGNthv4x1l81DEzSCWw+Z8zrFcLvxLz7GDVLCEsBTueoHzBUGMP6O0XGbN
         luQafa0sy887R5XNt1cd8uICHrCZdrHxpwFIuu5x/fzSfw9ErbTBh1sfUHI+mTtYIAJv
         +HNw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=1U/LNVpKMYnVUhWX8fEzic20b0IIkrtdYyOFlbts6aY=;
        b=W6e4pEENpOZc7yIXsn1RizWMSQFmv0Fb/Tnx8395oLpCDVYamN7R8ywaGEGtdOpfIJ
         KrN8yklbYsYwgrCiuwqeqchXxDpjwzO1N/krYVlekAGgipAz2ZMqMEn6VB+Q0ZZOz6aK
         YzVAvHTAH/Ko1RK/PJUwt6sSeXzi1x3hUty2ta0p4sFpejSw0Zso7NsVmZYRE4cqMMR+
         fYuJRMPxFleZstHMMzwqwIs8hquLoKLIJ4DbtYmIqXjKuHF+93f6OeqbCoNPmY0KBjyM
         jkZBRc30nS8gta5MUIgXwURs44oABgJ7l8RSvR5c/0yiQ4NON4rry/41EgDUYf21uTVN
         Ep4w==
X-Gm-Message-State: APjAAAVcgfk8H3vze3IT5ltTuHuYu4qAq9MMtevtriQMMQQ18EW6Sa25
        tflfxSkPC25lvj8VoZ++4HrPNbEn
X-Google-Smtp-Source: APXvYqw6dWL+WiVFMWazdBexWt/dUEqydpzoUmu5iD4Tl5BogcSIGYIH0zXPD9yEsPzMa7dAlpbrmA==
X-Received: by 2002:a2e:580c:: with SMTP id m12mr4541104ljb.150.1581758523242;
        Sat, 15 Feb 2020 01:22:03 -0800 (PST)
Received: from [192.168.1.10] (hst-227-49.splius.lt. [62.80.227.49])
        by smtp.gmail.com with ESMTPSA id 4sm4153586lfj.75.2020.02.15.01.22.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 15 Feb 2020 01:22:02 -0800 (PST)
Subject: Re: About r8169 regression 5.4
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     netdev@vger.kernel.org
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
From:   Vincas Dargis <vindrg@gmail.com>
Message-ID: <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
Date:   Sat, 15 Feb 2020 11:22:01 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.5.0
MIME-Version: 1.0
In-Reply-To: <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

2020-02-14 22:14, Heiner Kallweit rašė:
> On 14.02.2020 18:21, Vincas Dargis wrote:
>> Hi,
>>
>> I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:
>>
> Thanks for reporting. As you refer to [0], do you use jumbo packets?

Not sure, I guess not, because "1500"?

$ ip link | fgrep enp
2: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast state UP mode DEFAULT group 
default qlen 1000

> Best of course would be a bisect between 5.3 and 5.4. Can you do this?
> I have no test hardware with this chip version (RTL8411B).

Uhm, never done that, I'll have to research how do I "properly" build kernel in "Debian way" first.

> You could also try to revert a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
> and check whether this fixes your issue.
> In addition you could test latest 5.5-rc, or linux-next.

I've tried linux-image-5.5.0-rc5-amd64  (5.5~rc5-1~exp1) package form Debian experimental, issue 
"WARNING: CPU: 6 PID: 0 at net/sched/sch_generic.c:447 dev_watchdog+0x248/0x250" still occurs after 
some time after boot.

I'll try first to rebuild one of the Debian kernels after reverting that a7a92cf81589 patch, for 
starters.

Thanks for your response Heiner!

