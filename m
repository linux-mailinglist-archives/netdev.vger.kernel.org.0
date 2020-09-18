Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C59E270826
	for <lists+netdev@lfdr.de>; Fri, 18 Sep 2020 23:24:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726419AbgIRVYa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Sep 2020 17:24:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35516 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726201AbgIRVYa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Sep 2020 17:24:30 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B0DEC0613CE;
        Fri, 18 Sep 2020 14:24:30 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id D6BE9159F265D;
        Fri, 18 Sep 2020 14:07:41 -0700 (PDT)
Date:   Fri, 18 Sep 2020 14:24:28 -0700 (PDT)
Message-Id: <20200918.142428.1545199752958492397.davem@davemloft.net>
To:     prime.zeng@hisilicon.com
Cc:     pshelar@ovn.org, kuba@kernel.org, netdev@vger.kernel.org,
        dev@openvswitch.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: openswitch: reuse the helper variable to improve
 the code readablity
From:   David Miller <davem@davemloft.net>
In-Reply-To: <1600413270-38398-1-git-send-email-prime.zeng@hisilicon.com>
References: <1600413270-38398-1-git-send-email-prime.zeng@hisilicon.com>
X-Mailer: Mew version 6.8 on Emacs 27.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [2620:137:e000::1:9]); Fri, 18 Sep 2020 14:07:42 -0700 (PDT)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Zeng Tao <prime.zeng@hisilicon.com>
Date: Fri, 18 Sep 2020 15:14:30 +0800

> In the function ovs_ct_limit_exit, there is already a helper vaibale
> which could be reused to improve the readability, so i fix it in this
> patch.
> 
> Signed-off-by: Zeng Tao <prime.zeng@hisilicon.com>

Applied, thanks.
