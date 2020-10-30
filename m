Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1AB192A0FCE
	for <lists+netdev@lfdr.de>; Fri, 30 Oct 2020 22:00:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727694AbgJ3U7v (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 30 Oct 2020 16:59:51 -0400
Received: from mail.kernel.org ([198.145.29.99]:57244 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726163AbgJ3U7u (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 30 Oct 2020 16:59:50 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9ED3820797;
        Fri, 30 Oct 2020 20:59:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604091590;
        bh=g75KANMpn+QyFlKM9RAAm6BIhFn3Ci6qgnn766q1Hy0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jVCtK0ob8Wx5rTuY9eV73iXjZ4Vy/PDg2lD8OuRuPS24MvS5TODyrb9xesuYecKeC
         owFaNEwpozmKBO6Y8p8x5ZUsO1SMxITG6GygYQtz3pE5296Rc5BHflER34txiaYUXG
         5qyIaFc0hVklS2vGT+/s8ll5ns1r0+60zuYWOvsM=
Date:   Fri, 30 Oct 2020 13:59:48 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-safety@lists.elisa.tech
Subject: Re: [PATCH] ipv6: mcast: make annotations for ip6_mc_msfget()
 consistent
Message-ID: <20201030135948.32fc1a7c@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201028115349.6855-1-lukas.bulwahn@gmail.com>
References: <20201028115349.6855-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 28 Oct 2020 12:53:49 +0100 Lukas Bulwahn wrote:
> Commit 931ca7ab7fe8 ("ip*_mc_gsfget(): lift copyout of struct group_filter
> into callers") adjusted the type annotations for ip6_mc_msfget() at its
> declaration, but missed the type annotations at its definition.
> 
> Hence, sparse complains on ./net/ipv6/mcast.c:
> 
>   mcast.c:550:5: error: symbol 'ip6_mc_msfget' redeclared with different type \
>   (incompatible argument 3 (different address spaces))
> 
> Make ip6_mc_msfget() annotations consistent, which also resolves this
> warning from sparse:
> 
>   mcast.c:607:34: warning: incorrect type in argument 1 (different address spaces)
>   mcast.c:607:34:    expected void [noderef] __user *to
>   mcast.c:607:34:    got struct __kernel_sockaddr_storage *p
> 
> No functional change. No change in object code.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied, thank you!
