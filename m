Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C7448EE11D
	for <lists+netdev@lfdr.de>; Mon,  4 Nov 2019 14:29:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727998AbfKDN3Q (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 4 Nov 2019 08:29:16 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:47948 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727236AbfKDN3Q (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 4 Nov 2019 08:29:16 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=9Gp/NL2eqrz4dZTYKIyJt3+G0Admp4hdFnQ7Fk2dmTM=; b=LPjPliLvex0zTOMDvFoEY0Gvkv
        YZsfKjzGxFDu1X/mYlnN1XOmZDbxgE6PE+X3oQDt55b6uu9lW5qwii45CAj0s+g6zfwjCTQMi8W+f
        ItwJ5NY6SXnTmJuECTsCKybG0Oc0fBRIbNtlDjSXweTwwmKCinrXR9/Du53xNJEgYjvo=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iRcPy-0004Of-0m; Mon, 04 Nov 2019 14:29:14 +0100
Date:   Mon, 4 Nov 2019 14:29:14 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, dan.carpenter@oracle.com
Subject: Re: [PATCH v2 net-next] net: of_get_phy_mode: Change API to solve
 int/unit warnings
Message-ID: <20191104132914.GA16834@lunn.ch>
References: <20191101220756.2626-1-andrew@lunn.ch>
 <20191103.192601.443764119268490765.davem@davemloft.net>
 <20191103.194409.422094551811274424.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191103.194409.422094551811274424.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Nov 03, 2019 at 07:44:09PM -0800, David Miller wrote:
> From: David Miller <davem@davemloft.net>
> Date: Sun, 03 Nov 2019 19:26:01 -0800 (PST)
> 
> > Applied, thanks Andrew.
> 
> I tried to fix some of the allmodconfig build fallout but it just kept
> piling up.  Can you fix this and resubmit?  Thanks.

Hi David

Please try v3 i posted last night, fixing what 0-day found.

       Andrew
