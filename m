Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4FF336BBB5
	for <lists+netdev@lfdr.de>; Tue, 27 Apr 2021 00:34:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237147AbhDZWfg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 26 Apr 2021 18:35:36 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42066 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232161AbhDZWff (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 26 Apr 2021 18:35:35 -0400
Received: from mail-pg1-x535.google.com (mail-pg1-x535.google.com [IPv6:2607:f8b0:4864:20::535])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6ED9EC061574;
        Mon, 26 Apr 2021 15:34:53 -0700 (PDT)
Received: by mail-pg1-x535.google.com with SMTP id y32so40991832pga.11;
        Mon, 26 Apr 2021 15:34:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=ihh1qaX3Rr60u3zkAccWLpR6/wkZAHaJctKdrvn8oaw=;
        b=eiGIusn6YKDpuSXxYcyO5uSJfxQikAuIgbTifIuKG6h81ZQWrVgsPHgD0gxDiefMyn
         mXGm5ShR8kBSIBvsowHgoSjfK7Qdwr0bnMHVmqHVXvgzjBlNUCQhNp19idV77jTYYweY
         yiSN/I88wjx92y4pPbzDamfnuVsyN2KyVoMcC4yO+THjy7OpXBrLN9huJ7qrEmiPm0Pz
         ABVPKkgXTGkXJZzzvKDHy4cXIsy+IGOCfeWgrKqj9ycl2OaKpBNsNozZ8KjyKpv8cQx8
         X/qBIqHsYgtWxeRhcdu9PGFEBfiMWRadg5xhyNxE9MIiR019lw8Fy8I/MdDA6k72w+jX
         vqwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=ihh1qaX3Rr60u3zkAccWLpR6/wkZAHaJctKdrvn8oaw=;
        b=tWJTTkz7hmZVg49yzJEACnSx0uFrQXXA3L0Bt+/6iV4VkKV6Xh7wMqCzXlC0lzDzwQ
         tGEhQU3IMzOCs7q7dR2oFU3L8SD9lnXrTiX46tpeHu+/OwFM4FTaWVyxleHdca0v+fYk
         Q+4EAbB51X5O25hc+myHgymcWZCGdewISB8UYTMsgU/HQ6Nk6uVHgu8mVxFjzob4zj6d
         bf6azti9pleUS7SlTvhs22N3QANodMlQh0zbpLs8Jh4JVBdqiigYA5IHz9icxKEkoLRj
         134K78eXBi5yE68ca/eRS51l2brz9eehAlQqOd2QLHMwtwGJUhT50+/M+csqBrHnEe6+
         L/YA==
X-Gm-Message-State: AOAM532Q4PHoCUhE9oBV3+d6bv/brqBGrtGI3ElqdE+zdMl6IDY6bMyh
        UAEaU9bTsDlu7RED9+Mlds8=
X-Google-Smtp-Source: ABdhPJxT6HNh2Wszl65WZl/OItHg8JwNKUQd44N0EHxdrmFlLfKOANw+UumwD8UbI9pH+g4ctLinMw==
X-Received: by 2002:a63:d146:: with SMTP id c6mr19159912pgj.131.1619476492955;
        Mon, 26 Apr 2021 15:34:52 -0700 (PDT)
Received: from ast-mbp.dhcp.thefacebook.com ([2620:10d:c090:400::5:1ad0])
        by smtp.gmail.com with ESMTPSA id v123sm588856pfb.80.2021.04.26.15.34.51
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 26 Apr 2021 15:34:52 -0700 (PDT)
Date:   Mon, 26 Apr 2021 15:34:49 -0700
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
To:     Andrii Nakryiko <andrii.nakryiko@gmail.com>
Cc:     Yonghong Song <yhs@fb.com>, Andrii Nakryiko <andrii@kernel.org>,
        bpf <bpf@vger.kernel.org>, Networking <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Subject: Re: [PATCH v2 bpf-next 2/6] libbpf: rename static variables during
 linking
Message-ID: <20210426223449.5njjmcjpu63chqbb@ast-mbp.dhcp.thefacebook.com>
References: <20210423185357.1992756-3-andrii@kernel.org>
 <2b398ad6-31be-8997-4115-851d79f2d0d2@fb.com>
 <CAEf4BzYDiuh+OLcRKfcZDSL6esu6dK8js8pudHKvtMvAxS1=WQ@mail.gmail.com>
 <065e8768-b066-185f-48f9-7ca8f15a2547@fb.com>
 <CAADnVQ+h9eS0P9Jb0QZQ374WxNSF=jhFAiBV7czqhnJxV51m6A@mail.gmail.com>
 <CAEf4BzadCR+QFy4UY8NSVFjGJF4CszhjjZ48XeeqrfX3aYTnkA@mail.gmail.com>
 <CAADnVQKo+efxMvgrqYqVvUEgiz_GXgBVOt4ddPTw_mLuvr2HUw@mail.gmail.com>
 <CAEf4BzZifOFHr4gozUuSFTh7rTWu2cE_-L4H1shLV5OKyQ92uw@mail.gmail.com>
 <CAADnVQ+h78QijAjbkNqAWn+TAFxrd6vE=mXqWRcy815hkTFvOw@mail.gmail.com>
 <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAEf4BzZOmCgmbYDUGA-s5AF6XJFkT1xKinY3Jax3Zm2OLNmguA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 26, 2021 at 08:44:04AM -0700, Andrii Nakryiko wrote:
> 
> >
> > > Static maps are slightly different, because we use SEC() which marks
> > > them as used, so they should always be present.
> >
> > yes. The used attribute makes the compiler keep the data,
> > but it can still inline it and lose the reference in the .text.
> 
> At least if the map is actually used with helpers (e.g.,
> bpf_map_lookup_elem(&map, ...)) it would be invalid for compiler to do
> anything crazy with that map reference, because compiler has no
> visibility into what opaque helpers do with that memory. So I don't
> think it can alias multiple maps, for instance. So I think static maps
> should be fine.

Yeah. That makes sense.

> See above about passing a pointer to map into black box functions. I'd
> bet that the compiler can't merge together two different references at
> least because of that.
> 
> For static maps, btw, just like for static functions and vars, there
> is no symbol, it's an offset into .maps section. We use that offset to
> identify the map itself.

Ok. Sounds like there is a desire to expose both static and static volatile
into skeleton.
Sure, but let's make it such the linking step doesn't change the skeleton.
Imagine a project that using single .bpf.c file and skeleton.
It grows and wants to split itself into multiple .bpf.c.
If such split would change the skeleton generated var/map names
it would be annoying user experience.

I see few options to avoid that:
- keeping the btf names as-is during linking
The final .o can have multiple vars and maps with the same name.
The skeleton gen can see the name collision and disambiguate them.
Here I think it's important to give users a choice. Blindly appending
file name is not ideal.
How to express it cleanly in .bpf.c? I don't know. SEC() would be a bit
ugly. May be similar to core flavors? ___1 and ___2 ? Also not ideal.
- another option is to fail skeleton gen if names conflict.
This way the users wold be able to link just fine and traditonal C style
linker behavior will be preserved, but if the user wants a skeleton
then the static map names across .bpf.c files shouldn't conflict.
imo that's reasonable restriction.
- maybe adopt __hidden for vars and maps? Only not hidden (which is default now)
would be seen in skeleton?
