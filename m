Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 17CAF2DFEE7
	for <lists+netdev@lfdr.de>; Mon, 21 Dec 2020 18:20:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726352AbgLURR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Dec 2020 12:17:58 -0500
Received: from atlmailgw2.ami.com ([63.147.10.42]:63858 "EHLO
        atlmailgw2.ami.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725826AbgLURR6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Dec 2020 12:17:58 -0500
X-Greylist: delayed 942 seconds by postgrey-1.27 at vger.kernel.org; Mon, 21 Dec 2020 12:17:41 EST
X-AuditID: ac10606f-247ff70000001934-bf-5fe0d4e86a24
Received: from atlms1.us.megatrends.com (atlms1.us.megatrends.com [172.16.96.144])
        (using TLS with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (Client did not present a certificate)
        by atlmailgw2.ami.com (Symantec Messaging Gateway) with SMTP id E8.BF.06452.8E4D0EF5; Mon, 21 Dec 2020 12:01:28 -0500 (EST)
Received: from ami-us-wk.us.megatrends.com (172.16.98.207) by
 atlms1.us.megatrends.com (172.16.96.144) with Microsoft SMTP Server (TLS) id
 14.3.468.0; Mon, 21 Dec 2020 12:01:27 -0500
From:   Hongwei Zhang <hongweiz@ami.com>
To:     <linux-aspeed@lists.ozlabs.org>, <linux-kernel@vger.kernel.org>,
        <openbmc@lists.ozlabs.org>, Jakub Kicinski <kuba@kernel.org>,
        David S Miller <davem@davemloft.net>
CC:     Hongwei Zhang <hongweiz@ami.com>, netdev <netdev@vger.kernel.org>,
        Joel Stanley <joel@jms.id.au>, Andrew Jeffery <andrew@aj.id.au>
Subject: [Aspeed,ncsi-rx, v1 0/1] net: ftgmac100: Fix AST2600EVB NCSI RX issue
Date:   Mon, 21 Dec 2020 12:00:47 -0500
Message-ID: <20201221170048.29821-3-hongweiz@ami.com>
X-Mailer: git-send-email 2.17.1
References: <20201215192323.24359-1-hongweiz@ami.com>
In-Reply-To: <20201215192323.24359-1-hongweiz@ami.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [172.16.98.207]
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrOLMWRmVeSWpSXmKPExsWyRiBhgu6LKw/iDc4sELbYdZnDYs75FhaL
        3+f/Mltc2NbHatG8+hyzxeVdc9gsji0QszjV8oLFgcPjavsudo8tK28yeVz8eIzZY9OqTjaP
        8zMWMnp83iQXwBbFZZOSmpNZllqkb5fAlfHvXVlBP1vFmUnfWBoYn7J0MXJySAiYSFy89h7I
        5uIQEtjFJLHt9XVmKIdR4t6CZrAqNgE1ib2b5zCBJEQEVjNK9Gz4xQjiMAt0MEpMffGVHaRK
        WMBP4uSxo6wgNouAqkT/rP1g3bwCphJPfvyG2icvsXrDAWYQWwgo3rrvHdBUDg5OATOJPafk
        IMoFJU7OfAJWziwgIXHwxQuoclmJW4ceM0GMUZR48Os76wRGgVlIWmYhaVnAyLSKUSixJCc3
        MTMnvdxILzE3Uy85P3cTIySw83cwfvxofoiRiYPxEKMEB7OSCK+Z1P14Id6UxMqq1KL8+KLS
        nNTiQ4zSHCxK4ryr3I/GCwmkJ5akZqemFqQWwWSZODilGhijut9auFvn3HosOiHlqbhm2Ja5
        1TKffX3y/i89trqyOfRD+P9fyxcZrvORnfos4WG4ZlSH1V2NGd/eX2dLynVJcF5W8v/ePqYD
        a0w5khLVb0mnbaw7myT0o5TnZJUV/411O3lCxe5ILTxYpZN5Iz9sCkuXcYP3ysIzG1dITTR5
        vd4+MJRLL0KJpTgj0VCLuag4EQAtGGRsWgIAAA==
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Andrew,

> From:	Andrew Jeffery <andrew@aj.id.au>
> 
> > Fix AST2600 EVB NCSI RX timeout issue by removing 
> > FTGMAC100_RXDES0_RX_ERR bit from macro RXDES0_ANY_ERROR.
> 
> But why? What is wrong with the EVB that this change resolves? Which revision of the EVB?
> 
> The change affects all designs using the MAC, not just the AST2600 EVB. Why is this patch an 
> appropriate course of action? Can we not add a quirk targeting the specific board (e.g. a devicetree 
> property)?

You are correct. I was in a rush and didn't put this patch under whole picture 
of the driver it affected. I revised the cover letter with more information, also
use a configurable flag to isolate the change. please review the new approach.

> 
> Andrew
> 
Thanks,
--Hongwei

