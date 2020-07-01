Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39705210428
	for <lists+netdev@lfdr.de>; Wed,  1 Jul 2020 08:47:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgGAGra (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 02:47:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35000 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727807AbgGAGr3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 02:47:29 -0400
Received: from mail-qt1-x841.google.com (mail-qt1-x841.google.com [IPv6:2607:f8b0:4864:20::841])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ADCDBC061755;
        Tue, 30 Jun 2020 23:47:29 -0700 (PDT)
Received: by mail-qt1-x841.google.com with SMTP id u12so17617066qth.12;
        Tue, 30 Jun 2020 23:47:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=mUpty3XYkkCsgIHbIr/54jJGUHiVoKSQ6w1vfMldqro=;
        b=Eze1vYSKE8loBp1CVXGeFx98f/uc6WY7rUKjbnxpi/OMg3HiArvtj5UHc4/4T1CYrn
         O8jGzPqCtwLt2sJBKOCxZEdGZDIx6OJF1WO6ppZ+2XBxLl9jVa8OKGFzaROzcTIHF7ZX
         F8gjQ2SwAD4i66M3oC5eMb2MFwu/U6DDMrR3s5pw4P6XcemQV0UafqejLfU2ZcQxg1R9
         V4pYOohn3WRJW39M18GfQClJUBNBOxMdtQtgsrcGd0Tc/NyKGE0nJc2su/VsGKCDyETu
         0KkvkRvuDr/HruxYP9wwD/if7wFwlRZfXnTClU7S/nKWO1Vui7vF68GpZ9l5cN2D/SDz
         UOnA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=mUpty3XYkkCsgIHbIr/54jJGUHiVoKSQ6w1vfMldqro=;
        b=Yr+DWlCGdeuKe2K4TJzQEgmQiCXd/nlGkSJ6aAAmSGtK83z99ne/l4IMVQ+pAb1tES
         rQc5oAKsPGrCWGRCct8sYfGnISRq52yaIBkSyVmuL9LM1CXnRNxXsxZfUfc6P6UhfFTI
         9HEuLcNUBaELTsebGy5sP+qg2aIEL2dGynROWyUENSvJD8SSB3jPCuB0gER3nVgHIsa/
         yXZBkd8YjMyDz6X1H40TY1PR26Ie/pUwDrbcTgmXuxE0+B3lLw+chDOk+TPXYFM1ZZnx
         CoIkVgvYYU8sZCdo8BTdLUYASBOIC3KCRscL2rNL876v6jWWDqTaHuQUKQXIAbHrtp6M
         D+EA==
X-Gm-Message-State: AOAM531yowEQBU1WcsCcFFTSoEabIkvjXLsL4iaJAgOLuQpczC4cvAPM
        dFg4m6eDzYtIVLMtHApWdhAD/3VxgPUEkEGJJZA=
X-Google-Smtp-Source: ABdhPJwPXhIjz9WnxH7K3q3TDpgbAjEb4mmZKzfcdoulsMcqzrQ4nyX0R8TSEzlJbVh9IiTbGhXAbUbvYVai/t0tDjw=
X-Received: by 2002:ac8:4714:: with SMTP id f20mr24432298qtp.141.1593586048950;
 Tue, 30 Jun 2020 23:47:28 -0700 (PDT)
MIME-Version: 1.0
References: <20200701064527.3158178-1-andriin@fb.com> <20200701064527.3158178-3-andriin@fb.com>
In-Reply-To: <20200701064527.3158178-3-andriin@fb.com>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Tue, 30 Jun 2020 23:47:18 -0700
Message-ID: <CAEf4BzZvfmou6HzrcrawEbypRGzP3t9ufV=e5LRngmLRFqJa1A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 2/3] selftests/bpf: add selftest testin
 btf_dump's mod-stripping output
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>,
        Anton Protopopov <a.s.protopopov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 30, 2020 at 11:45 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> Add selftest validating that .strip_mods=true works.
>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>
> ---

Please ignore this patch, it is a stale copy with a typo in the subject.

[...]
