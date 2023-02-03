Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1739B688FF1
	for <lists+netdev@lfdr.de>; Fri,  3 Feb 2023 08:00:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231751AbjBCG76 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Feb 2023 01:59:58 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50750 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231205AbjBCG75 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Feb 2023 01:59:57 -0500
Received: from mail-vs1-xe2c.google.com (mail-vs1-xe2c.google.com [IPv6:2607:f8b0:4864:20::e2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5CB665ED3
        for <netdev@vger.kernel.org>; Thu,  2 Feb 2023 22:59:55 -0800 (PST)
Received: by mail-vs1-xe2c.google.com with SMTP id e9so4437477vsj.3
        for <netdev@vger.kernel.org>; Thu, 02 Feb 2023 22:59:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=chromium.org; s=google;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=yWWZ38xBlh3IVnKVLJVzuuNvI9iBwD+sciZ9Pk3h+ho=;
        b=Htk4ARYKUfpuvvqRJ2EeEUMvEHXAwrSb4+aIGuFbpWu72hwBzv7b3TBWYbT2WQhSKd
         P8TqXPmsrih4nuOihR7J87XRnApwAKXOxOqcU7LscwlLkh355223dPFLMU71E6OGPQ8s
         LRpy8cdSz+Ppo9W6DlE9HNaYjnMNkqN82kktU=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=yWWZ38xBlh3IVnKVLJVzuuNvI9iBwD+sciZ9Pk3h+ho=;
        b=E07Cg80pW2h4OZldCSWBu/6P4u7mft/2/oIEBWt0kJFJ5kMjZqteljThlPW4GYG2hW
         juQZd8jfNEJ7PEkmumI7r7fePV8guwTRQwi3js9Ab6n6LqJ2QAggP50nZB6o+dPauWB3
         WUG3pENjXNDet2F8Cya9KhXExwFAqk8hcqM0bYTXaTIWWLqt0FdI91vi4R/7h5Kq4MXZ
         +RB7bNXwf82CgKCKNuwkKcePcGZF8P0zyIRXOMYrj+H/RUBt6pVLLbtZNUJ0UrGC1m1s
         EnQPpp4FSvJN++NNGgwu65xw9yvsYRN2q6s71Cir43Z9KlcGlkAxP3RskIBJ/x+nPsBE
         E7jw==
X-Gm-Message-State: AO0yUKU33xB8f7SKbd6H/iVepvTLMvYTJ4MGtj5up7tciO6pYUsv+I2r
        MUoNbHhpLgqMG9UFDYT+GJOat6M3/mcllayF4O7SUUcWLX+yqg==
X-Google-Smtp-Source: AK7set/fvJef55OrCmgQPy2cey2QzW2vrXkOL7NADQDH9KEQEyy17KPIvRILeWRl3DyHoXydzUx1IzSjdM17JG3i+Jc=
X-Received: by 2002:a05:6102:23f2:b0:3ed:89c7:4bd2 with SMTP id
 p18-20020a05610223f200b003ed89c74bd2mr1663573vsc.26.1675407595078; Thu, 02
 Feb 2023 22:59:55 -0800 (PST)
MIME-Version: 1.0
References: <20230119124848.26364-1-Garmin.Chang@mediatek.com> <20230119124848.26364-10-Garmin.Chang@mediatek.com>
In-Reply-To: <20230119124848.26364-10-Garmin.Chang@mediatek.com>
From:   Chen-Yu Tsai <wenst@chromium.org>
Date:   Fri, 3 Feb 2023 14:59:43 +0800
Message-ID: <CAGXv+5Ef_=s8nXQn_rtaSgdx0jroKoaJ7DdxxyumKfT2SaLV0Q@mail.gmail.com>
Subject: Re: [PATCH v5 09/19] clk: mediatek: Add MT8188 ipesys clock support
To:     "Garmin.Chang" <Garmin.Chang@mediatek.com>
Cc:     Matthias Brugger <matthias.bgg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Michael Turquette <mturquette@baylibre.com>,
        Stephen Boyd <sboyd@kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        Project_Global_Chrome_Upstream_Group@mediatek.com,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-mediatek@lists.infradead.org,
        linux-clk@vger.kernel.org, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jan 19, 2023 at 8:54 PM Garmin.Chang <Garmin.Chang@mediatek.com> wrote:
>
> Add MT8188 ipesys clock controller which provides clock gate
> control for Image Process Engine.
>
> Signed-off-by: Garmin.Chang <Garmin.Chang@mediatek.com>

Reviewed-by: Chen-Yu Tsai <wenst@chromium.org>
