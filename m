Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9ECCC2B8A5A
	for <lists+netdev@lfdr.de>; Thu, 19 Nov 2020 04:14:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726238AbgKSDKq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 22:10:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44032 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726172AbgKSDKq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 22:10:46 -0500
Received: from mail-pg1-x542.google.com (mail-pg1-x542.google.com [IPv6:2607:f8b0:4864:20::542])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 41DB9C0613D4
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:10:46 -0800 (PST)
Received: by mail-pg1-x542.google.com with SMTP id i13so2908634pgm.9
        for <netdev@vger.kernel.org>; Wed, 18 Nov 2020 19:10:46 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=AFlDJBY0mtDgvvkpGp7HvOkqTHGWD4u6xIviX8IiU9I=;
        b=jcljGX6unSWahwU/wAYCM+tM5wTCKBaiRP3I+NKdLOatHK4GzZEpDSc3p5xK2r2m8l
         x3Sb1KV/CHE3K//3TnvKdukYkJR2h3R9HzIAuNZaqw7rbdmlSmV8yO/HgHlRoEnoSslm
         AFlAqG8JHdeukCtoQHGxroOM6DlMPjkXIszg8KeOYSPfoNVA/oZ8MxvX2SP9doOH9RAY
         CUsjTJcu+OLFifScVQYsM2MNYgpq+cBmUGqEtTiSWrqiMiiGpl0NUEB0GRPSXtvPzo81
         7JVqPjfNS87G5MUnXmA9PQMsJJvO3WvbGlmh9OHTkFdWv4ai0E1+uhfcI9L+PPzdW3R2
         UaRA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=AFlDJBY0mtDgvvkpGp7HvOkqTHGWD4u6xIviX8IiU9I=;
        b=FKYWxGvY9KlVbGgAKHzPVDOJiBWCUPYPvqkrjZutJn2MHGuI/L482OHYFdnFk8rytC
         oQ4Ktd9PMN6BszKuwqv2BC7dAXK8KNd1VvyC9xkXN6EnIZ3wsKGXg3+ZnLGdHx8VCWJC
         1Q7lc+NK8mDbcsOh8A0wIpgB+cTsuCtmZd3zkCvS/rIwY1YUnR3JSR3hS2zRODi92xMx
         SHWSiQ58zW2FNSZwJi7BiSpdjtmgrARKHSmpscqf0agqkoicl+imUMSiuemmGnl6X0I0
         9TMHy15f+Sf3mek83as26VgnWr+iCLQV8Iosj+RKQkHoI5qhG96Uuo2Q3Z39D2HSPM7R
         ge4g==
X-Gm-Message-State: AOAM530L9MB/BqLtLJRP4i2iek8S4n24fUquVfgPPzFVpm2tPhAnqhvv
        VRnPmLihsTLeP4sGoaajEMY=
X-Google-Smtp-Source: ABdhPJw0ECFYye5/dzyxRfNrL4wk7Eo7UdTZBM6gfL02SWFNhKMLD70I3BUiEscx8AxI2yXute4xkQ==
X-Received: by 2002:a17:90a:b782:: with SMTP id m2mr2169772pjr.185.1605755445750;
        Wed, 18 Nov 2020 19:10:45 -0800 (PST)
Received: from [10.230.28.242] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id 64sm16737569pfe.0.2020.11.18.19.10.44
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 18 Nov 2020 19:10:45 -0800 (PST)
Subject: Re: [PATCH 07/11] net: dsa: microchip: remove superfluous num_ports
 asignment
To:     Michael Grzeschik <m.grzeschik@pengutronix.de>,
        netdev@vger.kernel.org
Cc:     andrew@lunn.ch, davem@davemloft.net, kernel@pengutronix.de,
        matthias.schiffer@ew.tq-group.com, woojung.huh@microchip.com,
        UNGLinuxDriver@microchip.com
References: <20201118220357.22292-1-m.grzeschik@pengutronix.de>
 <20201118220357.22292-8-m.grzeschik@pengutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <217a9166-4ae0-038f-05b6-fdfc762cf868@gmail.com>
Date:   Wed, 18 Nov 2020 19:10:43 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.4.3
MIME-Version: 1.0
In-Reply-To: <20201118220357.22292-8-m.grzeschik@pengutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/18/2020 2:03 PM, Michael Grzeschik wrote:
> The variable num_ports is already assigned in the init function.
> This patch removes the extra assignment of the variable.
> 
> Signed-off-by: Michael Grzeschik <m.grzeschik@pengutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
