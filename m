Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 720D138CFDF
	for <lists+netdev@lfdr.de>; Fri, 21 May 2021 23:26:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229535AbhEUV1Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 May 2021 17:27:24 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:37940 "EHLO
        mail.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbhEUV1X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 May 2021 17:27:23 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        by mail.monkeyblade.net (Postfix) with ESMTPSA id 97D184D99338B;
        Fri, 21 May 2021 14:25:59 -0700 (PDT)
Date:   Fri, 21 May 2021 14:25:35 -0700 (PDT)
Message-Id: <20210521.142535.305654298687081579.davem@davemloft.net>
To:     Rao.Shoaib@oracle.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH RDS/TCP v1 1/1] RDS tcp loopback connection can hang
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
References: <20210521180806.80362-1-Rao.Shoaib@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.6.2 (mail.monkeyblade.net [0.0.0.0]); Fri, 21 May 2021 14:25:59 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Rao Shoaib <Rao.Shoaib@oracle.com>
Date: Fri, 21 May 2021 11:08:06 -0700

> +				/* No transport currently in use
> +				 * should end up here, but if it
> +				 * does, reset/destroy the connection.
> +				 */
> +				kmem_cache_free(rds_conn_slab, conn);
> +				conn = ERR_PTR(-EOPNOTSUPP);
> +				goto out;

Is thosa all we have to do?  What about releasing c_path[]?

Thanks.
