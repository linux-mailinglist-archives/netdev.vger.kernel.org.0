Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 410BF6C2C29
	for <lists+netdev@lfdr.de>; Tue, 21 Mar 2023 09:20:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230053AbjCUIUr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Mar 2023 04:20:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42884 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229640AbjCUIUq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Mar 2023 04:20:46 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BE681C58E;
        Tue, 21 Mar 2023 01:20:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 2FE0BB80A25;
        Tue, 21 Mar 2023 08:20:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E6E53C433EF;
        Tue, 21 Mar 2023 08:20:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679386842;
        bh=r/XTwJ0ZGyepgVGIYhRMA7vXO27GpJFl+4EAu53pwyQ=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=I5AS0EjZPdovcIfa3Rxq3mpy1YE1tj4r7DxmltKUbA9HAIs/+Z3rldPFX190yJmF0
         sQOuPslQRdYDEVdHQO75fgvUapJNFIno4orOhWPya+T2rV2URacZhPj7Ib5K3+/AQV
         eeP68B66netd1yDsQpOLHJ51Z5lL6MIIe0CsV+2oO+KDJvJaLxCb7kFE6ccUF2XoCm
         5DiKhfZXfXjpDckX6zxSpHh9VXoylVZ8H2EkCu2PRRvP6yLsiciU7S0MvKNFq+2585
         tw4b7xjjkS2E+QM6dLgAiFdp99T5V0NSNsfHa0bALQkWc5iAc+wBwNVa8lQijepYHC
         Zeu7EAiuL+f2w==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peXFs-00006M-Bo; Tue, 21 Mar 2023 09:22:05 +0100
Date:   Tue, 21 Mar 2023 09:22:04 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Kalle Valo <kvalo@kernel.org>
Cc:     Johan Hovold <johan+linaro@kernel.org>,
        Bjorn Andersson <andersson@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andy Gross <agross@kernel.org>,
        Konrad Dybcio <konrad.dybcio@linaro.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org, ath11k@lists.infradead.org
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Message-ID: <ZBlpLJfqB1Q7JfQ+@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-2-johan+linaro@kernel.org>
 <87ttyfhatn.fsf@kernel.org>
 <ZBhUo1C08U5mp9zP@hovoldconsulting.com>
 <87a607fepa.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87a607fepa.fsf@kernel.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 08:41:21PM +0200, Kalle Valo wrote:
> + ath11k list
> 
> Johan Hovold <johan@kernel.org> writes:
> 
> > On Mon, Mar 20, 2023 at 02:22:12PM +0200, Kalle Valo wrote:
> >> Johan Hovold <johan+linaro@kernel.org> writes:
> >> 
> >> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
> >> > for which the calibration data variant may need to be described.
> >> >
> >> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> >> > ---
> >> >  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
> >> >  1 file changed, 56 insertions(+)
> >> >  create mode 100644
> >> > Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> >> 
> >> I'm confused (as usual), how does this differ from
> >> bindings/net/wireless/qcom,ath11k.yaml? Why we need two .yaml files?
> >
> > Almost none of bindings/net/wireless/qcom,ath11k.yaml applies to WCN6856
> > when using PCIe (e.g. as most properties are then discoverable).
> >
> > We could try to encode everything in one file, but that would likely
> > just result in a big mess of a schema with conditionals all over.
> 
> Ah, so the current qcom,ath11k.yaml would be only for ath11k AHB devices
> and this new file is only for ath11k PCI devices?

Right, there would two separate schema files for the two device classes.

> But why still the odd
> name pci17cb,1103.yaml? It's not really descriptive and I'm for sure
> will not remember that pci17cb,1103.yaml is for ath11k :)

Yeah, it's not the best name from that perspective, but it follows the
current convention of naming the schema files after the first compatible
added.

That said, we don't have many schemas for PCI devices so perhaps we can
establish a new convention for those. Perhaps by replacing the numerical
ids with what we'd use if these were platform devices (e.g.
'qcom,wcn6855.yaml').

As long as the DT maintainers are OK with it, I'd also be happy with
something like you suggest below:

	qcom,ath11k-ahb.yaml
	qcom,ath11k-pci.yaml

(or simply not renaming the current file 'qcom,ath11k.yaml') but I have
gotten push back on that in the past.

> Also it doesn't look good that we have qcom,ath11k-calibration-variant
> documented twice now. I'm no DT expert but isn't there any other way? Is
> it possible to include other files? For example, if we would have three
> files:
> 
> qcom,ath11k.yaml
> qcom,ath11k-ahb.yaml
> qcom,ath11k-pci.yaml
> 
> Then have the common properties like ath11k-calibration-variant in the
> first file and ahb/pci files would include that.

That should be possible, but it's not necessarily better as you'd then
have to look up two files to see the bindings for either device class
(and as far as I can tell there would not be much sharing beyond this
single property).

Note that the property could just have well have been named
'qcom,calibration-variant' and then it would be shared also with the
ath10k set of devices which currently holds another definition of what
is essentially the same property ('qcom,ath10k-calibration-variant').

Johan
