Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9BC856C11AF
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:18:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229940AbjCTMSv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:18:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42552 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229866AbjCTMSl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:18:41 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 21A653AA2;
        Mon, 20 Mar 2023 05:18:40 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AC156614C8;
        Mon, 20 Mar 2023 12:18:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B9CA6C433D2;
        Mon, 20 Mar 2023 12:18:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679314719;
        bh=MjBrE9+FJKHdNZ3P0Yho1VvqqJ1X0wOX2gCGIRtBXA0=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=gDUH8P8c+pvL9wDZJwW6m1OST0dbkrr8wqeZctun95ReUcGkpNC7+XlGoWX7WhGkE
         OfNXmUQ9S3/IwlQ6sIXmHzLHrffe/h7l5seHTI+AgMUHLIUw/B3D1x90mh4pkyd8Ig
         YuSMXyJAKHmsgIn8tUl23gelD+NghIIb/pOkiEfTcWmb49O0OU9FZPxfvVhNvUiP3K
         N7aBLP+6L95oBJHz0v8KbxS0WHPAwQpQVYKgrGJ50/tSr/jfdzLfYTFmpe+phxe2Rn
         BHLOHKiN7/bt69WyL9IsS8A/fU75DAph6OUNZPdL2YIcUdq3tJ1/HGtkZGNDL4kG1g
         m9r3Jvmendf6g==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
Cc:     Konrad Dybcio <konrad.dybcio@linaro.org>,
        Johan Hovold <johan+linaro@kernel.org>,
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
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sc8280xp-crd: add wifi calibration variant
References: <20230320104658.22186-1-johan+linaro@kernel.org>
        <20230320104658.22186-4-johan+linaro@kernel.org>
        <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
        <ZBg7tA8NLDnjPp+k@hovoldconsulting.com>
        <ZBg+ixekH+Ou7jMd@hovoldconsulting.com>
Date:   Mon, 20 Mar 2023 14:18:31 +0200
In-Reply-To: <ZBg+ixekH+Ou7jMd@hovoldconsulting.com> (Johan Hovold's message
        of "Mon, 20 Mar 2023 12:07:55 +0100")
Message-ID: <87y1nrhazs.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Mon, Mar 20, 2023 at 11:55:48AM +0100, Johan Hovold wrote:
>
>> On Mon, Mar 20, 2023 at 11:50:30AM +0100, Konrad Dybcio wrote:
>> > 
>> > 
>> > On 20.03.2023 11:46, Johan Hovold wrote:
>> > > Describe the bus topology for PCIe domain 6 and add the ath11k
>> > > calibration variant so that the board file (calibration data) can be
>> > > loaded.
>> > > 
>> > > Link: https://bugzilla.kernel.org/show_bug.cgi?id=216036
>> > > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> > > ---
>> > >  arch/arm64/boot/dts/qcom/sc8280xp-crd.dts | 17 +++++++++++++++++
>> > >  1 file changed, 17 insertions(+)
>> > > 
>> > > diff --git a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
>> > > b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
>> > > index 90a5df9c7a24..5dfda12f669b 100644
>> > > --- a/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
>> > 
>> > 
>> > Was mixing
>> > > +++ b/arch/arm64/boot/dts/qcom/sc8280xp-crd.dts
>> > 
>> > this /\
>> > 
>> > [...]
>> > 
>> > and this \/
>> > > +			qcom,ath11k-calibration-variant = "LE_X13S";
>> > Intentional? Especially given Kalle's comment on bugzilla?
>> 
>> Yes, it is intentional. The corresponding calibration data allows the
>> wifi to be used on the CRD. I measure 150 MBits/s which may a bit lower
>> than expected, but it's better than having no wifi at all.
>
> I was going back and forth about mentioning this in the commit message
> and we could off on this one until someone confirms that the
> corresponding calibration data can (or should) be used for the X13s.
>
> Note that there is no other match for
>
> 	'bus=pci,vendor=17cb,device=1103,subsystem-vendor=17cb,subsystem-device=0108,qmi-chip-id=2,qmi-board-id=140'
>
> in the new board-2.bin.

If the device in question is something else than Lenovo X13s, I would
prefer that the variant is not set. Just in case we need different board
files for different models. It's easy to add aliases to board-2.bin.

I need to check internally what board file should be used for this CRD.
If the speed is only 150 Mbit/s I suspect it needs a different board
file.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
