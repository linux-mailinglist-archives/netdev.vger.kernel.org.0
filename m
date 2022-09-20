Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4820A5BEB8F
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 19:06:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229717AbiITRF5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 13:05:57 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53714 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229598AbiITRF4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 13:05:56 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B4E557218;
        Tue, 20 Sep 2022 10:05:54 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E2750B81606;
        Tue, 20 Sep 2022 17:05:52 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EF602C433C1;
        Tue, 20 Sep 2022 17:05:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663693551;
        bh=DiX69/nLg7iAswKIcIHKXWztAmNpoThXMm6VH04caWI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xyq1ORLvKARKt+m+UOoNc7XNcmOWmR+FoIF8HCniqAA3wWIsCPkXRn3rQqe1tzmsv
         pgi2Jj6puG91pRaBVznTS4/atkBvdVr8KoTe1nw52zpu9JrsKd6g5s7+ZceyT0lCb4
         uzV28iR1mod293vySvk36x1Pd30v/6r7SeNc0nc7VeXxVOUjbrf/MDhoZdqQxz+uVM
         GqSFYftf22hQU8trCKKE53fgQbG/86GjpzPUoytjaPRtuiiROXCI8PJH7buTT3aXBV
         HcdyqVFeJVBqM5R/3+3UFAOmYMD5biwMkiSDYEdcbjVdo0H2JjfdRi02MWnMWpq9k4
         6HZkERZXvCsfA==
Date:   Tue, 20 Sep 2022 10:05:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        mka@chromium.org, evgreen@chromium.org, bjorn.andersson@linaro.org,
        quic_cpratapa@quicinc.com, quic_avuyyuru@quicinc.com,
        quic_jponduru@quicinc.com, quic_subashab@quicinc.com,
        elder@kernel.org, netdev@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v2] net: ipa: properly limit modem routing table use
Message-ID: <20220920100549.3afca2c8@kernel.org>
In-Reply-To: <917abc36-ee08-6f1e-2bf5-a657b022c912@linaro.org>
References: <20220913204602.1803004-1-elder@linaro.org>
        <20220920081400.0cbe44ff@kernel.org>
        <917abc36-ee08-6f1e-2bf5-a657b022c912@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 20 Sep 2022 11:16:18 -0500 Alex Elder wrote:
> I don't want to be any more verbose, so I'll leave it at
> that.

;) To be clear I meant code changes only.

For the commit message and discussions the more verbose the better.
