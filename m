Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 45DFA38E685
	for <lists+netdev@lfdr.de>; Mon, 24 May 2021 14:24:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232486AbhEXM0O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 May 2021 08:26:14 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53740 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232300AbhEXM0M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 May 2021 08:26:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=n2kQUhfV6YRDTp0g7hvQZxqk2aG/kyfLlpWBKCO9/58=; b=oGuq7Yg4t4YsNo7s2JC9P87oaz
        ra8J2s3erjzFdTGY4bLBCj5znxigN65jXikdISsbpv+YJdhUZriH+pj87Xy31k2+iTHuZXKWL+lE9
        ayKasHLLa5tOysJPFnfWEQNk2f6E/k2gfqPmassBqaj8jLDLpemxjRMfKZAQYhoO71Vc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1ll9dP-005wOa-4L; Mon, 24 May 2021 14:24:39 +0200
Date:   Mon, 24 May 2021 14:24:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] net: r6040: Allow restarting auto-negotiation
Message-ID: <YKubB327R0W0HLeh@lunn.ch>
References: <20210523155843.11395-1-f.fainelli@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210523155843.11395-1-f.fainelli@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 23, 2021 at 08:58:42AM -0700, Florian Fainelli wrote:
> Use phy_ethtool_nway_reset() since the driver makes use of the PHY
> library.
> 
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
