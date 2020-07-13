Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BB58A21E314
	for <lists+netdev@lfdr.de>; Tue, 14 Jul 2020 00:37:10 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726376AbgGMWhJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Jul 2020 18:37:09 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48612 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726345AbgGMWhI (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Jul 2020 18:37:08 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E747CC061755;
        Mon, 13 Jul 2020 15:37:07 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id h22so20034701lji.9;
        Mon, 13 Jul 2020 15:37:07 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc:content-transfer-encoding;
        bh=mQ68tEF0aXub5iTkGyZvUgZkxTf5PGYNz+vVCkZeKeA=;
        b=WLA5fD3mWettYOszNS7xtt9QP1g/9387NvBjxwBoMEXdYnOkYKPhf8mhMrSQg+3gg1
         r4RaNYM6Mn3vM4dBv9eSLwoHM7l0N5PoIvL1ndEPPBPGRjgSuFfiu+rLh9UlH7fqcMDb
         wnWQvWSzSEQWaLFq623XuV1p27jWyzjiAUUcB/R66agrHTzLxDoJc9Gkn1xOHyVvkI+e
         Z3ikYL14FnzdPEe2sP9FXX9JAankXjUcus47BNd6gB/cbiLNc4bqiPW5u7RGuVTcchqV
         xiMq4BKMEYspn8DTDV80a3wjxhfN6BzAucEv2cQvcvYxQfta3vMz6qk4PEsrszolaIUo
         mBQg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc:content-transfer-encoding;
        bh=mQ68tEF0aXub5iTkGyZvUgZkxTf5PGYNz+vVCkZeKeA=;
        b=TDZiquwU0YSsd+ndE7fyw95a9nRl1m6AkSTf0S2YlZGPcO5VCmWhJOtf2FiOY/Svy0
         OJlqTca493jXMmqXbjf8vCh95FdqsTRQVuxOI772L9JkVMjsJA3THDXW84ZjqXX4KTvr
         +1tSj01V+QU+nHdhhlJyeskrS18VfUPjwOaiDMSf305toEn10XEhT6XhvWwoRHF7qfv3
         tpa5ffSVtIMlUa62ShvOsg6p5fjK7R7oLUouf09232o75sFITHbZlDStriqnSKlQoHnU
         mQB5EGkONNjo/kzWLEu/Y1nzgsmSV2i+r9sA5egmrI7IcXZ70MBs/r/cj+JJwF5QBg8/
         upXg==
X-Gm-Message-State: AOAM532aqga5VJoMNdKC3iTc8+Sx6bDj7ND0epolY/VEf6ZlrIuHDLeG
        cULfqDWeDrmcs49vjmgosk8mCNTp9JfqxB5hGSOx2A==
X-Google-Smtp-Source: ABdhPJyNmNXA+GXXH9sE4/otEBMaHF8EmiUo3j/qm1ogX7R4s2h82Hmil0zdX5bkeZsjjTN0b5vDQi5o5cwRRKyHrik=
X-Received: by 2002:a2e:8357:: with SMTP id l23mr783491ljh.290.1594679826037;
 Mon, 13 Jul 2020 15:37:06 -0700 (PDT)
MIME-Version: 1.0
References: <20200708072835.4427-1-ciara.loftus@intel.com> <e9e077dd-5bb1-dbce-de2e-ed8f46ac9b75@intel.com>
In-Reply-To: <e9e077dd-5bb1-dbce-de2e-ed8f46ac9b75@intel.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 13 Jul 2020 15:36:54 -0700
Message-ID: <CAADnVQ+DxfG-Jee0F21-BtDHUQy=jRFWP1eAJPB+FJDKZs1W4A@mail.gmail.com>
Subject: Re: [PATCH bpf-next 0/3] xsk: add new statistics
To:     =?UTF-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn.topel@intel.com>
Cc:     Ciara Loftus <ciara.loftus@intel.com>, bpf <bpf@vger.kernel.org>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Network Development <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 8, 2020 at 4:20 AM Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com=
> wrote:
>
>
>
> On 2020-07-08 09:28, Ciara Loftus wrote:
> > This series introduces new statistics for af_xdp:
> > 1. drops due to rx ring being full
> > 2. drops due to fill ring being empty
> > 3. failures pulling an item from the tx ring
> >
> > These statistics should assist users debugging and troubleshooting
> > peformance issues and packet drops.
> >
> > The statistics are made available though the getsockopt and xsk_diag
> > interfaces, and the ability to dump these extended statistics is made
> > available in the xdpsock application via the --extra-stats or -x flag.
> >
> > A separate patch which will add ss/iproute2 support will follow.
> >
>
> +netdev
>
> Thanks for working on this, Ciara!
>
> For the series:
> Acked-by: Bj=C3=B6rn T=C3=B6pel <bjorn.topel@intel.com>

Applied. Thanks
