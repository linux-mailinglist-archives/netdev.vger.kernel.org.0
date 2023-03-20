Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 05EFD6C11F3
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:33:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230103AbjCTMdQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:33:16 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35190 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229696AbjCTMdO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:33:14 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 07956BDFB;
        Mon, 20 Mar 2023 05:33:13 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AB794B80D34;
        Mon, 20 Mar 2023 12:33:11 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 66B62C433D2;
        Mon, 20 Mar 2023 12:33:10 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679315590;
        bh=fygr3RG8uPn2NJhUjRYDEIiWMomuFV1zegC03XGS6KQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=hKg0abvV0cEb5PGRSB82iHUWHBJizmJD+PvS0W/6Sl1jG4M9malqAGiz0p36sscB2
         N1lgy+Y52c3Y4wfPAkxucNRF4EdSelH3TdZ26TRxGSo3/bN4jV8HJ5iBykmy8H2/5c
         HL+AI8PzSKe4j9pBTZComTIzyKGMWpY8/341aHWsKIDDiR1rSLJ+gTK6ZLFVfnYL9v
         ezoZA4IryyFq57ahqVO4UES3SGbHBKAqxBEGljP/SeIUktQgSv846/Cfa2v8562bNl
         hac8e6fiuZhMiRKg5JI8K+ItQU7aMdSMwDe+cnvG9VlLtM2ruhbHtd9eVBV7GZUMXk
         lHLI+dbD7oZLg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peEic-0006WP-E0; Mon, 20 Mar 2023 13:34:31 +0100
Date:   Mon, 20 Mar 2023 13:34:30 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
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
Subject: Re: [PATCH 3/3] arm64: dts: qcom: sc8280xp-crd: add wifi calibration
 variant
Message-ID: <ZBhS1rV2+9ivOVUi@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-4-johan+linaro@kernel.org>
 <244a59c6-2dc0-83c7-07d2-6bae04022605@linaro.org>
 <ZBg7tA8NLDnjPp+k@hovoldconsulting.com>
 <ZBg+ixekH+Ou7jMd@hovoldconsulting.com>
 <87y1nrhazs.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87y1nrhazs.fsf@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 02:18:31PM +0200, Kalle Valo wrote:
> Johan Hovold <johan@kernel.org> writes:

> >> > > +			qcom,ath11k-calibration-variant = "LE_X13S";
> >> > Intentional? Especially given Kalle's comment on bugzilla?
> >> 
> >> Yes, it is intentional. The corresponding calibration data allows the
> >> wifi to be used on the CRD. I measure 150 MBits/s which may a bit lower
> >> than expected, but it's better than having no wifi at all.
> >
> > I was going back and forth about mentioning this in the commit message
> > and we could off on this one until someone confirms that the
> > corresponding calibration data can (or should) be used for the X13s.

Hopefully clear from context, but that was supposed to say "CRD" and not
"X13s"...

> > Note that there is no other match for
> >
> > 	'bus=pci,vendor=17cb,device=1103,subsystem-vendor=17cb,subsystem-device=0108,qmi-chip-id=2,qmi-board-id=140'
> >
> > in the new board-2.bin.
> 
> If the device in question is something else than Lenovo X13s, I would
> prefer that the variant is not set. Just in case we need different board
> files for different models. It's easy to add aliases to board-2.bin.

The sc8280xp CRD is the Qualcomm "compute" reference design for this
platform and is very similar to the X13s but they are not identical.

For ath11k and wcn6855, the CRD I have reports a chip_id of 2 and
"hw2.0", while the X13s reports chip_id 18 and "hw2.1".

The new board-2.bin notably adds two entries that match these chip_ids
but with the variant specified as "LE_X13S" for both.

> I need to check internally what board file should be used for this CRD.
> If the speed is only 150 Mbit/s I suspect it needs a different board
> file.

Sounds good. Let's drop this one for now then.

Johan
