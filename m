Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CED3218119F
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 08:18:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728344AbgCKHS1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 03:18:27 -0400
Received: from mail-wm1-f68.google.com ([209.85.128.68]:38021 "EHLO
        mail-wm1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726160AbgCKHS1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 03:18:27 -0400
Received: by mail-wm1-f68.google.com with SMTP id n2so870742wmc.3
        for <netdev@vger.kernel.org>; Wed, 11 Mar 2020 00:18:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=xvzWOjicBqIaD1afInp0MPKCetHO39DW/VdD7WLNWnE=;
        b=fUqj3in7WFCifzOXiUvII/sCQ12fCExCyNpwy3W5BufTffg5au8gvjZzqf4hb5n/Ki
         lVRMcNGpPYKW7ioS7emWztbTwNPRNuwZrPYVbU38jpqj8aEMrIIp6gbLutmLL+fyqCen
         aPNZXDI0fqrTONcOeD8LW2Px0FpxjEIPpoC/d8E39KEoI/wNOqILjSY6RzzRiHgnMEiL
         PvU1ZySVIIMO//hARwpotRlvsPtonvqrOnq1HCDCi1LqEbF6j1Um0AXNzVDKIUfNera7
         gWGeY0tmUoncTVs8KH/h1RPBD7EUSPJd3rvJi1FsZQj4lY+8pSeZCnMzrPDRSBQf/pjJ
         vlEg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=xvzWOjicBqIaD1afInp0MPKCetHO39DW/VdD7WLNWnE=;
        b=qT8cGQOlV4zXK1li00LV3/osfNo20I5PKQ057DBKL3CxLc72Z7nv7moGBP45cAUGR+
         S4QaxRphsr4pZWDJeewEs+39Sdm3EX4Iy1bi99yySI365eMxTA6mKFOedjc7PbQhvzhk
         zYxoYmSniMhx5/WupngRiyqKRsAjlAO+usdh18mBjkROyyGcOZhG1rpRDwxoown3Bwyc
         CtlB124EqthJuxPPUd4Torn95kn5YQL5tNRQgzBSL1BXKoeeaYxv17mAlK6iuGxSIS+i
         isU5zKXR89FqRyjrIpHrC3KYzca7UzjO0GWNA3q8TVPDNHuaG1EJHGtbs7LjgWwbOiWK
         14Cw==
X-Gm-Message-State: ANhLgQ2kVQh2bAaaB2wEuvp668ueuEuvajDs8172bih9we1HFv2W1GNG
        OyuY5iKBIYZ6WBUVu7lpFg6p+ultX9p9u4wM9aY=
X-Google-Smtp-Source: ADFU+vvsF7jZn4BL+8Mlok/idWLt/sS1sJBRBYOE0empQDThcKVxSxJrtMT/KJ7JVy+XbTyy+DLwzkkVmsQE1GYmrQc=
X-Received: by 2002:a1c:2d88:: with SMTP id t130mr2323257wmt.68.1583911104247;
 Wed, 11 Mar 2020 00:18:24 -0700 (PDT)
MIME-Version: 1.0
References: <1583866045-7129-1-git-send-email-sunil.kovvuri@gmail.com>
 <1583866045-7129-5-git-send-email-sunil.kovvuri@gmail.com>
 <20200310192111.GC11247@lunn.ch> <CA+sq2CeTFZdH60MS1fPhfTJjSJFCn2wY6iPH+VvuLSHzkApB-w@mail.gmail.com>
 <20200311070549.GG4215@unreal>
In-Reply-To: <20200311070549.GG4215@unreal>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Wed, 11 Mar 2020 12:48:13 +0530
Message-ID: <CA+sq2Cdec8orZVbZhH3VVHkkM48yF7-62u4cWas6gtaMgpSbzA@mail.gmail.com>
Subject: Re: [PATCH net-next 4/6] octeontx2-vf: Ethtool support
To:     Leon Romanovsky <leon@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Tomasz Duszynski <tduszynski@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 11, 2020 at 12:35 PM Leon Romanovsky <leon@kernel.org> wrote:
>
> On Wed, Mar 11, 2020 at 12:09:45PM +0530, Sunil Kovvuri wrote:
> > On Wed, Mar 11, 2020 at 12:51 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Wed, Mar 11, 2020 at 12:17:23AM +0530, sunil.kovvuri@gmail.com wrote:
> > > > +int __weak otx2vf_open(struct net_device *netdev)
> > > > +{
> > > > +     return 0;
> > > > +}
> > > > +
> > > > +int __weak otx2vf_stop(struct net_device *netdev)
> > > > +{
> > > > +     return 0;
> > > > +}
> > >
> > > Hi Sunil
> > >
> > > weak symbols are very unusual in a driver. Why are they required?
> > >
> > > Thanks
> > >         Andrew
> >
> > For ethtool configs which need interface reinitialization of interface
> > we need to either call PF or VF open/close fn()s.
> > If VF driver is not compiled in, then PF driver compilation will fail
> > without these weak symbols.
> > They are there just for compilation purpose, no other use.
>
> It doesn't make sense, your PF driver should be changed to allow
> compilation with those empty functions.
>
> Thanks
>

I didn't get, if VF driver is not compiled in then there are no
otx2vf_open/stop fn()s defined.
Either i have add weak fn()s or add empty ones based on VF CONFIG
option, anyother option ?

Thanks,
Sunil.
