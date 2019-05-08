Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EB1AB17D9D
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 17:57:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727921AbfEHP4n (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 11:56:43 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:49862 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727893AbfEHP4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 11:56:43 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190508155641euoutp02ab29d7812412ac1c56733ab131c56882~cwEt9JoIR1821018210euoutp02F
        for <netdev@vger.kernel.org>; Wed,  8 May 2019 15:56:41 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190508155641euoutp02ab29d7812412ac1c56733ab131c56882~cwEt9JoIR1821018210euoutp02F
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557331001;
        bh=xwr9JA4u04m/cCNX5V9IJpizLZY2lzXSvBKrzp1U6S4=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=dgPrq0brmbXa+J7SWzix6j/2iAWsrCgqUSRE+UGRyKD0J2VOOBFMZ2e6Xu559ONct
         9X6k0PZDc2Gj4gMxNEOXAaTZAEk4vJMKtxrbuDW6AeWiVhg1hHO7YTwRYsOb7m6m+J
         ZgERGX1hgRc3m53gbQKfcWWLasMTQdS3lA/lYKJc=
Received: from eusmges1new.samsung.com (unknown [203.254.199.242]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTP id
        20190508155640eucas1p18f0329dc7eb6957503180621c0dfabdd~cwEtPv3_T3008730087eucas1p1_;
        Wed,  8 May 2019 15:56:40 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges1new.samsung.com (EUCPMTA) with SMTP id C5.D6.04298.83CF2DC5; Wed,  8
        May 2019 16:56:40 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190508155639eucas1p216a1ad9528d5e2754945e3fb8446cc5a~cwEsWgbA01227912279eucas1p2G;
        Wed,  8 May 2019 15:56:39 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190508155639eusmtrp2772b7bcb97a0b9a48a914aa41df5c904~cwEsIbG2L0360203602eusmtrp2o;
        Wed,  8 May 2019 15:56:39 +0000 (GMT)
X-AuditID: cbfec7f2-f13ff700000010ca-a0-5cd2fc38365d
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 8A.71.04140.73CF2DC5; Wed,  8
        May 2019 16:56:39 +0100 (BST)
Received: from amdc2143 (unknown [106.120.51.59]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20190508155639eusmtip2e4321696185a593dbec179afed8b564a~cwErqWrqS0967609676eusmtip24;
        Wed,  8 May 2019 15:56:39 +0000 (GMT)
Message-ID: <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
Subject: Re: [PATCH v2] netfilter: xt_owner: Add supplementary groups option
From:   Lukasz Pawelczyk <l.pawelczyk@samsung.com>
To:     Eric Dumazet <eric.dumazet@gmail.com>,
        Pablo Neira Ayuso <pablo@netfilter.org>,
        Jozsef Kadlecsik <kadlec@blackhole.kfki.hu>,
        Florian Westphal <fw@strlen.de>,
        "David S. Miller" <davem@davemloft.net>,
        netfilter-devel@vger.kernel.org, coreteam@netfilter.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Cc:     Lukasz Pawelczyk <havner@gmail.com>
Date:   Wed, 08 May 2019 17:56:37 +0200
In-Reply-To: <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrHKsWRmVeSWpSXmKPExsWy7djPc7oWfy7FGLyeo2Dxd2c7s8Wc8y0s
        Fvven2Wz2Na7mtHi/2sdi8t905gtLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo9D3xewenzeJBfAFsVlk5Kak1mWWqRvl8CV8XHiKsaCqZIVq+duZmtgPCzU
        xcjJISFgIjHv1DfWLkYuDiGBFYwSz568YoRwvjBK3N9/D8r5zChxYcU1ti5GDrCWnXflIOLL
        GSXavk5kh3CeMUrcOXCRDWQur4CHxOmDNxhBGoQFfCS2vLQACbMJGEh8v7CXGaReROAgk0TX
        ptvsIAlmAXWJpbObWUBsFgFVifu3ZzOB2JwCthLLb78AmykqoCtxY8MzqPmCEidnPmGB6JWX
        2P52DthQCYFD7BKv3i5jh3jOReLNlAYWCFtY4tXxLVBxGYn/O+czQXxTLXHyTAVEbwejxMYX
        sxkhaqwlPk/awgxSwyygKbF+lz5EuaPE5E9SECafxI23ghAX8ElM2jadGSLMK9HRBg1cVYnX
        e2DmSUt8/LMXar+HxOEbW5gmMCrOQvLLLCS/zEJYu4CReRWjeGppcW56arFhXmq5XnFibnFp
        Xrpecn7uJkZgKjr97/inHYxfLyUdYhTgYFTi4c04dClGiDWxrLgy9xCjBAezkgjv9YlAId6U
        xMqq1KL8+KLSnNTiQ4zSHCxK4rzVDA+ihQTSE0tSs1NTC1KLYLJMHJxSDYxrljHcerfpzE9f
        EePutcmr/dPk9l+Jur7ql5FmngeTylHTlpKOyzPXrlJbULKVbcmOuW4qYc1+Aoe5syQVrm6v
        Zd5n8mufRJ521JrNi3/WCmw4++HVXD+deY6hLf8Xsv6rNL3kY/aj+tinWQu+dXtFvSgRyVr2
        u70qLNnQ+rG98A+1OXdcn71RYinOSDTUYi4qTgQAa9fDQ0EDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrGIsWRmVeSWpSXmKPExsVy+t/xe7rmfy7FGHxarm7xd2c7s8Wc8y0s
        Fvven2Wz2Na7mtHi/2sdi8t905gtLu+aw2ZxbIGYxYR1p1gspr+5yuzA5XG6aSOLx5aVN5k8
        ds66y+7x9vcJJo9D3xewenzeJBfAFqVnU5RfWpKqkJFfXGKrFG1oYaRnaGmhZ2RiqWdobB5r
        ZWSqpG9nk5Kak1mWWqRvl6CX8XHiKsaCqZIVq+duZmtgPCzUxcjBISFgIrHzrlwXIxeHkMBS
        Rol77d9Zuhg5geLSEscPLGSFsIUl/lzrYgOxhQSeMErsbWYHsXkFPCROH7zBCDJHWMBHYstL
        C5Awm4CBxPcLe5lBZooIHGSSmPj2OTNIgllAXWLp7Gaw+SwCqhL3b89mArE5BWwllt9+wQZx
        xG4miYPzFzFBNGhKtG7/DbZMVEBX4saGZ2wQiwUlTs58wgJRIy+x/e0c5gmMgrOQtMxCUjYL
        SdkCRuZVjCKppcW56bnFRnrFibnFpXnpesn5uZsYgXG27djPLTsYu94FH2IU4GBU4uHNOHQp
        Rog1say4MvcQowQHs5II7/WJQCHelMTKqtSi/Pii0pzU4kOMpkAfTWSWEk3OB6aAvJJ4Q1ND
        cwtLQ3Njc2MzCyVx3g6BgzFCAumJJanZqakFqUUwfUwcnFINjOkpyXyTli18pHvysFvTedtt
        /BvvPTFeWiAqeb9tkfg/9sP9czYWGO8IX+O02KpAl/m0/emWe2svpbed+pf18IbsfL/Xnk38
        FvyOZ1mu1ETMYmzduCJCW4ehtbbKQ0G0ba129Na0gHluCSxVWres2Sat/3s9vHTOksJMcdfb
        cgVOZksFp570U2Ipzkg01GIuKk4EAArkS5nJAgAA
X-CMS-MailID: 20190508155639eucas1p216a1ad9528d5e2754945e3fb8446cc5a
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
        <20190508141211.4191-1-l.pawelczyk@samsung.com>
        <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
        <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
        <6a6e9754-4f2b-3433-6df0-bbb9d9915582@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-08 at 08:41 -0700, Eric Dumazet wrote:
> 
> On 5/8/19 11:25 AM, Lukasz Pawelczyk wrote:
> > On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
> > > On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
> > > > The XT_SUPPL_GROUPS flag causes GIDs specified with
> > > > XT_OWNER_GID to
> > > > be also checked in the supplementary groups of a process.
> > > > 
> > > > Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
> > > > ---
> > > >  include/uapi/linux/netfilter/xt_owner.h |  1 +
> > > >  net/netfilter/xt_owner.c                | 23
> > > > ++++++++++++++++++++-
> > > > --
> > > >  2 files changed, 21 insertions(+), 3 deletions(-)
> > > > 
> > > > diff --git a/include/uapi/linux/netfilter/xt_owner.h
> > > > b/include/uapi/linux/netfilter/xt_owner.h
> > > > index fa3ad84957d5..d646f0dc3466 100644
> > > > --- a/include/uapi/linux/netfilter/xt_owner.h
> > > > +++ b/include/uapi/linux/netfilter/xt_owner.h
> > > > @@ -8,6 +8,7 @@ enum {
> > > >  	XT_OWNER_UID    = 1 << 0,
> > > >  	XT_OWNER_GID    = 1 << 1,
> > > >  	XT_OWNER_SOCKET = 1 << 2,
> > > > +	XT_SUPPL_GROUPS = 1 << 3,
> > > >  };
> > > >  
> > > >  struct xt_owner_match_info {
> > > > diff --git a/net/netfilter/xt_owner.c
> > > > b/net/netfilter/xt_owner.c
> > > > index 46686fb73784..283a1fb5cc52 100644
> > > > --- a/net/netfilter/xt_owner.c
> > > > +++ b/net/netfilter/xt_owner.c
> > > > @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct
> > > > xt_action_param *par)
> > > >  	}
> > > >  
> > > >  	if (info->match & XT_OWNER_GID) {
> > > > +		unsigned int i, match = false;
> > > >  		kgid_t gid_min = make_kgid(net->user_ns, info-
> > > > > gid_min);
> > > >  		kgid_t gid_max = make_kgid(net->user_ns, info-
> > > > > gid_max);
> > > > -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
> > > > -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
> > > > -		    !(info->invert & XT_OWNER_GID))
> > > > +		struct group_info *gi = filp->f_cred-
> > > > >group_info;
> > > > +
> > > > +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
> > > > +		    gid_lte(filp->f_cred->fsgid, gid_max))
> > > > +			match = true;
> > > > +
> > > > +		if (!match && (info->match & XT_SUPPL_GROUPS)
> > > > && gi) {
> > > > +			for (i = 0; i < gi->ngroups; ++i) {
> > > > +				kgid_t group = gi->gid[i];
> > > > +
> > > > +				if (gid_gte(group, gid_min) &&
> > > > +				    gid_lte(group, gid_max)) {
> > > > +					match = true;
> > > > +					break;
> > > > +				}
> > > > +			}
> > > > +		}
> > > > +
> > > > +		if (match ^ !(info->invert & XT_OWNER_GID))
> > > >  			return false;
> > > >  	}
> > > >  
> > > > 
> > > 
> > > How can this be safe on SMP ?
> > > 
> > 
> > From what I see after the group_info rework some time ago this
> > struct
> > is never modified. It's replaced. Would
> > get_group_info/put_group_info
> > around the code be enough?
> 
> What prevents the data to be freed right after you fetch filp-
> >f_cred->group_info ?

I think the get_group_info() I mentioned above would. group_info seems
to always be freed by put_group_info().


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



