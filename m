Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3BF17424B22
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 02:30:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232148AbhJGAcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Oct 2021 20:32:21 -0400
Received: from mail.kernel.org ([198.145.29.99]:53246 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230443AbhJGAcP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 Oct 2021 20:32:15 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F3AB161177;
        Thu,  7 Oct 2021 00:30:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1633566622;
        bh=JEPRVfWdoUQWUesQHU184NIpG6APbO2wbN7QxvDpKu0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=HV0yccoHA/nNEeiYwSxzEmXAXqLTtqRJWNwDpgwcWdNyA1vn/XMx3/vXQ/WyLvPuA
         Vx261cLkVVU5roWh577QDPJNqMQI8vx9I6rWkaFfeAjYsKFSP+7xJG3HLo5VdJWc4p
         GITh9ChlzTmAH01oyqrTi+BjucYNtP9Fkp3mrcO7Zo85LxvI2PuP10VP/+MZTTQQCm
         URPfBP267GwKVcfz/I7o5rCYzSFqQURMDV8Sr+KPF/buu1M9T70IKl2HBPZ12RMvqc
         xU+kb5hBdYYZGn3W/H73fopvB8lzOcZOGlKAZtnpvwYPrXJwgB/7f2SUTM3Lyk+VWV
         YfvaH41Kfj6mg==
Date:   Wed, 6 Oct 2021 17:30:21 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ioana Ciornei <ioana.ciornei@nxp.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        claudiu.manoil@nxp.com, vladimir.oltean@nxp.com
Subject: Re: [PATCH net-next 2/2] net: enetc: add support for software TSO
Message-ID: <20211006173021.1a76fee2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211006201308.2492890-3-ioana.ciornei@nxp.com>
References: <20211006201308.2492890-1-ioana.ciornei@nxp.com>
        <20211006201308.2492890-3-ioana.ciornei@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  6 Oct 2021 23:13:08 +0300 Ioana Ciornei wrote:
> +__wsum enetc_tso_hdr_csum(struct tso_t *tso, struct sk_buff *skb, char *hdr,
> +			  int hdr_len, int *l4_hdr_len)

> +void enetc_tso_complete_csum(struct enetc_bdr *tx_ring, struct tso_t *tso, struct sk_buff *skb,
> +			     char *hdr, int len, __wsum sum)

static x2
