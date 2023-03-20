Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 943B96C1054
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 12:10:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230113AbjCTLKk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 07:10:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53374 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231310AbjCTLKM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 07:10:12 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ACC301ACF6;
        Mon, 20 Mar 2023 04:06:37 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E2C1B80DFA;
        Mon, 20 Mar 2023 11:06:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DAF8EC433EF;
        Mon, 20 Mar 2023 11:06:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679310394;
        bh=7lVnvE+H0LwnZCwFqsBcASGQoZnp+CUIfRj+cb1hIhs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Tz/Iz9YFfmM0IQVgiLRwTXb7wqQyEO2uBYER6CiPDFY/5jedne251UlD1TJSNJa/+
         ApO+2CvcyiS+pH85bzk6JWcUkkOTPPZK6R/FnCZ617K0jmueUTN6V0RrDTunMrntMr
         LNp9/Zwsl/ur/u+GCYDJxBC/mM+eDXr+UcKOwAIA/JwW+RgOiE251ktt9sO6rE0kSz
         9IeqQorb2/yNdpTPf18aj3pFwmDGb60W6GmEJItWdbl0ZHKNUbPp8p91zNhc4QyioQ
         uQH/bT6pphC9NDX4yn1KylptAUf/GcVY4F90cDRk2G1q/p6iPwytP/HY5YTUhlSYjo
         GW2tLfCJyD1gg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peDMp-0005yt-Hh; Mon, 20 Mar 2023 12:07:55 +0100
Date:   Mon, 20 Mar 2023 12:07:55 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Konrad Dybcio <konrad.dybcio@linaro.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Kalle Valo <kvalo@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sc8280xp-crd: add wifi calibration
 variant
Message-ID: <ZBg+ixekH+Ou7jMd@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-4-johan+linaro@kernel.org>
 <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
 <ZBg7tA8NLDnjPp+k@hovoldconsulting.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ZBg7tA8NLDnjPp+k@hovoldconsulting.com>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:55:48AM +0100, Johan Hovold wrote:
> On Mon, Mar 20, 2023 at 11:50:30AM +0100, Konrad Dybcio wrote:
> > 
> > 
> > On 20.03.2023 11:46, Johan Hovold wrote:
> > > Describe the bus topology for PCIe domain 6 and add the ath11k
> > > calibration variant so that the board file (calibration data) can be
> > > loaded.
> > > 
> > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216036
> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > > ---
> > >  arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 17 +++++++++++++++++
> > >  1 file changed, 17 insertions(+)
> > > 
> > > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> > > index 90a5df9c7a24..5dfda12f669b 100644
> > > --- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> > 
> > 
> > Was mixing
> > > +++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> > 
> > this /\
> > 
> > [...]
> > 
> > and this \/
> > > +			qcom,ath11k-calibration-variant = "LE_X13S";
> > Intentional? Especially given Kalle's comment on bugzilla?
> 
> Yes, it is intentional. The corresponding calibration data allows the
> wifi to be used on the CRD. I measure 150 MBits/s which may a bit lower
> than expected, but it's better than having no wifi at all.

I was going back and forth about mentioning this in the commit message
and we could off on this one until someone confirms that the
corresponding calibration data can (or should) be used for the X13s.

Note that there is no other match for

	'bus=pci,vendor=17cb,device=1103,subsystem-vendor=17cb,subsystem-device=0108,qmi-chip-id=2,qmi-board-id=140'

in the new board-2.bin.

Johan
