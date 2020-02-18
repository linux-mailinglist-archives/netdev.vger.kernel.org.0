Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E8953161FCC
	for <lists+netdev@lfdr.de>; Tue, 18 Feb 2020 05:28:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726283AbgBRE2t (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 Feb 2020 23:28:49 -0500
Received: from mail-wm1-f54.google.com ([209.85.128.54]:53239 "EHLO
        mail-wm1-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726245AbgBRE2s (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 17 Feb 2020 23:28:48 -0500
Received: by mail-wm1-f54.google.com with SMTP id p9so1346134wmc.2
        for <netdev@vger.kernel.org>; Mon, 17 Feb 2020 20:28:47 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=BzPuU4g95aSBBFeFG+TjCwekfqveeuOJt5APejNXzoE=;
        b=Pb22be2ATGB3e8cOIGk75UEAqsB+RvxSpFMOhS4PKUO1N/6bdoy3eu1gGzYJWJ+yRY
         DJMUm0tcNZjTSMxxwFp9v9Q/gy8TkUT18DQFKJdK9Oqrph3PnnkbRG+9eWde2kdSwoQ6
         VyceGqx3lND7JYBiBjEWgzw2UDtokYOa5MMGDmfovT26HD63kTcr3H0UmkYmUvByOyQe
         tL+hgh1w4Q4C4feO0yNzkNqX+Q+Zu4CpocvurbndWON+pSlonEgAWworYSC4BBNJM3Ka
         ROXbkRO7vVh7sQNv37RFZiY3aVTOTNMS3SHSYwfj0inhAyJg3QhrA/thv6knOi3YJgsQ
         /R8g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=BzPuU4g95aSBBFeFG+TjCwekfqveeuOJt5APejNXzoE=;
        b=QGxgyUR9lWfz3J8lBJR0Nt5o2Wl0e58oXNBeRMyK1w1PFAP2MbyHWZYZx/eMzuPl+R
         xqlZ3Qyk7IVP7bZbvuG+AJOFxiM7jRFP7J3ExadrkRPjtvMVx/Rc4Fn7UyKA3szU3b5Y
         hOGlSo4omaVttjdKW2N/rIKgSK8qch7Mq1vG/Zcm5JOTRQMmxTsIRH3yJbvsjG9MDERo
         aDeskRXB4aHkmkUBJQ20sgt/XCvGgKSa7ytC/G/RMDdY17Z3Kt4sS1oZsvwefdMGUoW6
         NiXlVefDnbko3SZXZ3LnqiVSRq9fcl/JAoZxh1+hzR+Eg6uJYuItiwxt6lNxMErtN0iT
         jB5Q==
X-Gm-Message-State: APjAAAVO4Qny3QCiGLmHl3/hx4b7di8NwAwL7tVBjyy2b97z95cvLoX/
        pJVpdZnxeNJ41neLfcmkB0XHhMp7POxy7Cro3gw=
X-Google-Smtp-Source: APXvYqw/WrxEomPjeB6K62+thBB8Mk8IuWXee20YkvPelocFqAoh2U4U+MrKd6L2x75pR5xrcnEak6UYTHKQySGYiXc=
X-Received: by 2002:a1c:7d93:: with SMTP id y141mr392504wmc.111.1582000127169;
 Mon, 17 Feb 2020 20:28:47 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan> <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
 <20200214162104.04e0bb71@hermes.lan> <CADvbK_eSiGXuZqHAdQTJugLa7mNUkuQTDmcuVYMHO=1VB+Cs8w@mail.gmail.com>
 <793b8ff4-c04a-f962-f54f-3eae87a42963@gmail.com> <CADvbK_fOfEC0kG8wY_xbg_Yj4t=Y1oRKxo4h5CsYxN6Keo9YBQ@mail.gmail.com>
 <d0ec991a-77fc-84dd-b4cc-9ae649f7a0ac@gmail.com> <20200217130255.06644553@hermes.lan>
In-Reply-To: <20200217130255.06644553@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Tue, 18 Feb 2020 12:29:45 +0800
Message-ID: <CADvbK_c4=FesEqfjLxtCf712e3_1aLJYv9ebkomWYs+J=vcLpg@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     David Ahern <dsahern@gmail.com>,
        network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Feb 18, 2020 at 5:03 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Mon, 17 Feb 2020 12:53:14 -0700
> David Ahern <dsahern@gmail.com> wrote:
>
> > On 2/15/20 11:38 PM, Xin Long wrote:
> > > On Sun, Feb 16, 2020 at 12:51 AM David Ahern <dsahern@gmail.com> wrote:
> > >>
> > >> On 2/14/20 9:18 PM, Xin Long wrote:
> > >>> On Sat, Feb 15, 2020 at 8:21 AM Stephen Hemminger
> > >>> <stephen@networkplumber.org> wrote:
> > >>>>
> > >>>> On Sat, 15 Feb 2020 01:40:27 +0800
> > >>>> Xin Long <lucien.xin@gmail.com> wrote:
> > >>>>
> > >>>>> This's not gonna work. as the output will be:
> > >>>>> {"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
> > >>>>> instead of
> > >>>>> {"ver":2,"index":0,"dir":1,"hwid":2} (number)
> > >>>>
> > >>>> JSON is typeless. Lots of values are already printed in hex
> > >>> You may mean JSON data itself is typeless.
> > >>> But JSON objects are typed when parsing JSON data, which includes
> > >>> string, number, array, boolean. So it matters how to define the
> > >>> members' 'type' in JSON data.
> > >>>
> > >>> For example, in python's 'json' module:
> > >>>
> > >>> #!/usr/bin/python2
> > >>> import json
> > >>> json_data_1 = '{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}'
> > >>> json_data_2 = '{"ver":2,"index":0,"dir":1,"hwid":2}'
> > >>> parsed_json_1 = (json.loads(json_data_1))
> > >>> parsed_json_2 = (json.loads(json_data_2))
> > >>> print type(parsed_json_1["hwid"])
> > >>> print type(parsed_json_2["hwid"])
> > >>>
> > >>> The output is:
> > >>> <type 'unicode'>
> > >>> <type 'int'>
> > >>>
> > >>> Also, '{"result": true}' is different from '{"result": "true"}' when
> > >>> loading it in a 3rd-party lib.
> > >>>
> > >>> I think the JSON data coming from iproute2 is designed to be used by
> > >>> a 3rd-party lib to parse, not just to show to users. To keep these
> > >>> members' original type (numbers) is more appropriate, IMO.
> > >>>
> > >>
> > >> Stephen: why do you think all of the numbers should be in hex?
> > >>
> > >> It seems like consistency with existing output should matter more.
> > >> ip/link_gre.c for instance prints index as an int, version as an int,
> > >> direction as a string and only hwid in hex.
> > >>
> > >> Xin: any reason you did not follow the output of the existingg netdev
> > >> based solutions?
> > > Hi David,
> > >
> > > Option is expressed as "version:index:dir:hwid", I made all fields
> > > in this string of hex, just like "class:type:data" in:
> > >
> > > commit 0ed5269f9e41f495c8e9020c85f5e1644c1afc57
> > > Author: Simon Horman <simon.horman@netronome.com>
> > > Date:   Tue Jun 26 21:39:37 2018 -0700
> > >
> > >     net/sched: add tunnel option support to act_tunnel_key
> > >
> > > I'm not sure if it's good to mix multiple types in this string. wdyt?
> > >
> > > but for the JSON data, of course, these are all numbers(not string).
> > >
> >
> > I don't understand why Stephen is pushing for hex; it does not make
> > sense for version, index or direction. I don't have a clear
> > understanding of hwid to know uint vs hex, so your current JSON prints
> > seem fine.
> >
> > As for the stdout print and hex fields, staring at the tc and lwtunnel
> > code, it seems like those 2 have a lot of parallels in expressing
> > options for encoding vs lwtunnel and netdev based code. ie., I think
> > this latest set is correct.
> >
> > Stephen?
>
> I just wanted:
> 1. The parse and print functions should have the same formats.
> I.e. if you take the output and do a little massaging of the ifindex
> it should be accepted as an input set of parameters.
>
> 2. As much as possible, the JSON and non-JSON output should be similar.
> If non-JSON prints in hex, then JSON should display hex and vice/versa.
>
> Ideally all inputs would be human format (not machine formats like hex).
> But I guess the mistake was already made with some of the other tunnels.
I guess we can't 'fix' these in other tunnels in tc.

So I'm thinking we can either use the latest patchset,
or keep the geneve opts format in lwtunnel consistent
with the geneve opts in tc only and parse all with
unint in the new erspan/vxlan tunnels opts.
