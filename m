Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B768F43F50D
	for <lists+netdev@lfdr.de>; Fri, 29 Oct 2021 04:47:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231586AbhJ2Ctl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Oct 2021 22:49:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:42906 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231348AbhJ2Ctk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 28 Oct 2021 22:49:40 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5D7B061157;
        Fri, 29 Oct 2021 02:47:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635475632;
        bh=dZfQK7D+wdREIUuy6ES4GyEtbJr0ZniL0lGKtrURWdc=;
        h=From:To:Cc:Subject:Date:From;
        b=hImlNgpBJ8/A1ahSpjwoqwOqllaLlXZExFswL2lbmHVvvBZEkc+vw3eObn9UGCXNt
         gu/xZoZ7TcrJH0XC73s2U/ujNIDEoC3Q14N5Y+bYEuE6ROiCs0pDlPAdT+ckFhqAZo
         hSu3jr8BODIEkiVDg1rCSJByQh94XkUSXQHpMhYvxJYmUNmH6JQj7A0mD2r3V8Sq6I
         TZ3/LJ4Vg9zzZ0vQwr0iaS9qIJf75kIeM/zvTgo9Lb2QplQ99rh74boM4pvSIEs1zR
         lLAtS4BTxB2NXFX/gTxz8btNswxfIrrFuhFANoC42dgIWUeecshHAYVvOkZalgFodR
         PAJMqEcPJXJqw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/3] arch, misc: use eth_hw_addr_set()
Date:   Thu, 28 Oct 2021 19:47:04 -0700
Message-Id: <20211029024707.316066-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Convert remaining misc drivers to use helpers to write
to netdev->dev_addr.

This is the last set :) :)

Jakub Kicinski (3):
  net: sgi-xp: use eth_hw_addr_set()
  net: um: use eth_hw_addr_set()
  net: xtensa: use eth_hw_addr_set()

 arch/um/drivers/net_kern.c          | 3 ++-
 arch/xtensa/platforms/iss/network.c | 3 ++-
 drivers/misc/sgi-xp/xpnet.c         | 9 ++++++---
 3 files changed, 10 insertions(+), 5 deletions(-)

-- 
2.31.1

