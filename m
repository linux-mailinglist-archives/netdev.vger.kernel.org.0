Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8F7D966A2BA
	for <lists+netdev@lfdr.de>; Fri, 13 Jan 2023 20:16:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229706AbjAMTQw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Jan 2023 14:16:52 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229512AbjAMTQv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Jan 2023 14:16:51 -0500
Received: from mail-oa1-f46.google.com (mail-oa1-f46.google.com [209.85.160.46])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6C484E41;
        Fri, 13 Jan 2023 11:16:50 -0800 (PST)
Received: by mail-oa1-f46.google.com with SMTP id 586e51a60fabf-15b9c93848dso15029705fac.1;
        Fri, 13 Jan 2023 11:16:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc:subject:date
         :message-id:reply-to;
        bh=gQ0juXy1JW5wmlmLJIXH0aX3wlgBfr5f0sFha/JOtn0=;
        b=gLlC4lXXM3/6BUzAUZrEwuKJGCEih2S32pZ4BWYMFzAcM4I8fQpbx/0aXDFR9H3TmI
         KUIAJ9qmwTq5EOfhP6W/SICWxIkk/SyK2CGoN/bpVEO4XbQ0wzCoDgrZ+X4BQswiWVr/
         opItBV+9ClOu65QhtmDDnh4jB3YYNMzLKQUF3IbFjZOAkfwIyGyfjVljUiPkrVNaciRU
         1tmTidNwqvVABAljJpgldQLX9e1l1zuWD4YCo45d518mrn1EBcT/zMNFCPQfertuQx1d
         bd2QPgaSx0OTmYcJuJka/icDfKfd18Ek9g+j6OA4Vc6vMI9pTW6BQJltkvNsFpnfbF33
         5xJw==
X-Gm-Message-State: AFqh2krEO3Vzzsum/7kf+eS2lCnhfw1EBLZhEx0pSJQ7Ijq4QOFDMB4o
        tNZQhUz3CHKG6clvKJF30w==
X-Google-Smtp-Source: AMrXdXslcfC6lSZCGInWKQHjUYPPcdmhPaulBaBVtNBkXYromtXhHzUeMiM3fTvWp9ceWCI2ZelJCQ==
X-Received: by 2002:a05:6870:610b:b0:15e:cb48:adb2 with SMTP id s11-20020a056870610b00b0015ecb48adb2mr3756726oae.31.1673637409568;
        Fri, 13 Jan 2023 11:16:49 -0800 (PST)
Received: from robh_at_kernel.org (66-90-144-107.dyn.grandenetworks.net. [66.90.144.107])
        by smtp.gmail.com with ESMTPSA id fp18-20020a056870659200b0010d7242b623sm7315259oab.21.2023.01.13.11.16.48
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 13 Jan 2023 11:16:49 -0800 (PST)
Received: (nullmailer pid 2747658 invoked by uid 1000);
        Fri, 13 Jan 2023 19:16:48 -0000
Date:   Fri, 13 Jan 2023 13:16:48 -0600
From:   Rob Herring <robh@kernel.org>
To:     Siddharth Vadapalli <s-vadapalli@ti.com>
Cc:     davem@davemloft.net, linux-arm-kernel@lists.infradead.org,
        edumazet@google.com, krzysztof.kozlowski@linaro.org,
        kristo@kernel.org, pabeni@redhat.com, kuba@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, nsekhar@ti.com, nm@ti.com,
        rogerq@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        srk@ti.com, robh+dt@kernel.org, vigneshr@ti.com
Subject: Re: [PATCH net-next 1/5] dt-binding: net: ti: am65x-cpts: add
 'ti,pps' property
Message-ID: <167363740714.2747440.8721065757900102586.robh@kernel.org>
References: <20230111114429.1297557-1-s-vadapalli@ti.com>
 <20230111114429.1297557-2-s-vadapalli@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111114429.1297557-2-s-vadapalli@ti.com>
X-Spam-Status: No, score=-1.3 required=5.0 tests=BAYES_00,
        FREEMAIL_ENVFROM_END_DIGIT,FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,
        HEADER_FROM_DIFFERENT_DOMAINS,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H3,
        RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS autolearn=no
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On Wed, 11 Jan 2023 17:14:25 +0530, Siddharth Vadapalli wrote:
> From: Grygorii Strashko <grygorii.strashko@ti.com>
> 
> Add the ti,pps property used to indicate the pair of HWx_TS_PUSH input and
> the TS_GENFy output.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> Signed-off-by: Siddharth Vadapalli <s-vadapalli@ti.com>
> ---
>  .../devicetree/bindings/net/ti,k3-am654-cpts.yaml         | 8 ++++++++
>  1 file changed, 8 insertions(+)
> 

Reviewed-by: Rob Herring <robh@kernel.org>
