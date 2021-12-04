Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 272E54681F8
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 03:23:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1384094AbhLDC0u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 21:26:50 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45438 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354647AbhLDC0t (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 21:26:49 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E1C65C061751
        for <netdev@vger.kernel.org>; Fri,  3 Dec 2021 18:23:24 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AED55B828E8
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 02:23:23 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09A7CC341C1;
        Sat,  4 Dec 2021 02:23:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638584602;
        bh=aGMnzK0Z3ASUkbRx/tvdsl+vYsv8EUresOefIqHHjNo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ety9gV+QRuMVg+yyv/t68GI3QKXvCMvbLpMt5tjPUh72ZEvkS5M7a+L3KUKEswiKu
         WAz9KvftyN0KNCjx2BHo6Ue1Cx8haCOVYRE/QEgvwbNsX5l0CkovVAywAbNWvz6Mu1
         xOamrSQTHYVxnO9JW3p8tKzOKM36NgCmuPfOUIgZKlNqoTPORXue6CfQ7wZu/K++pB
         9KBCUUNopudThaVkROEvfqf+hC2ulaxMbYTp/Kjo2z4MqsD8lBhTQlhi9dXRO47h5N
         dsVLhB+ew8RI555cbhE8ZJ4OUGk0u1iFLInuYBrNqGOoE644VRsfjYbujJ2ov5ZUya
         ek+Yfmfo8cxHw==
Date:   Fri, 3 Dec 2021 18:23:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     <bigeasy@linutronix.de>
Cc:     Kuniyuki Iwashima <kuniyu@amazon.co.jp>, <eric.dumazet@gmail.com>,
        <kafai@fb.com>, <davem@davemloft.net>, <dsahern@kernel.org>,
        <efault@gmx.de>, <netdev@vger.kernel.org>, <tglx@linutronix.de>,
        <yoshfuji@linux-ipv6.org>
Subject: Re: [PATCH net-next] tcp: Don't acquire
 inet_listen_hashbucket::lock with disabled BH.
Message-ID: <20211203182320.0b24a175@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211203013934.20645-1-kuniyu@amazon.co.jp>
References: <20211130142302.ikcnjgo2xlbxbbl3@linutronix.de>
        <20211203013934.20645-1-kuniyu@amazon.co.jp>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 3 Dec 2021 10:39:34 +0900 Kuniyuki Iwashima wrote:
> I think this patch is for the net tree and needs a Fixes: tag of the commit
> mentioned in the description.
> The patch itself looks good to me.
> 
> Acked-by: Kuniyuki Iwashima <kuniyu@amazon.co.jp>

Makes sense, please repost for net with the Fixes tag and CC Eric.
