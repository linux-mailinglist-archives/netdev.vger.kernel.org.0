Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0722952BFFF
	for <lists+netdev@lfdr.de>; Wed, 18 May 2022 19:09:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240752AbiERRHU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 May 2022 13:07:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240748AbiERRHS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 May 2022 13:07:18 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C19D4674DB
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:07:14 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id eg11so3804715edb.11
        for <netdev@vger.kernel.org>; Wed, 18 May 2022 10:07:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=hsAlikGx92mCeiFg9O3cngIJIidnkU67xQah0T79V9E=;
        b=MzI9pw7AsqcYTpvGHOeflY5oIdkBv+CH6Eyc0pnFtfyP1rw5T50gyZDvuyv9VKNIr+
         KjyEw4NvYjPlJT8zRy2Ik0rpVMUaojYaUkTWBA/Pjl6Nrr+3h8Z3gqzFEc/OC09Ld/Oq
         yO7LsbnCuGYMvkkKFXlFYaDowt0GjF3MKtXttaFPcRpY595Em9Qv5i+3NBzMS9eptI5/
         DAzLFR2LW8k1s/Jy4RvqwtN+Nz1RGZVzAD+OlCUjdjxXKlC1gKtLYJvItI5rXw5Hptsm
         73PCxXC3TUZQAforph98tDagP/uVhyy24fhjAXGKXNhDzVmujuICP3gYNXPMQ39wZShA
         nB8A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=hsAlikGx92mCeiFg9O3cngIJIidnkU67xQah0T79V9E=;
        b=sos1RYVa8L7x21cT7A0czsn8xufvz713OaDAlmi9/smCOza/dbQymnMrmdKO71aler
         Px8udko1xue23kFa5Z0LeYR6sanNty5/hBfBhKO6QPhkY1naKuTm9cZWDTT7FmjNyExk
         ibNcEekqhXxixxVRLJ7S8iv/Qfigui1Q4upi46hnzcl2BmLZ+T4NMdZuwqtFKkokAMFm
         GcWN2CE/zIpMCFcbx4+VlcQqAJS8vCIydruc1L9uZR7BsBtlvNH7KMAIv1LL5nK/H5oA
         9WRtnZoGpjTs6EhYDMuy/J5g3/gOKUavNDkPpXsNyMA2wY3QgiPRP6ZsCcC9NbHPA99P
         MkPw==
X-Gm-Message-State: AOAM530tdWl4goNY72WGONr4y6GLkg1a941pkSNVE0QKwEwcjSiPBYdI
        pceloQI+ulEY1CF6WmuO8l3cV8/oIqYUqw6u
X-Google-Smtp-Source: ABdhPJzL7nXnbBy5tXRogqV8XUha0BpJBoCVUyoaGBW0rwN7pvrN8az4wkleJbf5noHWvNakBljBWQ==
X-Received: by 2002:a05:6402:358a:b0:428:136f:766a with SMTP id y10-20020a056402358a00b00428136f766amr759218edc.403.1652893633260;
        Wed, 18 May 2022 10:07:13 -0700 (PDT)
Received: from [192.168.1.122] (cpc159313-cmbg20-2-0-cust161.5-4.cable.virginm.net. [82.0.78.162])
        by smtp.gmail.com with ESMTPSA id n21-20020aa7c455000000b0042ac2705444sm1546507edr.58.2022.05.18.10.07.12
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 May 2022 10:07:12 -0700 (PDT)
Subject: Re: [PATCHv3 net] Documentation: add description for
 net.core.gro_normal_batch
To:     Xin Long <lucien.xin@gmail.com>,
        network dev <netdev@vger.kernel.org>
Cc:     davem@davemloft.net, kuba@kernel.org
References: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
From:   Edward Cree <ecree.xilinx@gmail.com>
Message-ID: <9a16f24d-90a4-4a3e-3848-0513958631c3@gmail.com>
Date:   Wed, 18 May 2022 18:07:11 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <acf8a2c03b91bcde11f67ff89b6050089c0712a3.1652888963.git.lucien.xin@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/05/2022 17:09, Xin Long wrote:
> Describe it in admin-guide/sysctl/net.rst like other Network core options.
> Users need to know gro_normal_batch for performance tuning.
> 
> Fixes: 323ebb61e32b ("net: use listified RX for handling GRO_NORMAL skbs")
> Reported-by: Prijesh Patel <prpatel@redhat.com>
> Signed-off-by: Xin Long <lucien.xin@gmail.com>

Reviewed-by: Edward Cree <ecree.xilinx@gmail.com>

> ---
> v1->v2:
> - improve the description according to the suggestion from Edward
>   and Jakub.
> v2->v3:
> - improve more for the description, and drop the default for
>   gro_normal_batch, suggested by Jakub.
> 
>  Documentation/admin-guide/sysctl/net.rst | 9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> diff --git a/Documentation/admin-guide/sysctl/net.rst b/Documentation/admin-guide/sysctl/net.rst
> index f86b5e1623c6..46b44fa82fa2 100644
> --- a/Documentation/admin-guide/sysctl/net.rst
> +++ b/Documentation/admin-guide/sysctl/net.rst
> @@ -374,6 +374,15 @@ option is set to SOCK_TXREHASH_DEFAULT (i. e. not overridden by setsockopt).
>  If set to 1 (default), hash rethink is performed on listening socket.
>  If set to 0, hash rethink is not performed.
>  
> +gro_normal_batch
> +----------------
> +
> +Maximum number of the segments to batch up on output of GRO. When a packet
> +exits GRO, either as a coalesced superframe or as an original packet which
> +GRO has decided not to coalesce, it is placed on a per-NAPI list. This
> +list is then passed to the stack when the number of segments reaches the
> +gro_normal_batch limit.
> +
>  2. /proc/sys/net/unix - Parameters for Unix domain sockets
>  ----------------------------------------------------------
>  
> 

