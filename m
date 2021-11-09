Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 256FC44AF5C
	for <lists+netdev@lfdr.de>; Tue,  9 Nov 2021 15:21:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237012AbhKIOYe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 9 Nov 2021 09:24:34 -0500
Received: from mail.kernel.org ([198.145.29.99]:53452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236800AbhKIOYb (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 9 Nov 2021 09:24:31 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 5E15F610F7;
        Tue,  9 Nov 2021 14:21:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636467705;
        bh=mo1+rhyssyl04yagu0+zAJeinO57uVXHKqe+e1wi/cc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ljIvXx1f034/vUGuqbD0dxp30MtgksnN5oY5zsfsab+2soYTfYSuIZ2F5CQVX3lLp
         iDCIhPDgkkAn0c1cLOlMXsReWsOQXeeVBf3WemeDtZi5qYCvJcvGnvwb+tLy74aKC+
         X8V4KuRyKijr5h/yOUoWVAAPcYpm7CmKNnSfbD3F/yQ1lxXhBuv1eSn1gTpZQbUZIQ
         OGiiHNUEUnHaS+oMPydWGAOpplHJUPg1KcbN2mXJtcrtiR1CaJS6fn7V2n9BXNpO85
         FjgQOuPd2Z56cQgxd0AN866V8omi4q/6VYwYa+PQgeE/jBYWre8GM4SibjfJQy4290
         GpA+DdRWruEIQ==
Date:   Tue, 9 Nov 2021 06:21:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ondrej Mosnacek <omosnace@redhat.com>,
        Xin Long <lucien.xin@gmail.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Paul Moore <paul@paul-moore.com>,
        Richard Haines <richard_c_haines@btinternet.com>,
        Vlad Yasevich <vyasevich@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        linux-sctp@vger.kernel.org, selinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] selinux: fix SCTP client peeloff socket labeling
Message-ID: <20211109062140.2ed84f96@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211104195949.135374-1-omosnace@redhat.com>
References: <20211104195949.135374-1-omosnace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  4 Nov 2021 20:59:49 +0100 Ondrej Mosnacek wrote:
> As agreed with Xin Long, I'm posting this fix up instead of him. I am
> now fairly convinced that this is the right way to deal with the
> immediate problem of client peeloff socket labeling. I'll work on
> addressing the side problem regarding selinux_socket_post_create()
> being called on the peeloff sockets separately.

IIUC Paul would like to see this part to come up in the same series.
Any predictions when such series would materialize?
