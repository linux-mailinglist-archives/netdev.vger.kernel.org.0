Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1472732605F
	for <lists+netdev@lfdr.de>; Fri, 26 Feb 2021 10:44:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230427AbhBZJoM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Feb 2021 04:44:12 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:45240 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S230083AbhBZJoC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 26 Feb 2021 04:44:02 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 635CE7A21;
        Fri, 26 Feb 2021 01:43:10 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 635CE7A21
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1614332590;
        bh=e1VnG3XpZa8kzq2qCuJLld9HPqfq5AJd4B2AuEtlRyU=;
        h=From:To:Cc:Subject:Date:From;
        b=dnSI5rgD4VwRkRudPcuhf7ZR3DvGfcnlegfr8kEWPLbzQZHEhRHcZq4795Bs09yms
         8TrQ4rcPBKQI6JUqUjDEFiOhsrbI0M5NBqHgb1yDzwCv1FHyygie8VSr5xEcxhWMHk
         43amO9UgLeQECu+2d6mH6AokLIfaJj3bem6JbJFg=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/2] bnxt_en: Error recovery bug fixes.
Date:   Fri, 26 Feb 2021 04:43:08 -0500
Message-Id: <1614332590-17865-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two error recovery related bug fixes for 2 corner cases.

Please queue patch #2 for -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: reliably allocate IRQ table on reset to avoid crash

Vasundhara Volam (1):
  bnxt_en: Fix race between firmware reset and driver remove.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 17 +++++++++++++++--
 1 file changed, 15 insertions(+), 2 deletions(-)

-- 
2.18.1

