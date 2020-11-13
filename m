Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB9D32B2693
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 22:27:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726020AbgKMV0l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 16:26:41 -0500
Received: from mail.kernel.org ([198.145.29.99]:42202 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725885AbgKMV0l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Nov 2020 16:26:41 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 744C822252;
        Fri, 13 Nov 2020 21:26:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605302800;
        bh=HYKwiEHUlNzDsTJUtY5ggIeiKma5jPsN/VnAotI9DZI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=q6csoxex7yzKKsRhKSFagOeStfJEl1sfXv9h6KeM0Q87UQ5M6UB7VheWmgGsUVpsN
         FsGd2A6N1w2vW1OYYRC5aXDDRkDfXU5qefv4fVHk/+Seq0DfylQAqvhK5Ri+bwowYL
         DVRclEBMzS4PfHa8S2BarF2kDACF+rjz6uYeepNY=
Date:   Fri, 13 Nov 2020 13:26:39 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Antonio Cardace <acardace@redhat.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        Michal Kubecek <mkubecek@suse.cz>
Subject: Re: [PATCH net-next v2 2/4] netdevsim: support ethtool ring and
 coalesce settings
Message-ID: <20201113132639.251de546@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201113152531.2235878-2-acardace@redhat.com>
References: <20201113152531.2235878-2-acardace@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Nov 2020 16:25:29 +0100 Antonio Cardace wrote:
> +static int nsim_get_coalesce(struct net_device *dev, struct ethtool_coalesce *coal)

Please wrap at 80 chars.

Please resend as a series (with a cover letter, patches are replies to
the cover letter (I think git send-email --thread --no-chain-reply-to,
but those options are on by default). Non-series patches don't get
grouped by patchwork and don't get build tested, they are also a pain
to apply.
