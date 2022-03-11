Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 67D8B4D599D
	for <lists+netdev@lfdr.de>; Fri, 11 Mar 2022 05:34:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343955AbiCKEej (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Mar 2022 23:34:39 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240668AbiCKEef (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Mar 2022 23:34:35 -0500
Received: from mail-io1-xd33.google.com (mail-io1-xd33.google.com [IPv6:2607:f8b0:4864:20::d33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6AF74BF95E
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:33:33 -0800 (PST)
Received: by mail-io1-xd33.google.com with SMTP id l18so1647624ioj.2
        for <netdev@vger.kernel.org>; Thu, 10 Mar 2022 20:33:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=ug0vcNKpS4i9QRtSPQ13Ebyd6q88a2L9AuMOs+BGbnY=;
        b=pEmnYXxkfAacEdDdCHlY6g1nW28P1hTu9csOn6mhFGftxBOhfr5bCDFRPJMIHsrUx5
         sgWjtTLX2pDtkaJj5TNkRzH/aX22ugZ+sQdNOaH2PSmrMcDD8EtRvNYr11M8b0/IREvC
         wYqYkeB3/ujwTLBUtyOVwRZ0YqO4Qt+z+luHhvFkSerZCa3+mmUKCmQLig4hOaMntuKT
         kUvw/ldbvG45AOA3xflAWYyPPyv4vRQtRsCznmk/+SI/KzeuD7MglwEGBfSMI9H/DA2g
         QgB9ilpVzwWDZSS0B5UpBJw0TCZEXgD8oiDIZqwOt5uTfRYkzOR+GUcxJ9BUTDceqJHD
         x/mQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=ug0vcNKpS4i9QRtSPQ13Ebyd6q88a2L9AuMOs+BGbnY=;
        b=l9QHV/q/vfOSPaktmmU7DJTHG44Gtd7FF8/TZm4I9ooeGYPF2nj97Ep/oxVQBCfJYV
         KSBhwR1BFU3v8TABGRQDHQihJwF0Cg6kfUi2qmqpJQkAgl4xBko2I0Vlf2VD6chE/IMJ
         d8zu2vqV6vhV81WqD9BSVgZCr2UlXeyonrS0q0vcShkbXKtu6BnhWRVQdF8PxPULTGdK
         ZE658pfUf6QWjqvxJPbeUFe2ybu13CNgA6ErtoAv3YDRko5TndEW3D51p2jLNTBJ4MpU
         en/eiVImDI1vzmZZAUEQ+tiPzABeN3TvyLlJnKn5X5EwZZHzehDu1JknnczUDEYZcg75
         +q0g==
X-Gm-Message-State: AOAM532rrUMZtyoXzg7p/HQAUHUJ9WdcZoO5TvCRJpUwP0i7pOoOeSFS
        0SGuIr9mui2HLjpi/S8bVOw=
X-Google-Smtp-Source: ABdhPJynT1ULNCAt1/DpKwiYLCbn48IfmwOuZtJguc7hVbAiqfX0XFdAFjlwnsE4lxSHW+J02v/AtA==
X-Received: by 2002:a6b:2b49:0:b0:63d:a8e7:538d with SMTP id r70-20020a6b2b49000000b0063da8e7538dmr6669779ior.207.1646973212839;
        Thu, 10 Mar 2022 20:33:32 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id t3-20020a922c03000000b002c6509399c4sm3764154ile.26.2022.03.10.20.33.32
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 10 Mar 2022 20:33:32 -0800 (PST)
Message-ID: <b68493ab-34b2-f9c0-3313-d430b0cffb6e@gmail.com>
Date:   Thu, 10 Mar 2022 21:33:30 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] net: remove exports for
 netdev_name_node_alt_create() and destroy
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org
References: <20220310223952.558779-1-kuba@kernel.org>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20220310223952.558779-1-kuba@kernel.org>
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

On 3/10/22 3:39 PM, Jakub Kicinski wrote:
> netdev_name_node_alt_create() and netdev_name_node_alt_destroy()
> are only called by rtnetlink, so no need for exports.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> ---
>  net/core/dev.c | 2 --
>  1 file changed, 2 deletions(-)
> 

Reviewed-by: David Ahern <dsahern@kernel.org>

