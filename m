Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A82A2E01AB
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 21:54:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725875AbgLUUwt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 15:52:49 -0500
Received: from atlmailgw1.ami.com ([63.147.10.40]:45826 "EHLO
        atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725780AbgLUUwt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 15:52:49 -0500
X-AuditID: ac1060b2-a93ff700000017ec-60-5fe10af76df7
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw1.ami.com (Symantec Messaging Gateway) with SMTP id E7.8D.06124.7FA01EF5; Mon, 21 Dec 2020 15:52:07 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 15:52:06 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed, v1 0/1] net: ftgmac100: Change the order of getting MAC address
Date:   Mon, 21 Dec 2020 15:51:56 -0500
Message-ID: <20201221205157.31501-1-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPLMWRmVeSWpSXmKPExsWyRiBhgu4ProfxBu/cLHZd5rCYc76FxeL3
        +b/MFhe29bFaNK8+x2xxedccNotjC8QsTrW8YHHg8LjavovdY8vKm0weFz8eY/bYtKqTzeP8
        jIWMHp83yQWwRXHZpKTmZJalFunbJXBlbDg4iaVgF3PFovWL2RoYHzB1MXJySAiYSOz58Ja5
        i5GLQ0hgF5PErY7DMA6jxJTjN1hAqtgE1CT2bp7DBJIQEVjNKNGz4RcjiMMs0MEoMfXFV3aQ
        KmGBQIkXLd2sXYwcHCwCqhIdzfwgYV4BU4lb334zQqyTl1i94QAzRFxQ4uTMJ2ALmAUkJA6+
        eAEWFxKQlbh16DHUeYoSD359Z53AyDcLScssJC0LGJlWMQolluTkJmbmpJcb6iXmZuol5+du
        YoQE6qYdjC0XzQ8xMnEwHmKU4GBWEuE1k7ofL8SbklhZlVqUH19UmpNafIhRmoNFSZx3lfvR
        eCGB9MSS1OzU1ILUIpgsEwenVAMjH4Oo93OLX67mE+9zhEyc7MDMrOj5U7foTUKEiVKP5tR0
        s4mrWr5Gn2EQcyptN1+hd7vl5ZlbohaL1nYzGwXdjvlyZFauX9I5h84lUVmrBRaelDloJ8K/
        4nHjgujU9qMsefn3XmzQVNB631ZoWKV73ki42//z2r5sIe/4KV/3yOYzN3Q85VFiKc5INNRi
        LipOBADbenNbQgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Reviewer,

Use native MAC address is preferred over other choices, thus change the order
of reading MAC address, try to read it from MAC chip first, if it's not
 availabe, then try to read it from device tree.

Hongwei Zhang (1):
  net: ftgmac100: Change the order of getting MAC address

 drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
2.17.1

