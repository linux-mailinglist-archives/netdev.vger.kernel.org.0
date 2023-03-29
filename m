Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 754D66CD229
	for <lists+netdev@lfdr.de>; Wed, 29 Mar 2023 08:40:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229694AbjC2GkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Mar 2023 02:40:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229590AbjC2GkM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Mar 2023 02:40:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 884A118C;
        Tue, 28 Mar 2023 23:40:11 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 25724B82011;
        Wed, 29 Mar 2023 06:40:10 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CD671C433D2;
        Wed, 29 Mar 2023 06:40:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680072008;
        bh=gvwWIULfsUzGowomB80s2P6Awux8x+iWAcLIQLNAlO4=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IFkenaaEJStHpjPg8UgX/scSObihDynya4w+nbBCtf/UL1MTY++C8zR5jPQztrbBJ
         NJv3NatdM/pwNUY3MPjvrch9S5NrFgfD61k2G7y09Re8Vp8MtkwMowOFuSUkgd1Khb
         8X77oJdewLNQCfnx32uDa8waQwKJE7LfCNpDpOnpJJ3s606AGIU7fTgqWAwvMEV13t
         0dwBe1jA8FD3MLoNNwgjeuby7tfjHsVnh9VVbrX9B5uN/Rrso/LQwQ26DFzRXHecb7
         o9Sc4msqhPj45G3u3oX431n+TSUAyudHNEJjPbz6BnVtJr6DlWX/vZZYDPRVx1zFXw
         y0JXjJXmAbmzQ==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1phPTq-0004Ls-IS; Wed, 29 Mar 2023 08:40:23 +0200
Date:   Wed, 29 Mar 2023 08:40:22 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Luiz Augusto von Dentz <luiz.dentz@gmail.com>
Cc:     Steev Klimaszewski <steev@kali.org>,
        "David S. Miller" <davem@davemloft.net>,
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
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>
Subject: Re: [PATCH v8 4/4] arm64: dts: qcom: sc8280xp-x13s: Add bluetooth
Message-ID: <ZCPdVrFE2lebRxQ3@hovoldconsulting.com>
References: <20230326233812.28058-1-steev@kali.org>
 <20230326233812.28058-5-steev@kali.org>
 <CABBYNZLh2_dKm1ePH3jMY8=EzsbG1TWkTLsgqY1KyFopLNHN6A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CABBYNZLh2_dKm1ePH3jMY8=EzsbG1TWkTLsgqY1KyFopLNHN6A@mail.gmail.com>
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 28, 2023 at 03:24:02PM -0700, Luiz Augusto von Dentz wrote:
> On Sun, Mar 26, 2023 at 4:38 PM Steev Klimaszewski <steev@kali.org> wrote:
> >
> > The Lenovo Thinkpad X13s has a WCN6855 Bluetooth controller on uart2,
> > add this.
> >
> > Signed-off-by: Steev Klimaszewski <steev@kali.org>
> 
> I would like to merge this set but this one still doesn't have any
> Signed-off-by other than yours.

While unfortunately not mentioned in the cover letter, this one should
go through the qcom tree once the binding and driver patches have been
merged (i.e. Bjorn will pick it up).

Johan
