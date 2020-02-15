Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CF42715FF2E
	for <lists+netdev@lfdr.de>; Sat, 15 Feb 2020 17:12:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726318AbgBOQMy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 Feb 2020 11:12:54 -0500
Received: from mail-wr1-f67.google.com ([209.85.221.67]:46038 "EHLO
        mail-wr1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726143AbgBOQMx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 Feb 2020 11:12:53 -0500
Received: by mail-wr1-f67.google.com with SMTP id g3so14560525wrs.12
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 08:12:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=sender:date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to;
        bh=Gum50LwYS+/3fvxvmz9DZtYVntrb0o89MxiSsLjOxpk=;
        b=FCP2ruNkXBjGMtv4kzViiM6Okf6eZR9RFiyZmgZo+UXbFWcsZdzkFOetZ53uJmmDHk
         b4SNm28l8puloMWNOrmwE00dZPDRKscwv+CwriAfxlt0qPBWzYrbmWdLdYymeQJkl/nw
         bSgWL8tKA0qsSV4M6Z3P08MCvm8viOZMbQsA73bR+igJufloF5PeP2eRjQAIOjbYntWF
         7cFKI4IiLMH3UWqCB+s++nqDh1GdZLLiyVvQNjIOoYZxEEBl2ijfSi9OvjsO/RIsHHDl
         4oiAWdasnGvxZRzGUcwFqML+1+/i0ZIy/V1WDOmwwmJHUNc6u0YT+qjAWA08T2yzE7Z/
         mkxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:date:from:to:cc:subject:message-id
         :references:mime-version:content-disposition
         :content-transfer-encoding:in-reply-to;
        bh=Gum50LwYS+/3fvxvmz9DZtYVntrb0o89MxiSsLjOxpk=;
        b=NdMVoB2DCvR9Xz4+1DRQAXtoq/4aVyFMWlVRGFa4x7CXpJGwoYQKC7FDiFaagYZLzw
         Ccn0dp0AWLkmovsBEV4P+OlCxCfYT9tbGtTs3SLHxp92d2XIfQJdghfbK9LgGTEbW4Ce
         pHDuttdFWA0/jMz1C4+nw4Crg20E2UXt7nHraVRc7RJJz7Q5EYUp5BLqYtHpSO8z34B3
         69Uzm0glzaAelMOv9SofSuP51b8ZSUfFXIJ535Jz/WoLfdrJ9HISqMUJxnFL/CZqcEXj
         BlbX/+xI3ta7TMzHQ5oKd01k2aMEG0i9VaWK0sT/ojE+GEevEo4xIKgWucSc8ccjyKF1
         ZS9g==
X-Gm-Message-State: APjAAAWGZS+8ZKBOl626J0wl7w10ANTiHwHQwPVdlb5SItED7x01+Ihq
        eICa9Dz1Az+NWRKmrLCuRuwaUwJQ0gA=
X-Google-Smtp-Source: APXvYqyabxF5IXUnCtoi9JuvvRhIST+YlkyhxL613SDTaR9PqmsRwRLEhhZUXcWdFiMqNgplkX05fg==
X-Received: by 2002:a5d:5044:: with SMTP id h4mr10248586wrt.4.1581783169941;
        Sat, 15 Feb 2020 08:12:49 -0800 (PST)
Received: from eldamar (80-218-24-251.dclient.hispeed.ch. [80.218.24.251])
        by smtp.gmail.com with ESMTPSA id g17sm12286321wru.13.2020.02.15.08.12.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Sat, 15 Feb 2020 08:12:48 -0800 (PST)
Date:   Sat, 15 Feb 2020 17:12:47 +0100
From:   Salvatore Bonaccorso <carnil@debian.org>
To:     Vincas Dargis <vindrg@gmail.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>, netdev@vger.kernel.org
Subject: Re: About r8169 regression 5.4
Message-ID: <20200215161247.GA179065@eldamar.local>
References: <b46d29d8-faf6-351e-0d9f-a4d4c043a54c@gmail.com>
 <9e865e39-0406-d5e0-5022-9978ef4ec6ac@gmail.com>
 <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <97b0eb30-7ae2-80e2-6961-f52a8bb26b81@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Vincas,

On Sat, Feb 15, 2020 at 11:22:01AM +0200, Vincas Dargis wrote:
> 2020-02-14 22:14, Heiner Kallweit rašė:
> > On 14.02.2020 18:21, Vincas Dargis wrote:
> > > Hi,
> > > 
> > > I've found similar issue I have myself since 5.4 on mailing list archive [0], for this device:
> > > 
> > Thanks for reporting. As you refer to [0], do you use jumbo packets?
> 
> Not sure, I guess not, because "1500"?
> 
> $ ip link | fgrep enp
> 2: enp5s0f1: <BROADCAST,MULTICAST,UP,LOWER_UP> mtu 1500 qdisc pfifo_fast
> state UP mode DEFAULT group default qlen 1000
> 
> > Best of course would be a bisect between 5.3 and 5.4. Can you do this?
> > I have no test hardware with this chip version (RTL8411B).
> 
> Uhm, never done that, I'll have to research how do I "properly" build kernel in "Debian way" first.
> 
> > You could also try to revert a7a92cf81589 ("r8169: sync PCIe PHY init with vendor driver 8.047.01")
> > and check whether this fixes your issue.
> > In addition you could test latest 5.5-rc, or linux-next.
> 
> I've tried linux-image-5.5.0-rc5-amd64  (5.5~rc5-1~exp1) package form Debian
> experimental, issue "WARNING: CPU: 6 PID: 0 at net/sched/sch_generic.c:447
> dev_watchdog+0x248/0x250" still occurs after some time after boot.
> 
> I'll try first to rebuild one of the Debian kernels after reverting that
> a7a92cf81589 patch, for starters.

You can generate the a7a92cf81589 revert patch, and then for simple
testing of a patch and build have a look at the Simple patching and
building[1] section of the kernel handbook.

Hope this helps,

Regards,
Salvatore

 [1] https://kernel-team.pages.debian.net/kernel-handbook/ch-common-tasks.html#s4.2.2
