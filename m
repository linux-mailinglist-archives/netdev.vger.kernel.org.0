Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6A79417A73A
	for <lists+netdev@lfdr.de>; Thu,  5 Mar 2020 15:18:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726184AbgCEOSZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Mar 2020 09:18:25 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24255 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726129AbgCEOSZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Mar 2020 09:18:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583417903;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         in-reply-to:in-reply-to:references:references;
        bh=CPLmPvg60dNkSrGFyR2iOQ9xr45oDSwNV1d+ed5BBwk=;
        b=IEMPGc/aXLzKsNd3Jw9YEKGl+0z89bDbDJ+yAcTdexBNI3dfzlYU75oJsJ5H0KMyBd78v3
        1/edI6mlHItX31ekn1DVxaPycCeN9XPpk8xwb5Ejlrq6XzurH8YjrsN6EpBIjh5NvvEe68
        m35Ku+BcOfqA+4ubcp7zgM57GgZfmHA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-23-OFZimnJ_M5WbkqOvcMCSPQ-1; Thu, 05 Mar 2020 09:18:22 -0500
X-MC-Unique: OFZimnJ_M5WbkqOvcMCSPQ-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id EB3BE19067E1;
        Thu,  5 Mar 2020 14:18:19 +0000 (UTC)
Received: from krava (unknown [10.43.17.74])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id BBE9E28980;
        Thu,  5 Mar 2020 14:18:14 +0000 (UTC)
Date:   Thu, 5 Mar 2020 15:18:12 +0100
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
        "md@linux.it" <md@linux.it>, Cestmir Kalina <ckalina@redhat.com>
Subject: Re: libbpf distro packaging
Message-ID: <20200305141812.GH168640@krava>
References: <A2E805DD-8237-4703-BE6F-CC96A4D4D909@fb.com>
 <20190828071237.GA31023@krava>
 <20190930111305.GE602@krava>
 <040A8497-C388-4B65-9562-6DB95D72BE0F@fb.com>
 <20191008073958.GA10009@krava>
 <AAB8D5C3-807A-4EE3-B57C-C7D53F7E057D@fb.com>
 <20191016100145.GA15580@krava>
 <824912a1-048e-9e95-f6be-fd2b481a8cfc@fb.com>
 <20191220135811.GF17348@krava>
 <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <c1b6a5b1-bbc8-2186-edcf-4c4780c6f836@fb.com>
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 04, 2020 at 04:22:35PM -0800, Julia Kartseva wrote:
> 
> 
> On 12/20/19 5:58 AM, Jiri Olsa wrote:
> > On Thu, Dec 19, 2019 at 09:37:23PM +0000, Julia Kartseva wrote:
> >> Hi Jiri,
> >>
> >> 1. v. 0.0.6 is out [1], could you please package it?
> >> 2. we might need a small spec update due to zlib is made an explicit
> >> dependency in [2]. zlib should be listed in BuildRequires: section of the
> >> spec so it's consistent with libbpf.pc
> > 
> > sure, it's ok for rawhide, in fedora 31/30 we still don't have
> > latest headers packaged
> > 
> >> 3. Do you plan to address the bug report [3] for CentOS? Namely rebuilding
> >> Fedora's RPM and publishing to EPEL repo?
> > 
> > I did not get any answers on who would do that internally,
> > so I'm afreaid I'll have to do it, but let me ask again first ;-)
> >
> 
> Bump :)
> Jiri, any volunteers for Fedora EPEL 7|8 packaging?
> systemd folks would appreciate it.
> Thanks!

hi,
yep.. we've got Cestmir as 'volunteer' for that (cc-ed) ;-) I can see
there's already epel8 branch for libbpf created.. but not sure what's
the actual rpm status

jirka

