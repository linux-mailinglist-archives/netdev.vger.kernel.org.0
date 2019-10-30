Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8F9BEA547
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 22:19:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727046AbfJ3VTG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 17:19:06 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:46700 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726261AbfJ3VTG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 30 Oct 2019 17:19:06 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 9F25614C612B7;
        Wed, 30 Oct 2019 14:19:05 -0700 (PDT)
Date:   Wed, 30 Oct 2019 14:19:05 -0700 (PDT)
Message-Id: <20191030.141905.193278198817861701.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     gvrose8192@gmail.com, pshelar@ovn.org, netdev@vger.kernel.org,
        dev@openvswitch.org
Subject: Re: [PATCH net-next v5 04/10] net: openvswitch: optimize flow mask
 cache hash collision
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1571472524-73832-5-git-send-email-xiangxia.m.yue@gmail.com>
References: <1571472524-73832-1-git-send-email-xiangxia.m.yue@gmail.com>
        <1571472524-73832-5-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 30 Oct 2019 14:19:05 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sat, 19 Oct 2019 16:08:38 +0800

> @@ -516,18 +519,31 @@ static struct sw_flow *flow_lookup(struct flow_table *tbl,
>  				   u32 *index)
>  {
>  	struct sw_flow *flow;
> +	struct sw_flow_mask *mask;
>  	int i;

Please preserve the reverse christmas tree ordering of local variables here.

Thank you.
