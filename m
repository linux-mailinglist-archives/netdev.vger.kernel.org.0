Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADB6535D6E
	for <lists+netdev@lfdr.de>; Fri, 27 May 2022 11:31:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243184AbiE0JaU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 27 May 2022 05:30:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50540 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232733AbiE0JaT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 27 May 2022 05:30:19 -0400
Received: from mail-pf1-x431.google.com (mail-pf1-x431.google.com [IPv6:2607:f8b0:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 55596B7D2;
        Fri, 27 May 2022 02:30:18 -0700 (PDT)
Received: by mail-pf1-x431.google.com with SMTP id f21so3880280pfa.3;
        Fri, 27 May 2022 02:30:18 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=Kb85+2Sd4OjNt+4J6/Cs/eNfwpCKX3GUphCee7XFrA0=;
        b=dRA5kKlB4Vxde9Kn5agHxoJaXKC90MjU4QDOC+rZq4NLGVzOcNe9EKFibNOB1rPk5T
         nl2pRDtCiHcdTQDz88k04+KJds+1OdZBIf2XJmViwOYUqIZ/MtRM4xzL2WIpzWVPKoWg
         a9ahqPsBfneglleaPSt8iRTCBqKiN4QoA4reGENx5hugwB4qrUNK8a5KDQy2LqTysWgy
         80ns+RyQVtTuv1KGWAOXqtEqGM8J/s4uGOchCsP4s9rgyu79tQyEFIVBNKM1PzI58bhu
         pfIFqSkrKGl21TtR/UZkJzAnpiOakY0kE3v1ZltbS5HwUDlbxfr/qbNP46ItsiNi+BLF
         wW9A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=Kb85+2Sd4OjNt+4J6/Cs/eNfwpCKX3GUphCee7XFrA0=;
        b=cXM0D5DKOTpzyr3GB5FQbj8P6c5gd09RnaPLp05v/vT8/ga1QKpPGOFJdXqiMtTT/z
         UiNNsy5I1HRqUb7zv8eW66Lxjms4OmSQUKHlHDE05SVwlMPv3jdwuXhTEB2Znzqn6uDN
         SF68BeYqyX4dKL3/K2aRKF8FJKW3xtGYaCPG8n0RAfcTP4PqZeM2W0/MOzOZg3LGDQYX
         c4OTumAvSZP13n1d/Hd9mPmlXjoJYxIFKM70/nfLb5dx+3nI6z/BZaDNMbH4d5H/Z5br
         yn2tm8n4bvsnbbyDX7ogS7EA4EKk9BkZMdOVIa5GkGTTt81ffx3AeLf4HadGOKADRAPP
         iG0g==
X-Gm-Message-State: AOAM533XPBZjrPyiSTkHfuYCn9j0af51CZx212wIbA9qUJoM18iQRI3F
        STq9q2tWJ15yZFnWn6SK14/Pzr8a0ks=
X-Google-Smtp-Source: ABdhPJxv3qbdZEQ+ZKYas5PE5Hw73EwjZbafG3koZF/0HUt4zVxZ1LvuI7uC/m+PGHV93tlQTJuj4Q==
X-Received: by 2002:a65:6a15:0:b0:3f6:1815:f540 with SMTP id m21-20020a656a15000000b003f61815f540mr35560176pgu.45.1653643817739;
        Fri, 27 May 2022 02:30:17 -0700 (PDT)
Received: from [192.168.43.80] (subs32-116-206-28-49.three.co.id. [116.206.28.49])
        by smtp.gmail.com with ESMTPSA id k71-20020a63844a000000b003db7de758besm3042313pgd.5.2022.05.27.02.30.13
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 27 May 2022 02:30:16 -0700 (PDT)
Message-ID: <4ef24dae-bad0-9641-7eb9-7d8207d198be@gmail.com>
Date:   Fri, 27 May 2022 16:30:11 +0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.9.1
Subject: Re: [PATCH net] net/ipv6: Change accept_unsolicited_na to
 accept_untracked_na
Content-Language: en-US
To:     Arun Ajith S <aajith@arista.com>, netdev@vger.kernel.org
Cc:     davem@davemloft.net, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, dsahern@kernel.org,
        yoshfuji@linux-ipv6.org, kuba@kernel.org, pabeni@redhat.com,
        gilligan@arista.com, noureddine@arista.com, gk@arista.com
References: <20220527073111.14336-1-aajith@arista.com>
From:   Bagas Sanjaya <bagasdotme@gmail.com>
In-Reply-To: <20220527073111.14336-1-aajith@arista.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,RCVD_IN_SORBS_WEB,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/27/22 14:31, Arun Ajith S wrote:
> This change expands the current implementation to match the RFC. The
> sysctl knob is also renamed to accept_untracked_na to better reflect the
> implementation.
>

Say in imperative, "Expand and rename accept_unsolicited na to
accept_untracked_na" in both commit/patch subject and message.

> -accept_unsolicited_na - BOOLEAN
> +accept_untracked_na - BOOLEAN
>  	Add a new neighbour cache entry in STALE state for routers on receiving an
> -	unsolicited neighbour advertisement with target link-layer address option
> -	specified. This is as per router-side behavior documented in RFC9131.
> -	This has lower precedence than drop_unsolicited_na.
> +	neighbour advertisement with target link-layer address option specified
> +	if a corresponding entry is not already present.
> +	This is as per router-side behavior documented in RFC9131.
>  
> -	 ====   ======  ======  ==============================================
> -	 drop   accept  fwding                   behaviour
> -	 ----   ------  ------  ----------------------------------------------
> -	    1        X       X  Drop NA packet and don't pass up the stack
> -	    0        0       X  Pass NA packet up the stack, don't update NC
> -	    0        1       0  Pass NA packet up the stack, don't update NC
> -	    0        1       1  Pass NA packet up the stack, and add a STALE
> -	                        NC entry
> -	 ====   ======  ======  ==============================================
> +	This has lower precedence than drop_unsolicited_na.
>  

I think you should have made similar logical expansion of drop_unsolicited_na to
drop_untracked_na. Otherwise, ...

>  	/* RFC 9131 updates original Neighbour Discovery RFC 4861.
> -	 * An unsolicited NA can now create a neighbour cache entry
> -	 * on routers if it has Target LL Address option.
> +	 * NAs with Target LL Address option without a corresponding
> +	 * entry in the neighbour cache can now create a STALE neighbour
> +	 * cache entry on routers.
>  	 *
> -	 * drop   accept  fwding                   behaviour
> -	 * ----   ------  ------  ----------------------------------------------
> -	 *    1        X       X  Drop NA packet and don't pass up the stack
> -	 *    0        0       X  Pass NA packet up the stack, don't update NC
> -	 *    0        1       0  Pass NA packet up the stack, don't update NC
> -	 *    0        1       1  Pass NA packet up the stack, and add a STALE
> -	 *                          NC entry
> -	 * Note that we don't do a (daddr == all-routers-mcast) check.
> +	 *   entry accept  fwding  solicited        behaviour
> +	 * ------- ------  ------  ---------    ----------------------
> +	 * present      X       X         0     Set state to STALE
> +	 * present      X       X         1     Set state to REACHABLE
> +	 *  absent      0       X         X     Do nothing
> +	 *  absent      1       0         X     Do nothing
> +	 *  absent      1       1         X     Add a new STALE entry
>  	 */

The Documentation/ diff above drops behavior table but in the code comment
it is updated. Why didn't update in Documentation/ instead?

And my nitpick: for consistency, prefer en-US words over en-UK or mixed
varieties when writing (s/behaviour/behavior/gc, s/neighbour/neighbor/gc).

-- 
An old man doll... just what I always wanted! - Clara
