Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8B252368382
	for <lists+netdev@lfdr.de>; Thu, 22 Apr 2021 17:39:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236465AbhDVPj7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Apr 2021 11:39:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233106AbhDVPj4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Apr 2021 11:39:56 -0400
Received: from mail-lj1-x22a.google.com (mail-lj1-x22a.google.com [IPv6:2a00:1450:4864:20::22a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ED1FEC06174A
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 08:39:21 -0700 (PDT)
Received: by mail-lj1-x22a.google.com with SMTP id z23so5872776lji.4
        for <netdev@vger.kernel.org>; Thu, 22 Apr 2021 08:39:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=plUAjDarJDyekWMgy0FkCFDFLzZZtjqWEzp24FU/oGc=;
        b=GVH7LtAe5IDyGNM32nkxm/Tgkc6AEW7bnz47XlEd306jLo9Sz+3otiD153LTZCS6hU
         zlvadG+MGKUqUToThdUM+Ssx2R667Egb2lM/Va5QeINqdYBIidLxQL9pUdIuYsUSNa4J
         dqXhNm07FCyw6r5TAhCpqR7iyYiopZWLSKGSIRcg59kFbcOEh+/ULoZjHuDgRS0P3+Wb
         r7mjAM+y9oCpHaC3/98Rg/k3ORBAqR8u/120Gx/x98aqQmTZjC3oWr6wQJ6eh+K5YO+8
         DexZVNeifd2ofIyi2kMmTn8TBKrhaGjy+GFamuBSOMX+K/2DbiZfiJCroX/iyIuaR7y6
         /bkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=plUAjDarJDyekWMgy0FkCFDFLzZZtjqWEzp24FU/oGc=;
        b=ikReXSKhMHJjgoE6sT7BAelm+0SzyXO2A+xBt6Q3+gmY3UpvQeE9jKhNQ9n3NRw+65
         IPyQm2KAxKencUCnF6+6eHs/uKFrAkoMxPcg67kKoOebJ+WeIuF6hvNsJMFYbnENtYWx
         m0aZo9pt8uaHQlT9gBPMi0CrboqojWYql1Q4EA7V3y54Meb3qM/GPmJ6uXNpNOARmaVT
         nCEmGF7Qle+qWD3iehNh2J7GHh8TVVqT2jtmixq9licU+N6mxEv2I+4IdDqDvwFU7ttD
         2RWitJvzCK0LDgELg2HptS+yQv7+HS7J0/OWLFIh5rlv/PmCyGKfIRvg/3ldfijhv6uz
         pOmA==
X-Gm-Message-State: AOAM5314uZvaNRVZYy8nH5sxAhoN1P+6hpkXyZfL94jtgG5rpeDZSoyd
        ZtMg9a+BDgTHfy1LI5YZ8w+jqJ7TBkz4P2M4pU5ckXWW3KgAvw==
X-Google-Smtp-Source: ABdhPJy+J6pn957FhOHwZjyk7gcCN1x7YgAp+VD5Efd7/IgYIAUbnOKSxezAgYN+dswKer5KxJuLbQCCFr6srLhrZpo=
X-Received: by 2002:a05:651c:c1:: with SMTP id 1mr2777078ljr.467.1619105959048;
 Thu, 22 Apr 2021 08:39:19 -0700 (PDT)
MIME-Version: 1.0
References: <20210419225133.2005360-1-linus.walleij@linaro.org> <YH4tsFtGJUMf2BFS@lunn.ch>
In-Reply-To: <YH4tsFtGJUMf2BFS@lunn.ch>
From:   Linus Walleij <linus.walleij@linaro.org>
Date:   Thu, 22 Apr 2021 17:39:07 +0200
Message-ID: <CACRpkdbppvaNUXE9GD_UXDrB8SJA5qv7wrQ1dj5E4ySU_6bG7w@mail.gmail.com>
Subject: Re: [PATCH 1/3] net: ethernet: ixp4xx: Add DT bindings
To:     Andrew Lunn <andrew@lunn.ch>, Rob Herring <robh+dt@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Zoltan HERPAI <wigyori@uid0.hu>,
        Raylynn Knight <rayknight@me.com>,
        "open list:OPEN FIRMWARE AND FLATTENED DEVICE TREE BINDINGS" 
        <devicetree@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Apr 20, 2021 at 3:26 AM Andrew Lunn <andrew@lunn.ch> wrote:

> > +      mdio {
> > +        #address-cells = <1>;
> > +        #size-cells = <0>;
> > +        phy1: phy@1 {
> > +          #phy-cells = <0>;
>
> Hi Linus
>
> phy-cells is not part of the Ethernet PHY binding.

Nevertheless:

  CHECK   Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dt.yaml
/var/linus/linux-nomadik/build-ixp4/Documentation/devicetree/bindings/net/intel,ixp4xx-ethernet.example.dt.yaml:
phy@1: '#phy-cells' is a required property
    From schema:
/home/linus/.local/lib/python3.9/site-packages/dtschema/schemas/phy/phy-provider.yaml

It has been hardcoded as required into the dtschema python package.
Looks like this:

properties:
  $nodename:
    pattern: "^(|usb-|usb2-|usb3-|pci-|pcie-|sata-)phy(@[0-9a-f,]+)*$"

  "#phy-cells": true

  phy-supply: true

required:
  - "#phy-cells"

additionalProperties: true

If this is wrong I bet Rob needs to hear about it.

Yours,
Linus Walleij
