Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 104B55EB130
	for <lists+netdev@lfdr.de>; Mon, 26 Sep 2022 21:21:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229697AbiIZTUz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Sep 2022 15:20:55 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35836 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229711AbiIZTUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Sep 2022 15:20:51 -0400
Received: from mail-oi1-f182.google.com (mail-oi1-f182.google.com [209.85.167.182])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B4EA27A75F;
        Mon, 26 Sep 2022 12:20:44 -0700 (PDT)
Received: by mail-oi1-f182.google.com with SMTP id q10so1905571oib.5;
        Mon, 26 Sep 2022 12:20:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date;
        bh=ADvJyP56wHbSxc129KlmBq1wxQ11OvIcsy3rVQbt0AM=;
        b=nqjRtNZqxGxiKH8/Xu17bmfWvVB1qS/y7iOcVZmO6A/mbfE3roDELudxzC53BWeDyf
         6fEOxKyGx17CgPL2wIbCSufIWMvLRViyl0RQqkxAWsAVS20UxNxP+YOrojLrNSFLM444
         BEWj+zeNBH/sIzx+/egPMqjRQHX9vl4i+6NJAAxK17TxiCoFGg/MGcjG+tooeWfWRYqt
         7SHZavJ+PebWAEXZZ38c9rE74cQ73HUOKvrr6LJNTGSQk9T2rRPPR+G72X5lL7Hb+/ku
         L5jJrzB2pyGjR4IhxkzS0JeKUD9+m50ptYP3TywX63fKuEHiOoe0schopIG6yy1WdQkd
         GjrQ==
X-Gm-Message-State: ACrzQf2aJKLdRtfBXfZIGX6TVT4c6Ay4XI17uhRb48wTxwd2IQxJit/B
        Yh+YFb6I8eWZH9sZ+hn8/skoWC7NqA==
X-Google-Smtp-Source: AMsMyM4ROdDjV6GTDIC7rGrPJZId6RQc+iAMicuKSsRckR/ihD7ZKbUwPWuDfXhBc1jE8xBvdfnQGQ==
X-Received: by 2002:aca:aa97:0:b0:34d:83f5:4a5 with SMTP id t145-20020acaaa97000000b0034d83f504a5mr144441oie.146.1664220043920;
        Mon, 26 Sep 2022 12:20:43 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id t9-20020a05683022e900b0061c9f9c54e4sm8144004otc.80.2022.09.26.12.20.42
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Sep 2022 12:20:43 -0700 (PDT)
Received: (nullmailer pid 2629975 invoked by uid 1000);
        Mon, 26 Sep 2022 19:20:42 -0000
Date:   Mon, 26 Sep 2022 14:20:42 -0500
From:   Rob Herring <robh@kernel.org>
To:     Sven Peter <sven@svenpeter.dev>
Cc:     linux-kernel@vger.kernel.org, Paolo Abeni <pabeni@redhat.com>,
        devicetree@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        Alyssa Rosenzweig <alyssa@rosenzweig.io>,
        Konrad Dybcio <konrad.dybcio@somainline.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-bluetooth@vger.kernel.org, Hector Martin <marcan@marcan.st>,
        linux-arm-kernel@lists.infradead.org,
        Andy Gross <agross@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Eric Dumazet <edumazet@google.com>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        netdev@vger.kernel.org, Marcel Holtmann <marcel@holtmann.org>,
        asahi@lists.linux.dev,
        Luiz Augusto von Dentz <luiz.dentz@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH v3 1/7] dt-bindings: net: Add generic Bluetooth controller
Message-ID: <20220926192042.GA2629908-robh@kernel.org>
References: <20220919164834.62739-1-sven@svenpeter.dev>
 <20220919164834.62739-2-sven@svenpeter.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220919164834.62739-2-sven@svenpeter.dev>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 19 Sep 2022 18:48:28 +0200, Sven Peter wrote:
> Bluetooth controllers share the common local-bd-address property.
> Add a generic YAML schema to replace bluetooth.txt for those.
> 
> Signed-off-by: Sven Peter <sven@svenpeter.dev>
> ---
> changes from v2:
>   - added new bluetooth subdirectory and moved files there
>   - removed minItems from local-bd-address
>   - dropped bjorn.andersson@linaro.org, bgodavar@codeaurora.org and
>     rjliao@codeaurora.org due to bouncing emails from the CC list
> 
> changes from v1:
>   - removed blueetooth.txt instead of just replacing it with a
>     deprecation note
>   - replaced references to bluetooth.txt
> 
>  .../devicetree/bindings/net/bluetooth.txt     |  5 ----
>  .../net/bluetooth/bluetooth-controller.yaml   | 29 +++++++++++++++++++
>  .../{ => bluetooth}/qualcomm-bluetooth.yaml   |  6 ++--
>  .../bindings/soc/qcom/qcom,wcnss.yaml         |  8 ++---
>  4 files changed, 35 insertions(+), 13 deletions(-)
>  delete mode 100644 Documentation/devicetree/bindings/net/bluetooth.txt
>  create mode 100644 Documentation/devicetree/bindings/net/bluetooth/bluetooth-controller.yaml
>  rename Documentation/devicetree/bindings/net/{ => bluetooth}/qualcomm-bluetooth.yaml (96%)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
