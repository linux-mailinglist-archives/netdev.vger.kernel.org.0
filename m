Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F33A613352C
	for <lists+netdev@lfdr.de>; Tue,  7 Jan 2020 22:47:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727289AbgAGVrN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Jan 2020 16:47:13 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:38504 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726594AbgAGVrM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Jan 2020 16:47:12 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EA2F115A16BA1;
        Tue,  7 Jan 2020 13:47:11 -0800 (PST)
Date:   Tue, 07 Jan 2020 13:47:11 -0800 (PST)
Message-Id: <20200107.134711.1860200595614980441.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     claudiu.manoil@nxp.com, po.liu@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: Fix an off by one in
 enetc_setup_tc_txtime()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200107131143.jqytedvewberqp5c@kili.mountain>
References: <20200107131143.jqytedvewberqp5c@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 07 Jan 2020 13:47:12 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 7 Jan 2020 16:11:43 +0300

> The priv->tx_ring[] has 16 elements but only priv->num_tx_rings are
> set up, the rest are NULL.  This ">" comparison should be ">=" to avoid
> a potential crash.
> 
> Fixes: 0d08c9ec7d6e ("enetc: add support time specific departure base on the qos etf")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
