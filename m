Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38C2339EF8F
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 09:28:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230370AbhFHHaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Jun 2021 03:30:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:40350 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229518AbhFHHaU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Jun 2021 03:30:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B3D5C61073;
        Tue,  8 Jun 2021 07:28:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623137307;
        bh=O/zMXaiejHSPpLDrpWoLj5vApKw6co+rXXxeAdTs0fQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nLlyZlZD273F402k83SpAE2/yTCnSoxOmIHbl9CNTcXkiOIJIwbU4EIxQMSt2a4ml
         qYAZ7+GRyFby1j7J/b6Qdg0ngb9aWUorA3LUTEzB/o7nAxtpl99tYE56SX6c/L7cnq
         JkQNkQc+kckZEP6v8MtI7gBXthqAyHNA2ro1bRHL944hNLYqFQNYNtkG14YdEsbCz8
         WiPAfikei2ZlyE9DmtO+G5LcsEimR8Zt3bf/sh+4dSJxaQew1IHT6LAPnPOy5G3d1V
         9RKb6ljsgqP02St+w9CxWqyTHfLgCquU2TvIEjFpSrPZM71r6hel2yJmUWm39106ZP
         ITZzuhEQ/FbwA==
Date:   Tue, 8 Jun 2021 09:28:19 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     "=?UTF-8?B?TsOtY29sYXM=?= F. R. A. Prado" <n@nfraprado.net>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        coresight@lists.linaro.org, devicetree@vger.kernel.org,
        kunit-dev@googlegroups.com, kvm@vger.kernel.org,
        linux-acpi@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-gpio@vger.kernel.org, linux-hwmon@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-kselftest@vger.kernel.org,
        linux-media@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 00/34] docs: avoid using ReST :doc:`foo` tag
Message-ID: <20210608092819.3f4191b3@coco.lan>
In-Reply-To: <20210608003458.kwhbn6mraekcutlt@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
        <20210605151109.axm3wzbcstsyxczp@notapiano>
        <20210605210836.540577d4@coco.lan>
        <20210606225225.fz4dsyz6im4bqena@notapiano>
        <20210607093422.0a369909@coco.lan>
        <20210608003458.kwhbn6mraekcutlt@notapiano>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Mon, 7 Jun 2021 21:34:58 -0300
N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:

> Hi Mauro,
>=20
> On Mon, Jun 07, 2021 at 09:34:22AM +0200, Mauro Carvalho Chehab wrote:
> > Em Sun, 6 Jun 2021 19:52:25 -0300
> > N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:
> >  =20
> > > On Sat, Jun 05, 2021 at 09:08:36PM +0200, Mauro Carvalho Chehab wrote=
: =20
> > > > Em Sat, 5 Jun 2021 12:11:09 -0300
> > > > N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:
> > > >    =20
> > > > > Hi Mauro,
> > > > >=20
> > > > > On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab w=
rote:   =20
> > > > > > As discussed at:
> > > > > > 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> > > > > >=20
> > > > > > It is better to avoid using :doc:`foo` to refer to Documentatio=
n/foo.rst, as the
> > > > > > automarkup.py extension should handle it automatically, on most=
 cases.
> > > > > >=20
> > > > > > There are a couple of exceptions to this rule:
> > > > > >=20
> > > > > > 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> > > > > > 2. when it is used with a named tag, e. g. :doc:`some name <foo=
>`;
> > > > > >=20
> > > > > > It should also be noticed that automarkup.py has currently an i=
ssue:
> > > > > > if one use a markup like:
> > > > > >=20
> > > > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > > > 	  - documents all of the standard testing API excluding mocking
> > > > > > 	    or mocking related features.
> > > > > >=20
> > > > > > or, even:
> > > > > >=20
> > > > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > > > 	    documents all of the standard testing API excluding mocking
> > > > > > 	    or mocking related features.
> > > > > > =09
> > > > > > The automarkup.py will simply ignore it. Not sure why. This pat=
ch series
> > > > > > avoid the above patterns (which is present only on 4 files), bu=
t it would be
> > > > > > nice to have a followup patch fixing the issue at automarkup.py=
.     =20
> > > > >=20
> > > > > What I think is happening here is that we're using rST's syntax f=
or definition
> > > > > lists [1]. automarkup.py ignores literal nodes, and perhaps a def=
inition is
> > > > > considered a literal by Sphinx. Adding a blank line after the Doc=
umentation/...
> > > > > or removing the additional indentation makes it work, like you di=
d in your
> > > > > 2nd and 3rd patch, since then it's not a definition anymore, alth=
ough then the
> > > > > visual output is different as well.   =20
> > > >=20
> > > > A literal has a different output. I think that this is not the case=
, but I=20
> > > > didn't check the python code from docutils/Sphinx.   =20
> > >=20
> > > Okay, I went in deeper to understand the issue and indeed it wasn't w=
hat I
> > > thought. The reason definitions are ignored by automarkup.py is becau=
se the main
> > > loop iterates only over nodes that are of type paragraph:
> > >=20
> > >     for para in doctree.traverse(nodes.paragraph):
> > >         for node in para.traverse(nodes.Text):
> > >             if not isinstance(node.parent, nodes.literal):
> > >                 node.parent.replace(node, markup_refs(name, app, node=
))
> > >=20
> > > And inspecting the HTML output from your example, the definition name=
 is inside
> > > a <dt> tag, and it doesn't have a <p> inside. So in summary, automark=
up.py will
> > > only work on elements which are inside a <p> in the output. =20
> >=20
> >=20
> > Yeah, that's what I was suspecting, based on the comments.
> >=20
> > Maybe something similar to the above could be done also for some
> > non-paragraph data. By looking at:
> >=20
> > 	https://docutils.sourceforge.io/docs/ref/doctree.html
> >=20
> > It says that the body elements are:
> >=20
> > 	admonition, attention, block_quote, bullet_list, caution, citation,=20
> > 	comment, compound, container, danger, definition_list, doctest_block,=
=20
> > 	enumerated_list, error, field_list, figure, footnote, hint, image,=20
> > 	important, line_block, literal_block, note, option_list, paragraph,=20
> > 	pending, raw, rubric, substitution_definition, system_message,=20
> > 	table, target, tip, warning =20
>=20
> Ok, I went through each one by searching the term on [1] and inspecting t=
he
> element to see if it contained a <p> or not. The vast majority did. These=
 are
> the ones I didn't find there or didn't make sense:
>=20
> 	comment
> 	container
> 	image
> 	pending
> 	raw
> 	substitution_definition
> 	system_message
> 	target
>=20
> We can safely ignore them. And these are the ones that matter and don't h=
ave
> paragraphs:
>=20
> 	1. literal_block
> 	2. doctest_block
> 	3. definition_list
> 	4. field_list
> 	5. option_list
> 	6. line_block
>=20
> 1 and 2 are literals, so we don't care about them.
>=20
> 3 is the one you noticed the issue with. It's worth mentioning that the
> definition term doesn't have a paragraph, but its definition does (as can=
 be
> checked by inspecting [2]).
>=20
> 4 is basically the same as 3, the rst syntax is different but the output =
is the
> same. That said, I believe we only use those to set options at the top of=
 the
> file, like in translations, and I can't see automarkup being useful in th=
ere.
>=20
> 5 is similar to 3 and 4, but the term is formatted using <kbd>, so it's l=
ike a
> literal and therefore not relevant.
>=20
> 6 is useful just to preserve indentation, and I'm pretty sure we don't us=
e it in
> the docs.
>=20
> So in the end, I think the only contenders to be added to automarkup are
> definition lists, and even then I still think we should just substitute t=
hose
> definition lists with alternatives like you did in your patches. Personal=
ly I
> don't see much gain in using definitions instead of a simple paragraph. B=
ut if
> you really think it's an improvement in some way, it could probably be ad=
ded to
> automarkup in the way you described.

Thank you for checking this!

Kernel docs use a lot definition lists. At the initial versions, it was
equivalent to:

	**Something to be written with emphasis**

	  Some description

Sphinx later changed the look-and-feel for the term, on html output, but
the thing is that:

	Something to be written with emphasis
	   Some description

looks a lot better when read as a text file.

Also, on some cases, the first notation doesn't work. The definition-list
was the only way I know that would allow to apply an emphasis to a literal
block.

We can avoid using Documentation/foo on description lists: the current 4=20
cases where doc:`foo` are already addressed in this series, and the output
is acceptable.

Yet, I have a couple of concerns:

1. It might have some unknown places where a description list is used
   for Documentation/foo;
2. It is not trivial to identify if someone add Documentation/foo in
   the future;
3. I suspect that there are several places where functions and structs
   appear at the definition lists.

(1) can probably be checked with a multi-line grep. So, not a big
    problem;

(2) is something that would require someone to verify from time to
    time;

but (3) are harder to check and seems to be a valid use-case.

Due to (3), I think we should let automarkup to parse non-literal
terms on description lists. At very least it should emit a warning when
it won't be doing auto-conversions for known patterns at definition
lists (if doing that would generate false-positives).

Thanks,
Mauro
