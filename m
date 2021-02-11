Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D4F5A3185A7
	for <lists+netdev@lfdr.de>; Thu, 11 Feb 2021 08:27:31 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229713AbhBKHZ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 02:25:29 -0500
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:47328 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229533AbhBKHZP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 02:25:15 -0500
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id D42427DC5;
        Wed, 10 Feb 2021 23:24:24 -0800 (PST)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com D42427DC5
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1613028264;
        bh=O7+2364f3DnKLIpNyFa4jcF1lcoMOci8N0Nay6h/t/0=;
        h=From:To:Cc:Subject:Date:From;
        b=gtId3xYbW30eRKFJyxc0u5NZuXwp8JWjuePzc0ERzAQjknUzg1TRC8S6QwJ9obxZU
         bo9r1ryNT3YbLHysCsL04Cimb/9JzU8m0OuVcMVvsueM9wZfmS4oT4M4sW1DOBe1hn
         GQ3wU4q0DL0yag4XP1FNmkfk2Csap7iukMduSmgA=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/2] bnxt_en: 2 bug fixes.
Date:   Thu, 11 Feb 2021 02:24:22 -0500
Message-Id: <1613028264-20306-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Two unrelated fixes.  The first one fixes intermittent false TX timeouts
during ring reconfigurations.  The second one fixes a formatting
discrepancy between the stored and the running FW versions.

Please also queue these for -stable.  Thanks.

Edwin Peer (1):
  bnxt_en: reverse order of TX disable and carrier off

Vasundhara Volam (1):
  bnxt_en: Fix devlink info's stored fw.psid version format.

 drivers/net/ethernet/broadcom/bnxt/bnxt.c         | 3 ++-
 drivers/net/ethernet/broadcom/bnxt/bnxt_devlink.c | 4 ++--
 2 files changed, 4 insertions(+), 3 deletions(-)

-- 
2.18.1

