Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3E67C31BC14
	for <lists+netdev@lfdr.de>; Mon, 15 Feb 2021 16:17:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230363AbhBOPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Feb 2021 10:17:18 -0500
Received: from mo-csw1514.securemx.jp ([210.130.202.153]:37546 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229910AbhBOPQf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Feb 2021 10:16:35 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1514) id 11FFEGmx020588; Tue, 16 Feb 2021 00:14:16 +0900
X-Iguazu-Qid: 34tMYNXf5eaVJ6v6C8
X-Iguazu-QSIG: v=2; s=0; t=1613402056; q=34tMYNXf5eaVJ6v6C8; m=uM2REpR00LsJgIiw9Tu2w9j02BB6yi8SVQNTaJm7Slo=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1511) id 11FFEEml039740;
        Tue, 16 Feb 2021 00:14:15 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11FFEE1b020321;
        Tue, 16 Feb 2021 00:14:14 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11FFEDc6007524;
        Tue, 16 Feb 2021 00:14:14 +0900
Date:   Tue, 16 Feb 2021 00:14:13 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Leon Romanovsky <leon@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>, arnd@kernel.org,
        devicetree@vger.kernel.org, netdev@vger.kernel.org,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
X-TSB-HOP: ON
Message-ID: <20210215151413.oqq5o6kzhmhlnc5d@toshiba.co.jp>
References: <20210215050655.2532-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210215050655.2532-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <YCoPmfunGmu0E8IT@unreal>
 <20210215072809.n3r5rdswookzri6j@toshiba.co.jp>
 <YCo9WVvtAeozE42k@unreal>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <YCo9WVvtAeozE42k@unreal>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

On Mon, Feb 15, 2021 at 11:22:33AM +0200, Leon Romanovsky wrote:
> On Mon, Feb 15, 2021 at 04:28:09PM +0900, Nobuhiro Iwamatsu wrote:
> >
> > I have received your point out and have sent an email with the content
> > to remove this line. But it may not have arrived yet...
> >
> > > Why did you use "def_bool y" and not "default y"? Isn't it supposed to be
> > > "depends on STMMAC_ETH"? And probably it shouldn't be set as a default as "y".
> > >
> >
> > The reason why "def_bool y" was set is that the wrong fix was left when
> > debugging. Also, I don't think it is necessary to set "default y".
> > This is also incorrect because it says "bool" Toshiba Visconti DWMAC
> > support "". I change it to trustate in the new patch.
> >
> > And this driver is enabled when STMMAC_PLATFORM was Y. And STMMAC_PLATFORM
> > depends on STMMAC_ETH.
> > So I understand that STMMAC_ETH does not need to be dependents. Is this
> > understanding wrong?
> 
> This is correct understanding, just need to clean other entries in that
> Kconfig that depends on STMMAC_ETH.

OK, thanks.

Best regards,
  Nobuhiro
