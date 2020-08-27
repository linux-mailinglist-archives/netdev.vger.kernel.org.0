Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 682B8254792
	for <lists+netdev@lfdr.de>; Thu, 27 Aug 2020 16:51:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728361AbgH0Ovt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 27 Aug 2020 10:51:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33308 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727851AbgH0Ovs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 27 Aug 2020 10:51:48 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A7218C061264
        for <netdev@vger.kernel.org>; Thu, 27 Aug 2020 07:51:48 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id E6CAB1279B496;
        Thu, 27 Aug 2020 07:35:01 -0700 (PDT)
Date:   Thu, 27 Aug 2020 07:51:47 -0700 (PDT)
Message-Id: <20200827.075147.1030378285544511842.davem@davemloft.net>
To:     wenxu@ucloud.cn
Cc:     netdev@vger.kernel.org, marcelo.leitner@gmail.com
Subject: Re: [PATCH net-next 1/2] ipv6: add ipv6_fragment hook in ipv6_stub
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1598524792-30597-2-git-send-email-wenxu@ucloud.cn>
References: <1598524792-30597-1-git-send-email-wenxu@ucloud.cn>
        <1598524792-30597-2-git-send-email-wenxu@ucloud.cn>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 27 Aug 2020 07:35:02 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: wenxu@ucloud.cn
Date: Thu, 27 Aug 2020 18:39:51 +0800

> From: wenxu <wenxu@ucloud.cn>
> 
> Add ipv6_fragment to ipv6_stub to avoid calling netfilter when
> access ip6_fragment.
> 
> Signed-off-by: wenxu <wenxu@ucloud.cn>

Please test these changes with ipv6 disabled.

It will crash, you have to update the default stub in
net/ipv6/addrconf_core.c as well.
