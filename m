Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A5A752C4CA5
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 02:32:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732043AbgKZBbe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 20:31:34 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58678 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730646AbgKZBbd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Nov 2020 20:31:33 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8D48EC0613D4;
        Wed, 25 Nov 2020 17:31:33 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id w4so289299pgg.13;
        Wed, 25 Nov 2020 17:31:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=gXEUjto7ex9qFqOtVVBA8NQbxibuAQ5L5MilC/zSyqs=;
        b=Yw0sCt7G88eJCd2O+zoj3bcPWeEMo+KpMuMBsWlD/YDUSs5Avh0uCYrmt831qbev8i
         OfPGD4zfEdiqM9i4+cnIwwgGCSHv3fliSRzOVRRcHfOf8Zf/zpeiVWRH2u/WoUifj6OC
         hPLJgA85yq237DXdDpGzh4rgoQnKySrqtpbgXEObPsIV7aS2r3xvtbVyM++LlHmLfERf
         bwd2zyRVql/X+8bird3PyNyAe6jQy66LO1FSrm48W9MwcTleDwU7AwovGUy4R+GCnPXF
         USeXLRzY0YtItYihM+7bYoX+RBMshtmcEgUXTo/RmfLQ7iaEOaFLbs+4iUv0cbqGIWch
         OskA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=gXEUjto7ex9qFqOtVVBA8NQbxibuAQ5L5MilC/zSyqs=;
        b=unS97ynmy44vpmrVULChE4xO1YV/eX5Fg5FcLlH3wRBH+BD6QiaBpI95BPgGZlGbPZ
         aAiVcJGzJlHrf2ryBGyvDP24ANSMHAYg/WM6Ph3g/16Fhrh2FfzNXE1zk6+6End8Fbf9
         pEmrkbV9VtmKT0C3BjWZnSRE00U8bU2Wv4TpTcTTA6An/IXQTywv5Mc4j+D/9scI7etq
         8WnTzbCDqzpRLUaFsks1eWF/Dzjd5q3ppcUOe7cmTNEa5XJxxtgmXFdhE1UrIzfblSPz
         2kYUFWQNeSds0araMjcGV6z+oADHwO5ioYxg6ZM17XU55qucQfY06wl4Lqt7zYSp4mq/
         X6kw==
X-Gm-Message-State: AOAM531nhePWx3n105nVEBfqt8lPkagmJQnvPnUOJk8NBunHG7MLX9n0
        Q5R2u+WU20dWb6gEUHvz4JT6KNK+oiw=
X-Google-Smtp-Source: ABdhPJwKtQ3Qe8uJg2JjQW9Tk1SejoeULNVa8ptlWFCWJK5r74wtMsBVOVs6xxelYWr4tBctwzChWA==
X-Received: by 2002:a65:5b04:: with SMTP id y4mr577293pgq.448.1606354292767;
        Wed, 25 Nov 2020 17:31:32 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 145sm2951531pga.11.2020.11.25.17.31.31
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 25 Nov 2020 17:31:32 -0800 (PST)
Subject: Re: [PATCH net-next v2 1/3] dsa: add support for Arrow XRS700x tag
 trailer
To:     George McCollister <george.mccollister@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
References: <20201125193740.36825-1-george.mccollister@gmail.com>
 <20201125193740.36825-2-george.mccollister@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <4aa33847-539d-df85-2e17-e7c8e62aed49@gmail.com>
Date:   Wed, 25 Nov 2020 17:31:30 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201125193740.36825-2-george.mccollister@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/25/2020 11:37 AM, George McCollister wrote:
> Add support for Arrow SpeedChips XRS700x single byte tag trailer. This
> is modeled on tag_trailer.c which works in a similar way.
> 
> Signed-off-by: George McCollister <george.mccollister@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
