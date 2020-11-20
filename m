Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B3C562BAF13
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 16:37:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729874AbgKTPfE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 10:35:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:37730 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728957AbgKTPfE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 10:35:04 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 649C1238E6;
        Fri, 20 Nov 2020 15:35:03 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605886503;
        bh=cVXoeJ7zPrI0vo2s1Sit4wLvzm4IN6l0ADlP7on1Il4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=azvLZh7wUK1hKsh725P2opJ8sCSxcJnJVcTghNynSZ2tms0wg+foZTJKFoOLAkfZN
         o6Lc+7BdNLnylPgjrh/tLkoukSvcNPW6P83IoJIttxkoQIJExLaxVBYImgxxCW/uHh
         bKSc4uHpA5aLiNltg2CkabWwCUfd+wBY2l5Dlv90=
Date:   Fri, 20 Nov 2020 07:35:02 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tom Seewald <tseewald@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] cxbgb4: Fix build failure when CHELSIO_TLS_DEVICE=n
Message-ID: <20201120073502.4beeb482@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <CAARYdbivN7N-xwqvgq7pdyeY9UOBL=aGr97AHMsMP1TvR-3Qog@mail.gmail.com>
References: <20201116023140.28975-1-tseewald@gmail.com>
        <20201117142559.37e6847f@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAARYdbg+HsjCBu5vU=aHg-OU8L6u52RUBzrYUTuUMke6bXuV3g@mail.gmail.com>
        <20201119093719.15f19884@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
        <CAARYdbivN7N-xwqvgq7pdyeY9UOBL=aGr97AHMsMP1TvR-3Qog@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 00:54:00 -0600 Tom Seewald wrote:
> > Seems to me that CHELSIO_T4 should depend on (TLS || TLS=n), the
> > CONFIG_CHELSIO_TLS_DEVICE has the dependency but AFAICT nothing prevents
> > CONFIG_CHELSIO_TLS_DEVICE=m and CHELSIO_T4=y and cxgb4_main.c is under
> > the latter.  
> 
> You are right, adding (TLS || TLS=n) for CHELSIO_T4 resolves the build
> error I am encountering.

Great, please submit a patch.
