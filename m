Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 398A819990D
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 16:57:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730615AbgCaO5r (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 10:57:47 -0400
Received: from mail-il1-f195.google.com ([209.85.166.195]:42764 "EHLO
        mail-il1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730511AbgCaO5q (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Mar 2020 10:57:46 -0400
Received: by mail-il1-f195.google.com with SMTP id f16so19682498ilj.9
        for <netdev@vger.kernel.org>; Tue, 31 Mar 2020 07:57:46 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cs.washington.edu; s=goo201206;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=jfQhccziDudVsLMP6kJ733ATOZ31NAdEJFty0F3uQqA=;
        b=PlQeasvJWSo4iQz94dt77xWDMNTQ+jYB7zJRbPPBNjYM5612R+MSy+yWtI+wboPQln
         U1BFVvavpFJ8O79mRN/SrlTA5PjRB0JO6ysbJ1GtuFMkdY5QO9moEBnkW9xb7/Fvwki7
         aKBt4twfTSpIC3oAK7rvmfhTng3NCSJDnzGfA=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=jfQhccziDudVsLMP6kJ733ATOZ31NAdEJFty0F3uQqA=;
        b=pjL7BKt8T84LReefYl/424klT0WZG3mJk3gPEKEzrVYFZLqy3GLe0sjjwiuwEGx0Mi
         UtSCuPdpFWdAsCHZk0LWFbJRZ7VM20E8491ICGD6VVVIQYr8wKSRg91LrYJMGsnEmisv
         8EMgSU48gNMd51g5vxbvd84YoxovXUqoXSkvicQLHEBQJnbVEBz1Mww/ItihoJq6Rjp7
         HNVkSvitluQVdsEmjKr0YxVGamOHkb8sdghrQlGv+ZPOnc7NUyC5ZHuWyf2ftKEOTEDG
         dGJFbSbHyHwJL9I4wCRPNX/EvHsqL1+BO6VQkKkJTcuyL0+ec1COhVsFAuW0CSzrY6iS
         qhNA==
X-Gm-Message-State: ANhLgQ3dRB2O47tslvtCTzL5cWEp3zLwQECRR9NJfibarsIeQ1o89Lzh
        /drf6X9YFsTbRwyS+kB253sXjTxRA232w2csdI98MA==
X-Google-Smtp-Source: ADFU+vuFxmGgOn08tmoANgBI3LNTetni9UTrAwOiEISPhiM5Omw//ihMU/JryRy+gVy9Ac1Y5taJ1VHJyEY+hsM2LGs=
X-Received: by 2002:a05:6e02:551:: with SMTP id i17mr16403204ils.280.1585666665915;
 Tue, 31 Mar 2020 07:57:45 -0700 (PDT)
MIME-Version: 1.0
References: <20200331101046.23252-1-bjorn.topel@gmail.com>
In-Reply-To: <20200331101046.23252-1-bjorn.topel@gmail.com>
From:   Luke Nelson <lukenels@cs.washington.edu>
Date:   Tue, 31 Mar 2020 07:57:35 -0700
Message-ID: <CADasFoDZq=+34MSjPD7gqEDhW8Zm_zFWAamHZc7ZsAeYT2=Lrg@mail.gmail.com>
Subject: Re: [PATCH bpf] riscv: remove BPF JIT for nommu builds
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Cc:     Netdev <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        linux-riscv@lists.infradead.org, Damien.LeMoal@wdc.com,
        hch@infradead.org, kbuild test robot <lkp@intel.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thanks for looking into this!

Acked-by: Luke Nelson <luke.r.nels@gmail.com>
