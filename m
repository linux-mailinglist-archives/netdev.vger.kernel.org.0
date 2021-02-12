Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F215731977A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 01:32:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230360AbhBLAcW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Feb 2021 19:32:22 -0500
Received: from mo-csw1516.securemx.jp ([210.130.202.155]:44768 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229873AbhBLAcU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Feb 2021 19:32:20 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1516) id 11C0ToQX013725; Fri, 12 Feb 2021 09:29:50 +0900
X-Iguazu-Qid: 34tKPbYPQHjUA19Ax6
X-Iguazu-QSIG: v=2; s=0; t=1613089790; q=34tKPbYPQHjUA19Ax6; m=dzUXSzuhKQ+wtGPRe+35JT6KMgJujBv8YF8S0TMdf+U=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1513) id 11C0TmeK027141;
        Fri, 12 Feb 2021 09:29:49 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11C0Tmp0029266;
        Fri, 12 Feb 2021 09:29:48 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11C0TlAR032392;
        Fri, 12 Feb 2021 09:29:48 +0900
Date:   Fri, 12 Feb 2021 09:29:47 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     David Miller <davem@davemloft.net>
Cc:     kuba@kernel.org, robh+dt@kernel.org, peppe.cavallaro@st.com,
        alexandre.torgue@st.com, joabreu@synopsys.com,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/4] net: stmmac: Add Toshiba Visconti SoCs glue driver
X-TSB-HOP: ON
Message-ID: <20210212002947.j6l4vsdjq4vx4zum@toshiba.co.jp>
References: <20210210162954.3955785-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210210162954.3955785-3-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210211.141307.764092492929918552.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210211.141307.764092492929918552.davem@davemloft.net>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your comment.

On Thu, Feb 11, 2021 at 02:13:07PM -0800, David Miller wrote:
> From: Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
> Date: Thu, 11 Feb 2021 01:29:52 +0900
> 
> > +static int visconti_eth_init_hw(struct platform_device *pdev, struct plat_stmmacenet_data *plat_dat)
> > +{
> > +	struct visconti_eth *dwmac;
> > +	unsigned int reg_val, clk_sel_val;
> 
> Please use reverse christmas tree ordering for local variable declarations.
> 
> > +static int visconti_eth_clock_probe(struct platform_device *pdev,
> > +				    struct plat_stmmacenet_data *plat_dat)
> > +{
> > +	int err;
> > +	struct visconti_eth *dwmac;
> 
> Likewise.
> 
> > +static int visconti_eth_clock_remove(struct platform_device *pdev)
> > +{
> > +	struct net_device *ndev = platform_get_drvdata(pdev);
> > +	struct stmmac_priv *priv = netdev_priv(ndev);
> > +	struct visconti_eth *dwmac = get_stmmac_bsp_priv(&pdev->dev);
> Likewise.
> 

OK, I will fix these.

Best regards,
  Nobuhiro
