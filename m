Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 362C04F0D8
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 00:45:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726067AbfFUWpY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jun 2019 18:45:24 -0400
Received: from mail-pf1-f193.google.com ([209.85.210.193]:35828 "EHLO
        mail-pf1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726043AbfFUWpY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jun 2019 18:45:24 -0400
Received: by mail-pf1-f193.google.com with SMTP id d126so4305009pfd.2;
        Fri, 21 Jun 2019 15:45:23 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=iuGdW6sX88KLfCjHMKLY49KKsvlSOj2HqpD/7s+bllQ=;
        b=MH9gcHjajms6Gyn8wPcgrt/a4VokIAMBa5DfZ7wmVaXrWS/K80A5xDhsRJaugR6yAC
         3/4s1DsWC5EXpOiTmrBMTw1Nno7unbWJViyyF2bnpsT/D6upVJGSUFsjutys4jBAJe9x
         QdW7ahsojf9L00i+2R94ukyA2XZykcmPZ0ZMwv1ZyVTrlzA8s6FLijRfOfsokkZEE2Fm
         EoyuCRiaDgIeHd9NbKSkLwdVUYRSdxgs0yAIOXUfTjhgN2fIuP7sRbLHeiF/FWca3Jnt
         RZmMWdGPoWdKLC+OvebpVyBsSKrvL9j1ANXxCUNHOIrV/Sx3IgPgFerGVYy0XfFwmuH2
         gTHA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=iuGdW6sX88KLfCjHMKLY49KKsvlSOj2HqpD/7s+bllQ=;
        b=HcvP/07PoW/iV4YemsZ0v9h1CFvvYxlaPz789ft0FQOZkpuqX4STHHLZLZPj3MCSzA
         lo9+a8iGhPg1Fh0db53wqvkYGxPVhRoYyrvtWXA/8pWEf9GeZf80+lQPnGXb8e9kQd1E
         jXsTMow9NbVUgOgqhUld/ZXo+8ifAR9I5H5ndXnWmaG4AuqN/jXjg8/9YipQmRHBpUpm
         8HOq68qpHSHmMwDW9kysIuTQ92VKAtm1mxq2thihTxWuJtKj+1gNBg9vCSekg6rQi/e1
         68gBo3yhFeeTnQxKjUFq5BeTd+bcqhMXDj8jB1F5wsYg4v50VuGZmVu0F7O9cGBeMuxc
         5kSA==
X-Gm-Message-State: APjAAAXCyHEgUhVMzsZfl1Rkwv6jJqhwCBszDKENh8QSDmj9Vcb7N1c/
        jU/PBsUfCWJemsaLdy479I7tiqxPIgkWmpxMVGs=
X-Google-Smtp-Source: APXvYqy9dBhygx88ZimvDfxuqLbtOuGacbVwbzt4VSlgkBYCzVTfmqcKSFqT/f/zCSPuyVlcP7UIOXNNSrlEjiEMpdM=
X-Received: by 2002:a63:490d:: with SMTP id w13mr20971630pga.355.1561157122919;
 Fri, 21 Jun 2019 15:45:22 -0700 (PDT)
MIME-Version: 1.0
References: <20190621163921.26188-1-puranjay12@gmail.com> <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
 <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
 <CAErSpo6iRVWU-yL5CRF_GEY7CWg5iV=Jw0BrdNV4h3Jvh5AuAw@mail.gmail.com> <838b8e84523151418ab8cda4abdbb114ce24a497.camel@perches.com>
In-Reply-To: <838b8e84523151418ab8cda4abdbb114ce24a497.camel@perches.com>
From:   Chris Snook <chris.snook@gmail.com>
Date:   Fri, 21 Jun 2019 15:45:11 -0700
Message-ID: <CAMXMK6uUgLSz=DXazLY81pkiMjtyxKxNeR_VcWOOh1NvaEyS8w@mail.gmail.com>
Subject: Re: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic
 definitions instead of private duplicates
To:     Joe Perches <joe@perches.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux PCI <linux-pci@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 11:33 AM Joe Perches <joe@perches.com> wrote:
>
> On Fri, 2019-06-21 at 13:12 -0500, Bjorn Helgaas wrote:
> > On Fri, Jun 21, 2019 at 12:27 PM Joe Perches <joe@perches.com> wrote:
> []
> > > Subsystem specific local PCI #defines without generic
> > > naming is poor style and makes treewide grep and
> > > refactoring much more difficult.
> >
> > Don't worry, we have the same objectives.  I totally agree that local
> > #defines are a bad thing, which is why I proposed this project in the
> > first place.
>
> Hi again Bjorn.
>
> I didn't know that was your idea.  Good idea.
>
> > I'm just saying that this is a "first-patch" sort of learning project
> > and I think it'll avoid some list spamming and discouragement if we
> > can figure out the scope and shake out some of the teething problems
> > ahead of time.  I don't want to end up with multiple versions of
> > dozens of little 2-3 patch series posted every week or two.
>
> Great, that's sensible.
>
> > I'd rather be able to deal with a whole block of them at one time.
>
> Also very sensible.
>
> > > 2: Show that you compiled the object files and verified
> > >    where possible that there are no object file changes.
> >
> > Do you have any pointers for the best way to do this?  Is it as simple
> > as comparing output of "objdump -d"?
>
> Generically, yes.
>
> I have a little script that does the equivalent of:
>
> <git reset>
> make <foo.o>
> mv <foo.o> <foo.o>.old
> patch -P1 < <foo_patch>
> make <foo.o>
> mv <foo.o> <foo.o>.new
> diff -urN <(objdump -d <foo.o>.old) <(objdump -d <foo.o>.new)
>
> But it's not foolproof as gcc does not guarantee
> compilation repeatability.
>
> And some subsystems Makefiles do not allow per-file
> compilation.
>

This should work, but be aware that the older atlx drivers did some
regrettable things with file structure, so not all .c files are
expected to generate a corresponding .o file.

- Chris
