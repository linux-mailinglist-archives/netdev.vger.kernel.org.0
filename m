Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 698B26B2BC7
	for <lists+netdev@lfdr.de>; Thu,  9 Mar 2023 18:14:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231221AbjCIROK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Mar 2023 12:14:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230240AbjCIRNu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 Mar 2023 12:13:50 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 16542E20F3;
        Thu,  9 Mar 2023 09:11:29 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id AE9F661CA1;
        Thu,  9 Mar 2023 17:11:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 17361C433D2;
        Thu,  9 Mar 2023 17:11:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678381880;
        bh=YDf/bSbadw2aQPNLx2AjcCwK+UKsckTH79u1MNDFfbY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=c4qv5EDNjtGll60hU6vqMTMKUCqSHq16LBOdyNKSx/fJtAXkHGs14+FteMYyQLYrE
         ftSXtls1cI/ZtnZ+ABxBPiqTdia0F+Jf8DTYOmzSsSRB5Cv1nNsHqYuLOmbScoSx9B
         opXvKM8NF8go0VAzd0hK8jseUfn6UtQnwPhHAuCaSNDXrJDZBBMvrCEukGxddagwlO
         QzD17Sdy4OtTpX2VzcHylnvCl9WA+wKwPzFwO4aa7SCiMOVMk+W5crQVqzKphlqprh
         ffcUcGXHgXN5Z7kdi/e5R5AEV1L4aIdwU3xjS+ybAHBN0yURsc5yLv533c41+hbitA
         Bu1OaVPjY4r6Q==
Received: from johan by xi.lan with local (Exim 4.94.2)
        (envelope-from <johan@kernel.org>)
        id 1paJoH-0002ZS-LO; Thu, 09 Mar 2023 18:12:09 +0100
Date:   Thu, 9 Mar 2023 18:12:09 +0100
From:   Johan Hovold <johan@kernel.org>
To:     Steev Klimaszewski <steev@kali.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
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
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        Sven Peter <sven@svenpeter.dev>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        Mark Pearson <markpearson@lenovo.com>,
        Brian Masney <bmasney@redhat.com>
Subject: Re: [PATCH v5 3/4] arm64: dts: qcom: sc8280xp: Define uart2
Message-ID: <ZAoTaX6A8JQnMH08@hovoldconsulting.com>
References: <20230209020916.6475-1-steev@kali.org>
 <20230209020916.6475-4-steev@kali.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230209020916.6475-4-steev@kali.org>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Feb 08, 2023 at 08:09:15PM -0600, Steev Klimaszewski wrote:
> From: Bjorn Andersson <bjorn.andersson@linaro.org>

I assume you got it from Bjorn in this form, but you still need to a
sentence or two here.

> Signed-off-by: Bjorn Andersson <bjorn.andersson@linaro.org>
> Signed-off-by: Steev Klimaszewski <steev@kali.org>
> Reviewed-by: Brian Masney <bmasney@redhat.com>
> Reviewed-by: Konrad Dybcio <konrad.dybcio@linaro.org>

With a proper commit message you can add my:

Reviewed-by: Johan Hovold <johan+linaro@kernel.org>

Johan
