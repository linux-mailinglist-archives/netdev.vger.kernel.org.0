Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B7BB4EB8F2
	for <lists+netdev@lfdr.de>; Wed, 30 Mar 2022 05:37:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242353AbiC3DhD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Mar 2022 23:37:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41970 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S242344AbiC3Dg5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Mar 2022 23:36:57 -0400
Received: from mail-pl1-x62b.google.com (mail-pl1-x62b.google.com [IPv6:2607:f8b0:4864:20::62b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F15B3BFBC;
        Tue, 29 Mar 2022 20:35:12 -0700 (PDT)
Received: by mail-pl1-x62b.google.com with SMTP id m18so14482706plx.3;
        Tue, 29 Mar 2022 20:35:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=PBAW2vqx4mTqaLF8rY9rXbvj8sF9d8ZKUwvPMd8+b7k=;
        b=RQXOxXTvKU73wHLr0oljHCxMgWGOpjfMQA9Cqw2v83+uLm2FV+8GzRsJWkiGyyRdRl
         b7gBPkaYidrBejv/SyENQVrosr7NuPqycL0ECkzPYDgKzLDUFE4nC+s0b6286bg1dr61
         wyEIKPorDmYwUGYPXTSEED5nfUAzPv07my0tAztn6LnPiYZYo0QpyXErgrckRbmjAJ5O
         HdytKR94NRHXMnzrIDf4tuROjjs1nsQQqdSaJHB40VMgNk0XHbJO6iHCFTnjLEV78oeA
         bSySWz4N6WEv95xmMPHBROfET4q3KTwdBiv7yKRjd7b6j/zB7HRYWOfuzsmJiJJBooDW
         ngfw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=PBAW2vqx4mTqaLF8rY9rXbvj8sF9d8ZKUwvPMd8+b7k=;
        b=dYiP6VrAkuae2TMw/Rhp3WbuUSxgYJKCNPuvba0N8U6SguRdQyOH6qx4LdGSICI1a6
         XDFoESWNV6ynH7DMVgVSvlksG/vvcVDqEYIYyV02N+EN5Ii689HBfH89bfGhO4xtR6x/
         r9KNKJ0G0ZEJGCsHkZY+1OZ6PiG+A98vYbHEXRZrnKuBs+J9mZ7kw7Tb9YKsKznsresP
         QnOBg6t6zKRY/luuIR8hVUp3OvUFccb6sT9erOemf5Qgi9qtERzxJNWb7sJ5uUdP72v+
         sJNuS+Myqjgok+Utx/iE4KJ6ie3sUKNMXK4npHQ5Urwl/0rByCDNZbU/0ZZokn/xxug0
         QGkw==
X-Gm-Message-State: AOAM531EZbwT9Ny6refvMDI2CCJmLTh/NdJNSxW9lX5Vd05CwCOy84y5
        s09k1S7g3m02T3CnMICPx7I=
X-Google-Smtp-Source: ABdhPJyIGEpRpXvGTxV+3XETP5z2O6ZD8RasexvAQlKFLnS5XW6+f/OzgzZ0IiQucbZJhwR+ViVZCQ==
X-Received: by 2002:a17:90a:4890:b0:1bf:654e:e1a0 with SMTP id b16-20020a17090a489000b001bf654ee1a0mr2642325pjh.113.1648611311732;
        Tue, 29 Mar 2022 20:35:11 -0700 (PDT)
Received: from [192.168.1.3] (ip72-194-116-95.oc.oc.cox.net. [72.194.116.95])
        by smtp.gmail.com with ESMTPSA id k14-20020aa7820e000000b004f7134a70cdsm20618368pfi.61.2022.03.29.20.35.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 29 Mar 2022 20:35:10 -0700 (PDT)
Message-ID: <4dabb2c8-2d06-ca33-d9a4-3afe2004594b@gmail.com>
Date:   Tue, 29 Mar 2022 20:35:09 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.7.0
Subject: Re: [PATCH net v2 14/14] docs: netdev: move the netdev-FAQ to the
 process pages
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, pabeni@redhat.com, corbet@lwn.net,
        bpf@vger.kernel.org, linux-doc@vger.kernel.org, andrew@lunn.ch
References: <20220329050830.2755213-1-kuba@kernel.org>
 <20220329050830.2755213-15-kuba@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220329050830.2755213-15-kuba@kernel.org>
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
> The documentation for the tip tree is really in quite a similar
> spirit to the netdev-FAQ. Move the netdev-FAQ to the process docs
> as well.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
