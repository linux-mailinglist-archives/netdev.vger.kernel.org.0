Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 874C66E6B61
	for <lists+netdev@lfdr.de>; Tue, 18 Apr 2023 19:49:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232279AbjDRRtH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Apr 2023 13:49:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57904 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232262AbjDRRtB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Apr 2023 13:49:01 -0400
Received: from mail-oo1-f53.google.com (mail-oo1-f53.google.com [209.85.161.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id F067FC65A;
        Tue, 18 Apr 2023 10:48:35 -0700 (PDT)
Received: by mail-oo1-f53.google.com with SMTP id k13-20020a4ad98d000000b00542416816b1so2046038oou.7;
        Tue, 18 Apr 2023 10:48:35 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1681840115; x=1684432115;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=Q7xYp5CwDsneRHusNluaAdmxoN53bJ4TtiyAVY3SPIY=;
        b=Yc8JMleu5nhvjNh6lWqlWtMwKyhKTwEG6UJPK7SEWRsMkhJeH4uTHREGLX8VXlXftG
         7uMxD0Ph5aJ1iyNDAhGyMZQm7hdJKKszZ/opyok+Epv5tXBpQLxElFJYS2KgpJvrZgZr
         9Rs8QiQdPubPr7fC65M8XlQkFcLPc5rIAS4z8pCOl/UIo5vaRojKIq6Mybz4wL7MH56u
         bJ7H86YQm6zdEXGQh3xKBOeZI2T7AR9yoKj/oDbEo7//zEUJCGAQwKr6cxR7WMWxzcFw
         ZKJtFIzWer3vlLqIoXUnHdkCB4LZ0RgdDWgDIgVgP0tGpB7U9k9yRgwrfpYJDZEpJfz4
         KokQ==
X-Gm-Message-State: AAQBX9fcHA96qkXWGb45mxw44ko7sLz5uBkTAw3/V66z1DNOifbxqzLs
        RFYzh3iINRIHgKP8/cClsw==
X-Google-Smtp-Source: AKy350bDRVbXUQ/6WrKJYqsUDjHxL9FF+iglMaQ8O01yb+Gp2gD8wY/rj8PHeas8kdp02Q6Dg/AXQw==
X-Received: by 2002:a4a:3758:0:b0:545:d0b1:33a9 with SMTP id r85-20020a4a3758000000b00545d0b133a9mr5519214oor.1.1681840115176;
        Tue, 18 Apr 2023 10:48:35 -0700 (PDT)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id q70-20020a4a3349000000b00546daaf33cfsm2418121ooq.14.2023.04.18.10.48.33
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 18 Apr 2023 10:48:34 -0700 (PDT)
Received: (nullmailer pid 2034437 invoked by uid 1000);
        Tue, 18 Apr 2023 17:48:33 -0000
Date:   Tue, 18 Apr 2023 12:48:33 -0500
From:   Rob Herring <robh@kernel.org>
To:     Alain Volmat <avolmat@me.com>
Cc:     devicetree@vger.kernel.org,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        patrice.chotard@foss.st.com, netdev@vger.kernel.org,
        Paolo Abeni <pabeni@redhat.com>, linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH] dt-bindings: net: dwmac: sti: remove
 stih415/sti416/stid127
Message-ID: <168184011078.2034354.12345083754240961550.robh@kernel.org>
References: <20230416195857.61284-1-avolmat@me.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230416195857.61284-1-avolmat@me.com>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Sun, 16 Apr 2023 21:58:56 +0200, Alain Volmat wrote:
> Remove compatible for stih415/stih416 and stid127 which are
> no more supported.
> 
> Signed-off-by: Alain Volmat <avolmat@me.com>
> Acked-by: Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
> ---
> Patch previously sent as part of serie: https://lore.kernel.org/all/20230209091659.1409-9-avolmat@me.com/
> 
>  Documentation/devicetree/bindings/net/sti-dwmac.txt | 3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 

Applied, thanks!

