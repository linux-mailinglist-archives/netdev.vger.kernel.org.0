Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AA2D22B229C
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 18:36:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726610AbgKMRgC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Nov 2020 12:36:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60368 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726136AbgKMRgB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 13 Nov 2020 12:36:01 -0500
Received: from mail-pg1-x532.google.com (mail-pg1-x532.google.com [IPv6:2607:f8b0:4864:20::532])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CF549C0613D1;
        Fri, 13 Nov 2020 09:36:00 -0800 (PST)
Received: by mail-pg1-x532.google.com with SMTP id f38so7657071pgm.2;
        Fri, 13 Nov 2020 09:36:00 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=WFsk02laB2PDDhAOiODMzXvVIH4r8zq9tMa2KeyB7uA=;
        b=jqh5zy0G6VIg6y9se75gO+rCuuIvg76Zil/R7l1BFUvapWlGNihGiHAeY9Xuy7Rtlg
         GDz9kqT9o5xMsuv554cWSJDLLecJlAOJhQx4YZb+rlwsKyJu6Ttkjxa/vmc27zPXKyi8
         ong4H7vo4lsyWSkZIVqlj2NpAzA11tJ81k2QTDTSaCqM/2VhKfwHSp7m9Nf/WHqg3Bbk
         DXLDxh9U7K8wh1U46pcoOHXLsW7uTVK9pFrErJGXNQ7AHv9+IMGLjHoJ2dqVZ467zrdo
         1mOAxh9hB6ey2MQDXmIHJdxEyIt1meyF2VpyZLvsZ+jAcaBwYaKv2xsdQ6Bi3H34hTPH
         T2XQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=WFsk02laB2PDDhAOiODMzXvVIH4r8zq9tMa2KeyB7uA=;
        b=kwDu/XnS4UnLmQty/RTyv0Eo0K7F6vxUsOnkuuE1LL3B9CLVKqst2imSGXeavs5t3F
         QIo0RPQ3SQfsIPDh6GLy7TtDJTdR4PSruv+3PiQUqY3HGRtrDTQuHHp/PutC9xQK/i4j
         FSdMfyWtaKzvtHVh+zeeewDL/rsTV6dyMbgF53oTR8GkgAp8bYdmMiSaHZmRK86NVdgP
         y8oA8xFVJLLWc+5pR5gAOoBvonsh4Auk6UsS0ybRMoO69cIcZqMOufq2VfEkEUBNmsZd
         hAGSRZOXL+DlmqllclrFx04KLl+z9/Ln+GCU0m0dtkmpFXqJ3Tgd4UCq4Mnt+m7uLKMV
         JwSw==
X-Gm-Message-State: AOAM533Psf5PpcYFPb+IU7ZF+tMcfZ7UQ80dUG5D8FUkvF43yraLA9OZ
        3xNvdI6awu8jQzrrlvliw8UmvVZNWbpoih+IaQg=
X-Google-Smtp-Source: ABdhPJy+W3bCjZfmVpQsSHdQpUOksuFNhp0ghlUTkyAogGTJrQb9McWj4gcOg9J2GF2E0hkXYXxtbDOf+blwL3UlFow=
X-Received: by 2002:aa7:83c2:0:b029:156:5ece:98b6 with SMTP id
 j2-20020aa783c20000b02901565ece98b6mr3008556pfn.4.1605288955357; Fri, 13 Nov
 2020 09:35:55 -0800 (PST)
MIME-Version: 1.0
References: <CAJht_EMXvAEtKfivV2K-mC=0=G1n2_yQAZduSt7rxRV+bFUUMQ@mail.gmail.com>
 <ed5b91db-fea9-99ff-59b7-fa0ffb810291@kernel.org> <f3b2c6ea4185226ad4058ed8a70ffb52@dev.tdt.de>
In-Reply-To: <f3b2c6ea4185226ad4058ed8a70ffb52@dev.tdt.de>
From:   Xie He <xie.he.0141@gmail.com>
Date:   Fri, 13 Nov 2020 09:35:44 -0800
Message-ID: <CAJht_ENUEN3WTcHA3U=oX6bkqE_tkxmpP0Q8QConRvx+z7CO7w@mail.gmail.com>
Subject: Re: linux-x25 mail list not working
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     "John 'Warthog9' Hawley" <warthog9@kernel.org>,
        postmaster@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@kernel.org>,
        Willem de Bruijn <willemdebruijn.kernel@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux X25 <linux-x25@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Nov 12, 2020 at 9:28 PM Martin Schiller <ms@dev.tdt.de> wrote:
>
> On 2020-11-13 03:17, John 'Warthog9' Hawley wrote:
> > Give it a try now, there was a little wonkiness with the alias setup
> > for it, and I have no historical context for a 'why', but I adjusted a
> > couple of things and I was able to subscribe myself.
> >
> > - John 'Warthog9' Hawley
>
> Thanks a lot John! Now it seems to work again.

Thank you John!! I see the mail archive at
https://www.spinics.net/lists/linux-x25/ is also working again!
