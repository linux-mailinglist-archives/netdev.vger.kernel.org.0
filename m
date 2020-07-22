Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 59719229E42
	for <lists+netdev@lfdr.de>; Wed, 22 Jul 2020 19:17:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732244AbgGVRPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Jul 2020 13:15:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49546 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1730381AbgGVRPC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jul 2020 13:15:02 -0400
Received: from mail-lj1-x244.google.com (mail-lj1-x244.google.com [IPv6:2a00:1450:4864:20::244])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id EFC91C0619DC;
        Wed, 22 Jul 2020 10:15:01 -0700 (PDT)
Received: by mail-lj1-x244.google.com with SMTP id q4so3337969lji.2;
        Wed, 22 Jul 2020 10:15:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cVcoEfFppL+7K43qaXbza9Qghk86OOJSk60UN9FStZU=;
        b=SQkF3b3jIXyEuSdG2/DVhNXbqJD1L6aLcInHXLchBVGeLN8o0aT/XdXCvj7AjKNyzS
         8U3YXYriHgkBXL16qQRpnh+p/6vsBMKKas5Gl+DYvDILmaQYgwb3rz0lp/MIxceLeOp3
         frjBpDxFFFldSvoJvejNtE3rtuPCRuG7izSQRYdb2JxsdfHWStwOyp5ake3WgRQBD+c7
         Ojfzdlbc/RaoMtzEE3O7kmfF1vyi//9bTi+fsuHy8Bek+MYr7ROjWZ/DxK6xm42Rf440
         0kZmy6snDSzMgfl7ScjTx+7sDJRB1hjeNKMn+RPPR3vd2E9ajtqSxz8dASyhPkyggsK4
         jH7w==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cVcoEfFppL+7K43qaXbza9Qghk86OOJSk60UN9FStZU=;
        b=GWf2efrPz9hMRtqzMEONzffTPbMhINfrjhFlUeGHj/cBBbX2BTGw6GIXg6F7Uugmy6
         nWVVvrE5SCWXgHU/5ujTIUOx2hZmHO2q3QXz7S4ExbcJo7bQrtT4pudnF4HQRdQOICqa
         LZyEC1V41CT9YVRh3Pe8SSRFR0LJi55xGFB6n6HJpcuHcGEV30bGFm5tq5D+NSxV8ZjS
         e5uWi8FaORX2uxYe1UYmye5NXujkm9ggPX7DtgEwZTFZrPJnhE8I1PzIBkxTPjjLjieH
         QcTF+6netriyUinYXAUCy8rvsO/15yC4aJvzLKnNidf6NVTUco3N7WF3Ak6fTaVmUX3Q
         mLYQ==
X-Gm-Message-State: AOAM532CHm6AlHBKBCb4/E1cuSW6AY4EdTHDvDvbSj90LhhBGZtBt+v/
        WZCoRK6CqvoPnBfcLea8yvC0l0mko4jMiRoCJmE=
X-Google-Smtp-Source: ABdhPJzM/e9tpN7Q9g2GlOjSqpxZZ/hREMDgbpsRDa+VhB57mZA5pvxtSis1AJ9LRNd/53/Kzzht5w79IT6tjpzb/9s=
X-Received: by 2002:a2e:8ec8:: with SMTP id e8mr97196ljl.51.1595438100443;
 Wed, 22 Jul 2020 10:15:00 -0700 (PDT)
MIME-Version: 1.0
References: <87wo2vwxq6.fsf@cloudflare.com> <20200722144212.27106-1-kuniyu@amazon.co.jp>
 <87v9ifwq2p.fsf@cloudflare.com> <CA+FuTScto+Z_qgFxJBzhPUNEruAvKLSTL7-0AnyP-M6Gon_e5Q@mail.gmail.com>
 <87tuxzwp0v.fsf@cloudflare.com> <CA+FuTSdQWKFam0KwCg_REZdhNB6+BOwAHL00eRgrJ2FwPDRjcA@mail.gmail.com>
In-Reply-To: <CA+FuTSdQWKFam0KwCg_REZdhNB6+BOwAHL00eRgrJ2FwPDRjcA@mail.gmail.com>
From:   Alexei Starovoitov <alexei.starovoitov@gmail.com>
Date:   Wed, 22 Jul 2020 10:14:49 -0700
Message-ID: <CAADnVQKmOLkd1oJHCxfqQnSbJFfp0NRd1C9i9mZy_3rNRc4a1A@mail.gmail.com>
Subject: Re: linux-next: manual merge of the bpf-next tree with the net tree
To:     Willem de Bruijn <willemdebruijn.kernel@gmail.com>
Cc:     Jakub Sitnicki <jakub@cloudflare.com>,
        Kuniyuki Iwashima <kuniyu@amazon.co.jp>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        kernel-team <kernel-team@cloudflare.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Linux-Next Mailing List <linux-next@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jul 22, 2020 at 8:50 AM Willem de Bruijn
<willemdebruijn.kernel@gmail.com> wrote:
>
> > TBH, I don't what is the preferred way to handle it. Perhaps DaveM or
> > Alexei/Daniel can say what would make their life easiest?
>
> Good point.
>
> With the above, there still remains a merge conflict, of course. But
> then we can take bpf-next as is, so I think it would save a separate
> patch to net. But not sure whether that helps anything. It does add an
> unnecessary variable.

whichever way is easier to deal with merge conflict....
currently bpf-next PR is pending.
but we can drop it and merge one more patch into bpf-next?
But reading through the read it doesn't sound that it will help the
merge conflict..
An alternative could be to drop PR and rebase the whole bpf-next to net-next
and deal with conflicts there...
Or I can rebase bpf-next and drop Jakub's series and he can resubmit them
without conflicts? I guess that's the easiest for me and for Dave.
