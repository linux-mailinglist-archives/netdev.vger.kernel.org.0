Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 278D340D88D
	for <lists+netdev@lfdr.de>; Thu, 16 Sep 2021 13:30:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237667AbhIPLcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Sep 2021 07:32:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:49672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236506AbhIPLcD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 16 Sep 2021 07:32:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 161C061351;
        Thu, 16 Sep 2021 11:30:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631791842;
        bh=JomLulPT/VCa+Ld8PCnrA61X+KN3aqBET6nR8VSiCbM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=k1M+1/F/Hux3jkf4B1W11De6kD+bQcAiJRC79Lj20yajPs9mGiBCduaxXvwvJ4XhA
         dz+xAbstwBu4vi6QwIV/1347BkfeEB0wREiMQw2yXelvXXoeIvClKJV4KOiz2OyZVn
         G1X8lr0807q4YeIKiVdeVkBVjmq97q7KSQmJ6kLHslXeqUodbT6QXU3W3Vht4VuI1i
         ZWiKHS1pFRZ03ggixwAFQBUeKJ3WiLCZs/wfbcbowQqkibVOHxa3f39JEN88EzPThd
         wUzW65zAYR/d28PKzqn5MLFVWqJzhv5umIFSbzQA9Yay51lRWo4FcOcebUS/V3MrwW
         o6yVi5yAZV82A==
Date:   Thu, 16 Sep 2021 13:30:36 +0200
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
Message-ID: <20210916133036.37c50383@coco.lan>
In-Reply-To: <33d66a49-2fc0-57a1-c1e5-34e932bcc237@isovalent.com>
References: <cover.1631783482.git.mchehab+huawei@kernel.org>
        <dc4bae7a14518fbfff20a0f539df06a5c19b09de.1631783482.git.mchehab+huawei@kernel.org>
        <eb80e8f5-b9d7-5031-8ebb-4595bb295dbf@isovalent.com>
        <20210916124930.7ae3b722@coco.lan>
        <33d66a49-2fc0-57a1-c1e5-34e932bcc237@isovalent.com>
X-Mailer: Claws Mail 4.0.0 (GTK+ 3.24.30; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Em Thu, 16 Sep 2021 11:57:51 +0100
Quentin Monnet <quentin@isovalent.com> escreveu:

> 2021-09-16 12:49 UTC+0200 ~ Mauro Carvalho Chehab
> <mchehab+huawei@kernel.org>
> > Hi Quentin,
> > 
> > Em Thu, 16 Sep 2021 10:43:45 +0100
> > Quentin Monnet <quentin@isovalent.com> escreveu:
> >   
> >> 2021-09-16 11:14 UTC+0200 ~ Mauro Carvalho Chehab
> >> <mchehab+huawei@kernel.org>  
> >>> The file name: Documentation/bpftool-prog.rst
> >>> should be, instead: tools/bpf/bpftool/Documentation/bpftool-prog.rst.
> >>>
> >>> Update its cross-reference accordingly.
> >>>
> >>> Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> >>> Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")    
> >>
> >> Hi,
> >> How is this a fix for the commit that added the documentation in bpftool?
> >>  
> >>> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> >>> ---
> >>>  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
> >>>  1 file changed, 1 insertion(+), 1 deletion(-)
> >>>
> >>> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> >>> index be54b7335a76..27a2c369a798 100755
> >>> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> >>> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> >>> @@ -374,7 +374,7 @@ class ManProgExtractor(ManPageExtractor):
> >>>      """
> >>>      An extractor for bpftool-prog.rst.
> >>>      """
> >>> -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-prog.rst')
> >>> +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-prog.rst')
> >>>  
> >>>      def get_attach_types(self):
> >>>          return self.get_rst_list('ATTACH_TYPE')
> >>>     
> >>
> >> No I don't believe it should. BPFTOOL_DIR already contains
> >> 'tools/bpf/bpftool' and the os.path.join() concatenates the two path
> >> fragments.
> >>
> >> Where is this suggestion coming from? Did you face an issue with the script?  
> > 
> > No, I didn't face any issues with this script.
> > 
> > The suggestion cames from the script at:
> > 
> > 	./scripts/documentation-file-ref-check
> > 
> > which is meant to discover broken doc references. 
> > 
> > Such script has already a rule to handle stuff under tools/:
> > 
> > 		# Accept relative Documentation patches for tools/
> > 		if ($f =~ m/tools/) {
> > 			my $path = $f;
> > 			$path =~ s,(.*)/.*,$1,;
> > 			next if (grep -e, glob("$path/$ref $path/../$ref $path/$fulref"));
> > 		}
> > 
> > but it seems it needs a fixup in order for it to stop reporting issues
> > at test_bpftool_synctypes.py:
> > 
> > 	$ ./scripts/documentation-file-ref-check 
> > 	...
> > 	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-prog.rst
> > 	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-map.rst
> > 	tools/testing/selftests/bpf/test_bpftool_synctypes.py: Documentation/bpftool-cgroup.rst  
> 
> Oh, I see, thanks for explaining. I didn't know this script would catch
> the paths in bpftool's test file.
> 
> > 
> > I'll drop the patches touching it for a next version, probably
> > adding a fix for such script.
> > 
> > Thanks,
> > Mauro
> >   
> 
> Sounds good to me, thanks a lot!

The enclosed patch should do the trick.

> Quentin

Thanks,
Mauro

[PATCH] scripts: documentation-file-ref-check: fix bpf selftests path

tools/testing/selftests/bpf/test_bpftool_synctypes.py use
relative patches on the top of BPFTOOL_DIR:

	BPFTOOL_DIR = os.path.join(LINUX_ROOT, 'tools/bpf/bpftool')

Change the script to automatically convert:

	testing/selftests/bpf -> bpf/bpftool

In order to properly check the files used by such script.

Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>

diff --git a/scripts/documentation-file-ref-check b/scripts/documentation-file-ref-check
index 7187ea5e5149..2d91cfe11cd2 100755
--- a/scripts/documentation-file-ref-check
+++ b/scripts/documentation-file-ref-check
@@ -144,6 +144,7 @@ while (<IN>) {
 		if ($f =~ m/tools/) {
 			my $path = $f;
 			$path =~ s,(.*)/.*,$1,;
+			$path =~ s,testing/selftests/bpf,bpf/bpftool,;
 			next if (grep -e, glob("$path/$ref $path/../$ref $path/$fulref"));
 		}
 



