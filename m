Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 540A714173
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 19:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727925AbfEER3y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 13:29:54 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52914 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727901AbfEER3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 13:29:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EC47F14DA6461;
        Sun,  5 May 2019 10:29:51 -0700 (PDT)
Date:   Sun, 05 May 2019 10:29:51 -0700 (PDT)
Message-Id: <20190505.102951.1109077189450790567.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     esben@geanix.com, michal.simek@xilinx.com, andrew@lunn.ch,
        netdev@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH 2/2 net-next] net: ll_temac: remove an unnecessary
 condition
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190503125051.GG29695@mwanda>
References: <20190503125024.GF29695@mwanda>
        <20190503125051.GG29695@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 10:29:52 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Fri, 3 May 2019 15:50:51 +0300

> The "pdata->mdio_bus_id" is unsigned so this condition is always true.
> This patch just removes it.
> 
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied.
