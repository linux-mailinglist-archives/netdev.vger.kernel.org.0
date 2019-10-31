Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1ED93EB882
	for <lists+netdev@lfdr.de>; Thu, 31 Oct 2019 21:42:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729787AbfJaUmI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 31 Oct 2019 16:42:08 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:33917 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729777AbfJaUmI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 31 Oct 2019 16:42:08 -0400
Received: by mail-wr1-f65.google.com with SMTP id e6so5889953wrw.1
        for <netdev@vger.kernel.org>; Thu, 31 Oct 2019 13:42:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:content-transfer-encoding:in-reply-to
         :user-agent;
        bh=ewVs5CtQ7DC3g05WS9zawrxD8UKXFocxlzIj1rs+CGo=;
        b=u0ihDxayWOgyQVQJ0HnyyQV8MdcVTSlc9z0upUFnL4td3Vz2c+ZDBdgZV+FbOVvTKB
         KyicvBpvnE+gPjSNYOdE42ZCZimvwATHdZ0sREgteu4D1Vy2P/PLH1EujlUy3uU2YH0u
         Ql87qI3xi74tVhTE2Hp4tNZOA4nforHEDVnKL9xidnEv7OBTGuOmJHfp4ki++RQYnJ62
         tA9BsUqpb8FG3LxSLtnA4zsIBkAnANjIV0eO+jIbKTda3Uef/jtfp1arlnLoCUZB+KAJ
         o8N+NHjrKPbc0yHkNaX1jlHHZGT85UoMEFRIt0LymlKx7Xk9kyvCM9LMMFF95+MSZi2i
         2ytg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to:user-agent;
        bh=ewVs5CtQ7DC3g05WS9zawrxD8UKXFocxlzIj1rs+CGo=;
        b=mSJSQa3gSG95eCOUioWrcmAjUt81kDMg4dC2jRsH0LzkQZOi1Fg/LNsnThrkbz0hIN
         8NuUZRfK0ym2WVQe7w0WWuzoJCLptbJZbAXQoDr2opE4FbQAc4qECnjuhdhiCmScb58K
         eT5t+r8UWmOpVFNHuYGxOg2CK35X0dDWBSJUfyJG06/7JbqZGIhIBqMNJIlSTz/ooebh
         +HvRQZ7jc71jfSHkXsIXyVcibZKC0EaBkdPfB+6IieM1wTTdKtsUxEGyCmfofUGI8aPl
         mA5i0GPHKnln//kF9X0sPhvGwnCgwGjpl7bBNYSVQaEoFH05ooptW81m9+qXr/AwU9eJ
         Sysg==
X-Gm-Message-State: APjAAAWeKrrvkV6wuCKZJQiLe8SSMrimpQ6OZluX9JnylV4uQsmdV17s
        qjkgdezfek888OP0WUgAzX+AsQ==
X-Google-Smtp-Source: APXvYqytoC1inlbhKyAShJk2vZ4/FrApDyUfeDB8ENq8oN9Tzf1PWk1mBfwKPUqV/Nn6LHUv3NjgQg==
X-Received: by 2002:adf:9044:: with SMTP id h62mr7744773wrh.91.1572554525976;
        Thu, 31 Oct 2019 13:42:05 -0700 (PDT)
Received: from netronome.com (fred-musen.rivierenbuurt.horms.nl. [2001:470:7eb3:404:a2a4:c5ff:fe4c:9ce9])
        by smtp.gmail.com with ESMTPSA id l4sm7047929wrf.46.2019.10.31.13.42.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 31 Oct 2019 13:42:05 -0700 (PDT)
Date:   Thu, 31 Oct 2019 21:42:03 +0100
From:   Simon Horman <simon.horman@netronome.com>
To:     Jiaxun Yang <jiaxun.yang@flygoat.com>
Cc:     linux-mips@vger.kernel.org, davem@davemloft.net,
        robh+dt@kernel.org, mark.rutland@arm.com, axboe@kernel.dk,
        peppe.cavallaro@st.com, alexandre.torgue@st.com,
        joabreu@synopsys.com, bhelgaas@google.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-ide@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 4/5] dt-bindings: net: document loongson.pci-gmac
Message-ID: <20191031204202.GB30739@netronome.com>
References: <20191030135347.3636-1-jiaxun.yang@flygoat.com>
 <20191030135347.3636-5-jiaxun.yang@flygoat.com>
 <20191031083509.GA30739@netronome.com>
 <a93eedb9-8863-3802-a563-fe4955d846c3@flygoat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <a93eedb9-8863-3802-a563-fe4955d846c3@flygoat.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 31, 2019 at 06:57:16PM +0800, Jiaxun Yang wrote:
> 
> 在 2019/10/31 下午4:35, Simon Horman 写道:
> > Hi Jiaxun,
> > 
> > thanks for your patch.
> > 
> > On Wed, Oct 30, 2019 at 09:53:46PM +0800, Jiaxun Yang wrote:
> > > This binding will provide extra information for PCI enabled
> > > device.
> > > 
> > > Signed-off-by: Jiaxun Yang <jiaxun.yang@flygoat.com>
> > Please verify the bindings using dtbs_check as described in
> > Documentation/devicetree/writing-schema.rst
> > 
> > > ---
> > >   .../net/wireless/loongson,pci-gmac.yaml       | 71 +++++++++++++++++++
> > >   1 file changed, 71 insertions(+)
> > >   create mode 100644 Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> > > 
> > > diff --git a/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> > > new file mode 100644
> > > index 000000000000..5f764bd46735
> > > --- /dev/null
> > > +++ b/Documentation/devicetree/bindings/net/wireless/loongson,pci-gmac.yaml
> > > @@ -0,0 +1,71 @@
> > > +# SPDX-License-Identifier: GPL-2.0
> > > +%YAML 1.2
> > > +---
> > > +$id: http://devicetree.org/schemas/net/allwinner,sun7i-a20-gmac.yaml#
> > The id does not match the filename of the schema.
> > 
> > i.e. the above should be:
> > 
> > 	$id: http://devicetree.org/schemas/net/wireless/loongson,pci-gmac.yaml#
> > 
> > > +$schema: http://devicetree.org/meta-schemas/core.yaml#
> > > +
> > > +title: Loongson PCI GMAC Device Tree Bindings
> > > +
> > > +allOf:
> > > +  - $ref: "snps,dwmac.yaml#"
> > snps,dwmac.yaml# is in the parent directory relative to loongson,pci-gmac.yaml.
> > So I think the above needs to be:
> > 
> > 	$ref: "../snps,dwmac.yaml#"
> > 
> > > +
> > > +maintainers:
> > > +  - Jiaxun Yang <jiaxun.yang@flygoat.com>
> > > +
> > > +properties:
> > > +  compatible:
> > > +    const: loongson,pci-gmac
> > > +
> > > +  reg:
> > > +    maxItems: 1
> > > +
> > > +  interrupts:
> > > +    minItems: 1
> > > +    maxItems: 3
> > > +    items:
> > > +      - description: Combined signal for various interrupt events
> > > +      - description: The interrupt to manage the remote wake-up packet detection
> > > +      - description: The interrupt that occurs when Rx exits the LPI state
> > > +
> > > +  interrupt-names:
> > > +    minItems: 1
> > > +    maxItems: 3
> > > +    items:
> > > +      - const: macirq
> > > +      - const: eth_wake_irq
> > > +      - const: eth_lpi
> > > +
> > > +  clocks:
> > > +    items:
> > > +      - description: GMAC main clock
> > > +
> > > +  clock-names:
> > > +    items:
> > > +      - const: stmmaceth
> > > +
> > > +required:
> > > +  - compatible
> > > +  - reg
> > > +  - interrupts
> > > +  - interrupt-names
> > > +  - clocks
> > > +  - clock-names
> > > +  - phy-mode
> > > +
> > > +examples:
> > > +  - |
> > > +    gmac: ethernet@ {
> > I would have expected a bus address here, f.e.:
> > 
> > 	gmac: ethernet@0x00001800
> > 
> > > +        compatible = "loongson,pci-irq";
> > > +        reg = <0x00001800 0 0 0 0>;
> > I think there is one to many cell in the above, perhaps it should be.
> > 
> > 	reg = <0x00001800 0 0 0>;
> > 
> > Also, I would expect the registers to be wider than 0, i.e. no registers.
> 
> Hi Simon,
> 
> Thanks for your suggestions above, will fix in v1.
> 
> Here, the reg domain is a standard 5-cell representing a PCI device,
> 
> See: Documentation/devicetree/bindings/pci/pci.txt and IEEE Std 1275-1994,<https://github.com/torvalds/linux/blob/master/Documentation/devicetree/bindings/pci/pci.txt>
> 
> Should I add some description?

Thanks, sorry for missing that.
As that is the case I think you need something like the following
as an example that compiles.

examples:
  - |
    pcie@0 {
        reg = <0 0 0 0>;
        #size-cells = <2>;
        #address-cells = <3>;
        ranges = <0 0 0 0 0 0>;
        device_type = "pci";

        gmac: ethernet@1800 {
            compatible = "loongson,pci-irq";
            reg = <0x00001800 0 0 0 0>;
            interrupts = <12>, <13>;
            interrupt-names = "macirq", "eth_lpi";
            clocks =  <&clk_pch_gmac>;
            clock-names = "stmmaceth";
            phy-mode = "rgmii";
        };
    };





