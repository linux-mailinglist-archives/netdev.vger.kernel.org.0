Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 095A948187D
	for <lists+netdev@lfdr.de>; Thu, 30 Dec 2021 03:25:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234662AbhL3CZT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Dec 2021 21:25:19 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49908 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233070AbhL3CZT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Dec 2021 21:25:19 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23B78C061574
        for <netdev@vger.kernel.org>; Wed, 29 Dec 2021 18:25:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 75D6ECE181B
        for <netdev@vger.kernel.org>; Thu, 30 Dec 2021 02:25:17 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 9F074C36AE1;
        Thu, 30 Dec 2021 02:25:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640831115;
        bh=GLjSNTbHZ+MUl50tySnDuv6cRZMBtfNxVIBkvBkzPKw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=cg27+t/4Zk4jyM/ejZeAtNnWgganPcBoJ1+sxFNpsbfOEHr9oqjEDqvkka/YCC9I3
         k10GpitqHtJOE6hipVakjjRGpFri2vUtkDiluu92bXaGuqEOsNUF0uM9VtQCqW4JCr
         PvcdZE513oodLiN7HI8jFwVtGL0Q+d/hDTvzni3CxJ6SYefIsBgbX387YEiSF98djS
         qBmSzLLXTvD1n0Z2jDx8SB/Bjt6wtOE+UtfLfeY3bqh/3QgJxOj0StHoNlZV9W/7cD
         LRlj7oLJRgCjpADBtaFYNnVn9Mf75IsvGv8yDnQm4kEzlQx4+U2Nr3nzDapnj35aXw
         txxLkhnm93bJw==
Date:   Wed, 29 Dec 2021 18:25:14 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Jianguo Wu <wujianguo106@163.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH] selftests/net: udpgso_bench_tx: fix dst ip argument
Message-ID: <20211229182514.54892af9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CA+FuTSfFmgwvLfkvk0knA0G7mbuKw3PdX=M9AAhLjxKuUYEO+g@mail.gmail.com>
References: <ff620d9f-5b52-06ab-5286-44b945453002@163.com>
        <CA+FuTSfFmgwvLfkvk0knA0G7mbuKw3PdX=M9AAhLjxKuUYEO+g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 29 Dec 2021 09:16:37 -0500 Willem de Bruijn wrote:
> On Wed, Dec 29, 2021 at 5:58 AM Jianguo Wu <wujianguo106@163.com> wrote:
> >
> > From: wujianguo <wujianguo@chinatelecom.cn>
> >
> > udpgso_bench_tx call setup_sockaddr() for dest address before
> > parsing all arguments, if we specify "-p ${dst_port}" after "-D ${dst_ip}",
> > then ${dst_port} will be ignored, and using default cfg_port 8000.
> >
> > This will cause test case "multiple GRO socks" failed in udpgro.sh.
> >
> > Setup sockaddr after after parsing all arguments.

s/after after/after/

> >
> > Fixes: 3a687bef148d ("selftests: udp gso benchmark")
> > Signed-off-by: Jianguo Wu <wujianguo@chinatelecom.cn>  
> 
> Reviewed-by: Willem de Bruijn <willemb@google.com>
> 
> The udpgso_bench_tx equivalent to commit d336509cb9d0 ("selftests/net:
> udpgso_bench_rx: fix port argument"). Thanks.

Applied, thanks!
