Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C0E3D2AC126
	for <lists+netdev@lfdr.de>; Mon,  9 Nov 2020 17:44:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730471AbgKIQoE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Nov 2020 11:44:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55792 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726410AbgKIQoE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Nov 2020 11:44:04 -0500
Received: from mail-qt1-x843.google.com (mail-qt1-x843.google.com [IPv6:2607:f8b0:4864:20::843])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 70F84C0613CF
        for <netdev@vger.kernel.org>; Mon,  9 Nov 2020 08:44:04 -0800 (PST)
Received: by mail-qt1-x843.google.com with SMTP id m65so6394321qte.11
        for <netdev@vger.kernel.org>; Mon, 09 Nov 2020 08:44:04 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=bxKjKzyax+cKTDy4CrT1Ah9rBj0Kud+9NcQt8Uwja9I=;
        b=NevfnH1ajOYsfTPL95QEBkvMx8cVstM+rEK/+UgXRYLe52JYtpHbtZOSaLGoc1AZq3
         t2+Q4HMRMamOft+5d7BtLPiWpOd22MyNLboDzciE0bizZH6Z5rMbIBf9k4x4540rhTqX
         JGG+j4yIKbTkdndc4dKJ0BNHXHT8BR+Kdb/xXlWYDKpOAxzZJjLxwL68ZZgkMedVqqKf
         DJPtdsfnWJgOnesVn/CuhJ2HpJiFOetxGLGNWRELr1SIHPKz4jvIs0pI72f6QX663Odn
         fV5TOyN0++PVvHu39o5Jamv+69xJ3C67YlAMnx8GBrxvkbh0wQKvx6nO3NPJ9tNobA91
         5PyQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=bxKjKzyax+cKTDy4CrT1Ah9rBj0Kud+9NcQt8Uwja9I=;
        b=EsbKSn8GsG0ErU6JyAfjDjL+yYHBbwJqi2vBtzj1GXqeWT8NT8gt+/iGuZtkD6A/r8
         7fdDhEqhvgl5bNnra+mg+mlDcPpay/yxUZHx445a/LS6C9T4UneVZUiopvkAsgEGjgmw
         KXabE9eWjw0VpESIcy2yUCbIMs3vkMRBc5h64pGG6+UIDMvrNeqkLsi5PHZ42cHexq13
         w3PeyJI7JKK+QwqAktIBxfSyFxYrseOWnhSst0YLAmFNlA1rXAEKlqVSC/NiLGUiuUKO
         gQRcM8wkjNuRm9KgWWggPNtK4cuPMbsybhYEInqoinI+3Xjl0H/FbiMOw50RUx4IOwhQ
         ytew==
X-Gm-Message-State: AOAM533AaqLESMzeHgusqTaImo7WE8NUxrMnE8hnHwEcwB2H0HYzQQBU
        DXyrfNA2TxvkceGCFXglp40=
X-Google-Smtp-Source: ABdhPJwEOouNnm5E2o0W9/obGhF5Z45qwMdy6jtHUJwNRGVlKBnBat0VCsmUqL7hpFp+Frjd778Ptw==
X-Received: by 2002:ac8:7189:: with SMTP id w9mr13996211qto.288.1604940243512;
        Mon, 09 Nov 2020 08:44:03 -0800 (PST)
Received: from localhost.localdomain ([2001:1284:f013:f46e:fd51:d129:1f9d:9ebd])
        by smtp.gmail.com with ESMTPSA id d140sm2579774qke.59.2020.11.09.08.44.02
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 09 Nov 2020 08:44:02 -0800 (PST)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 6D551C1B7C; Mon,  9 Nov 2020 13:44:00 -0300 (-03)
Date:   Mon, 9 Nov 2020 13:44:00 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Vlad Buslov <vladbu@nvidia.com>
Cc:     wenxu@ucloud.cn, kuba@kernel.org, dcaratti@redhat.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH v5 net-next 3/3] net/sched: act_frag: add implict packet
 fragment support.
Message-ID: <20201109164400.GC3913@localhost.localdomain>
References: <1604791828-7431-1-git-send-email-wenxu@ucloud.cn>
 <1604791828-7431-4-git-send-email-wenxu@ucloud.cn>
 <ygnhimaewtm2.fsf@nvidia.com>
 <20201109145025.GB3913@localhost.localdomain>
 <ygnhft5iwmzh.fsf@nvidia.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <ygnhft5iwmzh.fsf@nvidia.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Nov 09, 2020 at 05:47:46PM +0200, Vlad Buslov wrote:
> 
> On Mon 09 Nov 2020 at 16:50, Marcelo Ricardo Leitner <marcelo.leitner@gmail.com> wrote:
> > On Mon, Nov 09, 2020 at 03:24:37PM +0200, Vlad Buslov wrote:
> >> On Sun 08 Nov 2020 at 01:30, wenxu@ucloud.cn wrote:
...
> >> > +int tcf_dev_queue_xmit(struct sk_buff *skb, int (*xmit)(struct sk_buff *skb))
> >> > +{
> >> > +	if (tcf_xmit_hook_enabled())
> >> 
> >> Okay, so what happens here if tcf_xmit_hook is disabled concurrently? If
> >> we get here from some rule that doesn't involve act_ct but uses
> >> act_mirred and act_ct is concurrently removed decrementing last
> >> reference to static branch and setting tcf_xmit_hook to NULL?
> >
> > Yeah.. good point. Thinking further now, what about using RCU for the
> > hook? AFAICT it can cover the synchronization needed when clearing the
> > pointer, tcf_set_xmit_hook() should do a module_get() and
> > tcf_clear_xmit_hook() can delay a module_put(act_frag) as needed with
> > call_rcu.
> 
> Wouldn't it be enough to just call synchronize_rcu() in
> tcf_clear_xmit_hook() after setting tcf_xmit_hook to NULL? act_ct module
> removal should be very rare, so synchronously waiting for rcu grace
> period to complete is probably okay.

Right. And even if it gets reloaded (or, say, something else tries to
use the hook), the teardown was already handled. Nice, thanks Vlad.

> 
> >
> > I see tcf_mirred_act is already calling rcu_dereference_bh(), so
> > it's already protected by rcu read here and calling tcf_xmit_hook()
> > with xmit pointer should be fine. WDYT?
> 
> Yes, good idea.
> 
> >
> >> 
> >> > +		return tcf_xmit_hook(skb, xmit);
> >> > +	else
> >> > +		return xmit(skb);
> >> > +}
> >> > +EXPORT_SYMBOL_GPL(tcf_dev_queue_xmit);
> 
