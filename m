Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B34E939D623
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 09:35:03 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230284AbhFGHg0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 03:36:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:49074 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230231AbhFGHgU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 7 Jun 2021 03:36:20 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 29FEA60720;
        Mon,  7 Jun 2021 07:34:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1623051269;
        bh=0ypPpkJHDs3edXD5bDeKaiim7X/xfBueG4AuE8+Qj+U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MCZa/wfgoJSof9wCVVOv/LrdFcXdwY1vCJuTly8zaeAIwTuRDtC8rzfgyHA9r6/+g
         NW2tP3feh93C/5Dxty7jg+vScZHZGMhUEyWQ5FgxO8vpWG7sfVd2/FVm9kFVWmNyKF
         EQBYWqrXHDSSXIu/AIkm5+Ioyl/4Y8qqVlITSp7EP1AHAdF2gq6+t5N/EukG8nlrD5
         /Z/7kCrp6V3McL/0xD3Opj9oSYMVR4OQwEiMuDlxNhhxICUhrFF3xy6Xf7sAtNEHPC
         UZ6EjZnr6psnuld6cX9JYfcpHnFwEGAKkBcwq4fn3pJEE/OA/DfL7AgTqkUjjnfOU7
         t/jaztuq+MVCA==
Date:   Mon, 7 Jun 2021 09:34:22 +0200
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
Message-ID: <20210607093422.0a369909@coco.lan>
In-Reply-To: <20210606225225.fz4dsyz6im4bqena@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
        <20210605151109.axm3wzbcstsyxczp@notapiano>
        <20210605210836.540577d4@coco.lan>
        <20210606225225.fz4dsyz6im4bqena@notapiano>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Sun, 6 Jun 2021 19:52:25 -0300
N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:

> On Sat, Jun 05, 2021 at 09:08:36PM +0200, Mauro Carvalho Chehab wrote:
> > Em Sat, 5 Jun 2021 12:11:09 -0300
> > N=C3=ADcolas F. R. A. Prado <n@nfraprado.net> escreveu:
> >  =20
> > > Hi Mauro,
> > >=20
> > > On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab wrote=
: =20
> > > > As discussed at:
> > > > 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> > > >=20
> > > > It is better to avoid using :doc:`foo` to refer to Documentation/fo=
o.rst, as the
> > > > automarkup.py extension should handle it automatically, on most cas=
es.
> > > >=20
> > > > There are a couple of exceptions to this rule:
> > > >=20
> > > > 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> > > > 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> > > >=20
> > > > It should also be noticed that automarkup.py has currently an issue:
> > > > if one use a markup like:
> > > >=20
> > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > 	  - documents all of the standard testing API excluding mocking
> > > > 	    or mocking related features.
> > > >=20
> > > > or, even:
> > > >=20
> > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > 	    documents all of the standard testing API excluding mocking
> > > > 	    or mocking related features.
> > > > =09
> > > > The automarkup.py will simply ignore it. Not sure why. This patch s=
eries
> > > > avoid the above patterns (which is present only on 4 files), but it=
 would be
> > > > nice to have a followup patch fixing the issue at automarkup.py.   =
=20
> > >=20
> > > What I think is happening here is that we're using rST's syntax for d=
efinition
> > > lists [1]. automarkup.py ignores literal nodes, and perhaps a definit=
ion is
> > > considered a literal by Sphinx. Adding a blank line after the Documen=
tation/...
> > > or removing the additional indentation makes it work, like you did in=
 your
> > > 2nd and 3rd patch, since then it's not a definition anymore, although=
 then the
> > > visual output is different as well. =20
> >=20
> > A literal has a different output. I think that this is not the case, bu=
t I=20
> > didn't check the python code from docutils/Sphinx. =20
>=20
> Okay, I went in deeper to understand the issue and indeed it wasn't what I
> thought. The reason definitions are ignored by automarkup.py is because t=
he main
> loop iterates only over nodes that are of type paragraph:
>=20
>     for para in doctree.traverse(nodes.paragraph):
>         for node in para.traverse(nodes.Text):
>             if not isinstance(node.parent, nodes.literal):
>                 node.parent.replace(node, markup_refs(name, app, node))
>=20
> And inspecting the HTML output from your example, the definition name is =
inside
> a <dt> tag, and it doesn't have a <p> inside. So in summary, automarkup.p=
y will
> only work on elements which are inside a <p> in the output.


Yeah, that's what I was suspecting, based on the comments.

Maybe something similar to the above could be done also for some
non-paragraph data. By looking at:

	https://docutils.sourceforge.io/docs/ref/doctree.html

It says that the body elements are:

	admonition, attention, block_quote, bullet_list, caution, citation,=20
	comment, compound, container, danger, definition_list, doctest_block,=20
	enumerated_list, error, field_list, figure, footnote, hint, image,=20
	important, line_block, literal_block, note, option_list, paragraph,=20
	pending, raw, rubric, substitution_definition, system_message,=20
	table, target, tip, warning

So, perhaps a similar loop for definition_list would do the trick,
but maybe automarkup should also look at other types, like enum lists,
notes (and their variants, like error/warning) and footnotes.

No idea how this would affect the docs build time, though.

> Only applying the automarkup inside paragraphs seems like a good decision=
 (which
> covers text in lists and tables as well), so unless there are other types=
 of
> elements without paragraphs where automarkup should work, I think we shou=
ld just
> avoid using definition lists pointing to documents like that.

Checking the code or doing some tests are needed for us to be sure about wh=
at
of the above types docutils don't consider a paragraph.

Thanks,
Mauro
