Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 737F02FE1FD
	for <lists+netdev@lfdr.de>; Thu, 21 Jan 2021 06:46:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727852AbhAUFqU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 Jan 2021 00:46:20 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54630 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728803AbhAUDom (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 20 Jan 2021 22:44:42 -0500
Received: from mail-pg1-x530.google.com (mail-pg1-x530.google.com [IPv6:2607:f8b0:4864:20::530])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00251C061575
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:43:55 -0800 (PST)
Received: by mail-pg1-x530.google.com with SMTP id q7so501362pgm.5
        for <netdev@vger.kernel.org>; Wed, 20 Jan 2021 19:43:55 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=Ib0QCsH7dSy58+XvBX7OOoJrz6BAVzUXqXuS60XegYY=;
        b=B+GjGJY+g7bRrSi9bfagMgHcn04VfrkI9PQbwah94h4h3ffyOhk7ndB/D3O0ri8fk4
         5H/a3KzZzA3IrC8xDUlTDAJgZdIWHIChCVZo4ldZbGhQO7Jzejo5pAHScF5QDgJ9VNcg
         SsC4YZV1fR9yI3HvtRWtHXhOqhxiEpikQgJkLDv9/vn3EIyD0iKlSu+lkH93JO40FBP1
         E56g+M8zBmj6ihnK8GH6B8fGbqbfatRORSKTmPzPSkP0WOOMrTg1N0Vez/FrO8q2R0Av
         23lpe/ikWs6NmXDsR6GnJ4fmghwjIDMSa2jefYlkeEA2nFKQA8JICB3A1TyTcM8CXIWt
         9Agw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Ib0QCsH7dSy58+XvBX7OOoJrz6BAVzUXqXuS60XegYY=;
        b=EakTvPapqwU4ulFrIAz8YhScpEirOAhpuhBXY3ZJZdBkVX+nenTomG6DBW89Zuy0cW
         Zj8/v6HyUBRObIAxJLfxW/y38UQy/LFbOlKMQKOocny7BQKitGPEJu6fK4Rv5f2gNnqw
         Te4UdHGLqYlt3044DH/14x2Aka2h4p9c/7tOeg1ysut57rTvD9MXZHVvpV0r91nDfe5I
         LNGx/XmO41IQKIjZM/ga5zOPyDUR0tXFkBUkZ5RsaPHQELNKPjOcC/Nkkjl3NaUCrr7A
         +2ByIoE4aNoYSgIfTchGq23eVpWQhgwVNRvvaj4x5KOBVk0M+7w2ctAY61+WJ4/nTr+W
         7EUw==
X-Gm-Message-State: AOAM530sMje8jcOgzbMs25qVkUe3EhMNB2Ax/inBziLr4nmPS9HSzJem
        oaT5ueXsvMKheZv2Fcoes18=
X-Google-Smtp-Source: ABdhPJxtQiRvW9Eo+djtZnO59SEMolNJvbUGJiSY+BnEXPVrWjLWlT2F8kevqB1TD2in/oWvgO5FOg==
X-Received: by 2002:a63:c207:: with SMTP id b7mr12389560pgd.184.1611200635402;
        Wed, 20 Jan 2021 19:43:55 -0800 (PST)
Received: from [10.230.29.30] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id k128sm3786390pfd.137.2021.01.20.19.43.52
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Wed, 20 Jan 2021 19:43:54 -0800 (PST)
Subject: Re: [PATCH v5 net-next 06/10] net: dsa: document the existing switch
 tree notifiers and add a new one
To:     Vladimir Oltean <olteanv@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Richard Cochran <richardcochran@gmail.com>,
        Claudiu Manoil <claudiu.manoil@nxp.com>,
        Alexandru Marginean <alexandru.marginean@nxp.com>,
        Alexandre Belloni <alexandre.belloni@bootlin.com>,
        Xiaoliang Yang <xiaoliang.yang_1@nxp.com>,
        Hongbo Wang <hongbo.wang@nxp.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>,
        Po Liu <po.liu@nxp.com>, Yangbo Lu <yangbo.lu@nxp.com>,
        Maxim Kochetkov <fido_max@inbox.ru>,
        Eldar Gasanov <eldargasanov2@gmail.com>,
        Andrey L <al@b4comtech.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        UNGLinuxDriver@microchip.com
References: <20210121023616.1696021-1-olteanv@gmail.com>
 <20210121023616.1696021-7-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <c588f4a1-78ad-c92e-3e3b-700b47485bd9@gmail.com>
Date:   Wed, 20 Jan 2021 19:43:51 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.6.1
MIME-Version: 1.0
In-Reply-To: <20210121023616.1696021-7-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 1/20/2021 6:36 PM, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> The existence of dsa_broadcast has generated some confusion in the past:
> https://www.mail-archive.com/netdev@vger.kernel.org/msg365042.html
> 
> So let's document the existing dsa_port_notify and dsa_broadcast
> functions and explain when each of them should be used.
> 
> Also, in fact, the in-between function has always been there but was
> lacking a name, and is the main reason for this patch: dsa_tree_notify.
> Refactor dsa_broadcast to use it.
> 
> This patch also moves dsa_broadcast (a top-level function) to dsa2.c,
> where it really belonged in the first place, but had no companion so it
> stood with dsa_port_notify.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
