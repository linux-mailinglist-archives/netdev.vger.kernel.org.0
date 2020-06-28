Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B696620C7E1
	for <lists+netdev@lfdr.de>; Sun, 28 Jun 2020 14:28:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726525AbgF1M2A (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 28 Jun 2020 08:28:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41198 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgF1M2A (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 28 Jun 2020 08:28:00 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C9651C061794
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 05:27:59 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id g11so6496816qvs.2
        for <netdev@vger.kernel.org>; Sun, 28 Jun 2020 05:27:59 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=3Giw6OaH9xvYq2Fif3CFr7lJSII/fi4Af83UC8olEnc=;
        b=oJ64b15yeT+vjRFqsmr1DhgIrnhulqSCeNa2+PYBDppY1Ig0htBAzx1Yp+phgD29Lh
         OjY0NTUy7x3UyonaqdNvPyQSuF5PgLk6W+QXw5EY9+G83RV0PSFJ1sHGppZKIDd57Qqe
         gMkIoyNVlU84qLnVh50hBer5lqa8n3KLtzjeAeUrkPWRvvsk17HUb1D9uuccTEDQRBNn
         awa0CZThXBLSzTJkfzCpwJ24wcUONQSPIpaajRl1vINQJWkGNl+kqxrB0NRTIGeB2Yn7
         vRW9h7tS3tL6VuL0WHqqQ6VEQVlWsJipYTkG7QX1PKsOhRWUrHv/v8w5ReKsa4PqWpjC
         zXYw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=3Giw6OaH9xvYq2Fif3CFr7lJSII/fi4Af83UC8olEnc=;
        b=DVHxNhgSKgmQSFX1RlNtQUyoHw2dMwzd5TsjU5r6+WC98rwEGSAbTXusDf4pBj8sc0
         ScF5kHu7HBmehglFrhLRzGTT+fWZ9g8bP+1NdHT53yLtclm692a6lurjoLThitYXWt6Y
         ANxsvgR9yurBAskZhWywwiJ2KItNHA2PYAmjgFaON87GoEcO0UZJmklp80yJenbseAgh
         3NpOex78HzwXzL1Zlz6U3vte7voJ9jfHLYbypyv9jJ+u0Cvz9SEYtR/gJRjcXhbZTGt8
         DRaKiJhHw7oz9/MQXU6MeJ9oxytkSVeYcO0cVLwVTJQGQz1GCN6f/Q3FwaQ9voBbmGE9
         w+ZA==
X-Gm-Message-State: AOAM531iIBotkJ9hErnslsrvRlu2eFjpHpFpnoJHdAgHE2XEE2ANrDGt
        r/jVG++a18toQsmULTdwI61jwcO8m8aXaUtYg0fFVO4CyCXmzA==
X-Google-Smtp-Source: ABdhPJyo1jehU32MTdXNcL4XnTIDDcq8yqWT/hz6V9G2G13wkw11qWiOmT/aYp8J/0yvd4t9mPKgAxAok2uqUhC2f6w=
X-Received: by 2002:a0c:b4af:: with SMTP id c47mr10738576qve.233.1593347278927;
 Sun, 28 Jun 2020 05:27:58 -0700 (PDT)
MIME-Version: 1.0
References: <20200626144724.224372-1-idosch@idosch.org> <20200626144724.224372-2-idosch@idosch.org>
 <20200626151926.GE535869@lunn.ch> <CAL_jBfT93picGGoCNWQDY21pWmo3jffanhBzqVwm1kVbyEb4ow@mail.gmail.com>
 <20200626190716.GG535869@lunn.ch> <CAL_jBfQMQbMAFeHji2_Y_Y_gC20S_0QL33wjPgPBaKeVRLg1SQ@mail.gmail.com>
 <20200627191648.GA245256@shredder> <CAL_jBfTKW_T-Pf2_shLm7N-ve_eg3G=nTD+6Fc3ZN4aHncm9YQ@mail.gmail.com>
 <20200628115557.GA273881@shredder>
In-Reply-To: <20200628115557.GA273881@shredder>
From:   Adrian Pop <popadrian1996@gmail.com>
Date:   Sun, 28 Jun 2020 13:27:21 +0100
Message-ID: <CAL_jBfSNsveJSgtZ+5wPEOM+wQZPbTysj20jgttkgSf+E-0Pbg@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] mlxsw: core: Add ethtool support for QSFP-DD transceivers
To:     Ido Schimmel <idosch@idosch.org>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org, jiri@mellanox.com,
        vadimp@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

Regarding multiple banks, I think that we can have a much more
creative way of dealing with them (in the future). At page 76, we have
"In particular, support of the Lower Memory and of Page 00h is
required for all modules, including passive copper cables. These pages
are therefore always implemented. Additional support for Pages 01h,
02h and bank 0 of Pages 10h and 11h is required for all paged memory
modules."

My old patch clearly supports only the 1st (and mandatory) bank. So
the memory layout is 00h, 01h, 02h, 10h, 11h. If we will extend
ethtool to work for multiple banks, we might have something like 00h,
01h, 02h, (10h, 11h | bank 0), (10h, 11h | bank 1) etc. So we can
still check bits 1-0 of byte 142 from page 01h to determine how many
banks we have and we can still follow the "we can trim, but only to
the right" rule. Of course, this is only an idea, at the moment I
don't think we can even test something like that.

I'm sure that I can work something out to deal with sometimes having
page 03h and sometimes not, but first I think we need to decide if we
always add it or not. As I mentioned in my previous email, I think
Andrew can argue for its presence better than me. Based on that, I can
re-submit my old patch for ethtool.

Adrian

On Sun, 28 Jun 2020 at 12:56, Ido Schimmel <idosch@idosch.org> wrote:
>
> On Sat, Jun 27, 2020 at 09:42:10PM +0100, Adrian Pop wrote:
> > >
> > > Hi Adrian, Andrew,
> > >
> > > Not sure I understand... You want the kernel to always pass page 03h to
> > > user space (potentially zeroed)? Page 03h is not mandatory according to
> > > the standard and page 01h contains information if page 03h is present or
> >
> > Hi Ido!
> >
> > Andrew was thinking of having 03h after 02h (potentially zeroed) just
> > for the purpose of having a similar layout for QSFP-DD the same way we
> > do for QSFP. But as you said, it is not mandatory according to the
> > standard and I also don't know the entire codebase for ethtool and
> > where it might be actually needed. I think Andrew can argue for its
> > presence better than me.
> >
> > > not. So user space has the information it needs to determine if after
> > > page 02h we have page 03h or page 10h. Why always pass page 03h then?
> > >
> >
> > If we decide to add 03h but only sometimes, I think we will add an
> > extra layer of complexity. Sometimes after 02h we would have 03h and
> > sometimes 10h. In qsfp-dd.h (following the convention from qsfp.h) in
> > my patch there are a lot of different constants defined with respect
> > to the offset of the parent page in the memory layout and "dynamic
> > offsets" don't sound very good, at least for me. So even if there's a
> > way of checking in the user space which page is after 02h, a more
> > stable memory layout works better on the long run.
>
> Adrian,
>
> Thanks for the detailed response. I don't think the kernel should pass
> fake pages only to make it easier for user space to parse the
> information. What you are describing is basic dissection and it's done
> all the time by wireshark / tcpdump.
>
> Anyway, even we pass a fake page 03h, page 11h can still be at a
> variable offset. See table 8-28 [1], bits 1-0 at offset 142 in page 01h
> determine the size of pages 10h and 11h:
>
> 0 - each page is 128 bytes in size
> 1 - each page is 256 bytes in size
> 2 - each page is 512 bytes in size
>
> So a completely stable layout (unless I missed something) will entail
> the kernel sending 1664 bytes to user space each time. This looks
> unnecessarily rigid to me. The people who wrote the standard obviously
> took into account the fact that the page layout needs to be discoverable
> from the data and I think we should embrace it and only pass valid
> information to user space.
>
> Regardless, can Andrew and you let us know if you have a problems with
> current patch set which only exposes pages 00h-02h? I see it's marked as
> "Changes Requested", so I will need to re-submit.
>
> Thanks
>
> [1] http://www.qsfp-dd.com/wp-content/uploads/2019/05/QSFP-DD-CMIS-rev4p0.pdf
