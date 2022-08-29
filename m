Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F3F365A4724
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 12:29:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229916AbiH2K3h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 06:29:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33658 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229504AbiH2K3e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 06:29:34 -0400
Received: from mail-ej1-x635.google.com (mail-ej1-x635.google.com [IPv6:2a00:1450:4864:20::635])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C8C3C1EC78
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 03:29:33 -0700 (PDT)
Received: by mail-ej1-x635.google.com with SMTP id nc14so9871742ejc.4
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 03:29:33 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date;
        bh=McJe6Ttlwl+f338TAroTvV3W3E35F1KzQubH3mcNzT8=;
        b=lLsn35wWM2ISkkDJYZmpdTk6Oh7vgNmDiuFqSANrblTv0rAv1jzO4e/q1uCdxOlu+x
         CwswnNBI4IUUth4Lq92EE2iX4ZY/tY/gzZM3WT66+6wf/9xxrUA66lYdh/c3Abgio6PG
         BAB/+iFgdS/2P6ROQTFmHDt2CLbxQG1ePGtHfNFzhnxSw+CALFamHgeeGozRlgR50W0o
         AecyNUImVJ4KbD+fmo6r1AKjD06dMSc1eJRjYNiCt5y6O/5hICu6XBRN6JGw3fKNas2o
         iRsnqEGPpPS1CtfRBbxv2nj1NC79Iu+pRGkpo28XskmjTu1QoTLyCrGKHkgjNXLDxAFW
         Tkaw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date;
        bh=McJe6Ttlwl+f338TAroTvV3W3E35F1KzQubH3mcNzT8=;
        b=sSRcn0V7/+zWqiBDeG00LTfFkTqkc9YOKoMAlpr9SdO/uj7hO5NRVSUaxZRdMe7erT
         TrZdXRcwvsc73HhMnb7AtLKJgFg3MVhg07pImWBfeP1yPsOcUF//JJ64euwDtB30Vx0M
         V/zFtfZvngfBt6GNyxy1qIV3mG+POW6waiztgflBPyP3t7mNzL+11QtVDHomARd/Hr1b
         jXF0jsTQ9S8MieLlPfHxEUjTYDGPxYtVovgivPeO79GC300zV3VOnJf+5sYKCPcXKgnb
         IJNTj+NO7hH2hDhc3EN5Vi9IiqKExD28UWNKutP4Hf6PKJ9H5ZBe9HcUBKkWLZURpsXB
         XAEQ==
X-Gm-Message-State: ACgBeo39IX8I81AEnX4P5y9UbwhnG0CIBX7fPC5aWM7QgQC1SxFuzz3E
        EM+zAaYyETBAHV6QfPK8+RL/dMCn5fe7VB+cpzI=
X-Google-Smtp-Source: AA6agR4wG2+gI4B5N+z2SFkZOq+1cOhwup2ERrxomnkFVln+3o9zMnZEMAwytdM2eXQ1XOabEngRJyzqaeudHAU+3d4=
X-Received: by 2002:a17:907:d08:b0:72f:b107:c07a with SMTP id
 gn8-20020a1709070d0800b0072fb107c07amr13247135ejc.340.1661768972326; Mon, 29
 Aug 2022 03:29:32 -0700 (PDT)
MIME-Version: 1.0
References: <20220707101423.90106-1-jbrunet@baylibre.com> <00f1e968-c140-29b9-dc82-a6f831171d6f@gmail.com>
 <CACdvmAiyFQTUgEzkva9j8xYJYYBRXg_sfB562f3F515AHmkUoA@mail.gmail.com>
 <5c8f4cc4-9807-cfe5-7e0a-7961aef5057f@gmail.com> <1jfshftliz.fsf@starbuckisacylon.baylibre.com>
In-Reply-To: <1jfshftliz.fsf@starbuckisacylon.baylibre.com>
From:   Erico Nunes <nunes.erico@gmail.com>
Date:   Mon, 29 Aug 2022 12:29:21 +0200
Message-ID: <CAK4VdL0pWFga4V1jR8B4oHjXmbBm7dU6BB8pdh0Hymd2sAiqiw@mail.gmail.com>
Subject: Re: [RFC/RFT PATCH] net: stmmac: do not poke MAC_CTRL_REG twice on
 link up
To:     Jerome Brunet <jbrunet@baylibre.com>
Cc:     Heiner Kallweit <hkallweit1@gmail.com>,
        Da Xue <da@lessconfused.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>, netdev@vger.kernel.org,
        linux-amlogic@lists.infradead.org,
        Kevin Hilman <khilman@baylibre.com>,
        Neil Armstrong <narmstrong@baylibre.com>,
        Vyacheslav <adeep@lexina.in>, Qi Duan <qi.duan@amlogic.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 12:02 PM Jerome Brunet <jbrunet@baylibre.com> wrote:
> >>> Jerome, can you confirm that after this commit the following is no longer needed?
> >>> 2c87c6f9fbdd ("net: phy: meson-gxl: improve link-up behavior")
>
> This never had any meaningful impact for me. I have already reverted it
> for testing.
>
> I'm all for reverting it
>
> >>>
> >>> Then I'd revert it, referencing the successor workaround / fix in stmmac.
If we are considering to revert that, I would like to trigger some
tests on my S805X CI board farm as well, to ensure it won't regress
later. That was one of the original reasons for that patch.

Since there are some more changes referenced in this thread, can
someone clarify what is the desired state to test? Just revert
2c87c6f9fbdd on top of linux-next, or also apply some other patch?
