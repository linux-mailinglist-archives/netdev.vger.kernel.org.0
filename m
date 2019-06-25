Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0EBEC52786
	for <lists+netdev@lfdr.de>; Tue, 25 Jun 2019 11:08:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730523AbfFYJIZ convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 25 Jun 2019 05:08:25 -0400
Received: from mail-ed1-f66.google.com ([209.85.208.66]:34012 "EHLO
        mail-ed1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729360AbfFYJIY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jun 2019 05:08:24 -0400
Received: by mail-ed1-f66.google.com with SMTP id s49so26098379edb.1
        for <netdev@vger.kernel.org>; Tue, 25 Jun 2019 02:08:23 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=p826yz7xrmb/dtygzOjwnRJYVkCeMNGjVrwTiRVJZzU=;
        b=VmvUXyrn+PYDZ/A7GczXeuRBzxQakGT8BScFcQP6XsQwfuANEvMQfWu8lfOPYiI5dB
         ZzUvCa3vFFCYU1AR+Fqogbqw/cH+w6wQwq+ZHKoAMM93w6QXVf9OXUh1H3ZkyeuQ1T5K
         Q1tPPNp+meobo2voOeuDoQUfCidHz6REno6uaYIMD4cxBd6oBe8/ExJNrzFhkTD20G8S
         A3U8hfZvMBr98Eb5ipS3543H2pD6BAWCkFG0xyULYwgc+PUA5tSqWMpvxhKprvJEr5V4
         04M6l7wvIAeER7d9LAWhFySerQhR6q8FyUcHd1IigLN/Q8zBxWNAVZVW8uXUFqlqQT38
         /3kQ==
X-Gm-Message-State: APjAAAUSIm/CT8vME22ldXWomVgLRdOBL0hzObgliNWO8Y8gHS5QBlVc
        NKRKCQDNOCUVf92C+jNv228RkA==
X-Google-Smtp-Source: APXvYqyCdZoQKzpVGmDEkqwdoquR6Zo4COTDT/sVVSdAEBy6ZA14go0xVZPkihAf1uP+MoeTw/lBAA==
X-Received: by 2002:a50:fb86:: with SMTP id e6mr43394900edq.203.1561453703247;
        Tue, 25 Jun 2019 02:08:23 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id g16sm4598529edc.76.2019.06.25.02.08.22
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Tue, 25 Jun 2019 02:08:22 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 19CAB1800B0; Tue, 25 Jun 2019 11:08:22 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     "Daniel T. Lee" <danieltimlee@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Alexei Starovoitov <ast@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH v2] samples: bpf: make the use of xdp samples consistent
In-Reply-To: <20190625005536.2516-1-danieltimlee@gmail.com>
References: <20190625005536.2516-1-danieltimlee@gmail.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Tue, 25 Jun 2019 11:08:22 +0200
Message-ID: <878stqdoc9.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

"Daniel T. Lee" <danieltimlee@gmail.com> writes:

> Currently, each xdp samples are inconsistent in the use.
> Most of the samples fetch the interface with it's name.
> (ex. xdp1, xdp2skb, xdp_redirect_cpu, xdp_sample_pkts, etc.)
>
> But some of the xdp samples are fetching the interface with
> ifindex by command argument.
>
> This commit enables xdp samples to fetch interface with it's name
> without changing the original index interface fetching.
> (<ifname|ifindex> fetching in the same way as xdp_sample_pkts_user.c does.)
>
> Signed-off-by: Daniel T. Lee <danieltimlee@gmail.com>
> ---
> Changes in v2:
>   - added xdp_redirect_user.c, xdp_redirect_map_user.c

Great, thanks!

Acked-by: Toke Høiland-Jørgensen <toke@redhat.com>
