Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 011BD2C56DD
	for <lists+netdev@lfdr.de>; Thu, 26 Nov 2020 15:15:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391058AbgKZOO5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Nov 2020 09:14:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35664 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390266AbgKZOO4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Nov 2020 09:14:56 -0500
Received: from mail-vs1-xe41.google.com (mail-vs1-xe41.google.com [IPv6:2607:f8b0:4864:20::e41])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 717D5C0613D4;
        Thu, 26 Nov 2020 06:14:56 -0800 (PST)
Received: by mail-vs1-xe41.google.com with SMTP id j140so1003399vsd.4;
        Thu, 26 Nov 2020 06:14:56 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=VePxf7m/NgcAWkM2Kfm/Li7iK3Uu9oYrCoBb9NqSgu8=;
        b=WpBod6oATDQlyduaK6nl+Sj2w+ol/6bsos8PTCiaR2xBkbOzeLps/ERf9CH299sy0d
         +6YzsYw49zmbbgid6r7CjeFyIkK+HkphK+EOth7Ydx+dmL+cV7A8fyTJ2wxDfA8z4uBq
         p86eTXOWnsuz1JUEES+d/LjnMGXT3UTgwNcAJuakFcvYGSXX+Fki8Z8EsYrSzKtXDY9I
         bIBtNboYretnI2ulL9o2CRsOSeNejc3ykxBIums7GV+yKXZ1oNna3cMLAhA+JGyubjGd
         aAiPjuckmyJq34gjY0MDOwj3JXX3Zd/feGHmVG46xARCikh3pD3lLG+TzYLswHNLcAtQ
         IyNA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=VePxf7m/NgcAWkM2Kfm/Li7iK3Uu9oYrCoBb9NqSgu8=;
        b=n13ouMgZ8ImisD5LEAgaON0bmmAaMY8qbyrlPm4U7ewk4r7gCXw9UKzdX5KPdBO3qK
         X1p7O8qO1BiX13B63EA5KuoyIsf4BSyPVHqAt92MvH4lHdfuIKA+fqfxug4VrZhOI0Hv
         4vcFSGkMnuicX23nhsMVxc3tCayMTcVctK3Elt20seRPTxaxvSlAnWRoPNlO6Yb89Mjt
         sqx8hiFqyeq4JAlVxWgjsgXRrqBYe8tJdpZ1f1tWZX9NZO1/Tw4yUCbfLn64KJ5s4Cdn
         NcNjZAwN/VFLMiVx8iR3U/SyNuBXRKz0SP0dv+hRlTk2Fs/Q8BOhci4Y21XH8tOYAnQN
         9JKw==
X-Gm-Message-State: AOAM531WxEQ2zdwQAc3nPmngnc1w2qolm1kKdsz2KMPBCwDu9VkjEdu0
        KQLQYaGeyLsAR3ZRoAKJvtWKtRSpzmK4JE2YCk8=
X-Google-Smtp-Source: ABdhPJwhWxBOqidwyQHM+jEIhbhAorzTPnNXyiCXyR5QyHNoiQxadi/kxX0TGqvREKUPc6Lr8WPoek2QDLKLniS20TU=
X-Received: by 2002:a67:3115:: with SMTP id x21mr1921242vsx.12.1606400095332;
 Thu, 26 Nov 2020 06:14:55 -0800 (PST)
MIME-Version: 1.0
References: <20201123191529.14908-1-TheSven73@gmail.com> <20201124161742.795f326d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124161742.795f326d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Sven Van Asbroeck <thesven73@gmail.com>
Date:   Thu, 26 Nov 2020 09:14:44 -0500
Message-ID: <CAGngYiWNeBbH3fnSPVs25pEUCtvuhKWANNv7ZhZNMzh5UHX+2g@mail.gmail.com>
Subject: Re: [PATCH net-next v1 1/2] lan743x: clean up software_isr function
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 24, 2020 at 7:17 PM Jakub Kicinski <kuba@kernel.org> wrote:
>
> Applied both, thank you!

Thank you Jakub !
