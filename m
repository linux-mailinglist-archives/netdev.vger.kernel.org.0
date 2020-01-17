Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B6F61141167
	for <lists+netdev@lfdr.de>; Fri, 17 Jan 2020 20:04:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729393AbgAQTEQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 17 Jan 2020 14:04:16 -0500
Received: from mail-qv1-f66.google.com ([209.85.219.66]:36886 "EHLO
        mail-qv1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726761AbgAQTEQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 17 Jan 2020 14:04:16 -0500
Received: by mail-qv1-f66.google.com with SMTP id f16so11181809qvi.4;
        Fri, 17 Jan 2020 11:04:15 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=2TyqnVKgCpnAzYxZYQ5Gu1m+D2HzlM/LR6pu3UE0Tdg=;
        b=H13NDTeLZDHPjCTmdN+sPOqFSNcrxiz33NP9zKhrOPg3rJ9xTj56AhcOi5fsuJzNgs
         eXZ+BRl7FYZjB51qLqZF+gJziceM8RbmINA+i0+SHk35xJw+YvA627UbtCA91jnvP5MY
         LHoGSfxmzL+0UU1zA60klmIZ3Y6CpWudk0YTNq3jNW/lxcRSBCQ5kPwSIeuWItZ1/Ox9
         8q+9dZmDUUnMW32rVfE4VgZpWemKrG30VcL1XERIC0gPTF0uvCmr0m7RtkGoLIoriCRg
         KeTQZbxQqAEDa+U+9++1vNPQz/aL7kMwiCvx7Ney9aJJUmSaLfPuoTerotVnBPidlqjE
         UbxA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=2TyqnVKgCpnAzYxZYQ5Gu1m+D2HzlM/LR6pu3UE0Tdg=;
        b=PtJHezs62SDQyDCHXYccI6XFWfITkFt3BPcKDAQ21hPDBv83JBRp75LvbGogkHDcnM
         p1mqFzLjAltH2b+Wo6iAlZhU1xi8POU74WfuSQvDUNy1J0OKn8WeeuntAAd3ARtkC4wt
         PdWyit+TxROERMdi9xBRe36F4AVHkEL0ljGWKMQJJJPifcIMzNo3zc1ym4LaNCue+VkA
         Cia5h0elHobLS29qNir1thFwyF97KWKqpfOzYulJe7i8flS1JjmldIjmiU8yoqPvJ5WE
         /dubJOcmN53VrJkxsBpRyxAajbLSVrfjrYumJP5+PjX2DObAqc1jsG77uUEEIhCEcfmB
         0vew==
X-Gm-Message-State: APjAAAUrPvVA+ORI5hPCr411rw1Osc3CJZ6NEmSbM6xRgDowtg0b7BTK
        wlfp+Azw2+Mm9hTmxrw41rvzfNcEneD2OMIWaDs=
X-Google-Smtp-Source: APXvYqys1yZn7qtzvlO+odfcQVVBz5OAn3g5S0jGUo90bYW3y/EiXfjaLe4SePkZgLSdIjFzk1fMecNqAEY/+KRafx8=
X-Received: by 2002:ad4:4e34:: with SMTP id dm20mr9345451qvb.163.1579287854685;
 Fri, 17 Jan 2020 11:04:14 -0800 (PST)
MIME-Version: 1.0
References: <20200117165330.17015-1-daniel.diaz@linaro.org> <20200117165330.17015-3-daniel.diaz@linaro.org>
In-Reply-To: <20200117165330.17015-3-daniel.diaz@linaro.org>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Fri, 17 Jan 2020 11:04:03 -0800
Message-ID: <CAEf4BzbKMJOGGv19jCakZusQ-R5pstPo0bSpns5k-mFm9b0W_Q@mail.gmail.com>
Subject: Re: [PATCH 3/3] selftests/bpf: Build urandom_read with LDFLAGS and LDLIBS
To:     =?UTF-8?B?RGFuaWVsIETDrWF6?= <daniel.diaz@linaro.org>
Cc:     Shuah Khan <shuah@kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andriin@fb.com>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <netdev@vger.kernel.org>,
        "open list:BPF (Safe dynamic programs and tools)" 
        <bpf@vger.kernel.org>, open list <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Jan 17, 2020 at 8:55 AM Daniel D=C3=ADaz <daniel.diaz@linaro.org> w=
rote:
>
> During cross-compilation, it was discovered that LDFLAGS and
> LDLIBS were not being used while building binaries, leading
> to defaults which were not necessarily correct.
>
> OpenEmbedded reported this kind of problem:
>   ERROR: QA Issue: No GNU_HASH in the ELF binary [...], didn't pass LDFLA=
GS?
>
> Signed-off-by: Daniel D=C3=ADaz <daniel.diaz@linaro.org>
> ---

Acked-by: Andrii Nakryiko <andriin@fb.com>

>  tools/testing/selftests/bpf/Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
>
> diff --git a/tools/testing/selftests/bpf/Makefile b/tools/testing/selftes=
ts/bpf/Makefile
> index e2fd6f8d579c..f1740113d5dc 100644
> --- a/tools/testing/selftests/bpf/Makefile
> +++ b/tools/testing/selftests/bpf/Makefile
> @@ -88,7 +88,7 @@ $(notdir $(TEST_GEN_PROGS)                             =
               \
>          $(TEST_CUSTOM_PROGS)): %: $(OUTPUT)/% ;
>
>  $(OUTPUT)/urandom_read: urandom_read.c
> -       $(CC) -o $@ $< -Wl,--build-id
> +       $(CC) $(LDFLAGS) -o $@ $< $(LDLIBS) -Wl,--build-id
>
>  $(OUTPUT)/test_stub.o: test_stub.c
>         $(CC) -c $(CFLAGS) -o $@ $<
> --
> 2.20.1
>
