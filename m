Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C79801B8BC8
	for <lists+netdev@lfdr.de>; Sun, 26 Apr 2020 05:48:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726162AbgDZDsr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 25 Apr 2020 23:48:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51048 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725945AbgDZDsr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 25 Apr 2020 23:48:47 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A2F74C061A0C;
        Sat, 25 Apr 2020 20:48:47 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3D023159FFC4E;
        Sat, 25 Apr 2020 20:48:47 -0700 (PDT)
Date:   Sat, 25 Apr 2020 20:48:46 -0700 (PDT)
Message-Id: <20200425.204846.1929725746422713394.davem@davemloft.net>
To:     xiangxia.m.yue@gmail.com
Cc:     eric.dumazet@gmail.com, geert@linux-m68k.org, pshelar@ovn.org,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: openvswitch: use div_u64() for 64-by-32
 divisions
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1587785988-23517-2-git-send-email-xiangxia.m.yue@gmail.com>
References: <1587785988-23517-1-git-send-email-xiangxia.m.yue@gmail.com>
        <1587785988-23517-2-git-send-email-xiangxia.m.yue@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sat, 25 Apr 2020 20:48:47 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: xiangxia.m.yue@gmail.com
Date: Sat, 25 Apr 2020 11:39:48 +0800

> From: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> 
> Compile the kernel for arm 32 platform, the build warning found.
> To fix that, should use div_u64() for divisions.
> | net/openvswitch/meter.c:396: undefined reference to `__udivdi3'
> 
> [add more commit msg, change reported tag, and use div_u64 instead
> of do_div by Tonghao]
> 
> Fixes: e57358873bb5d6ca ("net: openvswitch: use u64 for meter bucket")
> Reported-by: kbuild test robot <lkp@intel.com>
> Signed-off-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>
> Tested-by: Tonghao Zhang <xiangxia.m.yue@gmail.com>

Applied.
