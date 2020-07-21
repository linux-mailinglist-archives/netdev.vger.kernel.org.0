Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 908C7227431
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 02:56:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728092AbgGUA4O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 20:56:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39894 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726390AbgGUA4N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 20:56:13 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB676C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 17:56:13 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A2B9B11E8EC25;
        Mon, 20 Jul 2020 17:39:28 -0700 (PDT)
Date:   Mon, 20 Jul 2020 17:56:12 -0700 (PDT)
Message-Id: <20200720.175612.796997135090632820.davem@davemloft.net>
To:     liujian56@huawei.com
Cc:     jiri@mellanox.co, idosch@mellanox.com, kuba@kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH net] mlxsw: destroy workqueue when trap_register in
 mlxsw_emad_init
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200720143150.40362-1-liujian56@huawei.com>
References: <20200720143150.40362-1-liujian56@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 17:39:28 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Liu Jian <liujian56@huawei.com>
Date: Mon, 20 Jul 2020 22:31:49 +0800

> When mlxsw_core_trap_register fails in mlxsw_emad_init,
> destroy_workqueue() shouled be called to destroy mlxsw_core->emad_wq.
> 
> Fixes: d965465b60ba ("mlxsw: core: Fix possible deadlock")
> Signed-off-by: Liu Jian <liujian56@huawei.com>

Applied and queued up for -stable, thanks.
