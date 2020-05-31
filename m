Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45F951E94D0
	for <lists+netdev@lfdr.de>; Sun, 31 May 2020 02:58:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729522AbgEaA6X (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 20:58:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51684 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729356AbgEaA6X (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 20:58:23 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 61637C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 17:58:23 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D2DF128DB7E9;
        Sat, 30 May 2020 17:58:22 -0700 (PDT)
Date:   Sat, 30 May 2020 17:58:20 -0700 (PDT)
Message-Id: <20200530.175820.1388522010933920643.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     paulb@mellanox.com, marcelo.leitner@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v2] net/sched: act_ct: add nat mangle action only for
 NAT-conntrack
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1590818091-3548-1-git-send-email-wenxu@ucloud.cn>
References: <1590818091-3548-1-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 30 May 2020 17:58:22 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Sat, 30 May 2020 13:54:51 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Currently add nat mangle action with comparing invert and ori tuple.
> It is better to check IPS_NAT_MASK flags first to avoid non necessary
> memcmp for non-NAT conntrack.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Applied.
