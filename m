Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40FBA494D13
	for <lists+netdev@lfdr.de>; Thu, 20 Jan 2022 12:33:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231651AbiATLd3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 20 Jan 2022 06:33:29 -0500
Received: from tartarus.angband.pl ([51.83.246.204]:47230 "EHLO
        tartarus.angband.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230037AbiATLd3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 20 Jan 2022 06:33:29 -0500
Received: from kilobyte by tartarus.angband.pl with local (Exim 4.94.2)
        (envelope-from <kilobyte@angband.pl>)
        id 1nAVeu-007RBp-3X; Thu, 20 Jan 2022 12:31:16 +0100
Date:   Thu, 20 Jan 2022 12:31:16 +0100
From:   Adam Borowski <kilobyte@angband.pl>
To:     Gal Pressman <gal@nvidia.com>
Cc:     netdev@vger.kernel.org
Subject: build failure: undef ref to __sk_defer_free_flush
Message-ID: <YelIBI/yG7gzy0Sf@angband.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
X-Junkbait: aaron@angband.pl, zzyx@angband.pl
X-SA-Exim-Connect-IP: <locally generated>
X-SA-Exim-Mail-From: kilobyte@angband.pl
X-SA-Exim-Scanned: No (on tartarus.angband.pl); SAEximRunCond expanded to false
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!
Your commit 79074a72d335dbd021a716d8cc65cba3b2f706ab
     net: Flush deferred skb free on socket destroy
causes a build failure if NET=y && INET=n

  LD      .tmp_vmlinux.kallsyms1
ld: net/core/sock.o: in function `sk_defer_free_flush':
/home/kilobyte/linux/./include/net/tcp.h:1378: undefined reference to `__sk_defer_free_flush'


Meow!
-- 
⢀⣴⠾⠻⢶⣦⠀ Aryans: split from other Indo-Europeans ~2900-2000BC → Ural →
⣾⠁⢠⠒⠀⣿⡁     Bactria → settled 2000-1000BC in northwest India.
⢿⡄⠘⠷⠚⠋⠀ Gypsies: came ~1000AD from northern India; aryan.
⠈⠳⣄⠀⠀⠀⠀ Germans: IE people who came ~2800BC to Scandinavia; not aryan.
