Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F266C438B79
	for <lists+netdev@lfdr.de>; Sun, 24 Oct 2021 20:41:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231684AbhJXSn6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 24 Oct 2021 14:43:58 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:55848 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229638AbhJXSn4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 24 Oct 2021 14:43:56 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=bywBeCUbzSk1obZbn8iBE4to/B32LlUEaB6YAeFC7uM=; b=SRyDJelbZYGIF3lxvOLaausDx7
        Kn6KSdnpH4W54A2rBSNU51oZ1ItN475EuPVGTHCMNZ8JNlVOfW8MAbv+aDn7thmcUckw6yEDbaSuT
        4iyemfq23XoJO5nEZdamVqw98afXfLef2d5JlpfiTX7mM/3zmCLarXN8hOQNfFLqZwqQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1meiR1-00Ba4K-Lr; Sun, 24 Oct 2021 20:41:31 +0200
Date:   Sun, 24 Oct 2021 20:41:31 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Luo Jie <luoj@codeaurora.org>
Cc:     hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, sricharan@codeaurora.org
Subject: Re: [PATCH v7 13/14] net: phy: adjust qca8081 master/slave seed
 value if link down
Message-ID: <YXWo27cqPMIgZlLp@lunn.ch>
References: <20211024082738.849-1-luoj@codeaurora.org>
 <20211024082738.849-14-luoj@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211024082738.849-14-luoj@codeaurora.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 24, 2021 at 04:27:37PM +0800, Luo Jie wrote:
> 1. The master/slave seed needs to be updated when the link can't
> be created.
> 
> 2. The case where two qca8081 PHYs are connected each other and
> master/slave seed is generated as the same value also needs
> to be considered, so adding this code change into read_status
> instead of link_change_notify.
> 
> Signed-off-by: Luo Jie <luoj@codeaurora.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
