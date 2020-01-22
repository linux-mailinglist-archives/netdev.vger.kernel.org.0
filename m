Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8D8AF144C95
	for <lists+netdev@lfdr.de>; Wed, 22 Jan 2020 08:47:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726103AbgAVHrx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jan 2020 02:47:53 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:53368 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1725883AbgAVHrx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jan 2020 02:47:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1579679272;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=G++hH120fgfGSmqHe6ikWFKlaVrxMD3F9wiI16FkCDo=;
        b=jV5YVM5jKzDdrLaMJNhVM18UB9m/dzJHbFM3tlYnOi9tNu/D+1zOLoeUtb2Ho6pkqeabd7
        Ndk6Ig+KCcG4Y840sZis1AbBfIG2QffqNstaEJcuBzzPd4y5qvn78RKjtfJIq74+/JLAXo
        JOPXu6nkCUlDDKyJrKLz9gb2Np+Butg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-160-UjA3deW1OSS9QtdmZjUGeg-1; Wed, 22 Jan 2020 02:47:48 -0500
X-MC-Unique: UjA3deW1OSS9QtdmZjUGeg-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A88ECDB61;
        Wed, 22 Jan 2020 07:47:46 +0000 (UTC)
Received: from krava (ovpn-204-206.brq.redhat.com [10.40.204.206])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 1CBFD5DA75;
        Wed, 22 Jan 2020 07:47:42 +0000 (UTC)
Date:   Wed, 22 Jan 2020 08:47:40 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        David Miller <davem@redhat.com>,
        =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@intel.com>,
        John Fastabend <john.fastabend@gmail.com>
Subject: Re: [PATCH 6/6] selftest/bpf: Add test for allowed trampolines count
Message-ID: <20200122074740.GC801240@krava>
References: <20200121120512.758929-1-jolsa@kernel.org>
 <20200121120512.758929-7-jolsa@kernel.org>
 <CAADnVQJO7cObUhqLbEB6+hKaPj1SStNfuhzXShC1XmAt217y8g@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQJO7cObUhqLbEB6+hKaPj1SStNfuhzXShC1XmAt217y8g@mail.gmail.com>
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 21, 2020 at 04:10:26PM -0800, Alexei Starovoitov wrote:
> On Tue, Jan 21, 2020 at 4:05 AM Jiri Olsa <jolsa@kernel.org> wrote:
> >
> > There's limit of 40 programs tht can be attached
> > to trampoline for one function. Adding test that
> > tries to attach that many plus one extra that needs
> > to fail.
> >
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> 
> I don't mind another test. Just pointing out that there is one
> for this purpose already :)
> prog_tests/fexit_stress.c
> Yours is better. Mine wasn't that sophisticated. :)

ok ;-) did not notice that one.. just wanted to be sure
the unwind change won't screw that

jirka

