Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BCF3718BBB4
	for <lists+netdev@lfdr.de>; Thu, 19 Mar 2020 16:56:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgCSP4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Mar 2020 11:56:40 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:45372 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727217AbgCSP4h (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Mar 2020 11:56:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=ZJz4N7Rgl0GCXCgXC6auY2kWgcwx2uoJYwpH2ERvzXY=; b=Cvabbjprd2pB7jcDwtBtr9xckh
        IIskY+JbCG58YHI+KRdjQ+ounsavm2xI03wdmACbQR0o8JwbE5VSlD1yLazd+sT0LY69YXq0eiSx6
        YsyJTRex+1e+bMQB+2YRz5zX828s2lUyEVelr3k7wmKPOvmp76iZ1QocdEO5Pnr9HWL4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jExX5-0007XQ-Mb; Thu, 19 Mar 2020 16:56:31 +0100
Date:   Thu, 19 Mar 2020 16:56:31 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     sunil.kovvuri@gmail.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        leon@kernel.org, Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Subject: Re: [PATCH v3 net-next 4/8] octeontx2-vf: Ethtool support
Message-ID: <20200319155631.GC27807@lunn.ch>
References: <1584623248-27508-1-git-send-email-sunil.kovvuri@gmail.com>
 <1584623248-27508-5-git-send-email-sunil.kovvuri@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1584623248-27508-5-git-send-email-sunil.kovvuri@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 19, 2020 at 06:37:24PM +0530, sunil.kovvuri@gmail.com wrote:
> From: Tomasz Duszynski <tduszynski@marvell.com>
> 
> Added ethtool support for VF devices for
>  - Driver stats, Tx/Rx perqueue stats
>  - Set/show Rx/Tx queue count
>  - Set/show Rx/Tx ring sizes
>  - Set/show IRQ coalescing parameters
>  - RSS configuration etc
> 
> It's the PF which owns the interface, hence VF
> cannot display underlying CGX interface stats.
> Except for this rest ethtool support reuses PF's
> APIs.
> 
> Signed-off-by: Tomasz Duszynski <tduszynski@marvell.com>
> Signed-off-by: Sunil Goutham <sgoutham@marvell.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
