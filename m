Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4522A35F734
	for <lists+netdev@lfdr.de>; Wed, 14 Apr 2021 17:12:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232358AbhDNPHg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 11:07:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42574 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229914AbhDNPHe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 14 Apr 2021 11:07:34 -0400
Received: from mail-lf1-x136.google.com (mail-lf1-x136.google.com [IPv6:2a00:1450:4864:20::136])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9BD8C061574;
        Wed, 14 Apr 2021 08:07:12 -0700 (PDT)
Received: by mail-lf1-x136.google.com with SMTP id j18so33808169lfg.5;
        Wed, 14 Apr 2021 08:07:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=sYsWUNBHZnufKSJLy44/uQhBEGPJ9cRby3hv9S4qytU=;
        b=ooBS3WEIlFW/KhJ4U7FI68zulAfBoy5QR3sQ9Lyir6yHMV2n/SNVJMn1nXJw13LEEv
         1CuI88d0QQcoTJtPDVfdxgaf26VIURmEuCCeVBthoYAC9y3izNqscIYhT8RTOHqFBBmA
         76uvxiGThrlX8mQ+TamEPxHQ3sgwwOTc57nBzs+gx3DvyOOvb5t3B1BQj+QNQTuPrEb9
         j1m4/vWyKr9d8nPSZI6/+RpyzeqIw4cm7ccX9mHom5q2tlZbkIvIFw9lZE9j5Cx6z01V
         LDbPHu3ZuSpLWufWiH5cMp6f/4LhNAWCpSY0h3w19istsT6CHbRbxsunw8qtnHUOL9qu
         wTSA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sYsWUNBHZnufKSJLy44/uQhBEGPJ9cRby3hv9S4qytU=;
        b=FIDO/vay4SAm0aaqNRVBH/OgGFenlt6/3hIgtoBlkfjB88B/N+tk9pgkPHcGAULzZC
         8n4D/z6M6yhstxLS3QURwXKH/MD9qA444Mkde6N5bov4/KJ24Ibx0enU9p4vPTSVJL7z
         SGK5spM0xnrmuwtI/BjUQlIOqpzYAUyS2r563VrVvdaju/++99aXzyq3z+nAtOsxCr2p
         oU+CJnH5ep2ytbQDOMcXWyv0DHYwkPsmAXCuEzxh7dMiA3eUYdZOq7KVNF7zbMUQo4d0
         NejD0aqwqGB/H1ribkx/r0NZXjHk13/7I1rJODRUVbHaMpRFd7vQtEjd+JAAs14OYEur
         maiw==
X-Gm-Message-State: AOAM531EFZ8frVk9NVg5gNZqH6IhK4DkJeqEXAT6cmHMXLWgE2HAXU5t
        bBA5SPwNaOiJjagnaH0C1N9OFQqf0pG+NiCD4dRDm5SsTSXOTw==
X-Google-Smtp-Source: ABdhPJxs7ltwZyyjMz7MrRegyOPp0Ytvlu5DeEMinCXqhI0wmO9IT16r7PxNxN3aHgj2aj4S0NeB3QEb4lQio2SJbMk=
X-Received: by 2002:a05:6512:3c88:: with SMTP id h8mr26678155lfv.169.1618412830890;
 Wed, 14 Apr 2021 08:07:10 -0700 (PDT)
MIME-Version: 1.0
References: <20210413010613.50128-1-ramonreisfontes@gmail.com> <4d0a27c465522ddd8d6ae1e552221c707ec05b22.camel@sipsolutions.net>
In-Reply-To: <4d0a27c465522ddd8d6ae1e552221c707ec05b22.camel@sipsolutions.net>
From:   Ramon Fontes <ramonreisfontes@gmail.com>
Date:   Wed, 14 Apr 2021 12:06:59 -0300
Message-ID: <CAK8U23ZXs1LYFXaXKmNfT3M4yXPGhoGoFNh4r4G45YaMHtU-Xg@mail.gmail.com>
Subject: Re: [PATCH] mac80211_hwsim: indicate support for 60GHz channels
To:     Johannes Berg <johannes@sipsolutions.net>
Cc:     linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-wireless <linux-wireless@vger.kernel.org>,
        kvalo@codeaurora.org, davem@davemloft.net
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Advertise 60GHz channels to mac80211.
Oh.. That was a mistake. Sorry for that.

Anyway, can we indicate 60GHz support even though it is not being
supported by mac80211 yet?
