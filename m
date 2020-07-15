Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2DF8222150B
	for <lists+netdev@lfdr.de>; Wed, 15 Jul 2020 21:23:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726971AbgGOTXy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jul 2020 15:23:54 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:27842 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726479AbgGOTXx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jul 2020 15:23:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1594841031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=HjxFHndoo5VUha/f0J2Qhspp+zsrHL4Q9bSPbhWoUxA=;
        b=L+UbWVFomwy2W1RP24pqaMapfxoIbmiuguLp1/IDr69x2rIzx2LR0iBGqfbaEMUqG3wYxF
        y6MEk9wlUvo3SnOery/uFZmtvpaxtn5H6q7mNV1f2miuyxT6sGLGRRWY50e/o0EnF0Z1iA
        mJ0f655lXmkFugPrtn6gSZA6RiVVBVQ=
Received: from mail-ot1-f70.google.com (mail-ot1-f70.google.com
 [209.85.210.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-92-pH5Q9KJhP1ir3ra_jwaTlg-1; Wed, 15 Jul 2020 15:23:50 -0400
X-MC-Unique: pH5Q9KJhP1ir3ra_jwaTlg-1
Received: by mail-ot1-f70.google.com with SMTP id a3so1475425otf.8
        for <netdev@vger.kernel.org>; Wed, 15 Jul 2020 12:23:49 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=HjxFHndoo5VUha/f0J2Qhspp+zsrHL4Q9bSPbhWoUxA=;
        b=jf5m3VntM5S+1/ICBQrwHA5ELfWFsDyZOEqZbu68stOnnplKf6hw38thTLoS0x5waq
         6gIo1g49mJgs5yko6lF0vB1jU2Dy9+OeTh+UtjjcjrKs15NuofwXtqO62UWXCZ4YUQDb
         Y00jcIv/x+grQO7l3cfo1RjFba70+7uqdiENYHo/nMOgZsGoKy3mxUlFq+O+0lzWqfDj
         KKY1NmVvkSbNrq6fK6Ih0rCZTW4iOFRLzpWrKaM/mdtVaH6szq0+ntTE/KeNJjKKW2Gj
         C19K/1IkD0AYdyt8jdHC3xWg53aDD1Twa/MofpjQFehzzl9v+VYqPUISENvGlYauE93f
         T6tg==
X-Gm-Message-State: AOAM531lsTHIDOhyOTG891VbA0q6WuuhAaLBYm33M5XPGkn1/6SbFZne
        28aqsOEv+9vljFiEazCs14HtNCQz42nsy40S1AuAft5/Fio56NM5Utt5RHYr5ly9RGTw2Gos1cB
        HQR8bBxmcgRjJnlwDxTKfPV7pKOePXQKQ
X-Received: by 2002:aca:d546:: with SMTP id m67mr1094945oig.5.1594841029227;
        Wed, 15 Jul 2020 12:23:49 -0700 (PDT)
X-Google-Smtp-Source: ABdhPJw18dWiSVhNR3I4QbvnvOWanQ+G1JUehL2ij8W2NtqgcG8+zZOnUsIpS69d1uSWugXhbvRGsrOGZksiWHjAQtA=
X-Received: by 2002:aca:d546:: with SMTP id m67mr1094931oig.5.1594841028959;
 Wed, 15 Jul 2020 12:23:48 -0700 (PDT)
MIME-Version: 1.0
References: <CAKfmpSdcvFG0UTNJFJgXwNRqQb-mk-PsrM5zQ_nXX=RqaaawgQ@mail.gmail.com>
 <20200713220016.xy4n7c5uu3xs6dyk@lion.mk-sys.cz> <20200713154118.3a1edd66@hermes.lan>
 <e515b840-c6f1-bc07-9369-c95e352573b2@solarflare.com>
In-Reply-To: <e515b840-c6f1-bc07-9369-c95e352573b2@solarflare.com>
From:   Jarod Wilson <jarod@redhat.com>
Date:   Wed, 15 Jul 2020 15:23:37 -0400
Message-ID: <CAKfmpSdS0Ckm4eA0hKECLNFvQo3nYU93N-oYO_wMeHoVGszA3g@mail.gmail.com>
Subject: Re: [RFC] bonding driver terminology change proposal
To:     Edward Cree <ecree@solarflare.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        Michal Kubecek <mkubecek@suse.cz>,
        Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 15, 2020 at 8:57 AM Edward Cree <ecree@solarflare.com> wrote:
>
> Once again, the opinions below are my own and definitely do not
>  represent anything my employer would be seen dead in the same
>  room as.
>
> On 13/07/2020 23:41, Stephen Hemminger wrote:
> > As far as userspace, maybe keep the old API's but provide deprecation n=
ags.
> Why would you need to deprecate the old APIs?
> If the user echoes 'slave' into some sysfs file (or whatever), that
>  indicates that they don't have any problem with using the word.
> So there's no reason toever remove that support =E2=80=94 its _mere
>  existence_ isn't problematic for anyone not actively seeking to be
>  offended.
> Which I think is more evidence that this change is not motivated by
>  practical concerns but by a kind of performative ritual purity.
>
> This is dumb.  I suspect you all, including Jarod, know that this
>  is dumb, but you're either going along with it or keeping your
>  head down in the hope that it will all blow over and you can go
>  back to normal.  Unfortunately, it doesn't work like that; the
>  activists who push this stuff are never satisfied; making
>  concessions to them results not in peace but in further demands;
>  and just as the corporations today are caving to the current
>  demands for fear of being singled out by the mob, so they will
>  cave again to the next round of demands, and you'll be back in
>  the same position, trying to deal with bosses wanting you to
>  break uAPI without even a technical reason.
> And next time around, the mob will be bolder and the bosses more
>  pliant, because by giving in this time we'll have signalled that
>  we're weak and easily dominated.  I would advise anyone still in
>  doubt of this point to read Kipling's poem "Dane-geld".
> And we'll all be left wondering why kernel development is so
>  soulless and joyless that no-one, of _any_ colour, aspires to
>  become a kernel hacker any more.
>
> It's not too late to stop the crazy, if we all just stop
>  pretending it's sane.

No, it isn't a practical code concern motivating this change, it's
actually quite impractical from a code standpoint and has no technical
merit. I understand your position, but having seen many emotional
responses to issues surrounding this, I think it's a worthwhile effort
that many people actually do appreciate. Even if I'm not personally
offended by the terminology, as a white male, I don't think I possess
the life experiences to downplay the negative impact ongoing use of
terms like "slave" might have on people that are actual descendants of
slavery. Embracing and helping move forward social change seems like a
responsible thing to do here, as long as we can do it without breaking
the kernel and UAPI.

--=20
Jarod Wilson
jarod@redhat.com

