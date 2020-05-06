Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C16E51C7B77
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 22:45:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729073AbgEFUp0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 16:45:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:47332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728526AbgEFUpZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 16:45:25 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ED8E2206D5;
        Wed,  6 May 2020 20:45:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588797925;
        bh=WFA8dI9kr5fD5SE4G/Pa7zr6zaOU1HMzCWhNwjJIkwg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fUX5a4Xxp2x2D7MbyTD/mRSkFcXcujhUo5buZTl91tdVSR5MiBleDstr+KBN9IkuJ
         ZMks5UdZbZ8BfhHaafWdjhhePe8jecVPKFlPjl6Y4vZPTDhUYE1Nbr5iky1afFRGl5
         jtpOQhb9JKNp6eABO3N/yc+C+Qu/MIa5V+8vGo5A=
Date:   Wed, 6 May 2020 13:45:23 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Joe Perches <joe@perches.com>, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: put DYNAMIC INTERRUPT MODERATION in proper
 order
Message-ID: <20200506134523.46b358e3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200506202906.23297-1-lukas.bulwahn@gmail.com>
References: <20200506202906.23297-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 May 2020 22:29:06 +0200 Lukas Bulwahn wrote:
> Commit 9b038086f06b ("docs: networking: convert DIM to RST") added a new
> file entry to DYNAMIC INTERRUPT MODERATION to the end, and not following
> alphabetical order.
> 
> So, ./scripts/checkpatch.pl -f MAINTAINERS complains:
> 
>   WARNING: Misordered MAINTAINERS entry - list file patterns in alphabetic
>   order
>   #5966: FILE: MAINTAINERS:5966:
>   +F:      lib/dim/
>   +F:      Documentation/networking/net_dim.rst
> 
> Reorder the file entries to keep MAINTAINERS nicely ordered.
> 
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
