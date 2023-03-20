Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F1EA26C0FE8
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 11:58:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229473AbjCTK6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 06:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35632 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231137AbjCTK5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 06:57:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4C71712BFB;
        Mon, 20 Mar 2023 03:54:34 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2C6B7B80E11;
        Mon, 20 Mar 2023 10:54:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E4CEEC433A7;
        Mon, 20 Mar 2023 10:54:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679309668;
        bh=hAuM4FXt+7DbVl5BqFSas5309znSRTrX/X0+uSoloL0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fD7MKJzfir4BY4EDV/4Jfwg3AxOsbOKjdpuVVoZTwXh3Q4G5WfhXrmcpFiqmsWDRk
         te1QMecpW3pQ/3j5KEbQbR4m0whWk/qp3xK/ibumavHv6qd6MauDAiVcsD09mNGO3n
         vTqBh8gG37cWg7oW1tJBZQRylpMWxFRA1/m6mCwqia4TENi/RJqlFRKDmS+79ydn/G
         fVWxmjQ5Sl7AYUV6CDX+jMlN0HXUJKu0jWPMv4nEBqSK6ZHcpsrqls5ylyr7lHC84x
         PaC9QuUtndkqAZlr/OJiV/oHsamjAZcOuXnMmo6/l+eQ2CVAz9HSQiUlksDuM5R56k
         vhLpzzXon3Q5g==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peDB6-0005sx-MZ; Mon, 20 Mar 2023 11:55:48 +0100
Date:   Mon, 20 Mar 2023 11:55:48 +0100
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
Message-ID: <ZBg7tA8NLDnjPp+k@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-4-johan+linaro@kernel.org>
 <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 11:50:30AM +0100, Konrad Dybcio wrote:
> 
> 
> On 20.03.2023 11:46, Johan Hovold wrote:
> > Describe the bus topology for PCIe domain 6 and add the ath11k
> > calibration variant so that the board file (calibration data) can be
> > loaded.
> > 
> > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216036
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 17 +++++++++++++++++
> >  1 file changed, 17 insertions(+)
> > 
> > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> > index 90a5df9c7a24..5dfda12f669b 100644
> > --- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> 
> 
> Was mixing
> > +++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
> 
> this /\
> 
> [...]
> 
> and this \/
> > +			qcom,ath11k-calibration-variant = "LE_X13S";
> Intentional? Especially given Kalle's comment on bugzilla?

Yes, it is intentional. The corresponding calibration data allows the
wifi to be used on the CRD. I measure 150 MBits/s which may a bit lower
than expected, but it's better than having no wifi at all.

Johan
