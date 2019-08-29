Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 670E5A107C
	for <lists+netdev@lfdr.de>; Thu, 29 Aug 2019 06:36:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725847AbfH2Egz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 29 Aug 2019 00:36:55 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:44059 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725776AbfH2Egz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 29 Aug 2019 00:36:55 -0400
Received: by mail-ed1-f67.google.com with SMTP id a21so2454598edt.11
        for <netdev@vger.kernel.org>; Wed, 28 Aug 2019 21:36:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=nltdpsPgKqXzZYmw6gGHhYlO21jQhRjP2llA8Qq+77M=;
        b=XeBv0pCgwVYTwqLp8xXeVM8sG21mOug7wv8vWOk1Pny/Vv444WWqna3jqeOalF6f9G
         NSl0UVWOx9kINr715H1I9k+2i8uryngrUtX+IfESWGbSjKeryDYWrPbZIWATInJ0nGfn
         tyjBALOSEDyIyOuyGiSghKW2LlHj52fo7/LZc=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=nltdpsPgKqXzZYmw6gGHhYlO21jQhRjP2llA8Qq+77M=;
        b=ucmX4ODz5LfFCRnrj7jBV0hiavvkNWh8Xwe9tuD/2dvAfAKwzPIU5ZwFQW6EHUNmec
         HWXseZLqC5WTZ3dZ9G3tL4fLnSlvAx4RYk2rCGn8E3E827DFNdO36+aeCEO7fA4uvlAk
         5QGwauocGYGLZRVRiGsct1M6KBwRYt7exTC/BDssar3C1Tv3cl24x2ljFyQXOshdC3c+
         AR/+m0vrobQEOh3jdYBqZkjjD3nYO+PN/xTZjPqpX/aXzEI3jBKt8Tr02I9fKZQoxC+C
         1dKspt06R71KE/VbMdMofVzaOWv10RksjP9aHmn0vQ7yzl28hD5CGKF8F8ZUuxJcV6hU
         N/EQ==
X-Gm-Message-State: APjAAAUXn/NxdmM5GKFsqKdd6ntdtO8xGMyESwil7TJP9DsT86YUBTE0
        YU8dm/mdwdHvAi8eEjbYZGcoWgFw4dyOoE4mebW5fg==
X-Google-Smtp-Source: APXvYqw/D6AX7BCYTZK8Krg1dFpkH8xMYkzZUOng2kQQan1Ee/7/ElnbKTzdsJ3EGPItbdNo9SWTJA5n0L/e0HQFIE8=
X-Received: by 2002:a50:f7c6:: with SMTP id i6mr7559930edn.281.1567053412937;
 Wed, 28 Aug 2019 21:36:52 -0700 (PDT)
MIME-Version: 1.0
References: <20190826151552.4f1a2ad9@cakuba.netronome.com> <20190826.151819.804077961408964282.davem@davemloft.net>
 <20190827070808.GA2250@nanopsycho> <20190827.012242.418276717667374306.davem@davemloft.net>
 <20190827093525.GB2250@nanopsycho> <CAJieiUjpE+o-=x2hQcsKQJNxB8O7VLHYw2tSnqzTFRuy_vtOxw@mail.gmail.com>
 <20190828070711.GE2312@nanopsycho>
In-Reply-To: <20190828070711.GE2312@nanopsycho>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Wed, 28 Aug 2019 21:36:41 -0700
Message-ID: <CAJieiUiipZY3A+04Po=WnvgkonfXZxFX2es=1Q5dq1Km869Obw@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Ahern <dsahern@gmail.com>,
        netdev <netdev@vger.kernel.org>,
        Stephen Hemminger <sthemmin@microsoft.com>, dcbw@redhat.com,
        Michal Kubecek <mkubecek@suse.cz>,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 28, 2019 at 12:07 AM Jiri Pirko <jiri@resnulli.us> wrote:
>
> Tue, Aug 27, 2019 at 05:14:49PM CEST, roopa@cumulusnetworks.com wrote:
> >On Tue, Aug 27, 2019 at 2:35 AM Jiri Pirko <jiri@resnulli.us> wrote:
> >>
> >> Tue, Aug 27, 2019 at 10:22:42AM CEST, davem@davemloft.net wrote:
> >> >From: Jiri Pirko <jiri@resnulli.us>
> >> >Date: Tue, 27 Aug 2019 09:08:08 +0200
> >> >
> >> >> Okay, so if I understand correctly, on top of separate commands for
> >> >> add/del of alternative names, you suggest also get/dump to be separate
> >> >> command and don't fill this up in existing newling/getlink command.
> >> >
> >> >I'm not sure what to do yet.
> >> >
> >> >David has a point, because the only way these ifnames are useful is
> >> >as ways to specify and choose net devices.  So based upon that I'm
> >> >slightly learning towards not using separate commands.
> >>
> >> Well yeah, one can use it to handle existing commands instead of
> >> IFLA_NAME.
> >>
> >> But why does it rule out separate commands? I think it is cleaner than
> >> to put everything in poor setlink messages :/ The fact that we would
> >> need to add "OP" to the setlink message just feels of. Other similar
> >> needs may show up in the future and we may endup in ridiculous messages
> >> like:
> >>
> >> SETLINK
> >>   IFLA_NAME eth0
> >>   IFLA_ATLNAME_LIST (nest)
> >>       IFLA_ALTNAME_OP add
> >>       IFLA_ALTNAME somereallylongname
> >>       IFLA_ALTNAME_OP del
> >>       IFLA_ALTNAME somereallyreallylongname
> >>       IFLA_ALTNAME_OP add
> >>       IFLA_ALTNAME someotherreallylongname
> >>   IFLA_SOMETHING_ELSE_LIST (nest)
> >>       IFLA_SOMETHING_ELSE_OP add
> >>       ...
> >>       IFLA_SOMETHING_ELSE_OP del
> >>       ...
> >>       IFLA_SOMETHING_ELSE_OP add
> >>       ...
> >>
> >> I don't know what to think about it. Rollbacks are going to be pure hell :/
> >
> >I don't see a huge problem with the above. We need a way to solve this
> >anyways for other list types in the future correct ?.
> >The approach taken by this series will not scale if we have to add a
> >new msg type and header for every such list attribute in the future.
>
> Do you have some other examples in mind? So far, this was not needed.

yes, so far it was not needed.
No other future possible examples in mind...but I wont be surprised if
we see such cases in the future.
Having a consistent API to extend a list attribute will help.

>
>
> >
> >A good parallel here is bridge vlan which uses RTM_SETLINK and
> >RTM_DELLINK for vlan add and deletes. But it does have an advantage of
> >a separate
> >msg space under AF_BRIDGE which makes it cleaner. Maybe something
> >closer to that  can be made to work (possibly with a msg flag) ?.
>
> 1) Not sure if AF_BRIDGE is the right example how to do things
> 2) See br_vlan_info(). It is not an OP-PER-VLAN. You either add or
> delete all passed info, depending on the cmd (RTM_SETLINK/RTM_DETLINK).

yes,  correct. I mentioned that because I was wondering if we can
think along the same lines for this API.
eg
(a) RTM_NEWLINK always replaces the list attribute
(b) RTM_SETLINK with NLM_F_APPEND always appends to the list attribute
(c) RTM_DELLINK with NLM_F_APPEND updates the list attribute

(It could be NLM_F_UPDATE if NLM_F_APPEND sounds weird in the del
case. I have not looked at the full dellink path if it will work
neatly..its been a busy day )


>
>
> >
> >Would be good to have a consistent way to update list attributes for
> >future needs too.
>
> Okay. Do you suggest to have new set of commands to handle
> adding/deleting lists of items? altNames now, others (other nests) later?
>
> Something like:
>
> CMD SETLISTS
>      IFLA_NAME eth0
>      IFLA_ATLNAME_LIST (nest)
>        IFLA_ALTNAME somereallylongname
>        IFLA_ALTNAME somereallyreallylongname
>        IFLA_ALTNAME someotherreallylongname
>      IFLA_SOMETHING_ELSE_LIST (nest)
>        IFLA_SOMETHING_ELSE
>        IFLA_SOMETHING_ELSE
>        IFLA_SOMETHING_ELSE
>
>
> CMD DELLISTS
>      IFLA_NAME eth0
>      IFLA_ATLNAME_LIST (nest)
>        IFLA_ALTNAME somereallylongname
>        IFLA_ALTNAME somereallyreallylongname
>        IFLA_ALTNAME someotherreallylongname
>      IFLA_SOMETHING_ELSE_LIST (nest)
>        IFLA_SOMETHING_ELSE
>        IFLA_SOMETHING_ELSE
>        IFLA_SOMETHING_ELSE
>
> How does this sound?

This seems fine but it does introduce a new type. If we can avoid a
new msg type with a flag that would be nice (like the NLM_F_APPEND eg
above).
The reason for that is to see if we can use it else where too (eg some
random future list attribute in the route subsystem. If a flag works
then we don't have to add a RTM_NEWROUTE variant of CMD SETLISTS and
CMD DELLISTS)
