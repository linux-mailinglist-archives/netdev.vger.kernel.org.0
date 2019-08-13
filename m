Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E8FD8B87C
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 14:24:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727263AbfHMMYX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 08:24:23 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57210 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726974AbfHMMYX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 13 Aug 2019 08:24:23 -0400
Received: from smtp.corp.redhat.com (int-mx07.intmail.prod.int.phx2.redhat.com [10.5.11.22])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id D54C2C03D478;
        Tue, 13 Aug 2019 12:24:22 +0000 (UTC)
Received: from krava (unknown [10.43.17.33])
        by smtp.corp.redhat.com (Postfix) with SMTP id E6F2010013A1;
        Tue, 13 Aug 2019 12:24:20 +0000 (UTC)
Date:   Tue, 13 Aug 2019 14:24:20 +0200
From:   Jiri Olsa <jolsa@redhat.com>
To:     Julia Kartseva <hex@fb.com>
Cc:     "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Subject: Re: libbpf distro packaging
Message-ID: <20190813122420.GB9349@krava>
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com>
User-Agent: Mutt/1.12.1 (2019-06-15)
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.22
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.31]); Tue, 13 Aug 2019 12:24:22 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Aug 12, 2019 at 07:04:12PM +0000, Julia Kartseva wrote:
> I would like to bring up libbpf publishing discussion started at [1].
> The present state of things is that libbpf is built from kernel tree, e.g. [2]
> For Debian and [3] for Fedora whereas the better way would be having a
> package built from github mirror. The advantages of the latter:
> - Consistent, ABI matching versioning across distros
> - The mirror has integration tests
> - No need in kernel tree to build a package
> - Changes can be merged directly to github w/o waiting them to be merged
> through bpf-next -> net-next -> main
> There is a PR introducing a libbpf.spec which can be used as a starting point: [4]
> Any comments regarding the spec itself can be posted there.
> In the future it may be used as a source of truth.
> Please consider switching libbpf packaging to the github mirror instead
> of the kernel tree.
> Thanks
> 
> [1] https://lists.iovisor.org/g/iovisor-dev/message/1521
> [2] https://packages.debian.org/sid/libbpf4.19
> [3] http://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/l/libbpf-5.3.0-0.rc2.git0.1.fc31.x86_64.html
> [4] https://github.com/libbpf/libbpf/pull/64

hi,
Fedora has libbpf as kernel-tools subpackage, so I think
we'd need to create new package and deprecate the current

but I like the ABI stability by using github .. how's actually
the sync (in both directions) with kernel sources going on?

thanks,
jirka
