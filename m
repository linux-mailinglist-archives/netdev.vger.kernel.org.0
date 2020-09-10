Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 13918264C72
	for <lists+netdev@lfdr.de>; Thu, 10 Sep 2020 20:12:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726997AbgIJSMw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 10 Sep 2020 14:12:52 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34636 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725951AbgIJSMk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 10 Sep 2020 14:12:40 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 894DBC061573;
        Thu, 10 Sep 2020 11:12:39 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id x69so4120572lff.3;
        Thu, 10 Sep 2020 11:12:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=b5/4a+sPvp8g91eIz2Z6rfUfGamXw5eXD4uHR8QWOaM=;
        b=ky7IcoAeI9W72Xv/muSnxQTnjLzwQLDqYwwj6XOPqiKs5eqMfeXt4aTVfSYUUZcvxV
         egVxu/RoNItYqk7eclHd7KRGK4XRcoueOSy6KvXVi7pQObr8qdLHfp85hsW359pxUGer
         CB/NlRHe+Jla5pn6W+k+WR/2xtyRoelRADvDfu3kW/bcgcCwiGH1iveO0gk321J+qS2l
         CuYvz1pI51nyi0n2Cel7as9oe12fyy/KHViTCtcVNwmXv2jhaGLPw8lZxCLTNt+9mGBw
         j+etyRdqqnRG62rl8UKOY+K1Em7v3TN6sEwHjRskBnfV/b18ALPeJpRJKx9M3LyBG1ON
         zD4g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=b5/4a+sPvp8g91eIz2Z6rfUfGamXw5eXD4uHR8QWOaM=;
        b=rLr/mk9Te9E+hXcUYwE8MOKZ94cwAlTg14f92aWH/uPLF44WBOp4N3hZL0OUXCzaxe
         dgMfvAR9VlbEVFW8KX5mKhObNSUH7uV2/7eCK+MLcA5IHr1rL1Og6Pb7MVvC/1CkxKLl
         /bpYDQ69vuyo4Wil/TkwdoZijDk3pTX2vxJbtUDjZAgZMPG81ewuTADL0O8DNPskD5ZQ
         9BTD2oVDWhmsIvy88MtDWudKlxOQEjRJ+GF1xbx1aYBMjXtVJeI4DAeOVMyecfm2hxn8
         NEDqKeBa15ELkxf3j9Kz7MUCke2KxBBFi303cWp5wPQGp00n7+7AJ8bzZI+yJBZyQujO
         uY8w==
X-Gm-Message-State: AOAM531pdL4Lt5fndK7KAeV9nTCLwcK9iz+JRX9t2ab4Y2Pow9b0Kgde
        5r96yfWcQcjgcMRh7Yd+/cXZ3+J9rA93cy3GDEALnxCx
X-Google-Smtp-Source: ABdhPJzq7sD6mMA21QyhekBRFxWffMRoLh8fU11va4nVPybxmhxHU5cJ9WklMWms2WyqfSb74Y21nwSBnTANJLbmvIk=
X-Received: by 2002:ac2:5327:: with SMTP id f7mr4800600lfh.8.1599761557648;
 Thu, 10 Sep 2020 11:12:37 -0700 (PDT)
MIME-Version: 1.0
References: <20200909162251.15498-1-quentin@isovalent.com>
In-Reply-To: <20200909162251.15498-1-quentin@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 10 Sep 2020 11:12:26 -0700
Message-ID: <CAADnVQLjGgz9sXanrkp2z0-uMETRZN+GPcqf4FLtVgvSPXhVbg@mail.gmail.com>
Subject: Re: [PATCH bpf-next v2 0/2] bpf: detect build errors for man pages
 for bpftool and eBPF helpers
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 9, 2020 at 9:22 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> This set aims at improving the checks for building bpftool's documentation
> (including the man page for eBPF helper functions). The first patch lowers
> the log-level from rst2man and fix the reported informational messages. The
> second one extends the script used to build bpftool in the eBPF selftests,
> so that we also check a documentation build.
>
> This is after a suggestion from Andrii Nakryiko.
>
> v2:
> - Pass rst2man option through a dedicated variable, use it to ask for a
>   non-zero exit value on errors.
> - Also build doc right after bpftool when building (not only running) the
>   selftests.

Applied. Thanks
