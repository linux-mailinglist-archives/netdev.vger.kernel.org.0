Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B02911C6043
	for <lists+netdev@lfdr.de>; Tue,  5 May 2020 20:40:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729047AbgEESkm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 May 2020 14:40:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34280 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728268AbgEESkl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 May 2020 14:40:41 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5DA8C061A0F;
        Tue,  5 May 2020 11:40:41 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A3A2D127F7213;
        Tue,  5 May 2020 11:40:39 -0700 (PDT)
Date:   Tue, 05 May 2020 11:40:38 -0700 (PDT)
Message-Id: <20200505.114038.1555352105288277307.davem@davemloft.net>
To:     yanaijie@huawei.com
Cc:     aelior@marvell.com, GR-everest-linux-l2@marvell.com,
        ast@kernel.org, daniel@iogearbox.net, kuba@kernel.org,
        hawk@kernel.org, john.fastabend@gmail.com, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        kpsingh@chromium.org, skalluru@marvell.com, pablo@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        bpf@vger.kernel.org
Subject: Re: [PATCH net-next] net: qede: Use true for bool variable in
 qede_init_fp()
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200505074539.22161-1-yanaijie@huawei.com>
References: <20200505074539.22161-1-yanaijie@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Tue, 05 May 2020 11:40:40 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jason Yan <yanaijie@huawei.com>
Date: Tue, 5 May 2020 15:45:39 +0800

> Fix the following coccicheck warning:
> 
> drivers/net/ethernet/qlogic/qede/qede_main.c:1717:5-19: WARNING:
> Assignment of 0/1 to bool variable
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>

Applied.
