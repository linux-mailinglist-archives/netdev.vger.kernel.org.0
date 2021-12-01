Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7A45E4645A5
	for <lists+netdev@lfdr.de>; Wed,  1 Dec 2021 05:00:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241667AbhLAEEN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 30 Nov 2021 23:04:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44338 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241642AbhLAEEM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 30 Nov 2021 23:04:12 -0500
Received: from mail-pf1-x435.google.com (mail-pf1-x435.google.com [IPv6:2607:f8b0:4864:20::435])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 95A6EC061574
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 20:00:52 -0800 (PST)
Received: by mail-pf1-x435.google.com with SMTP id p13so15270417pfw.2
        for <netdev@vger.kernel.org>; Tue, 30 Nov 2021 20:00:52 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-transfer-encoding:content-language;
        bh=7aYhjtGlxM/PKdsgMDzbERImGjg2ijv4dkzyPE2SdmM=;
        b=Rk12vG24rlsgfovfk6sJILiLptA/YRH+WHyQp8scqxdJytO8zbyAP5YNNNaJk3QIDJ
         VgT1BKib0G0S4SGV3cpkW4QiuaC96Cyztn37KRrHWZrJOj824C+ofWpVP6+pVF9oAO7H
         S7sDwndT3TVGkMzA403Af3iAAcDJQyq7tuZxuQB9CiEGRGYagaFhoMBge+W2lWzYG0A3
         Rsi5s765vBIKFGh04mT5iYLXQCe9A7laxmMwhoGamBRHzZj77wIIulAarcKNBVlhKVuF
         YEeadV/GeRDdWFAWh/Bx+SpvRfyLebo3XffWW0HBO1WOAYjpRkkxwN1jejAd5uHS8XGn
         0qGQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-transfer-encoding
         :content-language;
        bh=7aYhjtGlxM/PKdsgMDzbERImGjg2ijv4dkzyPE2SdmM=;
        b=ruIlR7ti/9FQL/z80gxaFJDU/7EBvXopLxOH3e73tHXSLIj0gjuwEaDiF8G3FtHjqB
         zs8BlLSLqjF371vjNFyXke9zVUWNaffTETiVgcxFO3ShD2rWbOklCUMVLTvn097Bi0tg
         8zhBLWJbhGNirrIlH4n4Pvw7URmKqb7o9Htz+KZmUPFxidsBqKaxnulK2ldeCL6wlaXN
         QqC6ssMus9kujtt1J8QEz8IRMs1bFE4NVErZkTcNC8zlJVBY5jSzjXGs/gTwdypq2uo0
         2vU62EfFMRZkawy++K1enrCDDucVPPkqfHpl91tjwsARcidmVpR6+dvTIdiF/kMiXbkA
         D/iw==
X-Gm-Message-State: AOAM531ed02gEMBklbRoCyO0idX2t6GBQF3jZl5AIltprI7Tq3RgWk89
        QKpSp1U7v/w4bKxKgEO2Pdheit8674c=
X-Google-Smtp-Source: ABdhPJwBxh6wAJUo7EJ1iX/rM3pRO3x2cuqXm2dhTE472NyUaYPXdPDO1eqG5x7EkS5cmMzXCfMlEw==
X-Received: by 2002:a65:55c1:: with SMTP id k1mr2713889pgs.84.1638331252022;
        Tue, 30 Nov 2021 20:00:52 -0800 (PST)
Received: from [192.168.86.22] (c-73-241-150-58.hsd1.ca.comcast.net. [73.241.150.58])
        by smtp.gmail.com with ESMTPSA id n3sm3027298pgc.76.2021.11.30.20.00.51
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 30 Nov 2021 20:00:51 -0800 (PST)
Subject: Re: [PATCH net-next] tcp: remove the TCPSmallQueueFailure counter
To:     Jakub Kicinski <kuba@kernel.org>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, imagedong@tencent.com
References: <20211201015144.112701-1-kuba@kernel.org>
From:   Eric Dumazet <eric.dumazet@gmail.com>
Message-ID: <31ca5dff-f69d-fc2a-64fe-145561fd18f6@gmail.com>
Date:   Tue, 30 Nov 2021 20:00:50 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.14.0
MIME-Version: 1.0
In-Reply-To: <20211201015144.112701-1-kuba@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 11/30/21 5:51 PM, Jakub Kicinski wrote:
> This reverts commit aeeecb889165 ("net: snmp: add statistics for
> tcp small queue check").
>
> The recently added TSQ-limit-hit metric does not provide clear,
> actionable signal and can be confusing to the user as it may
> well increment under normal operation (yet it has Failure in
> its name). Menglong mentioned that the condition he was
> targetting arised due to a bug in the virtio driver.
>
> Link: https://lore.kernel.org/r/20211128060102.6504-1-imagedong@tencent.com/
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>


Oops, I have seen this a bit late.


Maybe because my primary email address is edumazet@google.com, and that 
my @gmail.com

accounts have some lag.


Reviewed-by: Eric Dumazet <edumazet@google.com>


Thanks.


> ---
>   include/uapi/linux/snmp.h | 1 -
>   net/ipv4/proc.c           | 1 -
>   net/ipv4/tcp_output.c     | 5 +----
>   3 files changed, 1 insertion(+), 6 deletions(-)
>
> diff --git a/include/uapi/linux/snmp.h b/include/uapi/linux/snmp.h
> index e32ec6932e82..904909d020e2 100644
> --- a/include/uapi/linux/snmp.h
> +++ b/include/uapi/linux/snmp.h
> @@ -292,7 +292,6 @@ enum
>   	LINUX_MIB_TCPDSACKIGNOREDDUBIOUS,	/* TCPDSACKIgnoredDubious */
>   	LINUX_MIB_TCPMIGRATEREQSUCCESS,		/* TCPMigrateReqSuccess */
>   	LINUX_MIB_TCPMIGRATEREQFAILURE,		/* TCPMigrateReqFailure */
> -	LINUX_MIB_TCPSMALLQUEUEFAILURE,		/* TCPSmallQueueFailure */
>   	__LINUX_MIB_MAX
>   };
>   
> diff --git a/net/ipv4/proc.c b/net/ipv4/proc.c
> index 43b7a77cd6b4..f30273afb539 100644
> --- a/net/ipv4/proc.c
> +++ b/net/ipv4/proc.c
> @@ -297,7 +297,6 @@ static const struct snmp_mib snmp4_net_list[] = {
>   	SNMP_MIB_ITEM("TCPDSACKIgnoredDubious", LINUX_MIB_TCPDSACKIGNOREDDUBIOUS),
>   	SNMP_MIB_ITEM("TCPMigrateReqSuccess", LINUX_MIB_TCPMIGRATEREQSUCCESS),
>   	SNMP_MIB_ITEM("TCPMigrateReqFailure", LINUX_MIB_TCPMIGRATEREQFAILURE),
> -	SNMP_MIB_ITEM("TCPSmallQueueFailure", LINUX_MIB_TCPSMALLQUEUEFAILURE),
>   	SNMP_MIB_SENTINEL
>   };
>   
> diff --git a/net/ipv4/tcp_output.c b/net/ipv4/tcp_output.c
> index c4ab6c8f0c77..5079832af5c1 100644
> --- a/net/ipv4/tcp_output.c
> +++ b/net/ipv4/tcp_output.c
> @@ -2524,11 +2524,8 @@ static bool tcp_small_queue_check(struct sock *sk, const struct sk_buff *skb,
>   		 * test again the condition.
>   		 */
>   		smp_mb__after_atomic();
> -		if (refcount_read(&sk->sk_wmem_alloc) > limit) {
> -			NET_INC_STATS(sock_net(sk),
> -				      LINUX_MIB_TCPSMALLQUEUEFAILURE);
> +		if (refcount_read(&sk->sk_wmem_alloc) > limit)
>   			return true;
> -		}
>   	}
>   	return false;
>   }
