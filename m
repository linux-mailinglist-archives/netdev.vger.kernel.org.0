Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36ED040D7CA
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 12:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237040AbhIPKu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 06:50:58 -0400
Received: from mail.kernel.org ([198.145.29.99]:38034 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235644AbhIPKu5 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 06:50:57 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id B08C461212;
        Thu, 16 Sep 2021 10:49:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631789377;
        bh=fp1TNMHOFsWq2J/VHlgIglOFHSB2pZWpIK3WKY20BB0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JLBWL53G2batQtel8a586fQ7gSdE+AdJTh5qkJ7j9B1MTl3GkRcrJyjszQG1/PYzS
         dfpeFx29TJZfq5rNLRu/8+/omTILNZe2pZ4D3h99zTnqwzPILu8LvtA6EY96z28cWR
         KxHgbaZnB71knyCA2rQ+wK3XNAbDDFKlnwNyJuksfyGf5BgSGD67OWvqWq+zJghcGF
         McFZ8aavNQq0Ul5HAjDlC0jLJDVtJq6iYq3zshXa0ErQmHn1jnAq44b53IpWC8C/66
         vkplh0A3mOpQYrYTXyeLFrdyNeCMHXkpgmfzc1oxShgVo6RsjtMq18w98xGvby3sXx
         tK7ipVa9SOzug==
Date:   Thu, 16 Sep 2021 12:49:30 +0200
From:   Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-kselftest@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH 08/24] tools: bpftool: update bpftool-prog.rst reference
Message-ID: <20210916124930.7ae3b722@coco.lan>
In-Reply-To: <eb80e8f5-b9d7-5031-8ebb-4595bb295dbf@isovalent.com>
References: <cover.1631783482.git.mchehab+huawei@kernel.org>
        <dc4bae7a14518fbfff20a0f539df06a5c19b09de.1631783482.git.mchehab+huawei@kernel.org>
        <eb80e8f5-b9d7-5031-8ebb-4595bb295dbf@isovalent.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Quentin,

Em Thu, 16 Sep 2021 10:43:45 +0100
Quentin Monnet <quentin@isovalent.com> escreveu:

> 2021-09-16 11:14 UTC+0200 ~ Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org>
> > The file name: Documentation/bpftool-prog.rst
> > should be, instead: tools/bpf/bpftool/Documentation/bpftool-prog.rst.
> > 
> > Update its cross-reference accordingly.
> > 
> > Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> > Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")  
> 
> Hi,
> How is this a fix for the commit that added the documentation in bpftool?
> 
> > Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> > ---
> >  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> > 
> > diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > index be54b7335a76..27a2c369a798 100755
> > --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> > @@ -374,7 +374,7 @@ class ManProgExtractor(ManPageExtractor):
> >      """
> >      An extractor for bpftool-prog.rst.
> >      """
> > -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-prog.rst')
> > +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-prog.rst')
> >  
> >      def get_attach_types(self):
> >          return self.get_rst_list('ATTACH_TYPE')
> >   
> 
> No I don't believe it should. BPFTOOL_DIR already contains
> 'tools/bpf/bpftool' and the os.path.join() concatenates the two path
> fragments.
> 
> Where is this suggestion coming from? Did you face an issue with the script?

No, I didn't face any issues with this script.

The suggestion cames from the script at:

	./scripts/documentation-file-ref-check

which is meant to discover broken doc references. 

Such script has already a rule to handle stuff under tools/:

		# Accept relative Documentation patches for tools/
		if ($f =~ m/tools/) {
			my $path = $f;
			$path =~ s,(.*)/.*,$1,;
			next if (grep -e, glob("$path/$ref $path/../$ref $path/$fulref"));
		}

but it seems it needs a fixup in order for it to stop reporting issues
at test_bpftool_synctypes.py:

	$ ./scripts/documentation-file-ref-check 
	...
	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-prog.rst
	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-map.rst
	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-cgroup.rst

I'll drop the patches touching it for a next version, probably
adding a fix for such script.

Thanks,
Mauro
