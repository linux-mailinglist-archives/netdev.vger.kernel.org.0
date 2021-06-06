Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CCFA339D21B
	for <lists+netdev@lfdr.de>; Mon,  7 Jun 2021 00:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231312AbhFFWzP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 6 Jun 2021 18:55:15 -0400
Received: from relay8-d.mail.gandi.net ([217.70.183.201]:53791 "EHLO
        relay8-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbhFFWzK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 6 Jun 2021 18:55:10 -0400
Received: (Authenticated sender: n@nfraprado.net)
        by relay8-d.mail.gandi.net (Postfix) with ESMTPSA id 861051BF203;
        Sun,  6 Jun 2021 22:53:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nfraprado.net;
        s=gm1; t=1623019997;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=LEITmbgA+ypfFiT6sDRv13/uCob4oKC9Sq9src0AzZE=;
        b=chA+i0RmfXwj/WF8vUQcsG8LWn2bONkphlI9FxGByy3xXZzQ3/zHKFPGJxmKXuKUW335J7
        jYK4CRJ9+UN7xZA7RoqojnjXZW+0cqiNSJEER76idFul1Hmyyid+LU7eBwqw4Yf6VUnAAy
        EO/oCOnOkrJSrla2lWMUer63YFPTS6rPVGC6R5VJrg9wTSN5B9e0Ariq05tQnFO7ePJjQo
        bl4pkIEG3/A5X1Ubh0QT5mRcrGJQ8WehYjr1NfQyPqrYiwulB4ynbpB9vRe3MCb4L15B0r
        jLNt083VPjq8mnz5SK6VyymWvFVmHAPrKBJPANhNFdLyuGqe1sYaP2/+H+QnUQ==
Date:   Sun, 6 Jun 2021 19:52:25 -0300
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
Message-ID: <20210606225225.fz4dsyz6im4bqena@notapiano>
References: <cover.1622898327.git.mchehab+huawei@kernel.org>
 <20210605151109.axm3wzbcstsyxczp@notapiano>
 <20210605210836.540577d4@coco.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20210605210836.540577d4@coco.lan>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 05, 2021 at 09:08:36PM +0200, Mauro Carvalho Chehab wrote:
> Em Sat, 5 Jun 2021 12:11:09 -0300
> Nícolas F. R. A. Prado <n@nfraprado.net> escreveu:
> 
> > Hi Mauro,
> > 
> > On Sat, Jun 05, 2021 at 03:17:59PM +0200, Mauro Carvalho Chehab wrote:
> > > As discussed at:
> > > 	https://lore.kernel.org/linux-doc/871r9k6rmy.fsf@meer.lwn.net/
> > > 
> > > It is better to avoid using :doc:`foo` to refer to Documentation/foo.rst, as the
> > > automarkup.py extension should handle it automatically, on most cases.
> > > 
> > > There are a couple of exceptions to this rule:
> > > 
> > > 1. when :doc:  tag is used to point to a kernel-doc DOC: markup;
> > > 2. when it is used with a named tag, e. g. :doc:`some name <foo>`;
> > > 
> > > It should also be noticed that automarkup.py has currently an issue:
> > > if one use a markup like:
> > > 
> > > 	Documentation/dev-tools/kunit/api/test.rst
> > > 	  - documents all of the standard testing API excluding mocking
> > > 	    or mocking related features.
> > > 
> > > or, even:
> > > 
> > > 	Documentation/dev-tools/kunit/api/test.rst
> > > 	    documents all of the standard testing API excluding mocking
> > > 	    or mocking related features.
> > > 	
> > > The automarkup.py will simply ignore it. Not sure why. This patch series
> > > avoid the above patterns (which is present only on 4 files), but it would be
> > > nice to have a followup patch fixing the issue at automarkup.py.  
> > 
> > What I think is happening here is that we're using rST's syntax for definition
> > lists [1]. automarkup.py ignores literal nodes, and perhaps a definition is
> > considered a literal by Sphinx. Adding a blank line after the Documentation/...
> > or removing the additional indentation makes it work, like you did in your
> > 2nd and 3rd patch, since then it's not a definition anymore, although then the
> > visual output is different as well.
> 
> A literal has a different output. I think that this is not the case, but I 
> didn't check the python code from docutils/Sphinx.

Okay, I went in deeper to understand the issue and indeed it wasn't what I
thought. The reason definitions are ignored by automarkup.py is because the main
loop iterates only over nodes that are of type paragraph:

    for para in doctree.traverse(nodes.paragraph):
        for node in para.traverse(nodes.Text):
            if not isinstance(node.parent, nodes.literal):
                node.parent.replace(node, markup_refs(name, app, node))

And inspecting the HTML output from your example, the definition name is inside
a <dt> tag, and it doesn't have a <p> inside. So in summary, automarkup.py will
only work on elements which are inside a <p> in the output.

Only applying the automarkup inside paragraphs seems like a good decision (which
covers text in lists and tables as well), so unless there are other types of
elements without paragraphs where automarkup should work, I think we should just
avoid using definition lists pointing to documents like that.

>  
> > I'm not sure this is something we need to fix. Does it make sense to use
> > definition lists for links like that? If it does, I guess one option would be to
> > whitelist definition lists so they aren't ignored by automarkup, but I feel
> > this could get ugly really quickly.
> 
> Yes, we should avoid handling literal blocks, as this can be a nightmare.
> 
> > FWIW note that it's also possible to use relative paths to docs with automarkup.
> 
> Not sure if you meant to say using something like ../driver-api/foo.rst.
> If so, relative paths are a problem, as it will pass unnoticed by this script:
> 
> 	./scripts/documentation-file-ref-check
> 
> which is meant to warn when a file is moved to be elsewhere. Ok, it
> could be taught to use "../" to identify paths, but I suspect that this
> could lead to false positives, like here:
> 
> 	Documentation/usb/gadget-testing.rst:  # ln -s ../../uncompressed/u
> 	Documentation/usb/gadget-testing.rst:  # cd ../../class/fs
> 	Documentation/usb/gadget-testing.rst:  # ln -s ../../header/h

Yes, that's what I meant. 

Ok, that makes sense. Although after automarkup.py starts printing warnings on
missing references to files (which is a patch I still need to resend), it would
work out-of-the-box with relative paths. automarkup wouldn't face that false
positives issue since it ignores literal blocks, which isn't as easy for a
standalone script. But that's still in the future, we can discuss what to do
then after it is implemented, so full paths seem better for now.

Thanks,
Nícolas

> 
> If you meant, instead, :doc:`../foo`, this series address those too.
> 
> Regards,
> Mauro
