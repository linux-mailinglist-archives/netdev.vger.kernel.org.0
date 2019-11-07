Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39D28F3C3F
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 00:32:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726094AbfKGXcK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 18:32:10 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:50036 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725906AbfKGXcK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 18:32:10 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B53381537B3DB;
        Thu,  7 Nov 2019 15:32:09 -0800 (PST)
Date:   Thu, 07 Nov 2019 15:32:09 -0800 (PST)
Message-Id: <20191107.153209.2003045866627391357.davem@davemloft.net>
To:     ioana.ciornei@nxp.com
Cc:     netdev@vger.kernel.org, andrew@lunn.ch
Subject: Re: [PATCH net-next v2] dpaa2-eth: add ethtool MAC counters
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1573123488-21530-1-git-send-email-ioana.ciornei@nxp.com>
References: <1573123488-21530-1-git-send-email-ioana.ciornei@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 Nov 2019 15:32:09 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Ioana Ciornei <ioana.ciornei@nxp.com>
Date: Thu,  7 Nov 2019 12:44:48 +0200

> When a DPNI is connected to a MAC, export its associated counters.
> Ethtool related functions are added in dpaa2_mac for returning the
> number of counters, their strings and also their values.
> 
> Signed-off-by: Ioana Ciornei <ioana.ciornei@nxp.com>

Applied, thanks.
