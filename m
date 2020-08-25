Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 64DA2250E01
	for <lists+netdev@lfdr.de>; Tue, 25 Aug 2020 03:03:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728254AbgHYBDE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 21:03:04 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726090AbgHYBDD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 24 Aug 2020 21:03:03 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4F09BC061574;
        Mon, 24 Aug 2020 18:03:03 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id AA17C12952B6E;
        Mon, 24 Aug 2020 17:46:16 -0700 (PDT)
Date:   Mon, 24 Aug 2020 18:03:02 -0700 (PDT)
Message-Id: <20200824.180302.1446733126145418314.davem@davemloft.net>
To:     dinghao.liu@zju.edu.cn
Cc:     kjlu@umn.edu, 3chas3@gmail.com,
        linux-atm-general@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] firestream: Fix memleak in fs_open
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200823112935.27574-1-dinghao.liu@zju.edu.cn>
References: <20200823112935.27574-1-dinghao.liu@zju.edu.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 24 Aug 2020 17:46:16 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Dinghao Liu <dinghao.liu@zju.edu.cn>
Date: Sun, 23 Aug 2020 19:29:35 +0800

> When make_rate() fails, vcc should be freed just
> like other error paths in fs_open().
> 
> Signed-off-by: Dinghao Liu <dinghao.liu@zju.edu.cn>

Applied, thank you.
