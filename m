Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B0F0723B074
	for <lists+netdev@lfdr.de>; Tue,  4 Aug 2020 00:49:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728421AbgHCWte (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 18:49:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53758 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726770AbgHCWtd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 18:49:33 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CC6BBC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 15:49:32 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9D62512777A3D;
        Mon,  3 Aug 2020 15:32:46 -0700 (PDT)
Date:   Mon, 03 Aug 2020 15:49:31 -0700 (PDT)
Message-Id: <20200803.154931.851692800404466253.davem@davemloft.net>
To:     lukas@wunner.de
Cc:     kuba@kernel.org, vincent.ldev@duvert.net, chris@disavowed.jp,
        doug@downtowndougbrown.com, yuehaibing@huawei.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH] appletalk: Fix atalk_proc_init() return path
From:   David Miller <davem@davemloft.net>
In-Reply-To: <086b426f44bc24360cc89476fe18d2758a2652af.1596344622.git.lukas@wunner.de>
References: <086b426f44bc24360cc89476fe18d2758a2652af.1596344622.git.lukas@wunner.de>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 03 Aug 2020 15:32:46 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Lukas Wunner <lukas@wunner.de>
Date: Sun, 2 Aug 2020 07:06:51 +0200

> From: Vincent Duvert <vincent.ldev@duvert.net>
> 
> Add a missing return statement to atalk_proc_init so it doesn't return
> -ENOMEM when successful.  This allows the appletalk module to load
> properly.
> 
> Fixes: e2bcd8b0ce6e ("appletalk: use remove_proc_subtree to simplify procfs code")
> Link: https://www.downtowndougbrown.com/2020/08/hacking-up-a-fix-for-the-broken-appletalk-kernel-module-in-linux-5-1-and-newer/
> Reported-by: Christopher KOBAYASHI <chris@disavowed.jp>
> Reported-by: Doug Brown <doug@downtowndougbrown.com>
> Signed-off-by: Vincent Duvert <vincent.ldev@duvert.net>
> [lukas: add missing tags]
> Signed-off-by: Lukas Wunner <lukas@wunner.de>

Shows how many people are actually using appletalk if it doesn't even
load since v5.1

Applied.
