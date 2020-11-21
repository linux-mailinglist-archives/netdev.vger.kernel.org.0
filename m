Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 590902BC022
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 16:01:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728090AbgKUPBX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 21 Nov 2020 10:01:23 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33150 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728047AbgKUPBW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 21 Nov 2020 10:01:22 -0500
Received: from mail-pl1-x641.google.com (mail-pl1-x641.google.com [IPv6:2607:f8b0:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 67276C0613CF
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 07:01:22 -0800 (PST)
Received: by mail-pl1-x641.google.com with SMTP id 18so6478177pli.13
        for <netdev@vger.kernel.org>; Sat, 21 Nov 2020 07:01:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=igbTgXkAXSmaPGjybCPWgukT2I3p1JxcpedrQGr5L+Y=;
        b=cdI0WXE70lXvNJUJZIs0qJutTeAp17lLPsOyna+WJpMFeaMfL20vvZYMIU5HASd2aL
         feXyFHKgMFIOERbVIWASmIrizZIwdNqQiOcURaJ6c/BhaWcCUk3ictAzh4Lb81f32qTJ
         clLrdOzNMwN9Yz4hG0LL48KPfPNfs2pGFeFpkdiPJbyZ6pMAToWelWklK5TnIwtWN9ai
         pCkM9Fz39vD9VgAHGl+x0k/rt4ML6obXxCHDGoIPpZX31e/Y9d2mDmgNig7HLG/JMsdg
         u2Tg7N3E5OXcLYSojBG72vXPBL04I5c5epmPiA4UXI91flTJ5NP7PyP4h9kT//hSWPzA
         kUiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=igbTgXkAXSmaPGjybCPWgukT2I3p1JxcpedrQGr5L+Y=;
        b=Hjb3TUXtmuTRo8U//8m9ei4jkoSjzCNISW8x6b0gfeNEFwnL2d9nmxQ82C1z6QHf0H
         ra5fZkZ2i3x+vT06BpzzIzGKdNY084rs2tlNQzPr/gH5t9hqrcWr70t+PJHCojRPf8PC
         Y0uchpUcO2tVq3887BIgYewUphLsgie8EqnfAalA0uHpSmqwZ9UzOSuqbCFpI1gLZPcW
         wK1w/3FrCyZEagx3ZGZEm4XLzkBvhj+uj3vMDrq+0wnQLrELXNs6jo9XRXGIUDbF3I42
         b4txd8+rPA7usUT1jcxeKYIkHSnTfY1UykJcYi50z4rpSeSsE0RdmY9cB1ed0IBo51pS
         m1aQ==
X-Gm-Message-State: AOAM531A+38iLH6TcwcpC2FAkyfSnGQu+dFXl0rrVadqs8vQntK/++08
        XEoSXiOe7z/0xzgMVrIS6TROC0pTCBQ=
X-Google-Smtp-Source: ABdhPJyG5Nwz3WuiXOYUt0CYGvQToA5MI5ywgQv7bV6qE9oSo/4R5ouEPmOz9vQuMCNeudwCw/afjQ==
X-Received: by 2002:a17:902:c404:b029:d9:fbf5:83d8 with SMTP id k4-20020a170902c404b02900d9fbf583d8mr1215191plk.13.1605970881598;
        Sat, 21 Nov 2020 07:01:21 -0800 (PST)
Received: from [192.168.1.3] (ip68-111-84-250.oc.oc.cox.net. [68.111.84.250])
        by smtp.gmail.com with ESMTPSA id t8sm7120083pfe.65.2020.11.21.07.01.20
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 21 Nov 2020 07:01:20 -0800 (PST)
Subject: Re: [PATCH net-next 2/2] net: dsa: hellcreek: Don't print error
 message on defer
To:     Kurt Kanzenbach <kurt@linutronix.de>, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
References: <20201121114455.22422-1-kurt@linutronix.de>
 <20201121114455.22422-3-kurt@linutronix.de>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <567f5cbc-001c-c693-3c02-1b157d5571c5@gmail.com>
Date:   Sat, 21 Nov 2020 07:01:19 -0800
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.5.0
MIME-Version: 1.0
In-Reply-To: <20201121114455.22422-3-kurt@linutronix.de>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 11/21/2020 3:44 AM, Kurt Kanzenbach wrote:
> When DSA is not loaded when the driver is probed an error message is
> printed. But, that's not really an error, just a defer. Use dev_err_probe()
> instead.
> 
> Signed-off-by: Kurt Kanzenbach <kurt@linutronix.de>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
