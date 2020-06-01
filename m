Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EAEA1EB177
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:02:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729107AbgFAWCV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:02:21 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728336AbgFAWCU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:02:20 -0400
Received: from mail-lj1-x242.google.com (mail-lj1-x242.google.com [IPv6:2a00:1450:4864:20::242])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0E66BC061A0E;
        Mon,  1 Jun 2020 15:02:20 -0700 (PDT)
Received: by mail-lj1-x242.google.com with SMTP id z6so10048717ljm.13;
        Mon, 01 Jun 2020 15:02:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=28IDDw8HM/QpEtquXlco0ovqKhcVd+N9TrIHHVHfSZc=;
        b=N0WYEz0mVwPtvxMgILf0uU9UOt7cknWnAKxxl/JVG+o2pJHHQHI2VeaTLbv8wirlf4
         cmeUvmOlS+iLpu2Ay4fUt9eSHuy5MfWnb+v+hFGFxdg8YnjUNu5IUJGFLLtoQqBKvG6q
         DoN8o3zlVaNhyCFztWK19QJ/DW8CUgiuULvYW6erl97TlDRNRpy0+Lx+5zVSdTPWML9p
         +ek8+QlRInSt9ymZjbV5QGj2d6PUjP3L8iNGhR7BiRx4TjlVloUCYAZqgCGlOMTvsBzW
         XWiSgD2hdIymKBxNFfYlacjphRLNI62lyHy3D5fyCZKvoJUh3PhMGaw6JnS01254hGcZ
         xX5Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=28IDDw8HM/QpEtquXlco0ovqKhcVd+N9TrIHHVHfSZc=;
        b=rYxPZJjXUN9B7OIFnXay3zTVTKYz7JEtPiiaCE5Rj1EC1/yRH+s62DhMkxQnVMBMYr
         56TEKzRfOjTts5f0dprGCcjU5q9ECpECSo5K4p1dgrp1ajQp+luNKQujKg+Ouvm/sYsL
         wB28yDYCAfkapALQK+mBWeB+Zw5n5zy2MrcBl+bB28tlmXyWmqr6FctInvswyKU3jM65
         1a5U6JHdQq4JLeflN52feRGAxCBbYnNmPd/M2AZ20jZizixbFwBuyEIivBqiTuNjnPpK
         awemPm5CAy4WjjabM2mEPHjD3F1DWX/o5Mo+63te4PHxIriCq+OcpHWA+/3l+E1q9FY+
         FORg==
X-Gm-Message-State: AOAM533mi1rIoqug2uvfkojkhGGqR7BOdRQOVwfuYit0GysFCrubU0Fh
        Jxi8yzwjedGougyqDM+ePLkXAWFrbqr04tUBIRU=
X-Google-Smtp-Source: ABdhPJygItLNvavDHJ6vXhjXK/4zzTwyPSrq04ENAeMiA2fy2e9S2Scw0THZlGwqwV10gSNGDNmuLLDSh+6pEcdHZDA=
X-Received: by 2002:a2e:150e:: with SMTP id s14mr11038853ljd.290.1591048938509;
 Mon, 01 Jun 2020 15:02:18 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590871065.git.fejes@inf.elte.hu>
In-Reply-To: <cover.1590871065.git.fejes@inf.elte.hu>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 15:02:07 -0700
Message-ID: <CAADnVQJvPAibc3a98hfeFxu3OKC98+FQdCKmovgVvgeExBq2VQ@mail.gmail.com>
Subject: Re: [PATCH v2 net-next 0/3] Extending bpf_setsockopt with
 SO_BINDTODEVICE sockopt
To:     Ferenc Fejes <fejes@inf.elte.hu>
Cc:     Network Development <netdev@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Andrii Nakryiko <andrii.nakryiko@gmail.com>,
        Stanislav Fomichev <sdf@google.com>,
        Martin KaFai Lau <kafai@fb.com>,
        "David S . Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, May 30, 2020 at 2:11 PM Ferenc Fejes <fejes@inf.elte.hu> wrote:
>
> This option makes it possible to programatically bind sockets
> to netdevices. With the help of this option sockets
> of VRF unaware applications could be distributed between
> multiple VRFs with an eBPF program. This lets the applications
> benefit from multiple possible routes.
>
> v2:
> - splitting up the patch to three parts
> - lock_sk parameter for optional locking in sock_bindtoindex - Stanislav Fomichev
> - testing the SO_BINDTODEVICE option - Andrii Nakryiko

Applied. Thanks
