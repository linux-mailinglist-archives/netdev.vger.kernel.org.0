Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8D29B65FB20
	for <lists+netdev@lfdr.de>; Fri,  6 Jan 2023 06:58:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231463AbjAFF6M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Jan 2023 00:58:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47924 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229597AbjAFF6J (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Jan 2023 00:58:09 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 387E360CF5;
        Thu,  5 Jan 2023 21:58:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 80E2161D0F;
        Fri,  6 Jan 2023 05:58:08 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 09AE2C433EF;
        Fri,  6 Jan 2023 05:58:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1672984687;
        bh=f4kAf4jl5OrqQs3HlMxTw6NS8FwWp+oskfarswKO6Bw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JX3MTkZQChjBwMyE4a55F9V3FFLx/FfXM67tyeQ426oFgd/F59S/J5khgaEeP/WtB
         G6q1JI+xMJdyj+AAUlCd0KNvAm1NHJpq0YbtY0vvOV/cXlceGRFY2vc7PVhK1mE2tk
         lD/X+PFipAy3n8XCzRhxglQXYJupIB0JnfxNSDnKucmA336BsOK4qvC+144y8F/u4o
         DJ8y0SjNTyuheDYvlCHLAh9ZXikGbEKjDUJCXLYKzWSfz6FYCrtGWvlY43syQe9id8
         IE9GcfGtQCvuz+/Ehc4JuO/KRyk8uc99KpbCq91k/P3dLXdZMgYW/nPtAeGGWxaYtV
         sjfHq2q6QW/6Q==
Date:   Thu, 5 Jan 2023 21:58:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        luca.weiss@fairphone.com, konrad.dybcio@linaro.org,
        caleb.connolly@linaro.org, mka@chromium.org, evgreen@chromium.org,
        andersson@kernel.org, quic_cpratapa@quicinc.com,
        quic_avuyyuru@quicinc.com, quic_jponduru@quicinc.com,
        quic_subashab@quicinc.com, elder@kernel.org,
        netdev@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: ipa: correct IPA v4.7 IMEM offset
Message-ID: <20230105215806.4c192dad@kernel.org>
In-Reply-To: <20230104181017.2880916-1-elder@linaro.org>
References: <20230104181017.2880916-1-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  4 Jan 2023 12:10:17 -0600 Alex Elder wrote:
> Note:  This fixes a commit that first landed in v6.2-rc1.

Why is it tagged for net-next then? =F0=9F=A4=94=EF=B8=8F
Let's treat it as a normal fix with a Fixes tag and for net.
I reckon the commit message makes is sufficiently clear that
I'm to blame :)
