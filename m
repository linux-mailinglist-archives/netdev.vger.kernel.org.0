Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A59EA85270
	for <lists+netdev@lfdr.de>; Wed,  7 Aug 2019 19:53:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2389008AbfHGRwy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Aug 2019 13:52:54 -0400
Received: from mail-ot1-f66.google.com ([209.85.210.66]:42493 "EHLO
        mail-ot1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729278AbfHGRwy (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Aug 2019 13:52:54 -0400
Received: by mail-ot1-f66.google.com with SMTP id l15so107746274otn.9;
        Wed, 07 Aug 2019 10:52:53 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=4OipG1K63huoeX1jCZJUYK9UoS1KcXQ3eXJurjjUymU=;
        b=nYng0W1voe40QXExVJajwBETe+az5o4FZ9ySYkVDNmrDBllwYqCVL+S9gqvMHxLmh5
         oE4XZl11agKrwM44VI6xiekW9Vh/QQgOboyq0Fxggm1O/O7hrJ18iaqzBysbt4gNyOQq
         vB/vNt0lgnbeE1Tl7fbDjYx/Cs6tS6CPFGUrcuFV/4i9w6OPbvgfjIkqYhBYoITy+PQ2
         +V+R6hx73z8PPHn4YCo0hYL6+Gn5BZWMqb/cZuniWjEVXpkHwPUG7fKl2t06eSloorjX
         8nbH9+FqxMVSoPTmSh9ul6Bjd96d9qz5QYiP64r2ABT9asVJygmyoSEfhsFnp4EUIGgF
         JTMg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=4OipG1K63huoeX1jCZJUYK9UoS1KcXQ3eXJurjjUymU=;
        b=BBLsR2U1sqPpkQDfXifA8a0O0sHFARVtrSos6ozjQMdaCcI8cSMMtiKP3I2lZexHbH
         hrA+1303LlamIksDCYKM1BGqDrUtMLjYdenjXwxZTFe37MTZz6etqtRpP234LMnG0dbs
         UsmjR8u6QjKjNUsOpPwHMWcAJBlUl06/Wrf02W73adbkkXYsIc+lnEPa1tus6XgNv+y3
         cF3uH1+5RurDqm1BtEG4wdQ845IYNopn/Hk+vr2QpH/i+NJAXc++Pw3OI3ZQ+AiLtF7W
         1prlhRv4ZLfyTgb6AW3D4B6sg7e0mabSB+vlt1fY2vw/p80iM1+DonWa0gePHL7lLB0e
         dxNQ==
X-Gm-Message-State: APjAAAUneznlYT1RK+H5HbhQsCUdkgGdpt4P0WmXU29JTaj0I3cymJW8
        KdeaPf4yMY7G4+0PBdmqbBW3OD20/NDdtgRYYIg=
X-Google-Smtp-Source: APXvYqzxNb2B1mDuLJAVNqyhG0iN54WDp80TcddrQWXRxBW7q/LiSa3sNpMXl7UJhdeAQmRdzgSPwtjHVv8W2sZjfrg=
X-Received: by 2002:a02:ce35:: with SMTP id v21mr11151835jar.108.1565200373481;
 Wed, 07 Aug 2019 10:52:53 -0700 (PDT)
MIME-Version: 1.0
References: <156518133219.5636.728822418668658886.stgit@firesoul> <156518137803.5636.11766023213864836956.stgit@firesoul>
In-Reply-To: <156518137803.5636.11766023213864836956.stgit@firesoul>
From:   Y Song <ys114321@gmail.com>
Date:   Wed, 7 Aug 2019 10:52:17 -0700
Message-ID: <CAH3MdRVXYjfTHcCrhTYmt1hjN21bdL=OquOtfuw-+5cvaJ4_Rw@mail.gmail.com>
Subject: Re: [bpf-next PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to
 be xdp_tx_ports
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     netdev <netdev@vger.kernel.org>,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>,
        Xdp <xdp-newbies@vger.kernel.org>, a.s.protopopov@gmail.com,
        David Ahern <dsahern@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 7, 2019 at 5:37 AM Jesper Dangaard Brouer <brouer@redhat.com> wrote:
>
> The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
> which only have a single TX port. Change name to xdp_tx_ports
> to make it more descriptive.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>

Acked-by: Yonghong Song <yhs@fb.com>
