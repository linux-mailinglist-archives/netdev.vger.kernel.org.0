Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E77213B3D7C
	for <lists+netdev@lfdr.de>; Fri, 25 Jun 2021 09:36:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229945AbhFYHiq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Jun 2021 03:38:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48466 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229671AbhFYHiq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Jun 2021 03:38:46 -0400
Received: from mail-wr1-x430.google.com (mail-wr1-x430.google.com [IPv6:2a00:1450:4864:20::430])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 13FB7C061756
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 00:36:25 -0700 (PDT)
Received: by mail-wr1-x430.google.com with SMTP id g7so4869893wri.7
        for <netdev@vger.kernel.org>; Fri, 25 Jun 2021 00:36:25 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=ubique-spb-ru.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=A+iYsxnNRChil1qMH5MHHpKdV0Rl30rr/MhL/n0ldpo=;
        b=OwabMajJMXwFXlsoPKacy7ZKWmFfW+oWJ21Q3d4KKvsGhyzEhATItY3xjHbr0gG7Ze
         yL5f93uQgC6lqZg5i4lrjdFHoczrlNvRisnKJ4b8LO5Q0ey3yYMdil9PMm5fm9txhx1a
         oirlatfmY919d1KX6n97MhlhL1o5Po+QP2TBKybwDaC+m7ofZ6/497Sl6GHQ1JJFbSHy
         fS61WF1bB+fyfe5cHEpgEaUM3Ywanpwr4JZscgUV1SkicD64tI8f2mUaK3yXhSedJ6+a
         DxUxN8MG3557snFkRRlzkT/qG2P4A60VrTPGFusuzM3vibbLCpZhAJBM3L0SlILGt2j1
         0f+Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=A+iYsxnNRChil1qMH5MHHpKdV0Rl30rr/MhL/n0ldpo=;
        b=j4tJ/96mKEwysOig26VH1yvdm11ECXb/91zIci2UISkN5ZzLmeikfRHutVRvCpazEM
         cXDtuEf+MBhyLNsuqv1MkafU0kDULxon2lCSPxzs4i7g2TkOs/onuzf2dJDJuMiCJhua
         CsfqEYzsQRa0h7xp5C68o7OD2vx4MQwgmtA+FAzGLtcydk8+iaB7Q3M8H7iHgim8fyPL
         bKl0G1uNwdcol+ov7ghxfJtu5W4He8NJFOX7wVuG9U1sWmVBtHGPQlf3v1vugNJttNIy
         DbM2ZClTJG+b78wq25tF7DGhIcY18PWh3b7sXTK4Zue+upyKrAbJSAQ17wCjR4UGlpgm
         gLqw==
X-Gm-Message-State: AOAM531Iaw/rd50Tf5lDIu0C0A8+1dml/wxRVmlhPCiF7MUuB18jj7Wf
        OuxF9gT+t1c/6bA3n+mMgHcNMw==
X-Google-Smtp-Source: ABdhPJwbhMH8K0ko7h1DMvsBPkXfcdQWgEd8GSufhINDO4SZsP+VSNa9+m4a6/rLkDMoT68d4YcW0Q==
X-Received: by 2002:a5d:6a4e:: with SMTP id t14mr9258510wrw.211.1624606583710;
        Fri, 25 Jun 2021 00:36:23 -0700 (PDT)
Received: from localhost ([154.21.15.43])
        by smtp.gmail.com with ESMTPSA id 61sm6023536wrp.4.2021.06.25.00.36.22
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 25 Jun 2021 00:36:23 -0700 (PDT)
Date:   Fri, 25 Jun 2021 11:36:21 +0400
From:   Dmitrii Banshchikov <me@ubique.spb.ru>
To:     Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     Gary Lin <glin@suse.com>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        bpf <bpf@vger.kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        Martin Loviska <mloviska@suse.com>
Subject: Re: [PATCH bpf] net/bpfilter: specify the log level for the kmsg
 message
Message-ID: <20210625073621.zmd2w33wi335lya3@amnesia>
References: <20210623040918.8683-1-glin@suse.com>
 <CAADnVQLpN993VpnPkTUxXpBMZtS6+h4CVruH33zbw-BLWj41-A@mail.gmail.com>
 <20210623065744.igawwy424y2zy26t@amnesia>
 <CAADnVQK2uQ3MvwaRztMtcw8SJz1r213hxA+vM2dCtr6RfpZnSA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAADnVQK2uQ3MvwaRztMtcw8SJz1r213hxA+vM2dCtr6RfpZnSA@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jun 24, 2021 at 08:47:06PM -0700, Alexei Starovoitov wrote:
> On Tue, Jun 22, 2021 at 11:57 PM Dmitrii Banshchikov <me@ubique.spb.ru> wrote:
> >
> > On Tue, Jun 22, 2021 at 09:38:38PM -0700, Alexei Starovoitov wrote:
> > > On Tue, Jun 22, 2021 at 9:09 PM Gary Lin <glin@suse.com> wrote:
> > > >
> > > > Per the kmsg document(*), if we don't specify the log level with a
> > > > prefix "<N>" in the message string, the default log level will be
> > > > applied to the message. Since the default level could be warning(4),
> > > > this would make the log utility such as journalctl treat the message,
> > > > "Started bpfilter", as a warning. To avoid confusion, this commit adds
> > > > the prefix "<5>" to make the message always a notice.
> > > >
> > > > (*) https://www.kernel.org/doc/Documentation/ABI/testing/dev-kmsg
> > > >
> > > > Fixes: 36c4357c63f3 ("net: bpfilter: print umh messages to /dev/kmsg")
> > > > Reported-by: Martin Loviska <mloviska@suse.com>
> > > > Signed-off-by: Gary Lin <glin@suse.com>
> > > > ---
> > > >  net/bpfilter/main.c | 2 +-
> > > >  1 file changed, 1 insertion(+), 1 deletion(-)
> > > >
> > > > diff --git a/net/bpfilter/main.c b/net/bpfilter/main.c
> > > > index 05e1cfc1e5cd..291a92546246 100644
> > > > --- a/net/bpfilter/main.c
> > > > +++ b/net/bpfilter/main.c
> > > > @@ -57,7 +57,7 @@ int main(void)
> > > >  {
> > > >         debug_f = fopen("/dev/kmsg", "w");
> > > >         setvbuf(debug_f, 0, _IOLBF, 0);
> > > > -       fprintf(debug_f, "Started bpfilter\n");
> > > > +       fprintf(debug_f, "<5>Started bpfilter\n");
> > > >         loop();
> > > >         fclose(debug_f);
> > > >         return 0;
> > >
> > > Adding Dmitrii who is redesigning the whole bpfilter.
> >
> > Thanks. The same logic already exists in the bpfilter v1 patchset
> > - [1].
> >
> > 1. https://lore.kernel.org/bpf/c72bac57-84a0-ac4c-8bd8-08758715118e@fb.com/T/#mb36e20c4e5e4a70746bd50a109b1630687990214
> 
> Dmitrii,
> 
> what do you prefer we should do with this patch then?

There was an explicit request to make an event of loading a UMH
visible - [1]. Given that the default for MaxLevelConsole is info
and the patch makes the behavior slightly more accurate - ack
from me.

1. https://lore.kernel.org/netdev/CA+55aFx5Q8D3cmuoXJFV9Ok_vc3fd3rNP-5onqFTPTtfZgi=HQ@mail.gmail.com/

-- 

Dmitrii Banshchikov
