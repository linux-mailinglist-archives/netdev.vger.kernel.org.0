Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5250E16F6EE
	for <lists+netdev@lfdr.de>; Wed, 26 Feb 2020 06:14:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727078AbgBZFOJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 26 Feb 2020 00:14:09 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:43874 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726089AbgBZFOI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 26 Feb 2020 00:14:08 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:In-Reply-To:References;
        bh=0ycAnDc1mDz//TJNujJVfqAUznKl13u8yooFEbRUpVU=; b=o3TtZtRAsbCem3whbkX9svccVq
        /quTK6jPIHMK2DeeiqWiFQJLiicmcMbn4mc8SSVdO0tG+UmkVVQWLCciHMG9VXhbAekEnKnn8OJCT
        qFeWsi6m2IXTyUYbM1qudui0e0N4T0aAg93XkBMgT8Mg0tmhxnIc3+xb5c5M6Dxzmm6fI9D/u2+N6
        TK3dZJfly+C+JucV4Xw9YjwGE/R6tk61PivYzpz2/TWtQy7gWdwxkqp9sL88bumQN+N5DYouCeo9j
        d/L3tV0hdfB00i6qva267VeaMOyjchl+RCtFHC05tY9A3uR69Day8KN7XaRz4Y/eEUhd1ssIGxXYU
        ksQabE/w==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1j6p1K-0003Pv-MZ; Wed, 26 Feb 2020 05:14:06 +0000
To:     LKML <linux-kernel@vger.kernel.org>, X86 ML <x86@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        "Maciej W. Rozycki" <macro@linux-mips.org>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [RFC PATCH] x86: slightly reduce defconfigs
Message-ID: <433f203e-4e00-f317-2e6b-81518b72843c@infradead.org>
Date:   Tue, 25 Feb 2020 21:14:05 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.4.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Eliminate 2 config symbols from both x86 defconfig files:
HAMRADIO and FDDI.

The FDDI Kconfig file even says (for the FDDI config symbol):
  Most people will say N.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc:	x86@kernel.org
Cc:	netdev@vger.kernel.org
Cc:	"Maciej W. Rozycki" <macro@linux-mips.org>
Cc:	"David S. Miller" <davem@davemloft.net>
---
 arch/x86/configs/i386_defconfig   |    2 --
 arch/x86/configs/x86_64_defconfig |    2 --
 2 files changed, 4 deletions(-)

--- linux-next-20200225.orig/arch/x86/configs/i386_defconfig
+++ linux-next-20200225/arch/x86/configs/i386_defconfig
@@ -125,7 +125,6 @@ CONFIG_IP6_NF_MANGLE=y
 CONFIG_NET_SCHED=y
 CONFIG_NET_EMATCH=y
 CONFIG_NET_CLS_ACT=y
-CONFIG_HAMRADIO=y
 CONFIG_CFG80211=y
 CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
@@ -171,7 +170,6 @@ CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 # CONFIG_8139TOO_PIO is not set
 CONFIG_R8169=y
-CONFIG_FDDI=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y
--- linux-next-20200225.orig/arch/x86/configs/x86_64_defconfig
+++ linux-next-20200225/arch/x86/configs/x86_64_defconfig
@@ -123,7 +123,6 @@ CONFIG_IP6_NF_MANGLE=y
 CONFIG_NET_SCHED=y
 CONFIG_NET_EMATCH=y
 CONFIG_NET_CLS_ACT=y
-CONFIG_HAMRADIO=y
 CONFIG_CFG80211=y
 CONFIG_MAC80211=y
 CONFIG_MAC80211_LEDS=y
@@ -164,7 +163,6 @@ CONFIG_SKY2=y
 CONFIG_FORCEDETH=y
 CONFIG_8139TOO=y
 CONFIG_R8169=y
-CONFIG_FDDI=y
 CONFIG_INPUT_POLLDEV=y
 # CONFIG_INPUT_MOUSEDEV_PSAUX is not set
 CONFIG_INPUT_EVDEV=y

