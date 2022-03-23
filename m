Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 51A664E59B2
	for <lists+netdev@lfdr.de>; Wed, 23 Mar 2022 21:14:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344581AbiCWUQW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Mar 2022 16:16:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43726 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242759AbiCWUQV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Mar 2022 16:16:21 -0400
Received: from mail-pj1-x102d.google.com (mail-pj1-x102d.google.com [IPv6:2607:f8b0:4864:20::102d])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7CA56450;
        Wed, 23 Mar 2022 13:14:51 -0700 (PDT)
Received: by mail-pj1-x102d.google.com with SMTP id m22so2832578pja.0;
        Wed, 23 Mar 2022 13:14:51 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=sYah4SQ6W5gTXb2skvrUwE0UEgeqEkzpL8l65r/35FQ=;
        b=f4+4CT/zI9xJEEoy/SkNPQFcM1czgdB+qToPtmg8m8QF9UoEI0jQPib+phZG29WBnb
         xQy/7GquJnndMlwh19dUdFJyRDGnPIM+CE8fCRwgKrbP6mSOgqQLdabluFHQTcn6yMBD
         NNXPxFP2jmoXQUQynMLEMWWYMV7jzRfl+EJ0dDgSE49QtZNuWgKbyUZZbtk/Cpcf7sga
         GXLTKnmUSLZDTbvbIC22PwYgb9pS0imbne8DB/AjafWQQKlsDADCklDS4HvvIZv2Vc20
         jCSuYkxNiXzn6j6dz+5zJ1Bp5BlQGCNFHj5qghRC4JEY8DcUfWKy07xU29PVQR3OijrX
         qiAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=sYah4SQ6W5gTXb2skvrUwE0UEgeqEkzpL8l65r/35FQ=;
        b=v3oL9BsK50PHEO8pd8/dg6SI1ECTyf/AzNKpVQDWYWXmZQdEUZc+8AYJyz+PCFYOeL
         PSL+BAzoPf4nZDJREq7xxxoG9v8F5SjUbgYv45DBNoxP4vnzhh1+5scrQG9yn1u0cXqA
         iiAUGVaz9cqyE/uY9+YMj1I3NZe7LkRYZJjk7gbTI7TX8KFahFfRSzDapK5jOmIOF86X
         N+PTrA1m8GJNn/uk1j2WgLqWOX1Sa3aYIZGpsAuNtXRlpWv8JbvWy02zDL3+4Nlyq0Au
         nJDDbg/WIHsimdrhAk90wDdxjDmQ1EGH8ncQWDz+cxqBpykkMg6/i0J8IvCYv1oo0Ib3
         Mt1w==
X-Gm-Message-State: AOAM531U8pPa1PcwqMNIB10dOvxBRQkJNyQXboknWxJzsfW/CZie/tg5
        WRfBXxAfCaqRLS9PiN9K8e4=
X-Google-Smtp-Source: ABdhPJzZE6U1gBg7GK3BXfNCNRtxNBr8VckFk+ezjoOV4N65Y9oyrSaeDmvOiO4HGY7Ye89RNB9FVA==
X-Received: by 2002:a17:90a:ca06:b0:1c6:6af7:db3 with SMTP id x6-20020a17090aca0600b001c66af70db3mr1592461pjt.217.1648066491303;
        Wed, 23 Mar 2022 13:14:51 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id a5-20020a621a05000000b004f79f8f795fsm844289pfa.0.2022.03.23.13.14.48
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 23 Mar 2022 13:14:50 -0700 (PDT)
Message-ID: <3b695cb6-c0f9-a099-273a-cee14f287163@gmail.com>
Date:   Wed, 23 Mar 2022 13:14:47 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.5.0
Subject: Re: [PATCH RFC net-next 3/5] net: phy: mscc-miim: add
 probe_capabilities
Content-Language: en-US
To:     Michael Walle <michael@walle.cc>, Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Xu Liang <lxu@maxlinear.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20220323183419.2278676-1-michael@walle.cc>
 <20220323183419.2278676-4-michael@walle.cc>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220323183419.2278676-4-michael@walle.cc>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/23/22 11:34, Michael Walle wrote:
> The driver is currently only capable of doing c22 accesses. Add the
> corresponding probe_capabilities.
> 
> Signed-off-by: Michael Walle <michael@walle.cc>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
