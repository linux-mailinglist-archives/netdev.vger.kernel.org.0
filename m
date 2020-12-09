Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 68FA32D4E62
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 23:56:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387912AbgLIWyr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 17:54:47 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58078 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729617AbgLIWyq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 9 Dec 2020 17:54:46 -0500
Received: from mail-pf1-x42a.google.com (mail-pf1-x42a.google.com [IPv6:2607:f8b0:4864:20::42a])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8189FC0613CF;
        Wed,  9 Dec 2020 14:54:06 -0800 (PST)
Received: by mail-pf1-x42a.google.com with SMTP id i3so2172875pfd.6;
        Wed, 09 Dec 2020 14:54:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=lanATv4oPPkDwFaB9qQIK45VqUMTlXl+oCa+92TkqwA=;
        b=a1LJT7CHqVkFmpPPq4vfKK2iHYDskt9d+GXuzzpCWibXJC1W/p0QZTjJR6YKYQR8Iz
         RzGqgrBd52sbdim6Bi9MPNMld+VVyXPFECoaK0mUOwvsB8tZTlaaNoJFMeOW8cQxTEet
         lI3pKj2aVudpw8X5z1WYy0+uKlJRUqJQsJy6gFgVJPNL4dSi+TmO1BuDaLsbP4oy5tw3
         H5WtWrkk5M6zfPoLmutuxcfzxOm6iqz5McABNS85JISQj1//HO1QtV7/qyCObtYUhNUm
         b6uKHxTOtbtrue3mIGyVoYQxQjfmytvIoF1YMI7gbYFOPsi3LFgtdRscTtaBi5Kh7RSZ
         hwCg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=lanATv4oPPkDwFaB9qQIK45VqUMTlXl+oCa+92TkqwA=;
        b=Hy6GDMUmbsedu3mealvufDDx7I4yqDbbRjA+CMGvNc4CKQtmGTpR7z6hi5AKm+A7Cy
         kBo00NILCGs0U3+JimWgyW7a4ze53zphBNZLIZqaXZ5h6lO60vBHAwqNpjhH2rEJxjsG
         P0E/o49ESV4IvDmnKt3wrV5ncwYh6XdbhdPOExaKyztvYjUGDjDD5eD8jWYsD8WaZNsS
         NYyBvL0uMDAlBIETyrlLMFmsmiyR+nyX/c3utH9fCtSa+3SdhJK0av1dasMkI4FJcp2U
         JEjBEoZrnastAhcFlCxgaqEPWXeOyabn0WcNIXo3rGkFd6cCEXvNT//OD6CSSrmAZMMF
         AsJw==
X-Gm-Message-State: AOAM5321NgRrHaSZ3SywHCEhMZjoBNtEQV/JmJH996zHTN2hjWfZPb2+
        3b52OcmBsWMqD608qOGtx1YJX0kGQwmVWx8gqcDM0O9F1NI=
X-Google-Smtp-Source: ABdhPJxvNEYjMtHCvrrd3d8QPr0FLUevAYtzuvTgv50hYEuM9Qo2B88b7nImNE+CfOrKtKYIjFVUj6z+23ZHe4VJp34=
X-Received: by 2002:a62:5b05:0:b029:197:fafb:50f3 with SMTP id
 p5-20020a625b050000b0290197fafb50f3mr4125745pfb.76.1607554446124; Wed, 09 Dec
 2020 14:54:06 -0800 (PST)
MIME-Version: 1.0
References: <20201209033346.83742-1-xie.he.0141@gmail.com> <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
In-Reply-To: <801dc0320e484bf7a5048c0cddac12af@AcuMS.aculab.com>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Wed, 9 Dec 2020 14:53:55 -0800
Message-ID: <CAJht_EMQFtR_-QH=QMHt9+cLcNO6LHBSy2fy=mgbic+=JUsR-Q@mail.gmail.com>
Subject: Re: [PATCH net-next] net: x25: Remove unimplemented X.25-over-LLC
 code stubs
To:     David Laight <David.Laight@aculab.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        "linux-x25@vger.kernel.org" <linux-x25@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Martin Schiller <ms@dev.tdt.de>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Dec 9, 2020 at 1:21 PM David Laight <David.Laight@aculab.com> wrote:
>
> I always wondered about running Class 2 transport directly over LLC2
> (rather than Class 4 over LLC1).
> But the only LLC2 user was netbios - and microsoft's LLC2 was broken.
> Not to mention the window probing needed to handle systems that
> said they supported a window of (IIRC) 15 but would discard the
> 5th back to back frame.

To me, LLC1 and LLC2 are to Ethernet what UDP and TCP are to IP
networks. I think we can use LLC1 and LLC2 wherever UDP and TCP can be
used, as long as we are in the same LAN and are willing to use MAC
addresses as the addresses. X.25 layer 3 certainly can also run over
LLC2.

Linux actually has support for LLC1 and LLC2. User space programs can
transmit data directly over LLC1 and LLC2 using "AF_LLC" sockets.
