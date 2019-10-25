Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 99509E4432
	for <lists+netdev@lfdr.de>; Fri, 25 Oct 2019 09:15:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406662AbfJYHPf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Oct 2019 03:15:35 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:30376 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2406555AbfJYHPf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Oct 2019 03:15:35 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1571987734;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=rTRslYrHSdW7igFaHUholgbG5slSK/amyRgWotfdeUo=;
        b=IVNls4wTx4n+83JlWuQEL6JqJSL44Y9dmiQrNEjlDIvHvIcXy4xGHhrALANSUuNCYmD052
        wZvn971QiCxUDOumbG++do1pCAgiMFtZRW/AIkmUHU8YAj6bP0vzP6JzbKo17RJFgmj7Qk
        nRm9R36bcrLlrz+S/hl2oK9wI3gjdkQ=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-169-g7UiYoUTNgKgioDVGFZYkQ-1; Fri, 25 Oct 2019 03:15:30 -0400
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 19FC71005509;
        Fri, 25 Oct 2019 07:15:29 +0000 (UTC)
Received: from krava (unknown [10.43.17.61])
        by smtp.corp.redhat.com (Postfix) with SMTP id 1F5AC5D9CA;
        Fri, 25 Oct 2019 07:15:26 +0000 (UTC)
Date:   Fri, 25 Oct 2019 09:15:26 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     Jiri Olsa <jolsa@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>, netdev@vger.kernel.org,
        bpf@vger.kernel.org, Andrii Nakryiko <andriin@fb.com>,
        Yonghong Song <yhs@fb.com>, Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH] bpftool: Allow to read btf as raw data
Message-ID: <20191025071526.GB31679@krava>
References: <20191024133025.10691-1-jolsa@kernel.org>
 <20191024105537.0c824bcb@cakuba.hsd1.ca.comcast.net>
MIME-Version: 1.0
In-Reply-To: <20191024105537.0c824bcb@cakuba.hsd1.ca.comcast.net>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
X-MC-Unique: g7UiYoUTNgKgioDVGFZYkQ-1
X-Mimecast-Spam-Score: 0
Content-Type: text/plain; charset=WINDOWS-1252
Content-Transfer-Encoding: quoted-printable
Content-Disposition: inline
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 24, 2019 at 10:55:37AM -0700, Jakub Kicinski wrote:
> On Thu, 24 Oct 2019 15:30:25 +0200, Jiri Olsa wrote:
> > The bpftool interface stays the same, but now it's possible
> > to run it over BTF raw data, like:
> >=20
> >   $ bpftool btf dump file /sys/kernel/btf/vmlinux
> >   [1] INT '(anon)' size=3D4 bits_offset=3D0 nr_bits=3D32 encoding=3D(no=
ne)
> >   [2] INT 'long unsigned int' size=3D8 bits_offset=3D0 nr_bits=3D64 enc=
oding=3D(none)
> >   [3] CONST '(anon)' type_id=3D2
> >=20
> > Signed-off-by: Jiri Olsa <jolsa@kernel.org>
> > ---
> > v3 changes:
> >  - fix title
> >=20
> > v2 changes:
> >  - added is_btf_raw to find out which btf__parse_* function to call
> >  - changed labels and error propagation in btf__parse_raw
> >  - drop the err initialization, which is not needed under this change
>=20
>=20
> Aw, this is v3? Looks like I replied to the older now, such confusion :)

yea, that went well.. sry, missed the v3 in title

jirka

