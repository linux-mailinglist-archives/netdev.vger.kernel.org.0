Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2E866330F06
	for <lists+netdev@lfdr.de>; Mon,  8 Mar 2021 14:20:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229922AbhCHNTs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Mar 2021 08:19:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230033AbhCHNTc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Mar 2021 08:19:32 -0500
Received: from mail-ej1-x631.google.com (mail-ej1-x631.google.com [IPv6:2a00:1450:4864:20::631])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DA933C06174A
        for <netdev@vger.kernel.org>; Mon,  8 Mar 2021 05:19:31 -0800 (PST)
Received: by mail-ej1-x631.google.com with SMTP id jt13so20391434ejb.0
        for <netdev@vger.kernel.org>; Mon, 08 Mar 2021 05:19:31 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pdA0cgW9V9HG1J6DdfseyUJUHT0oF9YgXq2/0mScIDA=;
        b=MHWFp5NVNh7uoMlrhEijKMr3lASC/nGAwPyk7RmiO51k4AUM0X3e19oyMES0cH+Bty
         e5ksqrqDBGuGA8aRy/P4Kn0F9cgyhtIRmPYT5gW5S9zO/v7gPNBkrkMdT6U4L23356KX
         TcjguLestNkjzP9IcJzmVWj5Xi8ogs0zv49K34tA4+OFJpRz3+Rlm8CPWBBlfK6UXvt8
         vOGtpWOkki4txsVlhPrEaSxOlbaPbSUdMfY8eFYvNf6zjxdRKO7OOmWmxeXDtUBeGnBe
         fju5gNRBi8ztBbaLrFkhrp2DMm68pEoqkC+hVFZukIYoMlEQAMpbmxeYtU6HLrmJSd4s
         RdLg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pdA0cgW9V9HG1J6DdfseyUJUHT0oF9YgXq2/0mScIDA=;
        b=eyNniUGJRK15faoy++zuAxygA4r0hboFk8wk8hnVORiqXkWzvprCdt8kdves2htWAT
         KKbjmn/JmzZeUiptS4QsuMCGqdhsgNfFj0HxN6Mu3attsW2nNsnU/iaZDX0NgN9OrGOl
         S+3SwafKBVxzhy4OpHJNLEpVOJuVBKUEsFyjckdgOvbsLbPwU6NYhF6LeyYDupBfynSv
         NudpQyhYieyqLMz44lt1S7Txt5tzbv1f9/hHRopn5ejpp912rsYGzE3nip5VWdP9sl8I
         dAkRxF267ncSRmXIwv8vENEdPxZMjFp0bj0aKGEuXuXz8V/XgMxvCDFS1qgKG3T+oLxn
         8azw==
X-Gm-Message-State: AOAM530RGr/z1CGQYXPRPVrzLmQmiS8R8TAlGH26QCisOy2KDCejd7wj
        UWwBsJ2Wqd2sIqDj40nhEhCsvIYUqUoBpVeujR4=
X-Google-Smtp-Source: ABdhPJxR5qsscYoTYdNjXKqcl2TZDUTH3J6vPGQGGYq3D8kqMtZ70eAPPG+2ueWy7+T86dvWa8zzi2KVa3Mbn6GAfvc=
X-Received: by 2002:a17:907:e8f:: with SMTP id ho15mr15406196ejc.541.1615209570623;
 Mon, 08 Mar 2021 05:19:30 -0800 (PST)
MIME-Version: 1.0
References: <CA+sq2CdJf0FFMAMbh0OZ67=j2Fo+C2aqP3qTKcYkcRgscfTGiw@mail.gmail.com>
 <20210305150702.1c652fe2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <YELKIZzkU9LxpEE9@lunn.ch> <CA+sq2CfAsyFHEj=w3=ewTKk-qbF60FcCQNtk9e7_1wxf=tB7QA@mail.gmail.com>
 <YEOSd09MDm6G2S3/@lunn.ch>
In-Reply-To: <YEOSd09MDm6G2S3/@lunn.ch>
From:   Sunil Kovvuri <sunil.kovvuri@gmail.com>
Date:   Mon, 8 Mar 2021 18:49:18 +0530
Message-ID: <CA+sq2Ce0W+-oYs+o_99LT3QzZbSROUsLeyaa7jJZtuUDmML+MQ@mail.gmail.com>
Subject: Re: Query on new ethtool RSS hashing options
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        George Cherian <gcherian@marvell.com>,
        Subbaraya Sundeep <sbhatta@marvell.com>,
        Sunil Goutham <sgoutham@marvell.com>,
        Vladimir Oltean <vladimir.oltean@nxp.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 6, 2021 at 8:02 PM Andrew Lunn <andrew@lunn.ch> wrote:
>
> On Sat, Mar 06, 2021 at 06:04:14PM +0530, Sunil Kovvuri wrote:
> > On Sat, Mar 6, 2021 at 5:47 AM Andrew Lunn <andrew@lunn.ch> wrote:
> > >
> > > On Fri, Mar 05, 2021 at 03:07:02PM -0800, Jakub Kicinski wrote:
> > > > On Fri, 5 Mar 2021 16:15:51 +0530 Sunil Kovvuri wrote:
> > > > > Hi,
> > > > >
> > > > > We have a requirement where in we want RSS hashing to be done on packet fields
> > > > > which are not currently supported by the ethtool.
> > > > >
> > > > > Current options:
> > > > > ehtool -n <dev> rx-flow-hash
> > > > > tcp4|udp4|ah4|esp4|sctp4|tcp6|udp6|ah6|esp6|sctp6 m|v|t|s|d|f|n|r
> > > > >
> > > > > Specifically our requirement is to calculate hash with DSA tag (which
> > > > > is inserted by switch) plus the TCP/UDP 4-tuple as input.
> > > >
> > > > Can you share the format of the DSA tag? Is there a driver for it
> > > > upstream? Do we need to represent it in union ethtool_flow_union?
> > >
> > > Sorry, i missed the original question, there was no hint in the
> > > subject line that DSA was involved.
> > >
> > > Why do you want to include DSA tag in the hash? What normally happens
> > > with DSA tag drivers is we detect the frame has been received from a
> > > switch, and modify where the core flow dissect code looks in the frame
> > > to skip over the DSA header and parse the IP header etc as normal.
> >
> > I understand your point.
> > The requirement to add DSA tag into RSS hashing is coming from one of
> > our customer.
>
> So what is the customer requirement? Why does the customer want to do
> this? Please explain the real use case.

Very sorry, after further discussions got to know from customer that
this is not needed.
They were observing some other issue and thought this would solve it.

Thanks,
Sunil.
