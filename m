Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 51D69C009B
	for <lists+netdev@lfdr.de>; Fri, 27 Sep 2019 10:04:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726771AbfI0IEP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 Sep 2019 04:04:15 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:57022 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725804AbfI0IEP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 Sep 2019 04:04:15 -0400
Received: from localhost (unknown [65.39.69.237])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0200E14DD9E5A;
        Fri, 27 Sep 2019 01:04:13 -0700 (PDT)
Date:   Fri, 27 Sep 2019 10:04:12 +0200 (CEST)
Message-Id: <20190927.100412.283048791655860337.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     claudiu.manoil@nxp.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] enetc: Fix a signedness bug in enetc_of_get_phy()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190925105714.GF3264@mwanda>
References: <20190925105714.GF3264@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 27 Sep 2019 01:04:14 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 25 Sep 2019 13:57:14 +0300

> The "priv->if_mode" is type phy_interface_t which is an enum.  In this
> context GCC will treat the enum as an unsigned int so this error
> handling is never triggered.
> 
> Fixes: d4fd0404c1c9 ("enetc: Introduce basic PF and VF ENETC ethernet drivers")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
