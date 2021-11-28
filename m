Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CB823460AFB
	for <lists+netdev@lfdr.de>; Mon, 29 Nov 2021 00:13:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348477AbhK1XQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Nov 2021 18:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36962 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234011AbhK1XOc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Nov 2021 18:14:32 -0500
Received: from mail-ot1-x332.google.com (mail-ot1-x332.google.com [IPv6:2607:f8b0:4864:20::332])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 06DBDC061574
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 15:11:15 -0800 (PST)
Received: by mail-ot1-x332.google.com with SMTP id n104-20020a9d2071000000b005799790cf0bso22964659ota.5
        for <netdev@vger.kernel.org>; Sun, 28 Nov 2021 15:11:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=message-id:date:mime-version:user-agent:subject:content-language:to
         :references:from:in-reply-to:content-transfer-encoding;
        bh=3ANDAvy+t87+3k5fGu7wTBnNzcrlVzmpNe5vJe65QFk=;
        b=pR9JVFo/Tbs40ZSiCvRnrFuo2U0dIsVnU7ajJQy4T+mes52oW0uIWxmKIJ+0Fn190d
         ACzqin7cSPQqQDx6H1VeK3NOa1jUhMH7GcatxQe4dm62xgIDHZOe3nQzprBlO8U4phtT
         75NxW6E+duXM//WSih0gyCwRp+9o6bxz3sb3N1ABOmrE/PSNg9zbpWkceXbBaKpLWSfZ
         7pNl6Od86Ev//cLdSs3FoM80wdR81wgQhxVRSh6T2MJZFEgRGIFspYHI+iLhksY8M9ZN
         imJK4bxeWUcQeQylQyOFbuaJHAJLdKotldMgeatA8ts9LkhJtc/loJrO8lJd7EF/2MKE
         9Aeg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:message-id:date:mime-version:user-agent:subject
         :content-language:to:references:from:in-reply-to
         :content-transfer-encoding;
        bh=3ANDAvy+t87+3k5fGu7wTBnNzcrlVzmpNe5vJe65QFk=;
        b=5ykKQXKyHoYUEADy8rfSwDzyttoeOEri5TzliQlJedq2sGCxWi7uO/dira+v2HpwHo
         SMWSQaTXN/F0oFtCYv90fZHpYhnkkMT5pp1CzfoayOkWs3Lvbou9cK9veQ49T5XSoIqk
         EIN76s8PRy9i/n2etrqQGqFwwQkU0Eq7ndxdeCv1zXLhVrG5eC2yxKsdgX3jnHzRAcPK
         /9Y3LGSggufxBfR0OlcgSk3Gs5XOEORE9qoOKpZUcDbWxm2DOnxFu8lQ32HL6RyDWN9N
         3u8tUBnrMO02nPLAfnopYoCM8EDXoXAunWoIQqVnpsXRuhfbN3tU/mCUaSkesmGYPdLX
         Y5EQ==
X-Gm-Message-State: AOAM533FMbRFn5bklJzr7gTKJgwFXo/oXcaqnsj6NeIiIf2HgUfTehtc
        z+9p1qsYfqjV5CjutcbjoNuD3rNXfiw=
X-Google-Smtp-Source: ABdhPJy3LYSM6d4NzQOHQS+MfIQlg73Dw/Rt92xAUfNIigDCreWabJ4T9qKnF7OfShIlOvf6H5oXlA==
X-Received: by 2002:a9d:4f0b:: with SMTP id d11mr41581006otl.227.1638141075317;
        Sun, 28 Nov 2021 15:11:15 -0800 (PST)
Received: from [172.16.0.2] ([8.48.134.30])
        by smtp.googlemail.com with ESMTPSA id a6sm2649161oic.39.2021.11.28.15.11.14
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 28 Nov 2021 15:11:15 -0800 (PST)
Message-ID: <ab9b65b4-04d6-0bfe-4fd1-91af9ac5aa0d@gmail.com>
Date:   Sun, 28 Nov 2021 16:11:12 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.3.1
Subject: Re: IPv6 Router Advertisement Router Preference (RFC 4191) behavior
 issue
Content-Language: en-US
To:     Juhamatti Kuusisaari <juhamatk@gmail.com>, netdev@vger.kernel.org
References: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
From:   David Ahern <dsahern@gmail.com>
In-Reply-To: <CACS3ZpA=QDLqXE6RyCox8sCX753B=8+JC3jSxpv+vkbKAOwkYQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/18/21 3:35 AM, Juhamatti Kuusisaari wrote:
> Hello,
> 
> I have been testing IPv6 Router Advertisement Default Router
> Preference on 5.1X and it seems it is not honoured by the Linux
> networking stack. Whenever a new default router preference with a
> higher or lower preference value is received, a new default gateway is
> added as an ECMP route in the routing table with equal weight. This is
> a bit surprising as RFC 4191 Sec. 3.2 mentions that the higher
> preference value should be preferred. This part seems to be missing
> from the Linux implementation.
> 
> The problem has existed apparently for a while, see below discussion
> for reference:
> https://serverfault.com/questions/768932/can-linux-be-made-to-honour-ipv6-route-advertisement-preferences
> 
> I am happy to test any improvements to this, in case someone takes a look.
> 

do you have CONFIG_IPV6_ROUTER_PREF enabled and accept_ra_rtr_pref set
for the device?
