Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A1A120A731
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 23:05:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405588AbgFYVFe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 17:05:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51900 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405347AbgFYVFe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 17:05:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D1A01C08C5C1
        for <netdev@vger.kernel.org>; Thu, 25 Jun 2020 14:05:33 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 4649814BFC07F;
        Thu, 25 Jun 2020 14:05:32 -0700 (PDT)
Date:   Thu, 25 Jun 2020 14:05:28 -0700 (PDT)
Message-Id: <20200625.140528.1757449684577209415.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     kuba@kernel.org, netdev@vger.kernel.org
Subject: Re: [pull request][net-next V4 0/8] mlx5 updates 2020-06-23
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200625201329.45679-1-saeedm@mellanox.com>
References: <20200625201329.45679-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 25 Jun 2020 14:05:32 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Thu, 25 Jun 2020 13:13:21 -0700

> This series adds misc cleanup and updates to mlx5 driver.
> 
> v1->v2:
>  - Removed unnecessary Fixes Tags 
> 
> v2->v3:
>  - Drop "macro undefine" patch, it has no value
> 
> v3->v4:
>  - Drop the Relaxed ordering patch.
> 
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
 ...
>   git://git.kernel.org/pub/scm/linux/kernel/git/saeed/linux.git tags/mlx5-updates-2020-06-23

Pulled, thanks everyone.
