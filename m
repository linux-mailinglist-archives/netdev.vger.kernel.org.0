Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CFC04592A9
	for <lists+netdev@lfdr.de>; Mon, 22 Nov 2021 17:07:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233330AbhKVQLD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Nov 2021 11:11:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40536 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231787AbhKVQLD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Nov 2021 11:11:03 -0500
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0983BC061574
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:07:57 -0800 (PST)
Received: by mail-qt1-x829.google.com with SMTP id j17so16998941qtx.2
        for <netdev@vger.kernel.org>; Mon, 22 Nov 2021 08:07:57 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:subject:message-id:references:mime-version
         :content-disposition:in-reply-to;
        bh=4DDrKx9zqyJDwx5M+Te42GDRR5Rdu8n0yFzx3k8jFjY=;
        b=GY6WsHbJlUldHRburLwwLdpZU4RSSC/WDALt5euUTPVAfMTBHQ9osO33e8v/CSfkxo
         hI1YSmnUqkQ4fiYAJeA3PZTslb3ARoNo3eLyQTnq3ASSaCtjEA5Ac9UWjfwKxgq1LbTo
         kDQvP7niaPQk4S5RujYHnukrPbGrUP4rahEovWnfIs7eLbKAaicSrFsuLnod65fLAGTE
         2hpxVMYSuv/zujHz+PWUiP6zeLOMAzfKlk9bW2fnlEp4/6OXBlDGcku3huzjNfzp4+Kb
         BQyuhnYd7+kxJ0XsotwHt/TrYgIH+uHmlQiWffkM47GGvF3AXroyatv8rI+RWlAyjpbU
         M6cg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=4DDrKx9zqyJDwx5M+Te42GDRR5Rdu8n0yFzx3k8jFjY=;
        b=E+CDI4/IxxSAW1KODyTgWlVS+Rjpqa0rji2muGTgZVevc1ofrbypvGVa8PmhHUIKKS
         azR8W93BVBvOQhYXTJR8j8z9buanvkXlAso5HNeCh2tVCmNdu4CY23OQMxc/nh3qn9t/
         M3ug8t9YYRlBcHpVVDC9Vfgwrg0sGIU6vNTcKQLXdo85/yc/0duMT47dasNNFMlAyR5a
         F8Wip+WgSLnycgCrlPTHhu06/O4O0d1xYIH3kpiIqvBH8O7GLhqYL2moTticNlS2WH/N
         5cyBl2eYin6NIW4t11ibr4RlPpQhYRR8rX+YbrhO81+LKLRJFB6H4c5E66beYAUqm82a
         gmow==
X-Gm-Message-State: AOAM5329X1gPR2zpBx7KQkN99IfF811u4kWBee9wRHHTWKTAA5HxZEHG
        pyx7mPO9NuzAg9BgB4NXnjyfl5cBSQ==
X-Google-Smtp-Source: ABdhPJwqf8SzkC7ONs+xf9CLo9ueJp0foF7JmEs9qympiUEIqzqO0YWWAEvYz75YxT91ifQsld5jLw==
X-Received: by 2002:ac8:183:: with SMTP id x3mr31431997qtf.270.1637597276046;
        Mon, 22 Nov 2021 08:07:56 -0800 (PST)
Received: from ssuryadesk ([136.56.65.87])
        by smtp.gmail.com with ESMTPSA id p18sm4622956qtk.54.2021.11.22.08.07.55
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 22 Nov 2021 08:07:55 -0800 (PST)
Date:   Mon, 22 Nov 2021 11:07:54 -0500
From:   Stephen Suryaputra <ssuryaextr@gmail.com>
To:     netdev@vger.kernel.org, dsahern@gmail.com, ebiederm@xmission.com,
        roopa@nvidia.com
Subject: Re: IPCB isn't initialized when MPLS route is pointing to a VRF
Message-ID: <20211122160754.GB95191@ssuryadesk>
References: <20211122160546.GA95191@ssuryadesk>
MIME-Version: 1.0
Content-Type: multipart/mixed; boundary="ibTvN161/egqYuK8"
Content-Disposition: inline
In-Reply-To: <20211122160546.GA95191@ssuryadesk>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--ibTvN161/egqYuK8
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline

With the attachments this time.

On Mon, Nov 22, 2021 at 11:05:46AM -0500, Stephen Suryaputra wrote:
> Hi,
> 
> We ran into a problem because IPCB isn't being initialized when MPLS is
> egressing into a VRF. Reproducer script and its teardown are attached,
> but they are only to illustrate our setup rather than seeing the problem
> as it depends on what is in the skb->cb[].
> 
> We found this when h0 is sending an ip packet with DF=1 to 10.1.4.2 and
> on ler1 the code path is as follows: mpls_forward() calls mpls_egress()
> and then calls neigh_xmit(), which ends up calling __dev_queue_xmit()
> and vrf_xmit() through dev_hard_start_xmit(). vrf_xmit() eventually will
> call ip_output() and __ip_finish_output() that has the check for
> IPCB(skb)->frag_max_size. The conditional happens to be true for us due
> to IPCB isn't being initialized even though the packet size is small.
> The packet then is dropped in ip_fragment().
> 
> The change in this diff is a way to fix:
> 
> diff --git a/net/mpls/af_mpls.c b/net/mpls/af_mpls.c
> index ffeb2df8be7a..1d0a0151e175 100644
> --- a/net/mpls/af_mpls.c
> +++ b/net/mpls/af_mpls.c
> @@ -310,6 +310,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
>  			      htons(hdr4->ttl << 8),
>  			      htons(new_ttl << 8));
>  		hdr4->ttl = new_ttl;
> +		memset(IPCB(skb), 0, sizeof(*IPCB(skb)));
>  		success = true;
>  		break;
>  	}
> @@ -327,6 +328,7 @@ static bool mpls_egress(struct net *net, struct mpls_route *rt,
>  			hdr6->hop_limit = dec.ttl;
>  		else if (hdr6->hop_limit)
>  			hdr6->hop_limit = hdr6->hop_limit - 1;
> +		memset(IP6CB(skb), 0, sizeof(*IP6CB(skb)));
>  		success = true;
>  		break;
>  	}
> 
> Here are my questions. Is this the best place to initialize the IPCB?
> Would it be better done in vrf.c? I can work on the formal patch once we
> agree on where the final fix should be 
> 
> Cc Florian Westphal since we found the problem after upgrading to kernel
> version that has his commit bb4cc1a18856 ("net: ip: always refragment ip
> defragmented packets"). But I think the bug is there without his commit
> as well if (IPCB(skb)->flags & IPCB_FRAG_PMTU) happens to evaluate to
> true.
> 
> Thanks,
> 
> Stephen.

--ibTvN161/egqYuK8
Content-Type: application/x-sh
Content-Disposition: attachment; filename="mpls_test.sh"
Content-Transfer-Encoding: quoted-printable

#=0A# +-------+   +------------+   +-----------+   +------------+   +------=
-+=0A# | h0 v0-+---+-v1 ler0 v2-+---+-v3 lsr v4-+---+-v5 ler1 v6-+---+-v7 h=
1 |=0A# +-------+   +------------+   +-----------+   +------------+   +----=
---+=0A# 10.1.x.x=0A#   1.2/24     1.1/24                                 4=
=2E1/24     4.2/24=0A#                   2.1/24      2.2/24=0A#            =
                        3.1/24     3.2/24=0A#=0Amodprobe mpls_router=0Amodp=
robe mpls_iptunnel=0A=0Aip link add v0 type veth peer name v1=0Aip link add=
 v2 type veth peer name v3=0Aip link add v4 type veth peer name v5=0Aip lin=
k add v6 type veth peer name v7=0A=0Aip netns add h0=0Aip netns add ler0=0A=
ip netns add ler1=0Aip netns add lsr=0Aip netns add h1=0A=0Aip link set v0 =
netns h0=0Aip link set v1 netns ler0=0Aip link set v2 netns ler0=0Aip link =
set v3 netns lsr=0Aip link set v4 netns lsr=0Aip link set v5 netns ler1=0Ai=
p link set v6 netns ler1=0Aip link set v7 netns h1=0A=0Aip netns exec ler0 =
ip link add dev vrfA type vrf table 259=0Aip netns exec ler0 ip -4 route ad=
d table 259 unreachable default metric 4278198272=0Aip netns exec ler0 ip l=
ink set dev v1 master vrfA=0A=0Aip netns exec ler1 ip link add dev vrfA typ=
e vrf table 259=0Aip netns exec ler1 ip -4 route add table 259 unreachable =
default metric 4278198272=0Aip netns exec ler1 ip link set dev v6 master vr=
fA=0A=0Aip netns exec h0   ip address add 10.1.1.2/24 dev v0=0Aip netns exe=
c ler0 ip address add 10.1.1.1/24 dev v1=0Aip netns exec ler0 ip address ad=
d 10.1.2.1/24 dev v2=0Aip netns exec lsr  ip address add 10.1.2.2/24 dev v3=
=0Aip netns exec lsr  ip address add 10.1.3.1/24 dev v4=0Aip netns exec ler=
1 ip address add 10.1.3.2/24 dev v5=0Aip netns exec ler1 ip address add 10.=
1.4.1/24 dev v6=0Aip netns exec h1   ip address add 10.1.4.2/24 dev v7=0A=
=0Aip netns exec h0   ip link set v0 up=0Aip netns exec ler0 ip link set vr=
fA up=0Aip netns exec ler0 ip link set v1 up=0Aip netns exec ler0 ip link s=
et v2 up=0Aip netns exec lsr  ip link set v3 up=0Aip netns exec lsr  ip lin=
k set v4 up=0Aip netns exec ler1 ip link set vrfA up=0Aip netns exec ler1 i=
p link set v5 up=0Aip netns exec ler1 ip link set v6 up=0Aip netns exec h1 =
  ip link set v7 up=0A=0Aip netns exec h0 ip route add default via 10.1.1.1=
=0Aip netns exec h1 ip route add default via 10.1.4.1=0A=0Aip netns exec le=
r0 sysctl -w net.mpls.platform_labels=3D1048575=0Aip netns exec ler0 sysctl=
 -w net.mpls.conf.v2.input=3D1=0Aip netns exec ler0 ip route add 10.1.4.0/2=
4 encap mpls 111 via inet 10.1.2.2 table 259=0Aip netns exec ler0 ip -f mpl=
s route add 223 dev vrfA=0Aip netns exec ler0 sysctl -w net.ipv4.conf.all.f=
orwarding=3D1=0A=0Aip netns exec ler1 sysctl -w net.mpls.platform_labels=3D=
1048575=0Aip netns exec ler1 sysctl -w net.mpls.conf.v5.input=3D1=0Aip netn=
s exec ler1 ip route add 10.1.1.0/24 encap mpls 222 via inet 10.1.3.1 table=
 259=0Aip netns exec ler1 ip -f mpls route add 112 dev vrfA=0Aip netns exec=
 ler1 sysctl -w net.ipv4.conf.all.forwarding=3D1=0A=0Aip netns exec lsr  sy=
sctl -w net.mpls.platform_labels=3D1048575=0Aip netns exec lsr  sysctl -w n=
et.mpls.conf.v3.input=3D1=0Aip netns exec lsr  sysctl -w net.mpls.conf.v4.i=
nput=3D1=0Aip netns exec lsr  ip -f mpls route add 111 as 112 via inet 10.1=
=2E3.2=0Aip netns exec lsr  ip -f mpls route add 222 as 223 via inet 10.1.2=
=2E1=0Aip netns exec lsr  sysctl -w net.ipv4.conf.all.forwarding=3D1=0A
--ibTvN161/egqYuK8
Content-Type: application/x-sh
Content-Disposition: attachment; filename="mpls_teardown.sh"
Content-Transfer-Encoding: quoted-printable

ip netns exec h0   ip link del v0=0Aip netns exec ler0 ip link del v2=0Aip =
netns exec lsr  ip link del v4=0Aip netns exec ler1 ip link del v6=0A=0Aip =
netns exec ler0 ip link del vrfA=0Aip netns exec ler1 ip link del vrfA=0A=
=0Aip netns del h0=0Aip netns del ler0=0Aip netns del ler1=0Aip netns del l=
sr=0Aip netns del h1=0A=0Asleep 2=0A=0Amodprobe -r mpls_iptunnel=0Amodprobe=
 -r mpls_router=0A=0A
--ibTvN161/egqYuK8--
