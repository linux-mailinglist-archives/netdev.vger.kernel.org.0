Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54196110AF
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 02:35:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726202AbfEBAf1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 20:35:27 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:42776 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726126AbfEBAf1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 May 2019 20:35:27 -0400
Received: from localhost (adsl-173-228-226-134.prtc.net [173.228.226.134])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7FB0913C55A9D;
        Wed,  1 May 2019 17:35:25 -0700 (PDT)
Date:   Wed, 01 May 2019 20:35:22 -0400 (EDT)
Message-Id: <20190501.203522.1577716429222042609.davem@davemloft.net>
To:     michal.kalderon@marvell.com
Cc:     ariel.elior@marvell.com, jgg@ziepe.ca, dledford@redhat.com,
        linux-rdma@vger.kernel.org, netdev@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: [PATCH net-next 07/10] qed*: Add iWARP 100g support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190501095722.6902-8-michal.kalderon@marvell.com>
References: <20190501095722.6902-1-michal.kalderon@marvell.com>
        <20190501095722.6902-8-michal.kalderon@marvell.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 01 May 2019 17:35:26 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michal Kalderon <michal.kalderon@marvell.com>
Date: Wed, 1 May 2019 12:57:19 +0300

> diff --git a/drivers/infiniband/hw/qedr/main.c b/drivers/infiniband/hw/qedr/main.c
> index d93c8a893a89..8bc6775abb79 100644
> --- a/drivers/infiniband/hw/qedr/main.c
> +++ b/drivers/infiniband/hw/qedr/main.c
> @@ -52,6 +52,10 @@ MODULE_DESCRIPTION("QLogic 40G/100G ROCE Driver");
>  MODULE_AUTHOR("QLogic Corporation");
>  MODULE_LICENSE("Dual BSD/GPL");
>  
> +static uint iwarp_cmt;
> +module_param(iwarp_cmt, uint, 0444);
> +MODULE_PARM_DESC(iwarp_cmt, " iWARP: Support CMT mode. 0 - Disabled, 1 - Enabled. Default: Disabled");
> +

Sorry no, this is totally beneath us.
