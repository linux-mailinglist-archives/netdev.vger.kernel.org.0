Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9AC442A191
	for <lists+netdev@lfdr.de>; Sat, 25 May 2019 01:17:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726335AbfEXXRp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 May 2019 19:17:45 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:43833 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbfEXXRp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 May 2019 19:17:45 -0400
Received: by mail-wr1-f66.google.com with SMTP id l17so3047636wrm.10
        for <netdev@vger.kernel.org>; Fri, 24 May 2019 16:17:44 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Du8pm3zNT/C4eFKl/KOYJJmVkIdZ5Zf24+raNq+GceM=;
        b=p6vavkciQnzTE37MaWyk6pe1LmA0wH285vnQ8MXUIj89sKorz1mHsgdP7+wNO05xw+
         bpwTwy9HgflAhMFiERT98+jcx6R6zmtXG3tHd2KH1IvCSr6eXqeB9/xv7A78mCeQI7Kr
         ngyT+2M6UI2g0pOobcxBWCJ1TqhOSuNS9QH/R5YgiFRT2L8x4B3WmUcE5oc13/zlOGdx
         dmyuWArVjvQyZNHbB/Fw4OnOy3tIjdOpEUffu92fAw5d5VuyU3XPwCAuruIISGk2Mz1X
         9ABE4m4WYvd7EEZlo2bRp5jyeASJBu2VpqEI9Ho+poVIRXZdiVdnol2tKpOxBZMIy4PN
         /BAg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Du8pm3zNT/C4eFKl/KOYJJmVkIdZ5Zf24+raNq+GceM=;
        b=e09kObvJ29oYcE6M3YrjSqKCcrJ3BQ6UPZI/zVYlmUXz72PTKFqIdRFY+pnSN6RRdw
         pOXOzW7nxy+gwQH3hUGCehlX+Mp1n27krKto4MGTH9zSJ8h5Af/5XLnXLD+B5CdHj7rT
         N3c2Xldqk6t71tUg6XX7mIhCMFtgyIp9PMSLxO8LqPxdx+m+5ELpjuZEp04NXwRFiFqw
         TiJsp9lxhZyEdOWsaH5UwnOdbwiQRCmL1T3TJkxxCAF7wbtDmtRcTJTEh9wo04ovVV9e
         GrGEY9fWJSXUCVY7TAP/ruzrjAwpf0a5//mpEqjrPgIsbb6I+u8hucrWFqComOKuqy2D
         F7EA==
X-Gm-Message-State: APjAAAUd03cu9L4q6Cbq03sqpwTmrMF3SCqrUe3iYqAICUTJXKtp8Prx
        vKrm0SULFPxI4HbI80SCCiFv7yiP7SLu9OZFUPAMOQ==
X-Google-Smtp-Source: APXvYqzpOV2Ul4CMhcf8lP1A+weWf6b+IDItKiDJhkpq3w0azoEiG2yhQCvtbyfjpdl39FonelQ8Gd+UcVmuVNwKDvQ=
X-Received: by 2002:adf:f841:: with SMTP id d1mr1222359wrq.62.1558739863241;
 Fri, 24 May 2019 16:17:43 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1558557001.git.jbaron@akamai.com> <20190523.121435.1508515031987363334.davem@davemloft.net>
 <CAK6E8=fXs5kHVhcNyVHY5V3ZDkn3_FBcMPSnFoe4Fir-qU_1BA@mail.gmail.com>
In-Reply-To: <CAK6E8=fXs5kHVhcNyVHY5V3ZDkn3_FBcMPSnFoe4Fir-qU_1BA@mail.gmail.com>
From:   Yuchung Cheng <ycheng@google.com>
Date:   Fri, 24 May 2019 16:17:06 -0700
Message-ID: <CAK6E8=dEtKU49wMJbTCQnS+=O9Gt8GZh4KOQ2QTawxnACtzX+g@mail.gmail.com>
Subject: Re: [PATCH net-next 0/6] add TFO backup key
To:     David Miller <davem@davemloft.net>
Cc:     jbaron@akamai.com, Eric Dumazet <edumazet@google.com>,
        ilubashe@akamai.com, netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, May 23, 2019 at 4:31 PM Yuchung Cheng <ycheng@google.com> wrote:
>
> On Thu, May 23, 2019 at 12:14 PM David Miller <davem@davemloft.net> wrote:
> >
> > From: Jason Baron <jbaron@akamai.com>
> > Date: Wed, 22 May 2019 16:39:32 -0400
> >
> > > Christoph, Igor, and I have worked on an API that facilitates TFO key
> > > rotation. This is a follow up to the series that Christoph previously
> > > posted, with an API that meets both of our use-cases. Here's a
> > > link to the previous work:
> > > https://patchwork.ozlabs.org/cover/1013753/
> >
> > I have no objections.
> >
> > Yuchung and Eric, please review.
> >
> > And anyways there will be another spin of this to fix the typo in the documentation
> > patch #5.
> patch set looks fine. I am testing them w/ our internal TFO packetdrill tests.
> >
> > Thanks.
The patch series pass the packetdrill TFO tests :-) It'd be great to
support of TCP_FASTOPEN_KEY sock opt additionally.

Acked-by: Yuchung Cheng <ycheng@google.com>
