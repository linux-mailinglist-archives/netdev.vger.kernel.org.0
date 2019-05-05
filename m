Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 294CC13DF9
	for <lists+netdev@lfdr.de>; Sun,  5 May 2019 08:46:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727152AbfEEGpA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 5 May 2019 02:45:00 -0400
Received: from mail-lf1-f67.google.com ([209.85.167.67]:38911 "EHLO
        mail-lf1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725792AbfEEGpA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 5 May 2019 02:45:00 -0400
Received: by mail-lf1-f67.google.com with SMTP id v1so7006401lfg.5;
        Sat, 04 May 2019 23:44:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=rNM8okm3j5qcFOlmbtWz/i2dMSCk9m19FRDJuL/XICM=;
        b=PnTxj4e7Sd5m5Qx13CNSVDglWtShUklbGXst0dBhWas3TyPw7cPe2rx18VME+UOY4l
         p1EbTPApp/FJtj88mTtHzXHyCcD2vRAx6+tsnPeqm92mfSY50CsenIx5eNZ3zXR+s3Kl
         5Va7YeyFpQWd0esBmZWWBTUwyhZ+VJ8fnqk2yi46zWtb9kGcPGyW1gCxfMqL9BN+c0UI
         Cy0CzpcbBniyaT94O9hoYsVa5hLGrb231P6PRkrx6htQzHaVCsCubzAuP2bGaeKmwd7l
         XW1vHdwOph6/D2dNeOhxfVu/v2iSSCdiZuthdzGsFhpihjSb0tkawoaiBjShvABaeqVW
         gk+g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=rNM8okm3j5qcFOlmbtWz/i2dMSCk9m19FRDJuL/XICM=;
        b=kMG6PxvSVtU0iAxJ3r8iMBFhgM0u1g9DK8miwndYLf7R+cmMuAdpI0EG1AjSoGFox3
         Q7fM7n6bdz8vD57NDVs9KNpJpaiRi/tibNupyU1Yp+RMT//K0yhT4GYrXVVNerXsCfrU
         /WFJJuunlBoJzYFGGJKJUm69dGSYSX531BYYBFmJttAuFBJV/AthnWRSJpFLJfnr4jBm
         l4dKWocm12tlqNL2svgET0msOLYS8qUFf9RF50kP1TU6sYBK6puJvpgU9AfvM1Gy99sE
         8GstFX7T3YQvuePfzkJkd+aG6CthMcFYc3otBGXURTVYxsTI7ZH0vx0+OyW45DKbDb3K
         zlnA==
X-Gm-Message-State: APjAAAVisYvAV+1QAd/aUzd34VPYQ4g2Xt+XWh6ItCBdIGcPzhFzrVc1
        ln61v70GCAoCPMywLqCFCCz+iQQSJazVooQGQok=
X-Google-Smtp-Source: APXvYqy7amIsq5DhpiC8V2vckqyUcmbqQ+PeQ6Pc/A34RZ1jExivExzYEtAMrFinu6QQ0+4cNy+2PGitm18RFCEn8MU=
X-Received: by 2002:ac2:494f:: with SMTP id o15mr565893lfi.22.1557038697905;
 Sat, 04 May 2019 23:44:57 -0700 (PDT)
MIME-Version: 1.0
References: <1556718359-1598-1-git-send-email-yamada.masahiro@socionext.com> <b550f762-5324-0bdb-7097-6bcf354b6d67@netronome.com>
In-Reply-To: <b550f762-5324-0bdb-7097-6bcf354b6d67@netronome.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sat, 4 May 2019 23:44:46 -0700
Message-ID: <CAADnVQLnAjzqhNC78OX3QKfV0YRL55bSyo=FR7k3LErmAiOxnw@mail.gmail.com>
Subject: Re: [PATCH v2] bpftool: exclude bash-completion/bpftool from
 .gitignore pattern
To:     Quentin Monnet <quentin.monnet@netronome.com>
Cc:     Masahiro Yamada <yamada.masahiro@socionext.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Sirio Balmelli <sirio@b-ad.ch>,
        Song Liu <songliubraving@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Yonghong Song <yhs@fb.com>,
        Taeung Song <treeze.taeung@gmail.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        Martin KaFai Lau <kafai@fb.com>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 1, 2019 at 7:02 AM Quentin Monnet
<quentin.monnet@netronome.com> wrote:
>
> 2019-05-01 22:45 UTC+0900 ~ Masahiro Yamada <yamada.masahiro@socionext.com>
> > tools/bpf/bpftool/.gitignore has the "bpftool" pattern, which is
> > intended to ignore the following build artifact:
> >
> >   tools/bpf/bpftool/bpftool
> >
> > However, the .gitignore entry is effective not only for the current
> > directory, but also for any sub-directories.
> >
> > So, from the point of .gitignore grammar, the following check-in file
> > is also considered to be ignored:
> >
> >   tools/bpf/bpftool/bash-completion/bpftool
> >
> > As the manual gitignore(5) says "Files already tracked by Git are not
> > affected", this is not a problem as far as Git is concerned.
> >
> > However, Git is not the only program that parses .gitignore because
> > .gitignore is useful to distinguish build artifacts from source files.
> >
> > For example, tar(1) supports the --exclude-vcs-ignore option. As of
> > writing, this option does not work perfectly, but it intends to create
> > a tarball excluding files specified by .gitignore.
> >
> > So, I believe it is better to fix this issue.
> >
> > You can fix it by prefixing the pattern with a slash; the leading slash
> > means the specified pattern is relative to the current directory.
> >
> > Signed-off-by: Masahiro Yamada <yamada.masahiro@socionext.com>
> > ---
> >
> > Changes in v2:
> >   - Add more information to the commit log to clarify my main motivation
> >   - Touch "bpftool" pattern only
> >
> >  tools/bpf/bpftool/.gitignore | 2 +-
> >  1 file changed, 1 insertion(+), 1 deletion(-)
> >
> > diff --git a/tools/bpf/bpftool/.gitignore b/tools/bpf/bpftool/.gitignore
> > index 67167e4..8248b8d 100644
> > --- a/tools/bpf/bpftool/.gitignore
> > +++ b/tools/bpf/bpftool/.gitignore
> > @@ -1,5 +1,5 @@
> >  *.d
> > -bpftool
> > +/bpftool
> >  bpftool*.8
> >  bpf-helpers.*
> >  FEATURE-DUMP.bpftool
> >
>
> Thanks a lot for the changes!
>
> Reviewed-by: Quentin Monnet <quentin.monnet@netronome.com>

Applied. Thanks
