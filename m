Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B2F41E93AE
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 22:46:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729319AbgE3Uqp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 16:46:45 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40848 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728741AbgE3Uqo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 16:46:44 -0400
Received: from mail-wm1-x341.google.com (mail-wm1-x341.google.com [IPv6:2a00:1450:4864:20::341])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76DD7C03E969
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:46:44 -0700 (PDT)
Received: by mail-wm1-x341.google.com with SMTP id r9so7092363wmh.2
        for <netdev@vger.kernel.org>; Sat, 30 May 2020 13:46:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=VdKZDJARZbb5cIOU+bnTAil2lB5NYJYQmGuGYjV9PyM=;
        b=ITCveow35wmSVqLmm3s1fl5JpUy+SsDXBEk09erJVLWMiD938PV1Iaa3wDrCCJFYS2
         TZQA0/Gk8NFfuTq8uMUnl9TxLL1V9E9A/o3JWtXSZmAhh6pO9t/xk58zag49qf/1AU06
         HpbKkPBlUPg4WrFcttfqBq/lfpd4Gl/sstAuvg1JelcZn06vZSDIO2Pt7uCcHZiGv0YS
         MKtm9AjDNLluflcBkjl9EcWXPCQ8MuAAJp57tcIDWsaoI/4K7vpDldvcDl/SWKNdQSLi
         0cBSuO98//ezkhGg19CHGvLYQqL8EwXUkJzIWFKm+nAjQD/94zQ26W6G1GqFP3uYYGUo
         Wpbg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=VdKZDJARZbb5cIOU+bnTAil2lB5NYJYQmGuGYjV9PyM=;
        b=GGQULav1M2lb3H5NK+jRYBpaztXBKU1N6x19XGNwDnNrodzOacCGgYPNsP60HQLT4d
         MmAL6ENxHCl2J7pteSsBIecsIsqM6Ou0fa3XklXk3pPXbHFKAlmRZ0UQ6vo1uhORAr3A
         NfCgp72N5Yt8vMgoWjXUETBeoc792sjrEy/EMpG2yK3JxXRtpCBQbWMUJPdDE87aiKEv
         7aJZrZV/PNhG8Ey6gtflLAjJaUKTfXMlmIcc0cc8rP+1mV7ZsiCOHUq60tgeL+ItulTy
         PoFmdh3hcygEXnFnikQGMMFBerFNOHHRfISmQ5oVydS6GkkdOakkCZ1uR0ZiXTVOfTff
         SkiQ==
X-Gm-Message-State: AOAM531UcKjmain0g0+fgK48Rxh3b0dyF+H6/DYCtZj9J0q7pVvYXeYR
        oemVh+HUG4wBrKKcmr8E0C8=
X-Google-Smtp-Source: ABdhPJwlZpX2TPdL3zOyAu1VnxrRS8PoqyKWdF4tt4azny/VvsYWCKR83UTgJ8mebPANVWmiZKK+Vw==
X-Received: by 2002:a1c:ed04:: with SMTP id l4mr14754195wmh.93.1590871603163;
        Sat, 30 May 2020 13:46:43 -0700 (PDT)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t189sm4658916wma.4.2020.05.30.13.46.40
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 30 May 2020 13:46:42 -0700 (PDT)
Subject: Re: [PATCH v2 net-next 04/13] soc/mscc: ocelot: add MII registers
 description
To:     Vladimir Oltean <olteanv@gmail.com>, davem@davemloft.net
Cc:     netdev@vger.kernel.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        antoine.tenart@bootlin.com, alexandre.belloni@bootlin.com,
        UNGLinuxDriver@microchip.com, alexandru.marginean@nxp.com,
        claudiu.manoil@nxp.com, madalin.bucur@oss.nxp.com,
        radu-andrei.bulie@nxp.com, fido_max@inbox.ru, broonie@kernel.org
References: <20200530115142.707415-1-olteanv@gmail.com>
 <20200530115142.707415-5-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bb7c9b29-14d2-53ee-e0f9-bdf86f7da49d@gmail.com>
Date:   Sat, 30 May 2020 13:46:38 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; WOW64; rv:68.0) Gecko/20100101
 Firefox/68.0 Thunderbird/68.8.1
MIME-Version: 1.0
In-Reply-To: <20200530115142.707415-5-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/30/2020 4:51 AM, Vladimir Oltean wrote:
> From: Maxim Kochetkov <fido_max@inbox.ru>
> 
> Add the register definitions for the MSCC MIIM MDIO controller in
> preparation for seville_vsc9959.c to create its accessors for the
> internal MDIO bus.
> 
> Since we've introduced elements to ocelot_regfields that are not
> instantiated by felix and ocelot, we need to define the size of the
> regfields arrays explicitly, otherwise ocelot_regfields_init, which
> iterates up to REGFIELD_MAX, will fault on the undefined regfield
> entries (if we're lucky).
> 
> Signed-off-by: Maxim Kochetkov <fido_max@inbox.ru>
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
