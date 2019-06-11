Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E5CC83C491
	for <lists+netdev@lfdr.de>; Tue, 11 Jun 2019 08:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404142AbfFKG5Z (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 02:57:25 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:56619 "EHLO
        relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404056AbfFKG5Z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 11 Jun 2019 02:57:25 -0400
X-Originating-IP: 90.88.159.246
Received: from bootlin.com (aaubervilliers-681-1-40-246.w90-88.abo.wanadoo.fr [90.88.159.246])
        (Authenticated sender: maxime.chevallier@bootlin.com)
        by relay6-d.mail.gandi.net (Postfix) with ESMTPSA id 54C48C0004;
        Tue, 11 Jun 2019 06:57:18 +0000 (UTC)
Date:   Tue, 11 Jun 2019 08:57:24 +0200
From:   Maxime Chevallier <maxime.chevallier@bootlin.com>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        antoine.tenart@bootlin.com, thomas.petazzoni@bootlin.com,
        gregory.clement@bootlin.com, miquel.raynal@bootlin.com,
        nadavh@marvell.com, stefanc@marvell.com, mw@semihalf.com,
        yuric@marvell.com
Subject: Re: [PATCH net 1/2] net: mvpp2: prs: Fix parser range for VID
 filtering
Message-ID: <20190611085724.715cbfc7@bootlin.com>
In-Reply-To: <20190610.092300.1686623862696326754.davem@davemloft.net>
References: <20190610135008.8077-1-maxime.chevallier@bootlin.com>
        <20190610.092300.1686623862696326754.davem@davemloft.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello David,

On Mon, 10 Jun 2019 09:23:00 -0700 (PDT)
David Miller <davem@davemloft.net> wrote:

>Please start providing proper header postings with each and every patch
>series, explaining at a high level what the patch series is doing, how
>it is doing it, and why it is doing it that way.

Sure, I'll resend with a proper cover-letter, sorry about that.

Thanks,

Maxime
