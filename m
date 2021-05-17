Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A354386C2F
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 23:20:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244959AbhEQVWE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 17:22:04 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:44571 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238105AbhEQVWC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 May 2021 17:22:02 -0400
Received: by mail-ot1-f41.google.com with SMTP id r26-20020a056830121ab02902a5ff1c9b81so6801804otp.11;
        Mon, 17 May 2021 14:20:45 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=YcPVqnyxUoQRqLqrcd+xwOvSykAyUXn6XXyXXfewed8=;
        b=mtIO+EMTrhG0OFp22u7lFtRl2KcrfioE8we6bdl6QaDdVzWKkrjHzr5NSSAzjEfEK3
         +uC0PnHiL6yYpt1AU4vERZqQmbpY0DjPYBf1fbnyA7YiQA1MCdMW9mLCjiwlTmMU+N4/
         C3WYlQy0Khqzn9C37V4N0EUpchIEmyJbqV3Sj2eFj3omkuG/OLNte89KxujUC53b9WbV
         pD1ynqWGamMaXuxblqlVsvvRx/ohfMs+gCoq51AmF7iU2TijaEvRJsCunU9XHG5tmkAD
         1VBX4N6KZsa5IL6TSd/8fmHaS93FpVilsALOrBrjAHcb8eNild+zKygDTLrOgE5q+bsg
         in9w==
X-Gm-Message-State: AOAM533tbhNUmyfK3yNKFx8XdslE0i57ER21Ol71btaIivjk1+1+c3m9
        dldr3jWbHRl0fXuhG+Cxvg==
X-Google-Smtp-Source: ABdhPJyETxg9k9XJAKSPDZnyLWwwIHaYxzn+ovOlDY4J+ItNb3j1tMU05rQr9vzb7eu8lf00QgA4Rw==
X-Received: by 2002:a9d:5a1a:: with SMTP id v26mr1334412oth.50.1621286444548;
        Mon, 17 May 2021 14:20:44 -0700 (PDT)
Received: from robh.at.kernel.org (24-155-109-49.dyn.grandenetworks.net. [24.155.109.49])
        by smtp.gmail.com with ESMTPSA id y191sm2998370oia.50.2021.05.17.14.19.23
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 17 May 2021 14:19:33 -0700 (PDT)
Received: (nullmailer pid 3215069 invoked by uid 1000);
        Mon, 17 May 2021 21:18:28 -0000
Date:   Mon, 17 May 2021 16:18:28 -0500
From:   Rob Herring <robh@kernel.org>
To:     Rob Herring <robh@kernel.org>
Cc:     Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Stephen Boyd <sboyd@kernel.org>, alsa-devel@alsa-project.org,
        Georgi Djakov <djakov@kernel.org>,
        Sebastian Reichel <sre@kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Baolin Wang <baolin.wang7@gmail.com>,
        linux-kernel@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-pm@vger.kernel.org, Alex Elder <elder@kernel.org>,
        Mark Brown <broonie@kernel.org>,
        Chunyan Zhang <zhang.lyra@gmail.com>,
        devicetree@vger.kernel.org,
        Fabrice Gasnier <fabrice.gasnier@st.com>,
        Lars-Peter Clausen <lars@metafoo.de>,
        linux-arm-kernel@lists.infradead.org, linux-clk@vger.kernel.org,
        Luca Ceresoli <luca@lucaceresoli.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>,
        linux-input@vger.kernel.org,
        Odelu Kukatla <okukatla@codeaurora.org>,
        Shengjiu Wang <shengjiu.wang@nxp.com>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Olivier Moysan <olivier.moysan@foss.st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jonathan Cameron <jic23@kernel.org>, netdev@vger.kernel.org,
        Orson Zhai <orsonzhai@gmail.com>
Subject: Re: [PATCH] dt-bindings: More removals of type references on common
 properties
Message-ID: <20210517211828.GA3214995@robh.at.kernel.org>
References: <20210510204524.617390-1-robh@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210510204524.617390-1-robh@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 May 2021 15:45:24 -0500, Rob Herring wrote:
> Users of common properties shouldn't have a type definition as the
> common schemas already have one. A few new ones slipped in and
> *-names was missed in the last clean-up pass. Drop all the unnecessary
> type references in the tree.
> 
> A meta-schema update to catch these is pending.
> 
> Cc: Luca Ceresoli <luca@lucaceresoli.net>
> Cc: Stephen Boyd <sboyd@kernel.org>
> Cc: Olivier Moysan <olivier.moysan@foss.st.com>
> Cc: Arnaud Pouliquen <arnaud.pouliquen@foss.st.com>
> Cc: Jonathan Cameron <jic23@kernel.org>
> Cc: Lars-Peter Clausen <lars@metafoo.de>
> Cc: Dmitry Torokhov <dmitry.torokhov@gmail.com>
> Cc: Bjorn Andersson <bjorn.andersson@linaro.org>
> Cc: Georgi Djakov <djakov@kernel.org>
> Cc: "David S. Miller" <davem@davemloft.net>
> Cc: Jakub Kicinski <kuba@kernel.org>
> Cc: Sebastian Reichel <sre@kernel.org>
> Cc: Orson Zhai <orsonzhai@gmail.com>
> Cc: Baolin Wang <baolin.wang7@gmail.com>
> Cc: Chunyan Zhang <zhang.lyra@gmail.com>
> Cc: Liam Girdwood <lgirdwood@gmail.com>
> Cc: Mark Brown <broonie@kernel.org>
> Cc: Fabrice Gasnier <fabrice.gasnier@st.com>
> Cc: Odelu Kukatla <okukatla@codeaurora.org>
> Cc: Alex Elder <elder@kernel.org>
> Cc: Shengjiu Wang <shengjiu.wang@nxp.com>
> Cc: linux-clk@vger.kernel.org
> Cc: alsa-devel@alsa-project.org
> Cc: linux-iio@vger.kernel.org
> Cc: linux-arm-kernel@lists.infradead.org
> Cc: linux-input@vger.kernel.org
> Cc: linux-pm@vger.kernel.org
> Cc: netdev@vger.kernel.org
> Signed-off-by: Rob Herring <robh@kernel.org>
> ---
>  Documentation/devicetree/bindings/clock/idt,versaclock5.yaml    | 2 --
>  .../devicetree/bindings/iio/adc/st,stm32-dfsdm-adc.yaml         | 1 -
>  Documentation/devicetree/bindings/input/input.yaml              | 1 -
>  Documentation/devicetree/bindings/interconnect/qcom,rpmh.yaml   | 1 -
>  Documentation/devicetree/bindings/net/qcom,ipa.yaml             | 1 -
>  .../devicetree/bindings/power/supply/sc2731-charger.yaml        | 2 +-
>  Documentation/devicetree/bindings/sound/fsl,rpmsg.yaml          | 2 +-
>  7 files changed, 2 insertions(+), 8 deletions(-)
> 

Applied, thanks!
