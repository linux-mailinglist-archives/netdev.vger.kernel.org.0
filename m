Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41A2A2699ED
	for <lists+netdev@lfdr.de>; Tue, 15 Sep 2020 01:52:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726019AbgINXwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 19:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40432 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725994AbgINXwm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 19:52:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C55EEC06174A
        for <netdev@vger.kernel.org>; Mon, 14 Sep 2020 16:52:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 78989128DAA8F;
        Mon, 14 Sep 2020 16:35:54 -0700 (PDT)
Date:   Mon, 14 Sep 2020 16:52:40 -0700 (PDT)
Message-Id: <20200914.165240.1943724095970770811.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, jhs@mojatatu.com, xiyou.wangcong@gmail.com,
        jiri@resnulli.us
Subject: Re: [PATCH net 0/2] net: improve vxlan option process in net_sched
 and lwtunnel
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1599997873.git.lucien.xin@gmail.com>
References: <cover.1599997873.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Mon, 14 Sep 2020 16:35:54 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Sun, 13 Sep 2020 19:51:49 +0800

> This patch is to do some mask when setting vxlan option in net_sched
> and lwtunnel, so that only available bits can be set on vxlan md gbp.
> 
> This would help when users don't know exactly vxlan's gbp bits, and
> avoid some mismatch because of some unavailable bits set by users.

Series applied, thank you.
