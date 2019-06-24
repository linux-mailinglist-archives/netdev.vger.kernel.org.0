Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C49B451C4B
	for <lists+netdev@lfdr.de>; Mon, 24 Jun 2019 22:29:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731688AbfFXU27 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Jun 2019 16:28:59 -0400
Received: from vps.xff.cz ([195.181.215.36]:55264 "EHLO vps.xff.cz"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726393AbfFXU26 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Jun 2019 16:28:58 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=megous.com; s=mail;
        t=1561408136; bh=ebij2iMd2+jfNT2RnrG0rfsvu6bgvrUaIhcBD+2uT8k=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ez2ClL820tax9ruDyvFd7tjrHWXeaFMT3WQ70YRkAuZXuooYJaI0bHitWPVD4PtYk
         crqCMMgvP5GhR51NkheM4lNM8F0KrnDcTmtkA5LgSRKjeMhAxcb0fGDyr5mOsWO3XB
         s/6tcRDgFEoJpxyemaGnaucncUPtp060iDqxi4N0=
Date:   Mon, 24 Jun 2019 22:28:56 +0200
From:   =?utf-8?Q?Ond=C5=99ej?= Jirman <megous@megous.com>
To:     David Miller <davem@davemloft.net>
Cc:     linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com,
        wens@csie.org, robh+dt@kernel.org, jernej.skrabec@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, mark.rutland@arm.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
Subject: Re: [PATCH v7 0/6] Add support for Orange Pi 3
Message-ID: <20190624202856.ij4ujey2z6j5doxj@core.my.home>
Mail-Followup-To: David Miller <davem@davemloft.net>,
        linux-sunxi@googlegroups.com, maxime.ripard@bootlin.com,
        wens@csie.org, robh+dt@kernel.org, jernej.skrabec@gmail.com,
        airlied@linux.ie, daniel@ffwll.ch, mark.rutland@arm.com,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        dri-devel@lists.freedesktop.org, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com
References: <20190620134748.17866-1-megous@megous.com>
 <20190624.102927.1268781741493594465.davem@davemloft.net>
 <20190624174637.6sznc5ifiuh4c3sm@core.my.home>
 <20190624.132456.2013417744691373807.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20190624.132456.2013417744691373807.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 24, 2019 at 01:24:56PM -0700, David Miller wrote:
> From: Ondřej Jirman <megous@megous.com>
> Date: Mon, 24 Jun 2019 19:46:37 +0200
> 
> > This series was even longer before, with patches all around for various
> > maintainers. I'd expect that relevant maintainers pick the range of patches
> > meant for them. I don't know who's exactly responsible for what, but I think,
> > this should work:
> > 
> > - 2 stmmac patches should go together via some networking tree (is there
> >   something specific for stmmac?)
> > - all DTS patches should go via sunxi
> > - hdmi patches via some drm tree
> 
> Thank you.  So I'll merge the first two patches that touch the stmmac
> driver via my net-next tree.

Thank you.

regards,
	Ondrej
