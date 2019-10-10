Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9BCACD341A
	for <lists+netdev@lfdr.de>; Fri, 11 Oct 2019 00:55:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726532AbfJJWzT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Oct 2019 18:55:19 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:50446 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726135AbfJJWzS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Oct 2019 18:55:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:MIME-Version:Date:Message-ID:Subject:From:Cc:To:Sender:Reply-To:
        Content-ID:Content-Description:Resent-Date:Resent-From:Resent-Sender:
        Resent-To:Resent-Cc:Resent-Message-ID:In-Reply-To:References:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=F2vfSoHJ6UXdVy3ffOnuOtwX6bnamp8PxxmSJvKaEAo=; b=TE5UdKEnHJy6Ze8Jpbz/bJwsw
        0p42jinp8gSV4sseCskCsSEd8eeGRP0dofVA3rGIksSGgzVT6u7E0GegHMeTSzOvRa0RuxcasDMH/
        +9gBS11xQ+PygWcTyRM2OhR1L+BLnpYV54BcqmE8CK1g+rMQTb0K43pRW6ZnQZ6xL9XThoWUI/xO+
        BO3up8rBZBoHAyPUsEAHcP9a3t9EoeswzeSWwIlkf4M/kdoeJLteFwO5x2Frjy2fAI3LvPBTF6/G4
        EN2VOXPH2v8NNS+NlrLtoQGsPMoBA3sWYqxQMwHbL4BtEzSshhEHbDWM3zt580lg8/GCHhHF0bE8i
        S7fzwilkg==;
Received: from [2601:1c0:6280:3f0::9ef4]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iIhL2-0008Mn-CZ; Thu, 10 Oct 2019 22:55:16 +0000
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-rdma@vger.kernel.org" <linux-rdma@vger.kernel.org>
Cc:     Tal Gilboa <talgi@mellanox.com>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Subject: [PATCH] Documentation: networking: add a chapter for the DIM library
Message-ID: <e9345b39-352e-cfc6-7359-9b681cb760e8@infradead.org>
Date:   Thu, 10 Oct 2019 15:55:15 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Randy Dunlap <rdunlap@infradead.org>

Add a Documentation networking chapter for the DIM library.

Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
Cc: Tal Gilboa <talgi@mellanox.com>
Cc: "David S. Miller" <davem@davemloft.net>
Cc: Jakub Kicinski <jakub.kicinski@netronome.com>
Cc: netdev@vger.kernel.org
Cc: linux-rdma@vger.kernel.org
---
 Documentation/networking/index.rst   |    1 +
 Documentation/networking/lib-dim.rst |    6 ++++++
 2 files changed, 7 insertions(+)

--- linux-next-20191010.orig/Documentation/networking/index.rst
+++ linux-next-20191010/Documentation/networking/index.rst
@@ -33,6 +33,7 @@ Contents:
    scaling
    tls
    tls-offload
+   lib-dim
 
 .. only::  subproject and html
 
--- /dev/null
+++ linux-next-20191010/Documentation/networking/lib-dim.rst
@@ -0,0 +1,6 @@
+=====================================================
+Dynamic Interrupt Moderation (DIM) library interfaces
+=====================================================
+
+.. kernel-doc:: include/linux/dim.h
+    :internal:


