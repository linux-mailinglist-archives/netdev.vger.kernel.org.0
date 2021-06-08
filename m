Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F154739EAD3
	for <lists+netdev@lfdr.de>; Tue,  8 Jun 2021 02:35:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231222AbhFHAhs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Jun 2021 20:37:48 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:38513 "EHLO
        relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230266AbhFHAhp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Jun 2021 20:37:45 -0400
Received: (Authenticated sender: n@nfraprado.net)
        by relay3-d.mail.gandi.net (Postfix) with ESMTPSA id 8FFC460006;
        Tue,  8 Jun 2021 00:35:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nfraprado.net;
        s=gm1; t=1623112550;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=MgIRy6Q6KMGL5hWxoGPNnPkNfCR3aLlJDfZGUzWbz/E=;
        b=P9jivunjlN1sJ9eOlTMDyLjCEywxVya2Ftqz+hEdSkSw0/elvz6gS8kWLVyXaJ6oaaoyx0
        qIDIGMwtUglmC/Vgb2Ie9iI6I0cHBdlTTnMy0oKmq/2UNRiAziWlj8Gnr6eAAD4ELzFqsD
        mHk+x34HxuC0DbsYokBCWzuGfyBXhTfAMoYOS4Pq4ppxQdlPzzlEBRkzLLaXWwWCR9C72i
        Dqrf/Tb06aPjdbgxtbg/24TPHZncci0Ry+4s1AiNAxQNYtnBdo+YvtUor3hzZf1RWlrLDP
        UyqtEZ8lSyOFbJLN0PVHDwww5JkrI1RST7HtFLradWY3jd3nAcizBoEu2ztOUQ==
Date:   Mon, 7 Jun 2021 21:34:58 -0300
From:   =?utf-8?B?TsOtY29sYXMgRi4gUi4gQS4=?= Prado <n@nfraprado.net>
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
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
Message-ID: <20210608003458.kwhbn6mraekcutlt@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
 <20210605151109.axm3wzbcstsyxczp@notapiano>
 <20210605210836.540577d4@coco.lan>
 <20210606225225.fz4dsyz6im4bqena@notapiano>
 <20210607093422.0a369909@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210607093422.0a369909@coco.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Mauro,

On Mon, Jun 07, 2021 at 09:34:22AM +0200, Mauro Carvalho Chehab wrote:
> Em Sun, 6 Jun 2021 19:52:25 -0300
> Nícolas F. R. A. Prado <n@nfraprado.net> escreveu:
> 
> > On Sat, Jun 05, 2021 at 09:08:36PM +0200, Mauro Carvalho Chehab wrote:
> > > Em Sat, 5 Jun 2021 12:11:09 -0300
> > > Nícolas F. R. A. Prado <n@nfraprado.net> escreveu:
> > >   
> > > > Hi Mauro,
> > > > 
> > > > On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab wrote:  
> > > > > As discussed at:
> > > > > 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> > > > > 
> > > > > It is better to avoid using :doc:`foo` to refer to Documentation/foo.rst, as the
> > > > > automarkup.py extension should handle it automatically, on most cases.
> > > > > 
> > > > > There are a couple of exceptions to this rule:
> > > > > 
> > > > > 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> > > > > 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> > > > > 
> > > > > It should also be noticed that automarkup.py has currently an issue:
> > > > > if one use a markup like:
> > > > > 
> > > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > > 	  - documents all of the standard testing API excluding mocking
> > > > > 	    or mocking related features.
> > > > > 
> > > > > or, even:
> > > > > 
> > > > > 	Documentation/dev-tools/kunit/api/test.rst
> > > > > 	    documents all of the standard testing API excluding mocking
> > > > > 	    or mocking related features.
> > > > > 	
> > > > > The automarkup.py will simply ignore it. Not sure why. This patch series
> > > > > avoid the above patterns (which is present only on 4 files), but it would be
> > > > > nice to have a followup patch fixing the issue at automarkup.py.    
> > > > 
> > > > What I think is happening here is that we're using rST's syntax for definition
> > > > lists [1]. automarkup.py ignores literal nodes, and perhaps a definition is
> > > > considered a literal by Sphinx. Adding a blank line after the Documentation/...
> > > > or removing the additional indentation makes it work, like you did in your
> > > > 2nd and 3rd patch, since then it's not a definition anymore, although then the
> > > > visual output is different as well.  
> > > 
> > > A literal has a different output. I think that this is not the case, but I 
> > > didn't check the python code from docutils/Sphinx.  
> > 
> > Okay, I went in deeper to understand the issue and indeed it wasn't what I
> > thought. The reason definitions are ignored by automarkup.py is because the main
> > loop iterates only over nodes that are of type paragraph:
> > 
> >     for para in doctree.traverse(nodes.paragraph):
> >         for node in para.traverse(nodes.Text):
> >             if not isinstance(node.parent, nodes.literal):
> >                 node.parent.replace(node, markup_refs(name, app, node))
> > 
> > And inspecting the HTML output from your example, the definition name is inside
> > a <dt> tag, and it doesn't have a <p> inside. So in summary, automarkup.py will
> > only work on elements which are inside a <p> in the output.
> 
> 
> Yeah, that's what I was suspecting, based on the comments.
> 
> Maybe something similar to the above could be done also for some
> non-paragraph data. By looking at:
> 
> 	https://docutils.sourceforge.io/docs/ref/doctree.html
> 
> It says that the body elements are:
> 
> 	admonition, attention, block_quote, bullet_list, caution, citation, 
> 	comment, compound, container, danger, definition_list, doctest_block, 
> 	enumerated_list, error, field_list, figure, footnote, hint, image, 
> 	important, line_block, literal_block, note, option_list, paragraph, 
> 	pending, raw, rubric, substitution_definition, system_message, 
> 	table, target, tip, warning

Ok, I went through each one by searching the term on [1] and inspecting the
element to see if it contained a <p> or not. The vast majority did. These are
the ones I didn't find there or didn't make sense:

	comment
	container
	image
	pending
	raw
	substitution_definition
	system_message
	target

We can safely ignore them. And these are the ones that matter and don't have
paragraphs:

	1. literal_block
	2. doctest_block
	3. definition_list
	4. field_list
	5. option_list
	6. line_block

1 and 2 are literals, so we don't care about them.

3 is the one you noticed the issue with. It's worth mentioning that the
definition term doesn't have a paragraph, but its definition does (as can be
checked by inspecting [2]).

4 is basically the same as 3, the rst syntax is different but the output is the
same. That said, I believe we only use those to set options at the top of the
file, like in translations, and I can't see automarkup being useful in there.

5 is similar to 3 and 4, but the term is formatted using <kbd>, so it's like a
literal and therefore not relevant.

6 is useful just to preserve indentation, and I'm pretty sure we don't use it in
the docs.

So in the end, I think the only contenders to be added to automarkup are
definition lists, and even then I still think we should just substitute those
definition lists with alternatives like you did in your patches. Personally I
don't see much gain in using definitions instead of a simple paragraph. But if
you really think it's an improvement in some way, it could probably be added to
automarkup in the way you described.

Thanks,
Nícolas

[1] https://sphinx-rtd-theme.readthedocs.io/en/stable/index.html
[2] https://sphinx-rtd-theme.readthedocs.io/en/stable/demo/lists_tables.html?highlight=definition%20list#definition-lists

> 
> So, perhaps a similar loop for definition_list would do the trick,
> but maybe automarkup should also look at other types, like enum lists,
> notes (and their variants, like error/warning) and footnotes.
> 
> No idea how this would affect the docs build time, though.
> 
> > Only applying the automarkup inside paragraphs seems like a good decision (which
> > covers text in lists and tables as well), so unless there are other types of
> > elements without paragraphs where automarkup should work, I think we should just
> > avoid using definition lists pointing to documents like that.
> 
> Checking the code or doing some tests are needed for us to be sure about what
> of the above types docutils don't consider a paragraph.
> 
> Thanks,
> Mauro
