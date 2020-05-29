Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 57F431E8C36
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 01:41:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728667AbgE2XlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 May 2020 19:41:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42050 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728406AbgE2XlI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 May 2020 19:41:08 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DE424C03E969;
        Fri, 29 May 2020 16:41:08 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7425712868182;
        Fri, 29 May 2020 16:41:08 -0700 (PDT)
Date:   Fri, 29 May 2020 16:41:07 -0700 (PDT)
Message-Id: <20200529.164107.1817677145426311890.davem@davemloft.net>
To:     rao.shoaib@oracle.com
Cc:     netdev@vger.kernel.org, linux-rdma@vger.kernel.org,
        somasundaram.krishnasamy@oracle.com
Subject: Re: [PATCH net-next] rds: transport module should be auto loaded
 when transport is set
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200527081742.25718-1-rao.shoaib@oracle.com>
References: <20200527081742.25718-1-rao.shoaib@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Fri, 29 May 2020 16:41:08 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: rao.shoaib@oracle.com
Date: Wed, 27 May 2020 01:17:42 -0700

> diff --git a/include/uapi/linux/rds.h b/include/uapi/linux/rds.h
> index cba368e55863..7273c681e6c1 100644
> --- a/include/uapi/linux/rds.h
> +++ b/include/uapi/linux/rds.h
> @@ -64,7 +64,7 @@
>  
>  /* supported values for SO_RDS_TRANSPORT */
>  #define	RDS_TRANS_IB	0
> -#define	RDS_TRANS_IWARP	1
> +#define	RDS_TRANS_GAP	1
>  #define	RDS_TRANS_TCP	2
>  #define RDS_TRANS_COUNT	3
>  #define	RDS_TRANS_NONE	(~0)

You can't break user facing UAPI like this, sorry.
