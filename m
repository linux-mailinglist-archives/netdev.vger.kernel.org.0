Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 036A74B01EE
	for <lists+netdev@lfdr.de>; Thu, 10 Feb 2022 02:22:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231446AbiBJBVq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Feb 2022 20:21:46 -0500
Received: from gmail-smtp-in.l.google.com ([23.128.96.19]:40006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231354AbiBJBVk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Feb 2022 20:21:40 -0500
Received: from mail-oi1-f172.google.com (mail-oi1-f172.google.com [209.85.167.172])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 108C57650;
        Wed,  9 Feb 2022 17:21:43 -0800 (PST)
Received: by mail-oi1-f172.google.com with SMTP id s24so4431311oic.6;
        Wed, 09 Feb 2022 17:21:43 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=3m4WpzJ4MVLVXIguTbddiu47Feq3BAirYd01vWBM/gs=;
        b=c5zC6wV8qFN2+iInzwpUnkmMCx2o2wlKRsML9a4ZEO3ST2hT5SxYCEByGf9qxCXJhk
         5VUMqduhiPq5kdLhYNMHEXJLIhtQ0W9TppwvhOL0K8gyefRznr3dI+X2MGMRcgsm2kYU
         6lOrjjrxSQv/TD8jC6ImzEm9aA6RPXq03Z68ARaPJLmL0pA5aNSc7AjEl5uXBbkpgqI6
         CTRfDqfdhTKvbPHALR1KM3boD+nyKFWIMAvXsNAk1oeIRuI35u7tIEpzppifyCt7TuQH
         lC2Mwiy/7AI2Vu/pIsGY7pCrt6Og3MoFlnFJFAFzkahKQmcqosslBO5jjsjeN9/qwPK6
         qbTw==
X-Gm-Message-State: AOAM531XauVhqtFjgm8Or3M/aCGDi9BhbP7r3GVERSyRh3m/d7bmyQ70
        cGo3vZ4W794JTu2O/YC49ONFMAUsIMrE
X-Google-Smtp-Source: ABdhPJwmOPyW6Bx27J8217xy50UliYQCsJSBVvrs8RhanpcH/GZdfWkWzyV4SdncmvvzfVWeVIxB8g==
X-Received: by 2002:a05:6808:1481:: with SMTP id e1mr2568907oiw.131.1644452931590;
        Wed, 09 Feb 2022 16:28:51 -0800 (PST)
Received: from robh.at.kernel.org (66-90-148-213.dyn.grandenetworks.net. [66.90.148.213])
        by smtp.gmail.com with ESMTPSA id c29sm7204616otk.16.2022.02.09.16.28.50
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 09 Feb 2022 16:28:50 -0800 (PST)
Received: (nullmailer pid 1255067 invoked by uid 1000);
        Thu, 10 Feb 2022 00:28:49 -0000
Date:   Wed, 9 Feb 2022 18:28:49 -0600
From:   Rob Herring <robh@kernel.org>
To:     Dinh Nguyen <dinguyen@kernel.org>
Cc:     linux-can@vger.kernel.org, wg@grandegger.com, robh+dt@kernel.org,
        netdev@vger.kernel.org, mkl@pengutronix.de,
        devicetree@vger.kernel.org
Subject: Re: [PATCH] dt-bindings: net: can: fix dtbs warning
Message-ID: <YgRcQQqAEwWX6qDM@robh.at.kernel.org>
References: <20220128133142.2135718-1-dinguyen@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220128133142.2135718-1-dinguyen@kernel.org>
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

On Fri, 28 Jan 2022 07:31:42 -0600, Dinh Nguyen wrote:
> Mute the warning from "make dtbs_check":
> 
> Documentation/devicetree/bindings/net/can/bosch,m_can.example.dt.yaml:
> can@20e8000: bosch,mram-cfg: [[0, 0, 0, 32, 0, 0, 0, 1]] is too short
> 
> Signed-off-by: Dinh Nguyen <dinguyen@kernel.org>
> ---
>  Documentation/devicetree/bindings/net/can/bosch,m_can.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Applied, thanks!
