Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F03431E20F3
	for <lists+netdev@lfdr.de>; Tue, 26 May 2020 13:36:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731471AbgEZLg3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 07:36:29 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728148AbgEZLg3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 May 2020 07:36:29 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 152C3C03E97E;
        Tue, 26 May 2020 04:36:29 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so1574105ljn.4;
        Tue, 26 May 2020 04:36:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=n7qRuj222fMjN5gfezJPoEb++aOpZrJlyhV+OkWHA3I=;
        b=qATTWkgvl/pddWfQhXgYgI9FkZzKT9wSVFB8HffUHm2/5AHcVYCH+mfyTuzXbu5N7B
         5+Z/o0EYIthDfCgYxnzqY1SfPEisKP14HllN7n8SK3o6lLZsHO9WjIHeHVdSzCLJQKil
         b09cfyVfJ5KM4sJlrrUgwNDqAZG2aLSAAj2i3sXP8eOiqDYW+AlYNKX/izXE8liuFgWs
         4WXW96jBJq8Bp/6exwxc4l8tgqQvg9r8gQBuTUeIeNyeEYsU0Mzj9EzlOX4Irik6JaWA
         5dFmpUn59/5cgWgYvcXz43G1NSSwFHL7L8anGsJx82Pi5i+UPs4LYXfPBf3M1iPnHqan
         qObQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=n7qRuj222fMjN5gfezJPoEb++aOpZrJlyhV+OkWHA3I=;
        b=reZZwuDSwVn3rZt7u+8XfmASOBovhhz8pQpQ97Cic0FC7mSEQDmdgzVvZskEYWiTTw
         LEgZ8AmJPcdndrgwKYdJ7MaUOW5SsC+w2Q+VcGfx9Ica1SD71jxMdqp1lwYiECqv2+1M
         tF+0EdYY9Z8mfBb/fMlu+NA6CkJRS14BcVg8pUQuFLe8hcu5cPvmYd9ic3MgTL+9hytt
         Rvz+ul0HCt/okXz6jOSgsTDAOUA/rhUXxWKH4dx07B717jne9QbTFvUpgUROtsDwSVDJ
         O3waNNS/pYeUc4J55QEOPLMqKZ3B8GwxJl7UHUkA0YkiwCat/NCH++gtQqssyB5EYu6C
         HCfQ==
X-Gm-Message-State: AOAM531ipmk18rPw7Wqynn0mvKwpZpmDaP4mc3WQ84dQqxZFBJEubAyl
        hbylBe/w0Ds7N+DOZdoGrHyj5xt+6JYGHyRTf1Yh78Bm
X-Google-Smtp-Source: ABdhPJwLCu6lTROK8R5cM7T9azsG/diLvdXP/54j/Fnitz5AIoi2VD+MM3/hBhWrZFj7F1HZdaQACj/LPRNT5YbXl2I=
X-Received: by 2002:a2e:9b4d:: with SMTP id o13mr426940ljj.363.1590492987508;
 Tue, 26 May 2020 04:36:27 -0700 (PDT)
MIME-Version: 1.0
References: <20200515164640.97276-1-ramonreisfontes@gmail.com> <ab7cac9c73dc8ef956a1719dc090167bcfc24b63.camel@sipsolutions.net>
In-Reply-To: <ab7cac9c73dc8ef956a1719dc090167bcfc24b63.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Tue, 26 May 2020 08:36:15 -0300
Message-ID: <CAK8U23ZaUhoPVdWo-fkFpg4pGOcQQrk7oSbs9z1XPVE3cR_Jow@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: report the WIPHY_FLAG_SUPPORTS_5_10_MHZ capability
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Not sure this is enough? How about wmediumd, for example?

It works with wmediumd too. At least I was able to enable 5 / 10MHz
via iw with 5.9GHz

> And also, 5/10 MHz has many more channels inbetween the normal ones, no?
> Shouldn't those also be added?

Tested with 5855MHz - 5925MHz

--
Ramon
