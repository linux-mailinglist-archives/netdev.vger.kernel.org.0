Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5786A2AA1FE
	for <lists+netdev@lfdr.de>; Sat,  7 Nov 2020 02:20:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728131AbgKGBU1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Nov 2020 20:20:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33210 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726987AbgKGBU1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 6 Nov 2020 20:20:27 -0500
Received: from mail-pg1-x533.google.com (mail-pg1-x533.google.com [IPv6:2607:f8b0:4864:20::533])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 59ABDC0613CF;
        Fri,  6 Nov 2020 17:20:27 -0800 (PST)
Received: by mail-pg1-x533.google.com with SMTP id u4so2383238pgr.9;
        Fri, 06 Nov 2020 17:20:27 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=vg4UfygjpB1OZcPNgT3WWXdXZfBOXJzBtMpTcRJYFxs=;
        b=FB/a0ohIU8bZQz/nQMgiNxUp88UtaHBUqqJGTVVpAUXPnd+O9lkAC+VA4oP11BF8eb
         h2cnf9Au6JQWzwsT9/povyt27F0PFh0LcDVSeoE1O4cmo7PzyvMeVeJg4sKGTR5xzAt0
         Tdi5A2/RkrVtjiH+VYHJvZ063YHGCZ/DUQI81Mjo+pzbmt7Z7Qr6KgCALPgmHxNx6H+7
         1KhBJ2UCnOwz0e/fRC8FFrtXCgHs6p4Oxxwu4WmKBt1kx665xbjVnrc26wh3n87A7Wcz
         EuMO9IYu10rR7O+BZN4zWV64KWLHujnY8QRLejyKalBqekkJoWAbYOglX4H1qy4RHJgD
         uncw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=vg4UfygjpB1OZcPNgT3WWXdXZfBOXJzBtMpTcRJYFxs=;
        b=aJJbD3kd0fXAk4pEwpN81KGZR/PPjFmJRLUOkzLQOC7EBmeSfyPnIJeDM7X9xB7gKR
         gvmDFwZsHX91ZhDRJfDCCG6msWDZNuw0wR9QoyEG9PMtIsW9ijCgLdwP9/X7Wc1UCgHE
         eqN4VCtCHIN4xZ7+9xeK89T30igIwEG4kQjD3sWqeWvNs5MMavCa9YmA0J8zhAPZMZCh
         8+K/U84YYiXioHDgeY/kxYQmIfM3lKJdflOP5EVzkw4ISesZz6CtJQ4jmMRikFMBi3Ph
         iyDDNCkKcYqrNyJKlHSKi98RzKwYiy49OaG8sg3qPnukrXA98M2ZPYQe6+9nENwG68A7
         gkOQ==
X-Gm-Message-State: AOAM532HTotEy0qcvxZm3S7VJn3l3Lx+hm6kaqii7sH6QDNcfanFzcPE
        ui4hM9jLlFI+Pp6FJsuWwyoPmLn5kuAUs7oW
X-Google-Smtp-Source: ABdhPJyP+UC6MnW7mzuyzxhlNFVHbNdh0HtixlqCawuhDQTEFGD0R0IiM94ltMeL3P6VBm+LowtXJA==
X-Received: by 2002:a62:7656:0:b029:18b:c0f:1b7a with SMTP id r83-20020a6276560000b029018b0c0f1b7amr4345030pfc.80.1604712026843;
        Fri, 06 Nov 2020 17:20:26 -0800 (PST)
Received: from dhcp-12-153.nay.redhat.com ([209.132.188.80])
        by smtp.gmail.com with ESMTPSA id hz18sm3810326pjb.13.2020.11.06.17.20.24
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Fri, 06 Nov 2020 17:20:26 -0800 (PST)
Date:   Sat, 7 Nov 2020 09:20:16 +0800
From:   Hangbin Liu <liuhangbin@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org, William Tu <u9012063@gmail.com>,
        Daniel Borkmann <daniel@iogearbox.net>, bpf@vger.kernel.org,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCHv2 net 0/2] Remove unused test_ipip.sh test and add missed
 ip6ip6 test
Message-ID: <20201107012016.GV2531@dhcp-12-153.nay.redhat.com>
References: <20201103042908.2825734-1-liuhangbin@gmail.com>
 <20201106090117.3755588-1-liuhangbin@gmail.com>
 <20201106105554.02a3142b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201106105554.02a3142b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 06, 2020 at 10:56:00AM -0800, Jakub Kicinski wrote:
> On Fri,  6 Nov 2020 17:01:15 +0800 Hangbin Liu wrote:
> > In comment 173ca26e9b51 ("samples/bpf: add comprehensive ipip, ipip6,
> > ip6ip6 test") we added some bpf tunnel tests. In commit 933a741e3b82
> > ("selftests/bpf: bpf tunnel test.") when we moved it to the current
> > folder, we missed some points:
> > 
> > 1. ip6ip6 test is not added
> > 2. forgot to remove test_ipip.sh in sample folder
> > 3. TCP test code is not removed in test_tunnel_kern.c
> > 
> > In this patch set I add back ip6ip6 test and remove unused code. I'm not sure
> > if this should be net or net-next, so just set to net.
> 
> I'm assuming you meant to tag this with the bpf tree.

Ah, yes, I mean to bpf tree. Sorry for the mistake.

Regards
Hangbin
