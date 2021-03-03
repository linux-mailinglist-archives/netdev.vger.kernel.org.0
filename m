Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3795332C3E4
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:51:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1354446AbhCDAIq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:08:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51642 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232897AbhCCGwC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 01:52:02 -0500
Received: from mail-wr1-x42d.google.com (mail-wr1-x42d.google.com [IPv6:2a00:1450:4864:20::42d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 89E60C061756;
        Tue,  2 Mar 2021 22:51:16 -0800 (PST)
Received: by mail-wr1-x42d.google.com with SMTP id f12so18596875wrx.8;
        Tue, 02 Mar 2021 22:51:16 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=8JdY2JS+1+w/fgyi7UwJfIDGPQZQW84sAhTJerAI7Oo=;
        b=PgdXYZl5kTjYEWXcfoaydo1YdGO+iE+8oO2TGSCSrs8jsa42HXuRgPiU0U7DchcSbW
         +oKZRMG1k2rfj36Ou0jvAzCKJfCsvIpIcy/ldvBmw6bbhbS/S7A76bYWTLcWPWcOTOqm
         0ksRxq0YG+16R9uJByZE6eWj3mGjcXc1m1XanUjARH8hTn+IO2Ro99mDxdLwDvedoSDH
         Keri6KW5bJtSSOjFg1CWa7k5kQYpdCaK2HAaDUb5x/uYtiG4V0eqjKE04jyTwjiGuKBP
         rH0+mzEtlmf67gC+USFpQzfS54DJur9yGnwP2T536eVlbCPviLR9BvwRvkJN/25Jxh5w
         zEBg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=8JdY2JS+1+w/fgyi7UwJfIDGPQZQW84sAhTJerAI7Oo=;
        b=DTgauoUGTH6u4veWmvrw1ER2PZUez/JSiVrQnNroUk/HIpsgDnuv/MkMz11JxVkDch
         XO4lxUMCakCG+QJvBV7df1AjzOcASSHvufPGFQooV/ecM8esZcRqeq7o68bwJeTajK59
         X6qkNDk6a+ucigSkmn09KLq2sT5AZ9aQ74EN3EFGQor0NuMW/cbBo+XVdRkMAjZyjXkl
         Dbbx8yy+Wt8dHoxD1WTEP9DZZlHzeUzOn1oHhQTRRjV4cGJ1ko/tmHUVhvDFEx89BJ45
         Id/iDaOiYitMz1kd28KXca5wfYulgxatdNb+QYyyhJPyo5z+OY6bDD8GWNSD2B1LGdeb
         mUPA==
X-Gm-Message-State: AOAM533Io/Nj5IfKBetdXz7P5BMj/jvuLS7Yqcm/9Mk5RqTE4QeLORX+
        fJB2zLuRuLqoB1v3VwMo33NSOJAYouIBnw==
X-Google-Smtp-Source: ABdhPJzLCQKKKvug8DvHVhgWybYNp0Wj1smYraXBkLfUzBIKDyQ8vPkfSX9QgIDdO248Rm1uymSfPg==
X-Received: by 2002:adf:fac1:: with SMTP id a1mr26310548wrs.98.1614754275283;
        Tue, 02 Mar 2021 22:51:15 -0800 (PST)
Received: from ?IPv6:2003:ea:8f39:5b00:b95e:61df:ef38:eb5b? (p200300ea8f395b00b95e61dfef38eb5b.dip0.t-ipconnect.de. [2003:ea:8f39:5b00:b95e:61df:ef38:eb5b])
        by smtp.googlemail.com with ESMTPSA id p18sm24188956wro.18.2021.03.02.22.51.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 02 Mar 2021 22:51:14 -0800 (PST)
Subject: Re: next-20210302 - build issue with linux-firmware and rtl_nic/
 firmware.
To:     =?UTF-8?Q?Valdis_Kl=c4=93tnieks?= <valdis.kletnieks@vt.edu>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
References: <199898.1614751762@turing-police>
From:   Heiner Kallweit <hkallweit1@gmail.com>
Message-ID: <02b966f5-a056-b799-dd6d-c5dc762d42f3@gmail.com>
Date:   Wed, 3 Mar 2021 07:51:06 +0100
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <199898.1614751762@turing-police>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 03.03.2021 07:09, Valdis Klētnieks wrote:
> So my kernel build died..
> 
>   UPD     drivers/base/firmware_loader/builtin/rtl_nic/rtl8106e-1.fw.gen.S
> make[4]: *** No rule to make target '/lib/firmware/rtl_nic/rtl8106e-1.fw', needed by 'drivers/base/firmware_loader/builtin/rtl_nic/rtl8106e-1.fw.gen.o'.  Stop.
> make[3]: *** [scripts/Makefile.build:514: drivers/base/firmware_loader/builtin] Error 2
> 
> I tracked it down to a linux-firmware update that shipped everything with .xz compression:
> 
> % rpm2cpio linux-firmware-20201218-116.fc34.noarch.rpm | cpio -itv | grep 8106e-1
> -rw-r--r--   1 root     root         1856 Dec 19 04:43 ./usr/lib/firmware/rtl_nic/rtl8106e-1.fw
> 631034 blocks
> % rpm2cpio linux-firmware-20210208-117.fc34.noarch.rpm | cpio -itv|  grep 8106e-1
> -rw-r--r--   1 root     root          848 Feb  8 16:38 ./usr/lib/firmware/rtl_nic/rtl8106e-1.fw.xz
> 340217 blocks
> 
> and my .config shows it's self-inflicted (no, I don't remember why it's in there):
> 
> # Firmware loader
> CONFIG_EXTRA_FIRMWARE="rtl_nic/rtl8106e-1.fw"
> CONFIG_EXTRA_FIRMWARE_DIR="/lib/firmware"
> 
This is wrong, simply remove it.

> But then I take a closer look at  drivers/net/ethernet/realtek/r8169_main.c
> #define FIRMWARE_8168D_1	"rtl_nic/rtl8168d-1.fw"
> #define FIRMWARE_8168D_2	"rtl_nic/rtl8168d-2.fw"
> #define FIRMWARE_8168E_1	"rtl_nic/rtl8168e-1.fw"
> 
> So now I'm mystified how this compressing all the firmware files is supposed to work...
> 
