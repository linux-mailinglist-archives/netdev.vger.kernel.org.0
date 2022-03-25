Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2B0384E72EA
	for <lists+netdev@lfdr.de>; Fri, 25 Mar 2022 13:19:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355012AbiCYMVG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Mar 2022 08:21:06 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57266 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232166AbiCYMVF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Mar 2022 08:21:05 -0400
Received: from mail-ej1-f47.google.com (mail-ej1-f47.google.com [209.85.218.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4339A6F490;
        Fri, 25 Mar 2022 05:19:31 -0700 (PDT)
Received: by mail-ej1-f47.google.com with SMTP id j15so14963047eje.9;
        Fri, 25 Mar 2022 05:19:31 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=y3vrDBUv6F9OT8Q/6qXmmtUzzQHr9b7FoLwXkymKYc4=;
        b=EZC+9BM99AAdNxAu4mCgsThwcZDddSj7FZjUoICyXBPcMJLDkBudYUnPcZim7ouO1V
         wvq9L/lX9joOWEuW4cXGWgBQ8hlctIjoKw7WF2NK+m7Bmkpk5JCLVEjRaEpgOJBqAlrw
         wMusYvLv7gI/Rn6jAMfBo1D+/nDPLpjJ4ytOHFRIUs6FzV9NH3eZkxDZPPx05+Ps6m+C
         sLLL+nbbBmscpJATe7ngHHT+PukCbbQl9dggl8kBnSxd3cTvgmp3enB4qBPbyNRRgurM
         1Q6A4Me2Jq7J+Nm5COvojGGwPTT8O4Cnx7SMK8l2r2mJzS8DZ4Qvt8aFqN3h2aWzaeQv
         whcA==
X-Gm-Message-State: AOAM531MD2hpj6ZaIUOjcBBh7OrjdwA/ZLIt+RZ13kSTUrCh7FowyVpk
        o7GDWPYSwe4mTURaNF6w+QU=
X-Google-Smtp-Source: ABdhPJytFk/12sSW56j6ZbwpfMF+jf7c9WhUQs39ePFYQpRqrIpJQhMo/kKoPDs/mZ+HODgX2+MQSg==
X-Received: by 2002:a17:907:7f8c:b0:6e0:614f:f13e with SMTP id qk12-20020a1709077f8c00b006e0614ff13emr11250757ejc.488.1648210769760;
        Fri, 25 Mar 2022 05:19:29 -0700 (PDT)
Received: from [192.168.0.160] (xdsl-188-155-201-27.adslplus.ch. [188.155.201.27])
        by smtp.googlemail.com with ESMTPSA id j11-20020a056402238b00b00419181bb171sm2703528eda.38.2022.03.25.05.19.28
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 25 Mar 2022 05:19:29 -0700 (PDT)
Message-ID: <6c44b745-36c7-4d28-74ea-590011892658@kernel.org>
Date:   Fri, 25 Mar 2022 13:19:28 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v3 1/3] dt-bindings: net: add reset property for aspeed,
 ast2600-mdio binding
Content-Language: en-US
To:     Dylan Hung <dylan_hung@aspeedtech.com>, robh+dt@kernel.org,
        joel@jms.id.au, andrew@aj.id.au, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com
References: <20220325041451.894-1-dylan_hung@aspeedtech.com>
 <20220325041451.894-2-dylan_hung@aspeedtech.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220325041451.894-2-dylan_hung@aspeedtech.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.4 required=5.0 tests=BAYES_00,
        FREEMAIL_FORGED_FROMDOMAIN,FREEMAIL_FROM,HEADER_FROM_DIFFERENT_DOMAINS,
        NICE_REPLY_A,RCVD_IN_DNSWL_NONE,RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=no autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 25/03/2022 05:14, Dylan Hung wrote:
> The AST2600 MDIO bus controller has a reset control bit and must be
> deasserted before manipulating the MDIO controller. By default, the
> hardware asserts the reset so the driver only need to deassert it.
> 
> Regarding to the old DT blobs which don't have reset property in them,
> the reset deassertion is usually done by the bootloader so the reset
> property is optional to work with them.
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> ---
>  .../devicetree/bindings/net/aspeed,ast2600-mdio.yaml         | 5 +++++
>  1 file changed, 5 insertions(+)
> 


Reviewed-by: Krzysztof Kozlowski <krzk@kernel.org>


Best regards,
Krzysztof
