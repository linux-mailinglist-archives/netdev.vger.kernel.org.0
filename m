Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2BC9342CA3
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 18:49:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408424AbfFLQtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 Jun 2019 12:49:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37960 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405826AbfFLQtK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 12 Jun 2019 12:49:10 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0826415224152;
        Wed, 12 Jun 2019 09:49:08 -0700 (PDT)
Date:   Wed, 12 Jun 2019 09:49:08 -0700 (PDT)
Message-Id: <20190612.094908.1957141510166169801.davem@davemloft.net>
To:     horms@verge.net.au
Cc:     fabrizio.castro@bp.renesas.com, wg@grandegger.com,
        mkl@pengutronix.de, robh+dt@kernel.org, mark.rutland@arm.com,
        linux-can@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        geert+renesas@glider.be, Chris.Paterson2@renesas.com,
        biju.das@bp.renesas.com, linux-renesas-soc@vger.kernel.org
Subject: Re: [PATCH repost 0/5] Repost CAN and CANFD dt-bindings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190612122020.sgp5q427ilh6bbbg@verge.net.au>
References: <1557429622-31676-1-git-send-email-fabrizio.castro@bp.renesas.com>
        <TY1PR01MB1770D2AAF2ED748575CA4CBFC0100@TY1PR01MB1770.jpnprd01.prod.outlook.com>
        <20190612122020.sgp5q427ilh6bbbg@verge.net.au>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 12 Jun 2019 09:49:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Simon Horman <horms@verge.net.au>
Date: Wed, 12 Jun 2019 14:20:20 +0200

> are you comfortable with me taking these patches
> through the renesas tree? Or perhaps should they be reposted
> to you for inclusion in net-next?
> 
> They have been stuck for a long time now.

They can go through the renesas tree, no problem.

Acked-by: David S. Miller <davem@davemloft.net>
