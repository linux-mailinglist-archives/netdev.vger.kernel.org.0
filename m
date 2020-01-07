Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E30E6132C70
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 18:04:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728458AbgAGRE2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 12:04:28 -0500
Received: from mail-wr1-f41.google.com ([209.85.221.41]:33947 "EHLO
        mail-wr1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728365AbgAGRE1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 12:04:27 -0500
Received: by mail-wr1-f41.google.com with SMTP id t2so258338wrr.1;
        Tue, 07 Jan 2020 09:04:25 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=IYfcm5h1cwl8bkXOp1RiSEGJOTmPBd55Dmd0o2oSeVY=;
        b=iUNmmeSuzydmOzkjxeb7cBBjSaJZwUMi4TFoMv6AkTIkb/2kZnFionSLEChAR0x6Fr
         78+sa1u3EOMp0UH2Nx6aWwNh9m9Q9GmTZFc461po2HquNCB6UATaRwf4f08kwKnyXj/t
         uAFuH5DMQ+cwRAQkMyPArGajdkyuiCSrfukSXgDNGwLnG7PH6Y6iwajBZtg6wlipMBrB
         HYdl6+O2IOocjapDE9AkyBfW/QQkAW3LppqCKjOotj9oWcKGZBk+F579wSSMToKKeRim
         LPZh/Z+EZFxgMS008ce4vYgUlmlf34Pw2XmZ2950ucUvlgzJuo051KNKKebsers/pLMi
         m8kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IYfcm5h1cwl8bkXOp1RiSEGJOTmPBd55Dmd0o2oSeVY=;
        b=JEpPJlYKWt2CkvCuf9hU1rFaTgexAUaaBW+7wXexaHVHdDMpCPzoaWOnLWWhZYW/d6
         YKdBHqsCW4nKGZClAkaE+1KgK99X+4g+gHl5fEzljqdhgS07uwtFpBT4KFvCVM0tE4Ih
         NImTTDIAKxZbuq/T/FBJP9JOBHNlfpeFewuVwK29S1qiWzp1JvJqkyWTjSuRb+yIwBKK
         W0V9+XUygRLB5lCItfFdvoVOMDTyz1QEhovncqsJWISKR/DkOhpGHRuvUe+kvFCEP3JU
         YdsB66tb6ZmkDSSqjQYXyklPSfem6uO4hgBjZRvlBe3uQwlh2uFrgRDpJm6R2JN4TWgV
         PpyA==
X-Gm-Message-State: APjAAAWMceknJZoa1v/QhugJ/XbfKvkx/0sdp1tlooOMnRf4tOXhPlp2
        fjr/Pcxu20wZptgCCV3DEdM3SIx1
X-Google-Smtp-Source: APXvYqySIve4GD71YKIDS+ZHu0rPQM3EZ0gXw1AB2UPcUSIEWhuQfQhTFe5d2dZcmPPwZHqjWi+Y3w==
X-Received: by 2002:a5d:6284:: with SMTP id k4mr46915wru.398.1578416665218;
        Tue, 07 Jan 2020 09:04:25 -0800 (PST)
Received: from [192.168.8.147] (118.164.185.81.rev.sfr.net. [81.185.164.118])
        by smtp.gmail.com with ESMTPSA id n1sm541472wrw.52.2020.01.07.09.04.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 07 Jan 2020 09:04:24 -0800 (PST)
Subject: Re: [RPI 3B+ / TSO / lan78xx ]
To:     RENARD Pierre-Francois <pfrenard@gmail.com>,
        nsaenzjulienne@suse.de, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-usb@vger.kernel.org, stefan.wahren@i2se.com
References: <5267da21-8f12-2750-c0c5-4ed31b03833b@gmail.com>
 <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <863777f2-3a7b-0736-d0a4-d9966bea3f96@gmail.com>
Date:   Tue, 7 Jan 2020 09:04:23 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <78b94ba2-9a87-78bb-8916-e6ef5a0668ae@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/7/20 5:32 AM, RENARD Pierre-Francois wrote:
> 
> Hello all
> 
> I am facing an issue related to Raspberry PI 3B+ and onboard ethernet card.
> 
> When doing a huge transfer (more than 1GB) in a row, transfer hanges and failed after a few minutes.
> 
> 
> I have two ways to reproduce this issue
> 
> 
> using NFS (v3 or v4)
> 
>     dd if=/dev/zero of=/NFSPATH/file bs=4M count=1000 status=progress
> 
> 
>     we can see that at some point dd hangs and becomes non interrutible (no way to ctrl-c it or kill it)
> 
>     after afew minutes, dd dies and a bunch of NFS server not responding / NFS server is OK are seens into the journal
> 
> 
> Using SCP
> 
>     dd if=/dev/zero of=/tmp/file bs=4M count=1000
> 
>     scp /tmp/file user@server:/directory
> 
> 
>     scp hangs after 1GB and after a few minutes scp is failing with message "client_loop: send disconnect: Broken pipe lostconnection"
> 
> 
> 
> 
> It appears, this is a known bug relatted to TCP Segmentation Offload & Selective Acknowledge.
> 
> disabling this TSO (ethtool -K eth0 tso off & ethtool -K eth0 gso off) solves the issue.
> 
> A patch has been created to disable the feature by default by the raspberry team and is by default applied wihtin raspbian.
> 
> comment from the patch :
> 
> /* TSO seems to be having some issue with Selective Acknowledge (SACK) that
>  * results in lost data never being retransmitted.
>  * Disable it by default now, but adds a module parameter to enable it for
>  * debug purposes (the full cause is not currently understood).
>  */
> 
> 
> For reference you can find
> 
> a link to the issue I created yesterday : https://github.com/raspberrypi/linux/issues/3395
> 
> links to raspberry dev team : https://github.com/raspberrypi/linux/issues/2482 & https://github.com/raspberrypi/linux/issues/2449
> 
> 
> 
> If you need me to test things, or give you more informations, I ll be pleased to help.
>


I doubt TSO and SACK have a serious generic bug like that.

Most likely the TSO implementation on the driver/NIC has a bug .

Anyway you do not provide a kernel version, I am not sure what you expect from us.
