Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908A51C0C94
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:27:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728193AbgEAD0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:26:50 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41408 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728099AbgEAD0u (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:26:50 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7630DC035494;
        Thu, 30 Apr 2020 20:26:50 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 156CE12772F77;
        Thu, 30 Apr 2020 20:26:50 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:26:49 -0700 (PDT)
Message-Id: <20200430.202649.2131870872835136856.davem@davemloft.net>
To:     aishwaryarj100@gmail.com
Cc:     madalin.bucur@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] dpaa_eth: Fix comparing pointer to 0
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200427103230.4776-1-aishwaryarj100@gmail.com>
References: <20200427103230.4776-1-aishwaryarj100@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:26:50 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>
Date: Mon, 27 Apr 2020 16:02:30 +0530

> Fixes coccicheck warning:
> ./drivers/net/ethernet/freescale/dpaa/dpaa_eth.c:2110:30-31:
> WARNING comparing pointer to 0
> 
> Avoid pointer type value compared to 0.
> 
> Signed-off-by: Aishwarya Ramakrishnan <aishwaryarj100@gmail.com>

Applied, thanks.
