Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 462631E8EDC
	for <lists+netdev@lfdr.de>; Sat, 30 May 2020 09:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728783AbgE3HUC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 30 May 2020 03:20:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56700 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726843AbgE3HUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 30 May 2020 03:20:02 -0400
Received: from mail-qt1-x844.google.com (mail-qt1-x844.google.com [IPv6:2607:f8b0:4864:20::844])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 23E01C03E969;
        Sat, 30 May 2020 00:20:02 -0700 (PDT)
Received: by mail-qt1-x844.google.com with SMTP id g18so3869363qtu.13;
        Sat, 30 May 2020 00:20:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=+GY3oCb8k4ZoxDmYR0zizW+h7H+4Er+voGLPiRHg8M8=;
        b=hJQE1SgHlmzaVnCtS1DWmA8sQMIcVIXy2N7dht8Sjpyh/FF85sdPAtlsbgMEIkmrgt
         rLOCw0gvdMHB1JV2ES3yOJwLBfWlPbkB7yxBL5/6EskjH0clE2Tjxlkj/RI8VJBVNfBd
         2EY0N3nrsB7ycr//5+UkpRqQN2Z/rtzy5HnA9ILJm4/9/rvTl7/BUZqFN7eYJK8/jvCG
         gkmPNFLJPhKZiOsTSgak2INqfWKIN/eU9Ij+xwq46NCqNfTPxH5nUTZ3e4iSG7w0WQIz
         veS5sFCGdxWA66eo6bodZMV3XEvGhz8jD2iQia/XIRka1DZphlkYkhPfhdQ0S0OW6UNR
         cZ1w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=+GY3oCb8k4ZoxDmYR0zizW+h7H+4Er+voGLPiRHg8M8=;
        b=CpIrMURYKz7Zmeqaw3a6gjWx3iD6VMIRzc+zfh//F5QkwPeN0/W/uMZCXHSEAgX3X4
         lldVSdeQ72/QinT+3jjOEPf0evG5WZjbAKAufysV3yWzfLal818oPw0MtB+gptlm3/Nx
         KLH+NIHCSG/oROzmKPxLEgDWRnMQ77tjUqLvZ48iJkIo5xuu/cJFvc/AZRKnxXB5pInl
         usMO3XUeDGiI3uwMJXF6HjX4+2xudqqTX+A5qYiMLKQ73K5uIaRmBkE8lATKPDheCRT+
         G/JJ2mOR74FOYs+9UJjWhC3Adf/cgLrpKYDTI8/362b/8Xl2KdiXWMbXH39f0+HniI1H
         zODg==
X-Gm-Message-State: AOAM533EQFhPu4q7RMpihUTJ9V7kPq1x+Shwo2IpB5UN4J+XXH3uTCY5
        DQ8FlgJ2pnseeXW1pv0mT4liRBrk4OGmGL8z8NI=
X-Google-Smtp-Source: ABdhPJzRapl46s0lFpw2Nt19ca5Rav7hgzuMh0a2e39z81FiHo9a5+iizMErLv3laisFfPSWpXKDA+tJ+Wqdm+Ow3go=
X-Received: by 2002:ac8:4b63:: with SMTP id g3mr4424717qts.171.1590823201227;
 Sat, 30 May 2020 00:20:01 -0700 (PDT)
MIME-Version: 1.0
References: <159076794319.1387573.8722376887638960093.stgit@firesoul> <159076798566.1387573.8417040652693679408.stgit@firesoul>
In-Reply-To: <159076798566.1387573.8417040652693679408.stgit@firesoul>
From:   Andrii Nakryiko <andrii.nakryiko@gmail.com>
Date:   Sat, 30 May 2020 00:19:50 -0700
Message-ID: <CAEf4BzbL1ftGZ9x0hvFDc-PGNexTuMv67VxT=q2NF0y6im6+cg@mail.gmail.com>
Subject: Re: [PATCH bpf-next RFC 2/3] bpf: devmap dynamic map-value storage
 area based on BTF
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     David Ahern <dsahern@gmail.com>, bpf <bpf@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 29, 2020 at 8:59 AM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> The devmap map-value can be read from BPF-prog side, and could be used for a
> storage area per device. This could e.g. contain info on headers that need

If BPF program needs a storage area per device, why can't it just use
a separate map or just plain array (both keyed by ifindex) to store
whatever it needs per-device? It's not clear why this flexibility and
complexity is needed from the description above.

> to be added when packet egress this device.
>
> This patchset adds a dynamic storage member to struct bpf_devmap_val. More
> importantly the struct bpf_devmap_val is made dynamic via leveraging and
> requiring BTF for struct sizes above 4. The only mandatory struct member is
> 'ifindex' with a fixed offset of zero.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> ---
>  kernel/bpf/devmap.c |  216 ++++++++++++++++++++++++++++++++++++++++++++-------
>  1 file changed, 185 insertions(+), 31 deletions(-)
>

[...]
