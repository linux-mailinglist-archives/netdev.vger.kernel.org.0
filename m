Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id F00434F6B1D
	for <lists+netdev@lfdr.de>; Wed,  6 Apr 2022 22:17:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234327AbiDFUTC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 Apr 2022 16:19:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43616 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234839AbiDFUSA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 Apr 2022 16:18:00 -0400
Received: from mail-oo1-f43.google.com (mail-oo1-f43.google.com [209.85.161.43])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 48DC0190EB0;
        Wed,  6 Apr 2022 11:16:38 -0700 (PDT)
Received: by mail-oo1-f43.google.com with SMTP id y27-20020a4a9c1b000000b0032129651bb0so517615ooj.2;
        Wed, 06 Apr 2022 11:16:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=cY1a0Zc+pO37xq4HZwxxmQkJE9nJIcVM9C7Y7o2nOwQ=;
        b=yZTQEldSH5rdma2+D2E5naywnY4LUCV1pu42ax0dXBwl2ww8aqNONcxAkx18QVu6Rb
         SS2utJzd8ajGYDxifVGzII9PdSFzQpOrxGRCPqL4DwLFX6b598UzkQTdF9y3mDEbTHxX
         M0vWWswI9RQWsu7ACSbYOyAXVxILwZndshf5DfU5eu4OQtdvYXtmmxrx8OkXw7+WIHQA
         PQzgCn9cDBeuykmsNZ/meJPrRjMY3iwF8vmi45aU4MXPf+59j9ShoBfX3HyGzf1JGNed
         Wa4xL6JSEpFuouwGTdcEOLQkobqQDKPLTo8VpZwW0lQnNdLPXAUMjfAsASU+IQS+bqzJ
         1CkQ==
X-Gm-Message-State: AOAM532FL5oz5rLmMrJuj/LmEyWhDulYBUMIkAVLdULTrcWTqu94LbFA
        1M6AMU+fwidVXTl9vI6cKSv9kl8oGA==
X-Google-Smtp-Source: ABdhPJz/YTaqiBM6jzjgNmXt1nqqrrnf8BC+ftvIq85Hks6oQwMV4buUypRm9Oe+NY8R8NeR9F2qaw==
X-Received: by 2002:a4a:d0ca:0:b0:324:3aa2:cbfa with SMTP id u10-20020a4ad0ca000000b003243aa2cbfamr3213447oor.52.1649268997609;
        Wed, 06 Apr 2022 11:16:37 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id m13-20020a9d7acd000000b005cda59325e6sm6990563otn.60.2022.04.06.11.16.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 06 Apr 2022 11:16:37 -0700 (PDT)
Received: (nullmailer pid 2526989 invoked by uid 1000);
        Wed, 06 Apr 2022 18:16:36 -0000
Date:   Wed, 6 Apr 2022 13:16:36 -0500
From:   Rob Herring <robh@kernel.org>
To:     Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
Cc:     netdev@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        linux-arm-kernel@lists.infradead.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Masami Hiramatsu <mhiramat@kernel.org>,
        Krzysztof Kozlowski <krzk+dt@kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 2/2] dt-bindings: net: ave: Use unevaluatedProperties
Message-ID: <Yk3ZBEvVduXM9myB@robh.at.kernel.org>
References: <1649145181-30001-1-git-send-email-hayashi.kunihiko@socionext.com>
 <1649145181-30001-3-git-send-email-hayashi.kunihiko@socionext.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1649145181-30001-3-git-send-email-hayashi.kunihiko@socionext.com>
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

On Tue, 05 Apr 2022 16:53:01 +0900, Kunihiko Hayashi wrote:
> This refers common bindings, so this is preferred for
> unevaluatedProperties instead of additionalProperties.
> 
> Signed-off-by: Kunihiko Hayashi <hayashi.kunihiko@socionext.com>
> ---
>  .../devicetree/bindings/net/socionext,uniphier-ave4.yaml        | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 

Acked-by: Rob Herring <robh@kernel.org>
