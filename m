Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 18E0A21A7DA
	for <lists+netdev@lfdr.de>; Thu,  9 Jul 2020 21:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726660AbgGITd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Jul 2020 15:33:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37620 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726213AbgGITd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Jul 2020 15:33:57 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 79331C08C5CE;
        Thu,  9 Jul 2020 12:33:57 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 163FF127933E7;
        Thu,  9 Jul 2020 12:33:57 -0700 (PDT)
Date:   Thu, 09 Jul 2020 12:33:56 -0700 (PDT)
Message-Id: <20200709.123356.950993082804327488.davem@davemloft.net>
To:     vulab@iscas.ac.cn
Cc:     colyli@suse.de, claudiu.manoil@nxp.com, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: enetc: use eth_broadcast_addr() to assign
 broadcast
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200709064855.14183-1-vulab@iscas.ac.cn>
References: <20200709064855.14183-1-vulab@iscas.ac.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 09 Jul 2020 12:33:57 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xu Wang <vulab@iscas.ac.cn>
Date: Thu,  9 Jul 2020 06:48:55 +0000

> This patch is to use eth_broadcast_addr() to assign broadcast address
> insetad of memset().
> 
> Signed-off-by: Xu Wang <vulab@iscas.ac.cn>

Applied to net-next, thanks.
