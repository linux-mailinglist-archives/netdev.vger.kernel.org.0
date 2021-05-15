Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2ED9C38168C
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 09:25:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231529AbhEOH0j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 03:26:39 -0400
Received: from relay.smtp-ext.broadcom.com ([192.19.11.229]:59972 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229943AbhEOH0g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 15 May 2021 03:26:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id 156822E5D3;
        Sat, 15 May 2021 00:25:20 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com 156822E5D3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1621063520;
        bh=kDwsIliRLX96896lRltj7Qz69rMBuocFAFefRfGZ0SQ=;
        h=From:To:Cc:Subject:Date:From;
        b=DZAQO86MIpszk8SgAkVJfxAmL/VVSfcYs9hm4Q2v55xrwEPNaoDWUUOGGuk+Wpo4J
         S/38ezR8RvA4QHENLWDeJ95Esu9bSHVdRXet0lBz1vjTvkhz+wHtB1NLTAzewYeHHJ
         hZdmLNz7Au6fzWTiH/7i8e+kWVGXlhYdP2WnqdoQ=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/2] bnxt_en: 2 bug fixes.
Date:   Sat, 15 May 2021 03:25:17 -0400
Message-Id: <1621063519-7764-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

The first one fixes a bug to properly identify some recently added HyperV
device IDs.  The second one fixes device context memory set up on systems
with 64K page size.

Please queue these for -stable as well.  Thanks.

Andy Gospodarek (1):
  bnxt_en: Include new P5 HV definition in VF check.

Michael Chan (1):
  bnxt_en: Fix context memory setup for 64K page size.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 12 +++---------
 drivers/net/ethernet/broadcom/bnxt/bnxt.h | 10 ++++++++++
 2 files changed, 13 insertions(+), 9 deletions(-)

-- 
2.18.1

