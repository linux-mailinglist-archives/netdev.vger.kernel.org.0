Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37A802E0F3B
	for <lists+netdev@lfdr.de>; Tue, 22 Dec 2020 21:17:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727404AbgLVUP2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Dec 2020 15:15:28 -0500
Received: from atlmailgw2.ami.com ([63.147.10.42]:46440 "EHLO
        atlmailgw2.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725782AbgLVUP2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Dec 2020 15:15:28 -0500
X-AuditID: ac10606f-231ff70000001934-4f-5fe253b6a921
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw2.ami.com (Symantec Messaging Gateway) with SMTP id F1.71.06452.6B352EF5; Tue, 22 Dec 2020 15:14:47 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Tue, 22 Dec 2020 15:14:44 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed, v2 0/2] net: ftgmac100: Change the order of getting MAC address
Date:   Tue, 22 Dec 2020 15:14:35 -0500
Message-ID: <20201222201437.5588-1-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
In-Reply-To: <20201221205157.31501-2-hongweiz@ami.com>
References: <20201221205157.31501-2-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrMLMWRmVeSWpSXmKPExsWyRiBhgu724EfxBpNvs1vsusxhMed8C4vF
        ovczWC1+n//LbHFhWx+rRfPqc8wWl3fNYbM4tkDM4lTLCxYHTo+r7bvYPbasvMnksXPWXXaP
        ix+PMXtsWtXJ5nF+xkJGj8+b5ALYo7hsUlJzMstSi/TtErgyDtw/wVjwkqXi+LE5TA2Mn5m7
        GDk5JARMJLpnrWfqYuTiEBLYxSTx5uRsGIdRYte79WwgVWwCahJ7N88BS4gIXGaUuNH1hBnE
        YRboYJSY+uIrO0iVsECgxNMr51hBbBYBVYlX9yFsXqAdJ56tY4HYJy+xesMBsN2cAmYSF7pn
        gcWFBEwlVvz9yAxRLyhxcuYTsDizgITEwRcvmCFqZCVuHXrMBDFHUeLBr++sExgFZiFpmYWk
        ZQEj0ypGocSSnNzEzJz0ciO9xNxMveT83E2MkIDP38H48aP5IUYmDsZDjBIczEoivGZS9+OF
        eFMSK6tSi/Lji0pzUosPMUpzsCiJ865yPxovJJCeWJKanZpakFoEk2Xi4JRqYHQyTb9XNPPT
        jnn/ZB8G/oqzndBaVXb8spzp/ToRv7TSjbH36ibdju30W2Tt0fPxzrKsWbIfdXQWyPrs/TeV
        d+92gb+pDOsYduy68HXRz6YKf7c3HpaZHN7xd/YstIjclM33/7KW6NfTT2ZE5SfcmqlQckVt
        Z/aR54mhPxcxZ7b0PZ7nHzRx0wslluKMREMt5qLiRAAUA96kZgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Dear Reviewer,

Use native MAC address is preferred over other choices, thus change the order
of reading MAC address, try to read it from MAC chip first, if it's not
 availabe, then try to read it from device tree.

Thanks,
--Hongwei

Changelog:
v2:
- Corrected comments in the patch

v1: https://patchwork.ozlabs.org/project/linux-aspeed/list/?series=221576
- Initial submission

Hongwei Zhang (1):
  net: ftgmac100: Change the order of getting MAC address

 drivers/net/ethernet/faraday/ftgmac100.c | 22 +++++++++++++---------
 1 file changed, 13 insertions(+), 9 deletions(-)

-- 
2.17.1

