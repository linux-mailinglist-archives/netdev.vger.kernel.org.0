Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 120E3855EA
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 00:39:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387802AbfHGWj2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 18:39:28 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:49426 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1729753AbfHGWj2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 18:39:28 -0400
Received: from mr1.cc.vt.edu (inbound.smtp.ipv6.vt.edu [IPv6:2607:b400:92:9:0:9d:8fcb:4116])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x77MdRsr010531
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 18:39:27 -0400
Received: from mail-qt1-f200.google.com (mail-qt1-f200.google.com [209.85.160.200])
        by mr1.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x77MdM7K009135
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 18:39:27 -0400
Received: by mail-qt1-f200.google.com with SMTP id k31so83843716qte.13
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 15:39:27 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=r0uwyFJeFvH4bAs10mxKtLGquaNY41+jLpUXPC0EZek=;
        b=Bla+5XYH4RG6IdRK7paqP28skmkiDLSVCOSAtQoh/ApMj7L88toos6t20JJJ1I5UBK
         ZO/F6Vlz1py3Isdy9BqqoVP2hhR/2bIF3jws90tFAUY2iHqD07acU3TNESDwZglnHSgH
         Q3o9xVzktlN82n4q5fQebK06Zzf+Vs4tGA01AFgJN8OUWK9YYa12LBdBcRebzutK6dBs
         FRVQdCgNi9o2366XK/gyruN2Ji0s2jcsV24xZ717PZsUhP/VDWrnWHYfypW10CFWlZlj
         lvOZdkC/+FJJVt34TZAjbw4N2As2KwHcP1QcGoNVbYtN5cYOw6pE8IMiiPv8aJ3HkBWq
         55UA==
X-Gm-Message-State: APjAAAV1466U0L0VtDbwTcYjKiXRh03b2c2wxVYD/knv6SQuCXlA5boA
        MZFlqZLmsWWMRaDJgpbVwAT4sH7XwU5H49wGsQgw+8pd9UJiDdoxtjJa63s/nbv9Xha/n/ozhqM
        iU/j0nCsFR/8g7zZp2zSO7s9bB6Q=
X-Received: by 2002:ac8:38a8:: with SMTP id f37mr10506216qtc.150.1565217562213;
        Wed, 07 Aug 2019 15:39:22 -0700 (PDT)
X-Google-Smtp-Source: APXvYqyq2M4kYBk/DP7a4+BlSJvKHDCJm1Prg2gLCqkUE118sy7EEDEjeDyH6Ho3jOyIRsTfF2KH2g==
X-Received: by 2002:ac8:38a8:: with SMTP id f37mr10506192qtc.150.1565217561898;
        Wed, 07 Aug 2019 15:39:21 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id w24sm54135617qtb.35.2019.08.07.15.39.20
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 15:39:20 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Wed, 07 Aug 2019 18:39:20 -0400
Message-ID: <5924.1565217560@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix spurious warning message when building with W=1:

  CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line

Change the comment so gcc doesn't think it's a kerneldoc comment block

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index e24fda5e9087..9478cc0d4f8b 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -239,7 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
 	mutex_destroy(&rtlpriv->io.bb_mutex);
 }
 
-/**
+/*
  *
  *	Default aggregation handler. Do nothing and just return the oldest skb.
  */
@@ -756,7 +756,7 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-/**
+/*
  *
  *
  */
@@ -786,7 +786,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
 }
 
-/**
+/*
  *
  * We may add some struct into struct rtl_usb later. Do deinit here.
  *

