Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E3FDA563B2C
	for <lists+netdev@lfdr.de>; Fri,  1 Jul 2022 22:49:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231342AbiGAUfN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 1 Jul 2022 16:35:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38240 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231297AbiGAUfI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 1 Jul 2022 16:35:08 -0400
Received: from mail-io1-f51.google.com (mail-io1-f51.google.com [209.85.166.51])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BEA662870F;
        Fri,  1 Jul 2022 13:35:06 -0700 (PDT)
Received: by mail-io1-f51.google.com with SMTP id k15so3332099iok.5;
        Fri, 01 Jul 2022 13:35:06 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=U4bvbxWYfBS14+6nLRZ6HPagQvTsGqmEJtGVd36oP5Q=;
        b=jIRiPXs5i5oHMGjIpCWIjRozRcK6JkT+Q0OSUmlFtpfAhX0MCxrGAmw+GSsgeiAH2o
         3QnUJk3KaxrH6MfmcIWNkMfI2RB3i9xkfBdbOuhyJUXvNWeTAiuz97LH8gAjwAVNVOCT
         Rb4OgN0r+2cTpAWfxhWyZVIi/3IeFcKlZC3UsE4G11kydUaSDl0rnK7DBUmB02vKnYes
         FHt9xlWN+8ClOCWNpn/ivM+nfU8tAyYtIIejerLb1zPwAdf5c8EYXjmImLhEPJm1mz1k
         nOuNwtvL90x5KeGjK+0Hq21CWoNcfyCHZ7l1NcuUHLKnv6ueX9MGvheeMujHbOx3NKu/
         Nl6w==
X-Gm-Message-State: AJIora8hbiDm22YYQX6jLaj+yjmlGshEquky8OGUAouAjCpNmeoxtpyv
        BW8ueAkZqGZATclYCW7KTA==
X-Google-Smtp-Source: AGRyM1tayjJLhWLrzDeY8SLnBtrFnaK/S7ilMq60ejMBYlc6NtF1mCK3i4PS6rP7FypEMAp7CS67Bg==
X-Received: by 2002:a05:6638:42cd:b0:339:eda0:7d3f with SMTP id bm13-20020a05663842cd00b00339eda07d3fmr9738315jab.41.1656707705436;
        Fri, 01 Jul 2022 13:35:05 -0700 (PDT)
Received: from robh.at.kernel.org ([64.188.179.248])
        by smtp.gmail.com with ESMTPSA id d5-20020a026045000000b0033c836fe144sm8120568jaf.85.2022.07.01.13.35.04
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 01 Jul 2022 13:35:05 -0700 (PDT)
Received: (nullmailer pid 1478827 invoked by uid 1000);
        Fri, 01 Jul 2022 20:35:03 -0000
Date:   Fri, 1 Jul 2022 14:35:03 -0600
From:   Rob Herring <robh@kernel.org>
To:     Conor Dooley <conor.dooley@microchip.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        devicetree@vger.kernel.org, Eric Dumazet <edumazet@google.com>,
        linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        netdev@vger.kernel.org,
        Nicolas Ferre <nicolas.ferre@microchip.com>,
        linux-riscv@lists.infradead.org,
        Claudiu Beznea <claudiu.beznea@microchip.com>,
        Paolo Abeni <pabeni@redhat.com>
Subject: Re: [net-next PATCH RESEND 1/2] dt-bindings: net: cdns,macb:
 document polarfire soc's macb
Message-ID: <20220701203503.GA1478772-robh@kernel.org>
References: <20220701065831.632785-1-conor.dooley@microchip.com>
 <20220701065831.632785-2-conor.dooley@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220701065831.632785-2-conor.dooley@microchip.com>
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

On Fri, 01 Jul 2022 07:58:31 +0100, Conor Dooley wrote:
> Until now the PolarFire SoC (MPFS) has been using the generic
> "cdns,macb" compatible but has optional reset support. Add a specific
> compatible which falls back to the currently used generic binding.
> 
> Signed-off-by: Conor Dooley <conor.dooley@microchip.com>
> ---
>  Documentation/devicetree/bindings/net/cdns,macb.yaml | 1 +
>  1 file changed, 1 insertion(+)
> 

Acked-by: Rob Herring <robh@kernel.org>
