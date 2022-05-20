Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 93ABF52EB77
	for <lists+netdev@lfdr.de>; Fri, 20 May 2022 14:03:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348924AbiETMCY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 May 2022 08:02:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55892 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348916AbiETMCX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 May 2022 08:02:23 -0400
Received: from mail-wm1-x32f.google.com (mail-wm1-x32f.google.com [IPv6:2a00:1450:4864:20::32f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AA3F314917A
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:02:19 -0700 (PDT)
Received: by mail-wm1-x32f.google.com with SMTP id k126so4422694wme.2
        for <netdev@vger.kernel.org>; Fri, 20 May 2022 05:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=6wind.com; s=google;
        h=message-id:date:mime-version:user-agent:reply-to:subject
         :content-language:to:cc:references:from:organization:in-reply-to
         :content-transfer-encoding;
        bh=FCIoMgX4YMt3LzpjNytfLzy8l6OAc+D1LAtrTBfwlHA=;
        b=gPfHequ7ktAF+p4/2qSPmF3+CpU9sowqy5eligOSuJ8+TMxCRSUjzWR07ViV0E7mWp
         6YJPnzE1nr0sAdvAGBAv73Jo+98V7C8/wZObFYidXuMu6lcpKz8be+MHLl5RXUSgtIfY
         fG7D+rrS9UIqjx6NUi6DkE3f+O8wD8o5FNt0htL66MfjvmyDijxWVCT23I8b7TLzHuCh
         PFr2SKzGoghn9aH1paIHRmwNHxN5Db2jhq+PdlRNW8p9ONJq2nWuWq5+fbWbJssYuz1v
         yeVwtz6TeaojB3KDrc3or7vRq0jO6b9OHrThVc3TQAxWyFZFDyt1K3jrCKdRUMkvjj+I
         IUpg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:reply-to
         :subject:content-language:to:cc:references:from:organization
         :in-reply-to:content-transfer-encoding;
        bh=FCIoMgX4YMt3LzpjNytfLzy8l6OAc+D1LAtrTBfwlHA=;
        b=hcAjEvBjY2nOzUDpSmgGlgXMdXUV8ESxJPJNoVjQT4hOrQHFcF2rLGMt3OiZvo+k8b
         X8+L6dESbaINUBA9HMozAMEBGAUU4zqPS4DHchIh4nbJnVUD3AA3RnzLP1iO7CIOCPTc
         GMxDyx2sgN9LUtXgV8PiEJdhV5BB3B/8kvnYjck/Npzo3G1k4UFW8ag6a2ZuR7gAbKyd
         lfsqQQ4sPSNfAky0yL5NhClmX+4sjsrwEtYRwiuvwQwbNG11tS6ZUmUYLvaFN/PU6Yyf
         61p79wz5qrRTUF0gglIT5riMUZz5LAq5PkbaxeRtFCo04GQESDYW0izbgcw42DdJQkCl
         a2Xw==
X-Gm-Message-State: AOAM533mSlRzX81K8pXboc4n35JMQI9etG2AcKGtXK+JGsi/A77ka3x+
        VUqlNnv/J/Yr78J6nGUFkC7JEg==
X-Google-Smtp-Source: ABdhPJxQ1mqYBP4sa6WQFYVkHdfutMFUAfSjHOnkIjnL1kOhAO3q7CtWIIWy8Knupb4yiAIwCKxf4Q==
X-Received: by 2002:a7b:c445:0:b0:397:28d3:d9cf with SMTP id l5-20020a7bc445000000b0039728d3d9cfmr8356674wmi.116.1653048138223;
        Fri, 20 May 2022 05:02:18 -0700 (PDT)
Received: from ?IPV6:2a01:e0a:b41:c160:e96e:bd3d:75ff:2c21? ([2a01:e0a:b41:c160:e96e:bd3d:75ff:2c21])
        by smtp.gmail.com with ESMTPSA id ay13-20020a05600c1e0d00b003944821105esm1861457wmb.2.2022.05.20.05.02.17
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 20 May 2022 05:02:17 -0700 (PDT)
Message-ID: <797315cf-ee0d-f272-7421-d493a6b29b9b@6wind.com>
Date:   Fri, 20 May 2022 14:02:16 +0200
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.8.1
Reply-To: nicolas.dichtel@6wind.com
Subject: Re: [PATCH ipsec-next] xfrm: no need to set DST_NOPOLICY in IPv4
Content-Language: en-US
To:     Eyal Birger <eyal.birger@gmail.com>, dsahern@kernel.org,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, yoshfuji@linux-ipv6.org,
        steffen.klassert@secunet.com
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        shmulik.ladkani@gmail.com
References: <20220520104845.2644470-1-eyal.birger@gmail.com>
From:   Nicolas Dichtel <nicolas.dichtel@6wind.com>
Organization: 6WIND
In-Reply-To: <20220520104845.2644470-1-eyal.birger@gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Le 20/05/2022 à 12:48, Eyal Birger a écrit :
> This is a cleanup patch following commit e6175a2ed1f1
> ("xfrm: fix "disable_policy" flag use when arriving from different devices")
> which made DST_NOPOLICY no longer be used for inbound policy checks.
Thanks for the follow-up.

Nicolas
