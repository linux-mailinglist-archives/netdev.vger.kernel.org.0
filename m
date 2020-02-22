Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DFBFD168ED1
	for <lists+netdev@lfdr.de>; Sat, 22 Feb 2020 13:26:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727259AbgBVMZu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Feb 2020 07:25:50 -0500
Received: from mail-ed1-f67.google.com ([209.85.208.67]:35841 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726763AbgBVMZu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Feb 2020 07:25:50 -0500
Received: by mail-ed1-f67.google.com with SMTP id j17so5903038edp.3;
        Sat, 22 Feb 2020 04:25:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/Y50RHD2QGihstG7fjd8c2NdZnfKYGCwsRvJsD3a51U=;
        b=NhTbOsAtlr89Xk/roSZUnzFyZi5buN3T9l38N0HrufP0cibwbgBJAtd3Y6AwlCm2H4
         RhzUVdn6aK6roKwiZuRD6a6mQ6b6K7MdCI3UGhk/0trmFnf9vnNzDjFhTo2wsFgy1l8x
         yujA86FhM08935s665nOaSZB5pgb3+HjNlnPQyCseTvVPOldvQgQmuxY0/C4syo+Qlmw
         SvpcKC832vgrQLLbEHYpP7qUChKzkzBlizGq9uAQonHYQCdyulva0IyA/SOW51d01veR
         /KRKZxsBRRM9cfuODq3hZH+O3r/UI/1dSDADAkxc7imMvh9rjJ1GMoca0tHYb+y4k7kP
         19ZA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/Y50RHD2QGihstG7fjd8c2NdZnfKYGCwsRvJsD3a51U=;
        b=n5NMSLPTHvhAAWTobjpYP5hVN/T5s909xLXuJc/dBfXB4+8t6orAobukmh0waxn1N3
         QjxBhr72KzC/5pc5knNWT4fxHkR/HBNsjLVpoytRdwfp90/k0O0wdOUxFj53zhjjQHAM
         s6dUydgVCzyo2i9t6HZvxIZmvqkRX+tBWjWIh/IV19ekQJDPOv7rEai4IN7b6iNI3Qp3
         XeM9I06pQOmf1p2JQKthk/lN7nT3aoPuif7K7/tJUm9izRXUsHxtsC8BpUy0Yhtu+0+W
         50Munqyh/62Ejb/T+JDApdL0yqB4+Xe5cNMI2nN0DVVz1k5fi4XhH9pNHlgYa3mZvlOR
         vDCw==
X-Gm-Message-State: APjAAAWpGSDD9r6qGy7Hp/l1stZn0beV4BsCa3EyWq80TxGQ8DgN5r0/
        e6yByTbAaVCvnn1ew1ZLleYBwwFvUUWu/Vki9ms=
X-Google-Smtp-Source: APXvYqzhOH4Kn2D97bedbpm09NJOhnwoJKeOv6yPa5hiGs62R53VqNZ52MVlBTpVEDOAJf57+r1mHqsaj9Z6lZAengs=
X-Received: by 2002:a05:6402:3132:: with SMTP id dd18mr38997644edb.118.1582374346881;
 Sat, 22 Feb 2020 04:25:46 -0800 (PST)
MIME-Version: 1.0
References: <20200219151259.14273-5-olteanv@gmail.com> <20200222113829.32431-1-michael@walle.cc>
In-Reply-To: <20200222113829.32431-1-michael@walle.cc>
From:   Vladimir Oltean <olteanv@gmail.com>
Date:   Sat, 22 Feb 2020 14:25:36 +0200
Message-ID: <CA+h21hpCBjo18zHc-SvMj5Y=C+e=rna5MUgp7SW1u0btma+wfg@mail.gmail.com>
Subject: Re: [PATCH v2 net-next/devicetree 4/5] arm64: dts: fsl: ls1028a: add
 node for Felix switch
To:     Michael Walle <michael@walle.cc>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>,
        devicetree@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        lkml <linux-kernel@vger.kernel.org>,
        Mark Rutland <mark.rutland@arm.com>,
        netdev <netdev@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        Shawn Guo <shawnguo@kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Michael,

On Sat, 22 Feb 2020 at 13:38, Michael Walle <michael@walle.cc> wrote:
>
> Hi,
>

> > +
> > +                     enetc_port2: ethernet@0,2 {
> > +                             compatible = "fsl,enetc";
> > +                             reg = <0x000200 0 0 0 0>;
> > +                             phy-mode = "gmii";
> Can we disable this port by default in this dtsi? As mentioned in the other
> mail, I'd prefer to have all ports disabled because it doesn't make sense
> to have this port while having all the external ports disabled.
>

Ok. What would you want to happen with the "ethernet" property? Do you
want the board dts to set that too?

> > +                                     /* Internal port with DSA tagging */
> > +                                     mscc_felix_port4: port@4 {
> > +                                             reg = <4>;
> > +                                             phy-mode = "internal";
> > +                                             ethernet = <&enetc_port2>;
> Likewise, I'd prefer to have this disabled.
>

Ok.

> > +                     enetc_port3: ethernet@0,6 {
> > +                             compatible = "fsl,enetc";
> > +                             reg = <0x000600 0 0 0 0>;
> > +                             status = "disabled";
> > +                             phy-mode = "gmii";
> shouldn't the status be after the phy-mode property?

Why?

>
> -michael
>

Regards,
-Vladimir
