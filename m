Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D6049193533
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 02:16:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727607AbgCZBQ5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Mar 2020 21:16:57 -0400
Received: from mail-ed1-f67.google.com ([209.85.208.67]:39138 "EHLO
        mail-ed1-f67.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727539AbgCZBQ4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 25 Mar 2020 21:16:56 -0400
Received: by mail-ed1-f67.google.com with SMTP id a43so5018390edf.6
        for <netdev@vger.kernel.org>; Wed, 25 Mar 2020 18:16:55 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=NtOdomNdHvvJrrKi6gic1ppKsbP8qWdyIn1GJVXn9J8=;
        b=nK4RjuYG6zev9ORw8cq/HudHfF8ybzDHwvvKWoqWma1WEz48OKP1FD9CKlFE2z2kZI
         YsiftF+sxmCD9/vJzHlkH439tLNWWj//Ar7KJRnsEsiY9wXwZg8oWkjIa8xrx+LzByGz
         CxIS1PC0I7SMKuW0FagctezbSqiSqUZ2J0VO7/vOi4bS8IWLXqCOoFw6xKO+bE5a3sjB
         uq7OC4pc0FuoPVVnXTeAvbpczzet3CzQKhko9FrAggmz9nccw4DKiTdAarzdsgdwcnms
         lExzPX5S+Hthwb5AKdjkBseCA7+Pl/VHaDgI8PmUUQdkjm9HbEmQ2/5wX3Cqr+u/k+q9
         3vxg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=NtOdomNdHvvJrrKi6gic1ppKsbP8qWdyIn1GJVXn9J8=;
        b=YsiVoWQkSHNnHK+WwAFTkbyATLdkPHyBhvnkbS8KvVuDNSnuusJxKdMR5jfLUJHjlV
         LkQlCCoQ+H3nwFr//EaqooWJubXqDIWbh6o6PkjgoX96x/aB1pCLFbSj5wRCGB27eT0t
         PauV0eWJwBbMcpB4bdV2jFTjfHi3ZKMTRBWZ0q3LHAGfPKJI1CpQE5hWQ0qUpjZhcz3X
         gyuTvJT4YwT9WZjo4sHv5JWOhwLzkh7m0td2hY1yYBLbYcQbyPhCfcCURwYnmJeM2EJk
         Q5rWnILTymwMpGUEEnKTUg2JwIatwtEtoIJEaEhJyHcQfkKp6+ybmmJFd3P5Uel+68LT
         aizA==
X-Gm-Message-State: ANhLgQ3Fm3WsUkg2sUQ7A3RzNAmZqAddRqrNyFe67GY2bWxa6Z6pnhjK
        +UUifgwCrwdzOzEitvzFcE0rFzNDYSMYwXnsfKU=
X-Google-Smtp-Source: ADFU+vsOjTK2rsmzqjrrhiyjwHVArmj0BWqCLAuM2VKVpK59NCdmUEqhh0W9MDOBzDX/VFDBNuFzvCQNKY/AkV69NHo=
X-Received: by 2002:a05:6402:1a5a:: with SMTP id bf26mr5754474edb.42.1585185414653;
 Wed, 25 Mar 2020 18:16:54 -0700 (PDT)
MIME-Version: 1.0
References: <20200325140845.11840-1-yang_y_yi@163.com> <CA+FuTSf5U_ndpmBisjqLMihx0q+wCrqndDAUT1vF3=1DXJnumw@mail.gmail.com>
 <8c7c4b8.a0a4.17112280afb.Coremail.yang_y_yi@163.com>
In-Reply-To: <8c7c4b8.a0a4.17112280afb.Coremail.yang_y_yi@163.com>
From:   Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Date:   Wed, 25 Mar 2020 21:16:16 -0400
Message-ID: <CAF=yD-KzBEPsLOAG3G1bVu1zGHqJ5fHjwLC2vEtkJpSDu0Oqrg@mail.gmail.com>
Subject: Re: Re: [PATCH net-next] net/packet: fix TPACKET_V3 performance issue
 in case of TSO
To:     yang_y_yi <yang_y_yi@163.com>
Cc:     Network Development <netdev@vger.kernel.org>, u9012063@gmail.com,
        yangyi01@inspur.com
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 25, 2020 at 10:46 AM yang_y_yi <yang_y_yi@163.com> wrote:
>
> Yes, hrtimer is better, but it will change current API semantics.
>
> req.tp_retire_blk_tov means millisecond, if we change it as microsecond, it will break ABI.

That can be resolved by adding a new feature flag that reinterprets
the field in the request.

#define TP_FT_REQ_USEC      0x2

Please remember to use plain text and don't top paste.



> At 2020-03-25 22:37:59, "Willem de Bruijn" <willemdebruijn.kernel@gmail.com> wrote:
> >On Wed, Mar 25, 2020 at 10:10 AM <yang_y_yi@163.com> wrote:
> >>
> >> From: Yi Yang <yangyi01@inspur.com>
> >>
> >> TPACKET_V3 performance is very very bad in case of TSO, it is even
> >> worse than non-TSO case. For Linux kernels which set CONFIG_HZ to
> >> 1000, req.tp_retire_blk_tov = 1 can help improve it a bit, but some
> >> Linux distributions set CONFIG_HZ to 250, so req.tp_retire_blk_tov = 1
> >> actually means req.tp_retire_blk_tov = 4, it won't have any help.
> >>
> >> This fix patch can fix the aforementioned performance issue, it can
> >> boost the performance from 3.05Gbps to 16.9Gbps, a very huge
> >> improvement. It will retire current block as early as possible in
> >> case of TSO in order that userspace application can consume it
> >> in time.
> >>
> >> Signed-off-by: Yi Yang <yangyi01@inspur.com>
> >
> >I'm not convinced that special casing TSO packets is the right solution here.
> >
> >We should consider converting TPACKET_V3 to hrtimer and allow usec
> >resolution block timer.
> >
> >Would that solve your issue?
