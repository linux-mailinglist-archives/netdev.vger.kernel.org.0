Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B5816C206C
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 19:54:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229836AbjCTSyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 14:54:19 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34224 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230050AbjCTSx5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 14:53:57 -0400
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B7C9729428;
        Mon, 20 Mar 2023 11:46:44 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id 1107CCE1268;
        Mon, 20 Mar 2023 18:41:31 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id BDF97C433D2;
        Mon, 20 Mar 2023 18:41:25 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679337689;
        bh=2f37lfeV2uqUCawsoKtMP9QdXPtifZqxFzFW3xEcp8A=;
        h=From:To:Cc:Subject:References:Date:In-Reply-To:From;
        b=lWjFQyEDIo8MQTCiFBBVl1jHJQAxQmCPf74aa6CD2aNlUTBxZk29rMePvw8C6mLZc
         wrLYKoBIJEJBr84jjiWrDCUAOen5B8fxBAYivmL2MrxnYEaa7BLtJ0yNKhlJyJlhJn
         mwO2PQGUjdAF//4mjd+cijoCJT/NPCkgIT1s085wg/N6CmLzuCuhpmGN9xNZpRS996
         QgdIbY2voj2IIg2MFiNX4yGIE86800v/tQ4SJLTjcZCL3l3WbgQyAALlno3xrapB+e
         J9/eA4VdhrKZiarWIOG/mieT8wjMe8N+wVuD6CJPn5AKpxNeO6gSsg5qN2EH05S8Ga
         B9glULQd/XfTA==
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
Date:   Mon, 20 Mar 2023 20:41:21 +0200
In-Reply-To: <ZBhUo1C08U5mp9zP@hovoldconsulting.com> (Johan Hovold's message
        of "Mon, 20 Mar 2023 13:42:11 +0100")
Message-ID: <87a607fepa.fsf@kernel.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/26.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

+ ath11k list

Johan Hovold <johan@kernel.org> writes:

> On Mon, Mar 20, 2023 at 02:22:12PM +0200, Kalle Valo wrote:
>> Johan Hovold <johan+linaro@kernel.org> writes:
>> 
>> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
>> > for which the calibration data variant may need to be described.
>> >
>> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
>> > ---
>> >  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
>> >  1 file changed, 56 insertions(+)
>> >  create mode 100644
>> > Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
>> 
>> I'm confused (as usual), how does this differ from
>> bindings/net/wireless/qcom,ath11k.yaml? Why we need two .yaml files?
>
> Almost none of bindings/net/wireless/qcom,ath11k.yaml applies to WCN6856
> when using PCIe (e.g. as most properties are then discoverable).
>
> We could try to encode everything in one file, but that would likely
> just result in a big mess of a schema with conditionals all over.

Ah, so the current qcom,ath11k.yaml would be only for ath11k AHB devices
and this new file is only for ath11k PCI devices? But why still the odd
name pci17cb,1103.yaml? It's not really descriptive and I'm for sure
will not remember that pci17cb,1103.yaml is for ath11k :)

Also it doesn't look good that we have qcom,ath11k-calibration-variant
documented twice now. I'm no DT expert but isn't there any other way? Is
it possible to include other files? For example, if we would have three
files:

qcom,ath11k.yaml
qcom,ath11k-ahb.yaml
qcom,ath11k-pci.yaml

Then have the common properties like ath11k-calibration-variant in the
first file and ahb/pci files would include that.

-- 
https://patchwork.kernel.org/project/linux-wireless/list/

https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
