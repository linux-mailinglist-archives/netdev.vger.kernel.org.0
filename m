Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5E3384DBBF2
	for <lists+netdev@lfdr.de>; Thu, 17 Mar 2022 01:57:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351974AbiCQA6J (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Mar 2022 20:58:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50626 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1345483AbiCQA6C (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 16 Mar 2022 20:58:02 -0400
Received: from mail-oi1-x232.google.com (mail-oi1-x232.google.com [IPv6:2607:f8b0:4864:20::232])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EB4ED1A3A4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 17:56:44 -0700 (PDT)
Received: by mail-oi1-x232.google.com with SMTP id q129so2186542oif.4
        for <netdev@vger.kernel.org>; Wed, 16 Mar 2022 17:56:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=9Q72f0vYYm41O/RxkXSFPIWfv73+ZCMtJ3sf/t6ST70=;
        b=QFxNE41xlWkMXkjSZMKk3a6hVGb4z0Jh5xYo8DtCLTe08eHjGqYiQRybl7f56dWxOU
         ZhVlnDmTUxw4RkJC6P0HO7gzgYKcCQbVkh8b1W+v72q3RCzbRODDmPd9iVj0n/Hc5XDJ
         xxsnb83JoKIAK4m8bp5Tfa+pdfqfM2Tpyu0GqCwvyEi+A+Fjc2O5+3ky3Kb0sVvYuV+h
         QVyd8xR672KcRYEgbxUmAqZoIC9rcLjlgoJBvkXC10+32Jh/ujVyMAX01ksjnPuLYpvX
         YPE9E9Eue6XtAYdU4ngZKN5bQ9J84RReFMuQOkZ4KWAI1x5Jgcsxwxfi9S4LUXp076OU
         dopA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=9Q72f0vYYm41O/RxkXSFPIWfv73+ZCMtJ3sf/t6ST70=;
        b=kbfWFuGD14jz9K3Hh+tATU/3MQq9hiMnBT34j5n0uL2wWh/1XDNip5nGU1uXrlH10s
         /XJxiq4VhofOvmKsy5IhuQEI5cLTXaEeLcyZ7V0l/UV+wHS6fUvzedl/8B3gDa1Kjs3x
         5qU0g5ZgkU4dm0vdAjWTRGhSiaIWHboFyu00bi+HJc7ZcIflskEXc/v3Ru5z50N+5LB1
         JVlpWjUjl+0ToIHyUl8YIuwRR75EME+L5vyY2GljVPwTSWEFqhu9mlECa71PB6BAN6/j
         Ufo5jjwn+3oST77Ls1ZwJy0E5obKbFlB2MBk+ma3QwBxLr/UwmAfh0JV7a9z+tdtSbVo
         xcWg==
X-Gm-Message-State: AOAM533WKMhDIPJSRJvnuldjCj+pNvKGrVqoEOIR8Z63mb4Cd1q7CcKQ
        +36R5Bu1wjGRHTT4GhL8Pv4=
X-Google-Smtp-Source: ABdhPJyN3WgS2JsrzwODHqA2QsjrbGLYedJMgv/RNlsYtiivTZ2f6dlgy8bfrWLpnMyMVuokZXNxwA==
X-Received: by 2002:a05:6808:11c2:b0:2d9:a01a:4bc2 with SMTP id p2-20020a05680811c200b002d9a01a4bc2mr937569oiv.233.1647478604302;
        Wed, 16 Mar 2022 17:56:44 -0700 (PDT)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id y128-20020acae186000000b002d97bda3873sm1725519oig.56.2022.03.16.17.56.43
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 16 Mar 2022 17:56:43 -0700 (PDT)
Message-ID: <c1cb87c2-0107-7b0d-966f-b26f44b23d80@gmail.com>
Date:   Wed, 16 Mar 2022 18:56:42 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2-next v5 1/2] ip: GTP support in ip link
Content-Language: en-US
To:     Wojciech Drewek <wojciech.drewek@intel.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org
References: <20220316110815.46779-1-wojciech.drewek@intel.com>
 <20220316110815.46779-2-wojciech.drewek@intel.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220316110815.46779-2-wojciech.drewek@intel.com>
Content-Type: text/plain; charset=UTF-8
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

On 3/16/22 5:08 AM, Wojciech Drewek wrote:
> +static void gtp_print_opt(struct link_util *lu, FILE *f, struct rtattr *tb[])
> +{
> +
> +	if (tb[IFLA_GTP_ROLE]) {
> +		__u32 role = rta_getattr_u32(tb[IFLA_GTP_ROLE]);
> +
> +		print_string(PRINT_ANY, "role", "role %s ",
> +			     role == GTP_ROLE_SGSN ? "sgsn" : "ggsn");
> +	}

as a u32 does that mean more roles might get added? Seems like this
should have a attr to string converter that handles future additions.

