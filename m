Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7DB573BD97E
	for <lists+netdev@lfdr.de>; Tue,  6 Jul 2021 17:07:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232465AbhGFPKR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 6 Jul 2021 11:10:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40370 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232490AbhGFPKP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 6 Jul 2021 11:10:15 -0400
Received: from mail-oi1-x230.google.com (mail-oi1-x230.google.com [IPv6:2607:f8b0:4864:20::230])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D4C4C06178A;
        Tue,  6 Jul 2021 08:07:36 -0700 (PDT)
Received: by mail-oi1-x230.google.com with SMTP id q23so24817361oiw.11;
        Tue, 06 Jul 2021 08:07:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=vsVIuO58gOtXBkn6kFoxxUXBMaX3JR62ZTMYsewLQZs=;
        b=KNXgU2Tgn3EYwdul7Zmx6gmL9vpiL7QLdYnJ1UhdfsxP4JgK4yOoJ/ovVOux2T+dJp
         AOSKqdZrrRkIJU3x4ClnF5H9zN+MLRS8lu06Smz80eDOYxYi35ieFlhHAc08JdJKk3Ps
         TeOCWgXi4wDlNLCa7I9cJeBZ17e/pOw6RDu1ePKVLWXjBcgXjzEs9x2f0hi1qqc6i3bY
         +F2Y7sShpGvuIQzm1o8L/LQSwePhg3J8mUq4ZKpIps5vu300oRn9TdYXv7bUMpEc0jaF
         56t3HFsUHKypv7eCB7PkjcqlCOSTM14fGHPGAlZlz6AwR8piDaVMz2pn7AiNWxXDGW/g
         s+Dg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=vsVIuO58gOtXBkn6kFoxxUXBMaX3JR62ZTMYsewLQZs=;
        b=dli36OiFLSuvmSO0kZPquw48o6r39cT2x6Wie7jFuVgVJR/kCLR2GZ5y1oanwzePVU
         ZvTUmH4MiZRmDi4b0meTZNEG3kJrt3F1aQWKMRXDjfqh/prV3gk4QAWsWB5Pc77S307M
         mGHkeZG15LgFV0B2YXhKF907W7KFBX9641kp3GiYjuMIAcymnJpwgbZTLNMw2XzS6Ntk
         qWTSgPmZufy9EcNU82GLyH0qasIvs/ngFY/JvmjIbBz8z4I85Kg3H2UX6xZ6y7bQcIxe
         qpPZfEMrYIisd/2JNIM7di73Ig7vUr7nlr6b5KDs3Og6QPLcli+ouRUkqW5n2pAdUiXp
         GcdA==
X-Gm-Message-State: AOAM533BPZ+Vvd2fMq0M6qXERRCMpnOwTHIKAuzhsPnxPLHulvsLpvyM
        y6FfJV4hOJwGPpcgtmSyhFAGS6Hv8Mc=
X-Google-Smtp-Source: ABdhPJy/sxlvBY2WuNyZui3GBVgLgtxdvlePvL+9vO2D7EhRgQIdX4X9jeqt2ayN1gWkqxvxhya8Aw==
X-Received: by 2002:aca:ad86:: with SMTP id w128mr14453402oie.77.1625584055278;
        Tue, 06 Jul 2021 08:07:35 -0700 (PDT)
Received: from ?IPv6:2600:1700:dfe0:49f0:3964:fbb4:5a94:e345? ([2600:1700:dfe0:49f0:3964:fbb4:5a94:e345])
        by smtp.gmail.com with ESMTPSA id z5sm416062oib.14.2021.07.06.08.07.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 06 Jul 2021 08:07:34 -0700 (PDT)
Subject: Re: [PATCH AUTOSEL 5.13 159/189] net: dsa: b53: Create default VLAN
 entry explicitly
To:     Sasha Levin <sashal@kernel.org>, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
References: <20210706111409.2058071-1-sashal@kernel.org>
 <20210706111409.2058071-159-sashal@kernel.org>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <57a4d4ba-be97-3e25-0d7b-e698cb7511cf@gmail.com>
Date:   Tue, 6 Jul 2021 08:07:34 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.11.0
MIME-Version: 1.0
In-Reply-To: <20210706111409.2058071-159-sashal@kernel.org>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 7/6/2021 4:13 AM, Sasha Levin wrote:
> From: Florian Fainelli <f.fainelli@gmail.com>
> 
> [ Upstream commit 64a81b24487f0d2fba0f033029eec2abc7d82cee ]
> 
> In case CONFIG_VLAN_8021Q is not set, there will be no call down to the
> b53 driver to ensure that the default PVID VLAN entry will be configured
> with the appropriate untagged attribute towards the CPU port. We were
> implicitly relying on dsa_slave_vlan_rx_add_vid() to do that for us,
> instead make it explicit.
> 
> Reported-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> Reviewed-by: Vladimir Oltean <olteanv@gmail.com>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Please discard back porting this patch from 5.13, 5.12 and 5.10 it is 
part of a larger series and does not fix known uses until 5.14.
-- 
Florian
