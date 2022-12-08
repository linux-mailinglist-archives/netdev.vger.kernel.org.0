Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9B74D6473E5
	for <lists+netdev@lfdr.de>; Thu,  8 Dec 2022 17:07:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229942AbiLHQHv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Dec 2022 11:07:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52718 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229995AbiLHQHu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Dec 2022 11:07:50 -0500
Received: from mail-il1-x132.google.com (mail-il1-x132.google.com [IPv6:2607:f8b0:4864:20::132])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 28F0914D34
        for <netdev@vger.kernel.org>; Thu,  8 Dec 2022 08:07:48 -0800 (PST)
Received: by mail-il1-x132.google.com with SMTP id z9so1162937ilu.10
        for <netdev@vger.kernel.org>; Thu, 08 Dec 2022 08:07:48 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :from:to:cc:subject:date:message-id:reply-to;
        bh=MwFWqUJT8gv+Qi9XtXRvqgiJMG2LdrPKlJJeX/oYf3A=;
        b=UZW/JB3KkxZd0+jACQAH6RaeLWFU+StWUlvk3zrGRFIJKQsqy0riy4dz6isxkfjQAO
         mCWFB10nlDT2Tl21jdvddFYQH+nfSkv1C7PLdoqqm8C11ff4BMYNqTSuYM0GOvec22y/
         PU13w7PzuHfbbIJrqIwTHliPeKcApkaZ76aPFj55KRUpvxLSO+NgIdchZJ4wGyO+sMNe
         Oz0bcXpzfC78rQALWK4+vGcjjiPeRJImW93CRoLQyRl+ssDIW5cJF8XHN8652r3173Ow
         XXsDZHSNAiFC8poUFFSTtbHuCNlK58QCJxz5CHMlz3t2RbQUL5/pqUubUjRH0SFvCmEg
         bMHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=content-transfer-encoding:in-reply-to:from:content-language
         :references:cc:to:subject:user-agent:mime-version:date:message-id
         :x-gm-message-state:from:to:cc:subject:date:message-id:reply-to;
        bh=MwFWqUJT8gv+Qi9XtXRvqgiJMG2LdrPKlJJeX/oYf3A=;
        b=lY1TxTKmro3woIHS+UfEqusX9+UbJ9pJ965jExzyCmjVkn4U1mmlFkO3Df8fZec+o9
         mXtqX3Sh4zr4WVRXZw4GH3YdQ0fnts2jA/yeGdQIHEBqG4BvkVuEAcjmb9/15BL3gEfs
         chr7knbABl7iT3ccZrpzX0h3CWXV+YKhYV2Xh+lhSGVfEuIa5lFXh+UEvimSG8Cr3Z4V
         y+6Loz0Od1esydg4g/Cn39ksgdpfOOuQamT/RflYL+7QESpm53wQQnl11K+yWfHGTGCC
         LiBN/dbWYXfySqsn5F6PvuUnyWdZlp6AjDhINSb1KgvUDMtDNtUH7ncKMQ4Rx1x6DYaU
         UrYA==
X-Gm-Message-State: ANoB5pkGtUG4gX53MG6MSkvsmdPbdwV8Id+YCSDBw8nyPSG8CjXPOykl
        fab9Tu+zXBgeXOX9sWV+n3K1mXV0Vz0=
X-Google-Smtp-Source: AA0mqf6KqJdF5of0rESVHnLDKWiPGh/3C7cNHvQ5dD8VJ5I4rtfC5A0U3MuUAeElb3ZiHzohek52YQ==
X-Received: by 2002:a92:c5d0:0:b0:302:c541:624b with SMTP id s16-20020a92c5d0000000b00302c541624bmr1593592ilt.15.1670515667963;
        Thu, 08 Dec 2022 08:07:47 -0800 (PST)
Received: from [172.16.99.146] (c-73-14-130-18.hsd1.co.comcast.net. [73.14.130.18])
        by smtp.googlemail.com with ESMTPSA id ci7-20020a0566383d8700b00389e690d09esm8580558jab.74.2022.12.08.08.07.46
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Thu, 08 Dec 2022 08:07:46 -0800 (PST)
Message-ID: <2131854c-a23d-81a2-c9c4-5764e14b8afe@gmail.com>
Date:   Thu, 8 Dec 2022 09:07:45 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:102.0)
 Gecko/20100101 Thunderbird/102.5.1
Subject: Re: [PATCH iproute2-next] libnetlink: Fix wrong netlink header
 placement
To:     Ido Schimmel <idosch@nvidia.com>, netdev@vger.kernel.org
Cc:     stephen@networkplumber.org, mlxsw@nvidia.com
References: <20221208143816.936498-1-idosch@nvidia.com>
Content-Language: en-US
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <20221208143816.936498-1-idosch@nvidia.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/8/22 7:38 AM, Ido Schimmel wrote:
> The netlink header must be first in the netlink message, so move it
> there.
> 
> Fixes: fee4a56f0191 ("Update kernel headers")
> Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> ---
>  include/libnetlink.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/include/libnetlink.h b/include/libnetlink.h
> index 4d9696efa253..c91a22314548 100644
> --- a/include/libnetlink.h
> +++ b/include/libnetlink.h
> @@ -38,9 +38,9 @@ struct nlmsg_chain {
>  };
>  
>  struct ipstats_req {
> +	struct nlmsghdr nlh;
>  	struct if_stats_msg ifsm;
>  	char buf[128];
> -	struct nlmsghdr nlh;
>  };
>  
>  extern int rcvbuf;

thanks for noticing this. Must have been stale diff on the branch when I
was looking into the flex-array problem.
