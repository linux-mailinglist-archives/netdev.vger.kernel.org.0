Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 390A32CD95
	for <lists+netdev@lfdr.de>; Tue, 28 May 2019 19:25:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726827AbfE1RZ4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 May 2019 13:25:56 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:36130 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbfE1RZz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 28 May 2019 13:25:55 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gh2+I8dFZc+qTvK8LM4KjXXs/DmXe2CijJfrbBulRew=; b=XL/lLtpDZiOfE/wysPvGMUydez
        yCGRSZozXW0K1P0Yy9SUvjuscK9pjwBCEa2fLl9sk2zmBca5dR+1bHzgWjbE7qEBq5iIKHVzl+bY3
        nKu62sioByRRe0u7RcIKo7glBsuwFstzfrfa8M1lv2DzOR6DxWMClmPU7z3c/XlCqaec=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hVfrB-0001G8-18; Tue, 28 May 2019 19:25:49 +0200
Date:   Tue, 28 May 2019 19:25:48 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Thierry Reding <thierry.reding@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Jon Hunter <jonathanh@nvidia.com>, netdev@vger.kernel.org,
        linux-tegra@vger.kernel.org
Subject: Re: [PATCH] net: stmmac: Do not output error on deferred probe
Message-ID: <20190528172548.GS18059@lunn.ch>
References: <20190527105251.11198-1-thierry.reding@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190527105251.11198-1-thierry.reding@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 27, 2019 at 12:52:51PM +0200, Thierry Reding wrote:
> From: Thierry Reding <treding@nvidia.com>
> 
> If the subdriver defers probe, do not show an error message. It's
> perfectly fine for this error to occur since the driver will get another
> chance to probe after some time and will usually succeed after all of
> the resources that it requires have been registered.
> 
> Signed-off-by: Thierry Reding <treding@nvidia.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
