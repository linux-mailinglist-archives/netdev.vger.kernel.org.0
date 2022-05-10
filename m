Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7CA6B520B71
	for <lists+netdev@lfdr.de>; Tue, 10 May 2022 04:44:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234939AbiEJCs2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 22:48:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232495AbiEJCs1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 22:48:27 -0400
Received: from mail-io1-xd36.google.com (mail-io1-xd36.google.com [IPv6:2607:f8b0:4864:20::d36])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D5C627F135;
        Mon,  9 May 2022 19:44:32 -0700 (PDT)
Received: by mail-io1-xd36.google.com with SMTP id r27so17271941iot.1;
        Mon, 09 May 2022 19:44:32 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=f8UJqGII15EUvAh7IVf71vJDer3ywxR+YC79U4WRNxg=;
        b=IIuYSphoxM5Xe74hHyUvVMx4rZYWDgA//kqo93jCh5ZzUb94Mi486Lg/keBF+gcczl
         x6zS5eYgw5zDwrucwJ5k7Xoa/DS7n+M11FUkyUmTK9VP5CkRGr/+lA+ogibvf5b0AQjY
         OzHnl7dYP/ejbqslbi8R36pWk1zPihsU+x3qgOW8O3/A64Z8xvg1bfWFUzzmXlciIIAn
         ihi1Vn3ZY4NQdPuU1Gy9Pyl29qq2Yl7+tcAfrknMJqg06GtIV3gV5Y9I5EfTgzigXlZh
         P5nSTDH5Sgmb9WahyhINli1SoSxTPOqVP1VKYYqkMeaPv8AScouN4NyeAtWyB23aHX72
         SG/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=f8UJqGII15EUvAh7IVf71vJDer3ywxR+YC79U4WRNxg=;
        b=YWWDWtgpmRvBgePRuRUPehyd9ootFjKzMnE7iIeMhjk3Z1C6yGfP5Hpg9swjL9xsss
         rLdv26eOniFotrTjrBn41LADzmUeiZGAWDfUQQ/OL33kDUWZvsnLiYL4Kr7if6A94hLX
         p8tBk4TrG8jUJyclIC+HpOxKuHllh+gUbhxDot1MRM2DT4sIjZILtaYX9io7VUWO3rnP
         l4P3aaAwHZVWOzs4HeZp9UEw6Ybjxd5AgUzIfGRuPh1Ss5y5F1EWfKmIdPJtr9U7CrWU
         k7VmEdX3ZKzaPK1ggtSAsBHj1IZPkf5DQoVOBrPnuk6J6mkxe4ok554BDeFXOC1SneBc
         4s9w==
X-Gm-Message-State: AOAM530YjYazP47HdMDYjH8VfO79IgxDI6qFNcKJav4MNXY2A8YnlU2+
        yVrEZBlhfFiS3xbfPWkUrBA=
X-Google-Smtp-Source: ABdhPJyXLLuEDD9M3yW9LnoWjmZogru3bafdzoOFDyhv+X4IIHArlzC+yIAOkUzW8Ffz9vijA3fR/A==
X-Received: by 2002:a05:6638:d0a:b0:32b:b579:6875 with SMTP id q10-20020a0566380d0a00b0032bb5796875mr8983698jaj.291.1652150671562;
        Mon, 09 May 2022 19:44:31 -0700 (PDT)
Received: from ?IPV6:2601:282:800:dc80:e970:4f57:6d9a:73c8? ([2601:282:800:dc80:e970:4f57:6d9a:73c8])
        by smtp.googlemail.com with ESMTPSA id e131-20020a6bb589000000b0065a47e16f38sm3675091iof.10.2022.05.09.19.44.29
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 09 May 2022 19:44:30 -0700 (PDT)
Message-ID: <6d8a4c78-648f-07fe-496a-4ab34891f716@gmail.com>
Date:   Mon, 9 May 2022 20:44:28 -0600
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.9.0
Subject: Re: [PATCH net-next 0/3] docs: document some aspects of struct
 sk_buff
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, edumazet@google.com, pabeni@redhat.com,
        linux-doc@vger.kernel.org, corbet@lwn.net, imagedong@tencent.com,
        talalahmad@google.com
References: <20220509160456.1058940-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220509160456.1058940-1-kuba@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/9/22 10:04 AM, Jakub Kicinski wrote:
> This small set creates a place to render sk_buff documentation,
> documents one random thing (data-only skbs) and converts the big
> checksum comment to kdoc.
> 
> RFC v2 (no changes since then):
>  - fix type reference in patch 1
>  - use "payload" and "data" more consistently
>  - add snippet with calls
> https://lore.kernel.org/r/20220324231312.2241166-1-kuba@kernel.org/
> 
> RFC v1:
> https://lore.kernel.org/all/20220323233715.2104106-1-kuba@kernel.org/
> 
> Jakub Kicinski (3):
>   skbuff: add a basic intro doc
>   skbuff: rewrite the doc for data-only skbs
>   skbuff: render the checksum comment to documentation
> 
>  Documentation/networking/index.rst  |   1 +
>  Documentation/networking/skbuff.rst |  37 ++++
>  include/linux/skbuff.h              | 301 ++++++++++++++++++----------
>  3 files changed, 232 insertions(+), 107 deletions(-)
>  create mode 100644 Documentation/networking/skbuff.rst
> 

Reviewed-by: David Ahern <dsahern@kernel.org>
