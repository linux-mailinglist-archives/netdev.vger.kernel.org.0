Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E834B2B3140
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 23:55:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726248AbgKNWyb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 17:54:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48490 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726203AbgKNWyb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Nov 2020 17:54:31 -0500
Received: from mout-p-103.mailbox.org (mout-p-103.mailbox.org [IPv6:2001:67c:2050::465:103])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D0912C0613D1
        for <netdev@vger.kernel.org>; Sat, 14 Nov 2020 14:54:30 -0800 (PST)
Received: from smtp1.mailbox.org (smtp1.mailbox.org [IPv6:2001:67c:2050:105:465:1:1:0])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-384) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mout-p-103.mailbox.org (Postfix) with ESMTPS id 4CYVyW6FQWzQjhF;
        Sat, 14 Nov 2020 23:54:27 +0100 (CET)
X-Virus-Scanned: amavisd-new at heinlein-support.de
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=pmachata.org;
        s=MBO0001; t=1605394466;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:
         content-transfer-encoding:content-transfer-encoding;
        bh=bBFwsfHBNx5EUoDcIsE6Uvbkf9cLXnVa0v5didBBK1U=;
        b=eIv1Mqcyo+oDtLpYgR3ob4Gqx6vuwLLlYmDI2rYFOoTLxpKA1ouPXZTWqdiVgs/YdlzWVN
        09uYspTSs2iQITk+bi5FoN/HhFvnPlyn9PtQCqHgs331QbOHsNC5Yjt+8xB8q3bJ9NhRHy
        nd3cLTlqgB8yRpK5Ddp9h1Wpvb0EpnWG2UKQpzCjqyL5dEn+osnAA+D/Ezk40JRfyWvpHz
        9M+ttH2vgv2+ZCIenYxSMPVJl4dmhs922aI6GJtV19mlr7DTV5UqeLwygkLztVXt7yFKte
        5cMmS0S29GiHFlM/2Ptfd9Vy+40AN1AEgHaDeJr6qcu8bdsho8tl7pPG9Ex0IA==
Received: from smtp1.mailbox.org ([80.241.60.240])
        by spamfilter04.heinlein-hosting.de (spamfilter04.heinlein-hosting.de [80.241.56.122]) (amavisd-new, port 10030)
        with ESMTP id XQOKU2gXFtNR; Sat, 14 Nov 2020 23:54:24 +0100 (CET)
From:   Petr Machata <me@pmachata.org>
To:     netdev@vger.kernel.org, dsahern@gmail.com,
        stephen@networkplumber.org
Cc:     Petr Machata <me@pmachata.org>
Subject: [PATCH iproute2-next 0/7] Convert a number of use-cases to parse_on_off(), print_on_off()
Date:   Sat, 14 Nov 2020 23:53:54 +0100
Message-Id: <cover.1605393324.git.me@pmachata.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-MBO-SPAM-Probability: *
X-Rspamd-Score: 1.31 / 15.00 / 15.00
X-Rspamd-Queue-Id: DF57A181E
X-Rspamd-UID: a12119
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two helpers, parse_on_off() and print_on_off(), have been recently added to
lib/utils.c. Convert a number of instances of the same effective behavior
to calls to these helpers.

Petr Machata (7):
  bridge: link: Port over to parse_on_off()
  bridge: link: Convert to use print_on_off()
  ip: iplink: Convert to use parse_on_off()
  ip: iplink_bridge_slave: Port over to parse_on_off()
  ip: iplink_bridge_slave: Convert to use print_on_off()
  ip: ipnetconf: Convert to use print_on_off()
  ip: iptuntap: Convert to use print_on_off()

 bridge/link.c            | 135 ++++++++++++++++++---------------------
 ip/iplink.c              |  47 +++++---------
 ip/iplink_bridge_slave.c |  46 +++++--------
 ip/ipnetconf.c           |  28 ++++----
 ip/iptuntap.c            |  18 ++----
 5 files changed, 112 insertions(+), 162 deletions(-)

-- 
2.25.1

