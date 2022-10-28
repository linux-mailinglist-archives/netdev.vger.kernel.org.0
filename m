Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 267DE611399
	for <lists+netdev@lfdr.de>; Fri, 28 Oct 2022 15:51:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229787AbiJ1Nvl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 Oct 2022 09:51:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46074 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229689AbiJ1NvL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 Oct 2022 09:51:11 -0400
Received: from mail-pf1-x430.google.com (mail-pf1-x430.google.com [IPv6:2607:f8b0:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C643DAEA1F;
        Fri, 28 Oct 2022 06:51:06 -0700 (PDT)
Received: by mail-pf1-x430.google.com with SMTP id m6so4881461pfb.0;
        Fri, 28 Oct 2022 06:51:06 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=gVR7uLVEIb14+gIUsjABrQEQi2BsRftXIio3cVFwFYQ=;
        b=mXLZFNyNtymeMlvxGAoMhzfwbQyjIXXXM12ojwNCUV47agltlck9ZxdWTShPILGCsY
         Ok4eyCLHrcgI7cYTvova61YIGnDsbhuX/RJE6FBKRTDBBl8v6UVyt7ffZapDkrrYeVoK
         TQZz/dTXzN70mxdy81R03x6s/+TuFsXGg5KnmIdPnnt6JL7/eS0kST4ARj8HfFSvrFGe
         FGyoANksj/IVaF8tYRYBXPusInU6OA1MmCr645RD0636ynWrmZAZPtAmkHkENzJrX4sS
         WLITgHitn4SIUWIlxGaZRuuSVM2kZptNwenCN4S6DufjZg7Jc33vFjoqRhOeFZeQkWCI
         jnjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:references:cc:to
         :content-language:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=gVR7uLVEIb14+gIUsjABrQEQi2BsRftXIio3cVFwFYQ=;
        b=hFgRNHqFlu0cfV9ViChCZdgcf1t2gzSMGXVIfXyCrT6jn592TZvWp9UZKL1szfO6M5
         xXocLcqoN9p9YgUictybA/jeV0tjIStzo/Tns30TnqPZgWL3H9CpkRMCP9BDB4pbf7Od
         uQ99e65Hj0Akl0WftxEWxCmlzKZnq5jUoJ46bcm9+7U5kX7t5XkOlgYXWsdFmhUST2TF
         ru155IoZcClEzkTguYhMHMfynsfKXh8z5ncl6xaNuc7sXGrBnsRZY1JcD4hsqEVuxa3W
         /IL9fHFv/fx5ngiOwKlxkGIdJXFryJKNK7aoiubHf03PIYLocyS0TgQfSJbKmhhHG0Xu
         VmYg==
X-Gm-Message-State: ACrzQf3rUOAykZDnAqeW6heWU14UvT+nEnSEdPsa+yFGGwUQo5Z3Ae/G
        5Wov2N0cyNvGhFR4a0QxLA0=
X-Google-Smtp-Source: AMsMyM6if4CBEcjN2RGRqt4eY19a8v/sOOaQYnzPkWhBOTpAgAtb7eX963Y9r6IJG/vjBS81PVWSGA==
X-Received: by 2002:a63:7704:0:b0:464:3985:8963 with SMTP id s4-20020a637704000000b0046439858963mr48420258pgc.154.1666965066258;
        Fri, 28 Oct 2022 06:51:06 -0700 (PDT)
Received: from [192.168.43.80] (subs03-180-214-233-72.three.co.id. [180.214.233.72])
        by smtp.gmail.com with ESMTPSA id p18-20020a170902ead200b00176a6ba5969sm3074274pld.98.2022.10.28.06.51.00
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 28 Oct 2022 06:51:05 -0700 (PDT)
Message-ID: <61febb47-28a4-3343-081c-4c06b87ba870@gmail.com>
Date:   Fri, 28 Oct 2022 20:50:59 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.4.0
Subject: Re: [PATCH 01/15] hamradio: baycom: remove BAYCOM_MAGIC
Content-Language: en-US
To:     Dan Carpenter <dan.carpenter@oracle.com>
Cc:     =?UTF-8?B?0L3QsNCx?= <nabijaczleweli@nabijaczleweli.xyz>,
        Jonathan Corbet <corbet@lwn.net>,
        Federico Vaga <federico.vaga@vaga.pv.it>,
        Alex Shi <alexs@kernel.org>,
        Yanteng Si <siyanteng@loongson.cn>,
        Hu Haowen <src.res@email.cn>,
        Thomas Sailer <t.sailer@alumni.ethz.ch>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        =?UTF-8?Q?Jakub_Kici=c5=84ski?= <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jirislaby@kernel.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-doc-tw-discuss@lists.sourceforge.net,
        linux-hams@vger.kernel.org, netdev@vger.kernel.org
References: <9a453437b5c3b4b1887c1bd84455b0cc3d1c40b2.1666822928.git.nabijaczleweli@nabijaczleweli.xyz>
 <47c2bffb-6bfe-7f5d-0d2d-3cbb99d31019@gmail.com> <Y1vccrsHSnF1QOIb@kadam>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <Y1vccrsHSnF1QOIb@kadam>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-0.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 10/28/22 20:43, Dan Carpenter wrote:
>>
>> Also, s/Kill it/Remove BAYCOM_MAGIC from magic numbers table/ (your
>> wording is kinda mature).
>>
> 
> The kernel has almost 13 thousand kills...
> 
> $ git grep -i kill | wc -l
> 12975
> $
> 
> It's fine.
> 

The word meaning depends on context. In this case, the author means
removing SOME_MAGIC magic number from the table, one by one until
the magic number documentation is removed (due to historical cruft).

Thanks.

-- 
An old man doll... just what I always wanted! - Clara

