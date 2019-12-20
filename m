Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9760A127C13
	for <lists+netdev@lfdr.de>; Fri, 20 Dec 2019 14:58:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727369AbfLTN6Y (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Dec 2019 08:58:24 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:45315 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1727347AbfLTN6Y (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 20 Dec 2019 08:58:24 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1576850303;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=z/vT1v9oai6dd5cPt5za0mxKDratl1TdjeGUiSkGV8U=;
        b=Ftcrk7+AyrzmnRXWnF2B/SJTIZs0WEnSUjeOTZlhCHO6hN4wmndShaszEvJAtN5s8jgZEk
        DCaWAKL4FDSVMG4ALpntl7d2I20tero2Vbmt/KKQ0kDThZP3VdV36HxZOc5f7aMcUeFOLF
        kZpsIm/hvOPUdtG0qGazjW13NujU81I=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-335-7uWGQ2u_MCi_F4W2Gtz9nA-1; Fri, 20 Dec 2019 08:58:19 -0500
X-MC-Unique: 7uWGQ2u_MCi_F4W2Gtz9nA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 395C78024DE;
        Fri, 20 Dec 2019 13:58:17 +0000 (UTC)
Received: from krava (ovpn-204-66.brq.redhat.com [10.40.204.66])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id 06B9426FB3;
        Fri, 20 Dec 2019 13:58:13 +0000 (UTC)
Date:   Fri, 20 Dec 2019 14:58:11 +0100
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     Alexei Starovoitov <ast@fb.com>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrey Ignatov <rdna@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "md@linux.it" <md@linux.it>
Subject: Re: libbpf distro packaging
Message-ID: <20191220135811.GF17348@krava>
References: <a00bab9b-dae8-23d8-8de0-3751a1d1b023@fb.com>
 <20190826064235.GA17554@krava>
 <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
 <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Dec 19, 2019 at 09:37:23PM +0000, Julia Kartseva wrote:
> Hi Jiri,
> 
> 1. v. 0.0.6 is out [1], could you please package it?
> 2. we might need a small spec update due to zlib is made an explicit
> dependency in [2]. zlib should be listed in BuildRequires: section of the
> spec so it's consistent with libbpf.pc

sure, it's ok for rawhide, in fedora 31/30 we still don't have
latest headers packaged

> 3. Do you plan to address the bug report [3] for CentOS? Namely rebuilding
> Fedora's RPM and publishing to EPEL repo?

I did not get any answers on who would do that internally,
so I'm afreaid I'll have to do it, but let me ask again first ;-)

jirka

