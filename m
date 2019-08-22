Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C5BCB9A1D2
	for <lists+netdev@lfdr.de>; Thu, 22 Aug 2019 23:12:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389823AbfHVVMb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 22 Aug 2019 17:12:31 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:46496 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729718AbfHVVMb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 22 Aug 2019 17:12:31 -0400
Received: by mail-qt1-f195.google.com with SMTP id j15so9259154qtl.13;
        Thu, 22 Aug 2019 14:12:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=orPyMCzXeHsYXHUl5miKDkVoD0ryzkBoiARAwCBXnx0=;
        b=AnjVGBlLdnEch8CV/RolTNuqf/mXbgnvEhoD1RyozoQ+TLSXEFbbgGhKiKIb49NZNS
         QvxnXb2JQDURKL7H/ZoGJiFYJpKz2k8E3FQwn1CP/SPyGothGlTsG0/iMgLrM4NtVQf3
         fqgaBonqDMjvcwW2WL5SwlqWOOJjpfBm34EiX8WAI9g9gxg+GxvqWfulpmabb7N+JgSb
         Wl+4tUiJhEFARMQ2w6VPQO/bBg9BKvB9BUNM/E4ie/R+4r3pOrte/AWOdU/VxcA8WgSb
         iw3WW1yUkrBCFnTLntYMUUYLnzDBF5adjfAduDm1ihOFtxK8ve7WoxFCAziAtEKrAHho
         x1DA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=orPyMCzXeHsYXHUl5miKDkVoD0ryzkBoiARAwCBXnx0=;
        b=roJaqHlhqgyIFJmhJo9weKw78oD3/6dcvl9TRgBMuSf7oKGxqpa+XI7759lgG9WgX+
         cRNsOTEvPLlQBExmER2LRxpg3nrrasx+g3m20AIR8eAGRmTK9hSDQkXJbLToIV81w6nd
         U/ec+cZF33qcgMWQ8sX46Im1VU/ndARwy4SsCoi6qw1Pu2x0I+Ykjni3O0isIYY98SS/
         76qwYjfcjKb1Y1R9IB78MqTimte+GBCqXpYegwyyZy94Ek4+k6p4aIYdEpEqiwvtvqcR
         6z4qCy8qvRqzZJsd2e/ufCYTIlH6vTGF1cI8LD2o9g0oi1vqzpSB6URa+NkWk0QydBy1
         CKlw==
X-Gm-Message-State: APjAAAVOgJpS3aPo/RsIUoI8nvs4r3PIVGh+xHyJUYed0BUgdod4oULL
        BQRGCkpSApTuI6Hr5hzvcba0hyJn8ZrjGDC9neE=
X-Google-Smtp-Source: APXvYqzMFLCPqn5KnYlmfFhNmCYf6KvXFa0b/WlFjyeUyS9HCqJVnGOB7dqCmpNt/BJ1XqUWYUx1k9MRj7k7WGfzxwM=
X-Received: by 2002:a05:6214:13a1:: with SMTP id h1mr1319454qvz.190.1566508349936;
 Thu, 22 Aug 2019 14:12:29 -0700 (PDT)
MIME-Version: 1.0
References: <25ca9c48-1ac9-daa1-8472-0a53e4beed6a@web.de>
In-Reply-To: <25ca9c48-1ac9-daa1-8472-0a53e4beed6a@web.de>
From:   Song Liu <liu.song.a23@gmail.com>
Date:   Thu, 22 Aug 2019 14:12:19 -0700
Message-ID: <CAPhsuW5c7xn9hW70C3BV3GqysEzScJfpw11yRSMx39T5+Hxd5Q@mail.gmail.com>
Subject: =?UTF-8?Q?Re=3A_=5BPATCH=5D_net=2Fipv4=2Ftcp=5Fbpf=3A_Delete_an_unnecessary_?=
        =?UTF-8?Q?check_before_the_function_call_=E2=80=9Cconsume=5Fskb=E2=80=9D?=
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Daniel Borkmann <daniel@iogearbox.net>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Hideaki Yoshifuji <yoshfuji@linux-ipv6.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Aug 22, 2019 at 10:19 AM Markus Elfring <Markus.Elfring@web.de> wrote:
>
> From: Markus Elfring <elfring@users.sourceforge.net>
> Date: Thu, 22 Aug 2019 18:20:42 +0200
>
> The consume_skb() function performs also input parameter validation.
> Thus the test around the call is not needed.
>
> This issue was detected by using the Coccinelle software.
>
> Signed-off-by: Markus Elfring <elfring@users.sourceforge.net>

Acked-by: Song Liu <songliubraving@fb.com>
