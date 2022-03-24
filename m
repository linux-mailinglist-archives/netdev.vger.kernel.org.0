Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5B4EE4E6369
	for <lists+netdev@lfdr.de>; Thu, 24 Mar 2022 13:31:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1350197AbiCXMbV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Mar 2022 08:31:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59094 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233678AbiCXMbU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Mar 2022 08:31:20 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A60E0A94E9;
        Thu, 24 Mar 2022 05:29:48 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 5EB4BB801B9;
        Thu, 24 Mar 2022 12:29:47 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 77B81C340EC;
        Thu, 24 Mar 2022 12:29:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1648124986;
        bh=3DoK7n9nDP2CGFgPXTe97QnveDO+h1oyIl//9nYasVY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=IJq7vKfG82kt8jIdTOpib4NKU/d4K/dKlQpMN4zxXnxRbBL6g0IN7IcbjHbeaPUd9
         Dk05bOIA6Jb3wTnvL8F3mjlFPNx3AA4uKg9ttlUDvH1KyrAS9QRk4J3HW+Id1XXhyJ
         uqO7NIFLdbWR7Ks6oTXJ+nsGntmdvd0mE6NKC9OU=
Date:   Thu, 24 Mar 2022 13:29:43 +0100
From:   Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To:     Bhupesh Sharma <bhupesh.sharma@linaro.org>
Cc:     Bjorn Andersson <bjorn.andersson@linaro.org>,
        Vinod Koul <vkoul@kernel.org>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] net: stmmac: dwmac-qcom-ethqos: Enable RGMII functional
 clock on resume
Message-ID: <YjxkNzJMGt0f2XYF@kroah.com>
References: <20220323033255.2282930-1-bjorn.andersson@linaro.org>
 <CAH=2NtyChidtrBVBL=RNjPaYYmtTuN0N4fbMx4DRBD6hXxHguQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAH=2NtyChidtrBVBL=RNjPaYYmtTuN0N4fbMx4DRBD6hXxHguQ@mail.gmail.com>
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Mar 24, 2022 at 03:08:08PM +0530, Bhupesh Sharma wrote:
> +Cc: stable tree as I think this is an important fix for stmmac
> dwmac-qcom-ethernet driver and affects ethernet functionality on QCOM
> boards which use this driver.

<formletter>

This is not the correct way to submit patches for inclusion in the
stable kernel tree.  Please read:
    https://www.kernel.org/doc/html/latest/process/stable-kernel-rules.html
for how to do this properly.

</formletter>
