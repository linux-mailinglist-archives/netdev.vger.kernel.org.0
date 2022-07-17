Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id BD722577760
	for <lists+netdev@lfdr.de>; Sun, 17 Jul 2022 18:56:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232060AbiGQQ44 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 17 Jul 2022 12:56:56 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35084 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232180AbiGQQ4z (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 17 Jul 2022 12:56:55 -0400
Received: from mail-pl1-x633.google.com (mail-pl1-x633.google.com [IPv6:2607:f8b0:4864:20::633])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E91914006
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:56:55 -0700 (PDT)
Received: by mail-pl1-x633.google.com with SMTP id w7so7163348ply.12
        for <netdev@vger.kernel.org>; Sun, 17 Jul 2022 09:56:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :cc:references:from:in-reply-to:content-transfer-encoding;
        bh=MJ1rNt+3+MhR39AX0mgmRfzKo8MKFvAssVwwTnvP+Po=;
        b=hdDlv4pAJSc9s6ae0k1IKZfs78oMKGp0/c5IuRFYcC50TZkGGwR9xOE2PkH9zxN2LW
         xpB/5hwXHXCSyy5DiVDhLHnC2g4iGkqv2zm6FnwbpI2NzQoi0t4S9+kpVVZ8hc141An8
         NOJHDcAlRkf6NhrGtnrMCsljqt0AhfD7RyL0iNtrctOR0fAoPTBqqy6VSs4u7pepKUUJ
         8jPXKRqWJcCqpbwOjmxAvQ2oft+TYmLWgIySYPF2IAV69fWMb1zrrM7iRkJODnhpWnuB
         fVSakZDo4+oQKjKJD3YEutS6H1aL5mRPrSXvT3wcXJZO/1AS+x+nMIF12B1VJDbtzqci
         YUcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:cc:references:from:in-reply-to
         :content-transfer-encoding;
        bh=MJ1rNt+3+MhR39AX0mgmRfzKo8MKFvAssVwwTnvP+Po=;
        b=W6qItq6NnzrlAbbnzH3KG3mTPq35sEuPGHLK2T9ZVLSy8OR0DfO6LFeUF8O8cCOt/h
         6JP6ZQ9zwjG+Gxk5xp8iHSyadlGcqsS4Ns3rF6s7VGtj6Y3Hq1JZeBBS63v4mP2lnHyo
         7WgfDaMnFCU/2w01p25Takdoj6nonBSH0YMh40HCQLy855aYAs1puU2dswqAbCXvBbvM
         0jTOovSD1UV5QEMBRMYdbJNDHNbrVbWbVVf7OGdugFeeRtbTMbGWp6Mn7nE9Mn06GbUf
         HFWyfGW8EMaUxuc6xfVWRj5Uw4f2TFyfLKIH8DXgSPJE6LtZnTrSJ9frxXstEfZf5MXs
         rDPg==
X-Gm-Message-State: AJIora/PE8DE62l1aCSEs1/wiGK0lyOZfb4e7I054cjNetNPvtvjJiGY
        hrMJIUKQHtG4EvihZ4zoupe4/KT2XqI=
X-Google-Smtp-Source: AGRyM1sTrOGqJ3wntUxxX/FoAUFx+sxob8toslnOodWlbm50y4j/5IftdW8CBOAWl6PmrO4L/kJNcQ==
X-Received: by 2002:a17:903:22c8:b0:16c:4068:cd with SMTP id y8-20020a17090322c800b0016c406800cdmr24294767plg.59.1658077014495;
        Sun, 17 Jul 2022 09:56:54 -0700 (PDT)
Received: from ?IPV6:2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5? ([2600:8802:b00:4a48:c1c9:5ca7:2a60:8cc5])
        by smtp.gmail.com with ESMTPSA id mi9-20020a17090b4b4900b001ec84b0f199sm21937026pjb.1.2022.07.17.09.56.53
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 17 Jul 2022 09:56:54 -0700 (PDT)
Message-ID: <2ebd2305-751b-db0c-4f4a-a4d16a4b684b@gmail.com>
Date:   Sun, 17 Jul 2022 09:56:52 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:102.0) Gecko/20100101
 Thunderbird/102.0.2
Subject: Re: [PATCH net 01/15] docs: net: dsa: update probing documentation
Content-Language: en-US
To:     Vladimir Oltean <vladimir.oltean@nxp.com>, netdev@vger.kernel.org
Cc:     "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>
References: <20220716185344.1212091-1-vladimir.oltean@nxp.com>
 <20220716185344.1212091-2-vladimir.oltean@nxp.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
In-Reply-To: <20220716185344.1212091-2-vladimir.oltean@nxp.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,NICE_REPLY_A,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/16/2022 11:53 AM, Vladimir Oltean wrote:
> Since the blamed commit we don't have register_switch_driver() and
> unregister_switch_driver() anymore. Additionally, the expected
> dsa_register_switch() and dsa_unregister_switch() calls aren't
> documented.
> 
> Update the probing section with the details of how things are currently
> done.
> 
> Fixes: 93e86b3bc842 ("net: dsa: Remove legacy probing support")
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
