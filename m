Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E77540FE89
	for <lists+netdev@lfdr.de>; Fri, 17 Sep 2021 19:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245153AbhIQRUe (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Sep 2021 13:20:34 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S238596AbhIQRUV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Sep 2021 13:20:21 -0400
Received: from mail-qk1-x729.google.com (mail-qk1-x729.google.com [IPv6:2607:f8b0:4864:20::729])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 60566C061766;
        Fri, 17 Sep 2021 10:18:58 -0700 (PDT)
Received: by mail-qk1-x729.google.com with SMTP id 72so7906359qkk.7;
        Fri, 17 Sep 2021 10:18:58 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=dYb2BZZV5QZRj/vCF5Pconj91/y7PtBTQGXA05qL2nU=;
        b=Qim5f7i8X697lymtns/mCW+/tumzkctJOgEl67atf318GP1lGjxTsMqfS7EF06+a1W
         Iw0/SDq48Dfdc8Cg04HlJ+1i2ceXvqosAkcFUVcOUz5ttfk2h052knQQBpJAfjT7EVry
         dgvDw4sdqjEpvR0QrjebnYksrElh2WhA5R8hfTgRIbGYBdZflwscZ9qIUU0FjNmodPix
         FKigxPMhRLmaGDIdicHvuSmbpr8IRy2bEmkhPwkeMXoeepPiq1mpR3znaPzwCCps7NFg
         G0yMwMQc7AG3rVELX3r3KCsu1+rSDU8hBAEcSdwmhKqQTeCn1bzyCVFpvk7q6AHz9qPY
         bqiA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=dYb2BZZV5QZRj/vCF5Pconj91/y7PtBTQGXA05qL2nU=;
        b=nqC5nfPGu/EU1VwZGEPeNiCX6Z77W3D1FFLZcNXfz6r3NdYwijkYcJX5qHEJ4YAuQG
         Dsd4cJBM1fJpp8kL9hIstirmpkDB4XyMUpozPRm6PgHAA82ZAT7E9OirnKwjgDbG9Gft
         05hdQ4yaTh4dLphg1ep8K/clb4BpH4Lsh/hitkTsOLfS5fC5ZVQ0DFY2/qkybOtPca44
         1AfpxZRHc/oNtE4pBxVJgJ2DZe7+x10gc4L9WCGW5lQmWNt1ia2I4pzhYpcs2R0nKp+p
         Derpcxe7KCvdOez80FUz2kY9pNxQ2MWvyTY3asdscmarrXxY9sh8btd75ni33bgAKg+W
         o0Pg==
X-Gm-Message-State: AOAM5328iGjCUFmuxdCJSdiuo2MCH2I8Gibknmcd2Lm/Lez8Z3s0b7C0
        l6qrItqMPRGWN1Z8iKgP4x9ha2ZwoNsm2qJZXnM=
X-Google-Smtp-Source: ABdhPJxpAzPLHZ6zsEg1qSbGUgHYbRqDSia/GUjrrLAeK05HCPRHvGVUUCdcKN6J/2/9tXrls8EgUr2qzUY/O0FIXpg=
X-Received: by 2002:a25:840d:: with SMTP id u13mr1005772ybk.455.1631899137563;
 Fri, 17 Sep 2021 10:18:57 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1631785820.git.mchehab+huawei@kernel.org> <fe4bb3cf5984623976b3e8d751657bc1bcbb598e.1631785820.git.mchehab+huawei@kernel.org>
In-Reply-To: <fe4bb3cf5984623976b3e8d751657bc1bcbb598e.1631785820.git.mchehab+huawei@kernel.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Sep 2021 10:18:46 -0700
Message-ID: <CAEf4Bzaf3ShnjKDQ3Dw4X977aaDO2Awe=x-uNMxFLdEvqWK9bg@mail.gmail.com>
Subject: Re: [PATCH v2 08/23] tools: bpftool: update bpftool-prog.rst reference
To:     Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Andrii Nakryiko <andrii@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Beckett <david.beckett@netronome.com>,
        Jakub Kicinski <kuba@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Martin KaFai Lau <kafai@fb.com>,
        Quentin Monnet <quentin@isovalent.com>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        bpf <bpf@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Sep 16, 2021 at 2:55 AM Mauro Carvalho Chehab
<mchehab+huawei@kernel.org> wrote:
>
> The file name: Documentation/bpftool-prog.rst
> should be, instead: tools/bpf/bpftool/Documentation/bpftool-prog.rst.
>
> Update its cross-reference accordingly.
>
> Fixes: a2b5944fb4e0 ("selftests/bpf: Check consistency between bpftool source, doc, completion")
> Fixes: ff69c21a85a4 ("tools: bpftool: add documentation")
> Signed-off-by: Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
> ---
>  tools/testing/selftests/bpf/test_bpftool_synctypes.py | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/test_bpftool_synctypes.py b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> index be54b7335a76..27a2c369a798 100755
> --- a/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> +++ b/tools/testing/selftests/bpf/test_bpftool_synctypes.py
> @@ -374,7 +374,7 @@ class ManProgExtractor(ManPageExtractor):
>      """
>      An extractor for bpftool-prog.rst.
>      """
> -    filename = os.path.join(BPFTOOL_DIR, 'Documentation/bpftool-prog.rst')
> +    filename = os.path.join(BPFTOOL_DIR, 'tools/bpf/bpftool/Documentation/bpftool-prog.rst')

Same as on another patch, this is wrong, BPFTOOL_DIR points to the
correct bpftool path already

>
>      def get_attach_types(self):
>          return self.get_rst_list('ATTACH_TYPE')
> --
> 2.31.1
>
