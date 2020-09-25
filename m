Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AD54277E5B
	for <lists+netdev@lfdr.de>; Fri, 25 Sep 2020 05:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726921AbgIYDGB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Sep 2020 23:06:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33118 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726706AbgIYDGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Sep 2020 23:06:01 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 159B6C0613CE;
        Thu, 24 Sep 2020 20:06:01 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2B912135F8F1A;
        Thu, 24 Sep 2020 19:49:13 -0700 (PDT)
Date:   Thu, 24 Sep 2020 20:05:59 -0700 (PDT)
Message-Id: <20200924.200559.1785907173440605045.davem@davemloft.net>
To:     wangqing@vivo.com
Cc:     aelior@marvell.com, skalluru@marvell.com,
        GR-everest-linux-l2@marvell.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net/ethernet/broadcom: fix spelling typo
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600930226-31320-1-git-send-email-wangqing@vivo.com>
References: <1600930226-31320-1-git-send-email-wangqing@vivo.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Thu, 24 Sep 2020 19:49:13 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Wang Qing <wangqing@vivo.com>
Date: Thu, 24 Sep 2020 14:50:24 +0800

> Modify the comment typo: "compliment" -> "complement".
> 
> Signed-off-by: Wang Qing <wangqing@vivo.com>

Applied, thank you.
