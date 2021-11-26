Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 319A645E801
	for <lists+netdev@lfdr.de>; Fri, 26 Nov 2021 07:42:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346291AbhKZGp4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Nov 2021 01:45:56 -0500
Received: from mail.kernel.org ([198.145.29.99]:43200 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1347177AbhKZGnz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Nov 2021 01:43:55 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 543B561163;
        Fri, 26 Nov 2021 06:40:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637908843;
        bh=XzAf37h1rnADfzTrJqAT4rHQSajqyx47TxSipD3GmV8=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=X7aQJv/MzkOlP6+G85aEGewE1PUB3t1OId2ecVG9XtGFxdeJx7CZCxXNow2iWkUtb
         8buBx4ub/SEd1R7vVPZ5b1whF5UkWI15anq2IewZVPaFiw88Rw2BbEUhXOw+Qb94sZ
         uCM9GB/mzIje7TEBWIniKdSjFCccAuvJyal1JMXVZ+fhpzjOmpV6jRjIOVTrpkN+Sf
         rskWTgmsfgEUSXN9p1l5PvP8dWLtG8En2W3g5Z1e4nU96NKF4lVWqmK2BmU7Ucqc22
         c0lBaU5FipjBcBhcyHZNradm/en6+LnXFSjuRyKhU6KNE8r6bHF0a7M1hSm/LFyvl1
         hhhRanYabEv0Q==
Received: by mail-yb1-f169.google.com with SMTP id v7so17739745ybq.0;
        Thu, 25 Nov 2021 22:40:43 -0800 (PST)
X-Gm-Message-State: AOAM530hMZ/6fmtpMrGD2W1YPkQDlo5yRHxBC2tS+bjx4iHQ6qVu3J5W
        XoPgVWfzMsyDQUFna9UeniIrOXb8l1noitqo4oQ=
X-Google-Smtp-Source: ABdhPJxIDlEn42Kw+qo0W6K2g0dCJrPzIBGwO99WozlELE4s2VKvvPohtunlhMJWSPUx/3G50zh7PIGTrFT1NHB3/+U=
X-Received: by 2002:a25:bd45:: with SMTP id p5mr13762833ybm.213.1637908842546;
 Thu, 25 Nov 2021 22:40:42 -0800 (PST)
MIME-Version: 1.0
References: <20211119163215.971383-1-hch@lst.de> <20211119163215.971383-5-hch@lst.de>
In-Reply-To: <20211119163215.971383-5-hch@lst.de>
From:   Song Liu <song@kernel.org>
Date:   Thu, 25 Nov 2021 22:40:31 -0800
X-Gmail-Original-Message-ID: <CAPhsuW51eFJd1O=ds7jMcdXJhj9PDkV03gi1zo3--uU3+_YQgA@mail.gmail.com>
Message-ID: <CAPhsuW51eFJd1O=ds7jMcdXJhj9PDkV03gi1zo3--uU3+_YQgA@mail.gmail.com>
Subject: Re: [PATCH 4/5] bpf, docs: move handling of maps to Documentation/bpf/maps.rst
To:     Christoph Hellwig <hch@lst.de>
Cc:     Jonathan Corbet <corbet@lwn.net>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 8:32 AM Christoph Hellwig <hch@lst.de> wrote:
>
> Move the general maps documentation into the maps.rst file from the
> overall networking filter documentation and add a link instead.
>
> Signed-off-by: Christoph Hellwig <hch@lst.de>

Acked-by: Song Liu <songliubraving@fb.com>
