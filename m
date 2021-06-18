Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8C43ACE1F
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:58:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234810AbhFRPAb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 11:00:31 -0400
Received: from mail-vs1-f43.google.com ([209.85.217.43]:45715 "EHLO
        mail-vs1-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234183AbhFRPAa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 11:00:30 -0400
Received: by mail-vs1-f43.google.com with SMTP id k8so2653719vsg.12;
        Fri, 18 Jun 2021 07:58:20 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=sK1e1fPt0zMaEq6+4wMfGpXVrEHblA3IAhRYoTeadpQ=;
        b=Om495HxaqidnSHxaS6vEj4rVluKt5OUKVCzjfG69FJxQxcGxvYGk3CyeEdbK6VN7yk
         V1rEKGWCfuBYfcGrBRRVoYtKXleP21K2FxTWinvajwsvyle2YzqN3It9toTJjUuONSeN
         Mjr0dU13rKTvY4MUAGeHpqJv64ruEsHN8U7G8OFwgE36YggFt+NwHZCkY6RBipE77jKv
         WxNMTTKTfc/WldKK6jpA7KVibPm3lQyIX1diBnDe/pqyLfZCZa6D/KAMHParfgvxNS1L
         5nsJGMNklcVBlBUGGWjrQGom/MWaNbkFFSbI3iYCKDlsSEqOIwpYm/E18zRA5VSls2EU
         oa7Q==
X-Gm-Message-State: AOAM530+HrIKr9bAPi+6gl/oYDkt3JQ7yUfPQUG4DSH+zG6GN3XKgN4i
        26p2JGUNxw4HMK0BUaUaL4wcaJ1obwePWh2DDKc=
X-Google-Smtp-Source: ABdhPJzg/YZ6W6Is0ERxgmyVpS1tDEBVcgjBpDhPONT5Qk7oJfA8+VdLNRMVYyTep7yhmxjZzTnU3vP2PEwuB0o2fxE=
X-Received: by 2002:a67:3c2:: with SMTP id 185mr7549799vsd.42.1624028299731;
 Fri, 18 Jun 2021 07:58:19 -0700 (PDT)
MIME-Version: 1.0
References: <YIx7R6tmcRRCl/az@mit.edu> <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com> <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com> <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local> <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home> <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com> <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
 <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com> <20210618103214.0df292ec@oasis.local.home>
In-Reply-To: <20210618103214.0df292ec@oasis.local.home>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jun 2021 16:58:08 +0200
Message-ID: <CAMuHMdWK4NPzanF68TMVuihLFdRzxhs0EkbZdaA=BUkZo-k6QQ@mail.gmail.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     Steven Rostedt <rostedt@goodmis.org>
Cc:     James Bottomley <James.Bottomley@hansenpartnership.com>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        "Enrico Weigelt, metux IT consult" <lkml@metux.net>,
        David Hildenbrand <david@redhat.com>, Greg KH <greg@kroah.com>,
        Christoph Lameter <cl@gentwo.de>,
        "Theodore Ts'o" <tytso@mit.edu>, Jiri Kosina <jikos@kernel.org>,
        ksummit@lists.linux.dev,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-block@vger.kernel.org,
        Linux FS Devel <linux-fsdevel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, netdev <netdev@vger.kernel.org>,
        Linux-Arch <linux-arch@vger.kernel.org>,
        Linux API <linux-api@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Steven,

On Fri, Jun 18, 2021 at 4:32 PM Steven Rostedt <rostedt@goodmis.org> wrote:
> On Fri, 18 Jun 2021 16:28:02 +0200
> Geert Uytterhoeven <geert@linux-m68k.org> wrote:
>
> > What about letting people use the personal mic they're already
> > carrying, i.e. a phone?
>
> Interesting idea.
>
> I wonder how well that would work in practice. Are all phones good
> enough to prevent echo?

I deliberately didn't say anything about a speaker ;-)

Just use the mic, with a simple (web) app only doing audio input?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
