Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7EA23AC65
	for <lists+netdev@lfdr.de>; Mon,  3 Aug 2020 20:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728672AbgHCScC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Aug 2020 14:32:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42342 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726130AbgHCScB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Aug 2020 14:32:01 -0400
Received: from mail-pj1-x1043.google.com (mail-pj1-x1043.google.com [IPv6:2607:f8b0:4864:20::1043])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 78A5DC06174A
        for <netdev@vger.kernel.org>; Mon,  3 Aug 2020 11:32:01 -0700 (PDT)
Received: by mail-pj1-x1043.google.com with SMTP id t6so455013pjr.0
        for <netdev@vger.kernel.org>; Mon, 03 Aug 2020 11:32:01 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4ui5F+JM1N2WnxBRLdBr/CFJ0gbiimaakgSRCQJFDGA=;
        b=b5PUoiYI40oVvSs9Yndmd1+54fBkVKq6Bgnw7pZAP30rghAufID/G8oiD9ELp+LEaX
         4HzkQUelGZBS5++Dip9QbdvuuCNenSsUcWvYCN4yCW4hkS+qeIFk+SJrYb6lIA/v4Bbu
         R0RE4ewZq/1T8fsLZTmdlVmUe0sMUQiG6kaISRkQhKcn7RJRgHO5bphhpCGxL0sHQ2G/
         6dxrPc9zQJ9ii4+zQvIAAHCzttFkeICGgM6dv+peAUBJkzqd89x1OJBo+tQPc3QKsTMe
         9liUu5tUEdqAJ2rqztB6sxEdu+s22Wxd5nCUwcpGl4Yt+OzFpSdDE1ieAG6i8AlGHTNJ
         9v7Q==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4ui5F+JM1N2WnxBRLdBr/CFJ0gbiimaakgSRCQJFDGA=;
        b=gfogz5Nlh8TZySFCXo1R7JBQk53ebsyUP5nQMi2eoyLzbGLE/fCI/Gdn0wEaDCFMnf
         UhebwmatWuqhj65L/h8uxxky6X4wMjJPWVNh4Hg5GpCvb446qyx1x5azKvi7EnM2VJGC
         DGmhypsfJWFXR65Anbv9487YiCIonF4Qb8hkW9MqY7tL/0oHVlUt942POrRXvdwqLyXh
         gwBbYOp8djkDKuXRbo+lHTVEGMNYT5MzDHfGdsl2aVTveSAfqamB0DgzyVIzKDSeqrQk
         RIPDbfG6HOyOYJzowh/0TPPvof+HdXStAbnYZvWtwDlumowPg8adXqbBF99wIeCquDV3
         /7Rw==
X-Gm-Message-State: AOAM533VOJWn/AQKF4D8/rg3RGy9Giv4UnqrkN8eR+5ljzQnTeSQa7Cs
        oha/aVs+vzE5upEJ5+dogSU/Vg==
X-Google-Smtp-Source: ABdhPJyqO4E3MtTng8xXZCJNZqSQXKPh7aaxWwjiaWU82Wl/tGm9FVchKO98CEGl7WYaUUx2Epv+sQ==
X-Received: by 2002:a17:90a:8545:: with SMTP id a5mr566014pjw.91.1596479520635;
        Mon, 03 Aug 2020 11:32:00 -0700 (PDT)
Received: from google.com (56.4.82.34.bc.googleusercontent.com. [34.82.4.56])
        by smtp.gmail.com with ESMTPSA id e124sm19507562pfe.176.2020.08.03.11.31.59
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 03 Aug 2020 11:31:59 -0700 (PDT)
Date:   Mon, 3 Aug 2020 18:31:56 +0000
From:   William Mcvicker <willmcvicker@google.com>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     security@kernel.org, Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        Alexey Kuznetsov <kuznet@ms2.inr.ac.ru>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        kernel-team@android.com, stable@vger.kernel.org
Subject: Re: [PATCH v2 1/1] netfilter: nat: add a range check for l3/l4
 protonum
Message-ID: <20200803183156.GA3084830@google.com>
References: <20200727175720.4022402-1-willmcvicker@google.com>
 <20200727175720.4022402-2-willmcvicker@google.com>
 <20200729214607.GA30831@salvia>
 <20200731002611.GA1035680@google.com>
 <20200731175115.GA16982@salvia>
 <20200731181633.GA1209076@google.com>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="pf9I7BMVVzbSWLtt"
Content-Disposition: inline
In-Reply-To: <20200731181633.GA1209076@google.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--pf9I7BMVVzbSWLtt
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

Hi,

I have attached the follow up fix that checks for the proto index during
conntrack creation.

Thanks,
Will

On 07/31/2020, William Mcvicker wrote:
> Hi Pablo,
> 
> > Note that this code does not exist in the tree anymore. I'm not sure
> > if this problem still exists upstream, this patch does not apply to
> > nf.git. This fix should only go for -stable maintainers.
> 
> Right, the vulnerability has been fixed by the refactor commit fe2d0020994cd
> ("netfilter: nat: remove l4proto->in_range"), but this patch is a part of
> a full re-work of the code and doesn't backport very cleanly to the LTS
> branches. So this fix is only applicable to the 4.19, 4.14, 4.9, and 4.4 LTS
> branches. I missed the -stable email, but will re-add it to this thread with
> the re-worked patch.
> 
> Thanks,
> Will
> 
> On 07/31/2020, Pablo Neira Ayuso wrote:
> > Hi William,
> > 
> > On Fri, Jul 31, 2020 at 12:26:11AM +0000, William Mcvicker wrote:
> > > Hi Pablo,
> > > 
> > > Yes, I believe this oops is only triggered by userspace when the user
> > > specifically passes in an invalid nf_nat_l3protos index. I'm happy to re-work
> > > the patch to check for this in ctnetlink_create_conntrack().
> > 
> > Great.
> > 
> > Note that this code does not exist in the tree anymore. I'm not sure
> > if this problem still exists upstream, this patch does not apply to
> > nf.git. This fix should only go for -stable maintainers.
> > 
> > > > BTW, do you have a Fixes: tag for this? This will be useful for
> > > > -stable maintainer to pick up this fix.
> > > 
> > > Regarding the Fixes: tag, I don't have one offhand since this bug was reported
> > > to me, but I can search through the code history to find the commit that
> > > exposed this vulnerability.
> > 
> > That would be great.
> > 
> > Thank you.

--pf9I7BMVVzbSWLtt
Content-Type: text/x-diff; charset=us-ascii
Content-Disposition: attachment;
	filename="0001-netfilter-nat-add-a-range-check-for-l3-l4-protonum.patch"

From 2a9d621fa5c225e6aece6b4622a9a816c6fcfa0d Mon Sep 17 00:00:00 2001
From: Will McVicker <willmcvicker@google.com>
Date: Fri, 31 Jul 2020 13:10:43 -0700
Subject: [PATCH] netfilter: nat: add a range check for l3/l4 protonum

The indexes to the nf_nat_l[34]protos arrays come from userspace. So
check the tuple's family, e.g. l3num, when creating the conntrack in
order to prevent an OOB memory access during setup.  Here is an example
kernel panic on 4.14.180 when userspace passes in an index greater than
NFPROTO_NUMPROTO.

Internal error: Oops - BUG: 0 [#1] PREEMPT SMP
Modules linked in:...
Process poc (pid: 5614, stack limit = 0x00000000a3933121)
CPU: 4 PID: 5614 Comm: poc Tainted: G S      W  O    4.14.180-g051355490483
Hardware name: Qualcomm Technologies, Inc. SM8150 V2 PM8150 Google Inc. MSM
task: 000000002a3dfffe task.stack: 00000000a3933121
pc : __cfi_check_fail+0x1c/0x24
lr : __cfi_check_fail+0x1c/0x24
...
Call trace:
__cfi_check_fail+0x1c/0x24
name_to_dev_t+0x0/0x468
nfnetlink_parse_nat_setup+0x234/0x258
ctnetlink_parse_nat_setup+0x4c/0x228
ctnetlink_new_conntrack+0x590/0xc40
nfnetlink_rcv_msg+0x31c/0x4d4
netlink_rcv_skb+0x100/0x184
nfnetlink_rcv+0xf4/0x180
netlink_unicast+0x360/0x770
netlink_sendmsg+0x5a0/0x6a4
___sys_sendmsg+0x314/0x46c
SyS_sendmsg+0xb4/0x108
el0_svc_naked+0x34/0x38

Fixes: c1d10adb4a521 ("[NETFILTER]: Add ctnetlink port for nf_conntrack")
Signed-off-by: Will McVicker <willmcvicker@google.com>
---
 net/netfilter/nf_conntrack_netlink.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/net/netfilter/nf_conntrack_netlink.c b/net/netfilter/nf_conntrack_netlink.c
index 31fa94064a62..56d310f8b29a 100644
--- a/net/netfilter/nf_conntrack_netlink.c
+++ b/net/netfilter/nf_conntrack_netlink.c
@@ -1129,6 +1129,8 @@ ctnetlink_parse_tuple(const struct nlattr * const cda[],
 	if (!tb[CTA_TUPLE_IP])
 		return -EINVAL;
 
+	if (l3num >= NFPROTO_NUMPROTO)
+		return -EINVAL;
 	tuple->src.l3num = l3num;
 
 	err = ctnetlink_parse_tuple_ip(tb[CTA_TUPLE_IP], tuple);
-- 
2.28.0.163.g6104cc2f0b6-goog


--pf9I7BMVVzbSWLtt--
