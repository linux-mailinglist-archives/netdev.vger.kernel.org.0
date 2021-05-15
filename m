Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2087C381842
	for <lists+netdev@lfdr.de>; Sat, 15 May 2021 13:24:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231693AbhEOLZO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 15 May 2021 07:25:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:57360 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230384AbhEOLZH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 15 May 2021 07:25:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 3C31761353;
        Sat, 15 May 2021 11:23:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1621077833;
        bh=HeIddlkMKM2vvOljnLDXD4e2e2yH5GQzottfBaVm0bY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XXlyAEA014M55DUjIyQLfGWDcW9S7xmk1gidB0jh9f2ApxAuuEF9sz2c9VzCGb5GE
         41pS57vPJwcz1c2L+apHtk8j0/zoZAIUVQw007qk7tH/cIpT9DVClLM9mfxTLWrVvL
         wrhEszurWapZjCMLZr9NBlXhh1iki4WvckUaXrW2iyL74EjZoPEpdsooNgbX0Lq+iW
         z/ynOSpbXZQ9RM3lfA5tr05EXWQuuWTypwjc0XflcrGdCNtqTLQ0zuOI0eGNgvNIql
         jgNeJnivsI/Ub1np4iQ0qwQORU1dLwIVXW0zvu4YSMrvgguupZqbQkJ/ZhuuaAPIod
         yefI1SDfhPYmQ==
Date:   Sat, 15 May 2021 13:23:44 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     David Woodhouse <dwmw2@infradead.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, Jonathan Corbet <corbet@lwn.net>,
        Mali DP Maintainers <malidp@foss.arm.com>,
        alsa-devel@alsa-project.org, coresight@lists.linaro.org,
        intel-gfx@lists.freedesktop.org, intel-wired-lan@lists.osuosl.org,
        keyrings@vger.kernel.org, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-edac@vger.kernel.org, linux-ext4@vger.kernel.org,
        linux-f2fs-devel@lists.sourceforge.net,
        linux-hwmon@vger.kernel.org, linux-iio@vger.kernel.org,
        linux-input@vger.kernel.org, linux-integrity@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-rdma@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-usb@vger.kernel.org,
        mjpeg-users@lists.sourceforge.net, netdev@vger.kernel.org,
        rcu@vger.kernel.org
Subject: Re: [PATCH v2 00/40] Use ASCII subset instead of UTF-8 alternate
 symbols
Message-ID: <20210515132344.0206c8fc@coco.lan>
In-Reply-To: <c2a4cb8457823685ecba6833d57047d059b36fbb.camel@infradead.org>
References: <cover.1620823573.git.mchehab+huawei@kernel.org>
        <d2fed242fbe200706b8d23a53512f0311d900297.camel@infradead.org>
        <20210514102118.1b71bec3@coco.lan>
        <61c286b7afd6c4acf71418feee4eecca2e6c80c8.camel@infradead.org>
        <20210515102239.2ffd0451@coco.lan>
        <c2a4cb8457823685ecba6833d57047d059b36fbb.camel@infradead.org>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sat, 15 May 2021 10:24:28 +0100
David Woodhouse <dwmw2@infradead.org> escreveu:

> On Sat, 2021-05-15 at 10:22 +0200, Mauro Carvalho Chehab wrote:
> > > >      Here, <CTRL><SHIFT>U is not working. No idea why. I haven't=20
> > > >      test it for *years*, as I din't see any reason why I would
> > > >      need to type UTF-8 characters by numbers until we started
> > > >      this thread.   =20
> > >=20
> > > Please provide the bug number for this; I'd like to track it. =20
> >=20
> > Just opened a BZ and added you as c/c. =20
>=20
> Thanks.
>=20
> > Let's take one step back, in order to return to the intents of this
> > UTF-8, as the discussions here are not centered into the patches, but
> > instead, on what to do and why.
> >=20
> > -
> >=20
> > This discussion started originally at linux-doc ML.
> >=20
> > While discussing about an issue when machine's locale was not set
> > to UTF-8 on a build VM,  =20
>=20
> Stop. Stop *right* there before you go any further.
>=20
> The machine's locale should have *nothing* to do with anything.
>=20
> When you view this email, it comes with a Content-Type: header which
> explicitly tells you the character set that the message is encoded in,=20
> which I think I've set to UTF-7.
>=20
> When showing you the mail, your system has to interpret the bytes of
> the content using *that* character set encoding. Anything else is just
> fundamentally broken. Your system locale has *nothing* to do with it.
>=20
> If your local system is running EBCDIC that doesn't *matter*.
>=20
> Now, the character set encoding of the kernel source and documentation
> text files is UTF-8. It isn't EBCDIC, it isn't ISO8859-15 or any of the
> legacy crap. It isn't system locale either, unless your system locale
> *happens* to be UTF-8.
>=20
> UTF-8 *happens* to be compatible with ASCII for the limited subset of
> characters which ASCII contains, sure =E2=80=94 just as *many*, but not a=
ll, of
> the legacy 8-bit character sets are also a superset of ASCII's 7 bits.
>=20
> But if the docs contain *any* characters which aren't ASCII, and you
> build them with a broken build system which assumes ASCII, you are
> going to produce wrong output. There is *no* substitute for fixing the
> *actual* bug which started all this, and ensuring your build system (or
> whatever) uses the *actual* encoding of the text files it's processing,
> instead of making stupid and bogus assumptions based on a system
> default.
>=20
> You concede keeping U+00a9 =C2=A9 COPYRIGHT SIGN. And that's encoded in U=
TF-
> 8 as two bytes 0xC2 0xA9. If some broken build system *assumes* those
> bytes are ISO8859-15 it'll take them to mean two separate characters
>=20
>     U+00C2 =C3=82 LATIN CAPITAL LETTER A WITH CIRCUMFLEX
>     U+00A9 =C2=A9 COPYRIGHT SIGN
>=20
> Your broken build system that started all this is never going to be
> *anything* other than broken. You can only paper over the cracks and
> make it slightly less likely that people will notice in the common
> case, perhaps? That's all you do by *reducing* the use of non-ASCII,
> unless you're going to drag us all the way back to the 1980s and
> strictly limit us to pure ASCII, using the equivalent of trigraphs for
> *anything* outside the 0-127 character ranges.
>=20
> And even if you did that, systems which use EBCDIC as their local
> encoding would *still* be broken, if they have the same bug you started
> from. Because EBCDIC isn't compatible with ASCII *even* for the first 7
> bits.

Now, you're making a lot of wrong assumptions here ;-)

1. I didn't report the bug. Another person reported it at linux-doc;
2. I fully agree with you that the building system should work fine
   whatever locate the machine has;
3. Sphinx supported charset for the REST input and its output is UTF-8.

Despite of that, it seems that there are some issues at the building
tool set, at least under certain circunstances. One of the hypothesis=20
that it was mentioned there is that the Sphinx logger crashes when it
tries to print an UTF-8 message when the machine's locale is not UTF-8.

That's said, I tried forcing a non-UTF-8 on some tests I did to try
to reproduce, but the build went fine.

So, I was not able to reproduce the issue.

This series doesn't address the issue. It is just a side effect of the
discussions, where, while trying to understand the bug, we noticed
several UTF-8 characters introduced during the conversion that were't
the original author's intent.

So, with regards to the original but report, if I find a way to
reproduce it and to address it, I'll post a separate series.

If you want to discuss this issue further, let's not discuss here, but
instead, at the linux-doc thread:

	https://lore.kernel.org/linux-doc/20210506103913.GE6564@kitsune.suse.cz/

>=20
>=20
> > we discovered that some converted docs ended
> > with BOM characters. Those specific changes were introduced by some
> > of my convert patches, probably converted via pandoc.
> >=20
> > So, I went ahead in order to check what other possible weird things
> > were introduced by the conversion, where several scripts and tools
> > were used on files that had already a different markup.
> >=20
> > I actually checked the current UTF-8 issues, and asked people at
> > linux-doc to comment what of those are valid usecases, and what
> > should be replaced by plain ASCII. =20
>=20
> No, these aren't "UTF-8 issues". Those are *conversion* issues, and
> would still be there if the output of the conversion had been UTF-7,
> UCS-16, etc. Or *even* if the output of the conversion had been
> trigraph-like stuff like '--' for emdash. It's *nothing* to do with the
> encoding that we happen to be using.

Yes. That's what I said.

>=20
> Fixing the conversion issues makes a lot of sense. Try to do it without
> making *any* mention of UTF-8 at all.
>=20
> > In summary, based on the discussions we have so far, I suspect that
> > there's not much to be discussed for the above cases.
> >=20
> > So, I'll post a v3 of this series, changing only:
> >=20
> >         - U+00a0 (' '): NO-BREAK SPACE
> >         - U+feff ('=EF=BB=BF'): ZERO WIDTH NO-BREAK SPACE (BOM) =20
>=20
> Ack, as long as those make *no* mention of UTF-8. Except perhaps to
> note that BOM is redundant because UTF-8 doesn't have a byteorder.

I need to tell what UTF-8 codes are replaced, as otherwise the patch
wouldn't make much sense to reviewers, as both U+00a0 and whitespaces
are displayed the same way, and BOM is invisible.

>=20
> > ---
> >=20
> > Now, this specific patch series address also this extra case:
> >=20
> > 5. curly commas:
> >=20
> >         - U+2018 ('=E2=80=98'): LEFT SINGLE QUOTATION MARK
> >         - U+2019 ('=E2=80=99'): RIGHT SINGLE QUOTATION MARK
> >         - U+201c ('=E2=80=9C'): LEFT DOUBLE QUOTATION MARK
> >         - U+201d ('=E2=80=9D'): RIGHT DOUBLE QUOTATION MARK
> >=20
> > IMO, those should be replaced by ASCII commas: ' and ".
> >=20
> > The rationale is simple:=20
> >=20
> > - most were introduced during the conversion from Docbook,
> >   markdown and LaTex;
> > - they don't add any extra value, as using "foo" of =E2=80=9Cfoo=E2=80=
=9D means
> >   the same thing;
> > - Sphinx already use "fancy" commas at the output.=20
> >=20
> > I guess I will put this on a separate series, as this is not a bug
> > fix, but just a cleanup from the conversion work.
> >=20
> > I'll re-post those cleanups on a separate series, for patch per patch
> > review. =20
>=20
> Makes sense.=20
>=20
> The left/right quotation marks exists to make human-readable text much
> easier to read, but the key point here is that they are redundant
> because the tooling already emits them in the *output* so they don't
> need to be in the source, yes?

Yes.

> As long as the tooling gets it *right* and uses them where it should,
> that seems sane enough.
>=20
> However, it *does* break 'grep', because if I cut/paste a snippet from
> the documentation and try to grep for it, it'll no longer match.

>=20
> Consistency is good, but perhaps we should actually be consistent the
> other way round and always use the left/right versions in the source
> *instead* of relying on the tooling, to make searches work better?
> You claimed to care about that, right?

That's indeed a good point. It would be interesting to have more
opinions with that matter.

There are a couple of things to consider:

1. It is (usually) trivial to discover what document produced a
   certain page at the documentation.

   For instance, if you want to know where the text under this
   file came from, or to grep a text from it:

	https://www.kernel.org/doc/html/latest/admin-guide/cgroup-v2.html

   You can click at the "View page source" button at the first line.
   It will show the .rst file used to produce it:

	https://www.kernel.org/doc/html/latest/_sources/admin-guide/cgroup-v2.rst.=
txt

2. If all you want is to search for a text inside the docs,
   you can click at the "Search docs" box, which is part of the
   Read the Docs theme.

3. Kernel has several extensions for Sphinx, in order to make life=20
   easier for Kernel developers:

	Documentation/sphinx/automarkup.py
	Documentation/sphinx/cdomain.py
	Documentation/sphinx/kernel_abi.py
	Documentation/sphinx/kernel_feat.py
	Documentation/sphinx/kernel_include.py
	Documentation/sphinx/kerneldoc.py
	Documentation/sphinx/kernellog.py
	Documentation/sphinx/kfigure.py
	Documentation/sphinx/load_config.py
	Documentation/sphinx/maintainers_include.py
	Documentation/sphinx/rstFlatTable.py

Those (in particular automarkup and kerneldoc) will also dynamically=20
change things during ReST conversion, which may cause grep to not work.=20

5. some PDF tools like evince will match curly commas if you
   type an ASCII comma on their search boxes.

6. Some developers prefer to only deal with the files inside the
   Kernel tree. Those are very unlikely to do grep with curly aspas.

My opinion on that matter is that we should make life easier for
developers to grep on text files, as the ones using the web interface
are already served by the search box in html format or by tools like
evince.

So, my vote here is to keep aspas as plain ASCII.

>=20
> > The remaining cases are future work, outside the scope of this v2:
> >=20
> > 6. Hyphen/Dashes and ellipsis
> >=20
> >         - U+2212 ('=E2=88=92'): MINUS SIGN
> >         - U+00ad ('=C2=AD'): SOFT HYPHEN
> >         - U+2010 ('=E2=80=90'): HYPHEN
> >=20
> >             Those three are used on places where a normal ASCII hyphen/=
minus
> >             should be used instead. There are even a couple of C files =
which
> >             use them instead of '-' on comments.
> >=20
> >             IMO are fixes/cleanups from conversions and bad cut-and-pas=
te. =20
>=20
> That seems to make sense.
>=20
> >         - U+2013 ('=E2=80=93'): EN DASH
> >         - U+2014 ('=E2=80=94'): EM DASH
> >         - U+2026 ('=E2=80=A6'): HORIZONTAL ELLIPSIS
> >=20
> >             Those are auto-replaced by Sphinx from "--", "---" and "...=
",
> >             respectively.
> >=20
> >             I guess those are a matter of personal preference about
> >             weather using ASCII or UTF-8.
> >=20
> >             My personal preference (and Ted seems to have a similar
> >             opinion) is to let Sphinx do the conversion.
> >=20
> >             For those, I intend to post a separate series, to be
> >             reviewed patch per patch, as this is really a matter
> >             of personal taste. Hardly we'll reach a consensus here.
> >  =20
>=20
> Again using the trigraph-like '--' and '...' instead of just using the
> plain text '=E2=80=94' and '=E2=80=A6' breaks searching, because what's i=
n the output
> doesn't match the input. Again consistency is good, but perhaps we
> should standardise on just putting these in their plain text form
> instead of the trigraphs?

Good point.=20

While I don't have any strong preferences here, there's something that
annoys me with regards to EM/EN DASH:

With the monospaced fonts I'm using here - both at my e-mailer and
on my terminals, both EM and EN DASH are displayed look *exactly*
the same.

>=20
> > 7. math symbols:
> >=20
> >         - U+00d7 ('=C3=97'): MULTIPLICATION SIGN
> >=20
> >            This one is used mostly do describe video resolutions, but t=
his is
> >            on a smaller changeset than the ones that use "x" letter. =20
>=20
> I think standardising on =C3=97 for video resolutions in documentation wo=
uld
> make it look better and be easier to read.
>=20
> >=20
> >         - U+2217 ('=E2=88=97'): ASTERISK OPERATOR
> >=20
> >            This is used only here:
> >                 Documentation/filesystems/ext4/blockgroup.rst:filesyste=
m size to 2^21 =E2=88=97 2^27 =3D 2^48bytes or 256TiB.
> >=20
> >            Probably added by some conversion tool. IMO, this one should
> >            also be replaced by an ASCII asterisk.
> >=20
> > I guess I'll post a patch for the ASTERISK OPERATOR. =20
>=20
> That makes sense.



Thanks,
Mauro
