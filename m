Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 335322B8A4F
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:08:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbgKSDHK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:07:10 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43450 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725964AbgKSDHJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:07:09 -0500
Received: from mail-pf1-x441.google.com (mail-pf1-x441.google.com [IPv6:2607:f8b0:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A31BCC0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:07:09 -0800 (PST)
Received: by mail-pf1-x441.google.com with SMTP id 131so3052587pfb.9
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:07:09 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=siNX71xH20+Qh+CRoNhlT36kkkjm24Uj71yvnTLrBf8=;
        b=lv3IOfPAjlsrA8EEBrIPwTLgdk31g4m+yiC7iAEEdcrtijScjAw6FMk2Uo5/32+OcF
         O27e+hX5jRReKEXq4fojslUTL/qNfvXwLFma4HCKhUfglA7+e7T0HSO24oesQLJDJieu
         tieQAeSVv3LbyUwNeu1JF61KVZ3ujrLS5J+m2O714mJGv0FrQqZ8lD12kJdc+7XEzCYC
         b5yjpRNzI8tUNDimdxDOkCHLj75bHf0c/EeKFsP7vuKmf4wppWOKn7eHIZkSUstXgYOm
         XAT7VJI9Dn0jIZaazTtSzB5fk/MQL9zbyeCpdgwluw88XixBnAvzX2+hAZcdzQSMsK7t
         P8JQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=siNX71xH20+Qh+CRoNhlT36kkkjm24Uj71yvnTLrBf8=;
        b=EclKLx80Zb4NAwPbh6mx9IR/98ByGmcJcr8uKqJMOuJO4pBj9FAnV0AGD3KNaZZfRb
         0FjGKMMw8fneHZxM+C7whD90aDrLQf4fqvcIxr1den8Th+GIdFztE8ufiea8s5o51/ZD
         UiSQcTeXcixMxJN1ry9ubeVfiALzvZbi9ZYj65b9sYQC5//ZgyKJh4bUhep5cjyaoU3P
         rNFsh67q34CEFpA4iKyM60Er+TKJ042WYy0gw+M9qP4qRSsI3r4RfPAiVpt0Spu+pclo
         YNPsKOXaxiQ2Ith5oTU2zD/da9WfxkdnZhejW/m6KtKXvn8xSc9n8ov/cOvaEDvKvTTa
         D1Jg==
X-Gm-Message-State: AOAM531DnJtEO/gJpbpt8ChcZRmIIZ61FWPX7ZQQZYbdHHP5vInE3rFh
        012WEzWYHgj05AhY2YwTuQw=
X-Google-Smtp-Source: ABdhPJyVlkWR34GdqA8weTHiIcxj0imA4B0VjliH05pncdXjhAevbNywNfCkBWZMnaLBKFUH9Qv51w==
X-Received: by 2002:a17:90a:fa93:: with SMTP id cu19mr2219493pjb.117.1605755229160;
        Wed, 18 Nov 2020 19:07:09 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id p18sm3472403pju.17.2020.11.18.19.07.07
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:07:08 -0800 (PST)
Subject: Re: [PATCH 02/11] net: dsa: microchip: ksz8795: remove superfluous
 port_cnt assignment
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-3-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <ffad3f4d-a845-eb47-fbd3-cf33e6912901@gmail.com>
Date:   Wed, 18 Nov 2020 19:07:06 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-3-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The port_cnt assignment will be done again in the init function.
> This patch removes the previous assignment in the detect function.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
