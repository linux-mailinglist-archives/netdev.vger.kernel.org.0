Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4292A69A07
	for <lists+netdev@lfdr.de>; Mon, 15 Jul 2019 19:39:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731844AbfGORhN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Jul 2019 13:37:13 -0400
Received: from mail-pg1-f195.google.com ([209.85.215.195]:36093 "EHLO
        mail-pg1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731648AbfGORhN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 15 Jul 2019 13:37:13 -0400
Received: by mail-pg1-f195.google.com with SMTP id l21so8052572pgm.3
        for <netdev@vger.kernel.org>; Mon, 15 Jul 2019 10:37:12 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=ByZ2FfyTdIJqDinve5Dt0bIyl2IVXNGYrVfp064xHiQ=;
        b=s6VYE21+Y1fej8QmcjCpVVex9YnRAp3bWa1z4OWMHhNVVik/KKZZwKjY/MVpuJTvsr
         mSX8GJF4ULAOJ2zehz5eicr2rk+9Ltg2JsMd98p33pQ8j3MoQdk8c8O5+QDThakSYc8X
         XP2iwfATX7Pq4Lr+Q12cw0ILyhoYe0Z3S00w3pVLloa6GgjZ/t4+FILUGEfEqeLhPTcV
         frbmXVw4fIy2EeruTxXsWwsGqIQWeeGMPINzZbcWlD3jwfvm6NnRs+MDZiAZPLdxUKWy
         HI7aSK6IcsIPLOfw4L2oGs3V1WAZBlpE3L36ISbWg/Axsrsi5SFWGI1l95sO3T+GBFWr
         XYrQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=ByZ2FfyTdIJqDinve5Dt0bIyl2IVXNGYrVfp064xHiQ=;
        b=riprnpZWHRU0Sm7+TGSkwfkUux/novoGCdApwmeg67+7Wrrtv1iPUzVYTdrJQyhOam
         +OJt+EATDlhcWmC7JEfpDICoVVkOSM2ktCO2ymHsWvk3xda6Daz0cmrXLz/EUyfxQ/r4
         0HJkP4HXsd98eD4mbRGf+ZblTGEsNmOLW/o4RmyXs5ZccamwlhThgtDfTxq3yfdzipWK
         dCeTZt1EuqdV/QX7SvAqDy+r2ihIsqfasKRcSxqccg0S+K+v/dxsaY/R8NJydJWwlsR8
         uIjXqZOMz6UifZGkwwvYs0sJXNHYdcQvrAVZe3fq8B8hK6E02zIhART7c1tcxl78GZcb
         F1CA==
X-Gm-Message-State: APjAAAU6M1IHknqNwyAyE/zQntviDBk39O2UPhAp4SgKVDgo2lapKw/L
        1cozooRuLRNoneGse9TZRaImcgjv
X-Google-Smtp-Source: APXvYqxjgA1KBlaijYTGgexK+pMGHyq6DLrq741C+s2kKunS0c9fXNINdn2in5+sfOnFFkEbpSayEA==
X-Received: by 2002:a63:4185:: with SMTP id o127mr27168365pga.82.1563212232197;
        Mon, 15 Jul 2019 10:37:12 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id r27sm21502495pgn.25.2019.07.15.10.37.11
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 15 Jul 2019 10:37:12 -0700 (PDT)
Date:   Mon, 15 Jul 2019 10:37:04 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Matteo Croce <mcroce@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>, David Ahern <dsahern@kernel.org>
Subject: Re: [PATCH iproute2] utils: don't match empty strings as prefixes
Message-ID: <20190715103704.73d4bbfa@hermes.lan>
In-Reply-To: <CAGnkfhyyJJR0frmO7Z+bviu6xYnJVitw-G0Nzgv9UQ2PYO1goA@mail.gmail.com>
References: <20190709204040.17746-1-mcroce@redhat.com>
        <20190709143758.695a65bc@hermes.lan>
        <CAGnkfhz+p1o_yHxk2jkY9ggNwLSO-Jk4BcxPuWhSHw1YXoJsSw@mail.gmail.com>
        <CAGnkfhyyJJR0frmO7Z+bviu6xYnJVitw-G0Nzgv9UQ2PYO1goA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Jul 2019 16:57:54 +0200
Matteo Croce <mcroce@redhat.com> wrote:

> On Wed, Jul 10, 2019 at 1:18 AM Matteo Croce <mcroce@redhat.com> wrote:
> >
> > On Tue, Jul 9, 2019 at 11:38 PM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:  
> > >
> > > On Tue,  9 Jul 2019 22:40:40 +0200
> > > Matteo Croce <mcroce@redhat.com> wrote:
> > >  
> > > > iproute has an utility function which checks if a string is a prefix for
> > > > another one, to allow use of abbreviated commands, e.g. 'addr' or 'a'
> > > > instead of 'address'.
> > > >
> > > > This routine unfortunately considers an empty string as prefix
> > > > of any pattern, leading to undefined behaviour when an empty
> > > > argument is passed to ip:
> > > >
> > > >     # ip ''
> > > >     1: lo: <LOOPBACK,UP,LOWER_UP> mtu 65536 qdisc noqueue state UNKNOWN group default qlen 1000
> > > >         link/loopback 00:00:00:00:00:00 brd 00:00:00:00:00:00
> > > >         inet 127.0.0.1/8 scope host lo
> > > >            valid_lft forever preferred_lft forever
> > > >         inet6 ::1/128 scope host
> > > >            valid_lft forever preferred_lft forever
> > > >
> > > >     # tc ''
> > > >     qdisc noqueue 0: dev lo root refcnt 2
> > > >
> > > >     # ip address add 192.0.2.0/24 '' 198.51.100.1 dev dummy0
> > > >     # ip addr show dev dummy0
> > > >     6: dummy0: <BROADCAST,NOARP> mtu 1500 qdisc noop state DOWN group default qlen 1000
> > > >         link/ether 02:9d:5e:e9:3f:c0 brd ff:ff:ff:ff:ff:ff
> > > >         inet 192.0.2.0/24 brd 198.51.100.1 scope global dummy0
> > > >            valid_lft forever preferred_lft forever
> > > >
> > > > Rewrite matches() so it takes care of an empty input, and doesn't
> > > > scan the input strings three times: the actual implementation
> > > > does 2 strlen and a memcpy to accomplish the same task.
> > > >
> > > > Signed-off-by: Matteo Croce <mcroce@redhat.com>
> > > > ---
> > > >  include/utils.h |  2 +-
> > > >  lib/utils.c     | 14 +++++++++-----
> > > >  2 files changed, 10 insertions(+), 6 deletions(-)
> > > >
> > > > diff --git a/include/utils.h b/include/utils.h
> > > > index 927fdc17..f4d12abb 100644
> > > > --- a/include/utils.h
> > > > +++ b/include/utils.h
> > > > @@ -198,7 +198,7 @@ int nodev(const char *dev);
> > > >  int check_ifname(const char *);
> > > >  int get_ifname(char *, const char *);
> > > >  const char *get_ifname_rta(int ifindex, const struct rtattr *rta);
> > > > -int matches(const char *arg, const char *pattern);
> > > > +int matches(const char *prefix, const char *string);
> > > >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits);
> > > >  int inet_addr_match_rta(const inet_prefix *m, const struct rtattr *rta);
> > > >
> > > > diff --git a/lib/utils.c b/lib/utils.c
> > > > index be0f11b0..73ce19bb 100644
> > > > --- a/lib/utils.c
> > > > +++ b/lib/utils.c
> > > > @@ -887,13 +887,17 @@ const char *get_ifname_rta(int ifindex, const struct rtattr *rta)
> > > >       return name;
> > > >  }
> > > >
> > > > -int matches(const char *cmd, const char *pattern)
> > > > +/* Check if 'prefix' is a non empty prefix of 'string' */
> > > > +int matches(const char *prefix, const char *string)
> > > >  {
> > > > -     int len = strlen(cmd);
> > > > +     if (!*prefix)
> > > > +             return 1;
> > > > +     while(*string && *prefix == *string) {
> > > > +             prefix++;
> > > > +             string++;
> > > > +     }
> > > >
> > > > -     if (len > strlen(pattern))
> > > > -             return -1;
> > > > -     return memcmp(pattern, cmd, len);
> > > > +     return *prefix;
> > > >  }
> > > >
> > > >  int inet_addr_match(const inet_prefix *a, const inet_prefix *b, int bits)  
> > >
> > > ERROR: space required before the open parenthesis '('
> > > #134: FILE: lib/utils.c:895:
> > > +       while(*string && *prefix == *string) {
> > >
> > > total: 1 errors, 1 warnings, 30 lines checked
> > >
> > > The empty prefix string is a bug and should not be allowed.
> > > Also return value should be same as old code (yours isn't).
> > >
> > >
> > >  
> >
> > The old return value was the difference between the first pair of
> > bytes, according to the memcmp manpage.
> > All calls only checks if the matches() return value is 0 or not 0:
> >
> > iproute2$ git grep 'matches(' |grep -v -e '== 0' -e '= 0' -e '!matches('
> > include/utils.h:int matches(const char *prefix, const char *string);
> > include/xtables.h:extern void xtables_register_matches(struct
> > xtables_match *, unsigned int);
> > lib/color.c:    if (matches(dup, "-color"))
> > lib/utils.c:int matches(const char *prefix, const char *string)
> > tc/tc.c:                if (matches(argv[0], iter->c))
> >
> > Is it a problem if it returns a non negative value for non matching strings?
> >
> > Regards,
> >
> >
> > --
> > Matteo Croce
> > per aspera ad upstream  
> 
> Hi Stephen,
> 
> should I send a v2 which keeps the old behaviour, even if noone checks
> for all the values?
> Just to clarify, the old behaviour of matches(cmd, pattern) was:
> 
> -1 if len(cmd) > len(pattern)
> 0 if pattern is equal to cmd
> 0 if pattern starts with cmd
> < 0 if pattern is alphabetically lower than cmd
> > 0 if pattern is alphabetically higher than cmd  
> 
> Regards,

Maybe time to make matches() into a boolean since that is how it is used.
