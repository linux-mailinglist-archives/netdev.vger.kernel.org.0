Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FAB55BEA20
	for <lists+netdev@lfdr.de>; Tue, 20 Sep 2022 17:26:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230174AbiITP0W (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 20 Sep 2022 11:26:22 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51886 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231346AbiITP0T (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 20 Sep 2022 11:26:19 -0400
Received: from mail-lj1-x22f.google.com (mail-lj1-x22f.google.com [IPv6:2a00:1450:4864:20::22f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8E2F46611C
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:26:17 -0700 (PDT)
Received: by mail-lj1-x22f.google.com with SMTP id c7so3392569ljm.12
        for <netdev@vger.kernel.org>; Tue, 20 Sep 2022 08:26:17 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=linaro.org; s=google;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date;
        bh=4l7aMfmqCryjQwAP7nUR3rR023wPhPFZ45uqdGA6vXU=;
        b=ug41M0juoWTyFjlJFI3JO/BxOIkOyJX1HmmPygZID/A2DnhJvRY/vpvmZ6zDKaoN/9
         0iVDpLlXaxIX34fhgBHkS0UgbP2o5Zt97FlJwookkZY45p4frVPv0qG7BPk2Awsn68VM
         00DNt0kp/ihgQi2peCOsZnd7seMCnVOyGujvrhehLXya/jMDPjvMCG7H4luP04o0/LKP
         UAOYwyc4vImp7vdyM17Ul+GmrEkDW6T9/anC236oZqGTSAfAB+0b7xtPmcpXgEdYKGF7
         XC6tXPY5gYECtmW51sXIvoEKcsBSnFO+u20x9LPS+xAtOAHyyMwueAqo14sEm/sPdmjG
         aSkw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date;
        bh=4l7aMfmqCryjQwAP7nUR3rR023wPhPFZ45uqdGA6vXU=;
        b=Vhmg66jpCc5S0NhK4EQdZ4u/rLmVsjT0ijf6o2ADgy7diBv+qFSY5T5kBxM/bB4lyb
         ip3odipfi3V1bFGTos7a3qX6AfVxTmQh34aBSXx/SSzXSv9WmDHrIV9eRkrUi6h58dhe
         aUUJw3l3TMzDiZLC1ZR1BdANT+jhUZRzNau9W1xz/FCiTk+MiWz6+5MK2LPbVVXxa+1v
         YRozMTlK0Pz3+hsTGFfLtd4mFsdn4mb2rY0tWvyB0HyuhRB614MgPXeM1OKQltO4fQMc
         bbmaiQxb6NVLF2C7gssqm4Ls52S1UeXoqKgBqtZPA1LqsvxjbVSDEAJwe9KLtBHJnysl
         AX+A==
X-Gm-Message-State: ACrzQf2vWGkTRY5C86ws8l0it5q8u/puYtJ2eMxNNmD1Erm1WP1Icf9i
        9BkgR83woOgQFccVXGpSKSglKA==
X-Google-Smtp-Source: AMsMyM4JKyvwhM7YiHyZtwVoNrtUcBKYR2S6GGTDusaMteI1RsYMqBPofBm3W7n40MgCMtIOk+opOg==
X-Received: by 2002:a2e:a549:0:b0:26c:4988:2742 with SMTP id e9-20020a2ea549000000b0026c49882742mr4206383ljn.11.1663687575964;
        Tue, 20 Sep 2022 08:26:15 -0700 (PDT)
Received: from [192.168.0.21] (78-11-189-27.static.ip.netia.com.pl. [78.11.189.27])
        by smtp.gmail.com with ESMTPSA id be17-20020a056512251100b0049a4862966fsm10743lfb.146.2022.09.20.08.26.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 20 Sep 2022 08:26:15 -0700 (PDT)
Message-ID: <ada6ef7f-0106-6a30-64ad-66b3277d987b@linaro.org>
Date:   Tue, 20 Sep 2022 17:26:14 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.13.0
Subject: Re: [PATCH 1/2] dt-bindings: net: mediatek-dwmac: add support for
 mt8188
Content-Language: en-US
To:     Jianguo Zhang <jianguo.zhang@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>
Cc:     Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@foss.st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        Biao Huang <biao.huang@mediatek.com>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org
References: <20220920083617.4177-1-jianguo.zhang@mediatek.com>
 <20220920083617.4177-2-jianguo.zhang@mediatek.com>
From:   Krzysztof Kozlowski <krzysztof.kozlowski@linaro.org>
In-Reply-To: <20220920083617.4177-2-jianguo.zhang@mediatek.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.3 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS autolearn=unavailable autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 20/09/2022 10:36, Jianguo Zhang wrote:
> Add binding document for the ethernet on mt8188
> 
> Signed-off-by: Jianguo Zhang <jianguo.zhang@mediatek.com>

Please version your patches. git format-patch can do it for you.

Best regards,
Krzysztof
