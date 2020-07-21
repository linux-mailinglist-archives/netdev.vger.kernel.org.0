Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 25BEB227489
	for <lists+netdev@lfdr.de>; Tue, 21 Jul 2020 03:29:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726539AbgGUB3x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Jul 2020 21:29:53 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726029AbgGUB3x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Jul 2020 21:29:53 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 27A57C061794
        for <netdev@vger.kernel.org>; Mon, 20 Jul 2020 18:29:53 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8D8EF11FFCC33;
        Mon, 20 Jul 2020 18:13:07 -0700 (PDT)
Date:   Mon, 20 Jul 2020 18:29:51 -0700 (PDT)
Message-Id: <20200720.182951.718658562772727842.davem@davemloft.net>
To:     vinay.yadav@chelsio.com
Cc:     netdev@vger.kernel.org, kuba@kernel.org, borisp@mellanox.com,
        daniel@iogearbox.net, secdev@chelsio.com
Subject: Re: [PATCH net-next v2] crypto/chtls: Enable tcp window scaling
 option
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200717191639.1601-1-vinay.yadav@chelsio.com>
References: <20200717191639.1601-1-vinay.yadav@chelsio.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 20 Jul 2020 18:13:07 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vinay Kumar Yadav <vinay.yadav@chelsio.com>
Date: Sat, 18 Jul 2020 00:46:40 +0530

> Enable tcp window scaling option in hw based on sysctl settings
> and option in connection request.
> 
> v1->v2:
> - Set window scale option based on option in connection request.
> 
> Signed-off-by: Vinay Kumar Yadav <vinay.yadav@chelsio.com>

Applied.
