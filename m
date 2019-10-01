Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 30E78C3118
	for <lists+netdev@lfdr.de>; Tue,  1 Oct 2019 12:18:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730402AbfJAKRr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Oct 2019 06:17:47 -0400
Received: from mail-qk1-f193.google.com ([209.85.222.193]:46098 "EHLO
        mail-qk1-f193.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJAKRq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Oct 2019 06:17:46 -0400
Received: by mail-qk1-f193.google.com with SMTP id 201so10603973qkd.13;
        Tue, 01 Oct 2019 03:17:45 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=1XTVdrOmV1no1NximF6x4JToT7Z0gqeikJEk6LhVXx0=;
        b=clLx+LrvjCskroKu8+i3lksRlmy4EV1mdasaIHrzfweLGCRy8liLVlThudd4vBPE2X
         bFXBYrChOSbq2+6ab+qmo7TUMM9erAe3C26fqSNJ2bsDOgbUV6GZwcLi37UiXrqJQu2N
         vqPB8d/cwfa4pLeIDtSQ5ZMt2hsWpdmifAKm7Ew8fMnnlT9RDSVoiS6u8WhUvWhZspCN
         KGvchZWLTspbBiZwPk1sWpu3wroZqokY1+eXHeqlS3kNUpd7+Vx7jsJQlTDcLb25890g
         QfPF8yLvRgwpBgmvkIz4aFIzrjKOJPhpY5bOeL8ZAahxOhM3UUsBzCHV1KNfECNjVuO1
         u6sw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=1XTVdrOmV1no1NximF6x4JToT7Z0gqeikJEk6LhVXx0=;
        b=XkrFhXS5soKXAdbVPZLJPKL99A69qHX8qsCGmr52G+/4UPPYV/r413rODXlIrcwd5V
         c2fyE3ftmwMs4TFbQsNJ907NmbFFE4V+6c8ZgJPkudztnD2PR6igv4YDczvLfF6IL2yl
         F8OFMIlOSPMeO1AH6MVzaus8xdw6fPb/lBOU+mFFbw7IFKC1Uf2Eub1YsW0AoQD6dFT3
         rPxmRuDDMfGk4ESjB9BWj1v5Ygv9iwlwYUhvFmjL/+f+GHpGoGr0M4azUnIbD1ATDbpg
         Xm8kFdbAJVA73RF1SGRNe1Szm39oi5PWtlGLL2yEha3+k+521bTk612ggxkuOXBVyF74
         KCuw==
X-Gm-Message-State: APjAAAWGZJO5KUXabE13nol5ydVUWYUTqDpvvMRcWuv/w7d9yHQCtem4
        evEB2B/F5V2bhe0FyR+/iJ+1+7fUlisH45thv2XV9/JeB0CBrA==
X-Google-Smtp-Source: APXvYqxVw7tb+xvjwLWAH80CttooWcvHoBzihRL2jjYn01P8YCPFIeLXsb9Da/SUFtmEbOjSeOm+9ohvGTuv8xY5D2E=
X-Received: by 2002:a37:4b02:: with SMTP id y2mr5012794qka.493.1569925065228;
 Tue, 01 Oct 2019 03:17:45 -0700 (PDT)
MIME-Version: 1.0
References: <20191001101429.24965-1-bjorn.topel@gmail.com>
In-Reply-To: <20191001101429.24965-1-bjorn.topel@gmail.com>
From:   =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@gmail.com>
Date:   Tue, 1 Oct 2019 12:17:33 +0200
Message-ID: <CAJ+HfNjSPeRrbibG8LtyFOQAtm+Bu425PO5Co+tHn0PkS5-gcg@mail.gmail.com>
Subject: Re: [PATCH bpf] samples/bpf: kbuild: add CONFIG_SAMPLE_BPF Kconfig
To:     Netdev <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Cc:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>,
        linux-kbuild@vger.kernel.org, bpf <bpf@vger.kernel.org>,
        yamada.masahiro@socionext.com
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 1 Oct 2019 at 12:14, Bj=C3=B6rn T=C3=B6pel <bjorn.topel@gmail.com> =
wrote:
>
> From: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>
>
> This commit makes it possible to build the BPF samples via a Kconfig
> option, CONFIG_SAMPLE_BPF. Further, it fixes that samples/bpf/ could
> not be built due to a missing samples/Makefile subdir-y entry, after
> the introduction of commit 394053f4a4b3 ("kbuild: make single targets
> work more correctly").
>
> Signed-off-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

I didn't add a Fixes:-tag for the kbuild commit above; The fix is a
fallout from the kbuild change.
