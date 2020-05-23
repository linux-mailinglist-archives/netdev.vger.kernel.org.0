Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 438D81DFBFA
	for <lists+netdev@lfdr.de>; Sun, 24 May 2020 01:52:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388199AbgEWXwe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 23 May 2020 19:52:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54052 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388106AbgEWXwe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 23 May 2020 19:52:34 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B39A8C061A0E;
        Sat, 23 May 2020 16:52:34 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 5625112873741;
        Sat, 23 May 2020 16:52:34 -0700 (PDT)
Date:   Sat, 23 May 2020 16:52:33 -0700 (PDT)
Message-Id: <20200523.165233.2261018920178815445.davem@davemloft.net>
To:     dinghao.liu@zju.edu.cn
Cc:     kjlu@umn.edu, steve.glendinning@shawell.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: smsc911x: Fix runtime PM imbalance on error
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200523080820.13476-1-dinghao.liu@zju.edu.cn>
References: <20200523080820.13476-1-dinghao.liu@zju.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 May 2020 16:52:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Sat, 23 May 2020 16:08:20 +0800

> Remove runtime PM usage counter decrement when the
> increment function has not been called to keep the
> counter balanced.
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Applied, thank you.
