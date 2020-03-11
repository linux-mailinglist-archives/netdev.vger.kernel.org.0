Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 36ED718241F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 22:44:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729479AbgCKVoT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 17:44:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:38240 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729102AbgCKVoT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Mar 2020 17:44:19 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C0291206B1;
        Wed, 11 Mar 2020 21:44:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583963059;
        bh=klG8p9B6ZvM74J5caaf1Lv5IpHvKQhcAtgTj5EJ0ie8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=klFByTvwSzsJPRoqakQb4v+z6I6hZZ3lus+4PSkpSSs3EjSfK/XoSCxtN5lktyfmu
         vaHvPdF51xEwuTngJ8TeQQfxMnDvOY3k4/vC5if3uLyrxfNznbETzC+PD0aHQaRCvx
         l/7e0t1jQMnHBHfdKBo1L+GrYuDQwSVtFWvxKSUQ=
Date:   Wed, 11 Mar 2020 14:44:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Takashi Iwai <tiwai@suse.de>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>,
        oss-drivers@netronome.com
Subject: Re: [PATCH 4/7] nfp: Use scnprintf() for avoiding potential buffer
 overflow
Message-ID: <20200311144416.624c979c@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200311083745.17328-5-tiwai@suse.de>
References: <20200311083745.17328-1-tiwai@suse.de>
        <20200311083745.17328-5-tiwai@suse.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 11 Mar 2020 09:37:42 +0100 Takashi Iwai wrote:
> @@ -680,7 +680,7 @@ static int enable_bars(struct nfp6000_pcie *nfp, u16 interface)
>  		bar->iomem = ioremap(nfp_bar_resource_start(bar),
>  					     nfp_bar_resource_len(bar));
>  		if (bar->iomem) {
> -			msg += snprintf(msg, end - msg,
> +			msg += scnprintf(msg, end - msg,
>  					"0.%d: Explicit%d, ", 4 + i, i);

Thanks for the patches! One nit pick - please adjust the continuation
lines so it starts on the column after the opening bracket (other
patches have the same problem).

You can try running scripts/checkpatch --strict on your patches, it
should catch these.
