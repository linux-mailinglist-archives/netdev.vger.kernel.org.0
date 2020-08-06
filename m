Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E41FB23E4B9
	for <lists+netdev@lfdr.de>; Fri,  7 Aug 2020 01:46:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726190AbgHFXq1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 6 Aug 2020 19:46:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51134 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725272AbgHFXq0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 6 Aug 2020 19:46:26 -0400
Received: from mail-lj1-x243.google.com (mail-lj1-x243.google.com [IPv6:2a00:1450:4864:20::243])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6FD91C061574;
        Thu,  6 Aug 2020 16:46:26 -0700 (PDT)
Received: by mail-lj1-x243.google.com with SMTP id v9so233829ljk.6;
        Thu, 06 Aug 2020 16:46:26 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=uHAVjeRlAJMTAqd3XeN2VlGsoTZe6WuhjHZJAhkasJI=;
        b=ZnkAyOIPeI2cbG/Wzp9EXefaJSgPhODJNdh3gc7m4ZL4wyZuvpZlnPfmPaefPPd0Va
         QtkqyrxJ5VjxPWuXxL0lPQPHMTRqaRqDXaVLQEflbzNiWnQ+AQrd4wFMlxsDAL/TYhZv
         gKR+gDFLZt3FGNziWveJjZe7L1G4DAqmcLOpsWmiXxEcQOmgqx6+8rsJX2V4xaBfX1CN
         wQlql+scFimQu7l9CNeeJI7QWEtWBEFP+0S6L5KutYJQy5ThidLsuwWoqFxNNSWkMk8C
         KhnNXzAEGOChYRHVMzf9Wkm0CKNVYPbzZ6jG5k+mL891WcePDPOQ121nLYU82GYGl6jZ
         jmyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=uHAVjeRlAJMTAqd3XeN2VlGsoTZe6WuhjHZJAhkasJI=;
        b=WwV4i+C9kYK2MYSYvq52U4pC7sLoDxZx/1Z6X24c1dyG+MBlyd5uoO22D/verJazkg
         26dQlcFbq+CQeOlqm6YveVSd7WboeX55JZ24g3ItOtMk8VnnRcp3zOIuVLKPdp1XY7+H
         49pT6TyZIXQ37we/eapLxGOwMLeVrARS05BqCAUcleVlVT5+TFSBTLSfyW0EaKI1Qkm7
         MPzKW364a7EFuAJT1QVZKKw4WqlQG9JgMOGBJ44fqOhn4t29VCzmR2OqS32hM+QHeTxs
         L9n/cvLo5y5JvK7GqLF7sGCo/ddJwD4wfu5JLlKk5UAgfekgv7SII7q38WWkMjhKDa99
         nwYw==
X-Gm-Message-State: AOAM533fgQH90m/RN8YXy9m6h5wYnhpNZbTSEmLcrCRIsaG1JX52rhsP
        Ldwuk17ZXXxIE7w59G8VDdRFotDgpjrevzrK07w=
X-Google-Smtp-Source: ABdhPJwLYxOHFJ6nDHtBobre7dMW/iqIRarRxSiefGGRwJa0c2/fEBPT4u1p2tJGOmQVYhsK1sSCoR6qsFic3mXUtBs=
X-Received: by 2002:a2e:a17b:: with SMTP id u27mr5041684ljl.2.1596757584922;
 Thu, 06 Aug 2020 16:46:24 -0700 (PDT)
MIME-Version: 1.0
References: <20200805055056.1457388-1-yhs@fb.com>
In-Reply-To: <20200805055056.1457388-1-yhs@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Thu, 6 Aug 2020 16:46:13 -0700
Message-ID: <CAADnVQJ0Q7R9K9orMkpRWZ3jKSMvTu+jD72Vd=GSXLyAftz3FQ@mail.gmail.com>
Subject: Re: [PATCH bpf v4 0/2] bpf: change uapi for bpf iterator map elements
To:     Yonghong Song <yhs@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Kernel Team <kernel-team@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 4, 2020 at 10:51 PM Yonghong Song <yhs@fb.com> wrote:
>
> Andrii raised a concern that current uapi for bpf iterator map
> element is a little restrictive and not suitable for future potential
> complex customization. This is a valid suggestion, considering people
> may indeed add more complex custimization to the iterator, e.g.,
> cgroup_id + user_id, etc. for task or task_file. Another example might
> be map_id plus additional control so that the bpf iterator may bail
> out a bucket earlier if a bucket has too many elements which may hold
> lock too long and impact other parts of systems.
>
> Patch #1 modified uapi with kernel changes. Patch #2
> adjusted libbpf api accordingly.
>
> Changelogs:
>   v3 -> v4:
>     . add a forward declaration of bpf_iter_link_info in
>       tools/lib/bpf/bpf.h in case that libbpf is built against
>       not-latest uapi bpf.h.
>     . target the patch set to "bpf" instead of "bpf-next"

Applied. Thanks
