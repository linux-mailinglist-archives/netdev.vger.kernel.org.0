Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8559B484723
	for <lists+netdev@lfdr.de>; Tue,  4 Jan 2022 18:42:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235879AbiADRmM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 4 Jan 2022 12:42:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43110 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234403AbiADRmM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 4 Jan 2022 12:42:12 -0500
Received: from mail-wm1-x331.google.com (mail-wm1-x331.google.com [IPv6:2a00:1450:4864:20::331])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA995C061761;
        Tue,  4 Jan 2022 09:42:11 -0800 (PST)
Received: by mail-wm1-x331.google.com with SMTP id f134-20020a1c1f8c000000b00345c05bc12dso1847888wmf.3;
        Tue, 04 Jan 2022 09:42:11 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=7YnihPBgtVAxUbFRzoc/RmwxofXsfmor0Pi1YgJwWgU=;
        b=lTVky4crBY1Oof0c+EBDJOkiYXvEzqNvVgiA5anoQP9We0rrK+Hx+75xE8mpo01pqg
         apAxJJflBC1p+Tpafv6/Ym9EwRwTwFXL1j9wE7qoHatwWfiBSx7VgMQMTNSJPAza2uQP
         sFGWjcC4nbu12cmHDfNwYE6GLytCNpy8nt+CHM+1yIB/O8Su2fSQOPrMwEUzboYK9Gpo
         rhvcFXbcMcD+dwIJGJdcN7V1J/IhjYzryp/7Pe87BkIS7FEtstBtMaWGk2N/wINGPw6S
         4coldltzqLXLodrlBWWJqpoeRf9tt8ogYgy1KSV3EAPe2chCUN5mgpBMRlI7C4Z8C1XD
         JNnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=7YnihPBgtVAxUbFRzoc/RmwxofXsfmor0Pi1YgJwWgU=;
        b=RBkCfeAWFUFLEiQsJOszALQk+NuA9qT8Lai19MiAiDcfn8WpLOCwt33qRtQUeKO8K4
         2NKJwOEho4keEekH+G56lUfjRB/WSrK2pFA0T3Q2wIXTd++6K7iJAfskyh/RZ3v6kW1d
         U8qQVApQjeL/S+0kYkSy1rQP9Lne0iYwrDDjpPfNMlZKLV1TEkaQ174uk2AfH4I/piqq
         I8lMQAM46i8EkZi8suCSW2jJcfMsHP59kaUGz8GZqTFiIkShD5usCLWV4WYyeSBZzgle
         uBBX8Jc+CG9qJNhm34k7XrJ4dW7o019V6HxiyC9O7S8bvPdQMLWlSI0a+u6IgcxInnsQ
         YKLg==
X-Gm-Message-State: AOAM532ZB/c29AHRsdpQLIOyBYtNXegEthQ9oOoH0wYF06O/J17Ck5qO
        F+SizMMB1jq2sbBf5lM71P0=
X-Google-Smtp-Source: ABdhPJzD9GtqaQey1+cYN6EOaC5u8lArftuaJ96fiW3xLtAfAvHCGrLirjl6LW5Pk7woK2zFoCXfBw==
X-Received: by 2002:a05:600c:c6:: with SMTP id u6mr42442324wmm.8.1641318130504;
        Tue, 04 Jan 2022 09:42:10 -0800 (PST)
Received: from [10.0.0.4] ([37.165.184.46])
        by smtp.gmail.com with ESMTPSA id i8sm64866wmq.4.2022.01.04.09.42.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 04 Jan 2022 09:42:10 -0800 (PST)
Message-ID: <0db849a8-2708-6412-301d-fe77b2cf8d00@gmail.com>
Date:   Tue, 4 Jan 2022 09:42:08 -0800
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.3.2
Subject: Re: [PATCH net-next 3/3] net: lantiq_xrx200: convert to build_skb
Content-Language: en-US
To:     Aleksander Jan Bajkowski <olek2@wp.pl>, tsbogend@alpha.franken.de,
        hauke@hauke-m.de, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-mips@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20220104151144.181736-1-olek2@wp.pl>
 <20220104151144.181736-4-olek2@wp.pl>
From:   Eric Dumazet <eric.dumazet@gmail.com>
In-Reply-To: <20220104151144.181736-4-olek2@wp.pl>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/4/22 07:11, Aleksander Jan Bajkowski wrote:
> We can increase the efficiency of rx path by using buffers to receive
> packets then build SKBs around them just before passing into the network
> stack. In contrast, preallocating SKBs too early reduces CPU cache
> efficiency.
>
> NAT Performance results on BT Home Hub 5A (kernel 5.10.89, mtu 1500):
>
> 	Down		Up
> Before	577 Mbps	648 Mbps
> After	624 Mbps	695 Mbps
>
> Signed-off-by: Aleksander Jan Bajkowski <olek2@wp.pl>
> ---


Not sure why GRO is not yet implemented in this driver...


