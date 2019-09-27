Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51DD9C0103
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:21:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726668AbfI0IVK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:21:10 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57186 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0IVK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:21:10 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4F9BE14DE97B2;
        Fri, 27 Sep 2019 01:21:08 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:21:06 +0200 (CEST)
Message-Id: <20190927.102106.1025434748772068784.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     mdf@kernel.org, andrew@lunn.ch, alex.williams@ni.com,
        mcgrof@kernel.org, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] net: nixge: Fix a signedness bug in nixge_probe()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925110524.GP3264@mwanda>
References: <20190925110524.GP3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:21:09 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 14:05:24 +0300

> The "priv->phy_mode" is an enum and in this context GCC will treat it
> as an unsigned int so it can never be less than zero.
> 
> Fixes: 492caffa8a1a ("net: ethernet: nixge: Add support for National Instruments XGE netdev")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
