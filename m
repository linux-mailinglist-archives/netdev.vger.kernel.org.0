Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9407AA9645
	for <lists+netdev@lfdr.de>; Thu,  5 Sep 2019 00:22:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729963AbfIDWWV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Sep 2019 18:22:21 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:38654 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727722AbfIDWWV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 4 Sep 2019 18:22:21 -0400
Received: from localhost (unknown [62.21.130.100])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 8977015285AC1;
        Wed,  4 Sep 2019 15:22:20 -0700 (PDT)
Date:   Wed, 04 Sep 2019 15:22:18 -0700 (PDT)
Message-Id: <20190904.152218.250246841354408872.davem@davemloft.net>
To:     yanjun.zhu@oracle.com
Cc:     eric.dumazet@gmail.com, netdev@vger.kernel.org
Subject: Re: [PATCHv2 1/1] forcedeth: use per cpu to collect xmit/recv
 statistics
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1567322773-5183-2-git-send-email-yanjun.zhu@oracle.com>
References: <1567322773-5183-1-git-send-email-yanjun.zhu@oracle.com>
        <1567322773-5183-2-git-send-email-yanjun.zhu@oracle.com>
X-Mailer: Mew version 6.8 on Emacs 26.2
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Sep 2019 15:22:21 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zhu Yanjun <yanjun.zhu@oracle.com>
Date: Sun,  1 Sep 2019 03:26:13 -0400

> +static inline void nv_get_stats(int cpu, struct fe_priv *np,
> +				struct rtnl_link_stats64 *storage)
 ...
> +static inline void rx_missing_handler(u32 flags, struct fe_priv *np)
> +{

Never use the inline keyword in foo.c files, let the compiler decide.
