Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 622F6B2BB7
	for <lists+netdev@lfdr.de>; Sat, 14 Sep 2019 17:02:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725976AbfINOv2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Sep 2019 10:51:28 -0400
Received: from mail-yb1-f180.google.com ([209.85.219.180]:38347 "EHLO
        mail-yb1-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725879AbfINOv1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 14 Sep 2019 10:51:27 -0400
Received: by mail-yb1-f180.google.com with SMTP id o18so11075248ybp.5
        for <netdev@vger.kernel.org>; Sat, 14 Sep 2019 07:51:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=GkQ0ZCKUJ/5dE8pFE85jqw9Fe7ccUSIq1BW07FQhcYU=;
        b=jpBCc728gFvHs5EsGp5Q4beW2bLUDdaTdva+AzyOP9RIMVIdcNmG5FuPs3gLc/cWaQ
         yddKjA5T7NWSXnbQWg1dk+ZJzNtn/nMluKlxuA/QGjV4/uR82XtqGCCf91hynzuA103T
         eX5EhCnthVg6mVCcvUebyvjFRjLwtHJg492LZXWiUaSAiECZM15ouXbbQm6ew8NmitDq
         B4gG/wyhO4k36zfB+naGvlYFajc3aw1Ck+N92Xc2rwTrhcXrBcnJDzAh4HEMekgeIlT/
         0JeJW1a0Yr9u5mjmJfqsfOuW+0IqRWBdxG5tvYSiTP3Xd2EW9PwATMJvLNwfCl+Tw1h5
         5lrA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=GkQ0ZCKUJ/5dE8pFE85jqw9Fe7ccUSIq1BW07FQhcYU=;
        b=eF/GPWJcolCt2nZcx/sJ6jraU+h7fX/hrYULKaZRUb1EAyTBaufgPUQh9quMsQC6ID
         2SXooEAAUuAqoifMGN92v6cpoeCbjm0tDO/KgLnYAW5vysNT452ggnBfKFOlUX9aGXjb
         JLHj0RzsqiI/t6iE6nbmfJyJ6h2BdzbWnuZAKM8yvwax/iTS94G/2y+gkm0JzDMEM/D2
         v5V45Iznj0D9m/6ctOVr4eN3c7p5vMaE7nZJWy0HHbFF5+Df+K1xobhpojSHnHTUzEG1
         vaLs2mUcPaMC+Ld8Hubha3UwXO36UfiX3D8Ko0GQc9BrBTX20KXlUcMjOJXFRU7VPYiA
         NHKA==
X-Gm-Message-State: APjAAAUF/207GIcGJpRXFAgLLBu81LZjON6AWW1Lbce6fZiMju21Ohud
        wbZgagh0wICBwT4lDxYFf7b/gZ2kxNAANyBKKg==
X-Google-Smtp-Source: APXvYqzDwXEyzDtHlB3ATw2bLtTEW1Gdtq9jUP6XwyMiCZ74mh4CSklEdakY7No/Wzdq7FwjCmps/RkKqguLfGboIVk=
X-Received: by 2002:a25:a084:: with SMTP id y4mr4200438ybh.180.1568472685283;
 Sat, 14 Sep 2019 07:51:25 -0700 (PDT)
MIME-Version: 1.0
References: <20190911184807.21770-1-danieltimlee@gmail.com>
 <20190911184807.21770-3-danieltimlee@gmail.com> <20190913143144.2b8c18ed@carbon>
 <87ef0ks76q.fsf@toke.dk>
In-Reply-To: <87ef0ks76q.fsf@toke.dk>
From:   "Daniel T. Lee" <danieltimlee@gmail.com>
Date:   Sat, 14 Sep 2019 23:51:09 +0900
Message-ID: <CAEKGpzjv1HG3ysFEfMbmwy5HuGbFSX4YA_HCvz-oXH+NfHkq-A@mail.gmail.com>
Subject: Re: [v2 3/3] samples: pktgen: allow to specify destination IP range (CIDR)
To:     =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>
Cc:     Jesper Dangaard Brouer <brouer@redhat.com>,
        "David S . Miller" <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Sep 13, 2019 at 9:37 PM Toke H=C3=B8iland-J=C3=B8rgensen <toke@redh=
at.com> wrote:
>
> Jesper Dangaard Brouer <brouer@redhat.com> writes:
>
> > On Thu, 12 Sep 2019 03:48:07 +0900
> > "Daniel T. Lee" <danieltimlee@gmail.com> wrote:
> >
> >> diff --git a/samples/pktgen/pktgen_sample01_simple.sh b/samples/pktgen=
/pktgen_sample01_simple.sh
> >> index 063ec0998906..08995fa70025 100755
> >> --- a/samples/pktgen/pktgen_sample01_simple.sh
> >> +++ b/samples/pktgen/pktgen_sample01_simple.sh
> >> @@ -22,6 +22,7 @@ fi
> >>  # Example enforce param "-m" for dst_mac
> >>  [ -z "$DST_MAC" ] && usage && err 2 "Must specify -m dst_mac"
> >>  [ -z "$COUNT" ]   && COUNT=3D"100000" # Zero means indefinitely
> >> +[ -n "$DEST_IP" ] && read -r DST_MIN DST_MAX <<< $(parse_addr${IP6} $=
DEST_IP)
> >
> > The way the function "parse_addr" is called, in case of errors the
> > 'err()' function is called inside, but it will not stop the program
> > flow.  Instead that function will "only" echo the "ERROR", but program
> > flow continues (even-thought 'err()' uses exit $exitcode).
> >
> > Maybe it is not solveable to get the exit/$?/status out? (I've tried
> > different options, but didn't find a way).
>
> `set -o errexit`? :)
>

I've just tested and Toke's solution works great!

It stops when the function gets error.

I'll update it to the next version.
Thanks for the review!

> -Toke
