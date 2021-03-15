Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9C2BB33C3FD
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 18:21:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233714AbhCORUf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 13:20:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231305AbhCORUZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Mar 2021 13:20:25 -0400
Received: from mail-pj1-x102b.google.com (mail-pj1-x102b.google.com [IPv6:2607:f8b0:4864:20::102b])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 82B1FC06174A;
        Mon, 15 Mar 2021 10:20:25 -0700 (PDT)
Received: by mail-pj1-x102b.google.com with SMTP id a22-20020a17090aa516b02900c1215e9b33so14761382pjq.5;
        Mon, 15 Mar 2021 10:20:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=subject:to:references:from:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=Zzb1Mx3Me0a7IpWcopNxK/nQDrkG7++JCe/ABaKtP28=;
        b=kXr3M+Mml8Qe7pzEMKeJ06bF1QOgMxDWF27YUlz0eD+RKxKRSOvTGe0IegjeRtGjnU
         6mLfwhm4Jc+E546qAdSl5hbHXd13rwLU2AjZ0Uejd21R3Vjeu/ThlZ7YIquRvlPz/Pem
         WajfQOi+pQ3/kdwVnITV0ERRdHu2KR+ODpxHJx4KCzsNja2geX5POlOXD8F/YCl9p7EE
         m6Tb/3SYxyittBGvSeySU9CbySw1MWV80ub+oZ6u4htSO2TABBq5dd0zaKE3DhFTZCva
         huewkJs87Bu7PW01MwGDZVlsxoEJNsmhEK+mNqaiYjpwnWFi1lFKLvHB1v8SVVSYLaO+
         qCEA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:references:from:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=Zzb1Mx3Me0a7IpWcopNxK/nQDrkG7++JCe/ABaKtP28=;
        b=PHFPF95rO81hYeSD/X6tYIkP9RGMKzkXZVRJNT9sj0cvqkah2znFf//c5Pyby8B+H6
         KA1/VhPRfd489qjBm72Mw3vBLZIjhYymaj40759LEeqDZwUPvdRcYFeX2nqP/w/CL1Ts
         wtGqv7ccUGoheksma/ZxEuAPeCa9ln0UqAObXtHoqG58H3VdpA/IrxQRGYIUtPFZ3uiv
         5uI9LK7cg7kx0e+MpLoclQYkADzt9LU4dXYgndsaBT8+O+TlphU4dxaBXxT1NrnI+ef5
         w6yRiC8nW72QlvfJUk9FZpDxeMC9vaR4wcwjatKQ8bbArY9HiPbBC3ZbIh+tbczQgnu7
         3FcQ==
X-Gm-Message-State: AOAM532CZWSeY3BjBKGY8h28WuC66LRe6JqnuOTCFkVLt9sxzBL5VPp9
        HIoKmjnIV7dQs0kZNUJPDtbC78qmIto=
X-Google-Smtp-Source: ABdhPJzb58yZPqWDt1A2wejdB+Fa9YJHpNgspxVNp63d7JoauHV93CPNv4vMIS433wgRNtEwl/ewng==
X-Received: by 2002:a17:90a:7c4b:: with SMTP id e11mr85144pjl.151.1615828824645;
        Mon, 15 Mar 2021 10:20:24 -0700 (PDT)
Received: from [10.230.29.202] ([192.19.223.252])
        by smtp.gmail.com with ESMTPSA id c128sm13117332pfc.76.2021.03.15.10.20.22
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Mon, 15 Mar 2021 10:20:24 -0700 (PDT)
Subject: Re: [PATCH v2 net-next] net: dsa: b53: mmap: Add device tree support
To:     =?UTF-8?Q?=c3=81lvaro_Fern=c3=a1ndez_Rojas?= <noltari@gmail.com>,
        jonas.gorski@gmail.com, Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20210315151140.12636-1-noltari@gmail.com>
From:   Florian Fainelli <f.fainelli@gmail.com>
Message-ID: <b61866fe-784e-b973-893a-9f7c4d9494fe@gmail.com>
Date:   Mon, 15 Mar 2021 10:20:21 -0700
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:78.0) Gecko/20100101
 Firefox/78.0 Thunderbird/78.8.1
MIME-Version: 1.0
In-Reply-To: <20210315151140.12636-1-noltari@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 3/15/2021 8:11 AM, Álvaro Fernández Rojas wrote:
> Add device tree support to b53_mmap.c while keeping platform devices support.
> 
> Signed-off-by: Álvaro Fernández Rojas <noltari@gmail.com>

Acked-by: Florian Fainelli <f.fainelli@gmail.com>
-- 
Florian
