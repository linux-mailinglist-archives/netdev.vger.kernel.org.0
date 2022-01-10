Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 71AF7489E96
	for <lists+netdev@lfdr.de>; Mon, 10 Jan 2022 18:44:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238523AbiAJRox (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 12:44:53 -0500
Received: from mail-oi1-f179.google.com ([209.85.167.179]:45859 "EHLO
        mail-oi1-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238224AbiAJRox (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 12:44:53 -0500
Received: by mail-oi1-f179.google.com with SMTP id j124so19663909oih.12;
        Mon, 10 Jan 2022 09:44:52 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:content-transfer-encoding
         :in-reply-to;
        bh=RaD6+aAaTmRd5zEE9sReO0YiupSwot3U4AJVRAt9xhI=;
        b=OCzcw//9rcBBEmf8PXTcQgG3zYCWDUzK/YcAeJj7xUgEZJujxkKsPg1oMu21AUXB3f
         rU6k5qW5k9AlQAEtI21ohfm3kr7/cR3Yxn4XR9NRR/SrZ1QkHNMa0PsbQXQ2vkMBkgl9
         u2mnVqeysY6RGpUf2CQeoaIVKjumccrUKFyXQQ/7/9pJWuzWVdW62Xt26Jx4G2Up6Cm0
         lBe7sUn7aMRotkuWNgaNxAwZ4zTQmbv7rrvJY5Y5HIOzgxfR9d4tSYpx80FVyjfpWC7d
         o276PlVMndIsaRLlMxuiYvlgH2D3XuP/wkirSU9b7eVNv+ogTPrgVuUO/3dUt3dNdRrh
         PuCw==
X-Gm-Message-State: AOAM530dLTUrqSgMvbSRaP+M4ykvjzBAoAWpOGJa/tD8gvC3OzKA3Dec
        bND3dWLtAR8q3bT/qvZ0GbN/D0XYeA==
X-Google-Smtp-Source: ABdhPJyMrqn3sPc9Dy+vhme0aEwAY9t9CKbv8wwAdGwl+gC94BwsS/f26n51+OEZZfyA3pjaxhXhNw==
X-Received: by 2002:a05:6808:209a:: with SMTP id s26mr1074068oiw.152.1641836692526;
        Mon, 10 Jan 2022 09:44:52 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id o130sm1269203oig.26.2022.01.10.09.44.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 10 Jan 2022 09:44:52 -0800 (PST)
Received: (nullmailer pid 1165881 invoked by uid 1000);
        Mon, 10 Jan 2022 17:44:51 -0000
Date:   Mon, 10 Jan 2022 11:44:51 -0600
From:   Rob Herring <robh@kernel.org>
To:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <rafal@milecki.pl>
Cc:     =?utf-8?B?UmFmYcWCIE1pxYJlY2tp?= <zajec5@gmail.com>,
        Srinivas Kandagatla <srinivas.kandagatla@linaro.org>,
        devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 3/5] dt-bindings: nvmem: allow referencing device defined
 cells by names
Message-ID: <Ydxwk7PCn4smJt5w@robh.at.kernel.org>
References: <20211223110755.22722-1-zajec5@gmail.com>
 <20211223110755.22722-4-zajec5@gmail.com>
 <CAL_JsqK2TMu+h4MgQqjN0bvEzqdhsEviBwWiiR9hfNbC5eOCKg@mail.gmail.com>
 <f173d7a6-70e7-498f-8a04-b025c75f2b66@gmail.com>
 <YdSrG3EGDHMmhm1Y@robh.at.kernel.org>
 <49a2b78e-67a8-2e5c-f0c4-542851eabbf2@gmail.com>
 <0463d60e-b58e-84cc-df5e-d5030e8fdc1d@milecki.pl>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <0463d60e-b58e-84cc-df5e-d5030e8fdc1d@milecki.pl>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 04, 2022 at 09:56:01PM +0100, Rafał Miłecki wrote:
> On 4.01.2022 21:50, Rafał Miłecki wrote:
> > On 4.01.2022 21:16, Rob Herring wrote:
> > > On Thu, Dec 23, 2021 at 10:58:56PM +0100, Rafał Miłecki wrote:
> > > > On 23.12.2021 22:18, Rob Herring wrote:
> > > > > On Thu, Dec 23, 2021 at 7:08 AM Rafał Miłecki <zajec5@gmail.com> wrote:
> > > > > > 
> > > > > > From: Rafał Miłecki <rafal@milecki.pl>
> > > > > > 
> > > > > > Not every NVMEM has predefined cells at hardcoded addresses. Some
> > > > > > devices store cells in internal structs and custom formats. Referencing
> > > > > > such cells is still required to let other bindings use them.
> > > > > > 
> > > > > > Modify binding to require "reg" xor "label". The later one can be used
> > > > > > to match "dynamic" NVMEM cells by their names.
> > > > > 
> > > > > 'label' is supposed to correspond to a sticker on a port or something
> > > > > human identifiable. It generally should be something optional to
> > > > > making the OS functional. Yes, there are already some abuses of that,
> > > > > but this case is too far for me.
> > > > 
> > > > Good to learn that!
> > > > 
> > > > "name" is special & not allowed I think.
> > > 
> > > It's the node name essentially. Why is using node names not sufficient?
> > > Do you have some specific examples?
> > 
> > I tried to explain in
> > [PATCH 1/5] dt-bindings: nvmem: add "label" property to allow more flexible cells names
> > that some vendors come with fancy names that can't fit node names.

I still don't see the issue. Why do you need 'more flexible cells 
names'? What problem does that solve?

> > Broadcom's NVRAM examples:
> > 0:macaddr
> > 1:macaddr
> > 2:macaddr
> > 0:ccode
> > 1:ccode
> > 2:ccode
> > 0:regrev
>
> In other words I'd like to have something like:
> 
> nvram@1eff0000 {
> 	compatible = "brcm,nvram";
> 	reg = <0x1eff0000 0x10000>;
> 
> 	mac: cell-0 {
> 		label = "1:macaddr";
> 	};
> };
> 
> ethernet@1000 {
> 	compatible = "brcm,ethernet";
> 	reg = <0x1000 0x1000>;
> 	nvmem-cells = <&mac>;
> 	nvmem-cell-names = "mac-address";
> };

How does 'label' help here?

Note there's some other efforts around multiple mac addresses and how to 
interpret the nvmem data. Maybe that helps solve your problem.

Rob
