Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68AFBDE1C1
	for <lists+netdev@lfdr.de>; Mon, 21 Oct 2019 03:22:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726834AbfJUBWq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Oct 2019 21:22:46 -0400
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46135 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726399AbfJUBWq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Oct 2019 21:22:46 -0400
Received: by mail-lj1-f195.google.com with SMTP id d1so11401090ljl.13;
        Sun, 20 Oct 2019 18:22:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=V/JUtmAtM/GkGXaDJB1vyKZ/gwQgDhBXRCWybHQRV1k=;
        b=R2ppIkaIhKzFC0+4362d6zF8FdwgTWIn1nCslYhGfqoh6Jsn0RAsXwUgAs5b1eMP3k
         fyLKoD6dmuyQt/tBaZ6Tesjn8KpIUjOgXrMxWGHFAtYaGOrtIiwLPSU/9NrwwNMpfTa6
         /yV7UQdlP/iQaoTVhK/S7yL61gRt7KP9bxQCeL+Cx5aWoESOUulDFNNyk2SYZkLS6h97
         joJKZk1i9mtA7C3H0Cf1dOZYnDku7HPxHRF8oXMvt0nniA0JH4EpdzuJ++jzD2Sgeiy/
         2+NV7l/J5EphLTD+VRL23DJpvPSg+ShqS9jxWhMkFvrLHEc97a7jhvCM9T+GbjK5pPLZ
         dN4A==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=V/JUtmAtM/GkGXaDJB1vyKZ/gwQgDhBXRCWybHQRV1k=;
        b=rFjRa8JJ9xv/KUFFKiUBN/7wF2CAkJNet44MpebqyTMKTfR+gYSCuNxJxx8EQYyetL
         HhTuEIbPn+7Jn04YBJ261rGk2nyV+jVRqTL3D/T1n1OdBnfW/dCniJeic39evlMhiGS0
         95E0HRKlfWdA3CbIyw8KjI0kNTD71J/Bcr3DUZd4WKweswQLaal5VNEJ+JVmWAi81NZG
         lrvXNcWiLk8GpXNDngw3aiD+6ph37WNZCnxG2t1QgWFQVkrCTQrT/zqts9YlnueSGmhg
         YJdqEwKDV2CNuWagsNZo0R3NUX/Nr44owHC630BpcHBzkkpf4oBhj4e+/D27WfxPKLd4
         Cu0A==
X-Gm-Message-State: APjAAAWZ/ibi4Vv+RW+xyFopDAGJcUdrFL+ZMYkPsdL5Uqq9itxRw1Uo
        BxKYX6/jTw3CXBG6eSeEXXv+bO1E2B1qLukzKJs=
X-Google-Smtp-Source: APXvYqxq0kNKbR0aT/7nSQNIKfSC0yOdCtkHu+Eq9h/o5SF7h3HDeGwYjUcOT50IIBc5FQtcfXws13kHxLYtXudWJRs=
X-Received: by 2002:a2e:9b12:: with SMTP id u18mr13350055lji.142.1571620963520;
 Sun, 20 Oct 2019 18:22:43 -0700 (PDT)
MIME-Version: 1.0
References: <20191020112344.19395-1-jakub@cloudflare.com> <CAEf4Bzap3PxBuwm+Ew+hgm0bEHa4W0ZhoLTMeo04qW1w=NZSEw@mail.gmail.com>
In-Reply-To: <CAEf4Bzap3PxBuwm+Ew+hgm0bEHa4W0ZhoLTMeo04qW1w=NZSEw@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Sun, 20 Oct 2019 18:22:31 -0700
Message-ID: <CAADnVQLLuL7-6S-Ms7QvEEiQRTNkn0rBcfp=17xy3-NdBcsHWg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2] scripts/bpf: Print an error when known types
 list needs updating
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        kernel-team <kernel-team@cloudflare.com>,
        Andrii Nakryiko <andriin@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Oct 20, 2019 at 5:52 PM Andrii Nakryiko
<andrii.nakryiko@gmail.com> wrote:
>
> On Sun, Oct 20, 2019 at 4:24 AM Jakub Sitnicki <jakub@cloudflare.com> wrote:
> >
> > Don't generate a broken bpf_helper_defs.h header if the helper script needs
> > updating because it doesn't recognize a newly added type. Instead print an
> > error that explains why the build is failing, clean up the partially
> > generated header and stop.
> >
> > v1->v2:
> > - Switched from temporary file to .DELETE_ON_ERROR.
> >
> > Fixes: 456a513bb5d4 ("scripts/bpf: Emit an #error directive known types list needs updating")
> > Suggested-by: Andrii Nakryiko <andriin@fb.com>
> > Signed-off-by: Jakub Sitnicki <jakub@cloudflare.com>

Applied.Thanks
