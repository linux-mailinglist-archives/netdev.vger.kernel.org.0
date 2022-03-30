Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 36A2A4EB8D8
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:32:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242299AbiC3DdS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:33:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234408AbiC3DdP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:33:15 -0400
Received: from mail-pl1-x62e.google.com (mail-pl1-x62e.google.com [IPv6:2607:f8b0:4864:20::62e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3A8DD1DA8D4;
        Tue, 29 Mar 2022 20:31:32 -0700 (PDT)
Received: by mail-pl1-x62e.google.com with SMTP id a16so2449198plh.13;
        Tue, 29 Mar 2022 20:31:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=dOsNViykPVGcbncAms4BbmDoEHmpV4QWA/s1jP7jRuM=;
        b=EpCtpgnwEU9yPP08z/68qgiEvgcBqlKLzdBej5oRZ41z9fBOhe2wogvqezT4i8oDKo
         +tP5pW7DgE3ZWdG1eqdlBd/TXrz2f77DEOj9SX5ZIIEjC4UqPkwwGwGloPcQgahR48qh
         1MM9A2RfHaPXKVqL2b6jRaN6rG13ok8O8nIw184dHUsLMCOimQYdNUzEytcL96VYSVX7
         25sA5w1PO4lYbxatkQW2ocID2p9pg6rRkyfiVqM7i6OoKq8qUIREU4IYB5yrsVd6nlCE
         ev6UcmU3WtKnxIEyUcWHggaQfdqk5iwqsSMJfmq8iwKf16wSERBXVOjgEFjelA6C1zTZ
         xahA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=dOsNViykPVGcbncAms4BbmDoEHmpV4QWA/s1jP7jRuM=;
        b=deTHE508L0pHld6wzL4xVEJSYgqDUdYl8KPDR4IMRE9e/1iY4Zt8ypfn9WAsCNsdZ+
         EHYPJcC76D1HltjDpve8mu8OEgiX7fxCBgLg31AVNjot5fK5hhTTbMOEH0E4iNJCaGA6
         zmuY8zBKzy9s5B9p+CG5toXcsxUjleekHovSajtbiAYcFYjWE5LZNz26egQkk8FEICSg
         a9ui0VpMpsomjL/wDGWQLlbVLurmRB/Jly/lw6KuatnvG0CBt5n94SUm2RYy6Q1a2579
         Wg512xz5UVI+v4U82NdK5rUmIdgzCLqa4mCm+IYDxQpItBaLATANSy2doGzhaswKwgBX
         pofg==
X-Gm-Message-State: AOAM530oZxx3iRgsuu8l6Pfl+FSs23CpsBA7pdsUgV7NCyoW5t3dYevn
        IAV6EgE+tq6oIWtVzt8Muiw=
X-Google-Smtp-Source: ABdhPJwYvs/BxTCrRgHQVX4ekybZsuA5y3faeQFTfOJxLLqJeQ52KpnOFSkbe8IE9QbsLBRLhG94vg==
X-Received: by 2002:a17:90a:4217:b0:1c7:c203:b4f3 with SMTP id o23-20020a17090a421700b001c7c203b4f3mr2611487pjg.177.1648611091748;
        Tue, 29 Mar 2022 20:31:31 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id p128-20020a625b86000000b004fa666a1327sm20751778pfb.102.2022.03.29.20.31.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:31:30 -0700 (PDT)
Message-ID: <b6fb423d-7bc0-46f5-97d2-4edb06f76c2d@gmail.com>
Date:   Tue, 29 Mar 2022 20:31:28 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 06/14] docs: netdev: shorten the name and mention
 msgid for patch status
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-7-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-7-kuba@kernel.org>
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



On 3/28/2022 10:08 PM, Jakub Kicinski wrote:
> Cut down the length of the question so it renders better in docs.
> Mention that Message-ID can be used to search patchwork.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
