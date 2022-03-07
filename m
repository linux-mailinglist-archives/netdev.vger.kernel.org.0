Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4A0A94D060D
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:12:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244663AbiCGSNi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:13:38 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49702 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S244662AbiCGSNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:13:36 -0500
Received: from mail-oo1-xc31.google.com (mail-oo1-xc31.google.com [IPv6:2607:f8b0:4864:20::c31])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DBD792458F
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:12:41 -0800 (PST)
Received: by mail-oo1-xc31.google.com with SMTP id h16-20020a4a6f10000000b00320507b9ccfso18805444ooc.7
        for <netdev@vger.kernel.org>; Mon, 07 Mar 2022 10:12:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=4ilbLX/565r9ksOpHmBVHn67RxbleG+IcW1pxbSG8Qg=;
        b=SEbdyfJS7G4rm3ZbcmpA9hqRy98+wogTqyVdBTPClzrYKkfUa887gRC6X8oKni79ex
         AHLVysu6nFh76kT6zZvb/8Qngw1Gp9GBYvai2Mi4Tx9TgcKydhn76MHsqBfpaDLSdZV4
         HCM2Je2WDAHKLt2aPTpgDb/mOzYX+J/iLqxpC777fJJqH8u3Hmtkd3Lrj7u8t9XVlGzQ
         bd5jz+jWvZZEEYs8+Vxlwxm1o2C1Gvhx8pX0fRgA5AMrGnUAjy1dNcbYir5xSXLAGezq
         kHh2eDEe+sasQV9/dnRIZ/Q3y5U7VfTV0Zh3KCZgzzZfMWc6Su3ucdsH/AVJtU5PdgOp
         rtoA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=4ilbLX/565r9ksOpHmBVHn67RxbleG+IcW1pxbSG8Qg=;
        b=TEcHoMInzg5+OfQOHtL4sLMbNlQarz2yLCxvHYQtLzwLpzDJL0xAvEVNZQApPNgLLC
         BnNyXylun4daNc0RT5fa4+1T0sTo2pwEPiPTug9rV4m83ZwZLFGY+7rayxlOUeZz7JbX
         TRezZeWVGzJ6od/Z4Qf5FiOqskQwdgAQ6PjE0veGCXiuG+yIUL3smrYl8Y2diCd21Sqh
         p8QhEDjLYPJSGROUtJWyITfNPiRqc3zD2hW7g5C2im8d+1jPFdoJRDXOLuyNqwIGqlzU
         14fdyzhfUCS8ULgzhsWFrV6TmAvNEQRgD0ALKMLtwMZIK/zZd9yoF5SffeJkKm+lsHQJ
         b5eQ==
X-Gm-Message-State: AOAM532jM2P4XlhZXusPqN1XhMDDlYMjh+gtZPrfGODqSHZrkDr82WMq
        EDjThKygElQxOt50aEe5/TU=
X-Google-Smtp-Source: ABdhPJzkf7Bxt+Ba6JzuQUpXHpGyXvGQHApzv4qIJXSI5l8U2DWwZDqPuHxUvEIZmiiZJZNd/tMOPA==
X-Received: by 2002:a05:6870:1613:b0:da:b3f:2b3c with SMTP id b19-20020a056870161300b000da0b3f2b3cmr92321oae.219.1646676761321;
        Mon, 07 Mar 2022 10:12:41 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.65])
        by smtp.googlemail.com with ESMTPSA id q6-20020a056870028600b000d9be0ee766sm5130132oaf.57.2022.03.07.10.12.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 07 Mar 2022 10:12:41 -0800 (PST)
Message-ID: <3f97df10-a70f-786c-d8ca-a03c2fef060e@gmail.com>
Date:   Mon, 7 Mar 2022 11:12:39 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2 v2 1/2] lib/fs: fix memory leak in
 get_task_name()
Content-Language: en-US
To:     Andrea Claudi <aclaudi@redhat.com>,
        Leon Romanovsky <leon@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org,
        markzhang@nvidia.com
References: <cover.1646223467.git.aclaudi@redhat.com>
 <0731f9e5b5ce95ab2da44ac74aa1f79ead9413bf.1646223467.git.aclaudi@redhat.com>
 <YiEPeU8z5Y+qd3+l@unreal> <YiZJzokKojVtEH4S@tc2>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <YiZJzokKojVtEH4S@tc2>
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

On 3/7/22 11:07 AM, Andrea Claudi wrote:
> Thanks for letting me know. I usually rely a lot on Fixes: as iproute2
> package maintainer, but I'll change my habits if this is the common
> understanding. Stephen, David, WDYT?

I think a Fixes tag is relevant here.
