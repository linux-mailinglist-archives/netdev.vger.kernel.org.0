Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E3AB531B4E3
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 05:53:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229952AbhBOEw1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 14 Feb 2021 23:52:27 -0500
Received: from mo-csw1114.securemx.jp ([210.130.202.156]:42956 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229783AbhBOEwZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 14 Feb 2021 23:52:25 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1114) id 11F4o2iF008575; Mon, 15 Feb 2021 13:50:02 +0900
X-Iguazu-Qid: 2wGqsXjpwITRbgu6E9
X-Iguazu-QSIG: v=2; s=0; t=1613364601; q=2wGqsXjpwITRbgu6E9; m=SFm3NhKjBkIuojeahLC/t1YyOdGciL7xA5U48TQkS6w=
Received: from imx2.toshiba.co.jp (imx2.toshiba.co.jp [106.186.93.51])
        by relay.securemx.jp (mx-mr1113) id 11F4nxxr027709;
        Mon, 15 Feb 2021 13:50:00 +0900
Received: from enc01.toshiba.co.jp ([106.186.93.100])
        by imx2.toshiba.co.jp  with ESMTP id 11F4nx2A005861;
        Mon, 15 Feb 2021 13:49:59 +0900 (JST)
Received: from hop001.toshiba.co.jp ([133.199.164.63])
        by enc01.toshiba.co.jp  with ESMTP id 11F4nxWi016628;
        Mon, 15 Feb 2021 13:49:59 +0900
Date:   Mon, 15 Feb 2021 13:49:57 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, punit1.agrawal@toshiba.co.jp,
        yuji2.ishikawa@toshiba.co.jp, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
X-TSB-HOP: ON
Message-ID: <20210215044957.kdrmzgpqfiblermc@toshiba.co.jp>
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210212025806.556217-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YCjB3btP5+h4pISJ@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCjB3btP5+h4pISJ@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Sun, Feb 14, 2021 at 08:23:25AM +0200, Leon Romanovsky wrote:
> On Fri, Feb 12, 2021 at 11:58:04AM +0900, Nobuhiro Iwamatsu wrote:
> > Add dwmac-visconti to the stmmac driver in Toshiba Visconti ARM SoCs.
> > This patch contains only the basic function of the device. There is no
> > clock control, PM, etc. yet. These will be added in the future.
> >
> > Signed-off-by: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> > ---
> >  drivers/net/ethernet/stmicro/stmmac/Kconfig   |   8 +
> >  drivers/net/ethernet/stmicro/stmmac/Makefile  |   1 +
> >  .../ethernet/stmicro/stmmac/dwmac-visconti.c  | 288 ++++++++++++++++++
> >  3 files changed, 297 insertions(+)
> >  create mode 100644 drivers/net/ethernet/stmicro/stmmac/dwmac-visconti.c
> >
> > diff --git a/drivers/net/ethernet/stmicro/stmmac/Kconfig b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > index 53f14c5a9e02..55ba67a550b9 100644
> > --- a/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > +++ b/drivers/net/ethernet/stmicro/stmmac/Kconfig
> > @@ -219,6 +219,14 @@ config DWMAC_INTEL_PLAT
> >  	  This selects the Intel platform specific glue layer support for
> >  	  the stmmac device driver. This driver is used for the Intel Keem Bay
> >  	  SoC.
> > +
> > +config DWMAC_VISCONTI
> > +	bool "Toshiba Visconti DWMAC support"
> > +	def_bool y
> 
> Doesn't it need to be "default y"?
> 

Indeed. I will remove this.

Thanks.

Best regards,
  Nobuhiro
