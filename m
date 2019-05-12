Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id CA2141AACD
	for <lists+netdev@lfdr.de>; Sun, 12 May 2019 07:53:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726031AbfELFxC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 May 2019 01:53:02 -0400
Received: from mail-wm1-f67.google.com ([209.85.128.67]:50237 "EHLO
        mail-wm1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725913AbfELFxC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 May 2019 01:53:02 -0400
Received: by mail-wm1-f67.google.com with SMTP id f204so5356432wme.0;
        Sat, 11 May 2019 22:53:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=/yoEWXCHXPaRx0PqNfws8qCTvbAQ70w4QTJcFwL7+sA=;
        b=EmI5kLAjJ25FE5inIjdlys1i0lzCFjvfD6AeUrllMnzKXKC9TuRTU3+2zpWiHorAGV
         /OEFTjoIypMAdY0U+8DKtXwNhrMF1SV2nkFu8DJr89n3i7/sTUrmd5Ii2HeoWWnf4Z0/
         b3iiqgTzw3De0F+ZzdRQzOVyX7Xx7OQtn6RLR5qaZ2Q/4cVdJrXYNksQhuvBw1WV8dRK
         gKBtHwrlxAkPLr4knHTZKjW5CZ/0kfCevM2IxYQOk9IggPrbg3xkpmTdZ3YOXNxoITmq
         LayjVDpv57db9UIRucfEutAIzZQ+SJfSjsig2o8nXsqHDnvJUp1e3OnO1dLzapZevY8T
         bdRw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=/yoEWXCHXPaRx0PqNfws8qCTvbAQ70w4QTJcFwL7+sA=;
        b=HgdM7v5iS39WyYRNgVOGA/8Hobnf6sPASzgnb16R4E2wkfhDsdXS3c6XeGa8+G/1hB
         h3EDbC5cyTv+/Gx62gccXGLKlY9KE7GgVl3z+ZXUhTfKkTgagJXWZrMoipcGc9bL8Bwd
         t9ELh6Z+rgApEuJrmNBE7TxAu/5hVUR7aIbX3NBAZR37RdiucbQeDaAxHjXjTUtVqUxt
         DLmgMa4hgb/bTqEnquK8gUREO/2I/AFko0K0xo13eN6Vyd9R/pRIrvT69YCjKSRlGo1L
         INdPL+Ah/JOiPVXz5ryYQF+mex1st69sjNKDZGaPmcvgZfdmzbVzJiCKcdd9zNnrajqe
         Bvuw==
X-Gm-Message-State: APjAAAWaJsX1b/3Fh5H4dYd8EN48QzMf2484KyBgFcFijTQF/E82a5TJ
        BGZuT4Ta6Mtia001PYxOyUG2I4gSSuLO4A09Ojs=
X-Google-Smtp-Source: APXvYqzbTZ9sZtZCtUDS6JA1fkhVULqexYGVmeAY8jqnnCoAjiVuVPdlRr8QzeMHIphCazeRwZpdBZfUbmhphZb5ME8=
X-Received: by 2002:a7b:c652:: with SMTP id q18mr2911492wmk.57.1557640380368;
 Sat, 11 May 2019 22:53:00 -0700 (PDT)
MIME-Version: 1.0
References: <fa41cfdb9f8919d1420d12d270d97e3b17a0fb18.1557383280.git.lucien.xin@gmail.com>
 <20190509113235.GA12387@hmswarspite.think-freely.org> <20190509.093913.1261211226773919507.davem@davemloft.net>
 <20190510112718.GA4902@hmswarspite.think-freely.org>
In-Reply-To: <20190510112718.GA4902@hmswarspite.think-freely.org>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Sun, 12 May 2019 13:52:48 +0800
Message-ID: <CADvbK_f3cmHB+gcY-h6df06kMbB8eB4oiXdL7A8BvxNqVF2aJw@mail.gmail.com>
Subject: Re: [PATCH net-next] sctp: remove unused cmd SCTP_CMD_GEN_INIT_ACK
To:     Neil Horman <nhorman@tuxdriver.com>
Cc:     David Miller <davem@davemloft.net>,
        network dev <netdev@vger.kernel.org>,
        linux-sctp@vger.kernel.org,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, May 10, 2019 at 7:27 PM Neil Horman <nhorman@tuxdriver.com> wrote:
>
> On Thu, May 09, 2019 at 09:39:13AM -0700, David Miller wrote:
> > From: Neil Horman <nhorman@tuxdriver.com>
> > Date: Thu, 9 May 2019 07:32:35 -0400
> >
> > > This is definately a valid cleanup, but I wonder if it wouldn't be better to,
> > > instead of removing it, to use it.  We have 2 locations where we actually call
> > > sctp_make_init_ack, and then have to check the return code and abort the
> > > operation if we get a NULL return.  Would it be a better solution (in the sense
> > > of keeping our control flow in line with how the rest of the state machine is
> > > supposed to work), if we didn't just add a SCTP_CMD_GEN_INIT_ACK sideeffect to
> > > the state machine queue in the locations where we otherwise would call
> > > sctp_make_init_ack/sctp_add_cmd_sf(...SCTP_CMD_REPLY)?
I think they didn't do that, as the new INIT_ACK needs to add unk_param from
the err_chunk which is allocated and freed in those two places
sctp_sf_do_5_1B_init()/sctp_sf_do_unexpected_init().

It looks not good to pass that err_chunk as a param to the state machine.

> >
> > Also, net-next is closed 8-)
> >
> Details, details :)
>
So everytime before posting a patch on net-next,
I should check http://vger.kernel.org/~davem/net-next.html first, right?
