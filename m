Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E28DF160243
	for <lists+netdev@lfdr.de>; Sun, 16 Feb 2020 07:47:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725951AbgBPGhf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 16 Feb 2020 01:37:35 -0500
Received: from mail-wm1-f50.google.com ([209.85.128.50]:36218 "EHLO
        mail-wm1-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725899AbgBPGhf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 16 Feb 2020 01:37:35 -0500
Received: by mail-wm1-f50.google.com with SMTP id p17so15076535wma.1
        for <netdev@vger.kernel.org>; Sat, 15 Feb 2020 22:37:33 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=QvitKfs6b0pUy04jEminDO1yX7gNMeGMAurdMlrM0NE=;
        b=ANWUhl9oToQGt89CCb/VQKfsf2qVbbzWMbF+u/TQxgyCtdaV+ASIAwo76k9dq8Sx0c
         LORizxARpVCOpz9JQIpbk/Ia0ra96x/AA4Fq63VJBYblXIRE9PHrbDnETR4AY9McTGa5
         QZZpI+4N7+1RMY/lJU53V+4hhDjke1Lh0SukLl7sqKswW5VDRjUB2NT0O/67yr1u615Q
         4/NkiSqO96WQFn/3nSjKjFWfO54CAoyGANu4Kh8isqf2avCv1iMu9aCn2ZTVhXSrRjdS
         5u23PvH/IHLSWzcJ3OXchEWTcm9VqfTCetA7hpc+zY/5f0VDwoZR0aytLMqB/4lGvl9R
         9QEw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=QvitKfs6b0pUy04jEminDO1yX7gNMeGMAurdMlrM0NE=;
        b=mcjSRPuq7gqlWY3DnDb78YqjTmXF0jGUtQm9aDA1nisbgoXCk8xz/fyJsn+dh/BQso
         wGn5uRqGJ7YFIS4G3U9Fk6n7uCo4JZdABIndzGzDu1uNs2uNvxDtUX6znuwUyqerSaHe
         F3yxewSbfJUhlcLMLR62Gz2ARAN4I83AgXFZ/m1gMzHLV0+yrOzKU+KiS93f3iQsQ5xL
         YFp6kuTpM/x9RhL56QOOSwguPOcn9VTdWERh5HQ41U7Y3Nlqs+egZtn/fEhp6M0jOjPl
         8tA1dU8BfCWI2gg0WnCqyv1Yl2FFPOIM69g3ziezjmDkdcYZPQOSt6lVL5yQtXMTOf7X
         yrfA==
X-Gm-Message-State: APjAAAXCvi40eu+hzuRZuTwX9G0+FooXIStxpzC9geNxeI/MzZ+Yl8T5
        mb8G8Ek+nnPo+AZDUzsJuZRx4I1mq4RAdAA1hNg=
X-Google-Smtp-Source: APXvYqwCqU2sWEpIZSdxThXHfhBCU0WYLpKeAnhfKrQs3oEbDB998HZEx05ryeQ9A1x0icwEP7//tv4yPvTEz0bY2O8=
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr14581711wmc.111.1581835052604;
 Sat, 15 Feb 2020 22:37:32 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan> <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
In-Reply-To: <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 16 Feb 2020 14:38:24 +0800
Message-ID: <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     David Ahern <dsahern@gmail.com>
Cc:     Stephen Hemminger <stephen@networkplumber.org>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 16, 2020 at 12:51 AM David Ahern <dsahern@gmail.com> wrote:
>
> On 2/14/20 9:18 PM, Xin Long wrote:
> > On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
> > <stephen@networkplumber.org> wrote:
> >>
> >> On Sat, 15 Feb 2020 01:40:27 +0800
> >> Xin Long <lucien.xin@gmail.com> wrote:
> >>
> >>> This's not gonna work. as the output will be:
> >>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> >>> instead of
> >>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
> >>
> >> JSON is typeless. Lots of values are already printed in hex
> > You may mean JSON data itself is typeless.
> > But JSON objects are typed when parsing JSON data, which includes
> > string, number, array, boolean. So it matters how to define the
> > members' 'type' in JSON data.
> >
> > For example, in python's 'json' module:
> >
> > #!/usr/bin/python2
> > import json
> > json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
> > json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
> > parsed_json_1 = (json.loads(json_data_1))
> > parsed_json_2 = (json.loads(json_data_2))
> > print type(parsed_json_1["hwid"])
> > print type(parsed_json_2["hwid"])
> >
> > The output is:
> > <type 'unicode'>
> > <type 'int'>
> >
> > Also, '{"result": true}' is different from '{"result": "true"}' when
> > loading it in a 3rd-party lib.
> >
> > I think the JSON data coming from iproute2 is designed to be used by
> > a 3rd-party lib to parse, not just to show to users. To keep these
> > members' original type (numbers) is more appropriate, IMO.
> >
>
> Stephen: why do you think all of the numbers should be in hex?
>
> It seems like consistency with existing output should matter more.
> ip/link_gre.c for instance prints index as an int, version as an int,
> direction as a string and only hwid in hex.
>
> Xin: any reason you did not follow the output of the existingg netdev
> based solutions?
Hi David,

Option is expressed as "version:index:dir:hwid", I made all fields
in this string of hex, just like "class:type:data" in:

commit 0ed5269f9e41f495c8e9020c85f5e1644c1afc57
Author: Simon Horman <simon.horman@netronome.com>
Date:   Tue Jun 26 21:39:37 2018 -0700

    net/sched: add tunnel option support to act_tunnel_key

I'm not sure if it's good to mix multiple types in this string. wdyt?

but for the JSON data, of course, these are all numbers(not string).

Thanks.
