Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 626B18C086
	for <lists+netdev@lfdr.de>; Tue, 13 Aug 2019 20:24:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728363AbfHMSYL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Aug 2019 14:24:11 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:34990 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725923AbfHMSYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Aug 2019 14:24:11 -0400
Received: by mail-qk1-f193.google.com with SMTP id r21so80497190qke.2
        for <netdev@vger.kernel.org>; Tue, 13 Aug 2019 11:24:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=pW2w8jvV1TCKffO1TzkH103ny5W9s8goXKo5RIMP0kA=;
        b=FBQB+z5AdKy7X71VAKQuRw6VKen8WG9fyDMwpZFvdS/ITDz1SW4SzeV1MQdanCcAry
         JCGWDrhLBhU+WnI+LCNf4o4w3CJaD0SpuZ1chLQum1aHA3JVWYqeRFkXSkmqClgTxOHc
         kW+yo4/1kC8E/gVvOp50LS4eF7Xy2RuKRYSp7zpbpgopBVpgOZTG3z21IcUD7HLT8mIb
         AlN3m4AXdei0A7d7GesUVhKbsLYKeXhM3JPmQO8lgiQc+ggHrzaHZr2mL4424O8BH8CY
         VEY+YuQMnOLsxq90nQvRNO8sWe7kO/nVV4lNHl/SpWTmpEtIOq4voBvwMN0O/MLTVqO4
         JoWA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=pW2w8jvV1TCKffO1TzkH103ny5W9s8goXKo5RIMP0kA=;
        b=KBAqoIAXc/YZ+yggHywkUr28aZW2xO7blxeEdD8Kp6lqEco8qdj1TtaW+Ju9HwWHpV
         goHX4fIXc+D1tDltt3TrBc5Qa0uBloHNddcCFVBs1f/+vHGhhDElC9cw9xppn9S3Druf
         +EKZxa/VYUyt5YeZO/WMYEEB9/ydaP8Yf52pNJSYGRdztUpanlMYezBDjRUQCal0+j8U
         szUXNSQHP/wYV9/IloDodYwLfbaqV8SDryufkmQEHzdyHuj3n05PZ9OMvXCcR1zszIpb
         LRopVNAXQnIOSPKM/uSiS87yipSF+BRrvpBd9XafLbptZwtbxpRHxmE5x+o04ujOaQQ/
         YP6A==
X-Gm-Message-State: APjAAAVL84V0nSevb2gPRfVPvNo7MlysRC5sbL1YfdkeAcIq/CNH0LVP
        Pa8DN822320p9vtI0x+KLaBkUikFqaHWRFaXShs=
X-Google-Smtp-Source: APXvYqyQtXMSMOcRY68dQVIuH0RVfvXYN0y2MKuvi+9ncn8TrSIS8pdgAt4WV0h4tjqwaJF4PgfKyHpc0BAFz8tzeIQ=
X-Received: by 2002:a37:9b48:: with SMTP id d69mr36350852qke.449.1565720650191;
 Tue, 13 Aug 2019 11:24:10 -0700 (PDT)
MIME-Version: 1.0
References: <3FBEC3F8-5C3C-40F9-AF6E-C355D8F62722@fb.com> <20190813122420.GB9349@krava>
In-Reply-To: <20190813122420.GB9349@krava>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 13 Aug 2019 11:23:59 -0700
Message-ID: <CAEf4BzbG29eAL7gUV+Vyrrft4u4Ss8ZBC6RMixJL_CYOTQ+F2w@mail.gmail.com>
Subject: Re: libbpf distro packaging
To:     Jiri Olsa <jolsa@redhat.com>
Cc:     Julia Kartseva <hex@fb.com>,
        "labbott@redhat.com" <labbott@redhat.com>,
        "acme@kernel.org" <acme@kernel.org>,
        "debian-kernel@lists.debian.org" <debian-kernel@lists.debian.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Andrii Nakryiko <andriin@fb.com>, Andrey Ignatov <rdna@fb.com>,
        Alexei Starovoitov <ast@fb.com>, Yonghong Song <yhs@fb.com>,
        "jolsa@kernel.org" <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 13, 2019 at 5:26 AM Jiri Olsa <jolsa@redhat.com> wrote:
>
> On Mon, Aug 12, 2019 at 07:04:12PM +0000, Julia Kartseva wrote:
> > I would like to bring up libbpf publishing discussion started at [1].
> > The present state of things is that libbpf is built from kernel tree, e.g. [2]
> > For Debian and [3] for Fedora whereas the better way would be having a
> > package built from github mirror. The advantages of the latter:
> > - Consistent, ABI matching versioning across distros
> > - The mirror has integration tests
> > - No need in kernel tree to build a package
> > - Changes can be merged directly to github w/o waiting them to be merged
> > through bpf-next -> net-next -> main
> > There is a PR introducing a libbpf.spec which can be used as a starting point: [4]
> > Any comments regarding the spec itself can be posted there.
> > In the future it may be used as a source of truth.
> > Please consider switching libbpf packaging to the github mirror instead
> > of the kernel tree.
> > Thanks
> >
> > [1] https://lists.iovisor.org/g/iovisor-dev/message/1521
> > [2] https://packages.debian.org/sid/libbpf4.19
> > [3] http://rpmfind.net/linux/RPM/fedora/devel/rawhide/x86_64/l/libbpf-5.3.0-0.rc2.git0.1.fc31.x86_64.html
> > [4] https://github.com/libbpf/libbpf/pull/64
>
> hi,
> Fedora has libbpf as kernel-tools subpackage, so I think
> we'd need to create new package and deprecate the current
>
> but I like the ABI stability by using github .. how's actually
> the sync (in both directions) with kernel sources going on?

Sync is always in one direction, from kernel sources into Github repo.
Right now it's triggered by a human (usually me), but we are using a
script that automates entire process (see
https://github.com/libbpf/libbpf/blob/master/scripts/sync-kernel.sh).
It cherry-pick relevant commits from kernel, transforms them to match
Github's file layout and re-applies those changes to Github repo.

There is never a sync from Github back to kernel, but Github repo
contains some extra stuff that's not in kernel. E.g., the script I
mentioned, plus Github's Makefile is different, because it can't rely
on kernel's kbuild setup.

>
> thanks,
> jirka
