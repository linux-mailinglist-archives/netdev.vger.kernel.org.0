Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA7221EB17E
	for <lists+netdev@lfdr.de>; Tue,  2 Jun 2020 00:06:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728857AbgFAWGU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Jun 2020 18:06:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47930 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728182AbgFAWGU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Jun 2020 18:06:20 -0400
Received: from mail-lj1-x241.google.com (mail-lj1-x241.google.com [IPv6:2a00:1450:4864:20::241])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C751C061A0E;
        Mon,  1 Jun 2020 15:06:19 -0700 (PDT)
Received: by mail-lj1-x241.google.com with SMTP id z13so10127692ljn.7;
        Mon, 01 Jun 2020 15:06:19 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=g8fTfzku4cmaQ4elf2pu5Gi7XjUlMRAcUFCJBczo6I0=;
        b=KquswAhQw1Z0tJRwt1ihVLtUz6GAHHQhFkw2v6QvHzduKAGkn982ungTwMmzJINY5t
         NzD+MA9kQIW9dlvChkv5+hzBOkW0O5QdvXOG6AV+nGbetYgII1mSEnL7ot6AF+KeE6pT
         OK/tCjLIMfJd6vpHNQ/3IgRT4+K9eCWSZwJ8b6hjY3pQ9gbscrm1+B7+rzUML3R1z5Jh
         /5YCVjr4rcWzMOwVptaw5j1ods+GADPf7fwVVnVp6KcrUdN4l83SBfPdXevsY0yLlUVC
         QtW7jgRjp6mQwNnuOyzysKpmUTQdyqwl3mFVSRiVTUZ3xPi7uWcQWPtXAZu2H6J+wwpk
         Vjyw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=g8fTfzku4cmaQ4elf2pu5Gi7XjUlMRAcUFCJBczo6I0=;
        b=dlepOyNKGBB2fUiwp3M3pI3RDBaFYp6jUql6vyN5hnLFiu7k5ut75TSoaTbXphw6Ih
         znpm5HXgVUPUP/ZSH6W6swZx04Rk/gLz+hXUdZY1vB2gDI9ZsOcLU0Q93xrx1PlCBzb1
         wI/xI4uALHcxjyLXqR6pnfU2lt8lJ64mis1fiqzqzY9xQ450wi3oa8We2GgufCV3VuNQ
         WMf+ric9Rp/Puolu+8tfFb2q5rJs8Joo7UNPukocipGNd97TlZ3lP9MZmSZCzA8Pebww
         RGswYiNJVSdsUNy3RPou9PBswKXb6eFkEldYPdZTSm65ljLLPJnaFvicocrz/hlCYNQO
         Ss3Q==
X-Gm-Message-State: AOAM531QdkPvSq6kmhccU5Zn/pBZv9/+56Qn/GM5sSRqtpBCku0L3yll
        3TI/pVnGo40NNJWrbJaiNEbbHnmyCJhL6YCJ4L8=
X-Google-Smtp-Source: ABdhPJz+tVeEsvMZd9r7ENqzSDWqfG/5Ija9yAQrEa7pVYDLLePVRK4lhOnz6YKRzKLmdgoYr6Aft/9m5HQWg4SHkU4=
X-Received: by 2002:a2e:150e:: with SMTP id s14mr11044645ljd.290.1591049177933;
 Mon, 01 Jun 2020 15:06:17 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1590698295.git.lorenzo@kernel.org> <6344f739be0d1a08ab2b9607584c4d5478c8c083.1590698295.git.lorenzo@kernel.org>
 <20200528231214.43832c20@carbon>
In-Reply-To: <20200528231214.43832c20@carbon>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Mon, 1 Jun 2020 15:06:06 -0700
Message-ID: <CAADnVQK4ugJQ_yDrVTWNtN+vFMN4rr0znobJdNgoUqK2sCBGSQ@mail.gmail.com>
Subject: Re: [PATCH v3 bpf-next 2/2] xdp: rename convert_to_xdp_frame in xdp_convert_buff_to_frame
To:     Jesper Dangaard Brouer <brouer@redhat.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Daniel Borkmann <daniel@iogearbox.net>,
        lorenzo.bianconi@redhat.com, David Ahern <dsahern@kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 28, 2020 at 2:12 PM Jesper Dangaard Brouer
<brouer@redhat.com> wrote:
>
> On Thu, 28 May 2020 22:47:29 +0200
> Lorenzo Bianconi <lorenzo@kernel.org> wrote:
>
> > In order to use standard 'xdp' prefix, rename convert_to_xdp_frame
> > utility routine in xdp_convert_buff_to_frame and replace all the
> > occurrences
> >
> > Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
>
> Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

Applied. Thanks
