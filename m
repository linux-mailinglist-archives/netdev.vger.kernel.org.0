Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1464E3ACD7E
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:28:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234482AbhFROaZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:30:25 -0400
Received: from mail-vs1-f48.google.com ([209.85.217.48]:38644 "EHLO
        mail-vs1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233642AbhFROaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:30:24 -0400
Received: by mail-vs1-f48.google.com with SMTP id x8so5054542vso.5;
        Fri, 18 Jun 2021 07:28:14 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=wpS6QroHuI0Ot0nY6i49aZuPyLqHan9IIfQa2dpKXgY=;
        b=IfiNQBUzURsf2EszxU+s9Z6Af2EQRwU/yOQq4DeA6pBtwZcYF/9LPjH+/5ZO+7qnaK
         9x462dUr3+2XeTvKAHui4hf2KBjzJbiMCQZu5IBOrLAAikp4r0mW7LCGT4+P/WLnrzUK
         7Zd7Ysb+pBw0rBPbdigMW43k+/ZNmSLvVMGiCtqX+m8rhZhIZ5lYfamr8Wzh8M4uRJc7
         yHh2mfPSHEMblmUnfnU4Xd1vvpHOKxuLkxyPK9DdXiDoAwvxI3reGbHL1wTQZR3FLr4o
         SncrbexpzyCwGAbUuU6kaLV7k1EzWbqjkyt7meP69jQTwD0ushog3tHwe/qzkNmHyaNZ
         peBg==
X-Gm-Message-State: AOAM532h59fhNMmvO5gaXlTTq4o/03EnVcBhJPzoCR5g6pLZYUQtttYU
        rC7gPYao3bb+Dew7DKi0Kh/VuPiYPPlcFXH+iIE=
X-Google-Smtp-Source: ABdhPJzdh6L1VpRsrh92eO3uJR1GKWcu3EWNO1w+Ez7YI5z7LoBIg3gSmZF2HB6Pv0YFaCrWrh9wQb1RBGmHtXwjJ0k=
X-Received: by 2002:a67:7787:: with SMTP id s129mr2392253vsc.40.1624026494097;
 Fri, 18 Jun 2021 07:28:14 -0700 (PDT)
MIME-Version: 1.0
References: <YIx7R6tmcRRCl/az@mit.edu> <alpine.DEB.2.22.394.2105271522320.172088@gentwo.de>
 <YK+esqGjKaPb+b/Q@kroah.com> <c46dbda64558ab884af060f405e3f067112b9c8a.camel@HansenPartnership.com>
 <b32c8672-06ee-bf68-7963-10aeabc0596c@redhat.com> <5038827c-463f-232d-4dec-da56c71089bd@metux.net>
 <20210610182318.jrxe3avfhkqq7xqn@nitro.local> <YMJcdbRaQYAgI9ER@pendragon.ideasonboard.com>
 <20210610152633.7e4a7304@oasis.local.home> <37e8d1a5-7c32-8e77-bb05-f851c87a1004@linuxfoundation.org>
 <YMyjryXiAfKgS6BY@pendragon.ideasonboard.com> <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
In-Reply-To: <cd7ffbe516255c30faab7a3ee3ee48f32e9aa797.camel@HansenPartnership.com>
From:   Geert Uytterhoeven <geert@linux-m68k.org>
Date:   Fri, 18 Jun 2021 16:28:02 +0200
Message-ID: <CAMuHMdVcNfDvpPXHSkdL3VuLXCX5m=M_AQF-P8ZajSdXt8NdQg@mail.gmail.com>
Subject: Re: Maintainers / Kernel Summit 2021 planning kick-off
To:     James Bottomley <James.Bottomley@hansenpartnership.com>
Cc:     Laurent Pinchart <laurent.pinchart@ideasonboard.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
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

On Fri, Jun 18, 2021 at 4:11 PM James Bottomley
<James.Bottomley@hansenpartnership.com> wrote:
> On Fri, 2021-06-18 at 16:46 +0300, Laurent Pinchart wrote:
> > For workshop or brainstorming types of sessions, the highest barrier
> > to participation for remote attendees is local attendees not speaking
> > in microphones. That's the number one rule that moderators would need
> > to enforce, I think all the rest depends on it. This may require a
> > larger number of microphones in the room than usual.
>
> Plumbers has been pretty good at that.  Even before remote
> participation, if people don't speak into the mic, it's not captured on
> the recording, so we've spent ages developing protocols for this.
> Mostly centred around having someone in the room to remind everyone to
> speak into the mic and easily throwable padded mic boxes.  Ironically,
> this is the detail that meant we couldn't hold Plumbers in person under
> the current hotel protocols ... the mic needs sanitizing after each
> throw.

What about letting people use the personal mic they're already
carrying, i.e. a phone?

Gr{oetje,eeting}s,

                        Geert

-- 
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
