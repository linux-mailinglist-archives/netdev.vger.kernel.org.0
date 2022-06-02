Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A309D53BABE
	for <lists+netdev@lfdr.de>; Thu,  2 Jun 2022 16:29:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235928AbiFBO3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jun 2022 10:29:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35778 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235859AbiFBO3U (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Jun 2022 10:29:20 -0400
Received: from mail-ot1-f53.google.com (mail-ot1-f53.google.com [209.85.210.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E21541EB41A;
        Thu,  2 Jun 2022 07:29:18 -0700 (PDT)
Received: by mail-ot1-f53.google.com with SMTP id w19-20020a9d6393000000b0060aeb359ca8so3519967otk.6;
        Thu, 02 Jun 2022 07:29:18 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3LdxAC+hjoGbT8X2doYYpQEStBAtaF+fLV0X0u4yir4=;
        b=KHDFjHHCpgdiUo9QqYaa0gIenz6tSgZ51roA5gizgVG8qKpQL0DkodlB8U6W5JBCVa
         0MrKD4T4xxaW/7ZFvxk+5TuhUtIggR2cSDrtP0AA5VCUiz0xOdWRYWAxxU1UXnRYb/uC
         3bbpHn6zHYcnZOzvZMLn4P82dQb1MXCotUh7yk4nbJriJky2O0VXAnya8MbyCod04+jh
         mwFbXr+lkFDwW/C0uiwJUntzK5qewUEpHKiGQ0bN9jZ+qnH5X6eBpT3HPqp4bFRJrN7Z
         GeKsW7yMSRxcL7qK1ut1NQ9NZSNR1LiO+b0zD4VbAUDZjOR5j+yKMWEQs578zCNk1OIu
         oa2w==
X-Gm-Message-State: AOAM531u1Wk385aFvjPa/pIAsa7t8LNEqCsZq+o4Rsp+R0X6FZv8HC+V
        2NyfHphFx+ZANqaU8hNS3A==
X-Google-Smtp-Source: ABdhPJxpzv7HpzITyd+wSw147FKRkc3JqW2DfLG9yre4EqpNix4xcaTZaxmSlhKlegS5iTyFsoVN3A==
X-Received: by 2002:a05:6830:2b07:b0:60b:b38:fcc0 with SMTP id l7-20020a0568302b0700b0060b0b38fcc0mr2109243otv.353.1654180158189;
        Thu, 02 Jun 2022 07:29:18 -0700 (PDT)
Received: from robh.at.kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id s42-20020a05683043aa00b0060613c844adsm2183325otv.10.2022.06.02.07.29.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 02 Jun 2022 07:29:17 -0700 (PDT)
Received: (nullmailer pid 2255406 invoked by uid 1000);
        Thu, 02 Jun 2022 14:29:17 -0000
Date:   Thu, 2 Jun 2022 09:29:17 -0500
From:   Rob Herring <robh@kernel.org>
To:     Palmer Dabbelt <palmer@rivosinc.com>
Cc:     kuba@kernel.org, michael.hennerich@analog.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com,
        krzysztof.kozlowski+dt@linaro.org, alexandru.ardelean@analog.com,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux@rivosinc.com
Subject: Re: [PATCH] dt-bindings: net: adin: Escape a trailing ":"
Message-ID: <20220602142917.GA2254348-robh@kernel.org>
References: <20220602012809.8384-1-palmer@rivosinc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220602012809.8384-1-palmer@rivosinc.com>
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

On Wed, Jun 01, 2022 at 06:28:09PM -0700, Palmer Dabbelt wrote:
> From: Palmer Dabbelt <palmer@rivosinc.com>
> 
> 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output
> properties") added a line with a ":" at the end, which is tripping up my
> attempts to run the DT schema checks due to this being invalid YAML
> syntax.  I get a schema check failure with the following error
> 
>     ruamel.yaml.scanner.ScannerError: mapping values are not allowed in this context
> 
> This just escapes the line in question, so it can parse.
> 
> Fixes: 1f77204e11f8 ("dt-bindings: net: adin: document phy clock output properties")
> Signed-off-by: Palmer Dabbelt <palmer@rivosinc.com>
> ---
>  Documentation/devicetree/bindings/net/adi,adin.yaml | 3 ++-
>  1 file changed, 2 insertions(+), 1 deletion(-)

Already have a fix queued in netdev.

Rob
