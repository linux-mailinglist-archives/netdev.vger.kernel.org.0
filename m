Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CA5A16C43BA
	for <lists+netdev@lfdr.de>; Wed, 22 Mar 2023 07:59:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229833AbjCVG73 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Mar 2023 02:59:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229482AbjCVG72 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Mar 2023 02:59:28 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9D85014982;
        Tue, 21 Mar 2023 23:59:27 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2FAFE61F89;
        Wed, 22 Mar 2023 06:59:27 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 84E97C4339C;
        Wed, 22 Mar 2023 06:59:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1679468366;
        bh=PIUEALEH9IIlr4WfA56Zh//ektSNC3wBHU4OOoWuz5A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=q3XOnMn6OPllb+YqXqJ5rZdCd86SIcOzniEXCvCoCYuIZPTI6vNi+W7YzO0kMqusO
         LlHrTNGdPECskeLSJyNmpsM3QnB2QON2ghsiC9PiHcFY+w7k0kuJB3WRehTz4v5M53
         rfRbJ51nY/E1Wrs3Awe6tK5aYEYtxNiVUXxVhwSGcCDvQtxSMqO64WqFwX+qRuTzwN
         oll/GS/W2GZz3X3ED1WoC394VCDG4tARwTI95sgUZisovTGDS4T0ySBMQnAVfy3xdQ
         0SQgX72bkzdYPLxSoPYeWXojxBlbsaNLbi6tQjoxWZDftsjtdhJ4lmztROHFB84yug
         OrRKT+emzPUEg==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1pesSq-0002BV-1E; Wed, 22 Mar 2023 08:00:52 +0100
Date:   Wed, 22 Mar 2023 08:00:52 +0100
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
        Steev Klimaszewski <steev@kali.org>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        ath11k@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] dt-bindings: wireless: add ath11k pcie bindings
Message-ID: <ZBqnpLcJDaaPbNjt@hovoldconsulting.com>
References: <20230321094011.9759-1-johan+linaro@kernel.org>
 <20230321094011.9759-2-johan+linaro@kernel.org>
 <87mt45e34h.fsf@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <87mt45e34h.fsf@kernel.org>
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 22, 2023 at 08:01:18AM +0200, Kalle Valo wrote:
> Johan Hovold <johan+linaro@kernel.org> writes:
> 
> > Add devicetree bindings for Qualcomm ath11k PCIe devices such as WCN6855
> > for which the calibration data variant may need to be described.
> >
> > Signed-off-by: Johan Hovold <johan+linaro@kernel.org>
> > ---
> >  .../net/wireless/qcom,ath11k-pci.yaml         | 58 +++++++++++++++++++
> 
> I talked with Bjorn, our plan is that I take patch 1 to ath-next and he
> takes patch 2. I just rename this patch to:
> 
> dt-bindings: net: wireless: add ath11k pcie bindings
> 
> Everyone ok with the plan?

Sounds good, thanks!

Johan
