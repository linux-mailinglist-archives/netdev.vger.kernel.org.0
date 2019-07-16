Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D2AB36B140
	for <lists+netdev@lfdr.de>; Tue, 16 Jul 2019 23:41:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731847AbfGPVk7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Jul 2019 17:40:59 -0400
Received: from mail-qk1-f196.google.com ([209.85.222.196]:37662 "EHLO
        mail-qk1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726794AbfGPVk7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 16 Jul 2019 17:40:59 -0400
Received: by mail-qk1-f196.google.com with SMTP id d15so15825114qkl.4;
        Tue, 16 Jul 2019 14:40:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=O86ZpFw0TkhJylopJ7ym1zEkxJQZTmt3EOoPGiMPUNA=;
        b=I6zFZ6nT2chfBxKdNBkfoiBJOTZWs7/RA5E62y5ACSoLu2VAMC9evx41JAyoqEDbt8
         9+yqskKY1biqIS3X5mQqUsRhA9Ym/yMTow8bAmdu8lZfIf7YUp14Xshad8nWFUiF+FWi
         rHITEflz2cb6zH41jHB0GpA0Ot7EJjEJITUZggC34fTGNy6igoz4ilHTq8h372jrEQ6O
         xmr0QMA3sbx6mutg6/n1MAwRgUfDfDKWCbgCPx8JmDEDH0uoL0mtdIGRB3xd36HtQvak
         ubt6KrHkbQrYzPhKKrvSxmcXWGp0Unq4p5Ior1bgpDRs6Cljj08W2v89hXLjO1w9ghA9
         ejsg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=O86ZpFw0TkhJylopJ7ym1zEkxJQZTmt3EOoPGiMPUNA=;
        b=dYJ0H99n7LHUZtRyHh+QiIv/24RLEo4Hu1RDz2maUCEZlgB9amdWz/I4Gw0z3r72nF
         FR00L7E6k+rh+VCTrf0S5SIWKhqDYJlFwllVch+p9xrph8HbvPiQL6rSEy/VaW6mZ+7Q
         8NaoTD1HlrwBWXm6OYHJC36cSyizJuyXF+sAtNCwyqfO6esdyUoamHI6aOeWskLzrBeC
         I3wQsT9R/duOzQ6DcZGtR9LDLb/mgtmeMQisjE8wLXGe2EjL7vK4RmXSzW41dtD86qlf
         7VHdD0W6ZEZCBk0Dg6uD3QdIJ3Zt6gmknYYks8y49HKSj8NoR6RyrlM9FWIPHDjitCBp
         K2TA==
X-Gm-Message-State: APjAAAUvUqGALsx0O9HrRqkJBU9EEtWpp/Waqs4q3VZQwYQUoI+4MfXi
        XoItlcWBS+yncat6DCJwqLNAahH2JXf06JXEC54=
X-Google-Smtp-Source: APXvYqxlzRJv6yW5nAkxyKDCmWiCV5c/sA3DcmhVVQWuVwAVud+64m65zAbEy50NrGlRe/HvpWgyN8/gp1Xhnl4OHDw=
X-Received: by 2002:a37:bf42:: with SMTP id p63mr23897974qkf.437.1563313257975;
 Tue, 16 Jul 2019 14:40:57 -0700 (PDT)
MIME-Version: 1.0
References: <20190716193837.2808971-1-andriin@fb.com> <20190716195544.GB14834@mini-arch>
In-Reply-To: <20190716195544.GB14834@mini-arch>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 16 Jul 2019 14:40:46 -0700
Message-ID: <CAEf4BzZ4XAdjasYq+JGFHnhwEV3G5UYWBuqKMK1yu1KRLn19MQ@mail.gmail.com>
Subject: Re: [PATCH bpf 1/2] selftests/bpf: fix test_verifier/test_maps make dependencies
To:     Stanislav Fomichev <sdf@fomichev.me>
Cc:     Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@fb.com>,
        Kernel Team <kernel-team@fb.com>,
        Ilya Leoshkevich <iii@linux.ibm.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 16, 2019 at 12:55 PM Stanislav Fomichev <sdf@fomichev.me> wrote:
>
> On 07/16, Andrii Nakryiko wrote:
> > e46fc22e60a4 ("selftests/bpf: make directory prerequisites order-only")
> > exposed existing problem in Makefile for test_verifier and test_maps tests:
> > their dependency on auto-generated header file with a list of all tests wasn't
> > recorded explicitly. This patch fixes these issues.
> Why adding it explicitly fixes it? At least for test_verifier, we have
> the following rule:
>
>         test_verifier.c: $(VERIFIER_TESTS_H)
>
> And there should be implicit/builtin test_verifier -> test_verifier.c
> dependency rule.
>
> Same for maps, I guess:
>
>         $(OUTPUT)/test_maps: map_tests/*.c
>         test_maps.c: $(MAP_TESTS_H)
>
> So why is it not working as is? What I'm I missing?

I don't know exactly why it's not working, but it's clearly because of
that. It's the only difference between how test_progs are set up,
which didn't break, and test_maps/test_verifier, which did.

Feel free to figure it out through a maze of Makefiles why it didn't
work as expected, but this definitely fixed a breakage (at least for
me).
