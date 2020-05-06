Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AB4C31C6D82
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 11:47:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729142AbgEFJrk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 05:47:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34200 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729040AbgEFJrk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 6 May 2020 05:47:40 -0400
Received: from mail-lf1-x141.google.com (mail-lf1-x141.google.com [IPv6:2a00:1450:4864:20::141])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E6410C061A0F
        for <netdev@vger.kernel.org>; Wed,  6 May 2020 02:47:38 -0700 (PDT)
Received: by mail-lf1-x141.google.com with SMTP id d25so774548lfi.11
        for <netdev@vger.kernel.org>; Wed, 06 May 2020 02:47:38 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=/9ah7zhuR4873GSpvZCqmYYEsJCcLFVCYyRiQ4J6Vdk=;
        b=GmeI+UP24kyAPTiBFvucgZ/V4AdmN9uFhZQV85PUDH3V01byOj0XccFF6diF/xZd4E
         +cSoNUycgb8W8kPHInzeAOkcj+nqZPlNvaGrwlGWqFZpY2eMaUa27ZP5I9tqihtthDnx
         6QQKERCXj5PH5svOqIuTE12LsGdy5dfxSTCXg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=/9ah7zhuR4873GSpvZCqmYYEsJCcLFVCYyRiQ4J6Vdk=;
        b=SPfz0zSZ6WCB/gjVeZBI7j8lhEOMztWm9ZYLEe8tTSfJ2FHF6kR5a6SeXhpGE43J/T
         598h7FiRYIymc7o70N3JIMT9TWFOxJHg5rRN6+JYCXtTRJ4Md0TxsDNsAfOizAYkWAsR
         UEWsSwKQVW1TbdPNt0sYmGvkRDSB9iDqeVQ7WU8Zoxe3th2pklg20pprmMwr3D4b8/kf
         WKvSzoD/D0jou4WYPQEpUw9Uk4UTVQRIHsb1cjWpvZJHxFZSXMdkHPCLz3QuWjHUDTLM
         dJSuTwwLtbFLbupOj5l4MtdvnME4hZBJ3EnEW0m/rd8TZuso1g4KK3x0wgf98DqCFB9c
         Faug==
X-Gm-Message-State: AGi0PubGkPfcEivf+df8jEvPbprBbCmp1bkEER4Kifmtb1Mjj4Ho/xTm
        UunGkOBcr5WwH2qFd7euOdYNNA==
X-Google-Smtp-Source: APiQypLnD2AvkD2qPRRmjXwr/1RNm41CbdM9Hbn0xbk9jZ1SR3g4pCmCYNoosoZyqZS6x+UMJMpQzA==
X-Received: by 2002:a05:6512:455:: with SMTP id y21mr4691981lfk.202.1588758457377;
        Wed, 06 May 2020 02:47:37 -0700 (PDT)
Received: from [192.168.0.109] (84-238-136-197.ip.btc-net.bg. [84.238.136.197])
        by smtp.gmail.com with ESMTPSA id 23sm954196lju.106.2020.05.06.02.47.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 06 May 2020 02:47:36 -0700 (PDT)
Subject: Re: [PATCH net-next] net: bridge: return false in br_mrp_enabled()
To:     Jason Yan <yanaijie@huawei.com>, roopa@cumulusnetworks.com,
        davem@davemloft.net, kuba@kernel.org,
        bridge@lists.linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20200506061616.18929-1-yanaijie@huawei.com>
From:   Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Message-ID: <80b3d01a-1bd5-f5c5-abaa-6f3114683617@cumulusnetworks.com>
Date:   Wed, 6 May 2020 12:47:35 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <20200506061616.18929-1-yanaijie@huawei.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 06/05/2020 09:16, Jason Yan wrote:
> Fix the following coccicheck warning:
> 
> net/bridge/br_private.h:1334:8-9: WARNING: return of 0/1 in function
> 'br_mrp_enabled' with return type bool
> 
> Signed-off-by: Jason Yan <yanaijie@huawei.com>
> ---
>  net/bridge/br_private.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/bridge/br_private.h b/net/bridge/br_private.h
> index c35647cb138a..78d3a951180d 100644
> --- a/net/bridge/br_private.h
> +++ b/net/bridge/br_private.h
> @@ -1331,7 +1331,7 @@ static inline int br_mrp_process(struct net_bridge_port *p, struct sk_buff *skb)
>  
>  static inline bool br_mrp_enabled(struct net_bridge *br)
>  {
> -	return 0;
> +	return false;
>  }
>  
>  static inline void br_mrp_port_del(struct net_bridge *br,
> 
Fixes: 6536993371fab ("bridge: mrp: Integrate MRP into the bridge")
Acked-by: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>

