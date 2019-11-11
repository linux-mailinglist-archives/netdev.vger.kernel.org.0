Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA0EFF75C0
	for <lists+netdev@lfdr.de>; Mon, 11 Nov 2019 14:57:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726908AbfKKN4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 Nov 2019 08:56:40 -0500
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:46304 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726834AbfKKN4k (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 11 Nov 2019 08:56:40 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1573480599;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SiKp+ONUKarRJdOJuC22hyB9UFmPM/DUafbfNDGf398=;
        b=elq1htgPBVUinrhgAwFoaUse9hdoqBUEHVa1QEXMyL945L+18UWdrE4DwEmRazQV/1u8eW
        AkVEezZjEu5sshPLFbPrleEz68bVtG/TDQhm+n2Xv+q5nmW0ktNGpKXM3RhLToSkfDgWXO
        3P0rrnp2O2nFW51/DYRkHM202sGP9F0=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-60-ZFIi6fCdNw2WLck8TXMOcw-1; Mon, 11 Nov 2019 08:56:36 -0500
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2E391800D48;
        Mon, 11 Nov 2019 13:56:34 +0000 (UTC)
Received: from carbon (ovpn-200-19.brq.redhat.com [10.40.200.19])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C232E289AA;
        Mon, 11 Nov 2019 13:56:29 +0000 (UTC)
Date:   Mon, 11 Nov 2019 14:56:28 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Daniel Borkmann <daniel@iogearbox.net>
Cc:     bpf@vger.kernel.org, linux-kbuild@vger.kernel.org,
        netdev@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        brouer@redhat.com
Subject: Re: [net-next PATCH] samples/bpf: adjust Makefile and README.rst
Message-ID: <20191111145628.23bea8fe@carbon>
In-Reply-To: <a1e149a5-af72-0602-d48d-ec7e6939df22@iogearbox.net>
References: <157340347607.14617.683175264051058224.stgit@firesoul>
        <a1e149a5-af72-0602-d48d-ec7e6939df22@iogearbox.net>
MIME-Version: 1.0
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
X-MC-Unique: ZFIi6fCdNw2WLck8TXMOcw-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Nov 2019 14:49:51 +0100
Daniel Borkmann <daniel@iogearbox.net> wrote:

> On 11/10/19 5:31 PM, Jesper Dangaard Brouer wrote:
> > Side effect of some kbuild changes resulted in breaking the
> > documented way to build samples/bpf/.
> >=20
> > This patch change the samples/bpf/Makefile to work again, when
> > invoking make from the subdir samples/bpf/. Also update the
> > documentation in README.rst, to reflect the new way to build.
> >=20
> > Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com> =20
>=20
> Please make sure to have bpf@vger.kernel.org Cc'ed in future as well
> (done here). Given net-next in subject, any specific reason you need
> this expedited over normal bpf-next route? Looks like there is no
> conflict either way.

When I created this patch, bpf-next didn't have the other fixes for
samples/bpf/.  If you have sync'ed with net-next, then I'm fine with
you taking this change (as it will propagate back to DaveM's tree soon
enough).


> In any case, change looks good to me:
>=20
> Acked-by: Daniel Borkmann <daniel@iogearbox.net>
>=20
> > ---
> >   samples/bpf/Makefile   |    4 ++--
> >   samples/bpf/README.rst |   12 +++++-------
> >   2 files changed, 7 insertions(+), 9 deletions(-)
> >=20
> > diff --git a/samples/bpf/Makefile b/samples/bpf/Makefile
> > index d88c01275239..8e32a4d29a38 100644
> > --- a/samples/bpf/Makefile
> > +++ b/samples/bpf/Makefile
> > @@ -203,7 +203,7 @@ TPROGLDLIBS_test_overhead=09+=3D -lrt
> >   TPROGLDLIBS_xdpsock=09=09+=3D -pthread
> >  =20
> >   # Allows pointing LLC/CLANG to a LLVM backend with bpf support, redef=
ine on cmdline:
> > -#  make samples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm=
/build/bin/clang
> > +#  make M=3Dsamples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/=
llvm/build/bin/clang
> >   LLC ?=3D llc
> >   CLANG ?=3D clang
> >   LLVM_OBJCOPY ?=3D llvm-objcopy
> > @@ -246,7 +246,7 @@ endif
> >  =20
> >   # Trick to allow make to be run from this directory
> >   all:
> > -=09$(MAKE) -C ../../ $(CURDIR)/ BPF_SAMPLES_PATH=3D$(CURDIR)
> > +=09$(MAKE) -C ../../ M=3D$(CURDIR) BPF_SAMPLES_PATH=3D$(CURDIR)
> >  =20
> >   clean:
> >   =09$(MAKE) -C ../../ M=3D$(CURDIR) clean
> > diff --git a/samples/bpf/README.rst b/samples/bpf/README.rst
> > index cc1f00a1ee06..dd34b2d26f1c 100644
> > --- a/samples/bpf/README.rst
> > +++ b/samples/bpf/README.rst
> > @@ -46,12 +46,10 @@ Compiling
> >   For building the BPF samples, issue the below command from the kernel
> >   top level directory::
> >  =20
> > - make samples/bpf/
> > -
> > -Do notice the "/" slash after the directory name.
> > + make M=3Dsamples/bpf
> >  =20
> >   It is also possible to call make from this directory.  This will just
> > -hide the the invocation of make as above with the appended "/".
> > +hide the invocation of make as above.
> >  =20
> >   Manually compiling LLVM with 'bpf' support
> >   ------------------------------------------
> > @@ -77,7 +75,7 @@ Quick sniplet for manually compiling LLVM and clang
> >   It is also possible to point make to the newly compiled 'llc' or
> >   'clang' command via redefining LLC or CLANG on the make command line:=
:
> >  =20
> > - make samples/bpf/ LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llvm/b=
uild/bin/clang
> > + make M=3Dsamples/bpf LLC=3D~/git/llvm/build/bin/llc CLANG=3D~/git/llv=
m/build/bin/clang
> >  =20
> >   Cross compiling samples
> >   -----------------------
> > @@ -98,10 +96,10 @@ Pointing LLC and CLANG is not necessarily if it's i=
nstalled on HOST and have
> >   in its targets appropriate arm64 arch (usually it has several arches)=
.
> >   Build samples::
> >  =20
> > - make samples/bpf/
> > + make M=3Dsamples/bpf
> >  =20
> >   Or build samples with SYSROOT if some header or library is absent in =
toolchain,
> >   say libelf, providing address to file system containing headers and l=
ibs,
> >   can be RFS of target board::
> >  =20
> > - make samples/bpf/ SYSROOT=3D~/some_sysroot
> > + make M=3Dsamples/bpf SYSROOT=3D~/some_sysroot
> >  =20
>=20



--=20
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

