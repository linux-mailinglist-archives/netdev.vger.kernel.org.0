Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 01686264FB1
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 21:50:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbgIJTtl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 15:49:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49800 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725991AbgIJTtW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 15:49:22 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 80F70C061757
        for <netdev@vger.kernel.org>; Thu, 10 Sep 2020 12:49:22 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E58E712A34021;
        Thu, 10 Sep 2020 12:32:34 -0700 (PDT)
Date:   Thu, 10 Sep 2020 12:49:20 -0700 (PDT)
Message-Id: <20200910.124920.351614097376857899.davem@davemloft.net>
To:     kuba@kernel.org
Cc:     netdev@vger.kernel.org, kernel-team@fb.com, tariqt@mellanox.com,
        ogerlitz@mellanox.com, yishaih@mellanox.com, saeedm@mellanox.com,
        leonro@nvidia.com
Subject: Re: [PATCH net-next v2 0/2] mlx4: avoid devlink port type not set
 warnings
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200908222114.190718-1-kuba@kernel.org>
References: <20200908222114.190718-1-kuba@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 10 Sep 2020 12:32:35 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <kuba@kernel.org>
Date: Tue,  8 Sep 2020 15:21:12 -0700

> This small set addresses the issue of mlx4 potentially not setting
> devlink port type when Ethernet or IB driver is not built, but
> port has that type.
> 
> v2:
>  - add patch 1

Series applied, thank you.
