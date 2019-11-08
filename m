Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 11F7EF4D22
	for <lists+netdev@lfdr.de>; Fri,  8 Nov 2019 14:27:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727558AbfKHN1j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 Nov 2019 08:27:39 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:56596 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726445AbfKHN1j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 8 Nov 2019 08:27:39 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=B+CjZNtDxgYcTtUeBCepTN3AXfAd9eK73+AzIlkpkpc=; b=K5oGszEEx2GiOPobgLQh1L97pW
        ngyE8tntoO3jNpcehACfC0EKPCjYzXtY4jX6iZ8OIUlBI/kmkxZsqin3vr+qUN3NNeYGqv5hiz/py
        amZHA8LB5iS0pyfidzE6gS/zoOnx9fRS5p1c2mG+rt9D3Ikci+wACWEMpBtAII/nqnYY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iT4IZ-0006cL-KK; Fri, 08 Nov 2019 14:27:35 +0100
Date:   Fri, 8 Nov 2019 14:27:35 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Michael Walle <michael@walle.cc>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Claudiu Manoil <claudiu.manoil@nxp.com>
Subject: Re: [PATCH] enetc: fix return value for enetc_ioctl()
Message-ID: <20191108132735.GH22978@lunn.ch>
References: <20191107235821.12767-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191107235821.12767-1-michael@walle.cc>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 08, 2019 at 12:58:21AM +0100, Michael Walle wrote:
> Return -EOPNOTSUPP instead of -EINVAL if the requested ioctl is not
> implemented.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
