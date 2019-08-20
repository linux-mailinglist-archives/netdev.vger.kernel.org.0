Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A0C5595379
	for <lists+netdev@lfdr.de>; Tue, 20 Aug 2019 03:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728920AbfHTBfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Aug 2019 21:35:53 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:39376 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728627AbfHTBfx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Aug 2019 21:35:53 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DB90E14A872EE;
        Mon, 19 Aug 2019 18:35:52 -0700 (PDT)
Date:   Mon, 19 Aug 2019 18:35:52 -0700 (PDT)
Message-Id: <20190819.183552.1819321784691078344.davem@davemloft.net>
To:     marco.hartmann@nxp.com
Cc:     fugang.duan@nxp.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, christian.herber@nxp.com
Subject: Re: [PATCH net-next 1/1] fec: add C45 MDIO read/write support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1566234659-7164-2-git-send-email-marco.hartmann@nxp.com>
References: <1566234659-7164-1-git-send-email-marco.hartmann@nxp.com>
        <1566234659-7164-2-git-send-email-marco.hartmann@nxp.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 19 Aug 2019 18:35:53 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Marco Hartmann <marco.hartmann@nxp.com>
Date: Mon, 19 Aug 2019 17:11:14 +0000

> @@ -1767,7 +1770,7 @@ static int fec_enet_mdio_read(struct mii_bus *bus, int mii_id, int regnum)
>  	struct fec_enet_private *fep = bus->priv;
>  	struct device *dev = &fep->pdev->dev;
>  	unsigned long time_left;
> -	int ret = 0;
> +	int ret = 0, frame_start, frame_addr, frame_op;
>  

Please retain the reverse christmas tree ordering of local variables
here, thank you.
