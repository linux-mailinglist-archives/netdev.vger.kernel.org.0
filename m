Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B57B06CEF81
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 18:34:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229799AbjC2Qe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 12:34:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229518AbjC2Qe0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 12:34:26 -0400
Received: from vps0.lunn.ch (vps0.lunn.ch [156.67.10.101])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11D659E;
        Wed, 29 Mar 2023 09:34:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=lVJeQXAAkUcIEbt/RzgMtWzPHAS6fEs3vnlZ41+68Nw=; b=GVU2fl2ATLxLurLW6y/vQZRGzO
        KqOUPhIaIZXJRgx9Y+NAGI8GoQZiFki06kjKN0BZArTmQ2vI49J964ibHCGZQC2ca8g9CsIOFku11
        J7tapOpscTKFM5DxVyE9l1l6QdhGRw7y+gVben5jsr8GK1reahdlG2/Kh+k0UQJfQdGc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1phYke-008mZ1-5u; Wed, 29 Mar 2023 18:34:20 +0200
Date:   Wed, 29 Mar 2023 18:34:20 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Daniel Golle <daniel@makrotopia.org>
Cc:     netdev@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        AngeloGioacchino Del Regno 
        <angelogioacchino.delregno@collabora.com>,
        Sean Wang <sean.wang@mediatek.com>,
        Landen Chao <Landen.Chao@mediatek.com>,
        DENG Qingfang <dqfext@gmail.com>,
        Philipp Zabel <p.zabel@pengutronix.de>,
        Sam Shih <Sam.Shih@mediatek.com>,
        Lorenzo Bianconi <lorenzo@kernel.org>,
        John Crispin <john@phrozen.org>, Felix Fietkau <nbd@nbd.name>
Subject: Re: [RFC PATCH net-next v3 07/15] net: dsa: mt7530: introduce
 mt7530_probe_common helper function
Message-ID: <caaab39c-96ae-4f64-9153-5168c306df69@lunn.ch>
References: <cover.1680105013.git.daniel@makrotopia.org>
 <d5147ef8738c1425fdd4fb351c1f3d98786fc19f.1680105013.git.daniel@makrotopia.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d5147ef8738c1425fdd4fb351c1f3d98786fc19f.1680105013.git.daniel@makrotopia.org>
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 29, 2023 at 04:58:50PM +0100, Daniel Golle wrote:
> Move commonly used parts from mt7530_probe into new mt7530_probe_common
> helper function which will be used by both, mt7530_probe and the
> to-be-introduced mt7988_probe.
> 
> Signed-off-by: Daniel Golle <daniel@makrotopia.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
