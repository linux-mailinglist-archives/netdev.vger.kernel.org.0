Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 541E229A2F0
	for <lists+netdev@lfdr.de>; Tue, 27 Oct 2020 04:06:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2437177AbgJ0DGt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Oct 2020 23:06:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:50622 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2437086AbgJ0DGt (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 26 Oct 2020 23:06:49 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 96EFB2151B;
        Tue, 27 Oct 2020 03:06:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603768008;
        bh=+iDp6qGbupqnPeHLiPOQ4jGGEsxVPDaHzfEp/5i5qNY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HCsnwhxLxrF/z65WpDtJGj9olkTBwiPJNDBfp6PAB4dqShk4SV2RdPHsBYlDMCw+Z
         KpForSNsrZOwDSIme8N9a83a7847SkU5yka6ZU9J0X0PCZd5/NRulVeH5mgoEWUPwl
         wAkWYdeCBQo5+HKdK2nRSLlIBQpMRo6lK+nRrh5o=
Date:   Mon, 26 Oct 2020 20:06:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mark Brown <broonie@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        "Jonathan Corbet" <corbet@lwn.net>, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH RESEND 3/3] net: core: fix some kernel-doc markups
Message-ID: <20201026200646.50dbb231@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <492b5ee3aca655ffad6e95e61d9b4019e69b8e3a.1603705472.git.mchehab+huawei@kernel.org>
References: <cover.1603705472.git.mchehab+huawei@kernel.org>
        <492b5ee3aca655ffad6e95e61d9b4019e69b8e3a.1603705472.git.mchehab+huawei@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 26 Oct 2020 10:47:38 +0100 Mauro Carvalho Chehab wrote:
> Some identifiers have different names between their prototypes
> and the kernel-doc markup.
> 
> In the specific case of netif_subqueue_stopped(), keep the
> current markup for __netif_subqueue_stopped(), adding a
> new one for netif_subqueue_stopped().
> 
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

> @@ -3590,6 +3590,13 @@ static inline bool __netif_subqueue_stopped(const struct net_device *dev,
>  	return netif_tx_queue_stopped(txq);
>  }
>  
> +/**
> + *	netif_subqueue_stopped - test status of subqueue
> + *	@dev: network device
> + *	@skb: sub queue buffer pointer

Ah, no: "socket buffer from which to get the mapping"

> + *
> + * Check individual transmit queue of a device with multiple transmit queues.
> + */
>  static inline bool netif_subqueue_stopped(const struct net_device *dev,
>  					  struct sk_buff *skb)
>  {

