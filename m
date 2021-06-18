Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087863AC319
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 08:07:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232800AbhFRGJi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 02:09:38 -0400
Received: from lpdvacalvio01.broadcom.com ([192.19.229.182]:57212 "EHLO
        relay.smtp-ext.broadcom.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S232250AbhFRGJg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 02:09:36 -0400
Received: from localhost.swdvt.lab.broadcom.net (dhcp-10-13-253-90.swdvt.lab.broadcom.net [10.13.253.90])
        by relay.smtp-ext.broadcom.com (Postfix) with ESMTP id AF9B13D8EE;
        Thu, 17 Jun 2021 23:07:27 -0700 (PDT)
DKIM-Filter: OpenDKIM Filter v2.11.0 relay.smtp-ext.broadcom.com AF9B13D8EE
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=broadcom.com;
        s=dkimrelay; t=1623996447;
        bh=V3pxvwbaDdBqr2Q/yMaW2jCRaPP5k/vtOBxuHeWvcqI=;
        h=From:To:Cc:Subject:Date:From;
        b=gBV9gnsb5DS5RjemQ3cASSppnehR+ULUp+mnVrNnYlDpCsjrwmM2EqjLUYO/SpSCv
         POFuVRVMXrAhSvzDuiKhT+VnWd7QP8w8NZTMXXKyb4kSwimtgUYKr8fN+p8yRCtVQd
         qH4BzStlfkJj8HAJPW1wn0wNzp5qqDCrbgCnuM+M=
From:   Michael Chan <michael.chan@broadcom.com>
To:     davem@davemloft.net
Cc:     netdev@vger.kernel.org, kuba@kernel.org, gospo@broadcom.com
Subject: [PATCH net 0/3] bnxt_en: Bug fixes
Date:   Fri, 18 Jun 2021 02:07:24 -0400
Message-Id: <1623996447-28958-1-git-send-email-michael.chan@broadcom.com>
X-Mailer: git-send-email 1.8.3.1
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This patchset includes 3 small bug fixes to reinitialize PHY capabilities
after firmware reset, setup the chip's internal TQM fastpath ring
backing memory properly for RoCE traffic, and to free ethtool related
memory if driver probe fails.

Michael Chan (1):
  bnxt_en: Rediscover PHY capabilities after firmware reset

Rukhsana Ansari (1):
  bnxt_en: Fix TQM fastpath ring backing store computation

Somnath Kotur (1):
  bnxt_en: Call bnxt_ethtool_free() in bnxt_init_one() error path

 drivers/net/ethernet/broadcom/bnxt/bnxt.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

-- 
2.18.1

