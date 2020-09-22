Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 41C1F27479C
	for <lists+netdev@lfdr.de>; Tue, 22 Sep 2020 19:40:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726656AbgIVRkS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 22 Sep 2020 13:40:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:43304 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726566AbgIVRkS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 22 Sep 2020 13:40:18 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 67CD022206;
        Tue, 22 Sep 2020 17:40:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1600796417;
        bh=JOfqNQHXsw1s8tCv0/lBWRfI1wukkc5VrTScuPcGrfs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=r6gYYwb5cvijvkdbiRleuucn6MlAKoQaygfpDRKzVEL4WF0GbA8rq0bSh8pGP1mOb
         h7+aQNuGwsJ60gQHJFFUMK7GvBjIMrPWhr3r0RyLea8+nWrCHeBMeCvcsDAu0Ar2f8
         eYm+qk8pYqzGGarMbEwRTQlWgyOKGG+sryqL5EbI=
Date:   Tue, 22 Sep 2020 10:40:15 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Awogbemila <awogbemila@google.com>
Cc:     netdev@vger.kernel.org, Catherine Sullivan <csully@google.com>,
        Yangchun Fu <yangchun@google.com>
Subject: Re: [PATCH net-next v2 3/3] gve: Add support for raw addressing in
 the tx path
Message-ID: <20200922104015.005cd8b2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200922155100.1624976-4-awogbemila@google.com>
References: <20200922155100.1624976-1-awogbemila@google.com>
        <20200922155100.1624976-4-awogbemila@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Sep 2020 08:51:00 -0700 David Awogbemila wrote:
> -static void gve_dma_sync_for_device(struct device *dev, dma_addr_t *page_buses,
> -				    u64 iov_offset, u64 iov_len)
> +static void gve_dma_sync_for_device(struct gve_priv *priv,
> +				    dma_addr_t *page_buses,
> +								u64 iov_offset, u64 iov_len)

Alignment stilled messed up here.
