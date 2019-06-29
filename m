Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4C9405AD99
	for <lists+netdev@lfdr.de>; Sun, 30 Jun 2019 00:09:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726950AbfF2WJy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 Jun 2019 18:09:54 -0400
Received: from mail-wm1-f66.google.com ([209.85.128.66]:53760 "EHLO
        mail-wm1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726923AbfF2WJy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 29 Jun 2019 18:09:54 -0400
Received: by mail-wm1-f66.google.com with SMTP id x15so12291702wmj.3
        for <netdev@vger.kernel.org>; Sat, 29 Jun 2019 15:09:52 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=r7zlhp1tCoQcEpWOKuGny2AIHnmLB4wQvkMIVKhX+oU=;
        b=PznQIXH7M0LviuaHnpxQh4RpGNjbcdIAxDlIj2AnOSX3/7Q+j+6N7/zX1qT0JTp6Pu
         2fctFB3JZ9SXAa8fXPBTuOANPmDtRECzwcyfjgxZ16+Y+weS0JSr+6Mt187wrF8ao41Z
         apTeNmKYM5xbOo3+K1AwmOyi0n7WEwNa1ajlXPUPRYX/Uzk31jsDseveyaoD6gd43VYo
         TD6SWvO9SpUnHjZ2WKSXWPXiGMtdb9UftEz5YRngirdQbERsPrhCiP/pj+TFle2Vh9NY
         7xWqj51Q00BkwsMXaoSWuZVIBLQm5UYT/ATzeGOZTFbWdNPxLnVlddd2ZAbzHtdOKi3K
         xqfg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=r7zlhp1tCoQcEpWOKuGny2AIHnmLB4wQvkMIVKhX+oU=;
        b=DlYO3gH11qWSCMswFNb5f3NNGu6fdJsGJGe1r77FKezNW2u++7/rORmAmWMP4jApDX
         AnQ1JueDn8HKhesmndL+2IP1J+X4GpUN+3Afd0QEgSsdisYeRFlpHnOmUkIjmFV/LA0u
         PsmnDnm2iVBubbYCTQ0u+67wMgAIVDmZUEne6mMbriUkpQOvlc6FaHrmjvJhr5uTWSW+
         jIrNJqzCTqe6KW2uJ2JIv+wQEvtqtlQqHM1YKJ+FFfh6mfm0x5OjyvUiELBg/JuFeif7
         CAPRkTmANJeByC2GMJNaZrx1nQ7wX9hLNKdXXGVfShijfCMpYCT5G/Xbg39Ncs2nPyxv
         YVPA==
X-Gm-Message-State: APjAAAWhiefgld8y+2UAWuWxy6issKAskdXeaymg/6AKuSkYAOhYrX94
        VLlqCqmdjLoTr9he82sqrInWmesG
X-Google-Smtp-Source: APXvYqwLAofNsL0kHMx3xaO/ak30d6qxzOZcOJolEnWM4qGLdhC401beYvJlFwb5Xi+p6lP+EDR8IQ==
X-Received: by 2002:a1c:7c11:: with SMTP id x17mr10757436wmc.22.1561846191432;
        Sat, 29 Jun 2019 15:09:51 -0700 (PDT)
Received: from ?IPv6:2003:ea:8bf3:bd00:b46c:12ac:acc1:b4f5? (p200300EA8BF3BD00B46C12ACACC1B4F5.dip0.t-ipconnect.de. [2003:ea:8bf3:bd00:b46c:12ac:acc1:b4f5])
        by smtp.googlemail.com with ESMTPSA id 32sm13080623wra.35.2019.06.29.15.09.50
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sat, 29 Jun 2019 15:09:50 -0700 (PDT)
Subject: Re: r8169 not working on 5.2.0rc6 with GPD MicroPC
To:     Karsten Wiborg <karsten.wiborg@web.de>, nic_swsd@realtek.com,
        romieu@fr.zoreil.com
Cc:     netdev@vger.kernel.org
References: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <85548ec0-350b-118f-a60c-4be2235d5e4e@gmail.com>
Date:   Sun, 30 Jun 2019 00:09:45 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:60.0) Gecko/20100101
 Thunderbird/60.7.2
MIME-Version: 1.0
In-Reply-To: <0a560a5e-17f2-f6ff-1dad-66907133e9c2@web.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 29.06.2019 22:34, Karsten Wiborg wrote:
> Hello,
> 
> writing to you because of the r8168-dkms-README.Debian.
> 
> I am using a GPD MicroPC running Debian Buster with Kernel:
> Linux praktifix 5.2.0-050200rc6-generic #201906222033 SMP Sun Jun 23
> 00:36:46 UTC 2019 x86_64 GNU/Linux
> 
> 
> Got the Kernel from:
> https://kernel.ubuntu.com/~kernel-ppa/mainline/v5.2-rc6/
> Reason for the Kernel: it includes Hans DeGoedes necessary fixes for the
> GPD MicroPC, see:
> https://github.com/jwrdegoede/linux-sunxi
> (btw. I also tried Hans' 5.2.0rc5-kernel which also did not work with
> respect to Ethernet). Googling of course didn't help out either.
> 
> 
> My GPD MicroPC with running r8169 gives the following lines in dmesg:
> ...
If r8169 (the mainline driver) is running, why do you want to switch
to r8168 (the Realtek vendor driver)? The latter is not supported by
the kernel community.

> [    2.839485] libphy: r8169: probed
> [    2.839776] r8169 0000:02:00.0 eth0: RTL8168h/8111h,
> 00:00:00:00:00:00, XID 541, IRQ 126
> [    2.839779] r8169 0000:02:00.0 eth0: jumbo features [frames: 9200
> bytes, tx checksumming: ko]
> ...
> [    2.897924] r8169 0000:02:00.0 eno1: renamed from eth0
> 
> 
> ip addr show gives me:
> # ip addr show
> ...
> 2: eno1: <BROADCAST,MULTICAST> mtu 1500 qdisc noop state DOWN group
> default qlen 1000
>     link/ether 00:00:00:00:00:00 brd ff:ff:ff:ff:ff:ff
> ...
> 
Seems like the network isn't started.

> 
> ethtool gives me:
> # ethtool -i eno1
> driver: r8169
> version:
> firmware-version:
> expansion-rom-version:
> bus-info: 0000:02:00.0
> supports-statistics: yes
> supports-test: no
> supports-eeprom-access: no
> supports-register-dump: yes
> supports-priv-flags: no
> 
> 
> lspci shows me:
> 02:00.0 Ethernet controller: Realtek Semiconductor Co., Ltd.
> RTL8111/8168/8411 PCI Express Gigabit Ethernet Controller (rev 15)
> 
> 
> Installing r8168-dkms fails with the following errors:
> Setting up r8168-dkms (8.046.00-1) ...
> Removing old r8168-8.046.00 DKMS files...
> 
> ------------------------------
> Deleting module version: 8.046.00
> completely from the DKMS tree.
> ------------------------------
> Done.
> Loading new r8168-8.046.00 DKMS files...
> Building for 5.2.0-050200rc6-generic 5.2.0-rc5-gpd-custom
> Building initial module for 5.2.0-050200rc6-generic
> Error! Bad return status for module build on kernel:
> 5.2.0-050200rc6-generic (x86_64)
> Consult /var/lib/dkms/r8168/8.046.00/build/make.log for more information.
> dpkg: error processing package r8168-dkms (--configure):
>  installed r8168-dkms package post-installation script subprocess
> returned error exit status 10
> Errors were encountered while processing:
>  r8168-dkms
> E: Sub-process /usr/bin/dpkg returned an error code (1)
> 
> 
> Does that help you?
> Do you need more data?
> Thank you very much in advance for hopefully looking into this matter.
> 
> Regards,
> Karsten Wiborg
> .
> 

