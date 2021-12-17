Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A01A4478116
	for <lists+netdev@lfdr.de>; Fri, 17 Dec 2021 01:08:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229627AbhLQAIf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Dec 2021 19:08:35 -0500
Received: from mx3.wp.pl ([212.77.101.9]:33086 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229600AbhLQAIe (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Dec 2021 19:08:34 -0500
Received: (wp-smtpd smtp.wp.pl 6874 invoked from network); 17 Dec 2021 01:08:30 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1639699710; bh=z87+zKOvNkETmRkuO/mzBu/FQqdESHMB5S8NqdVjEy4=;
          h=From:To:Subject;
          b=ZGxmhbRmEaxh8xlghkfHt5Zv4tikoMy1u/tHGLaku3Zm/iaII3KtZ19Nut19zMZcE
           ekTPcQxlbVWY6DxbPgabN8yVeG2icc56gXCm+77kYVyOR0x838as/TK3BPSzolMDbA
           rZecNjU8pc+/Z80xPSbEYFnqX0CLYoMgs4PnABOg=
Received: from riviera.nat.ds.pw.edu.pl (HELO LAPTOP-OLEK.lan) (olek2@wp.pl@[194.29.137.1])
          (envelope-sender <olek2@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <hauke@hauke-m.de>; 17 Dec 2021 01:08:30 +0100
From:   Aleksander Jan Bajkowski <olek2@wp.pl>
To:     hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        olek2@wp.pl, netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/1] net: lantiq_xrx200: increase buffer reservation
Date:   Fri, 17 Dec 2021 01:07:39 +0100
Message-Id: <20211217000740.683089-1-olek2@wp.pl>
X-Mailer: git-send-email 2.30.2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
X-WP-MailID: 6cd76d0e47cdbff75baa8b6cc1d154b3
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [8cMU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Changes in v3:
 - Removed -1 from the buffer size calculation
 - Removed ETH_FCS_LEN from the buffer size calculation
 - Writing rounded buffer size to descriptor 

Changes in v2:
 - Removed the inline keyword

Aleksander Jan Bajkowski (1):
  net: lantiq_xrx200: increase buffer reservation

 drivers/net/ethernet/lantiq_xrx200.c | 34 ++++++++++++++++++++--------
 1 file changed, 24 insertions(+), 10 deletions(-)

-- 
2.30.2

