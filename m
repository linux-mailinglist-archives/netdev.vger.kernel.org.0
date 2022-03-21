Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 991EC4E2CE6
	for <lists+netdev@lfdr.de>; Mon, 21 Mar 2022 16:53:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348202AbiCUPyn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 21 Mar 2022 11:54:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56826 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348079AbiCUPyj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 21 Mar 2022 11:54:39 -0400
Received: from mail-wr1-f42.google.com (mail-wr1-f42.google.com [209.85.221.42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C3B293A1BB;
        Mon, 21 Mar 2022 08:53:13 -0700 (PDT)
Received: by mail-wr1-f42.google.com with SMTP id h23so20691484wrb.8;
        Mon, 21 Mar 2022 08:53:13 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=O83M9g7HZ0bl5yKyCrG5hB98wSTjsEoQqTkE9qL5pAE=;
        b=8BgA6BjLtu+xaDQKDNK7nYnnJznHp+sr9IWRgNBESyRgA4Ct3xcuiw0wlJ9sPSSR7M
         7I1xC3cNXNiRcJ54HCTwPe+HXgGUw8KWWRFcSY+gf7jIaN2DOC3eBbBRXwLUcNa9ooH8
         tR4wnnkifU2jKxonQC0oFgCuFQmmz/aUO8SLCucRPgXjkTh0JzpkiYVGjJ7NFDqCvKB6
         rHRh7/S6SVNuimAWKYIiEH6S+yS7mxtmhvdf0KtGkbS9vYD4LvgwWxs/hXIujbVpgpqk
         ikEQ1UpSN2Igv+YKOMXNNWkTssFKjUERe3luOhnAqphsVWgfPB456jmMk/rUFAEMfRzm
         DDyQ==
X-Gm-Message-State: AOAM531kup/O/oje4VmeM121Z4/LANBYHg3DXAIbOs0h5oZAF71/G48Q
        lD/fA0ydCFjmyCbLrICEtzk=
X-Google-Smtp-Source: ABdhPJwMRG1dX+1zrHr+zFL5pS1NfgNXXqlzDQcAzX8jYM9eno1IAUX77WTCEo3QXtZLEbr9MvoIMg==
X-Received: by 2002:a5d:584a:0:b0:203:97f6:5975 with SMTP id i10-20020a5d584a000000b0020397f65975mr18579197wrf.612.1647877992260;
        Mon, 21 Mar 2022 08:53:12 -0700 (PDT)
Received: from [192.168.0.17] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.googlemail.com with ESMTPSA id o12-20020adfa10c000000b001efb97fae48sm14184830wro.80.2022.03.21.08.53.10
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 21 Mar 2022 08:53:11 -0700 (PDT)
Message-ID: <eefe6dd8-6542-a5c2-6bdf-2c3ffe06e06b@kernel.org>
Date:   Mon, 21 Mar 2022 16:53:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH v2 3/3] ARM: dts: aspeed: add reset properties into MDIO
 nodes
Content-Language: en-US
To:     Dylan Hung <dylan_hung@aspeedtech.com>, robh+dt@kernel.org,
        joel@jms.id.au, andrew@aj.id.au, andrew@lunn.ch,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net,
        kuba@kernel.org, pabeni@redhat.com, p.zabel@pengutronix.de,
        devicetree@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-aspeed@lists.ozlabs.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     BMC-SW@aspeedtech.com, stable@vger.kernel.org
References: <20220321095648.4760-1-dylan_hung@aspeedtech.com>
 <20220321095648.4760-4-dylan_hung@aspeedtech.com>
From:   Krzysztof Kozlowski <krzk@kernel.org>
In-Reply-To: <20220321095648.4760-4-dylan_hung@aspeedtech.com>
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

On 21/03/2022 10:56, Dylan Hung wrote:
> Add reset control properties into MDIO nodes.  The 4 MDIO controllers in
> AST2600 SOC share one reset control bit SCU50[3].
> 
> Signed-off-by: Dylan Hung <dylan_hung@aspeedtech.com>
> Cc: stable@vger.kernel.org

Please describe the bug being fixed. See stable-kernel-rules.

Best regards,
Krzysztof
