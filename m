Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D29FD857CC
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 03:53:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389655AbfHHBwH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 21:52:07 -0400
Received: from outbound.smtp.vt.edu ([198.82.183.121]:49582 "EHLO
        omr1.cc.vt.edu" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S2387536AbfHHBwG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 21:52:06 -0400
Received: from mr2.cc.vt.edu (mr2.cc.ipv6.vt.edu [IPv6:2607:b400:92:8400:0:90:e077:bf22])
        by omr1.cc.vt.edu (8.14.4/8.14.4) with ESMTP id x781q5hT015318
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 21:52:05 -0400
Received: from mail-qk1-f197.google.com (mail-qk1-f197.google.com [209.85.222.197])
        by mr2.cc.vt.edu (8.14.7/8.14.7) with ESMTP id x781q0p2009570
        for <netdev@vger.kernel.org>; Wed, 7 Aug 2019 21:52:05 -0400
Received: by mail-qk1-f197.google.com with SMTP id g4so7668624qkk.1
        for <netdev@vger.kernel.org>; Wed, 07 Aug 2019 18:52:05 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:sender:from:to:cc:subject:mime-version:date
         :message-id;
        bh=IVOB0NY2JGj/kstTGc6wLued6V3alD1RmAyhwYH10so=;
        b=We/YrR5lSCgtnidVylQJUiQpZ3HC8589G0+MnjMgkHb15gDUD/f7L/tb457b/eR0xB
         qUKT1a1s+xWtlKa1289S7TKdrTlMr6bDNN9nX7rt5c+4UeK9NMf2NyO1PQZICG4g0RwF
         /n+4KlaBwZcSypg9Q6UB8heYWBtaTKdE8NCSFIEZefsjzAoJD8RDXd3fgynAnv0ck4oa
         6X7Bd58euz2WTsdpBKJ63zsKr8i74FJHoESTjBxjl5F1i52QTmiYRoDmqpX7tVsXBAhz
         AkIC95PTQgIL2IgdN6Z1Orw7lb60/C5unbCT4ymITSxlrH6ZJIOrMDxW6C+CBEbtEA3s
         S3gw==
X-Gm-Message-State: APjAAAXyfU+OVpjwLvrGwNrSaiwt4/I4gYrQ64wzZ1CzZCdy0Gdd36lW
        yvWTFnx/Jtc5Qq/QGxz8fEcvqREtRmc3AKwvkl0JpokpPhOKsCE0TorxdBsUmg5AG5VGDojoY0Y
        ntnm6qaPqvhV6TF6dhcCCTY7twxQ=
X-Received: by 2002:ac8:45d2:: with SMTP id e18mr10979187qto.258.1565229120429;
        Wed, 07 Aug 2019 18:52:00 -0700 (PDT)
X-Google-Smtp-Source: APXvYqwsFTfPXmDA5/PiMsVC9GvHUAyCGr/895p2INC7GFhiSvFjcwVR2PUfzyinAlZa29Z3TikFcw==
X-Received: by 2002:ac8:45d2:: with SMTP id e18mr10979177qto.258.1565229120197;
        Wed, 07 Aug 2019 18:52:00 -0700 (PDT)
Received: from turing-police ([2601:5c0:c001:4341::359])
        by smtp.gmail.com with ESMTPSA id q29sm2965320qtf.74.2019.08.07.18.51.58
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Wed, 07 Aug 2019 18:51:59 -0700 (PDT)
From:   "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <valdis.kletnieks@vt.edu>
X-Google-Original-From: "Valdis =?utf-8?Q?Kl=c4=93tnieks?=" <Valdis.Kletnieks@vt.edu>
X-Mailer: exmh version 2.9.0 11/07/2018 with nmh-1.7+dev
To:     Ping-Ke Shih <pkshih@realtek.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>
Cc:     linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] Fix non-kerneldoc comment in realtek/rtlwifi/usb.c
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Date:   Wed, 07 Aug 2019 21:51:58 -0400
Message-ID: <34195.1565229118@turing-police>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Fix spurious warning message when building with W=1:

  CC [M]  drivers/net/wireless/realtek/rtlwifi/usb.o
drivers/net/wireless/realtek/rtlwifi/usb.c:243: warning: Cannot understand  * on line 243 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:760: warning: Cannot understand  * on line 760 - I thought it was a doc line
drivers/net/wireless/realtek/rtlwifi/usb.c:790: warning: Cannot understand  * on line 790 - I thought it was a doc line

Clean up the comment format.

Signed-off-by: Valdis Kletnieks <valdis.kletnieks@vt.edu>

---
Changes since v1:  Larry Finger pointed out the patch wasn't checkpatch-clean.

diff --git a/drivers/net/wireless/realtek/rtlwifi/usb.c b/drivers/net/wireless/realtek/rtlwifi/usb.c
index 34d68dbf4b4c..4b59f3b46b28 100644
--- a/drivers/net/wireless/realtek/rtlwifi/usb.c
+++ b/drivers/net/wireless/realtek/rtlwifi/usb.c
@@ -239,10 +239,7 @@ static void _rtl_usb_io_handler_release(struct ieee80211_hw *hw)
 	mutex_destroy(&rtlpriv->io.bb_mutex);
 }
 
-/**
- *
- *	Default aggregation handler. Do nothing and just return the oldest skb.
- */
+/*	Default aggregation handler. Do nothing and just return the oldest skb.  */
 static struct sk_buff *_none_usb_tx_aggregate_hdl(struct ieee80211_hw *hw,
 						  struct sk_buff_head *list)
 {
@@ -756,11 +753,6 @@ static int rtl_usb_start(struct ieee80211_hw *hw)
 	return err;
 }
 
-/**
- *
- *
- */
-
 /*=======================  tx =========================================*/
 static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 {
@@ -786,11 +778,7 @@ static void rtl_usb_cleanup(struct ieee80211_hw *hw)
 	usb_kill_anchored_urbs(&rtlusb->tx_submitted);
 }
 
-/**
- *
- * We may add some struct into struct rtl_usb later. Do deinit here.
- *
- */
+/* We may add some struct into struct rtl_usb later. Do deinit here.  */
 static void rtl_usb_deinit(struct ieee80211_hw *hw)
 {
 	rtl_usb_cleanup(hw);

