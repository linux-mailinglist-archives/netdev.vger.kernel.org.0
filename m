Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D81F53948E
	for <lists+netdev@lfdr.de>; Fri,  7 Jun 2019 20:44:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731907AbfFGSon (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 7 Jun 2019 14:44:43 -0400
Received: from casper.infradead.org ([85.118.1.10]:55408 "EHLO
        casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728873AbfFGSon (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 7 Jun 2019 14:44:43 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        MIME-Version:References:In-Reply-To:Message-ID:Subject:Cc:To:From:Date:Sender
        :Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=okj69MZGvSUR6PKRM1mo76QwPQAo0KpBD3JOl7izOGQ=; b=tkvWPXolFrV5gC6B/5s5iq8MdS
        71AqKowXyuv3bN8SkI+l2hm+nntwA7kf9Vp1BZbYZ7a0zstKeUuQK4lQC4lL7Hf/lc9Qnhq/nADyG
        oZpW6Uvw7OAz13o5FduofHVYHVUtVImMNlJ082ilSm5zr5jpHf0z+vlpbgt2oDx/I4RcAQym43m5b
        /rAepyYSek6lQnoC10I5TM/3wYS5L00RHVmJ+gp+qSRzJhGgsVMWutpTVH0ns9VVtodda92tav6RA
        eeqwTIvWGagPvmBIBDHO/e0ogkZerSFtXxQWrFNw9IdUifKf6NcumiewyU6UVX+vIx6FuKNMcCpa7
        qorGd03g==;
Received: from [179.181.119.115] (helo=coco.lan)
        by casper.infradead.org with esmtpsa (Exim 4.92 #3 (Red Hat Linux))
        id 1hZJqw-0006VH-9M; Fri, 07 Jun 2019 18:44:38 +0000
Date:   Fri, 7 Jun 2019 15:44:30 -0300
From:   Mauro Carvalho Chehab <mchehab+samsung@kernel.org>
To:     Jonathan Corbet <corbet@lwn.net>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Mauro Carvalho Chehab <mchehab@infradead.org>,
        linux-kernel@vger.kernel.org, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Subject: Re: [PATCH v2 00/22] Some documentation fixes
Message-ID: <20190607154430.4879976d@coco.lan>
In-Reply-To: <20190607115521.6bf39030@lwn.net>
References: <cover.1559656538.git.mchehab+samsung@kernel.org>
        <20190607115521.6bf39030@lwn.net>
X-Mailer: Claws Mail 3.17.3 (GTK+ 2.24.32; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Fri, 7 Jun 2019 11:55:21 -0600
Jonathan Corbet <corbet@lwn.net> escreveu:

> On Tue,  4 Jun 2019 11:17:34 -0300
> Mauro Carvalho Chehab <mchehab+samsung@kernel.org> wrote:
> 
> > Fix several warnings and broken links.
> > 
> > This series was generated against linux-next, but was rebased to be applied at
> > docs-next. It should apply cleanly on either tree.
> > 
> > There's a git tree with all of them applied on the top of docs/docs-next
> > at:
> > 
> > https://git.linuxtv.org/mchehab/experimental.git/log/?h=fix_doc_links_v2  
> 
> So I'll admit I've kind of lost track of which of these are applied, which
> have comments, etc.  When you feel things have settled, can you get me an
> updated set and I'll get them applied?

What I usually do here to check what was already applied (besides
looking e-mails) is to reset my tree against yours, then pull from
linux-next and pull from my old branch with those patches.

Then, I reset again to your tree, in order to make easier for you
to apply. It should be noticed that, due to this, you might actually
see a few more warnings on your tree, if a patch on this series
fix an issue that it is at linux next but didn't arrive your
tree.

Yet, all patches apply cleanly on your tree.

After doing that, there are 17 patches yet to be applied. Two new
patches are now needed too, due to vfs.txt -> vfs.rst and
pci.txt -> pci.rst renames.

The patches against your tree are at:

	https://git.linuxtv.org/mchehab/experimental.git/log/?h=fix_doc_links_v3.3

For convenience, I'm sending them again as a new patch series
(with the two extra patches fixing the recent issues).


Thanks,
Mauro
