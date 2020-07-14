Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5F6B421F607
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 17:20:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728353AbgGNPTl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jul 2020 11:19:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33514 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725876AbgGNPTl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jul 2020 11:19:41 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C636AC061755;
        Tue, 14 Jul 2020 08:19:40 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id e4so23240602ljn.4;
        Tue, 14 Jul 2020 08:19:40 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=SA0uu4ku+ay9B3/DOo8G+wZzkPjoInJwybqv9U+fLsQ=;
        b=HsC/2aNYjOGT28FimFi2OsEDI/J7edk7ADSK/ixlg5q5ohp+FHd0h5h8WW3sMyVqUz
         SgfdJJsr1SK8Nt9Nkzj4fXpHA35BdlrAK0YvLGVaaovxqk7YfsOGKRmcj7qeXzYQ13s3
         sX+9E5j5si5MhMpITFAKcMwtIwwR6DdMjbyvnCU4VbkqGMH62vC11ACJRKl1qNJJQzT7
         t4DQvA3hk3U5nabYbll+tRUPtyrom9yiZQHDrUesDWPS/3RUG4NuTCZKp1ju5mshb1zd
         klghNmA2wNsF0ZTd65qOGzSnADKYK7jqmMfA0TK7fuKFbjopUdgyeOzvBrtyBptH3RDM
         121w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=SA0uu4ku+ay9B3/DOo8G+wZzkPjoInJwybqv9U+fLsQ=;
        b=VZ3XJSd4PViF7ld//0In6o9XfQy7CtNFjc6jNUk0lmqJH+A7Wx6xF2+KCsfH+QjpgI
         n4NWlRgLrVLmde3ApgqicJ7AOOy/JzNIEfO7kcZXhQKvPCb+j+5VW+g/eptyAp4I335b
         hdaBSOTdM0HIoxnsYaMuLWB4Jt6UFD7YJpA+Jt3nWzQLmhG/+PhI3DLfmHczA/SQvTE2
         wg5cxemdPCyPk7W+ztPqP1SB4g3CqPlxyLNrOBTjslVBRXWOrBWWv4WLyjVbBzrPHSAH
         qUU4f/bnRfGgV/91pb1vBspiQLHL4YVmupOVNoiIpSVJ8CGuOetl0MgwlsNM5BjCZZWD
         THCA==
X-Gm-Message-State: AOAM533GN/gI0jvrkL4tsBr6xEH9j/oROhAKO/+OQ3BoqSEenOCQHH/h
        fU0Jr/uCYSXyhT4F2Chg3lVtu0KWG6wPFLyPDw0=
X-Google-Smtp-Source: ABdhPJybgeZeUwjQ+R5ZESyEhbVkkdhYxfyUvsXwQlCzvDvZXLt1GUHzJr8vTQ61KnfRU/0rEUZHkqfK30RyC1yY85k=
X-Received: by 2002:a2e:8216:: with SMTP id w22mr2640126ljg.2.1594739979123;
 Tue, 14 Jul 2020 08:19:39 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1594734381.git.lorenzo@kernel.org>
In-Reply-To: <cover.1594734381.git.lorenzo@kernel.org>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Tue, 14 Jul 2020 08:19:27 -0700
Message-ID: <CAADnVQLNuStgi45XT0nUDifg7yHxKFn04Ufs=fQr5DYnoMshzQ@mail.gmail.com>
Subject: Re: [PATCH v7 bpf-next 0/9] introduce support for XDP programs in CPUMAP
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Alexei Starovoitov <ast@kernel.org>,
        Jesper Dangaard Brouer <brouer@redhat.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        =?UTF-8?B?VG9rZSBIw7hpbGFuZC1Kw7hyZ2Vuc2Vu?= <toke@redhat.com>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 14, 2020 at 6:56 AM Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> Similar to what David Ahern proposed in [1] for DEVMAPs, introduce the
> capability to attach and run a XDP program to CPUMAP entries.
> The idea behind this feature is to add the possibility to define on which CPU
> run the eBPF program if the underlying hw does not support RSS.
> I respin patch 1/6 from a previous series sent by David [2].
> The functionality has been tested on Marvell Espressobin, i40e and mlx5.
> Detailed tests results can be found here:
> https://github.com/xdp-project/xdp-project/blob/master/areas/cpumap/cpumap04-map-xdp-prog.org
>
> Changes since v6:
> - rebase on top of bpf-next
> - move bpf_cpumap_val and bpf_prog in the first bpf_cpu_map_entry cache-line

fyi. I'm waiting on Daniel to do one more look, since he commented in the past.
