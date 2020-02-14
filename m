Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 919DE15EE64
	for <lists+netdev@lfdr.de>; Fri, 14 Feb 2020 18:40:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729417AbgBNRjq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 14 Feb 2020 12:39:46 -0500
Received: from mail-wr1-f48.google.com ([209.85.221.48]:46365 "EHLO
        mail-wr1-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729298AbgBNRjo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 14 Feb 2020 12:39:44 -0500
Received: by mail-wr1-f48.google.com with SMTP id z7so11830733wrl.13
        for <netdev@vger.kernel.org>; Fri, 14 Feb 2020 09:39:42 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pYuOJLW01DzOuCLaDBQPnbbeoDpAXhJ8eRHOWxJepx8=;
        b=JP3Vg9cacoCrHrFk85nOqvzwEVxDp7vVzICFyuHBNg6gpRjWnDxoFmQWvvwe84w50B
         4UjBJZEXOiNZFvbmMWD105VKwNNci0hLy0yLclKxVrw3qHUznOTrVaQZGP2g8GBDDXkX
         HGGrS5ZOMowNVv2JjDqDHMy9T+ABbS3bQe7OwTW+K/dvcZYzjx/iotS9dKRC0p+5St2k
         6gZ2aZeSo+YGilNZ+hJN418BP1jlPJU8vGflC6q/FjeZw1bbM0zxxeznrivFqmWtcTEe
         FRChZ/aqz2h52msbgW4iCgdXfl3nPf7czsWw3hbiWX9f+WEQdC4tj5DjO33RXEnjwMdC
         RjJg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pYuOJLW01DzOuCLaDBQPnbbeoDpAXhJ8eRHOWxJepx8=;
        b=iz+jwzPkq+mqtN7rZQa8id0LSbeNuyd6qXDcQ7PigEtYAdn8107VnkvraRLJDKMW1i
         rqRRNRxAYOLekSKevyYqtNy1PXxX0fgYzXHQOnlXtYN8qqGZvhZ6ED7TJ0S31JuMvCzL
         GYy/6OBt8X6gLP5DeWwJeHBGNTEsbuKudhCanouYOBOv2LqGNddOFKMGejmKcxOr6Cuu
         NE9lO2uOwfEN4Oeipr+H5Zn+CaxwZLdihus8dzSoj43yfsEbLdAQzGpjSltlHUsud209
         60VGwbiFu62XSaj8+tWfT+tYw8M9vNv7hpVwoRUO/PZAYWEJ6IRBfFDBGwicl5hMKAvP
         fGHg==
X-Gm-Message-State: APjAAAWK+y0Vhxw1RyIiZyfjtw53aLPyuxJlRGtO7fzvVLH4KDLxRJfs
        ArPEm6v1JxXqjiKB9NqEjfGVqjOcT9uIOr45vtKipz0U
X-Google-Smtp-Source: APXvYqzD6D+4LImyanYPp8o7IHsMNenEEvRxMpNs4luLxus9ZkM/5l8z+TGWK1iDprQfXdxcXgBnMzQH1GHcjk5gwco=
X-Received: by 2002:a5d:4c88:: with SMTP id z8mr5086837wrs.395.1581701981660;
 Fri, 14 Feb 2020 09:39:41 -0800 (PST)
MIME-Version: 1.0
References: <cover.1581676056.git.lucien.xin@gmail.com> <44db73e423003e95740f831e1d16a4043bb75034.1581676056.git.lucien.xin@gmail.com>
 <77f68795aeb3faeaf76078be9311fded7f716ea5.1581676056.git.lucien.xin@gmail.com>
 <290ab5d2dc06b183159d293ab216962a3cc0df6d.1581676056.git.lucien.xin@gmail.com>
 <20200214081324.48dc2090@hermes.lan>
In-Reply-To: <20200214081324.48dc2090@hermes.lan>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sat, 15 Feb 2020 01:40:27 +0800
Message-ID: <CADvbK_dYwQ6LTuNPfGjdZPkFbrV2_vrX7OL7q3oR9830Mb8NcQ@mail.gmail.com>
Subject: Re: [PATCHv3 iproute2-next 3/7] iproute_lwtunnel: add options support
 for erspan metadata
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     network dev <netdev@vger.kernel.org>,
        Simon Horman <simon.horman@netronome.com>,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Feb 15, 2020 at 12:13 AM Stephen Hemminger
<stephen@networkplumber.org> wrote:
>
> On Fri, 14 Feb 2020 18:30:47 +0800
> Xin Long <lucien.xin@gmail.com> wrote:
>
> > +
> > +     open_json_array(PRINT_JSON, name);
> > +     open_json_object(NULL);
> > +     print_uint(PRINT_JSON, "ver", NULL, ver);
> > +     print_uint(PRINT_JSON, "index", NULL, idx);
> > +     print_uint(PRINT_JSON, "dir", NULL, dir);
> > +     print_uint(PRINT_JSON, "hwid", NULL, hwid);
> > +     close_json_object();
> > +     close_json_array(PRINT_JSON, name);
> > +
> > +     print_nl();
> > +     print_string(PRINT_FP, name, "\t%s ", name);
> > +     sprintf(strbuf, "%02x:%08x:%02x:%02x", ver, idx, dir, hwid);
> > +     print_string(PRINT_FP, NULL, "%s ", strbuf);
> > +}
>
> Instead of having two sets of prints, is it possible to do this
>         print_nl();
>         print_string(PRINT_FP, NULL, "\t", NULL);
>
>         open_json_array(PRINT_ANY, name);
>         open_json_object(NULL);
>         print_0xhex(PRINT_ANY, "ver", " %02x", ver);
>         print_0xhex(PRINT_ANY, "idx", ":%08x", idx);
>         print_0xhex(PRINT_ANY, "dir", ":%02x", dir);
>         print_0xhex(PRINT_ANY, "hwid", ":%02x", hwid)
>         close_json_object();
>         close_json_array(PRINT_ANY, " ");
Hi Stephen,

This's not gonna work. as the output will be:
{"ver":"0x2","idx":"0","dir":"0x1","hwid":"0x2"}  (string)
instead of
{"ver":2,"index":0,"dir":1,"hwid":2} (number)

>
> Also, you seem to not hear the request to not use opaque hex values
> in the iproute2 interface. The version, index, etc should be distinct
> parameter values not a hex string.
The opts STRING, especially these like "XX:YY:ZZ" are represented
as hex string on both adding and dumping. It is to keep consistent with
geneve_opts in m_tunnel_key and f_flower,  see

commit 6217917a382682d8e8a7ecdeb0c6626f701a0933
Author: Simon Horman <simon.horman@netronome.com>
Date:   Thu Jul 5 17:12:00 2018 -0700

    tc: m_tunnel_key: Add tunnel option support to act_tunnel_key

and
commit 56155d4df86d489c4207444c8a90ce4e0e22e49f
Author: Pieter Jansen van Vuuren <pieter.jansenvanvuuren@netronome.com>
Date:   Fri Sep 28 16:03:39 2018 +0200

    tc: f_flower: add geneve option match support to flower

and actually, the code type I'm using is exactly from these 2 patches.
please take a look.

I don't think this patchset should go to another type of format for opts.

Thanks.

>
> I think this still needs more work before merging.
