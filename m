Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 52C4A6C428D
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:00:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229807AbjCVGAO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:00:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53618 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229751AbjCVGAM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:00:12 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82E3F59804;
        Tue, 21 Mar 2023 22:59:47 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8875961F77;
        Wed, 22 Mar 2023 05:59:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6109BC433EF;
        Wed, 22 Mar 2023 05:59:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679464785;
        bh=rbS4+cSpc5FAGaV0VmvkShCzxuAN20xSH/FhclW087A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=kv5ttoIi0jSRzSW/i+2UdrvdRkvCG0XP+EaqD0BeawfF369FWjRL5lclsi0OUYMKC
         Dre10tc0kqfjI6zTCYGku8zNUjFuwbS6eqX8YN3UXeWboU9iWOkj3nIc2DjVJFxZC2
         wekMqQ7xedDLm52Y5uXwdGDbmy5/kOnol2NLBfiU+uTTOwBsffceoRN0cEAbaXHfkx
         XGm2X/s53fjH7qGtQg2A8431Cwb5Qm0hH8cDb2M0Hd/pxuvgvwrtvLhTJNtfLfShfa
         +cxEVz/6u2WKwbqV7+f/J1PuH092WZHkJ7hhGgZjdGUc3hbW1tFG2P2c6wakByOMjR
         yjiDQK8HWFPmA==
From:   Kalle Valo <kvalo@kernel.org>
To:     Johan Hovold <johan@kernel.org>
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
References: <20230320104658.22186-1-johan+linaro@kernel.org>
        <20230320104658.22186-2-johan+linaro@kernel.org>
        <87ttyfhatn.fsf@kernel.org> <ZBhUo1C08U5mp9zP@hovoldconsulting.com>
        <87a607fepa.fsf@kernel.org> <ZBlpLJfqB1Q7JfQ+@hovoldconsulting.com>
Date:   Wed, 22 Mar 2023 07:59:40 +0200
In-Reply-To: <ZBlpLJfqB1Q7JfQ+@hovoldconsulting.com> (Johan Hovold's message
        of "Tue, 21 Mar 2023 09:22:04 +0100")
Message-ID: <87r0the377.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Johan Hovold <johan@kernel.org> writes:

> On Mon, Mar 20, 2023 at 08:41:21PM +0200, Kalle Valo wrote:
>
>> + ath11k list
>> 
>> Johan Hovold <johan@kernel.org> writes:
>> 
>> > On Mon, Mar 20, 2023 at 02:22:12PM +0200, Kalle Valo wrote:
>> >> Johan Hovold <johan+linaro@kernel.org> writes:
>> >> 
>> >> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
>> >> > for which the calibration data variant may need to be described.
>> >> >
>> >> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> >> > ---
>> >> >  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
>> >> >  1 file changed, 56 insertions(+)
>> >> >  create mode 100644
>> >> > Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
>> >> 
>> >> I'm confused (as usual), how does this differ from
>> >> bindings/net/wireless/qcom,ath11k.yaml? Why we need two .yaml files?
>> >
>> > Almost none of bindings/net/wireless/qcom,ath11k.yaml applies to WCN6856
>> > when using PCIe (e.g. as most properties are then discoverable).
>> >
>> > We could try to encode everything in one file, but that would likely
>> > just result in a big mess of a schema with conditionals all over.
>> 
>> Ah, so the current qcom,ath11k.yaml would be only for ath11k AHB devices
>> and this new file is only for ath11k PCI devices?
>
> Right, there would two separate schema files for the two device classes.
>
>> But why still the odd
>> name pci17cb,1103.yaml? It's not really descriptive and I'm for sure
>> will not remember that pci17cb,1103.yaml is for ath11k :)
>
> Yeah, it's not the best name from that perspective, but it follows the
> current convention of naming the schema files after the first compatible
> added.
>
> That said, we don't have many schemas for PCI devices so perhaps we can
> establish a new convention for those. Perhaps by replacing the numerical
> ids with what we'd use if these were platform devices (e.g.
> 'qcom,wcn6855.yaml').
>
> As long as the DT maintainers are OK with it, I'd also be happy with
> something like you suggest below:
>
> 	qcom,ath11k-ahb.yaml
> 	qcom,ath11k-pci.yaml
>
> (or simply not renaming the current file 'qcom,ath11k.yaml') but I have
> gotten push back on that in the past.

Ok, maybe it's then better not to try renaming qcom,ath11k.yaml and keep
it as is.

>> Also it doesn't look good that we have qcom,ath11k-calibration-variant
>> documented twice now. I'm no DT expert but isn't there any other way? Is
>> it possible to include other files? For example, if we would have three
>> files:
>> 
>> qcom,ath11k.yaml
>> qcom,ath11k-ahb.yaml
>> qcom,ath11k-pci.yaml
>> 
>> Then have the common properties like ath11k-calibration-variant in the
>> first file and ahb/pci files would include that.
>
> That should be possible, but it's not necessarily better as you'd then
> have to look up two files to see the bindings for either device class
> (and as far as I can tell there would not be much sharing beyond this
> single property).
>
> Note that the property could just have well have been named
> 'qcom,calibration-variant' and then it would be shared also with the
> ath10k set of devices which currently holds another definition of what
> is essentially the same property ('qcom,ath10k-calibration-variant').

Oh man, having it as 'qcom,calibration-variant' would have been so much
better. Oh well, too late now :(

Thanks for explaining all this.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
