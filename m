Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0F9838D91C
	for <lists+netdev@lfdr.de>; Sun, 23 May 2021 07:27:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231602AbhEWF26 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 23 May 2021 01:28:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:59700 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229895AbhEWF25 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 23 May 2021 01:28:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D768461152;
        Sun, 23 May 2021 05:27:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621747651;
        bh=yiYAcQgE9pZoEZlSXBQs9RZ6EsXFhPoeecgU4Qy12uY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=gQLipBR5jz8bI/f6WUK1HLA4t+BouxLxZeKdLoIrxb/IuKP3Wwmdb/EfCmVTdXYU3
         YJFotRzgzuq0oShtXPMb3a5SOfHGFU8AvxSAtFD1RvsGqvSLpPS7uzb8G142ndcW8Y
         ZBLThILs2lofx0jncfDQYrDDl+H5LB3HIy9jC3+G2m/a8edP6tOybCiXlzRFFW4+Xt
         eVZ2XWNtMh78hBlafWTuKb/AGFayz6d67Ylnkt/lSVfMRenfvDzTIVAlNJtaBENyPK
         bOxMYHlzpPGylROWcDTRZejqHcpdpqpxY7J3DJTqZBarTnWoaCV5uv9AruHiIN80AF
         +7yvsPSGHzgBA==
Date:   Sun, 23 May 2021 13:27:25 +0800
From:   Shawn Guo <shawnguo@kernel.org>
To:     Geert Uytterhoeven <geert+renesas@glider.be>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Thomas Bogendoerfer <tsbogend@alpha.franken.de>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-mips@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/5] ARM: dts: i.MX51: digi-connectcore-som: Correct
 Ethernet node name
Message-ID: <20210523052724.GX8194@dragon>
References: <cover.1621518686.git.geert+renesas@glider.be>
 <44eec3e8f638f3ac0a2b58ea52f3442a8f52a9a0.1621518686.git.geert+renesas@glider.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <44eec3e8f638f3ac0a2b58ea52f3442a8f52a9a0.1621518686.git.geert+renesas@glider.be>
User-Agent: Mutt/1.9.4 (2018-02-28)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 20, 2021 at 03:58:35PM +0200, Geert Uytterhoeven wrote:
> make dtbs_check:
> 
>     lan9221@5,0: $nodename:0: 'lan9221@5,0' does not match '^ethernet(@.*)?$'
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>

Applied, thanks.
