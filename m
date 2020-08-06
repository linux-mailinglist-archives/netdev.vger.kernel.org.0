Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F341E23D459
	for <lists+netdev@lfdr.de>; Thu,  6 Aug 2020 02:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726442AbgHFAGC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 5 Aug 2020 20:06:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58430 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725969AbgHFAGB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 5 Aug 2020 20:06:01 -0400
Received: from mail-il1-x142.google.com (mail-il1-x142.google.com [IPv6:2607:f8b0:4864:20::142])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C21A9C061574
        for <netdev@vger.kernel.org>; Wed,  5 Aug 2020 17:06:00 -0700 (PDT)
Received: by mail-il1-x142.google.com with SMTP id i138so33037749ild.9
        for <netdev@vger.kernel.org>; Wed, 05 Aug 2020 17:06:00 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=At86T27dRyeI3X3RxxrfykLCAToepGpNyyXq9UR3aSU=;
        b=sTEj1HD7Hf5Qa14SiHxONTTT5Zw6ZQr2dveL9eWQP8BzUPH2sKcGAWElePwix6Iyid
         /aT+EeKL68U86oUAlxOQOIp5X5OiAwmPKSAxc8vnTOPlGRb4U0VlYGDzeBCy3tzyuqbl
         asf2zytwDyapnkh0AWU5PJzXX5It/JEQ+lXGp8c0mOhoLY3CsV46tUfD0E8+ff6LED7t
         UlsIoM14f4YDKp5ipxfdnhK8pfqxZGcYYlIei4THsbF0frkpcFIFdPkwiWQqjWQxc4O+
         BwBAtRrqwFV79jqZCfWJWZG9kKdCEjC6tCw28xc/wkD5WkoACl1TioMpeHCEUirfljer
         hZcw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=At86T27dRyeI3X3RxxrfykLCAToepGpNyyXq9UR3aSU=;
        b=oQC2g09EdKO2yV5+iWwyt0f8zz2SyttXggl6V7u+/jNPwXexmYxRLSv6PeDSYtCEJQ
         XCmK8ge2WFlLexEgoU/k+/SX467EGNnY6SByozWVFEzje1RbvO8y+102AQElEIgSRiTP
         nUcjjlGtska1JxSwTOyQUQVR2S6UA2aoi2chCAy3FTmjq4Qv7CTkEnGGrsMH+FiQqVJR
         VOQkh5J/NsYoFoZCmOin1ZFy1Za46bzqnyqvCSgJUCygDmQuoLwd37kEWXciIrdcMRgl
         UPM/Z8ulHhiVAxMwksHRVIbUU/56kVC2NkMkNori3jWnAqYTuRSnYGK6HqRYVcxaie6L
         xxQQ==
X-Gm-Message-State: AOAM531SeCnuEXxbSaLoXoo43FsmK/MXXHUcUndWBBmCYWxuBWVg/d2Q
        3K2yMvptLeKswgkDTbt7i5TlWJapk0ZoRwPow8M1+9Dx
X-Google-Smtp-Source: ABdhPJyfn9laFnBmfn8ev8BsaVd9fnpxNcdh/DZ6nD7w7I0RZVtnIPcescsR/Qyvx1ITLiTf51iJWhkf9pHsO5X6sfw=
X-Received: by 2002:a92:8b84:: with SMTP id i126mr3053965ild.238.1596672359624;
 Wed, 05 Aug 2020 17:05:59 -0700 (PDT)
MIME-Version: 1.0
References: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
In-Reply-To: <CAFbJv-4yACz4Zzj50JxeU-ovnKMQP_Lo-1tk2jRuOJEs0Up6MQ@mail.gmail.com>
From:   Cong Wang <xiyou.wangcong@gmail.com>
Date:   Wed, 5 Aug 2020 17:05:48 -0700
Message-ID: <CAM_iQpWhwQc4yHvfFh-UWtEU2caMzXFXs4JM4gwQaRf=B0JG5g@mail.gmail.com>
Subject: Re: Question about TC filter
To:     satish dhote <sdhote926@gmail.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello,

On Tue, Aug 4, 2020 at 10:39 PM satish dhote <sdhote926@gmail.com> wrote:
>
> Hi Team,
>
> I have a question regarding tc filter behavior. I tried to look
> for the answer over the web and netdev FAQ but didn't get the
> answer. Hence I'm looking for your help.
>
> I added ingress qdisc for interface enp0s25 and then configured the
> tc filter as shown below, but after adding filters I realize that
> rule is reflected as a result of both ingress and egress filter
> command?  Is this the expected behaviour? or a bug? Why should the
> same filter be reflected in both ingress and egress path?

I am not very sure but I am feeling this is a bug. Let's Cc Daniel who
introduced this.

With the introduction of clsact qdisc, the keywords "ingress" and
"egress" were introduced too to match clsact qdisc. However, its
major/minor handle is kinda confusing:

TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_INGRESS);
TC_H_MAKE(TC_H_CLSACT, TC_H_MIN_EGRESS);
#define TC_H_CLSACT TC_H_INGRESS

They could match the ingress qdisc (ffff:) too.


>
> I understand that policy is always configured for ingress traffic,
> so I believe that filters should not be reflected with egress.
> Behaviour is same when I offloaded ovs flow to the tc software
> datapath.

I believe so too, otherwise it would be too confusing to users.

If you are able to test kernel patch, does the following one-line
change fix this problem? If not, I will try it on my side.

diff --git a/net/sched/sch_ingress.c b/net/sched/sch_ingress.c
index 84838128b9c5..4d9c1bb15545 100644
--- a/net/sched/sch_ingress.c
+++ b/net/sched/sch_ingress.c
@@ -49,7 +49,7 @@ static struct tcf_block *ingress_tcf_block(struct
Qdisc *sch, unsigned long cl,
 {
        struct ingress_sched_data *q = qdisc_priv(sch);

-       return q->block;
+       return cl == 0 ? q->block : NULL;
 }

 static void clsact_chain_head_change(struct tcf_proto *tp_head, void *priv)


Thanks.
