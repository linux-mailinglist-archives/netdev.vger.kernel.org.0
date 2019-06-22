Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB46B4F47A
	for <lists+netdev@lfdr.de>; Sat, 22 Jun 2019 10:50:24 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726372AbfFVIuU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 22 Jun 2019 04:50:20 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:46197 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726114AbfFVIuT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 22 Jun 2019 04:50:19 -0400
Received: by mail-pf1-f194.google.com with SMTP id 81so4749975pfy.13;
        Sat, 22 Jun 2019 01:50:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HuyUZznnr+2KTzyGeAevDXOnX1L1s36jECfUjJLEBVY=;
        b=nQ9fUmlGL1p1hlKj1JC+UdErZcBkQhP+ho3nGSAmkPtmsC1G3BEwYna7ZG/a/zxLnN
         JEigT7Srdnge2JzAruVO2eDmflLWCk8VO0UYq7RIlj2V3MSFjBJBW9mUcBAKuqT8ecIG
         JH9JK0i1KvjA9zaZDt+vv9IX+Nlz0l95T0Q/3H64y3jX1mHLjcV40gXsMN35mps9HxAT
         U8K2LQCQFT8AWkUfuWmgGuPFhuSeS4pNcZaxQGt7g9AiJRpPIBx7ENZCF8P4Loaza2bT
         2dYB/AhAGQ8/dAfJ7+ALVcU5pOpSaHvUF9KrgREet7st0Ex6qtbFFIswh+VQ6E3RwgHj
         mYrg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HuyUZznnr+2KTzyGeAevDXOnX1L1s36jECfUjJLEBVY=;
        b=eOmZ+QlJzDnaZ157PtadpYQ1JAPTxZ6OyIMPMhkmFyTVqKGz/PxC7xBowGKpUvgrQz
         lD1M4OEfZBgShz0+fGnkKmrCAEYWH23Jkov+iGmguWdriIUh26muUryCWTipjEaUCj3O
         YA+/NqEcNJyNzjJp2wA3r6dUmvhhI7gCosrv91LhWKUTzWNvXU8IEk4L8ver+Plh/fWf
         hbHM3FuL5WMaJTKeo0MZUmZXk42Pcbt1CwVobW0499cH2BE+HdQeXZygmhglJSBHHDn0
         /w0aW4L9qnA3dr3pHOuqngdM2UwLT2soGtTSaemA+iIq7wNi/zBFKguVxzQW+kuZsTyA
         Logg==
X-Gm-Message-State: APjAAAW3Bv/wGAoTKYLS9VtDeIq8zHtGQ88YPPhCgPQ0Gy7jzZBd2zI5
        xDIYdr64dzNtbyxyunyrKyzjpOPgjJND+A==
X-Google-Smtp-Source: APXvYqxW7xK3j4Vyr1xnfpkzg5t2peLxlCmlJFBZ1lfX9JqIduSzNbSdUfryVMoVr10zrQXZOaysrg==
X-Received: by 2002:a17:90a:fa18:: with SMTP id cm24mr3869488pjb.120.1561193418682;
        Sat, 22 Jun 2019 01:50:18 -0700 (PDT)
Received: from arch ([112.196.181.13])
        by smtp.gmail.com with ESMTPSA id j13sm8240054pgh.44.2019.06.22.01.50.14
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Sat, 22 Jun 2019 01:50:18 -0700 (PDT)
Date:   Sat, 22 Jun 2019 14:20:01 +0530
From:   Puranjay Mohan <puranjay12@gmail.com>
To:     Joe Perches <joe@perches.com>
Cc:     Bjorn Helgaas <bhelgaas@google.com>,
        Puranjay Mohan <puranjay12@gmail.com>,
        Jay Cliburn <jcliburn@gmail.com>,
        Shuah Khan <skhan@linuxfoundation.org>,
        Bjorn Helgaas <bjorn@helgaas.com>,
        netdev <netdev@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-kernel-mentees@lists.linuxfoundation.org,
        Linux PCI <linux-pci@vger.kernel.org>,
        Chris Snook <chris.snook@gmail.com>
Subject: Re: [PATCH 0/3] net: ethernet: atheros: atlx: Use PCI generic
 definitions instead of private duplicates
Message-ID: <20190622085001.GA11032@arch>
References: <20190621163921.26188-1-puranjay12@gmail.com>
 <CAErSpo5TMPokae7BMY8ZcOXtW=GeGsWXX_bqS8SrZnh0pEQYxw@mail.gmail.com>
 <698d3e3614ae903ae9582547d64c6a9846629e57.camel@perches.com>
 <CAErSpo6iRVWU-yL5CRF_GEY7CWg5iV=Jw0BrdNV4h3Jvh5AuAw@mail.gmail.com>
 <838b8e84523151418ab8cda4abdbb114ce24a497.camel@perches.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <838b8e84523151418ab8cda4abdbb114ce24a497.camel@perches.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jun 21, 2019 at 11:33:27AM -0700, Joe Perches wrote:
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
Hi Joe,
I tried using your specified technique here are the steps I took and the
results I got.

I built the object file before the patch named it "atl2-old.o"
then I built it after the patch, named it "atl2-new.o"

then i ran these commands:-
$ objdump -d atl2-old.o > 1
$ objdump -d atl2-new.o > 2
$ diff -urN 1 2

--- 1	2019-06-22 13:56:17.881392372 +0530
+++ 2	2019-06-22 13:56:35.228018053 +0530
@@ -1,5 +1,5 @@

-atl2-old.o:     file format elf64-x86-64
+atl2-new.o:     file format elf64-x86-64


 Disassembly of section .text:

So both the object files are similar.

Thanks,
--Puranjay



