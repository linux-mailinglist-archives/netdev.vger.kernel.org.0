Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 11CB43C8AB0
	for <lists+netdev@lfdr.de>; Wed, 14 Jul 2021 20:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239986AbhGNSXV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Jul 2021 14:23:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58270 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbhGNSXU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Jul 2021 14:23:20 -0400
Received: from mail-oo1-xc33.google.com (mail-oo1-xc33.google.com [IPv6:2607:f8b0:4864:20::c33])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0CCA5C06175F;
        Wed, 14 Jul 2021 11:20:28 -0700 (PDT)
Received: by mail-oo1-xc33.google.com with SMTP id n24-20020a4ad4180000b029025bcb88a40eso854575oos.2;
        Wed, 14 Jul 2021 11:20:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=IZHV17HrDm3mXvlMglOQgvLLp42WlpMA1EiV1Ps+/BI=;
        b=H+vm6oqHFE6x5nWY0AIBWZrMU/JFV1E7RlfPV+htdU7SqDZZNrKwrdLtrafZc/AorS
         A1cI3NKH0fEKqOI4Al014QT8bwC0hHpab3fl6RAGB1cFpYFLf8fnP2oh4Rzrr+dfGKpw
         Mf0r3bS175zI3IYORzlw2VwRPBmPKAVYUF2pmBbeHNKu4K6n75aOez1hPrxCwm6UtxNK
         Jy+67R0NeXPH1meUzyTOjHe7YgUH46e0TKUhMdKS1PlV7MtP4wCP3tVD8ePGffDa5Xee
         9VcZqpMV9OmUPoBjvETHo5dMsjF5p98QUm1pHe16Z1ij/jmr9TMkRHlOPr8vZjoHrMJl
         e0cQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=IZHV17HrDm3mXvlMglOQgvLLp42WlpMA1EiV1Ps+/BI=;
        b=mv2bsrwhcqARaKk7NsMkQn0QeatgikcadnZhKelQ+4mrZ+vkCfXOOMbujRsyy2U2+q
         cL2O/skofEWpec5GOPtU1gx/d/tg3WqmaifIHTKED7zeEMa82NLoSqGLhl7Im1ASW7Xx
         0J2rUrcSEaZ7qGwZ0Ij6WkVPI7Luoa82s6JUzfaoIeTauzBsSbgtky6Z1D65HishzKot
         Tmt3nKfD6KDj+H4ZbQFIAXWVfTQZCCHrbwtwkQjFCG8s9UJpeWdegnTpytq5cbXHyPt6
         JV06ot7axG/HgDVNoMfnA5ph7M2UvJmFVdn4ILz/LaTv00lwTqvN5MfVXdSu6meX8F9d
         NwTA==
X-Gm-Message-State: AOAM5307Pd8X0zkz2mjeldc6ExloR1Exu9uCy7IPGQAckWMViRVhuCsQ
        EMxZu7ryA2lplAalnMF5PFc=
X-Google-Smtp-Source: ABdhPJzsxslVMe/u0X4ex3JA+B6DQS3NdJKCEqD6Tg0m4IaMXYXw659YBjHMM1dTLnt4gmZP+/qkdg==
X-Received: by 2002:a4a:97ed:: with SMTP id x42mr8831385ooi.49.1626286827439;
        Wed, 14 Jul 2021 11:20:27 -0700 (PDT)
Received: from Davids-MacBook-Pro.local ([8.48.134.38])
        by smtp.googlemail.com with ESMTPSA id b10sm645794oiy.4.2021.07.14.11.20.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 14 Jul 2021 11:20:27 -0700 (PDT)
Subject: Re: [PATCH] ipv6: remove unused local variable
To:     Rocco Yue <rocco.yue@mediatek.com>,
        "David S . Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        David Ahern <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        Matthias Brugger <matthias.bgg@gmail.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, wsd_upstream@mediatek.com,
        rocco.yue@gmail.com
References: <20210714151533.6210-1-rocco.yue@mediatek.com>
From:   David Ahern <dsahern@gmail.com>
Message-ID: <c524c725-84ce-0106-6e28-bf5c7dc36e30@gmail.com>
Date:   Wed, 14 Jul 2021 12:20:25 -0600
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210714151533.6210-1-rocco.yue@mediatek.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 7/14/21 9:15 AM, Rocco Yue wrote:
> The local variable "struct net *net" in the two functions of
> inet6_rtm_getaddr() and inet6_dump_addr() are actually useless,
> so remove them.
> 
> Signed-off-by: Rocco Yue <rocco.yue@mediatek.com>
> ---
>  net/ipv6/addrconf.c | 6 ++----
>  1 file changed, 2 insertions(+), 4 deletions(-)
> 

please add 'net' or 'net-next' in the subject line.  e.g.,
[PATCH net-next]

Reviewed-by: David Ahern <dsahern@kernel.org>
