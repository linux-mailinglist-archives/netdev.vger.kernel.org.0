Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 797F86B8570
	for <lists+netdev@lfdr.de>; Mon, 13 Mar 2023 23:59:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229765AbjCMW7C (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Mar 2023 18:59:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42580 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229524AbjCMW7A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Mar 2023 18:59:00 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F84A746C9;
        Mon, 13 Mar 2023 15:58:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id D07C861549;
        Mon, 13 Mar 2023 22:57:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 26B70C433D2;
        Mon, 13 Mar 2023 22:57:30 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678748250;
        bh=vByp+cleYjNRsooeWKVsK7Pf6qW+dTVxWVIfmwEMi/k=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=LAMexyxtT93hnMxPAeSJOm3HE6EXQjwmlwxCGOXssdRS7y0uE9RV33QYRlCWl2zCF
         oT2WoR4xFQGd2eahk/s/g1Tq+mXi8SE8BHmXfwyDltOv4PJqTl4SL2QEBhBONTKvq/
         wNTh5B1YVB8wowIGd9k6hTpKPEPQKYUf7zyYVLnia+oJ9d4Gb+TTfyDBaQER8lBh7C
         BbB4IMv61ivPl9wGiWQdHwZqeNetxZ7FCjxwQLHjCpGugSTXIIQuG0yJt0SwuVVJ1X
         w+cWiz35fhNVaRCOYiNT7GqK55c4HyXYTNY18/tAxvKCDCZCQVuMKuHMt+/H6QdoJu
         wPdA15ba4fiQg==
Message-ID: <e5cb46e8874b12dbe438be12ee0cf949.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230313165620.128463-6-ahalaney@redhat.com>
References: <20230313165620.128463-1-ahalaney@redhat.com> <20230313165620.128463-6-ahalaney@redhat.com>
Subject: Re: [PATCH net-next 05/11] clk: qcom: gcc-sc8280xp: Add EMAC GDSCs
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     agross@kernel.org, andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, vkoul@kernel.org,
        bhupesh.sharma@linaro.org, mturquette@baylibre.com,
        peppe.cavallaro@st.com, alexandre.torgue@foss.st.com,
        joabreu@synopsys.com, mcoquelin.stm32@gmail.com,
        richardcochran@gmail.com, linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-clk@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com,
        Andrew Halaney <ahalaney@redhat.com>
To:     Andrew Halaney <ahalaney@redhat.com>, linux-kernel@vger.kernel.org
Date:   Mon, 13 Mar 2023 15:57:27 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Halaney (2023-03-13 09:56:14)
> Add the EMAC GDSCs to allow the EMAC hardware to be enabled.
>=20
> Signed-off-by: Andrew Halaney <ahalaney@redhat.com>
> ---

Acked-by: Stephen Boyd <sboyd@kernel.org>

I'm not sure if Bjorn Andersson is planning on modifying this file too,
so please confirm it can go through netdev tree.
