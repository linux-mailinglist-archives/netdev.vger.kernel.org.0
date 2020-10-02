Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 204D3281E22
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 00:16:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725772AbgJBWQ3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 2 Oct 2020 18:16:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42404 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725283AbgJBWQ3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 2 Oct 2020 18:16:29 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39D75C0613D0;
        Fri,  2 Oct 2020 15:16:29 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B643011E4794D;
        Fri,  2 Oct 2020 14:59:39 -0700 (PDT)
Date:   Fri, 02 Oct 2020 15:16:22 -0700 (PDT)
Message-Id: <20201002.151622.389422629289740345.davem@davemloft.net>
To:     mchehab+huawei@kernel.org
Cc:     linux-doc@vger.kernel.org, corbet@lwn.net, kuba@kernel.org,
        ap420073@gmail.com, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 1/6] net: core: document two new elements of struct
 net_device
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1c6293ffd174d0301c0acb85f0e60e9edf5e4a27.1601616399.git.mchehab+huawei@kernel.org>
References: <cover.1601616399.git.mchehab+huawei@kernel.org>
        <1c6293ffd174d0301c0acb85f0e60e9edf5e4a27.1601616399.git.mchehab+huawei@kernel.org>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 02 Oct 2020 14:59:40 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Date: Fri,  2 Oct 2020 07:49:45 +0200

> As warned by "make htmldocs", there are two new struct elements
> that aren't documented:
> 
> 	../include/linux/netdevice.h:2159: warning: Function parameter or member 'unlink_list' not described in 'net_device'
> 	../include/linux/netdevice.h:2159: warning: Function parameter or member 'nested_level' not described in 'net_device'
> 
> Fixes: 1fc70edb7d7b ("net: core: add nested_level variable in net_device")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

Applied, thank you.
