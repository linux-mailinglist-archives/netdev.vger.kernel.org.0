Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9D33E1C9FB5
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 02:36:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726712AbgEHAgn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 May 2020 20:36:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59246 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726470AbgEHAgn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 May 2020 20:36:43 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6E13AC05BD43;
        Thu,  7 May 2020 17:36:43 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EF6C111939C2B;
        Thu,  7 May 2020 17:36:42 -0700 (PDT)
Date:   Thu, 07 May 2020 17:36:42 -0700 (PDT)
Message-Id: <20200507.173642.1807000659009589804.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     claudiu.manoil@nxp.com, Po.Liu@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] enetc: Fix use after free in
 stream_filter_unref()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505204721.GA51853@mwanda>
References: <20200505204721.GA51853@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 07 May 2020 17:36:43 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Tue, 5 May 2020 23:47:21 +0300

> This code frees "sfi" and then dereferences it on the next line.
> 
> Fixes: 888ae5a3952b ("net: enetc: add tc flower psfp offload driver")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

This was fixed in another patch by using the local variable 'index'.
