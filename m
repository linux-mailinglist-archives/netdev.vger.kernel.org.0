Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AAB73274DF7
	for <lists+netdev@lfdr.de>; Wed, 23 Sep 2020 02:45:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727154AbgIWApb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 20:45:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47812 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726878AbgIWApb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 22 Sep 2020 20:45:31 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 66C11C061755
        for <netdev@vger.kernel.org>; Tue, 22 Sep 2020 17:45:31 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A04B013C05434;
        Tue, 22 Sep 2020 17:28:43 -0700 (PDT)
Date:   Tue, 22 Sep 2020 17:45:30 -0700 (PDT)
Message-Id: <20200922.174530.742039366455945503.davem@davemloft.net>
To:     saeed@kernel.org
Cc:     kuba@kernel.org, netdev@vger.kernel.org, saeedm@nvidia.com
Subject: Re: [pull request][net-next V3 00/12] mlx5 Multi packet tx
 descriptors for SKBs
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200922024704.544482-1-saeed@kernel.org>
References: <20200922024704.544482-1-saeed@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Tue, 22 Sep 2020 17:28:43 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: saeed@kernel.org
Date: Mon, 21 Sep 2020 19:46:52 -0700

> From: Saeed Mahameed <saeedm@nvidia.com>
> 
> Hi Dave & Jakub
> 
> This series adds support for Multi packet tx descriptors for SKBs.
> For more information please see tag log below.
> 
> v1->v2:
>  - Move small irrelevant changes from the refactoring patch to separate
> patches.
>  - Don't touch mlx5e_txwqe_build_eseg_csum without need.
> 
> v2->v3:
> Manual inlining was dropped, test results were updated for GCC 10. The
> previous numbers were measured on a kernel compiled with GCC 4.9, and it
> turns out that the new GCC optimizes code in a different way, and manual
> inlining is not needed to avoid performance degradation with GCC 10.
> 
> Please pull and let me know if there is any problem.

Pulled, thank you.
