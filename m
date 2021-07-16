Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 35D113CB9E0
	for <lists+netdev@lfdr.de>; Fri, 16 Jul 2021 17:33:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240780AbhGPPfx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 16 Jul 2021 11:35:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:58598 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240282AbhGPPfn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 16 Jul 2021 11:35:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=CGZsktWNeZSP9brVnhmnumOVvSpPdBAXCv4lSMGQFv4=; b=KDq8NTcR/64IPQfgHMHGx8OrHD
        PNyK6GiKo91ZMVNnntywFZG0QY/Lodr5w7nLMsFGrpQAnUZiyupr5iPpE183n16ThEiW298hbqzcC
        AJjNi30BG7gEfdXUxvVZfmc1aa8+DJB033ckQYU3xAI2dz05S/s0FNuoiDZXpVAVuVXI=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m4PpF-00DdAs-N5; Fri, 16 Jul 2021 17:32:29 +0200
Date:   Fri, 16 Jul 2021 17:32:29 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     ericwouds@gmail.com
Cc:     Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Eric Woudstra <37153012+ericwoud@users.noreply.github.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7530 fix mt7530_fdb_write vid missing ivl bit
Message-ID: <YPGmjd1ODFQ+ZIE2@lunn.ch>
References: <20210716152213.4213-1-ericwouds@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210716152213.4213-1-ericwouds@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 16, 2021 at 05:22:11PM +0200, ericwouds@gmail.com wrote:
> From: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>
> 
> According to reference guides mt7530 (mt7620) and mt7531:
> 
> NOTE: When IVL is reset, MAC[47:0] and FID[2:0] will be used to 
> read/write the address table. When IVL is set, MAC[47:0] and CVID[11:0] 
> will be used to read/write the address table.
> 
> Since the function only fills in CVID and no FID, we need to set the
> IVL bit. The existing code does not set it.
> 
> This is a fix for the issue I dropped here earlier:
> 
> http://lists.infradead.org/pipermail/linux-mediatek/2021-June/025697.html
> 
> With this patch, it is now possible to delete the 'self' fdb entry
> manually. However, wifi roaming still has the same issue, the entry
> does not get deleted automatically. Wifi roaming also needs a fix
> somewhere else to function correctly in combination with vlan.
> 
> Signed-off-by: Eric Woudstra <37153012+ericwoud@users.noreply.github.com>

Hi Eric

We need a real email address in the Signed-off-by, and the noreply bit
makes me think this will not work.

      Andrew
