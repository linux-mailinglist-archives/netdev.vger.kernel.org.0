Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 318E2B2362
	for <lists+netdev@lfdr.de>; Fri, 13 Sep 2019 17:29:28 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388915AbfIMP3U (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 13 Sep 2019 11:29:20 -0400
Received: from mail.kernel.org ([198.145.29.99]:52168 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2388205AbfIMP3T (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 13 Sep 2019 11:29:19 -0400
Received: from mail-qt1-f172.google.com (mail-qt1-f172.google.com [209.85.160.172])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 21FA92084F
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 15:29:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1568388559;
        bh=uU/QWtP+Cn7/ELIT1pAg5+DQ8xTZWPdZYy9cQiqiwlQ=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=enGvBUt7MYpCCjc1IkeAG5KzfaJ2gitV2P+fzLyt8kvNf88ap1/ggXWYNDGNmHCKb
         6Y98C+qGTb8POodJLJLF1CEY1YtByQFYoYRR7uJpKmM0ueOP0KN3t5+8+eyc5vBKkp
         RO/i1JTXJ5BA8EzfJ2qamBOQ05D2uEsvhLHFab5I=
Received: by mail-qt1-f172.google.com with SMTP id l22so34342092qtp.10
        for <netdev@vger.kernel.org>; Fri, 13 Sep 2019 08:29:19 -0700 (PDT)
X-Gm-Message-State: APjAAAV0xwPQQ2YUxcdJx2zotn7HB5sUKrLCZmz1U284hzLAzGIGamdf
        XlRaJyusYDtAz5faqJU13e1DDlFtwQTNSTxs7rg=
X-Google-Smtp-Source: APXvYqwGPkNp+87dl1Llp+qnth62NH2mikGIKyxuLczzlnQkguulByWHhuj05E4fYpl+g0mqfhUx6cna/7bP0Ev+M6c=
X-Received: by 2002:a0c:9051:: with SMTP id o75mr31723879qvo.147.1568388558243;
 Fri, 13 Sep 2019 08:29:18 -0700 (PDT)
MIME-Version: 1.0
References: <20190913124727.3277-1-paul.durrant@citrix.com> <CAHd7Wqw6bQbzR2gvzGM+bBgVQ8HHQPCBJppSWWqHT7S7Dp27qg@mail.gmail.com>
In-Reply-To: <CAHd7Wqw6bQbzR2gvzGM+bBgVQ8HHQPCBJppSWWqHT7S7Dp27qg@mail.gmail.com>
From:   Wei Liu <wei.liu@kernel.org>
Date:   Fri, 13 Sep 2019 16:29:13 +0100
X-Gmail-Original-Message-ID: <CAHd7Wqw_aoftSS=RQG9v5pDypfBwvZe9zJAPBifggNDTo=xXpw@mail.gmail.com>
Message-ID: <CAHd7Wqw_aoftSS=RQG9v5pDypfBwvZe9zJAPBifggNDTo=xXpw@mail.gmail.com>
Subject: Re: [PATCH net-next] MAINTAINERS: xen-netback: update my email address
To:     Wei Liu <wei.liu@kernel.org>
Cc:     Paul Durrant <paul.durrant@citrix.com>, netdev@vger.kernel.org,
        xen-devel@lists.xenproject.org
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 13 Sep 2019 at 16:28, Wei Liu <wei.liu@kernel.org> wrote:
>
> On Fri, 13 Sep 2019 at 13:47, Paul Durrant <paul.durrant@citrix.com> wrote:
> >
> > My Citrix email address will expire shortly.
> >
> > Signed-off-by: Paul Durrant <paul.durrant@citrix.com>
>
> Acked-by: Wei Liu <wl@xen.org>

Or rather:

Acked-by: Wei Liu <wei.liu@kernel.org>
