Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1A80C437C2C
	for <lists+netdev@lfdr.de>; Fri, 22 Oct 2021 19:42:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233648AbhJVRoz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Oct 2021 13:44:55 -0400
Received: from mail.kernel.org ([198.145.29.99]:46412 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233538AbhJVRoz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 22 Oct 2021 13:44:55 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9143861037;
        Fri, 22 Oct 2021 17:42:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1634924557;
        bh=yL4tnrPPnh+3ueFbEtazjR6LwrhamC6ZzSwBcviuphs=;
        h=From:To:Cc:Subject:Date:From;
        b=LdP5ITdrPlOATgr/I9JpwW3U/AzZOilvgAfQEFW2ZawY7vF4R0pShCIn6pg5H3JMe
         yOjMLMxEuLgN2+FYNJ1Kg58eK70yvjnlyunbH2r5Ep+uBq1UuVaDRXgDKU8K4G533r
         e/o+zbM64xQMSC6yNOPVaMp9qEm1OfdMarcaZibVmpKO87NPp7+rYsWMCW7crynQ9z
         yAmIMrXC29sGilajKsSWofX518AGuFB+e9bzpecGurpgci5pqPpxu3B5kbru7gD5yT
         LbaaHTeN3pvxvYmO2ka4Dix1RojuhfEWgn7W/lmxdquSSlriYkkXhcd4MjYSebsJf1
         5GEHTpXs9E/cw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        marcel@holtmann.org, Jakub Kicinski <kuba@kernel.org>
Subject: [PATCH net-next 0/2] bluetooth: don't write directly to netdev->dev_addr
Date:   Fri, 22 Oct 2021 10:42:30 -0700
Message-Id: <20211022174232.2510917-1-kuba@kernel.org>
X-Mailer: git-send-email 2.31.1
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The usual conversions.

These are intended to be merged to net-next directly,
because bluetooth tree is missing one of the pre-req
changes at the moment.

Jakub Kicinski (2):
  bluetooth: use eth_hw_addr_set()
  bluetooth: use dev_addr_set()

 net/bluetooth/6lowpan.c   | 4 +++-
 net/bluetooth/bnep/core.c | 2 +-
 2 files changed, 4 insertions(+), 2 deletions(-)

-- 
2.31.1

