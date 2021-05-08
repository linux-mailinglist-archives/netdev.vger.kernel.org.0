Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 052EE3772BC
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 17:48:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229673AbhEHPsR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 11:48:17 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48126 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229500AbhEHPsQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 11:48:16 -0400
Received: from mail-pl1-x62f.google.com (mail-pl1-x62f.google.com [IPv6:2607:f8b0:4864:20::62f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9F035C061574;
        Sat,  8 May 2021 08:47:14 -0700 (PDT)
Received: by mail-pl1-x62f.google.com with SMTP id z18so3152659plg.8;
        Sat, 08 May 2021 08:47:14 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:cc:references:from:message-id:date:user-agent
         :mime-version:in-reply-to:content-language:content-transfer-encoding;
        bh=bstsTTNpsNMle2gQUiWKeyxnV0vVc1JNnMWJT7VCZcE=;
        b=A4PXzTlkIhsdqxQHQhUOczem6wzUihyyNStHGV2HDgczRJoSzERFr0dmUbJma1Olu0
         /WVOX6yj2N3Z7cUTw+p936JpaqXEfrmV8lryK7EkOdhcpe7FwUjujVrYOOjCLZLTeBHJ
         ATitTUZHwN+8H98pCh/RGvKJ/nXCZsprQLZDfbf6SYXoOYOjOpn15GaGKAFiOOM9h78l
         o7yCrQfh/r3xhru0+V8qx16t/QQU3UQjmHIgS+qQNrKFRnD7p4BUZ9eyppFdgUGHdfXE
         SROm5N9sf/oJ2ZOooiz0x+ummxJNjRczWRGHCATGLD8SjuO5CmJH1pMojNkFGMxKnIDL
         x6wA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=bstsTTNpsNMle2gQUiWKeyxnV0vVc1JNnMWJT7VCZcE=;
        b=tL6sTUfrz6QPQRS/UgWvLU64zqQ2Z8lsn8RAkdcgKGAbx05xgrfOd3OLH4KMidvytE
         D0QgqHB1A4tm82NMCyGjD1EryFa6INhLAzfvGni4+X7qWm+e4E4xKl8GndMRdx+VpPcc
         hStIHp7Ns005a89EfNrwAMlhZonRekctCJnLeb+elQD+qtEJ86/D1Aiinrs9M6F/Jhq0
         wZY+tk+k3N2uhztDvCfF5X44vOeHJrGCPVBs7apzJLzEAYOD26zyDn26GgAoTwOjQOpk
         7yLa+CpAuS92e8jYTA2v84YnXvEXvm6eHuEDebUbuWsGEWWP9vg4hC4UMedszQBDUUGI
         P2Qw==
X-Gm-Message-State: AOAM532Cj9DYWKtiNDaHmYV9ylJzTIMaKyRKQdK44CwdUJyn3Qt0glsg
        n9TJ1P3c56iLf0b9eNFmXm6qfLEPhSw=
X-Google-Smtp-Source: ABdhPJzRNhAU6f0V7UDTj2z83oDpg/dqdZQNUl+8Je/Dembpk+8zbIZwGjkApBH4K11ahVaW2YqMGg==
X-Received: by 2002:a17:90a:8c81:: with SMTP id b1mr29942772pjo.73.1620488833892;
        Sat, 08 May 2021 08:47:13 -0700 (PDT)
Received: from [192.168.1.67] (99-44-17-11.lightspeed.irvnca.sbcglobal.net. [99.44.17.11])
        by smtp.gmail.com with ESMTPSA id y30sm7227780pff.195.2021.05.08.08.47.09
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sat, 08 May 2021 08:47:13 -0700 (PDT)
Subject: Re: [RFC PATCH net-next v4 04/28] net: dsa: qca8k: change simple
 print to dev variant
To:     Ansuel Smith <ansuelsmth@gmail.com>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210508002920.19945-1-ansuelsmth@gmail.com>
 <20210508002920.19945-4-ansuelsmth@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <1dccbfec-0d08-32d3-c663-0cb96c74b199@gmail.com>
Date:   Sat, 8 May 2021 08:47:06 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.10.1
MIME-Version: 1.0
In-Reply-To: <20210508002920.19945-4-ansuelsmth@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 5/7/2021 5:28 PM, Ansuel Smith wrote:
> Change pr_err and pr_warn to dev variant.
> 
> Signed-off-by: Ansuel Smith <ansuelsmth@gmail.com>

Reviewed-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
