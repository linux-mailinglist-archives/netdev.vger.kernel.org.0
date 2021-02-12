Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D80DB31A10A
	for <lists+netdev@lfdr.de>; Fri, 12 Feb 2021 16:04:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229977AbhBLPCA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 12 Feb 2021 10:02:00 -0500
Received: from mo-csw1116.securemx.jp ([210.130.202.158]:46234 "EHLO
        mo-csw.securemx.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229574AbhBLPB4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 12 Feb 2021 10:01:56 -0500
Received: by mo-csw.securemx.jp (mx-mo-csw1116) id 11CExO9r030513; Fri, 12 Feb 2021 23:59:24 +0900
X-Iguazu-Qid: 2wGrVxzyElBLa1Vwyu
X-Iguazu-QSIG: v=2; s=0; t=1613141964; q=2wGrVxzyElBLa1Vwyu; m=2QkLuNMlUJCxF7TouJ5hz1LlS63NCn+01MLR5NgKghM=
Received: from imx12.toshiba.co.jp (imx12.toshiba.co.jp [61.202.160.132])
        by relay.securemx.jp (mx-mr1110) id 11CExMnl023041;
        Fri, 12 Feb 2021 23:59:23 +0900
Received: from enc02.toshiba.co.jp ([61.202.160.51])
        by imx12.toshiba.co.jp  with ESMTP id 11CExMlt014544;
        Fri, 12 Feb 2021 23:59:22 +0900 (JST)
Received: from hop101.toshiba.co.jp ([133.199.85.107])
        by enc02.toshiba.co.jp  with ESMTP id 11CExL1P032581;
        Fri, 12 Feb 2021 23:59:21 +0900
Date:   Fri, 12 Feb 2021 23:59:20 +0900
From:   Nobuhiro Iwamatsu <nobuhiro1.iwamatsu@toshiba.co.jp>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        DTML <devicetree@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        punit1.agrawal@toshiba.co.jp, yuji2.ishikawa@toshiba.co.jp,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 4/4] arm: dts: visconti: Add DT support for Toshiba
 Visconti5 ethernet controller
X-TSB-HOP: ON
Message-ID: <20210212145920.lz24qi5orqrfjtza@toshiba.co.jp>
References: <20210212025806.556217-1-nobuhiro1.iwamatsu@toshiba.co.jp>
 <20210212025806.556217-5-nobuhiro1.iwamatsu@toshiba.co.jp>
 <CAK8P3a0Wycgn=Dq8KE+-F2keWj4mKaYQ=Y5RLefYn4gc71vVFw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAK8P3a0Wycgn=Dq8KE+-F2keWj4mKaYQ=Y5RLefYn4gc71vVFw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi,

Thanks for your review.

On Fri, Feb 12, 2021 at 10:32:09AM +0100, Arnd Bergmann wrote:
> On Fri, Feb 12, 2021 at 4:03 AM Nobuhiro Iwamatsu
> <nobuhiro1.iwamatsu@toshiba.co.jp> wrote:
> > @@ -384,6 +398,16 @@ spi6: spi@28146000 {
> >                         #size-cells = <0>;
> >                         status = "disabled";
> >                 };
> > +
> > +               piether: ethernet@28000000 {
> > +                       compatible = "toshiba,visconti-dwmac";
> 
> Shouldn't there be a more specific compatible string here, as well as the
> particular version of the dwmac you use?

I rechecked the code again based on your point.
I need to specify the version of dwmac. I also noticed that it could
remove some unnecessary code. I will fix this.

> 
> In the binding example, you list the device as "dma-coherent",
> but in this instance, it is not marked that way. Can you find out
> whether the device is in fact connected properly to a cache-coherent
> bus?
> 
> Note that failing to mark it as cache-coherent will make the device
> rather slow and possibly not work correctly if it is in fact coherent,
> but the default is non-coherent since a lot of SoCs are lacking
> that hardware support.

Thanks for point out.
This hardware does not require dma-coherent. I will remove dma-coherent from DT
binding document.

> 
>        Arnd
> 

Best regards,
  Nobuhiro
