Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 54A4020694A
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 03:03:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388341AbgFXBC6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 21:02:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388240AbgFXBC5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 21:02:57 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 53ED8C061573;
        Tue, 23 Jun 2020 18:02:57 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id n23so649876ljh.7;
        Tue, 23 Jun 2020 18:02:57 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=ZfjkORTpcf3tAvl4U+UVM7GM+AI0XbxZRU+YKtkIZxk=;
        b=jncS4s5rJ+HKtwZtFZBQQoOU6pEuyHYj8wbU1k/LNZui65o1ol1QaASs1cJdLB8Eg/
         VRNOoDInwluj6tZ075XPaxBTtQnGAATpWTfgF4yfyD36Qvfyh7RmqvwHiNebci/iy5hH
         9oMpN/S/ktRIld/9z0Bshdm9g1iDxvyo4yy5nP7+Vl4Xq8rOjml+qlkoDUZjnHUvfzOH
         0xE/J/QiyiYdnGVod57dJ3PXbEW+LCbBcK7BEg4EikVjvcObPyca844E7dowwk1CSiVc
         1H8xGMsGutNhQDYbRucPM2DLnUcCU1jqSnsIcwIXWq+9VKDzlifdqVRnMF20lllOkmPq
         TyPg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=ZfjkORTpcf3tAvl4U+UVM7GM+AI0XbxZRU+YKtkIZxk=;
        b=r+GBOTQOkX/jNqAS+fwBjWLe1/b7ilKmSiizk/wB9eNHq+dz1ARDH3QNRG028t+tzL
         xhjAGqZChYKVFHyXsDcq86cP5G/5w70h1xPAydPhGDBDyXsYH9RQToG0Eixz/kQLPZ5V
         Auu0bZnBC9J6IteRl7RYH+VW0QZn2UQvT4VTIz74QKV3NTQwZPTwiDzEgOVnODrOy7E9
         LcwDp7ABr369iiHXEnTotGY+30oEJJ9ohSETjz8QX1LPBWnBcy4lyDdmM8hMBzzCMIoJ
         x9wB1OyiJXBk45hBZMliyoIQDO2GZDmLZdGvL2dZScRnmegoPZtUfGqkF6PyB43UWfum
         kYBw==
X-Gm-Message-State: AOAM530NjNmptZNWcQHvsOKRk+kgsvUmYyhG4usu3ohH3pDWQXBLBQ5m
        dbNtgVyBB1mwZKC/sD6Myaq6JsHEb47Oz9wgAsE=
X-Google-Smtp-Source: ABdhPJw62Iq6Z3Kjfjk6T17vMR7BP2pkRPRDwDSFn1GyEBHpbqdcPGPvfmmw8IqByNlGqCGuB6VOpSN5D4wBXk/Wgeo=
X-Received: by 2002:a2e:974a:: with SMTP id f10mr12943432ljj.283.1592960575864;
 Tue, 23 Jun 2020 18:02:55 -0700 (PDT)
MIME-Version: 1.0
References: <20200623153935.6215-1-quentin@isovalent.com>
In-Reply-To: <20200623153935.6215-1-quentin@isovalent.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 23 Jun 2020 18:02:44 -0700
Message-ID: <CAADnVQJwtac0C+DgAhQbVrofSwV7BeG7RoEdQAj5sQZGvxNeLA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix formatting in documentation for BPF helpers
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 8:39 AM Quentin Monnet <quentin@isovalent.com> wrote:
>
> When producing the bpf-helpers.7 man page from the documentation from
> the BPF user space header file, rst2man complains:
>
>     <stdin>:2636: (ERROR/3) Unexpected indentation.
>     <stdin>:2640: (WARNING/2) Block quote ends without a blank line; unexpected unindent.
>
> Let's fix formatting for the relevant chunk (item list in
> bpf_ringbuf_query()'s description), and for a couple other functions.
>
> Signed-off-by: Quentin Monnet <quentin@isovalent.com>
> ---
>  include/uapi/linux/bpf.h | 41 ++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)

Applied to bpf tree and added similar fix to tools/include/.../bpf.h
Please don't forget it next time.
