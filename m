Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 563FC6D2E3F
	for <lists+netdev@lfdr.de>; Sat,  1 Apr 2023 06:55:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233541AbjDAEzL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Apr 2023 00:55:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55978 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229850AbjDAEzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 1 Apr 2023 00:55:10 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 45407DBF8;
        Fri, 31 Mar 2023 21:55:09 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 03ED2B83369;
        Sat,  1 Apr 2023 04:55:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 30EC5C433D2;
        Sat,  1 Apr 2023 04:55:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680324906;
        bh=doMEXp7g4Mi+U4ogcvsQzEVvkyrG3KfqBOkNEZBmucY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=QmeQwqPIUOLAx+/0TRAFGNCemB8Mxd/GAIZex9HTrz1AdQ5FbeDxsatbW+GfwEo8i
         aWqhM8UeM6Q8rTcntaicUsHQApOjY3jst8ObwcMR5oUgU+QJHbaCxyC9PGeKiHa6BJ
         RyOQquolki6Rumcuqhop22QgddSFzntE4DxvlkbFUaCFBpxm6fTelbe+mVpvnC8yE6
         T54cQ0F6N1crYNfNHK6TfD3wX9cgb+IVrOVsWpS+Ke78spXMN8mzj8SzIXMjg9KiLJ
         khtbfgnPOGEGICTkwQFFJw2sPHegkV2Ul3FZzgpihXmRRcewgS/K6k6R8qvjrT7zVP
         moT/HlGLr5c/Q==
Date:   Fri, 31 Mar 2023 21:55:04 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Halaney <ahalaney@redhat.com>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org,
        davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        vkoul@kernel.org, bhupesh.sharma@linaro.org, wens@csie.org,
        jernej.skrabec@gmail.com, samuel@sholland.org,
        mturquette@baylibre.com, peppe.cavallaro@st.com,
        alexandre.torgue@foss.st.com, joabreu@synopsys.com,
        mcoquelin.stm32@gmail.com, richardcochran@gmail.com,
        linux@armlinux.org.uk, veekhee@apple.com,
        tee.min.tan@linux.intel.com, mohammad.athari.ismail@intel.com,
        jonathanh@nvidia.com, ruppala@nvidia.com, bmasney@redhat.com,
        andrey.konovalov@linaro.org, linux-arm-msm@vger.kernel.org,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org, ncai@quicinc.com,
        jsuraj@qti.qualcomm.com, hisunil@quicinc.com, echanude@redhat.com
Subject: Re: [PATCH net-next v3 00/12] Add EMAC3 support for sa8540p-ride
Message-ID: <20230331215504.0169293a@kernel.org>
In-Reply-To: <20230331220613.2cr2r5mcf2wwse4j@halaney-x13s>
References: <20230331214549.756660-1-ahalaney@redhat.com>
        <20230331220613.2cr2r5mcf2wwse4j@halaney-x13s>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.5 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Mar 2023 17:06:13 -0500 Andrew Halaney wrote:
> As promised: https://lore.kernel.org/netdev/20230331215804.783439-1-ahalaney@redhat.com/T/#t

Patch 12 never made it to netdev or lore :(
