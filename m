Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4E7A72B884C
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 00:22:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726641AbgKRXT7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 18:19:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:35034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726086AbgKRXT6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 18:19:58 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C76B2206CA;
        Wed, 18 Nov 2020 23:19:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605741598;
        bh=vW1eqCMVpD8aS0vTHIukNf7zRJ5AVfWo3ymwEqKC1TU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=uu4y0jij4WXxElmDXgTV/Mgnr7HiQlBvg8IsFcnA5fnX11xyYI1WL/YZK/pHkyH3f
         1jVJsMK/VvNwCPVBmeEF43jYq3SeG99Y+tsMrcZDE5HAGXJZZfHR9WU9OPv0tkwYwU
         qpErx5quqEmZXJR+FYyAs8jXD6k0rMbqFz6m3Q0k=
Date:   Wed, 18 Nov 2020 15:19:56 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Antonio Cardace <acardace@redhat.com>,
        Network Development <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH net-next v3 4/4] selftests: add ring and coalesce
 selftests
Message-ID: <20201118151956.277f7fec@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+FuTSevYage147cqyogSfvZN5gtqKngP3RNQe0UoawgtQQ-xA@mail.gmail.com>
References: <20201113231655.139948-1-acardace@redhat.com>
        <20201113231655.139948-4-acardace@redhat.com>
        <20201116164503.7dcedcae@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20201117113236.yqgv3q5csgq3vwqr@yoda.fritz.box>
        <20201117091536.5e09ac13@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CA+FuTSevYage147cqyogSfvZN5gtqKngP3RNQe0UoawgtQQ-xA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 16:43:33 -0500 Willem de Bruijn wrote:
> On Tue, Nov 17, 2020 at 12:19 PM Jakub Kicinski <kuba@kernel.org> wrote:
> > Sorry I misremembered it's 4. We can leave that as is.  
> 
> Instead of having to remember, maybe we should have a file in
> tools/testing/selftest to define constants?
> 
> I defined them one-off in tools/testing/selftests/net/udpgso_bench.sh
> 
> readonly KSFT_PASS=0
> readonly KSFT_FAIL=1
> readonly KSFT_SKIP=4
> 
> along with some other kselftest shell support infra. But having each
> test figure this out independently is duplicative and error prone.

Sounds like a good idea, I was surprised it wasn't already defined in
any lib.

CCing the selftest ML.
