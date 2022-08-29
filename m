Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A5C995A4C28
	for <lists+netdev@lfdr.de>; Mon, 29 Aug 2022 14:43:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229929AbiH2Mn1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Aug 2022 08:43:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56628 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiH2MnC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 29 Aug 2022 08:43:02 -0400
Received: from gnuweeb.org (gnuweeb.org [51.81.211.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 840E7868A6
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:27:51 -0700 (PDT)
Received: from mail-lf1-f50.google.com (mail-lf1-f50.google.com [209.85.167.50])
        by gnuweeb.org (Postfix) with ESMTPSA id 52E3180866
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 12:27:50 +0000 (UTC)
X-GW-Data: lPqxHiMPbJw1wb7CM9QUryAGzr0yq5atzVDdxTR0iA==
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gnuweeb.org;
        s=default; t=1661776070;
        bh=F3P0jtYe8nBBFXZxxubIcGD7PfjN1LKYQeyor8Ohfao=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=hnHmjuybxncoUr/QXrr0zwmmO5H7sZXbDhSBkRu+5H95jeJ04EzsNX3c7JRgnrLxY
         KeaMEGtVG+vnsLk+NqC5hsXtQBwB5mPkTbyJbE3tfqCf3rpgx0OUWQ2e4Q0ZNJGWPr
         9r+XG0NfCAWDjrQ/ko9zbOZOUhFH7LUhQKeL+BgsEbjHh40/gZfCFATrRezTKm8UE4
         HP6XSLI882kHdLmjrbid+PudCtjkOHCaATFEVrX5s5/Szfh5BaDVv1iMW0Bw7tK0zt
         OtYTgde6RKHq/fr1R6lmTMxVdiUygm7A8OH0Bkj6OJxiLte7y1dNcGk8npnnu39nyl
         r5om56wW1C+Tw==
Received: by mail-lf1-f50.google.com with SMTP id br21so5143001lfb.0
        for <netdev@vger.kernel.org>; Mon, 29 Aug 2022 05:27:50 -0700 (PDT)
X-Gm-Message-State: ACgBeo3b/ujBaqsSZmysAp7ag6NSL4yfsP6ZGr8nqwNGLNdokakGwiqD
        KBE99nNRGgtqnAM3dOiKZJSsd/YhHUQ1wwuYZWYMog==
X-Google-Smtp-Source: AA6agR6/MaCwdTGYPhxBfRk9aiC96sUXc/nQmdHSZZRK4ihB3EWrLnr+Dp4zIwQ7qLnb+azquQLTlBSE8gM9pP+lBEM=
X-Received: by 2002:a05:6512:2353:b0:492:db5e:775b with SMTP id
 p19-20020a056512235300b00492db5e775bmr5846597lfu.656.1661776058426; Mon, 29
 Aug 2022 05:27:38 -0700 (PDT)
MIME-Version: 1.0
References: <20220829115516.267647-1-cui.jinpeng2@zte.com.cn>
In-Reply-To: <20220829115516.267647-1-cui.jinpeng2@zte.com.cn>
From:   Ammar Faizi <ammarfaizi2@gnuweeb.org>
Date:   Mon, 29 Aug 2022 19:27:27 +0700
X-Gmail-Original-Message-ID: <CAGzmLMV80OLRB+OA=SLk5fEvy2jecYogg636D_HijgzthUoqnQ@mail.gmail.com>
Message-ID: <CAGzmLMV80OLRB+OA=SLk5fEvy2jecYogg636D_HijgzthUoqnQ@mail.gmail.com>
Subject: Re: [PATCH linux-next] wifi: cfg80211: remove redundant err variable
To:     cgel.zte@gmail.com
Cc:     aspriel@gmail.com, franky.lin@broadcom.com,
        hante.meuleman@broadcom.com, kvalo@kernel.org,
        "David S. Miller" <davem@davemloft.net>, edumazet@google.com,
        Jakub Kicinski <kuba@kernel.org>, pabeni@redhat.com,
        johannes.berg@intel.com, a.fatoum@pengutronix.de,
        quic_vjakkam@quicinc.com, loic.poulain@linaro.org,
        hzamani.cs91@gmail.com, hdegoede@redhat.com, smoch@web.de,
        prestwoj@gmail.com, Jinpeng Cui <cui.jinpeng2@zte.com.cn>,
        linux-wireless@vger.kernel.org,
        brcm80211-dev-list.pdl@broadcom.com,
        SHA-cyfmac-dev-list@infineon.com, netdev@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Zeal Robot <zealci@zte.com.cn>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_PASS,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 29, 2022 at 7:12 PM wrote:
> From: Jinpeng Cui <cui.jinpeng2@zte.com.cn>
>
> Return value from brcmf_fil_iovar_data_set() and
> brcmf_config_ap_mgmt_ie() directly instead of
> taking this in another redundant variable.
>
> Reported-by: Zeal Robot <zealci@zte.com.cn>
> Signed-off-by: Jinpeng Cui <cui.jinpeng2@zte.com.cn>

Reviewed-by: Ammar Faizi <ammarfaizi2@gnuweeb.org>
