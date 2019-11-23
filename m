Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D4129107CA7
	for <lists+netdev@lfdr.de>; Sat, 23 Nov 2019 04:35:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726451AbfKWDbw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 22 Nov 2019 22:31:52 -0500
Received: from mail-vk1-f193.google.com ([209.85.221.193]:43556 "EHLO
        mail-vk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726085AbfKWDbw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 22 Nov 2019 22:31:52 -0500
Received: by mail-vk1-f193.google.com with SMTP id k19so2161375vke.10
        for <netdev@vger.kernel.org>; Fri, 22 Nov 2019 19:31:50 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=cmz/I5suO5ZDEUCFjujbBL+EBELhiLFkCntHf56cv8E=;
        b=o8BkwakPe4Mpo/72Fs8Ch/Tds1OB1HLYQJQ8X3DpZ3apWBKjVOu/qyIGLsfO/RRyNO
         Ynp89Cj0dJ996MhWEn+WaTppl/qS9RH+KZf+NRcatkDuXHptDjTZlPfPb5dW4I8Y1yDo
         e0L4TPvXoM7lxuSw4HvA6/TqPY8ul2uq21ai8atC5aSHyiJN9SOkndBDMLBpo+fMqZzO
         Ye8B27ft2lNAgsLRTRYXI1XrUaLFIIVuHVUzzfnDTBjMYqe22Uzl8OXTGWEiPK672hq0
         aOVllwEYdf+iOTMNIqRLQhBh/PlYFWvqZ+NuVtuXDAlvPkEgx6qflkyB1F+XBnANhT7+
         eXHw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=cmz/I5suO5ZDEUCFjujbBL+EBELhiLFkCntHf56cv8E=;
        b=hjwKKJ37mOIxXNH/Dso1lPWND4oL2NoAIh2qFpOvtQTKJEk8+JRcqcqmBUGbRgCCqZ
         DN8w1gsd2mhJpypQ48OpKGhDzyTr14Xg9dkZUb01EciRzzqTcwkNIhVa5EUo0610PE7q
         p1j008fBtOwU5ANZz+Ve7JZjlvY+ERdwSxLwcgg8n7bb5bK2i41D4UASwrRASO5jl03C
         n7zcKo14yatAumte5TRg63IhggBm4WSSkx9GZjvWQp52YgqXjPQnHuWgrPviVkK8gOP+
         Abp5lUNhe7JvMQ3h4cbks2BFNmS+JV4uH9Isn6h1TRX8qd2LEB8y/Ukk3AjSlXuvYDsU
         G3/Q==
X-Gm-Message-State: APjAAAXL9t7nUqFDBSgTSbgD9ynhYntlP0B37g8LYsR8TksbMc1+mwPH
        Z0WxAFVDW6Fn3MVg+1AOD02Efew1msnTN0sf6XCisg==
X-Google-Smtp-Source: APXvYqzSiM8Ld2LLaFQM7O7GUvsQKIaxk24sy0JE2YNGv5Kh8Wpz+BSzyYhtXMI1IR0iBD1KoDwT7nSTVpaye3duTuk=
X-Received: by 2002:a1f:e243:: with SMTP id z64mr11802401vkg.56.1574479908872;
 Fri, 22 Nov 2019 19:31:48 -0800 (PST)
MIME-Version: 1.0
References: <CANP3RGfF9GZ-quN-ijM4A_A+cP3-tzhA174hFjsYbXPRiTMSLA@mail.gmail.com>
 <20191122215052.155595-1-zenczykowski@gmail.com> <20191122165500.4eeac09c@cakuba.netronome.com>
In-Reply-To: <20191122165500.4eeac09c@cakuba.netronome.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Fri, 22 Nov 2019 19:31:37 -0800
Message-ID: <CANP3RGdne0qC32GpOirbA5wyRGWod3nRLoByGnWVp0kLU2-8_A@mail.gmail.com>
Subject: Re: [PATCH] net: inet_is_local_reserved_port() should return bool not int
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux NetDev <netdev@vger.kernel.org>,
        Eric Dumazet <edumazet@google.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> On Fri, 22 Nov 2019 13:50:52 -0800, Maciej =C5=BBenczykowski wrote:
> > From: Maciej =C5=BBenczykowski <maze@google.com>
> >
> > Cc: Eric Dumazet <edumazet@google.com>
> > Signed-off-by: Maciej =C5=BBenczykowski <maze@google.com>
>
> Applied.
>
> It would had been nice to see net-next in the subject and a commit
> message, you know :/

Sorry, about that.  I'm never entirely certain what's going to
net-next, what isn't.
Should I just default to net-next?

As for the commit message, there simply didn't appear to be anything to wri=
te,
the commit title was pretty self explanatory I thought.

- Maciej
