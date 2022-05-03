Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9FDAC518D1B
	for <lists+netdev@lfdr.de>; Tue,  3 May 2022 21:23:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239149AbiECT0a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 May 2022 15:26:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230079AbiECT03 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 May 2022 15:26:29 -0400
Received: from mail-pf1-x432.google.com (mail-pf1-x432.google.com [IPv6:2607:f8b0:4864:20::432])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B735A2A70C;
        Tue,  3 May 2022 12:22:56 -0700 (PDT)
Received: by mail-pf1-x432.google.com with SMTP id bo5so15526785pfb.4;
        Tue, 03 May 2022 12:22:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=xD1u/BOCFh8co86RcbO90R+LMkeSGzDA0te4TNIgVnc=;
        b=Xjgo9vAzqDLWsngCdL0oCPVql0nzfcFk2SSIdmCMLATXOmaVeQCZCN4DKeH+lAkf1O
         ApoLQh6yYF+KlknXXk37SgF0IUCmZUXeoUI4jYNzkiy2d6Um5/ekhyJyplicT2ljmqZ/
         sDicOfaZ0aySEg1OqXZgc2OIJKNjXpNVhm5c5qiUM6FJof8+CXCbebW4FwQF+CfitRbU
         a9cL31d6/w6Ur+DQGMXL6D1Ital7QMrqNugGS6rI7G2+J5B9+QBgGVpIOTwuv4cKyk2h
         cLIo0NWC9ZKPAxX8bLfbUvCziVLFxu+Fne0dL1V0Neq5CmSyK4UCZPKF3I6v+cw0OUMK
         Y3Sg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=xD1u/BOCFh8co86RcbO90R+LMkeSGzDA0te4TNIgVnc=;
        b=PQrWRuWzeR0stHqqDCuFBeYXbaBetXPK0uinG/Narm7iWeRkAoBwBFxv1PIogp4+gP
         IfQBgID6xP0hubm45+LS9P4c3WjSpzsaPetLYC1NTSapZLic8HxRUtPIum6QQIyxEh0T
         HJKxk9d/bXkemAOyroDd2P+e0jtt1yIa/JEKnQrolirO1XD3cmEIDmp9HmEALpkOazsV
         LzeRMeYqFOXI5pRVMmxszlhZUFK09T1OK7XlGK+SYA4v1/TLwy8X8V5wrAIMQZy6u4yo
         OkH/wsZG0/fCU6ch54R0n259YnEcKyhKqMjXUyvstKvaK7M/6CXA6lUJ9mrE8VPuNigt
         Rieg==
X-Gm-Message-State: AOAM532/ojmi2HZJZKibPGwbphM0LXSPvLZ3Ia1MWlHS4WufjFmSWjZp
        04SoosgjHfzfQR3dmM3TfYA=
X-Google-Smtp-Source: ABdhPJzXllvznstYNI0LiRA+WwuQ8GZ9pEl9wM4hLsuhz6R8TZtqrGsqGrG38Q5PF1RNS6nebgUrtg==
X-Received: by 2002:a63:6987:0:b0:3aa:eec1:1587 with SMTP id e129-20020a636987000000b003aaeec11587mr14868503pgc.144.1651605776227;
        Tue, 03 May 2022 12:22:56 -0700 (PDT)
Received: from [10.67.48.245] ([192.19.223.252])
        by smtp.googlemail.com with ESMTPSA id s19-20020aa78d53000000b0050dc76281d0sm6831662pfe.170.2022.05.03.12.22.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 03 May 2022 12:22:55 -0700 (PDT)
Message-ID: <ed9bf7db-4437-f24e-6e57-18df4f485c37@gmail.com>
Date:   Tue, 3 May 2022 12:22:51 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Subject: Re: [Patch net-next v12 01/13] dt-bindings: net: make
 internal-delay-ps based on phy-mode
Content-Language: en-US
To:     Arun Ramadoss <arun.ramadoss@microchip.com>, bpf@vger.kernel.org,
        linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>, Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Russell King <linux@armlinux.org.uk>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Eric Dumazet <edumazet@google.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vladimir Oltean <olteanv@gmail.com>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>, UNGLinuxDriver@microchip.com,
        Woojung Huh <woojung.huh@microchip.com>
References: <20220502155848.30493-1-arun.ramadoss@microchip.com>
 <20220502155848.30493-2-arun.ramadoss@microchip.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220502155848.30493-2-arun.ramadoss@microchip.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.0 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/2/22 08:58, Arun Ramadoss wrote:
> From: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> 
> *-internal-delay-ps properties would be applicable only for RGMII interface
> modes.
> 
> It is changed as per the request,
> https://lore.kernel.org/netdev/d8e5f6a8-a7e1-dabd-f4b4-ea8ea21d0a1d@gmail.com/
> 
> Ran dt_binding_check to confirm nothing is broken.
> 
> Signed-off-by: Prasanna Vengateshan <prasanna.vengateshan@microchip.com>
> Signed-off-by: Arun Ramadoss <arun.ramadoss@microchip.com>
> Reviewed-by: Andrew Lunn <andrew@lunn.ch>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
