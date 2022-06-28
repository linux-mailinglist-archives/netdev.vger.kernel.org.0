Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E812D55EC94
	for <lists+netdev@lfdr.de>; Tue, 28 Jun 2022 20:26:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234790AbiF1S0k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Jun 2022 14:26:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34414 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232504AbiF1S0j (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Jun 2022 14:26:39 -0400
Received: from mail-io1-f42.google.com (mail-io1-f42.google.com [209.85.166.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7955B21267;
        Tue, 28 Jun 2022 11:26:38 -0700 (PDT)
Received: by mail-io1-f42.google.com with SMTP id h85so13742630iof.4;
        Tue, 28 Jun 2022 11:26:38 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=O+ydJO4bYfDavkdJDLTAPmYYlM6AjpckGclreqh9wN0=;
        b=YzDaudCWXAFkPz4mrTn+EdQaET0vnjV9reIfC0L9h2Naod49wIkZDx2pSCfmf0J6TL
         VCTka3ALeS2GwPs/vXT13CXkwp8BKlCkxzyOrFRutzseM3OayZcXjTru3GWALMoA/Rq9
         SAN2XL9m7kY/BouCTAMN94YB/XU687Pj92XahYrrXeyKuzpwqJlUyhUOgBWFkC5D2bOR
         b9ytkotUqF7MRg6BGeHG51cWmbH2bzmlikxfNonIsz1nny+ruTqhwQ0fXct+DzQH8ZkF
         Lo4+Xb4YQwBQMk7leZ/cQl6COtPo/y7Rv9GC7tBJkgkE764cqPn9dm0u80EBMHoUjFSv
         6X3Q==
X-Gm-Message-State: AJIora/vIw3czk096nfxL/8/GT36cVmwvJWDt1uNZdym+6MFgo0whW6q
        6ZOPaMtWg6oGW3m5AIW8hQ==
X-Google-Smtp-Source: AGRyM1tRtzWxXEWSov0dyMEvaWMlyEK5dPAT+XUej8CsZyhvIUVCjvV1eY0mUe+fMhXX/jt9FrPBGA==
X-Received: by 2002:a05:6602:2e8c:b0:66a:4455:f47f with SMTP id m12-20020a0566022e8c00b0066a4455f47fmr11086082iow.117.1656440797675;
        Tue, 28 Jun 2022 11:26:37 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.253])
        by smtp.gmail.com with ESMTPSA id f1-20020a056e020c6100b002d95d67fbc5sm6200348ilj.2.2022.06.28.11.26.36
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 28 Jun 2022 11:26:37 -0700 (PDT)
Received: (nullmailer pid 748236 invoked by uid 1000);
        Tue, 28 Jun 2022 18:26:35 -0000
Date:   Tue, 28 Jun 2022 12:26:35 -0600
From:   Rob Herring <robh@kernel.org>
To:     Michael Walle <michael@walle.cc>
Cc:     Jakub Kicinski <kuba@kernel.org>, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>, netdev@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>,
        Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
Subject: Re: [PATCH] dt-bindings: nfc: nxp,nci: drop Charles Gorand's mail
Message-ID: <20220628182635.GA748152-robh@kernel.org>
References: <20220628070959.187734-1-michael@walle.cc>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220628070959.187734-1-michael@walle.cc>
X-Spam-Status: No, score=-1.2 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Jun 2022 09:09:59 +0200, Michael Walle wrote:
> Mails to Charles get an auto reply, that he is no longer working at
> Eff'Innov technologies. Remove the entry.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>
> ---
>  Documentation/devicetree/bindings/net/nfc/nxp,nci.yaml | 1 -
>  1 file changed, 1 deletion(-)
> 

Applied, thanks!
