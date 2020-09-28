Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2A68027B749
	for <lists+netdev@lfdr.de>; Mon, 28 Sep 2020 23:42:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726977AbgI1Vl7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 28 Sep 2020 17:41:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726582AbgI1Vl7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 28 Sep 2020 17:41:59 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20E42C061755
        for <netdev@vger.kernel.org>; Mon, 28 Sep 2020 14:41:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7E04611E3E4CE;
        Mon, 28 Sep 2020 14:25:09 -0700 (PDT)
Date:   Mon, 28 Sep 2020 14:41:49 -0700 (PDT)
Message-Id: <20200928.144149.790487567012040407.davem@davemloft.net>
To:     kliteyn@nvidia.com
Cc:     saeed@kernel.org, kuba@kernel.org, netdev@vger.kernel.org,
        erezsh@nvidia.com, mbloch@nvidia.com, saeedm@nvidia.com
Subject: Re: [net-next 01/15] net/mlx5: DR, Add buddy allocator utilities
From:   David Miller <davem@davemloft.net>
In-Reply-To: <DM6PR12MB423444C484839CF7FB7AA6B3C0350@DM6PR12MB4234.namprd12.prod.outlook.com>
References: <20200925193809.463047-2-saeed@kernel.org>
        <20200926.151540.1383303857229218158.davem@davemloft.net>
        <DM6PR12MB423444C484839CF7FB7AA6B3C0350@DM6PR12MB4234.namprd12.prod.outlook.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 28 Sep 2020 14:25:09 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Yevgeny Kliteynik <kliteyn@nvidia.com>
Date: Mon, 28 Sep 2020 19:58:59 +0000

> By replacing the bits-per-long array with a single counter we loose
> this ability to jump faster to the free spot.

I don't understand why this is true, because upon the free we will
update the hint and that's where the next bit search will start.

Have you even tried my suggestion?
