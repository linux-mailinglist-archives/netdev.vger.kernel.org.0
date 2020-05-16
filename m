Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 817C21D5DEE
	for <lists+netdev@lfdr.de>; Sat, 16 May 2020 04:35:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727890AbgEPCfl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 May 2020 22:35:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36372 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-FAIL-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726247AbgEPCfl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 May 2020 22:35:41 -0400
Received: from mail-ed1-x543.google.com (mail-ed1-x543.google.com [IPv6:2a00:1450:4864:20::543])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B0A91C061A0C
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 19:35:39 -0700 (PDT)
Received: by mail-ed1-x543.google.com with SMTP id l3so3766014edq.13
        for <netdev@vger.kernel.org>; Fri, 15 May 2020 19:35:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=9EfQsTCgf37S0Hk9lOsUlLTGTyRvjjim26A8igZXUyA=;
        b=BtjYsquojgI2LZuYe+qSvR3DTqCXFrYBz7pMHXHeF7kCtXPwf26tPA90RUDID03zvN
         cX+8XDGYfsojUkaHEf/+wyEyPKudEBQ5I/Mr+nnpKXK/tx7LKTH1zkPeadGfDqs23zhR
         1lDIj2Q7Qlc6CQ92l1XW2TW4WPGHqQ4yegwpqml6cS3YDT04g+p7HH2AZl/JI0lEwYqs
         +LDn3NsNn2lUGCkVdlT2C6qTyBf4jF9mAIYUUVS1pdWwOeukmy2rNJWLOuBsOHqNoyDM
         PHjoWK2qCCW/diTmRQjFxKGwFe2YVrV5wCyu5o82i7YfolI3//YN14LB4cuGjWmJ3N5W
         dG5g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=9EfQsTCgf37S0Hk9lOsUlLTGTyRvjjim26A8igZXUyA=;
        b=hwMwR27o9wM4lpOX1YMYA+xe7fx+6AiRO9r2Hugs/YVfWmxgNwfYvAeAz0b58Q3RRc
         TIQ413QJ2kgmNsqTD3n2fifPiH3qBMc6r1zFMDFZtGFmnoncCXhQEU1DPjxHe1zQ+z3Q
         OVIcThYCVgfXHfuj+sFV8Vcii9JpiJSLbKqkKQjBuabM2sF46yYdxd0pEEwVKIh+KZEP
         BKYHo+gzlJ+ZuBCrHsyIbPayKfW25E1J977grYmyNCuXfzn2W1aR6ozT8JRQhQ3qu8yL
         6e2KV1lAEbcybrN4wFyvTq3NupycbsIqszcpLCbs9T61G9BIfNCb7fNezeA+7kCasLVD
         q69Q==
X-Gm-Message-State: AOAM530x5DnPuWhkyah4FgK2rYbkgYJJh77NIgcpUZqBw6+r/S8g72AO
        VMAtAxyv1zEspKxLlYs3dmZyX5Ud
X-Google-Smtp-Source: ABdhPJy023y5SjSVrXRP9hL4xOaj1960W2lNpg/H6ow+OCx54LHfdSxfNBU9CE3aH2g9YCkYp4uR9A==
X-Received: by 2002:a50:9b19:: with SMTP id o25mr5846027edi.141.1589596538380;
        Fri, 15 May 2020 19:35:38 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id bi7sm116999edb.17.2020.05.15.19.35.36
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Fri, 15 May 2020 19:35:37 -0700 (PDT)
Subject: Re: [PATCH net-next] net: phy: broadcom: fix checkpatch complains
 about tabs
To:     Kevin Lo <kevlo@kevlo.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        "David S. Miller" <davem@davemloft.net>
References: <20200516020926.GA6046@ns.kevlo.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <fb575bea-437d-1a59-1d6e-60d48da8faa6@gmail.com>
Date:   Fri, 15 May 2020 19:35:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.0
MIME-Version: 1.0
In-Reply-To: <20200516020926.GA6046@ns.kevlo.org>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/15/2020 7:09 PM, Kevin Lo wrote:
> This patch makes checkpatch happy for tabs
> 
> Signed-off-by: Kevin Lo <kevlo@kevlo.org>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
