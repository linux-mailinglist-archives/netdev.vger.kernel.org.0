Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B167B598A4E
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 19:27:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344778AbiHRRWf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 13:22:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344791AbiHRRV4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 13:21:56 -0400
Received: from mail-pj1-f53.google.com (mail-pj1-f53.google.com [209.85.216.53])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 256422CCAA;
        Thu, 18 Aug 2022 10:21:21 -0700 (PDT)
Received: by mail-pj1-f53.google.com with SMTP id e19so1123888pju.1;
        Thu, 18 Aug 2022 10:21:21 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=in-reply-to:content-disposition:mime-version:references:message-id
         :subject:cc:to:from:date:x-gm-message-state:from:to:cc;
        bh=vanZygsLh7oEj5y254592X3RdUXrhVJF3OLlXailxjk=;
        b=7F0Uu1mDJIo/Hf5FyXeMv989Wz2p8I5njd+yNqW8hkkyKlbhHBC+9p7r2nFubxhxCK
         6TvRvdZPgoBHLd5xu05I06st3NSzX0sTk1AkGbpOHMThBhasNVEedgU3Qiw6lo4QDIfm
         Y7PSVEZC8u5UHAM+5YgN13wWoIG9qGQ5ILpcxH0MSopXDmnqUv58ZMmB5KdfBeLD29JD
         htfkOStn5H6oic3h6lv1RtMcI5rrLr8Kv1umi9mqidJguC0340EjO+W/5w1fXipb5iRQ
         xiWYeIeVNYd7FkMdrRxMdYbtq+81bFBcnRvILNUMmDAwA5zlOZked0OBbsg8eL1XgKEk
         k6Yw==
X-Gm-Message-State: ACgBeo13jAB95fDCcC2iZYBPlW0FhpLlzglJQLE1KujrydkbPNhxVSVv
        OebDXjQJRseV8Kdb0xLM94qnjQxEcg==
X-Google-Smtp-Source: AA6agR7IVR3vJCScPvq4DpLDESckyA04q28EqUlUq4SYrZ+JK1pHP4nu6RmPbgMkAcvrhWT7LsZw4g==
X-Received: by 2002:a17:90a:a08:b0:1fa:b43d:68cf with SMTP id o8-20020a17090a0a0800b001fab43d68cfmr9002070pjo.41.1660843280416;
        Thu, 18 Aug 2022 10:21:20 -0700 (PDT)
Received: from robh.at.kernel.org ([2607:fb90:647:4ff2:3529:f8cd:d6cd:ac54])
        by smtp.gmail.com with ESMTPSA id d11-20020a170902aa8b00b00172b5adb78asm1424901plr.147.2022.08.18.10.21.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 18 Aug 2022 10:21:19 -0700 (PDT)
Received: (nullmailer pid 2058883 invoked by uid 1000);
        Thu, 18 Aug 2022 17:21:16 -0000
Date:   Thu, 18 Aug 2022 11:21:16 -0600
From:   Rob Herring <robh@kernel.org>
To:     andrei.tachici@stud.acs.upb.ro
Cc:     linux-kernel@vger.kernel.org, andrew@lunn.ch, hkallweit1@gmail.com,
        linux@armlinux.org.uk, davem@davemloft.net, edumazet@google.com,
        kuba@kernel.org, pabeni@redhat.com, netdev@vger.kernel.org,
        vegard.nossum@oracle.com, joel@jms.id.au, l.stelmach@samsung.com,
        krzysztof.kozlowski+dt@linaro.org, devicetree@vger.kernel.org
Subject: Re: [net-next v4 3/3] dt-bindings: net: adin1110: Add docs
Message-ID: <20220818172116.GA2055664-robh@kernel.org>
References: <20220817160236.53586-1-andrei.tachici@stud.acs.upb.ro>
 <20220817160236.53586-4-andrei.tachici@stud.acs.upb.ro>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220817160236.53586-4-andrei.tachici@stud.acs.upb.ro>
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

On Wed, Aug 17, 2022 at 07:02:36PM +0300, andrei.tachici@stud.acs.upb.ro wrote:
> From: Alexandru Tachici <alexandru.tachici@analog.com>
> 
> Add bindings for the ADIN1110/2111 MAC-PHY/SWITCH.
> 
> Signed-off-by: Alexandru Tachici <alexandru.tachici@analog.com>
> ---
>  .../devicetree/bindings/net/adi,adin1110.yaml | 77 +++++++++++++++++++
>  1 file changed, 77 insertions(+)
>  create mode 100644 Documentation/devicetree/bindings/net/adi,adin1110.yaml

Reviewed-by: Rob Herring <robh@kernel.org>
