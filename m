Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5E142F757F
	for <lists+netdev@lfdr.de>; Fri, 15 Jan 2021 10:33:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729182AbhAOJcn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jan 2021 04:32:43 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56578 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728119AbhAOJcm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jan 2021 04:32:42 -0500
Received: from mail-wr1-x431.google.com (mail-wr1-x431.google.com [IPv6:2a00:1450:4864:20::431])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7EFA0C061757;
        Fri, 15 Jan 2021 01:32:06 -0800 (PST)
Received: by mail-wr1-x431.google.com with SMTP id 6so1245120wri.3;
        Fri, 15 Jan 2021 01:32:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=FIIXOUpL8BdWUaLE7hAEfwvKYGbtD/1zuweKjwFi+pw=;
        b=J08t/PVjSubdOE6eTFMRmblV+ELJV017urFVlGtbErnSKdgHNQlr9KOzlLOQKbWvAU
         o3VFtY3PPcVJMNWCIfhgl+KkJFXGUKaCmx5vdbC0unny9qnppHROYvV04m+eqOdnvP1Z
         qBypCrHMMfWbrJgPDorcdlR4xR2TP750hfVltpazy9WT3d7XL2hwhWis3RTq5GP8MHFb
         LGd/ED/Agj0BM75NaOmnFSat7nnnGZfdrXQ7jnk7PIsjXvUvPOqvRWjZ8JLvjCFIPYVv
         W2LwPXnhfvomI+C0ZANgsQDzc3CB3ZNSeMZD6bTCYQaVZeNaAAsyZjuWR43zsOuiObE8
         lWdQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=FIIXOUpL8BdWUaLE7hAEfwvKYGbtD/1zuweKjwFi+pw=;
        b=DpmVMWvwgGsokZ2Ow70p8+591/YAmTwuU7SBssQ6S/h1Es2jPHZMI1KgI28INaycYy
         xoMyDlcq/Es5BjDKhvp5by1GRCClLMMkA5IUWihqISnfy/bEAtxNn3QOmmyR3rpKDrMU
         DmmBtowJHjjwagmeOujZzizm8tmY2jWtkyZMmfJwWa2NTyTvrcAZ2ho3IEjQuWDFhUmW
         DQp7Ik05rEpiyYOIYNYztQl4Io/Htzvc05hoFJm/WqnqAjQB2WOcwu1ES9H/f4wuKPjy
         LHvFiImyoPeDtirDnCjL9coEOY8IpfXx9b4+i08wuNIvXoBKblbzXBrSeIHwDqKwriq9
         Qn3A==
X-Gm-Message-State: AOAM5305ozyGvfqUvlMXww4ZKBQ2/yz1kwyvwvamxDbk1REJ+6EjPRCK
        x1gqXRzZTMRs3aGCFmICf8kxXfmrhhrqG/P+qM1Y8/rd1j8=
X-Google-Smtp-Source: ABdhPJzDtpXK37/HmIhorQuxZPeeNiMPAwQEiA9c4B+nlH14eeBOUpF3vh+Ql2AMx5hYkxai4iMEOj5rOOtFYC+zfMs=
X-Received: by 2002:adf:c642:: with SMTP id u2mr12298517wrg.243.1610703125174;
 Fri, 15 Jan 2021 01:32:05 -0800 (PST)
MIME-Version: 1.0
References: <cover.1610698811.git.lucien.xin@gmail.com>
In-Reply-To: <cover.1610698811.git.lucien.xin@gmail.com>
From:   Xin Long <lucien.xin@gmail.com>
Date:   Fri, 15 Jan 2021 17:31:53 +0800
Message-ID: <CADvbK_e3eZJeSNw899AND-vK7-bOu01pVdk4f4u+bVO7=P0b5Q@mail.gmail.com>
Subject: Re: [PATCHv2 net-next 0/2] net: fix the features flag in sctp_gso_segment
To:     network dev <netdev@vger.kernel.org>,
        "linux-sctp @ vger . kernel . org" <linux-sctp@vger.kernel.org>
Cc:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        davem <davem@davemloft.net>, Jakub Kicinski <kuba@kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Please drop this patchset, the second one is incorrect.
I will post v3, thanks.

On Fri, Jan 15, 2021 at 4:21 PM Xin Long <lucien.xin@gmail.com> wrote:
>
> Patch 1/2 is to improve the code in skb_segment(), and it is needed
> by Patch 2/2.
>
> v1->v2:
>   - see Patch 1/2.
>
> Xin Long (2):
>   net: move the hsize check to the else block in skb_segment
>   udp: remove CRC flag from dev features in __skb_udp_tunnel_segment
>
>  net/core/skbuff.c      | 11 ++++++-----
>  net/ipv4/udp_offload.c |  4 ++--
>  2 files changed, 8 insertions(+), 7 deletions(-)
>
> --
> 2.1.0
>
