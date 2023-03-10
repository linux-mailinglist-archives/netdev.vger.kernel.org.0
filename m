Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7BF4A6B371A
	for <lists+netdev@lfdr.de>; Fri, 10 Mar 2023 08:09:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230128AbjCJHJM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Mar 2023 02:09:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45184 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230107AbjCJHJL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Mar 2023 02:09:11 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2462365C67;
        Thu,  9 Mar 2023 23:09:10 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B792560DC5;
        Fri, 10 Mar 2023 07:09:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 1643BC433EF;
        Fri, 10 Mar 2023 07:09:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678432149;
        bh=W3cj7tkyrmamofsiSpj68x4j1VoipLoRNxNDHjrnowg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EhLXD5X4oIL/ZTLTlyEomgtDCeOQmtvUH6olYU/aMk/gR6H3CAkqA81a1IsLLsM9f
         bd3ol5pOmLHV/v8JYxxGgwNOVAJ6JgvizO6IGW5KrGVgcne3TEfGyCVzOflMyi050M
         rTATz5D98dtJhNCtXRVNblyRIS4aC8Lz1KwzGx5ZTzAtuvFFD9OPrOvzoiKGlymnZo
         y/4FoWkryKZtxpJL54doyVeVC3M5PDh/Ot8Z55p1ICKj6GGfWvIBwahgoSxKNWn0xh
         xKkcrcH1F1/4Ogu2DsgXa3huYgSVB7Ij1j0hbY7ehIDhkeDiPzYil7N5sB0lhHQqup
         NxS8TAFo9/0Yw==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paWt5-0007kB-Us; Fri, 10 Mar 2023 08:10:00 +0100
Date:   Fri, 10 Mar 2023 08:09:59 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v5 4/4] arm64: dts: qcom: thinkpad-x13s: Add bluetooth
Message-ID: <ZArXx3g1oGb6GSVY@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-5-steev@kali.org>
 <ZAoWdR7mppnWclFr@hovoldconsulting.com>
 <CAKXuJqgAbdALaRdcoSV+sXbGzwm6h54hZtG2rBobcGA9vyu50g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKXuJqgAbdALaRdcoSV+sXbGzwm6h54hZtG2rBobcGA9vyu50g@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 09, 2023 at 02:07:58PM -0600, Steev Klimaszewski wrote:
> On Thu, Mar 9, 2023 at 11:24 AM Johan Hovold <johan@kernel.org> wrote:
> > On Wed, Feb 08, 2023 at 08:09:16PM -0600, Steev Klimaszewski wrote:

> > > +     uart2_state: uart2-state {
> >
> > Rename this one too:
> >
> >         uart2_default: uart2-default-state
> >
> > > +             cts-pins {
> > > +                     pins = "gpio122";
> >
> > This should be gpio121 (gpio122 is rts).
> >
> 
> You are right that it should be... however... if I actually set it to
> be 121.... bluetooth doesn't actually come up/work?

I'm running with this fixed locally and it's working here.

Not muxing the cts-pin should break flow control (e.g. the host will
send data regardless of if the device signals that it's ready to receive
it).

> > > +                     function = "qup2";
> > > +                     bias-disable;
> >
> > Don't we need a pull-down on this one to avoid a floating input when the
> > module is powered down?
>
> Maybe?  I don't have access to the schematics or anything so I was
> going with the best guess based on what worked by poking and prodding.
> Will try this.

There are no external resistors and most of the Qualcomm boards with
these Bluetooth modules appear to enable the internal pull-down on cts.

But there are also two boards that recently switched to bias-bus-hold:

	3d0e375bae55 ("arm64: dts: qcom: sc7280-qcard: Configure CTS pin to bias-bus-hold for bluetooth")

to avoid leakage. Perhaps that's what we want here too.

Johan
