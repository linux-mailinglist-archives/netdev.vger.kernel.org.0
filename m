Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8FF9588B9D
	for <lists+netdev@lfdr.de>; Sat, 10 Aug 2019 15:50:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726147AbfHJNrK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 10 Aug 2019 09:47:10 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:42834 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726066AbfHJNrJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 10 Aug 2019 09:47:09 -0400
Received: by mail-ed1-f68.google.com with SMTP id m44so5234586edd.9
        for <netdev@vger.kernel.org>; Sat, 10 Aug 2019 06:47:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=tdkTXlm10t9E9By1HLAN9XJWvmiSg/50sSqDMaR/CeM=;
        b=JDt8br8RcAeRzxw8uiDkacgK+IeQj8rkW5xJvu4+ynKulHDrW8fYgqp95aIfW0gXf8
         /sEe+WG3OO5AhBEGgq/H9a3XVpo6VrwmLfDL3gtymn1FRyFjh3rf1qsGevVPQQ8507K9
         erGv70rxrfvFO1/OkuHWHvW8rV38pBYTX4JYY=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=tdkTXlm10t9E9By1HLAN9XJWvmiSg/50sSqDMaR/CeM=;
        b=YzYnt7dLiSDvNo7Br9JR2aA9O60osahKEpOT14HtmXn+WZRyeUXd42zeDj+YZcF2e4
         /qB/T6qZLI+CkoMz4kb29Fow+6G1VZhduuL9H5fweqwdyiwXaYxZI3TTsJ0cGJKgBSBC
         ML+a/GLcnep+Gh8j3cfSoYerDu3m3Vl5Yr7bfvI/lYjyLZitdoFZTN4hbcHycTOhS0Zr
         pFtH/RWiCLozlrKexBS57DynCOP9DgJBT569Ip6slblWwAESajJzpXxv06XBsvHtfK4F
         6IiyvysCH5MH7n/wHRC3H2e8H1jmgiGkWE38glrdPFnjN056pWffWXIoF+J7I57ErbZ5
         VRng==
X-Gm-Message-State: APjAAAXyKWDlLaNcvQU+h+0OIAj7vts0jojyU20b0++rhiTpuiJzsIFO
        ZoqjpwQ8DIZ+5MzhiRk6M1/oVq8hBR2Wr3hxU1+XFw==
X-Google-Smtp-Source: APXvYqz6M1uTB2fuZypVtt/HUHmcPbl6EMRylMcNoV3uhzTI6EZHy3mZDvBVCzT5cIIUZ4jzkGjAjg8UbRBdaq1AJ0g=
X-Received: by 2002:aa7:c559:: with SMTP id s25mr26979993edr.117.1565444828056;
 Sat, 10 Aug 2019 06:47:08 -0700 (PDT)
MIME-Version: 1.0
References: <20190719110029.29466-1-jiri@resnulli.us> <20190719110029.29466-4-jiri@resnulli.us>
 <CAJieiUi+gKKc94bKfC-N5LBc=FdzGGo_8+x2oTstihFaUpkKSA@mail.gmail.com>
 <20190809062558.GA2344@nanopsycho.orion> <CAJieiUj7nzHdRUjBpnfL5bKPszJL0b_hKjxpjM0RGd9ocF3EoA@mail.gmail.com>
 <20190809154609.GG31971@unicorn.suse.cz>
In-Reply-To: <20190809154609.GG31971@unicorn.suse.cz>
From:   Roopa Prabhu <roopa@cumulusnetworks.com>
Date:   Sat, 10 Aug 2019 06:46:57 -0700
Message-ID: <CAJieiUhcG6tpDA3evMtiyPSsKS9bfKPeD=dUO70oYOgGbFKy9Q@mail.gmail.com>
Subject: Re: [patch net-next rfc 3/7] net: rtnetlink: add commands to add and
 delete alternative ifnames
To:     Michal Kubecek <mkubecek@suse.cz>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Stephen Hemminger <sthemmin@microsoft.com>,
        David Ahern <dsahern@gmail.com>, dcbw@redhat.com,
        Andrew Lunn <andrew@lunn.ch>, parav@mellanox.com,
        Saeed Mahameed <saeedm@mellanox.com>,
        mlxsw <mlxsw@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Aug 9, 2019 at 8:46 AM Michal Kubecek <mkubecek@suse.cz> wrote:
>
> On Fri, Aug 09, 2019 at 08:40:25AM -0700, Roopa Prabhu wrote:
> > to that point, I am also not sure why we have a new API For multiple
> > names. I mean why support more than two names  (existing old name and
> > a new name to remove the length limitation) ?
>
> One use case is to allow "predictable names" from udev/systemd to work
> the way do for e.g. block devices, see
>
>   http://lkml.kernel.org/r/20190628162716.GF29149@unicorn.suse.cz
>

thanks for the link. don't know the details about alternate block
device names. Does user-space generate multiple and assign them to a
kernel object as proposed in this series ?. is there a limit to number
of names ?. my understanding of 'predictable names' was still a single
name but predictable structure to the name.

No strong objections around multiple alternate names as long as the
need for this does not make the base long name setting complex :).
