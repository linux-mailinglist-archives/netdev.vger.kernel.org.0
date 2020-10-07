Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B93CA2863E1
	for <lists+netdev@lfdr.de>; Wed,  7 Oct 2020 18:27:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727857AbgJGQ1B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Oct 2020 12:27:01 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726138AbgJGQ0y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Oct 2020 12:26:54 -0400
Received: from mail-wm1-x342.google.com (mail-wm1-x342.google.com [IPv6:2a00:1450:4864:20::342])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7DDD7C061755
        for <netdev@vger.kernel.org>; Wed,  7 Oct 2020 09:26:54 -0700 (PDT)
Received: by mail-wm1-x342.google.com with SMTP id e2so3091310wme.1
        for <netdev@vger.kernel.org>; Wed, 07 Oct 2020 09:26:54 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=HNrPfVPWEOgSBysddesMcyNlIkodpRatozMw85/sqpQ=;
        b=hynYI2LN4XGDQL9R/Dn9NmsaZkvQkR8Fd711Gt5TSscaQC8Ogxa+RY2WeQXeBvUNu8
         6p1XW8n9vJGWdMj4gMMfYTN0gWzcB98XvjgSUJTYBQ1+afC6cg8j+LmUjjwRi9Eeh//+
         bxXb1/0pdJ6vPQbsCKZTm+uKe7tv8rQJRPawMw0DZTH43XzCe9iPp7TY8QlzYe53kGE1
         BbpWPakNjdtVLK9t/pwRhOCqwX6PJhijByEXJtRbRGtGFzKMw85TXt4if02/nRC/GK2W
         e5IIu2kdjxVvAPAd7XQbQjVE2bfARHOmwKNIWcC49tSvaiJR9CHJ5dyOKY33qmgqAe2H
         LdHg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HNrPfVPWEOgSBysddesMcyNlIkodpRatozMw85/sqpQ=;
        b=Pc4b7uzhsXBbhe31Y6Hs5DU1c9YlRKiM4nWhTJmv3TxnhAnYXhras73Heu4p6Gg+fj
         xrlAdoOI6YZGGaUM1Rx7kaB7EEf4RotUF060UFsu8jy8F3H4/JRrVJJNwoNc4TXTiQ0/
         RFiQGr2fgRDy3UyUJnAJlgA+B65NYDAuEm8jLp/YQJxysb49hMeBww/PootJGKH2iG7q
         cnR4BJlGL0uVZLsqzoVDlTGv5+n1oSvjwsP9w3v/IpRNjCGwU4x6RFW72jgxS5ojrnNh
         fYNMDjZ7RYJnuMMJ7YgjtG/Lh60GeCsoeUOs++SZEV40MGZfHbIj5j+bed8Bicdh7jre
         Y/nQ==
X-Gm-Message-State: AOAM531spSrr0Q8YqpFXfLhb2vil7FtYs2RJA1OcD4Ym7yuqpiTXr/fA
        Myu0OvdVA5SNbp2gGRlnmOCBLtVsWEQwN5lERhZkoeA+
X-Google-Smtp-Source: ABdhPJxJdoftzlQ/1qD1AMxIs8+VhjP5f9hJX04+Ketyitrp5qnD6GRmNBIFOzdChjOBC7LcUqEXFDzklvtSelimSwc=
X-Received: by 2002:a1c:4683:: with SMTP id t125mr4299620wma.110.1602088013225;
 Wed, 07 Oct 2020 09:26:53 -0700 (PDT)
MIME-Version: 1.0
References: <20200730054130.16923-1-steffen.klassert@secunet.com>
 <20200730054130.16923-11-steffen.klassert@secunet.com> <c79acf02-f6a9-8833-fca4-94f990c1f1f3@6wind.com>
 <CADvbK_c6gbV-F9Lv6aiT6JbGGJD96ExWxTj_SWerJsvwvzOoXQ@mail.gmail.com>
 <621ebebc-c73d-b707-3faf-c315e45cf4a4@6wind.com> <2df6aeeb-bad8-e148-d5de-d7a30207cd4c@6wind.com>
In-Reply-To: <2df6aeeb-bad8-e148-d5de-d7a30207cd4c@6wind.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Thu, 8 Oct 2020 00:26:41 +0800
Message-ID: <CADvbK_cmcLqOyuDjBTizj7x-nUf6HoWu1pO8S9XL1Dc63=ZWwA@mail.gmail.com>
Subject: Re: [PATCH 10/19] xfrm: interface: support IP6IP6 and IP6IP tunnels
 processing with .cb_handler
To:     Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Steffen Klassert <steffen.klassert@secunet.com>,
        David Miller <davem@davemloft.net>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        network dev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 7, 2020 at 11:40 PM Nicolas Dichtel
<nicolas.dichtel@6wind.com> wrote:
>
> Le 05/10/2020 =C3=A0 17:11, Nicolas Dichtel a =C3=A9crit :
> > Le 03/10/2020 =C3=A0 11:41, Xin Long a =C3=A9crit :
> > [snip]
> >> When xfrmi processes the ipip packets, it does the state lookup and xf=
rmi
> >> device lookup both in xfrm_input(). When either of them fails, instead=
 of
> >> returning err and continuing the next .handler in tunnel4_rcv(), it wo=
uld
> >> drop the packet and return 0.
> >>
> >> It's kinda the same as xfrm_tunnel_rcv() and xfrm6_tunnel_rcv().
> >>
> >> So the safe fix is to lower the priority of xfrmi .handler but it shou=
ld
> >> still be higher than xfrm_tunnel_rcv() and xfrm6_tunnel_rcv(). Having
> >> xfrmi loaded will only break IPCOMP, and it's expected. I'll post a fi=
x:
> > Thanks. This patch fixes my test cases.
> Do you think that you will have time to send the patch before the release=
 (v5.9)
> goes out?
Sure, I will do it tomorrow.
