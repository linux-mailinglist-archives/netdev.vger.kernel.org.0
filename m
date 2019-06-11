Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F07CE4181C
	for <lists+netdev@lfdr.de>; Wed, 12 Jun 2019 00:25:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391012AbfFKWZm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 Jun 2019 18:25:42 -0400
Received: from vps.xff.cz ([195.181.215.36]:41794 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2389575AbfFKWZl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 Jun 2019 18:25:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1560291939; bh=u1xRqcipnjQfdrJT1iMxqmCOWzuFT5iSpjmBJ/NwAng=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iUogNK2F3RyjngMx4djQtjKewbxnn+Nvf/e84Jaqj+b4bz0KfhOo3Ucmsc62ArP91
         AnN9RXuB+r50eNOnii91OJYHduVuqj5nTyOUHPDIYkXghBU6tFTYtNYz9GqOvxApED
         F0Y3GKdyuZXdNlSiqbjhmi4AahsEzFRbhTeWdtDA=
Date:   Wed, 12 Jun 2019 00:25:39 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     Rob Herring <robh@kernel.org>
Cc:     Mark Rutland <mark.rutland@arm.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        Chen-Yu Tsai <wens@csie.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        linux-sunxi@googlegroups.com, Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
Subject: Re: [PATCH v6 4/6] dt-bindings: display: hdmi-connector: Support DDC
 bus enable
Message-ID: <20190611222539.msviqrbptjd5vdji@core.my.home>
Mail-Followup-To: Rob Herring <robh@kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        devicetree@vger.kernel.org,
        Maxime Ripard <maxime.ripard@bootlin.com>, netdev@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        Chen-Yu Tsai <wens@csie.org>, dri-devel@lists.freedesktop.org,
        linux-kernel@vger.kernel.org, David Airlie <airlied@linux.ie>,
        linux-sunxi@googlegroups.com, Jose Abreu <joabreu@synopsys.com>,
        linux-arm-kernel@lists.infradead.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>
References: <20190527162237.18495-1-megous@megous.com>
 <20190527162237.18495-5-megous@megous.com>
 <20190611215206.GA17759@bogus>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190611215206.GA17759@bogus>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 11, 2019 at 03:52:06PM -0600, Rob Herring wrote:
> On Mon, 27 May 2019 18:22:35 +0200, megous@megous.com wrote:
> > From: Ondrej Jirman <megous@megous.com>
> > 
> > Some Allwinner SoC using boards (Orange Pi 3 for example) need to enable
> > on-board voltage shifting logic for the DDC bus using a gpio to be able
> > to access DDC bus. Use ddc-en-gpios property on the hdmi-connector to
> > model this.
> > 
> > Add binding documentation for optional ddc-en-gpios property.
> > 
> > Signed-off-by: Ondrej Jirman <megous@megous.com>
> > ---
> >  .../devicetree/bindings/display/connector/hdmi-connector.txt     | 1 +
> >  1 file changed, 1 insertion(+)
> > 
> 
> Please add Acked-by/Reviewed-by tags when posting new versions. However,
> there's no need to repost patches *only* to add the tags. The upstream
> maintainer will do that for acks received on the version they apply.
> 
> If a tag was not added on purpose, please state why and what changed.

Sorry, it was some mistake. Thanks for the note.

regards,
	Ondrej

> _______________________________________________
> linux-arm-kernel mailing list
> linux-arm-kernel@lists.infradead.org
> http://lists.infradead.org/mailman/listinfo/linux-arm-kernel
