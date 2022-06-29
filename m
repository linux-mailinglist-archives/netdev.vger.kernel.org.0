Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 55AB155FA10
	for <lists+netdev@lfdr.de>; Wed, 29 Jun 2022 10:09:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229879AbiF2IHt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 Jun 2022 04:07:49 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230349AbiF2IHs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 29 Jun 2022 04:07:48 -0400
Received: from mail-ed1-x52f.google.com (mail-ed1-x52f.google.com [IPv6:2a00:1450:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A78323BA41
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:07:47 -0700 (PDT)
Received: by mail-ed1-x52f.google.com with SMTP id e40so21084026eda.2
        for <netdev@vger.kernel.org>; Wed, 29 Jun 2022 01:07:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=blackwall-org.20210112.gappssmtp.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=tqDYe+CaxG5rdxrYEshOizmWJw2UB37F2HUQkIlbpzg=;
        b=eTa5kFPRhJ9XXCyyvuOAJJD9KztwiyJQVOdeTwhCfAJ8/3zUUatQUlSLeJ+Fiu9pA7
         kpnodWjT/LVmq3UFR4Rv14xKzK2psWjiUaGTxZuip23qTnQSpU4l+TO388gVpGEZQBoj
         N7lY3ZL1rrCFNpdMZtg7G1byq/bHLicqMZ6AfPxZv7k87s+1AZY4O73FfpnkwNS721/h
         DJ95nr0M3Vkuoc99UYP+J0i6sh1KjQg7Ompeb1D0m2CM0D98Kl8ZMaEwh8KCPdKNLXxA
         7GjaQgnPQQ315EakB8OwowLdRW0qeAEhG38i64dnVQ+EmH3jZCGSunJxhWhT+Zdn2qBJ
         EejQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=tqDYe+CaxG5rdxrYEshOizmWJw2UB37F2HUQkIlbpzg=;
        b=mTwn4IqNMCD9CxyM+xqGdSvpbWfgWz+NJ/ij4dI9yjQ0LMEoF6zqVPvSk6TbrvuITs
         U5E8nJvrcsxGj6n/TaccPs7A5hv+TYJMQhLu0kJ8Orea2OfmEKz4UTmm6qWQxPrTGOdr
         Q/C4EzDNo3EQfGMKMIJ1ACwe1WnmPNNjtgEg4I7rYwHfQeX51t8F23/8XA5DWmS93t9l
         Ur93FX2DZyYhpTdgxQo8tvbyED+4bg/9JyjerZDpCW4ZVOIAzfZpjGVJs0GcNl9dCXu5
         KlH7x2+15Kj2GviLhansWjIasb3RmGuhQ/VLA+Io7jarLMIEtCGJEEkDQ1JmxSjr/toC
         i7Gw==
X-Gm-Message-State: AJIora9NBXwla7XJmZi42fjw2YfQ7UkI7/fWX1F4nlPVGAOWvvdFg4A7
        g0Wm2kMTbadsPqlMorZseQ5l8A==
X-Google-Smtp-Source: AGRyM1tuu9CQHgVFJEA7+0jyEpjwj+NgRKS3hxtfjlaGipukmjzZImAv7vIEB3AwtAheS2Zttv60cA==
X-Received: by 2002:a05:6402:440f:b0:435:2e63:aca9 with SMTP id y15-20020a056402440f00b004352e63aca9mr2521235eda.162.1656490066029;
        Wed, 29 Jun 2022 01:07:46 -0700 (PDT)
Received: from [192.168.0.111] (87-243-81-1.ip.btc-net.bg. [87.243.81.1])
        by smtp.gmail.com with ESMTPSA id ov24-20020a170906fc1800b006f3ef214d9fsm7358531ejb.5.2022.06.29.01.07.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 29 Jun 2022 01:07:45 -0700 (PDT)
Message-ID: <33ceacbe-7cde-d131-f208-2d53a47eca0e@blackwall.org>
Date:   Wed, 29 Jun 2022 11:07:43 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH net-next] net: switchdev: add reminder near struct
 switchdev_notifier_fdb_info
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Jiri Pirko <jiri@resnulli.us>,
        Ivan Vecera <ivecera@redhat.com>,
        Roopa Prabhu <roopa@nvidia.com>,
        Ido Schimmel <idosch@nvidia.com>
References: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
From:   Nikolay Aleksandrov <razor@blackwall.org>
In-Reply-To: <20220628100831.2899434-1-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 28/06/2022 13:08, Vladimir Oltean wrote:
> br_switchdev_fdb_notify() creates an on-stack FDB info variable, and
> initializes it member by member. As such, newly added fields which are
> not initialized by br_switchdev_fdb_notify() will contain junk bytes
> from the stack.
> 
> Other uses of struct switchdev_notifier_fdb_info have a struct
> initializer which should put zeroes in the uninitialized fields.
> 
> Add a reminder above the structure for future developers. Recently
> discussed during review.
> 
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-2-schultz.hans+netdev@gmail.com/#24877698
> Link: https://patchwork.kernel.org/project/netdevbpf/patch/20220524152144.40527-3-schultz.hans+netdev@gmail.com/#24912269
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>
> ---
>  include/net/switchdev.h | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/include/net/switchdev.h b/include/net/switchdev.h
> index aa0171d5786d..7dcdc97c0bc3 100644
> --- a/include/net/switchdev.h
> +++ b/include/net/switchdev.h
> @@ -239,6 +239,9 @@ struct switchdev_notifier_info {
>  	const void *ctx;
>  };
>  
> +/* Remember to update br_switchdev_fdb_populate() when adding
> + * new members to this structure
> + */
>  struct switchdev_notifier_fdb_info {
>  	struct switchdev_notifier_info info; /* must be first */
>  	const unsigned char *addr;

Reviewed-by: Nikolay Aleksandrov <razor@blackwall.org>

