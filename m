Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D43B31D9FD6
	for <lists+netdev@lfdr.de>; Tue, 19 May 2020 20:45:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727975AbgESSo0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 May 2020 14:44:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40206 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727939AbgESSoZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 May 2020 14:44:25 -0400
Received: from mail-lf1-x144.google.com (mail-lf1-x144.google.com [IPv6:2a00:1450:4864:20::144])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 004AAC08C5C0;
        Tue, 19 May 2020 11:44:24 -0700 (PDT)
Received: by mail-lf1-x144.google.com with SMTP id h26so401219lfg.6;
        Tue, 19 May 2020 11:44:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=hKupQ7+fi3Z2Nzu15kZUtQT/75gJ3YSPs+QCUvPsvmA=;
        b=kH2uq89WQkud5wZEV/ypwKyzm+JPvvXGXo0Py2IJjTuQYVc6ZiDzex8lDr5qmVWsND
         Q5QqMjMgac+NVvArfMXk/uy96e3rth97iBLJylI2zOp5F3cGC6UbFblji6hivHTUwXy3
         TMHPmW288q2b4GbnMEviZsyihroY4+VNOmdZRnBHL35IqnSkvNRg4S9EMIb2HPPUSjOR
         iEZYivCvH1u1zKpwmP6V6KsGWrLqUSIdmsnAP4RBUyKfZWOQDHy3IcfIcZ2HUyz3Wp2U
         t3rT2tOa+xLWaOep9BoXynFKmOUw09I4yfCMH90cCjJiaKhWUTLRKA+XhasUomdiUmae
         ZERA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=hKupQ7+fi3Z2Nzu15kZUtQT/75gJ3YSPs+QCUvPsvmA=;
        b=Kl2/BSk/f1l2GUHgXw+OF8MMlrDgQQdaCeecYntch4dTBzYSQG6rFeQCFJFp1y4Gio
         SI7x+yVKgGZi0x8avdqVMaR9NfX8aFvZvRGWoErcI/RCuF3USbs1pOoSmidRgX6T04ut
         uCT3U4JVQbdU6Er50eWrVGOwqju6QwiLCrXySMV+DWBEnTQf/BAeXStyhSqkqsY3AKle
         yQ3yy9PVDsvCSAhEVwQCY18d3zZn1g4/LOt2s9Z4Pfoig9Euxj7vtzU2R9PsVCKl0QjF
         9yQ072AP7sTDtg+XmZq2MMyD8+6RQ6owsi3lA4WmAF8NiSDyhZGDEKl+LjXmuCnaWDAS
         uV5g==
X-Gm-Message-State: AOAM5321GzOVuTWy78eD+DmQo1Assc/anxUuRscL6H8uk2lFfpHPjBTs
        byXe3/+1GFLXspq03XLoqD4UdkWx4XkUkYxe6C0=
X-Google-Smtp-Source: ABdhPJxFdYAu/trwXbY4ykY3alxbjmUsf6nRL81oD2iHI6TZgeeOe8Cor0D0Y9pCS/OxVl7qzvBYPw3FS2Nws0T6Jsk=
X-Received: by 2002:a19:103:: with SMTP id 3mr169041lfb.196.1589913863488;
 Tue, 19 May 2020 11:44:23 -0700 (PDT)
MIME-Version: 1.0
References: <20200518234516.3915052-1-andriin@fb.com>
In-Reply-To: <20200518234516.3915052-1-andriin@fb.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 19 May 2020 11:44:11 -0700
Message-ID: <CAADnVQJs7R9_bfUvMyksXnD70cG8omTRC-upDOpxcAVZqs9VYg@mail.gmail.com>
Subject: Re: [PATCH bpf-next] selftest/bpf: make bpf_iter selftest compilable
 against old vmlinux.h
To:     Andrii Nakryiko <andriin@fb.com>
Cc:     bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@fb.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Kernel Team <kernel-team@fb.com>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Yonghong Song <yhs@fb.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 18, 2020 at 4:49 PM Andrii Nakryiko <andriin@fb.com> wrote:
>
> It's good to be able to compile bpf_iter selftest even on systems that don't
> have the very latest vmlinux.h, e.g., for libbpf tests against older kernels in
> Travis CI. To that extent, re-define bpf_iter_meta and corresponding bpf_iter
> context structs in each selftest. To avoid type clashes with vmlinux.h, rename
> vmlinux.h's definitions to get them out of the way.
>
> Cc: Jesper Dangaard Brouer <brouer@redhat.com>
> Cc: Yonghong Song <yhs@fb.com>
> Signed-off-by: Andrii Nakryiko <andriin@fb.com>

Applied. Thanks
