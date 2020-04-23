Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B11D81B648C
	for <lists+netdev@lfdr.de>; Thu, 23 Apr 2020 21:35:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728824AbgDWTfB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Apr 2020 15:35:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35336 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728700AbgDWTfA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Apr 2020 15:35:00 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7D25C09B042;
        Thu, 23 Apr 2020 12:35:00 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 68F2A127789E0;
        Thu, 23 Apr 2020 12:35:00 -0700 (PDT)
Date:   Thu, 23 Apr 2020 12:34:59 -0700 (PDT)
Message-Id: <20200423.123459.1317092825451472203.davem@davemloft.net>
To:     dan.carpenter@oracle.com
Cc:     jiri@mellanox.com, idosch@mellanox.com, netdev@vger.kernel.org,
        kernel-janitors@vger.kernel.org
Subject: Re: [PATCH net] mlxsw: Fix some IS_ERR() vs NULL bugs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200422093641.GA189235@mwanda>
References: <20200422093641.GA189235@mwanda>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 23 Apr 2020 12:35:00 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>
Date: Wed, 22 Apr 2020 12:36:41 +0300

> The mlxsw_sp_acl_rulei_create() function is supposed to return an error
> pointer from mlxsw_afa_block_create().  The problem is that these
> functions both return NULL instead of error pointers.  Half the callers
> expect NULL and half expect error pointers so it could lead to a NULL
> dereference on failure.
> 
> This patch changes both of them to return error pointers and changes all
> the callers which checked for NULL to check for IS_ERR() instead.
> 
> Fixes: 4cda7d8d7098 ("mlxsw: core: Introduce flexible actions support")
> Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>

Applied, thanks.
