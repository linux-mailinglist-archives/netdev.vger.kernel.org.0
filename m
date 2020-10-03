Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4CB6B282670
	for <lists+netdev@lfdr.de>; Sat,  3 Oct 2020 21:44:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725919AbgJCTos (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 3 Oct 2020 15:44:48 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:49779 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1725831AbgJCTos (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 3 Oct 2020 15:44:48 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1601754287;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=7ajQYGYojq4f9aQLq4fZ43qbXeKvwhmhvTmq4l0hgCs=;
        b=iolzYA72rwRTeMOgkMRLXENozUKvU2bVeoYVmk/6WGo0eH7LvDFjBmzmnfw2OuBc/N2gxi
        K/reKmb6sq0GNPvDlURzLfogH0mlY9W5OU1ATKCPGISKnalVqQTRdibSyzsg1HbgmQUelX
        e00OZBOry8yRo10Z2dXnPTggIi/WqYE=
Received: from mail-ot1-f69.google.com (mail-ot1-f69.google.com
 [209.85.210.69]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-251-zd4sAqXAOO6R9oFg_8s8lw-1; Sat, 03 Oct 2020 15:44:45 -0400
X-MC-Unique: zd4sAqXAOO6R9oFg_8s8lw-1
Received: by mail-ot1-f69.google.com with SMTP id d10so2288802otq.11
        for <netdev@vger.kernel.org>; Sat, 03 Oct 2020 12:44:44 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=7ajQYGYojq4f9aQLq4fZ43qbXeKvwhmhvTmq4l0hgCs=;
        b=mO//sATwSwYAW+VbByVWoOOIvD6SNlxPvtM1yYCwDSy2mf/9wGNwM6DUIZG+GRw5fS
         ADNYx5UcE2eAPFZ9L2PWnBEAGE/89JTlqj4zyievymdOIT8XiXpKFUlInX2Adf66p67f
         yRZK/KhR9TmJO3soiHEbmRl7aoEBmNBVZyg9ckYGXMvUc9YmBM1i88kBrgvAr2jq6Z4A
         jsogF3oAiG9nIQhYWDTW0IxFsnI+R5jXzNq+WTKGIwUMkZVOWf7v7++pOUjb3wunon0T
         7W3pLL2c7/lzQnzDO3ZwgOAA8No1zwWIY/F0G6ZS5Wy6o+suKuI6stWT2DVoTTQFmXFF
         C8OA==
X-Gm-Message-State: AOAM531Le9uZ3QLzxk2usQoR2t65do12kXeaoXHrink6pxSt0+OQUDrP
        E8sjUpn2a9aeucYpIMe0mZ+2iYHSGKAk79ZFKzC3VNsVT071dECVAG6SobaCoBHsxqpRsvw1kNx
        DkMeffjcig9j8A1WqAt+jiLScYdDs+Zmz
X-Received: by 2002:aca:4e06:: with SMTP id c6mr2746465oib.120.1601754284256;
        Sat, 03 Oct 2020 12:44:44 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJz+1W2OcJQdBH5Es26AH2enJprMfA6Y6Ta0TykOVjsUsp+EeIZZaj3b8yn+Q4U1qjm0n74jCFvjcTLQRMWgMzI=
X-Received: by 2002:aca:4e06:: with SMTP id c6mr2746461oib.120.1601754284042;
 Sat, 03 Oct 2020 12:44:44 -0700 (PDT)
MIME-Version: 1.0
References: <20201002174001.3012643-6-jarod@redhat.com> <20201002121051.5ca41c1a@hermes.local>
 <CAKfmpSecU63B1eJ5KEyPcCAkXxeqZQdghvUMdn_yGn3+iQWwcQ@mail.gmail.com> <20201002.155535.2066858020292000189.davem@davemloft.net>
In-Reply-To: <20201002.155535.2066858020292000189.davem@davemloft.net>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Sat, 3 Oct 2020 15:44:33 -0400
Message-ID: <CAKfmpSd=mSUEThgD_z58wHkyLtHZcZHcK87t+EzXHU2QSxf2Dg@mail.gmail.com>
Subject: Re: [PATCH net-next v2 5/6] bonding: update Documentation for
 port/bond terminology
To:     David Miller <davem@davemloft.net>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Jay Vosburgh <j.vosburgh@gmail.com>,
        Veaceslav Falico <vfalico@gmail.com>,
        Andy Gospodarek <andy@greyhouse.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Davis <tadavis@lbl.gov>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 2, 2020 at 6:55 PM David Miller <davem@davemloft.net> wrote:
>
> From: Jarod Wilson <jarod@redhat.com>
> Date: Fri, 2 Oct 2020 16:12:49 -0400
>
> > The documentation was updated to point to the new names, but the old
> > ones still exist across the board, there should be no userspace
> > breakage here. (My lnst bonding tests actually fall flat currently
> > if the old names are gone).
>
> The documentation is the reference point for people reading code in
> userspace that manipulates bonding devices.
>
> So people will come across the deprecated names in userland code and
> therefore will try to learn what they do and what they mean.
>
> Which means that the documentation must reference the old names.
>
> You can mark them "(DEPRECATED)" or similar, but you must not remove
> them.

Okay, so it sounds like just a blurb near the top of the file
referencing the changes that have been made in the code might be the
way to go here. Tagging every occurrence of master or slave in the doc
inline as deprecated would get ... noisy.

-- 
Jarod Wilson
jarod@redhat.com

