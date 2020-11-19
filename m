Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A31572B8A50
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726224AbgKSDH2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:07:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43506 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgKSDH2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:07:28 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 029D8C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:07:28 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id c66so3069706pfa.4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:07:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=68ho5thaGyJKnKm903ZjjtOOTkAGnPq4vobVihQTMb8=;
        b=tdQPQ77JCiqGDOcrHinbM6ve1QZvNzMZ0XpDvOvs4VD25FHFgp7X8WaE6e+tQwF5+c
         RPCsXT9qZTpgsKJ4qWAY5V5++gGlvp6SYQM+WTRu6jbSy2L+5QHpV/9qtlueNguxQERS
         NgfsrOZ7K2g+87lCyRxcr/6eFiQxSAH0qDKO6KI+9egEJh5uuSoH4Ix3rmMjoE1cFdTH
         ROumwc9Fl9PJCu5wlNUIqebmOqjcWLCH6rBdHZMtVke3TCs5ngCwtCdSUxWwLqUM9Apj
         SKjYEkhKxGRvzcqKTeLNi/1wNveC0hB/P8mk8jxDo0q7NKayIomoEeLnASc+LpMmv4Fz
         RE/A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=68ho5thaGyJKnKm903ZjjtOOTkAGnPq4vobVihQTMb8=;
        b=KB4br0s9dcxQMN4tZLqDL1H9FzDjWv2UMpepsumxdHQTCVvx2OaEkvTXwKiqwiHxQL
         n6qB6h79dtJQbn1bfWq/5ZsBBf2x+QlcgYobO1o4mpa0j8TDRlRDi1HnlI172mClHewA
         zmIvP5Uso6vQlRgyOqbWbb3z5fJ/Nzg9qkm9HVIOld0TzRVXfkhcasVSKleiapmD+Ff8
         l1qYs+9KGR1retqeogiIf/1gbfWMKeH9U9ILzEc280uuUBTynSbs5epAS09uaplmUq0p
         An6Qm9AAHQmb92y24oJHYjB26FOh02DdiCNWFmPrTHD1aqj2vCVhuTsIV55hpLDp01C3
         ix/g==
X-Gm-Message-State: AOAM533eV43adsDyvM3Q/ZxCgqmDc+sFaDNziaUVcefa/wFsorbwd2EW
        mUEcng/WvBUIjzHNzd+294U=
X-Google-Smtp-Source: ABdhPJzhqM79L5RQnLqQ6E2EiI1skpLHfiez4TTm3VElLHmo6E9VJf7VhmeRq3+9JIVyHnxib2hMIg==
X-Received: by 2002:a05:6a00:c:b029:18b:eae3:bff0 with SMTP id h12-20020a056a00000cb029018beae3bff0mr7228302pfk.9.1605755247560;
        Wed, 18 Nov 2020 19:07:27 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id a23sm24466436pgv.35.2020.11.18.19.07.24
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:07:26 -0800 (PST)
Subject: Re: [PATCH 03/11] net: dsa: microchip: ksz8795: move variable
 assignments from detect to init
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-4-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <181f569d-ac5c-68ea-bd7d-ba60b6727bf6@gmail.com>
Date:   Wed, 18 Nov 2020 19:07:24 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-4-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> This patch moves all variable assignments to the init function. It
> leaves the detect function for its single purpose to detect which chip
> version is found.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
