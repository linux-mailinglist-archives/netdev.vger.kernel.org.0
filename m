Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248D8203D7B
	for <lists+netdev@lfdr.de>; Mon, 22 Jun 2020 19:09:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729918AbgFVRJv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 13:09:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729881AbgFVRJu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jun 2020 13:09:50 -0400
Received: from mail-wr1-x443.google.com (mail-wr1-x443.google.com [IPv6:2a00:1450:4864:20::443])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7BCA7C061573
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:09:49 -0700 (PDT)
Received: by mail-wr1-x443.google.com with SMTP id h5so17483852wrc.7
        for <netdev@vger.kernel.org>; Mon, 22 Jun 2020 10:09:49 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=HOSV/U3JaxH9mKz5Yfxaejb5ofaS4BhJZP3QgqrmjGg=;
        b=njdmDISZbpqmQKpamHXngWM+Xn1Ejd4bVLMwrUbF/wTMEDfZEtYXBDsYoNojXUIsZZ
         tGS4qc80IqfsLOT2gI9AuNUkFZZbkhu1Qw2AFBxVknZgJIXN6jvTTKoKbfglyltvbK7I
         wnimXlvJ26J+QLoaBPNrSSPtKm4k0iHwjbmaO5a7Frk1+c0upKt1teyAmhfbc7PaxGys
         1/DQZXvcDOGKuNuUzi98Aov9dvzW30jpFOY4cwWZtjKMP1Otm8bFlurteglY8bgb7JJ4
         BBF78BptyBK5xJFfXhopZewJWJIGL9FuNYzGeJGIrQ3DKXIjhR620EWkc5WGe+bZxX2J
         1Gow==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=HOSV/U3JaxH9mKz5Yfxaejb5ofaS4BhJZP3QgqrmjGg=;
        b=hGXSS/9nTOM8J+AHgMRepbjuZRu6PAG2HuoKsJRAB9pIJeDXpi8ITI/Mjtvx62DY06
         5JjjFfTt7Jkefvq11DZV5AoKcP6StZH+Ndcyrbie44z24hd4In+7EjyvRYNJK5Su8anM
         Cwj8kKJIdCnbZJtiNFdjqsDPISw59MJq/Rrg0xu7D0JY61QcPzfXbNRMIn9RlofuLKpK
         6kvegcPODUr++BX7GjG0vAg7MmvM49QfdUD5DZLBk977RblqZ4t2OWoDw0z7BNwFK/CQ
         yem9yq9rJ24P6p2erufinREMArOkgB7yLju5oG03h0lpMONvlEuBqsNnrlk4o7NEZI5I
         7VMA==
X-Gm-Message-State: AOAM530e59CL868yFWdAH3f+lOt306cCR9iXo2pWCoDOEtqJGLI6BPg/
        IarM6mZiYQG2SOdeZ2BbUbkGZBg1AvzhOt0kpak=
X-Google-Smtp-Source: ABdhPJzHiLM7op9ycY1S+ofrZGnXfeKDrz7ucgA6unnNanOb/Ymb3q1fZEy3+vEtkmySG97VsKFdmP+8GwdWr72kV3o=
X-Received: by 2002:adf:f34e:: with SMTP id e14mr20047584wrp.299.1592845788330;
 Mon, 22 Jun 2020 10:09:48 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1592328814.git.lucien.xin@gmail.com> <5a63a0c47cc71476786873cbd32db8db3c0f7d1e.1592328814.git.lucien.xin@gmail.com>
 <20200622131650.GD2557669@bistromath.localdomain>
In-Reply-To: <20200622131650.GD2557669@bistromath.localdomain>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 23 Jun 2020 01:18:39 +0800
Message-ID: <CADvbK_ekuzyKkAYg1uMhYRQv-FWgHZwftCpdqdCc6gtvxDyajw@mail.gmail.com>
Subject: Re: [PATCH ipsec-next 02/10] tunnel4: add cb_handler to struct xfrm_tunnel
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     network dev <netdev@vger.kernel.org>,
        Steffen Klassert <steffen.klassert@secunet.com>,
        Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jun 22, 2020 at 9:16 PM Sabrina Dubroca <sd@queasysnail.net> wrote:
>
> 2020-06-17, 01:36:27 +0800, Xin Long wrote:
> > @@ -231,6 +255,7 @@ static int __init tunnel4_init(void)
> >               goto err;
> >       }
> >  #endif
> > +     xfrm_input_register_afinfo(&tunnel4_input_afinfo);
>
> This can fail. Shouldn't you handle that error?
Yeah, I copied it from xfrm4_protocol_init().
Now I see why it didn't in xfrm4_protocol_init().

Thanks.

>
> >       return 0;
> >
> >  err:
>
> --
> Sabrina
>
