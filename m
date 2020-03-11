Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 56BE3180EF3
	for <lists+netdev@lfdr.de>; Wed, 11 Mar 2020 05:34:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726196AbgCKEeF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Mar 2020 00:34:05 -0400
Received: from mail-qk1-f194.google.com ([209.85.222.194]:44532 "EHLO
        mail-qk1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725958AbgCKEeF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Mar 2020 00:34:05 -0400
Received: by mail-qk1-f194.google.com with SMTP id f198so857441qke.11;
        Tue, 10 Mar 2020 21:34:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=gjw0KBoYU5LrMVELwtpGDmwUO/+u5X+lxTfCA5ZMfT0=;
        b=lQLaby6twMdGKIQ7eMg/iHvYcoEVlAaeIBsyhp/nMf2GoH9TIcpib8RBJKmO8wopYt
         psPX98g15BnmkOEoGzFHANVSX1maKHBWDqXYpAs52sKqXMhKm5PSMVpyRzeN4ntIRsRj
         /7VoLnXshVk5cxmjzTUosHGrMmjLPppF1zdIaHOYyRyTesqgs3A2TZHEA9O8FcIu7xU4
         miRkjSOa28puAaU7r024mVXmOdOH5ZSUkcVXl04RPA2zRjYDVd5rsZxDQbJ8p5JMnzij
         prgcME5P9dwIrfsOr8UVoJe0vgxx6GVbQlCwsOuK33DdphckMBSLVEZbk4qKn2WSPByS
         U0Bg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=gjw0KBoYU5LrMVELwtpGDmwUO/+u5X+lxTfCA5ZMfT0=;
        b=ZDrYiiJ652qeGAAha8QS8BhNFzJjKlH7M3K0q7sJxk8Z1DMCtwfJ7N4+Fogqfgr5gT
         k37tzF+OvTD47MK2mOkl5v2P/0gV8R1hsusEe5Tul/3vgySDBE3a7GwcgwxrN77/GnKg
         RxaJ6kdzqAZ5r3RFsYoi+wzT3Hg5DuPTBsXDrLCLFmWxy9HzCf40jNfqOf6YANWQo13I
         mv4ZhFKIi0M1vlS1nWDzykduQ8NLFVkUooncL/9sdJWaiZSE0nKl712Z9TOczpesUtOn
         ZfBqMeE4fOpxb7tWIFYMi0Jwym4YhdSSXqi1GaRI8f4FubgjoQZFcA/4pamqpSX5KwGG
         XrzA==
X-Gm-Message-State: ANhLgQ0U3PgwbtQrOyNC/l0ax1yhAjlV27xRsAAZDAmqVGPFHCdvz/KX
        AUvv3+ZpnguIxl6Azw64Lj+w0geAaumNLpxcckk=
X-Google-Smtp-Source: ADFU+vsZGFlX051SaRcye9d2hnx6KoUZA1UwcqWpgtlK3sZwBwC2du8AS+ApnY3TM4ARVhfAaGFC4llosNT6iQYwIDE=
X-Received: by 2002:a37:9104:: with SMTP id t4mr1089155qkd.449.1583901244048;
 Tue, 10 Mar 2020 21:34:04 -0700 (PDT)
MIME-Version: 1.0
References: <20200310183624.441788-1-songliubraving@fb.com>
In-Reply-To: <20200310183624.441788-1-songliubraving@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 10 Mar 2020 21:33:52 -0700
Message-ID: <CAEf4BzY2AuYgsxjMtFCfjReFqCkwde0ffy+4B16x-sz6gxmWoA@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/2] Fixes for bpftool-prog-profile
To:     Song Liu <songliubraving@fb.com>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        quentin@isovalent.com, Kernel Team <kernel-team@fb.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Arnaldo Carvalho de Melo <arnaldo.melo@gmail.com>,
        Jiri Olsa <jolsa@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 10, 2020 at 11:36 AM Song Liu <songliubraving@fb.com> wrote:
>
> 1. Fix build for older clang;
> 2. Fix skeleton's dependency on libbpf.
>

Can you please also add tools/bpf/bpftool/profiler.skel.h to .gitignore?

> Song Liu (2):
>   bpftool: only build bpftool-prog-profile with clang >= v11
>   bpftool: skeleton should depend on libbpf
>
>  tools/bpf/bpftool/Makefile | 15 ++++++++++++---
>  tools/bpf/bpftool/prog.c   |  2 ++
>  2 files changed, 14 insertions(+), 3 deletions(-)
>
> --
> 2.17.1
