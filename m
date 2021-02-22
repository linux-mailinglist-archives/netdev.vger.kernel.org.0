Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4D3E4321034
	for <lists+netdev@lfdr.de>; Mon, 22 Feb 2021 06:17:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhBVFRD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Feb 2021 00:17:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53698 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230131AbhBVFRB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Feb 2021 00:17:01 -0500
Received: from mail-ot1-x334.google.com (mail-ot1-x334.google.com [IPv6:2607:f8b0:4864:20::334])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00B32C061574
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:16:21 -0800 (PST)
Received: by mail-ot1-x334.google.com with SMTP id r19so3620335otk.2
        for <netdev@vger.kernel.org>; Sun, 21 Feb 2021 21:16:20 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=XPAF3o8onbIPPCQvK50+EWpZPR/foC/1hdldk4dfeCM=;
        b=m4UdujU13QwtvfOFd13QARL7XQRMWVGmwnptsgmU/IBJCL9J8pwvzt4soNcDOhFGRn
         pNgZDniWONCCuTvYvatdYZU5JJXIYlZsVVlHnRG0PD7a+ZhFk2ayAQsA5sfA56C5L8xw
         4rLT0JqqkQuUEzMoFpOE1Hw5Ql8ZUhEqhdFmGBNbQMXC721VL9yRGsLp8KCwPH6XmWwH
         DxrjDoXiLr8yWev4hjnKf98v7xoomPiFN6glhwM4WXaT+bHTToTWM9l1fzyG4A22gy5+
         5dUjrcgAc6r2fyfqM0eCfQzKsuTFUUn8msj4M1PEbmGd72hgebVrk2PaRkvkjs5m07a7
         XDKQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=XPAF3o8onbIPPCQvK50+EWpZPR/foC/1hdldk4dfeCM=;
        b=H8d6mEgceAwzBfwa0Rfb1vS6DHqjhvsjU8CAXLGraAydqENKxaurf3NiaHpjJ0jrN6
         3JGuLv4DPF6Z42bxhMMdDQjKH2dXB4JbHZYmuEn9FBYKk+PMnrKP5r57Iuhvb4Fi/U/f
         z4GCJlb1kG6guhEGCuPqICfH5RRwG5VreWGTS3DNrnkkqGHFmR0JQHqPFatGUz6hFVqy
         SJ/tiBp+LxqPCtEcUeYfQTXu35y/TihXtRh8XbuPK/R+rN/Qzm7/PzqpxtLpysUEfP5E
         toIzcbXE0FKc66XlODJbGlpiy8Ib6nhdsUgaFZ8g2JwOuGqwvSTkBOq+GhqY1SiQwU7s
         CA6Q==
X-Gm-Message-State: AOAM532GkesEwbv2OI02th94KoQ6D3QnMxHn+6bPTq66+uObBFenSSSa
        Sn6bmb6MoE5U9BbBLK+F31Y=
X-Google-Smtp-Source: ABdhPJz6dVMJ4Ziom8dOkJPppBW8CXa/V1MJni21HgU9IO6Oy7FaYtVJBS7Hz6fOnrCnxpmx/DNQIg==
X-Received: by 2002:a9d:7f86:: with SMTP id t6mr15587439otp.362.1613970980436;
        Sun, 21 Feb 2021 21:16:20 -0800 (PST)
Received: from ?IPv6:2600:1700:dfe0:49f0:f028:e4b6:7941:9a45? ([2600:1700:dfe0:49f0:f028:e4b6:7941:9a45])
        by smtp.gmail.com with ESMTPSA id i3sm1143746otk.56.2021.02.21.21.16.18
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 21 Feb 2021 21:16:19 -0800 (PST)
Subject: Re: [RFC PATCH net-next 07/12] Documentation: networking: dsa:
 mention integration with devlink
To:     Vladimir Oltean <olteanv@gmail.com>, netdev@vger.kernel.org
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>,
        Ido Schimmel <idosch@idosch.org>,
        DENG Qingfang <dqfext@gmail.com>,
        Tobias Waldekranz <tobias@waldekranz.com>,
        George McCollister <george.mccollister@gmail.com>,
        Horatiu Vultur <horatiu.vultur@microchip.com>,
        Kurt Kanzenbach <kurt@linutronix.de>
References: <20210221213355.1241450-1-olteanv@gmail.com>
 <20210221213355.1241450-8-olteanv@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <bce2405e-d4f9-ab53-89b4-58acc89462ad@gmail.com>
Date:   Sun, 21 Feb 2021 21:16:18 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Thunderbird/78.7.1
MIME-Version: 1.0
In-Reply-To: <20210221213355.1241450-8-olteanv@gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 2/21/2021 13:33, Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> Add a short summary of the devlink features supported by the DSA core.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
