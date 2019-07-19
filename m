Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3099C6E64D
	for <lists+netdev@lfdr.de>; Fri, 19 Jul 2019 15:27:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728844AbfGSN1G (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Jul 2019 09:27:06 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52154 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727344AbfGSN1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Jul 2019 09:27:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=Pky9viuD0oMDaJSoHdvUAeTOz0jBwYPwJje4fFabTHU=; b=PVB/5sDt8JO1QPzJBKxZ8mraPo
        F/njzXIy4mL2QNrBSOcPF5R9AhwgOgMGaDXTMT2tsinFyHLTqU0c8nC5u6ClaCqG0mE330J+R0SlS
        lCzgjEz167T6Wj5iAT7pFI39Hc0tYOToCZVn8xH7TpVEyfO3bYfXCELlIUMHbAtza3pg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hoSuX-0006qO-Iq; Fri, 19 Jul 2019 15:26:57 +0200
Date:   Fri, 19 Jul 2019 15:26:57 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sagar Kadam <sagar.kadam@sifive.com>
Cc:     Yash Shah <yash.shah@sifive.com>, davem@davemloft.net,
        Rob Herring <robh+dt@kernel.org>,
        Paul Walmsley <paul.walmsley@sifive.com>,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-riscv@lists.infradead.org,
        Mark Rutland <mark.rutland@arm.com>,
        Albert Ou <aou@eecs.berkeley.edu>,
        Palmer Dabbelt <palmer@sifive.com>,
        nicolas.ferre@microchip.com,
        Sachin Ghadi <sachin.ghadi@sifive.com>, ynezz@true.cz
Subject: Re: [PATCH 3/3] riscv: dts: Add DT node for SiFive FU540 Ethernet
 controller driver
Message-ID: <20190719132657.GD24930@lunn.ch>
References: <1563534631-15897-1-git-send-email-yash.shah@sifive.com>
 <1563534631-15897-3-git-send-email-yash.shah@sifive.com>
 <CAARK3H=D1N8gO0Z82_MCtgr5DtT1=E0wzYbn-y451ASgxV-qBg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAARK3H=D1N8gO0Z82_MCtgr5DtT1=E0wzYbn-y451ASgxV-qBg@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jul 19, 2019 at 05:23:45PM +0530, Sagar Kadam wrote:
> > +&eth0 {
> > +       status = "okay";
> > +       phy-mode = "gmii";
> > +       phy-handle = <&phy1>;
> > +       phy1: ethernet-phy@0 {
> > +               reg = <0>;
> > +       };

Hi Sagar

Is there a good reason to call it phy1? Is there a phy0?

Thanks

   Andrew
