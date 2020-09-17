Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32B1526D019
	for <lists+netdev@lfdr.de>; Thu, 17 Sep 2020 02:43:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726072AbgIQAnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Sep 2020 20:43:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43760 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbgIQAnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Sep 2020 20:43:02 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D9DF7C061353
        for <netdev@vger.kernel.org>; Wed, 16 Sep 2020 17:42:59 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 0FEA313C788C4;
        Wed, 16 Sep 2020 17:26:12 -0700 (PDT)
Date:   Wed, 16 Sep 2020 17:42:58 -0700 (PDT)
Message-Id: <20200916.174258.641582844139093431.davem@davemloft.net>
To:     mark.d.gray@redhat.com
Cc:     netdev@vger.kernel.org, qiuyu.xiao.qyx@gmail.com,
        gvrose8192@gmail.com
Subject: Re: [PATCH net v2] geneve: add transport ports in route lookup for
 geneve
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200916091935.859119-1-mark.d.gray@redhat.com>
References: <20200916091935.859119-1-mark.d.gray@redhat.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Wed, 16 Sep 2020 17:26:12 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Mark Gray <mark.d.gray@redhat.com>
Date: Wed, 16 Sep 2020 05:19:35 -0400

> This patch adds transport ports information for route lookup so that
> IPsec can select Geneve tunnel traffic to do encryption. This is
> needed for OVS/OVN IPsec with encrypted Geneve tunnels.
> 
> This can be tested by configuring a host-host VPN using an IKE
> daemon and specifying port numbers. For example, for an
> Openswan-type configuration, the following parameters should be
> configured on both hosts and IPsec set up as-per normal:
 ...
> Fixes: 2d07dc79fe04 ("geneve: add initial netdev driver for GENEVE tunnels")
> Signed-off-by: Qiuyu Xiao <qiuyu.xiao.qyx@gmail.com>
> Signed-off-by: Mark Gray <mark.d.gray@redhat.com>
> Reviewed-by: Greg Rose <gvrose8192@gmail.com>

Applied and queued up for -stable, thank you.
