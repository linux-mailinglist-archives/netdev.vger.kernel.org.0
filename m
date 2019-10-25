Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C575CE53CA
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 20:27:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726214AbfJYS1N (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 14:27:13 -0400
Received: from dcvr.yhbt.net ([64.71.152.64]:33760 "EHLO dcvr.yhbt.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726030AbfJYS1M (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 25 Oct 2019 14:27:12 -0400
Received: from localhost (dcvr.yhbt.net [127.0.0.1])
        by dcvr.yhbt.net (Postfix) with ESMTP id 4E98A1F4C0;
        Fri, 25 Oct 2019 18:27:12 +0000 (UTC)
Date:   Fri, 25 Oct 2019 18:27:12 +0000
From:   Eric Wong <e@80x24.org>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Konstantin Ryabitsev <konstantin@linuxfoundation.org>,
        workflows@vger.kernel.org
Subject: Re: patch review delays
Message-ID: <20191025182712.GA9391@dcvr>
References: <CAADnVQK2a=scSwGF0TwJ_P0jW41iqnv6aV3FZVmoonRUEaj0kQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAADnVQK2a=scSwGF0TwJ_P0jW41iqnv6aV3FZVmoonRUEaj0kQ@mail.gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Alexei Starovoitov <alexei.starovoitov@gmail.com> wrote:
> The last few days I've experienced long email delivery when I was not
> directly cc-ed on patches.
> Even right now I see some patches in patchworks, but not in my inbox.
> Few folks reported similar issues.
> In order for everyone to review the submissions appropriately
> I'll be applying only the most obvious patches and
> will let others sit in the patchworks a bit longer than usual.
> Sorry about that.
> Ironic that I'm using email to talk about email delays.
> 
> My understanding that these delays are not vger's fault.
> Some remediations may be used sporadically, but
> we need to accelerate our search of long term solutions.
> I think Daniel's l2md:
> https://git.kernel.org/pub/scm/linux/kernel/git/dborkman/l2md.git/
> is a great solution.
> It's on my todo list to give it a try,
> but I'm not sure how practical for every patch reviewer on this list
> to switch to that model.
> Thoughts?

If cloning git repos is too much work, You can subscribe to an
Atom feed of search results to paths or files you're interested
in using "dfn:" (diff-file-name) using your favorite feed
reader:

lore.kernel.org/lkml/?q=dfn:path/to/dir-or-file-youre-interested-in&x=A

Or drop the "&x=A" to get an HTML summary, or POST to that URL
with "&x=m" to download an mbox.

You can also search for multiple files at once by having dfn:foo
multiple times separated by "OR"

lore.kernel.org/lkml/?q=dfn:foo+OR+dfn:bar&x=A

https://lore.kernel.org/lkml/_/text/help/ has other prefixes
like "dfn:" which might be helpful for search.

For example, if you expected to be Cc-ed (or To-ed) and want to
double-check that your mail account got it, you can use the "c:"
or "tc:" prefixes with your name or address, too.
