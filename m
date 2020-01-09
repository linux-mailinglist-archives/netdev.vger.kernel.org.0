Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E22FC13503A
	for <lists+netdev@lfdr.de>; Thu,  9 Jan 2020 01:03:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727308AbgAIAD5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 19:03:57 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:49984 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726438AbgAIAD4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 19:03:56 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E1D6B15371C53;
        Wed,  8 Jan 2020 16:03:55 -0800 (PST)
Date:   Wed, 08 Jan 2020 16:03:55 -0800 (PST)
Message-Id: <20200108.160355.2056120405467352285.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     mkubecek@suse.cz, f.fainelli@gmail.com, andrew@lunn.ch,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net-next] ethtool: fix a memory leak in
 ethnl_default_start()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200108053947.776s3sp3op6v7a6r@kili.mountain>
References: <20200108053947.776s3sp3op6v7a6r@kili.mountain>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 16:03:56 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 8 Jan 2020 08:39:48 +0300

> If ethnl_default_parse() fails then we need to free a couple
> memory allocations before returning.
> 
> Fixes: 728480f12442 ("ethtool: default handlers for GET requests")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
