Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 05DE03B1F5D
	for <lists+netdev@lfdr.de>; Wed, 23 Jun 2021 19:25:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229881AbhFWR1d (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Jun 2021 13:27:33 -0400
Received: from mail.kernel.org ([198.145.29.99]:57496 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229523AbhFWR1c (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Jun 2021 13:27:32 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9F90460FEA;
        Wed, 23 Jun 2021 17:25:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1624469114;
        bh=bskff73XWWxpgTzfK/jxsxgtC9fuGF5fnf7xrQldBiQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=OCpB9iw5B9xMuFtds+/77jyu3PUVIeGnJOh7aSkDfU+i9UFz1z++SvqO0NMGZPQSR
         OozYnLZViLOVukzCYAa1vdB2QayAFjbBSjJsv4kORIzf+UJ8e2ihfvZQTRbqxw6mxP
         bSSNEYQ6uVLgacK5Tz4kieKkqjnjWjStQE5LzC9c=
Date:   Wed, 23 Jun 2021 19:25:11 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Rocco Yue <rocco.yue@mediatek.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Felix Fietkau <nbd@nbd.name>, John Crispin <john@phrozen.org>,
        Sean Wang <sean.wang@mediatek.com>,
        Mark Lee <Mark-MC.Lee@mediatek.com>, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, bpf@vger.kernel.org,
        wsd_upstream@mediatek.com, chao.song@mediatek.com,
        zhuoliang.zhang@mediatek.com, kuohong.wang@mediatek.com
Subject: Re: [PATCH 4/4] drivers: net: mediatek: initial implementation of
 ccmni
Message-ID: <YNNudzDzzx7ZBwf+@kroah.com>
References: <20210623113452.5671-1-rocco.yue@mediatek.com>
 <20210623113452.5671-4-rocco.yue@mediatek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210623113452.5671-4-rocco.yue@mediatek.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jun 23, 2021 at 07:34:52PM +0800, Rocco Yue wrote:
> +EXPORT_SYMBOL(ccmni_rx_push);

Why are you exporting symbols that are not used by anyone in this patch
series?  That doesn't feel right.  Who needs this?

> +EXPORT_SYMBOL(ccmni_hif_hook);

Same with this, who calls this?

> +++ b/drivers/net/ethernet/mediatek/ccmni/ccmni.h

Why do you have a .h file for a single .c file?  that shouldn't be
needed.

thanks,

greg k-h
