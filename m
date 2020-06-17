Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 273581FD683
	for <lists+netdev@lfdr.de>; Wed, 17 Jun 2020 22:57:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgFQU4q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Jun 2020 16:56:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34596 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726758AbgFQU4q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 17 Jun 2020 16:56:46 -0400
Received: from mail-wr1-x442.google.com (mail-wr1-x442.google.com [IPv6:2a00:1450:4864:20::442])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AED94C06174E
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:45 -0700 (PDT)
Received: by mail-wr1-x442.google.com with SMTP id b6so3815862wrs.11
        for <netdev@vger.kernel.org>; Wed, 17 Jun 2020 13:56:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:from:to:cc:references:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=ODJBbeZcCQquLoXgh17IK5pd3cIH+B4P1lBpzq8f/YE=;
        b=hlHKcBqpJD1G3ikkD+HdvIXUTy1AYIIlbGP7QfACJ55ACoGIBuE1BWdlaWdxCHY8gk
         MmdBFCSPOTFn/TBHWNV4ghwSRAa3zRmP0weYMhypuZW7nZNwKwPrEJ57+3xjDGnOJXvm
         0OXfOyWTQPDI87Qr4nLysay7WWuh90OwrOuvuImroJ93IrDOK3n9IaAH6dtAYIIAVg1v
         rCJNy8+YbeULzBpVEpEzfLbpesOY7UwE/eNct6BDT+PMnc93cM0G+LCPFaxLr3KtIF1K
         BGCPgJaJq2w6ylS1oC9m/lxTVpHgnfD5VyKpk7rFBoXiDIHElzzPUa+ej77n4xR5Ak9G
         daMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:cc:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=ODJBbeZcCQquLoXgh17IK5pd3cIH+B4P1lBpzq8f/YE=;
        b=AnXBNDsKvuIxHhdz5pookwED9TliyZ+3UGJoW5mR1KTdmOaaT3KVSUK3SwndC6UCzZ
         tm5Tme1sOQdfqFoPdXFb79Id1b1U2x51w4bLTPjIooV2rTAajEc7hTMVdyB2QKuvrMML
         NpF10b9ta8dcuxdAL9h2jTGWUgufZff1AYRRP5oiLLACxh6MynqceXIyM34tY4XaOeal
         gI+Y81Bsg4GRCXFA8f1xyc+rUzkQKKii+QwNKoYZoyvVzwRouwQ7sikRhc7wcGMAu4lV
         CtpCDwMaht7ilIhLxC+mFp8RoEULiX2D+ePfONo4RSZMYSa5IiUB1LAqMrJhvlGA/l2Z
         ypRA==
X-Gm-Message-State: AOAM532mtunEF0yr/ULxJW/vWF//mA+xePn4OD37bQlYE3vCOm3HOd20
        7YBNYdua/wmENAH21HjuyfBNdE16
X-Google-Smtp-Source: ABdhPJz2q19hiHyYEv+kAKBmaAchJP8jYawWm1RKLV/8Jx5Pd/qsVHBkbfcgw8neFYnkb9Uhoe2Bbg==
X-Received: by 2002:adf:f450:: with SMTP id f16mr1055648wrp.307.1592427404131;
        Wed, 17 Jun 2020 13:56:44 -0700 (PDT)
Received: from ?IPv6:2003:ea:8f23:5700:c06e:b26:fa7c:aab? (p200300ea8f235700c06e0b26fa7c0aab.dip0.t-ipconnect.de. [2003:ea:8f23:5700:c06e:b26:fa7c:aab])
        by smtp.googlemail.com with ESMTPSA id q128sm969776wma.38.2020.06.17.13.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 17 Jun 2020 13:56:43 -0700 (PDT)
Subject: [PATCH net-next 2/8] r8169: remove unused constant RsvdMask
From:   Heiner Kallweit <hkallweit1@gmail.com>
To:     Realtek linux nic maintainers <nic_swsd@realtek.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Message-ID: <64643297-cbef-e72e-5822-9c95fdc3aa9c@gmail.com>
Date:   Wed, 17 Jun 2020 22:51:46 +0200
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Thunderbird/68.9.0
MIME-Version: 1.0
In-Reply-To: <ef2a4cd4-1492-99d8-f94f-319eeb129137@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Since 9d3679fe0f30 ("r8169: inline rtl8169_make_unusable_by_asic")
this constant isn't used any longer, so remove it.

Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>
---
 drivers/net/ethernet/realtek/r8169_main.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/drivers/net/ethernet/realtek/r8169_main.c b/drivers/net/ethernet/realtek/r8169_main.c
index 7bb26fb07..4bc6c5529 100644
--- a/drivers/net/ethernet/realtek/r8169_main.c
+++ b/drivers/net/ethernet/realtek/r8169_main.c
@@ -529,8 +529,6 @@ enum rtl_rx_desc_bit {
 	RxVlanTag	= (1 << 16), /* VLAN tag available */
 };
 
-#define RsvdMask	0x3fffc000
-
 #define RTL_GSO_MAX_SIZE_V1	32000
 #define RTL_GSO_MAX_SEGS_V1	24
 #define RTL_GSO_MAX_SIZE_V2	64000
-- 
2.27.0


