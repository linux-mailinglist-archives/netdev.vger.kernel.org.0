Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E8BE10DEF
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:25:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726133AbfEAUZF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:25:05 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51488 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726077AbfEAUZF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:25:05 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=54Ibxew9eyxQN5lW440IVycH60bacny/xYlF2l1rNhk=; b=Xb97gUcHCZD9RGqGC5MTQXLhmx
        jhvPLYtR58AA02Kza9tI423Ah8WJC3Yl+R83sv97E3DAlQGPTUx1L+UAH/x+/gNWUEtvE4xseJsqC
        Q+jbfW8ZDZIOxr2VXqyOFbCutT1yUa1yEXjVbQuUvmaNCQ6XhPD0WTPe2S/meTGMSIrA=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvmm-0008Fn-SV; Wed, 01 May 2019 22:25:00 +0200
Date:   Wed, 1 May 2019 22:25:00 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: Re: [RFC PATCH 4/5] net: dsa: implement vtu_getnext and
 vtu_loadpurge for mv88e6250
Message-ID: <20190501202500.GE19809@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-5-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501193126.19196-5-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 07:32:13PM +0000, Rasmus Villemoes wrote:
> These are almost identical to the 6185 variants, but have fewer bits
> for the FID.
> 
> Bit 10 of the VTU_OP register (offset 0x05) is the VidPolicy bit,
> which one should probably preserve in mv88e6xxx_g1_vtu_op(), instead
> of always writing a 0. However, on the 6352 family, that bit is
> located at bit 12 in the VTU FID register (offset 0x02), and is always
> unconditionally cleared by the mv88e6xxx_g1_vtu_fid_write()
> function.
> 
> Since nothing in the existing driver seems to know or care about that
> bit, it seems reasonable to not add the boilerplate to preserve it for
> the 6250 (which would require adding a chip-specific vtu_op function,
> or adding chip-quirks to the existing one).
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
