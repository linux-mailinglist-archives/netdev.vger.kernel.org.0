Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CE9C3A7A67
	for <lists+netdev@lfdr.de>; Wed,  4 Sep 2019 06:48:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726240AbfIDEsm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 00:48:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:55690 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725267AbfIDEsm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 00:48:42 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id DFE421433DD9F;
        Tue,  3 Sep 2019 21:48:40 -0700 (PDT)
Date:   Tue, 03 Sep 2019 21:48:36 -0700 (PDT)
Message-Id: <20190903.214836.182971744584710402.davem@davemloft.net>
To:     saeedm@mellanox.com
Cc:     netdev@vger.kernel.org, valex@mellanox.com, erezsh@mellanox.com
Subject: Re: [pull request][net-next V2 00/18] Mellanox, mlx5 software
 managed steering
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190903200409.14406-1-saeedm@mellanox.com>
References: <20190903200409.14406-1-saeedm@mellanox.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 03 Sep 2019 21:48:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Saeed Mahameed <saeedm@mellanox.com>
Date: Tue, 3 Sep 2019 20:04:24 +0000

> This series adds the support for software (driver managed) flow steering.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.
> 
> Please note that the series starts with a merge of mlx5-next branch,
> to resolve and avoid dependency with rdma tree.
> 
> v2:
>  - Improve return values transformation of the first patch.

Pulled, thanks Saeed.
