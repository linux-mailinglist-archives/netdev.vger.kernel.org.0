Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8519A18882
	for <lists+netdev@lfdr.de>; Thu,  9 May 2019 12:48:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726650AbfEIKr5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 May 2019 06:47:57 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:39019 "EHLO
        mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726174AbfEIKr5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 9 May 2019 06:47:57 -0400
Received: from eucas1p1.samsung.com (unknown [182.198.249.206])
        by mailout2.w1.samsung.com (KnoxPortal) with ESMTP id 20190509104755euoutp02dfed98904f476357511ac61f67ca86d7~c-gaBpOPO1336013360euoutp02z
        for <netdev@vger.kernel.org>; Thu,  9 May 2019 10:47:55 +0000 (GMT)
DKIM-Filter: OpenDKIM Filter v2.11.0 mailout2.w1.samsung.com 20190509104755euoutp02dfed98904f476357511ac61f67ca86d7~c-gaBpOPO1336013360euoutp02z
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=samsung.com;
        s=mail20170921; t=1557398875;
        bh=TfyZFrlJuEyBeXKif+gNGhwH9qs/V6vJOn4rODYSeUE=;
        h=Subject:From:To:Cc:Date:In-Reply-To:References:From;
        b=P8BIfVJd/VSw5X9eKLa8U0Q3nJWWK71hnkllfu6xN+Fa9bPK265ttWu28Q/FOT682
         Odr30cG5BUu6bEBd6sgEYXa0bnT4Opie4o3k7ymyK9gLehvztJlBbOPncrm0FJoMHu
         n7JgyQlWmaOUV3B2FsWWSKHZFjybC2t3LnSsnTE8=
Received: from eusmges2new.samsung.com (unknown [203.254.199.244]) by
        eucas1p2.samsung.com (KnoxPortal) with ESMTP id
        20190509104754eucas1p2f97a86746bca69d89c8db6d6ab7c38b0~c-gZWVcLl2923129231eucas1p22;
        Thu,  9 May 2019 10:47:54 +0000 (GMT)
Received: from eucas1p2.samsung.com ( [182.198.249.207]) by
        eusmges2new.samsung.com (EUCPMTA) with SMTP id 52.40.04377.95504DC5; Thu,  9
        May 2019 11:47:54 +0100 (BST)
Received: from eusmtrp1.samsung.com (unknown [182.198.249.138]) by
        eucas1p1.samsung.com (KnoxPortal) with ESMTPA id
        20190509104753eucas1p1758b13cba5a5e18d1679b915aa786684~c-gYgIQZL0715107151eucas1p1k;
        Thu,  9 May 2019 10:47:53 +0000 (GMT)
Received: from eusmgms1.samsung.com (unknown [182.198.249.179]) by
        eusmtrp1.samsung.com (KnoxPortal) with ESMTP id
        20190509104753eusmtrp1d76dd57b1e9fc170cd7512163e6362d9~c-gYSD47b0664006640eusmtrp1a;
        Thu,  9 May 2019 10:47:53 +0000 (GMT)
X-AuditID: cbfec7f4-113ff70000001119-19-5cd4055918ec
Received: from eusmtip1.samsung.com ( [203.254.199.221]) by
        eusmgms1.samsung.com (EUCPMTA) with SMTP id F6.A5.04146.95504DC5; Thu,  9
        May 2019 11:47:53 +0100 (BST)
Received: from amdc2143 (unknown [106.120.51.59]) by eusmtip1.samsung.com
        (KnoxPortal) with ESMTPA id
        20190509104752eusmtip1c7346bd16f96ecf4944ca61406d77e9c~c-gXwmsLA0332003320eusmtip1w;
        Thu,  9 May 2019 10:47:52 +0000 (GMT)
Message-ID: <cd06d09489cd723b3cc48e42f7cccc21737bfd9e.camel@samsung.com>
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
Date:   Thu, 09 May 2019 12:47:51 +0200
In-Reply-To: <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com>
User-Agent: Evolution 3.30.5 (3.30.5-1.fc29) 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA01SWzBUcRjvv+fsOnasOZb4wjA2EuNapjmDmjQezoOHmvQQJm2cUHZpj2sm
        DKWlyGWGwsM+ZJBya4eYLLZxJ0mNLTSpxhRW49KYJpTdw+Tt+3637/tmPgITN/JtiTh5EqOQ
        S+MlAiHe1v973DOM/y7CpykPUVsddzGqevw2Tml+jgmotsIGRP1d9KAmi8oxarKzWkD1q6yp
        4sZhnKpYeo+dFtIjOS04ra7/wKM7KmdNaP2fQR6t3VDx6bVWh7OCMGFgNBMfl8IovE9dFsZq
        cs8lapzSng7XomxUAwXIlADSD1q6v6ACJCTEZB2C5dHXAq5ZR/BpuAbjmjUEmoYZ3p6lcX1u
        l6hFMNDXsOufR7DQu803qEQkDT2qrR0VQViSIaD+QRlgAekDG2+6jGYrspcHBa3TJgYCI12h
        pioXN9Q46QLaj4tG3JQ8CWv5j434QdITdM3zAi7fAoYefcM5ryO066uNoUBqTCAvu8iEWzUY
        ns9MYFxtCQsD6l3cHkbK7uOG5YDMgKHRNM6rRNDyvQpxmgBYK1UbD8BIN2jq9ObkQVC2asuV
        5qDTW3AbmENpWwXGwSJQ5om5DBdYfLmXZwcrm12782l4pVPzipFT5b5bKvfdUvl/rAphT5AN
        k8zKYhj2mJxJ9WKlMjZZHuMVlSBrRTtfNLI9sP4CdW5e0SKSQBIzUaz2bYSYL01h02VaBAQm
        sRJNlexAomhp+k1GkRCpSI5nWC2yI3CJjSjjwOdwMRkjTWKuM0wio9hjeYSpbTY6HhgQEkxP
        lGViieUJ9ifqrbfvjGU+EDkP+jv2R62nlj4sTFwO/YXJm0NCh8/q6EzlkpsyZH6uoN/pcM41
        2dWy6G2l372EmmexvmeyhhTupdTRlaWSfF3U+ICzQ50+6JLreTOPdjayx3/2RnjWtO+Fet6h
        7tVbo0f6pny/Xhys10twNlbq644pWOk/bg1zykEDAAA=
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrOIsWRmVeSWpSXmKPExsVy+t/xu7qRrFdiDL7tY7X4u7Od2WLO+RYW
        i33vz7JZbOtdzWjx/7WOxeW+acwWl3fNYbM4tkDMYsK6UywW099cZXbg8jjdtJHFY8vKm0we
        O2fdZfd4+/sEk8eh7wtYPT5vkgtgi9KzKcovLUlVyMgvLrFVija0MNIztLTQMzKx1DM0No+1
        MjJV0rezSUnNySxLLdK3S9DL2NccWLBPsWLNqeWMDYxLJboYOTkkBEwk1n15yNzFyMUhJLCU
        UeLF3i5miIS0xPEDC1khbGGJP9e62CCKnjBK/G/7yAiS4BXwkDiw4C9QAweHsICPxJaXFiBh
        NgEDie8X9oINFRE4yCQx8e1zsKHMAuoSS2c3s4DYLAKqEoduvWYHsTkFbCU+dy5hgViwnlni
        3JeLTBANmhKt23+DFYkK6Erc2PCMDWKxoMTJmU9YIGrkJba/ncM8gVFwFpKWWUjKZiEpW8DI
        vIpRJLW0ODc9t9hQrzgxt7g0L10vOT93EyMw0rYd+7l5B+OljcGHGAU4GJV4eDMOXYoRYk0s
        K67MPcQowcGsJMJ7fSJQiDclsbIqtSg/vqg0J7X4EKMp0EcTmaVEk/OBSSCvJN7Q1NDcwtLQ
        3Njc2MxCSZy3Q+BgjJBAemJJanZqakFqEUwfEwenVANjv3TXjrMvv/97/eNC52axskn/NIWt
        l5hnL8ma86P5ScT11jT1A0/Tvd/la+U3VLxUm5Hz6U38ryXzjy7L+lLuOdfuTLa7s/PiigkF
        V2Z8rHXTze6L5ha+c/z7w5hbyZHf/m99dcv+cZ8aX+381o8bD2rUf6qcMl+2Tclu/X/xnTOL
        M83+HhLbocRSnJFoqMVcVJwIAINRzYfKAgAA
X-CMS-MailID: 20190509104753eucas1p1758b13cba5a5e18d1679b915aa786684
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
        <cf34c829002177e89806e9f7260559aefb3c2ac7.camel@samsung.com>
        <afc200a8-438f-5d73-2236-6d9e4979bb59@gmail.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 2019-05-08 at 09:53 -0700, Eric Dumazet wrote:
> 
> On 5/8/19 11:56 AM, Lukasz Pawelczyk wrote:
> > On Wed, 2019-05-08 at 08:41 -0700, Eric Dumazet wrote:
> > > On 5/8/19 11:25 AM, Lukasz Pawelczyk wrote:
> > > > On Wed, 2019-05-08 at 07:58 -0700, Eric Dumazet wrote:
> > > > > On 5/8/19 10:12 AM, Lukasz Pawelczyk wrote:
> > > > > > The XT_SUPPL_GROUPS flag causes GIDs specified with
> > > > > > XT_OWNER_GID to
> > > > > > be also checked in the supplementary groups of a process.
> > > > > > 
> > > > > > Signed-off-by: Lukasz Pawelczyk <l.pawelczyk@samsung.com>
> > > > > > ---
> > > > > >  include/uapi/linux/netfilter/xt_owner.h |  1 +
> > > > > >  net/netfilter/xt_owner.c                | 23
> > > > > > ++++++++++++++++++++-
> > > > > > --
> > > > > >  2 files changed, 21 insertions(+), 3 deletions(-)
> > > > > > 
> > > > > > diff --git a/include/uapi/linux/netfilter/xt_owner.h
> > > > > > b/include/uapi/linux/netfilter/xt_owner.h
> > > > > > index fa3ad84957d5..d646f0dc3466 100644
> > > > > > --- a/include/uapi/linux/netfilter/xt_owner.h
> > > > > > +++ b/include/uapi/linux/netfilter/xt_owner.h
> > > > > > @@ -8,6 +8,7 @@ enum {
> > > > > >  	XT_OWNER_UID    = 1 << 0,
> > > > > >  	XT_OWNER_GID    = 1 << 1,
> > > > > >  	XT_OWNER_SOCKET = 1 << 2,
> > > > > > +	XT_SUPPL_GROUPS = 1 << 3,
> > > > > >  };
> > > > > >  
> > > > > >  struct xt_owner_match_info {
> > > > > > diff --git a/net/netfilter/xt_owner.c
> > > > > > b/net/netfilter/xt_owner.c
> > > > > > index 46686fb73784..283a1fb5cc52 100644
> > > > > > --- a/net/netfilter/xt_owner.c
> > > > > > +++ b/net/netfilter/xt_owner.c
> > > > > > @@ -91,11 +91,28 @@ owner_mt(const struct sk_buff *skb,
> > > > > > struct
> > > > > > xt_action_param *par)
> > > > > >  	}
> > > > > >  
> > > > > >  	if (info->match & XT_OWNER_GID) {
> > > > > > +		unsigned int i, match = false;
> > > > > >  		kgid_t gid_min = make_kgid(net->user_ns, info-
> > > > > > > gid_min);
> > > > > >  		kgid_t gid_max = make_kgid(net->user_ns, info-
> > > > > > > gid_max);
> > > > > > -		if ((gid_gte(filp->f_cred->fsgid, gid_min) &&
> > > > > > -		     gid_lte(filp->f_cred->fsgid, gid_max)) ^
> > > > > > -		    !(info->invert & XT_OWNER_GID))
> > > > > > +		struct group_info *gi = filp->f_cred-
> > > > > > > group_info;
> > > > > > +
> > > > > > +		if (gid_gte(filp->f_cred->fsgid, gid_min) &&
> > > > > > +		    gid_lte(filp->f_cred->fsgid, gid_max))
> > > > > > +			match = true;
> > > > > > +
> > > > > > +		if (!match && (info->match & XT_SUPPL_GROUPS)
> > > > > > && gi) {
> > > > > > +			for (i = 0; i < gi->ngroups; ++i) {
> > > > > > +				kgid_t group = gi->gid[i];
> > > > > > +
> > > > > > +				if (gid_gte(group, gid_min) &&
> > > > > > +				    gid_lte(group, gid_max)) {
> > > > > > +					match = true;
> > > > > > +					break;
> > > > > > +				}
> > > > > > +			}
> > > > > > +		}
> > > > > > +
> > > > > > +		if (match ^ !(info->invert & XT_OWNER_GID))
> > > > > >  			return false;
> > > > > >  	}
> > > > > >  
> > > > > > 
> > > > > 
> > > > > How can this be safe on SMP ?
> > > > > 
> > > > 
> > > > From what I see after the group_info rework some time ago this
> > > > struct
> > > > is never modified. It's replaced. Would
> > > > get_group_info/put_group_info
> > > > around the code be enough?
> > > 
> > > What prevents the data to be freed right after you fetch filp-
> > > > f_cred->group_info ?
> > 
> > I think the get_group_info() I mentioned above would. group_info
> > seems
> > to always be freed by put_group_info().
> 
> The data can be freed _before_ get_group_info() is attempted.
> 
> get_group_info() would do a use-after-free
> 
> You would need something like RCU protection over this stuff,
> this is not really only a netfilter change.
> 

sk_socket keeps reference to f_cred. f_cred keeps reference to
group_info. As long as f_cred is alive and it doesn't seem to be the
issue in the owner_mt() function, group_info should be alive as well as
far as I can see. Its refcount will go down only when f_cred is freed
(put_cred_rcu()).

If there is something I'm missing please correct me.


-- 
Lukasz Pawelczyk
Samsung R&D Institute Poland
Samsung Electronics



