Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6EF1A6BE1FF
	for <lists+netdev@lfdr.de>; Fri, 17 Mar 2023 08:38:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230015AbjCQHiT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Mar 2023 03:38:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37590 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229955AbjCQHiP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Mar 2023 03:38:15 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6EC8D1421B;
        Fri, 17 Mar 2023 00:38:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 19AA0CE1F6F;
        Fri, 17 Mar 2023 07:38:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06B2BC4339B;
        Fri, 17 Mar 2023 07:38:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679038687;
        bh=iEJpyZ9jXapfaJWky/MC2x1NLyVZPYHtlZserzfH3pU=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=EbYKMO9P3WzyjRWnMaMPaCg+JNnCadnKf1C4HvZZP6GzV20QRjd8sP7ElHpEsNYs1
         WEV8x18+0M8dGcw8KcWf938vhz1OrjNLR4uBBI6uPkmhQHsaRZTVzY6o4ydnPxJ4o1
         f5q5Ia3JNzNfdJhQp9AJCY+jpmHiexU59/XRaW4P76aRyaehfwZbKETnOsS7uCbMpE
         8OTdsG4CywWxTMduLKIc0gUsyh1HgNU3ewzKuYJRFDtBmoSA5oEdPz8YkZTk0trdkW
         QOnY2zVy31sWEW41w4AE75RrznDRWpmD6ER+nojyFmfgN/Wgc0gJxPWCYPCYmWOp7k
         gL1UQcFeBEaMg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pd4gI-0001DB-3N; Fri, 17 Mar 2023 08:39:18 +0100
Date:   Fri, 17 Mar 2023 08:39:18 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        Marcel Holtmann <marcel@holtmann.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v6 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZBQZJo4UgMxm82pA@hovoldconsulting.com>
References: <20230316034759.73489-1-steev@kali.org>
 <20230316034759.73489-5-steev@kali.org>
 <ZBLuxFxFvCY+0XHG@hovoldconsulting.com>
 <ZBL4Qrp9Lr+aOyXr@hovoldconsulting.com>
 <CAKXuJqh447rZxDZ28aCiRZaL=uj5xDULhyU=HUbFVePYyz7AOw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAKXuJqh447rZxDZ28aCiRZaL=uj5xDULhyU=HUbFVePYyz7AOw@mail.gmail.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 16, 2023 at 02:17:38PM -0500, Steev Klimaszewski wrote:
> On Thu, Mar 16, 2023 at 6:05 AM Johan Hovold <johan@kernel.org> wrote:
> > On Thu, Mar 16, 2023 at 11:26:12AM +0100, Johan Hovold wrote:
> > > On Wed, Mar 15, 2023 at 10:47:58PM -0500, Steev Klimaszewski wrote:

> > > > +           vreg_s1c: smps1 {
> > > > +                   regulator-name = "vreg_s1c";
> > > > +                   regulator-min-microvolt = <1880000>;
> > > > +                   regulator-max-microvolt = <1900000>;
> > > > +                   regulator-initial-mode = <RPMH_REGULATOR_MODE_HPM>;
> > > > +                   regulator-allowed-modes = <RPMH_REGULATOR_MODE_AUTO>,
> > > > +                                             <RPMH_REGULATOR_MODE_RET>;
> > > > +                   regulator-allow-set-load;
> > >
> > > So this does not look quite right still as you're specifying an initial
> > > mode which is not listed as allowed.
> > >
> > > Also there are no other in-tree users of RPMH_REGULATOR_MODE_RET and
> > > AUTO is used to switch mode automatically which seems odd to use with
> > > allow-set-load.
> > >
> > > This regulator is in fact also used by the wifi part of the chip and as
> > > that driver does not set any loads so we may end up with a regulator in
> > > retention mode while wifi is in use.
> > >
> > > Perhaps Bjorn can enlighten us, but my guess is that this should just be
> > > "intial-mode = AUTO" (or even HPM, but I have no idea where this came
> > > from originally).
> >
> > This one probably also needs to be marked as always-on as we don't
> > currently describe the fact that the wifi part also uses s1c.

> I couldn't remember exactly why I chose HPM, and so I recreated what
> I'd done.  I looked to see what modes were available by git grepping
> the kernel sources and since they are in
> include/dt-bindings/regulator/qcom,rpmh-regulator.h with a comment
> explaining what each mode is, I picked HPM since it starts it at the
> full rated current.  As to why I chose the others... it was based on
> SMPS being mentioned in that comment block.  Since I wasn't sure what
> PFM is (and admittedly, did not look it up) I skipped it.
> 
> And you are right, we probably don't want to yank that regulator out
> from under the wifi...  will add that in v7, so I guess for v7 we want
> HPM, LPM, AUTO with AUTO being initial.  I guess I was trying to think
> that RET would allow as little power usage as possible when bluetooth
> isn't in use.

No, I think you need to stick with HPM and disallow setting the load
since doing so could impact other consumers that are not yet described.

Johan
