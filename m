Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id C1ABB6C120D
	for <lists+netdev@lfdr.de>; Mon, 20 Mar 2023 13:41:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231420AbjCTMk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 20 Mar 2023 08:40:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45188 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231407AbjCTMk5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 20 Mar 2023 08:40:57 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48887D53A;
        Mon, 20 Mar 2023 05:40:53 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id F1AE7B80D5B;
        Mon, 20 Mar 2023 12:40:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 97EEBC433D2;
        Mon, 20 Mar 2023 12:40:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679316050;
        bh=ygtqlan6gmapNgIcCgqJ3TjvKfvjZ61I2WRWKTEMJxo=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=UwNNBTfSSGciqjoxIuA483/4GSZisGmO74L5rjgFf1VrMRKXk1DESUqtixBnJyHV4
         vaNneXW5W9EkzqDs3If7nSW9Xe+jLtNyRz76G/leyj/EoYObEgx8cHqxqOe93imq4c
         2sKBT3jxhceJgjrSEX8oOQqHfUQ7BTAQrgA1CDqYIpUTHdHvucyoVBnrpZ5JpPmd+D
         6ceJUhvOKyxE5XoY+NIxKNEljshhvKP9/G+CD3i/qjZxkc+sRRkEvlltj1F+KdC9wk
         p98AKHdOjQnRk3Sfx54YLlK6odc0yxfw+oxJDXm+aGO7YsaElDG/kFTUll++RShD6d
         4SCdYZ2LponHA==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1peEq3-0006a9-Cj; Mon, 20 Mar 2023 13:42:11 +0100
Date:   Mon, 20 Mar 2023 13:42:11 +0100
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
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] dt-bindings: wireless: add ath11k pcie bindings
Message-ID: <ZBhUo1C08U5mp9zP@hovoldconsulting.com>
References: <20230320104658.22186-1-johan+linaro@kernel.org>
 <20230320104658.22186-2-johan+linaro@kernel.org>
 <87ttyfhatn.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87ttyfhatn.fsf@kernel.org>
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 20, 2023 at 02:22:12PM +0200, Kalle Valo wrote:
> Johan Hovold <johan+linaro@kernel.org> writes:
> 
> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6856
> > for which the calibration data variant may need to be described.
> >
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  .../bindings/net/wireless/pci17cb,1103.yaml   | 56 +++++++++++++++++++
> >  1 file changed, 56 insertions(+)
> >  create mode 100644 Documentation/devicetree/bindings/net/wireless/pci17cb,1103.yaml
> 
> I'm confused (as usual), how does this differ from
> bindings/net/wireless/qcom,ath11k.yaml? Why we need two .yaml files?

Almost none of bindings/net/wireless/qcom,ath11k.yaml applies to WCN6856
when using PCIe (e.g. as most properties are then discoverable).

We could try to encode everything in one file, but that would likely
just result in a big mess of a schema with conditionals all over.

Johan
