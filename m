Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DD29B17D45
	for <lists+netdev@lfdr.de>; Wed,  8 May 2019 17:27:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727048AbfEHPZl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 May 2019 11:25:41 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:55827 "EHLO
        mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726515AbfEHPZk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 May 2019 11:25:40 -0400
Received: from eucas1p2.samsung.com (unknown [182.198.249.207])
        by mailout1.w1.samsung.com (KnoxPortal) with ESMTP id 20190508152538euoutp0127a996236be8157913bf14dd361380e6~cvpnHmMRu2226022260euoutp01q
        for <netdev@vger.kernel.org>; Wed,  8 May 2019 15:25:38 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout1.w1.samsung.com 20190508152538euoutp0127a996236be8157913bf14dd361380e6~cvpnHmMRu2226022260euoutp01q
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557329138;
        bh=cmQiyoy/MiewNCS2UA2xkRvHl0j9btQyYtxZEj9XqXI=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=uGf8glol93nSBRknSkwlEnzV5KIYJijmdPuRCyDpbUcyJk0lEl62zNORTNo1CBoEG
         bWAj36JLCF+gX05/ZC9y26dm5SWk2MllmT/s+IeNLUoibdhdioJ7HST4XN7PgQ6CBk
         ziRM0ZaO+ufHZjb7ylNPdWkyBnJbHD9Pf9xs8wI4=
Received: from eusmges3new.samsung.com (unknown [203.254.199.245]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190508152538eucas1p2e97bf92e1f167d105d1ba4791a4dd858~cvpmVjP-S1365013650eucas1p2S;
        Wed,  8 May 2019 15:25:38 +0000 (GMT)
Received: from eucas1p1.samsung.com ( [182.198.249.206]) by
        eusmges3new.samsung.com (EUCPMTA) with SMTP id F4.85.04325.1F4F2DC5; Wed,  8
        May 2019 16:25:37 +0100 (BST)
Received: from eusmtrp2.samsung.com (unknown [182.198.249.139]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTPA id
        20190508152537eucas1p232009ed92648bedd1dab8ddec9bf579b~cvplknpwv1916519165eucas1p2g;
        Wed,  8 May 2019 15:25:37 +0000 (GMT)
Received: from eusmgms2.samsung.com (unknown [182.198.249.180]) by
        eusmtrp2.samsung.com (KnoxPortal) with ESMTP id
        20190508152536eusmtrp20c0e0303488583202ffeb265e9896408~cvplWM2aJ1803118031eusmtrp2w;
        Wed,  8 May 2019 15:25:36 +0000 (GMT)
X-AuditID: cbfec7f5-b8fff700000010e5-c4-5cd2f4f1eac0
Received: from eusmtip2.samsung.com ( [203.254.199.222]) by
        eusmgms2.samsung.com (EUCPMTA) with SMTP id 5C.3F.04140.0F4F2DC5; Wed,  8
        May 2019 16:25:36 +0100 (BST)
Received: from amdc2143 (unknown [106.120.51.59]) by eusmtip2.samsung.com
        (KnoxPortal) with ESMTPA id
        20190508152536eusmtip2cc1bf9fa7da4584564656025d6b786c1~cvpk5DYK-2500525005eusmtip2r;
        Wed,  8 May 2019 15:25:36 +0000 (GMT)
Message-ID: <cdba4a3b7f31ae8ece81be270233032fe774bd86.camel@samsung.com>
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
Date:   Wed, 08 May 2019 17:25:35 +0200
In-Reply-To: <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFlrPKsWRmVeSWpSXmKPExsWy7djPc7ofv1yKMTg6Rdfi7852Zos551tY
        LPa9P8tmsa13NaPF/9c6Fpf7pjFbXN41h83i2AIxiwnrTrFYTH9zldmBy+N000YWjy0rbzJ5
        7Jx1l93j7e8TTB6Hvi9g9fi8SS6ALYrLJiU1J7MstUjfLoEr4+LRI4wFTSIVTxtWMDYwzuPv
        YuTkkBAwkWhvmMDexcjFISSwglHi9oRtTBDOF0aJvYe3QjmfGSVev3rACNPy5HQTVGI5o8Tn
        roVsEM4zRonJc5uZQap4BTwkJny4C2RzcAgL+EhseWkBEmYTMJD4fmEvM0i9iMBBJomuTbfZ
        QRLMAuoSS2c3s4DYLAKqEsuWPQKbwylgK/Hp2mywGlEBXYkbG56xQcwXlDg58wkLRK+8xPa3
        c8CGSgjsY5eYuPIZO8SpLhLPJ/1lhbCFJV4d3wIVl5H4v3M+E8hxEgLVEifPVED0djBKbHwx
        G+pNa4nPk7aAPcAsoCmxfpc+RLmjxORPUhAmn8SNt4IQF/BJTNo2nRkizCvR0SYEMUNV4vUe
        mHnSEh//7IXa7yFx+MYWpgmMirOQ/DILyS+zENYuYGRexSieWlqcm55abJyXWq5XnJhbXJqX
        rpecn7uJEZiMTv87/nUH474/SYcYBTgYlXh4Mw5dihFiTSwrrsw9xCjBwawkwnt9IlCINyWx
        siq1KD++qDQntfgQozQHi5I4bzXDg2ghgfTEktTs1NSC1CKYLBMHp1QD49yN13evmfnmyR0F
        9+U/T95avdNU6CSXiPrijZuuhqQ8b917PdgsY5fC06O3VJ5r3jqwxabrzsK8Y+W108Tsb6yM
        FPRTY2myPH7udqGDwMOaXWZHV798vihAJ1fL+aBR9Zy8Vywn+PTj/ky7VzvZTJFBZ+bG2voQ
        72gWZYPT4ltNBeMa9/M9e6jEUpyRaKjFXFScCACjy4MOQgMAAA==
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrBIsWRmVeSWpSXmKPExsVy+t/xe7ofvlyKMXh2w9Ti7852Zos551tY
        LPa9P8tmsa13NaPF/9c6Fpf7pjFbXN41h83i2AIxiwnrTrFYTH9zldmBy+N000YWjy0rbzJ5
        7Jx1l93j7e8TTB6Hvi9g9fi8SS6ALUrPpii/tCRVISO/uMRWKdrQwkjP0NJCz8jEUs/Q2DzW
        yshUSd/OJiU1J7MstUjfLkEv4+LRI4wFTSIVTxtWMDYwzuPvYuTkkBAwkXhyuompi5GLQ0hg
        KaPExWe97BAJaYnjBxayQtjCEn+udbFBFD1hlHjbcwUswSvgITHhw13mLkYODmEBH4ktLy1A
        wmwCBhLfL+xlBqkXETjIJDHx7XNmkASzgLrE0tnNLCA2i4CqxLJlj8DinAK2Ep+uzWaHWHCc
        UaLp13EWiAZNidbtv8EuEhXQlbix4RkbxGJBiZMzn0DVyEtsfzuHeQKj4CwkLbOQlM1CUraA
        kXkVo0hqaXFuem6xkV5xYm5xaV66XnJ+7iZGYKxtO/Zzyw7GrnfBhxgFOBiVeHgzDl2KEWJN
        LCuuzD3EKMHBrCTCe30iUIg3JbGyKrUoP76oNCe1+BCjKdBHE5mlRJPzgWkgryTe0NTQ3MLS
        0NzY3NjMQkmct0PgYIyQQHpiSWp2ampBahFMHxMHp1QD47WVmptEt+pwpLtonawxPMPWfkOk
        ozL/krt1t/jOvZ/Kl7MebNm0sYSPpZJBeHl8j/a89ekeN3hZj2eF9G87N8247vwpye99M5ev
        mfb01tfNK77UG6VxNa3ce9O8dLrEw5p98rN2NKZ+lV95lfHWp+dz5vV8CQ1SMdjgebx/qf2a
        uHuaQjbf1JRYijMSDbWYi4oTAf8PHN7LAgAA
X-CMS-MailID: 20190508152537eucas1p232009ed92648bedd1dab8ddec9bf579b
X-Msg-Generator: CA
Content-Type: text/plain; charset="utf-8"
X-RootMTR: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
X-EPHeader: CA
CMS-TYPE: 201P
X-CMS-RootMailID: 20190508141219eucas1p1e5a899714747b497499976113ea9681f
References: <CGME20190508141219eucas1p1e5a899714747b497499976113ea9681f@eucas1p1.samsung.com>
        <20190508141211.4191-1-l.pawelczyk@samsung.com>
        <98f71c64-3887-b715-effb-894224a71ef9@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
> 
> On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
> > The XT_SUPPL_GROUPS flag causes GIDs specified with XT_OWNER_GID to
> > be also checked in the supplementary groups of a process.
> > 
> > Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
> > ---
> >  include/uapi/linux/netfilter/xt_owner.h |  1 +
> >  net/netfilter/xt_owner.c                | 23 ++++++++++++++++++++-
> > --
> >  2 files changed, 21 insertions(+), 3 deletions(-)
> > 
> > diff --git a/include/uapi/linux/netfilter/xt_owner.h
> > b/include/uapi/linux/netfilter/xt_owner.h
> > index fa3ad84957d5..d646f0dc3466 100644
> > --- a/include/uapi/linux/netfilter/xt_owner.h
> > +++ b/include/uapi/linux/netfilter/xt_owner.h
> > @@ -8,6 +8,7 @@ enum {
> >  	XT_OWNER_UID    = 1 << 0,
> >  	XT_OWNER_GID    = 1 << 1,
> >  	XT_OWNER_SOCKET = 1 << 2,
> > +	XT_SUPPL_GROUPS = 1 << 3,
> >  };
> >  
> >  struct xt_owner_match_info {
> > diff --git a/net/netfilter/xt_owner.c b/net/netfilter/xt_owner.c
> > index 46686fb73784..283a1fb5cc52 100644
> > --- a/net/netfilter/xt_owner.c
> > +++ b/net/netfilter/xt_owner.c
> > @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb, struct
> > xt_action_param *par)
> >  	}
> >  
> >  	if (info->match & XT_OWNER_GID) {
> > +		unsigned int i, match = false;
> >  		kgid_t gid_min = make_kgid(net->user_ns, info-
> > >gid_min);
> >  		kgid_t gid_max = make_kgid(net->user_ns, info-
> > >gid_max);
> > -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
> > -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
> > -		    !(info->invert & XT_OWNER_GID))
> > +		struct group_info *gi = filp->f_cred->group_info;
> > +
> > +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
> > +		    gid_lte(filp->f_cred->fsgid, gid_max))
> > +			match = true;
> > +
> > +		if (!match && (info->match & XT_SUPPL_GROUPS) && gi) {
> > +			for (i = 0; i < gi->ngroups; ++i) {
> > +				kgid_t group = gi->gid[i];
> > +
> > +				if (gid_gte(group, gid_min) &&
> > +				    gid_lte(group, gid_max)) {
> > +					match = true;
> > +					break;
> > +				}
> > +			}
> > +		}
> > +
> > +		if (match ^ !(info->invert & XT_OWNER_GID))
> >  			return false;
> >  	}
> >  
> > 
> 
> How can this be safe on SMP ?
> 

From what I see after the group_info rework some time ago this struct
is never modified. It's replaced. Would get_group_info/put_group_info
around the code be enough?


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



