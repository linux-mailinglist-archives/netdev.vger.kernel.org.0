Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84EE72DFEE8
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726363AbgLURSE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 12:18:04 -0500
Received: from atlmailgw1.ami.com ([63.147.10.40]:45050 "EHLO
        atlmailgw1.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725930AbgLURSD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 12:18:03 -0500
X-AuditID: ac1060b2-a7dff700000017ec-60-5fe0d4eaa98b
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw1.ami.com (Symantec Messaging Gateway) with SMTP id 6F.3D.06124.AE4D0EF5; Mon, 21 Dec 2020 12:01:30 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 12:01:30 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed,ncsi-rx, v1] Answer to initial submission
Date:   Mon, 21 Dec 2020 12:00:48 -0500
Message-ID: <20201221170048.29821-4-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
References: <20201215192323.24359-1-hongweiz@ami.com>
In-Reply-To: <20201215192323.24359-1-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRiBhgu6rKw/iDRpfm1jsusxhMed8C4vF
        7/N/mS0ubOtjtWhefY7Z4vKuOWwWxxaIWZxqecHiwOFxtX0Xu8eWlTeZPC5+PMbssWlVJ5vH
        +RkLGT0+b5ILYIvisklJzcksSy3St0vgyvh5Zz5TwSaWis4ZC5kaGLcxdzFyckgImEi8OPqB
        BcQWEtjFJLF/VmkXIxeIzSgx/81RVpAEm4CaxN7Nc5hAEiICqxklejb8YgRxmAU6GCWmvvjK
        DlIlLGAlMf3aH0YQm0VAVWLBm3VgY3kFTCVuLH3PCLFOXmL1hgPMEOtMJVr3vQOaysHBKWAm
        seeUHES5oMTJmU/AWpkFJCQOvngBVS4rcevQYyaIMYoSD359Z53AKDALScssJC0LGJlWMQol
        luTkJmbmpJcb6iXmZuol5+duYoQE9qYdjC0XzQ8xMnEwHmKU4GBWEuE1k7ofL8SbklhZlVqU
        H19UmpNafIhRmoNFSZx3lfvReCGB9MSS1OzU1ILUIpgsEwenVAPjkwTpC/7H7213uXBX/8rM
        /n7PCxOkwv1P2uf83HVLv+wim81tH7lWlqhWz/I7iWuDYh5lLi+/pGr3cUZBwuJHJx337Hw2
        XTl/YvPLBfdulDR7Plzgn27x83dPR9Jip2/2z74fM2Aw8EwQiU94P8l40TpLtu/39b4aXM3r
        KA55u19fijH9/ZFbSizFGYmGWsxFxYkATTfua1oCAAA=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Jakub,

> From:	Jakub Kicinski <kuba@kernel.org>
> 
> > ... 
> > Signed-off-by: Hongwei Zhang <hongweiz@ami.com>
> 
> Thanks for the patch. Please repost CCing the netdev mailing list so it can be merged to the networking 
> tree (which I assume is your intent).
> Please also include a Fixes tag pointing to the commit where the timeout issue started (even if it's the 
> first commit of the driver).
> 
I updated the cc list and cover letter accordingly, also addressed
Andrew's question. please review.

Thanks,
--Hongwei

-- 
2.17.1

