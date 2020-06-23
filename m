Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F1C12205A7A
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 20:25:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733242AbgFWSZN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Jun 2020 14:25:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34500 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732549AbgFWSZL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Jun 2020 14:25:11 -0400
Received: from mail-qv1-xf42.google.com (mail-qv1-xf42.google.com [IPv6:2607:f8b0:4864:20::f42])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BF52CC061573;
        Tue, 23 Jun 2020 11:25:10 -0700 (PDT)
Received: by mail-qv1-xf42.google.com with SMTP id p7so2814488qvl.4;
        Tue, 23 Jun 2020 11:25:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=UYgY1JcDt8lnxw3Zpin+GyVm+3/Jge7pi3uW9+Nj39U=;
        b=ciGX+awxCF97jOlvFgcJtPdSOEHEumu6Ms0gF+onsMedt0W2koX9j7l/+1lS/YMdo4
         zCcnxTPqsTcnISF6p0RkArTGIwzzn4RhP13JKkd2WBRClLNdSt5r2Bkv8c3Unljd5kbK
         dbKDH9Kba2CXOFFQyVLAGS8t2vXoGoBSEnZtZnXNmieVl1GoYyJZbJg4WrdOOGde5Orr
         ndVCr5er8mWVBHeWNj30iJUQhSO/epVqugBpU7my6AMZQyatw0SF//wheWjHzma2uvUq
         g2BXYYykVv6UD/MEwHns6fR/dobqpsAxYTmAgsqir+mCqz9wQnL2kh/0WhMKr+ZQNEtG
         SBMA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=UYgY1JcDt8lnxw3Zpin+GyVm+3/Jge7pi3uW9+Nj39U=;
        b=qsjQaRD4lzLVA6vRVVvw86xxJTKd8kLAkpTGvRStunZtlIangDFmrCzt07sjmA3d/N
         6LhZ1DzCy2yia3//c8uHqBrg74Xd4OhEAF9xs3eeuKjjPNQLpmAcELJ0R0NebFVgrMTH
         5V6DkdVULXlgxgo9WJRw8Q4zOrE9/PNPho7F6GDIRYMKXxSrRnSp6prwvtbiltB+pnBF
         zcnES6rlNkbYE1lVHhMqqlaxUHKc546etBgoks2tj5lfXDZAXbcvqYJL+mkJPlKPLrBo
         KGyyf/yF1GoxiZlqoEMFrRc4jg6NaqBcnmHGjmXiKDrIxoX2qOm9YaLtndtcdwHSJRYs
         BQ+Q==
X-Gm-Message-State: AOAM533iJuysFx1ahkG4fwGyGkiPofSlE9qU4B/AwXlOJnBco6XFz2TM
        5kSpy4d0b3vZDkogOUvWYQ8N5pQbcievgdjr6oQ=
X-Google-Smtp-Source: ABdhPJwtQlpjYe0oJadZmNwwbtNG1aSgcrNKqu8qJXYxJD5P5q0xcCJ1a8InLSFENZq7iG/jNXuIqdW05ZD6pOHIxhQ=
X-Received: by 2002:ad4:598f:: with SMTP id ek15mr27668748qvb.196.1592936709954;
 Tue, 23 Jun 2020 11:25:09 -0700 (PDT)
MIME-Version: 1.0
References: <20200623153935.6215-1-quentin@isovalent.com>
In-Reply-To: <20200623153935.6215-1-quentin@isovalent.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 23 Jun 2020 11:24:58 -0700
Message-ID: <CAEf4BzbPDa6gZf05R2W6ibreibWNTf2Y=V-NENV9L0g6zk_+sA@mail.gmail.com>
Subject: Re: [PATCH bpf] bpf: fix formatting in documentation for BPF helpers
To:     Quentin Monnet <quentin@isovalent.com>
Cc:     Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andriin@fb.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 23, 2020 at 8:41 AM Quentin Monnet <quentin@isovalent.com> wrote:
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

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  include/uapi/linux/bpf.h | 41 ++++++++++++++++++++--------------------
>  1 file changed, 21 insertions(+), 20 deletions(-)
>

[...]
