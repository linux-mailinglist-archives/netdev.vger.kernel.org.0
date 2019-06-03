Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C3DC632919
	for <lists+netdev@lfdr.de>; Mon,  3 Jun 2019 09:06:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727075AbfFCHGj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 3 Jun 2019 03:06:39 -0400
Received: from mx0a-00105401.pphosted.com ([67.231.144.184]:39712 "EHLO
        mx0a-00105401.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726383AbfFCHGi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 3 Jun 2019 03:06:38 -0400
X-Greylist: delayed 5300 seconds by postgrey-1.27 at vger.kernel.org; Mon, 03 Jun 2019 03:06:37 EDT
Received: from pps.filterd (m0072139.ppops.net [127.0.0.1])
        by mx0a-00105401.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x535Ybux039101;
        Mon, 3 Jun 2019 01:38:06 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=utc.com; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=POD040618;
 bh=mmGM8DpAUTLQB61bjxIblpunZCVeZuWEB+oaqW9Tv08=;
 b=O1IXG768lx+0PuztOiLDDmpK+tnqSK5jGkw1/VEe2VFVKBREaL04nqMnTXjU3t9lUjvx
 IKk+YHzH0NWG4vF7LM2xVKzvStCLFZWLar/YEHNtX3SaaVzvzV4D9H1YZk3cg3xBvU+8
 eMi/DpTo6X1tIGKZs6d9qadtCOW6ZWumGQjMBHB/SCn4E5E42dG9YGQX5SDNf71oPNW4
 xXjzeVptSgpqCabKjgIC9mvdy4OI/ngf73cgat4B67OUzkBHAkOCML3NWykrfHKvt8Pk
 SEStznCMSzbLKUs+S1x19cuVu8Zjcg/d2GvYrB76nIvfJG6szSs4dvffI8rWD5ABXmg5 gw== 
Received: from xnwpv35.utc.com ([167.17.239.15])
        by mx0a-00105401.pphosted.com with ESMTP id 2suj8fjne9-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=FAIL);
        Mon, 03 Jun 2019 01:38:05 -0400
Received: from uusnwa4u.utc.com (uusnwa4u.utc.com [159.82.101.254])
        by xnwpv35.utc.com (8.16.0.27/8.16.0.27) with ESMTPS id x535c4gu180201
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 01:38:04 -0400
Received: from UUSALE10.utcmail.com (UUSALE10.utcmail.com [10.220.3.17])
        by uusnwa4u.utc.com (Sentrion-MTA-4.3.2/Sentrion-MTA-4.3.2) with ESMTP id x535c0qr013866
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=OK);
        Mon, 3 Jun 2019 01:38:01 -0400
Received: from UUSALE1H.utcmail.com (10.220.3.34) by UUSALE10.utcmail.com
 (10.220.3.17) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Jun
 2019 01:38:00 -0400
Received: from UUSALE1A.utcmail.com (10.220.3.27) by UUSALE1H.utcmail.com
 (10.220.3.34) with Microsoft SMTP Server (TLS) id 15.0.1473.3; Mon, 3 Jun
 2019 01:37:59 -0400
Received: from UUSALE1A.utcmail.com ([10.220.5.27]) by UUSALE1A.utcmail.com
 ([10.220.5.27]) with mapi id 15.00.1473.003; Mon, 3 Jun 2019 01:37:59 -0400
From:   "Nagal, Amit               UTC CCS" <Amit.Nagal@utc.com>
To:     Matthew Wilcox <willy@infradead.org>
CC:     "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mm@kvack.org" <linux-mm@kvack.org>,
        "CHAWLA, RITU UTC CCS" <RITU.CHAWLA@utc.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "Netter, Christian M UTC CCS" <christian.Netter@fs.UTC.COM>
Subject: RE: [External] Re: linux kernel page allocation failure and tuning of
 page cache
Thread-Topic: [External] Re: linux kernel page allocation failure and tuning
 of page cache
Thread-Index: AdUXwJaEVv2cRvqaQPqGQFhwqLYB3QASEIWAAHE1M4A=
Date:   Mon, 3 Jun 2019 05:37:59 +0000
Message-ID: <000fd1b29190498a8577753d4e6b9ab7@UUSALE1A.utcmail.com>
References: <09c5d10e9d6b4c258b22db23e7a17513@UUSALE1A.utcmail.com>
 <20190531193035.GB15496@bombadil.infradead.org>
In-Reply-To: <20190531193035.GB15496@bombadil.infradead.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-ms-exchange-transport-fromentityheader: Hosted
x-originating-ip: [10.220.3.243]
Content-Type: text/plain; charset="Windows-1252"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-Proofpoint-Spam-Details: rule=outbound_default_notspam policy=outbound_default score=0
 priorityscore=1501 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0
 spamscore=0 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=971 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1906030040
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----Original Message-----
From: Matthew Wilcox [mailto:willy@infradead.org]=20
Sent: Saturday, June 1, 2019 1:01 AM
To: Nagal, Amit UTC CCS <Amit.Nagal@utc.com>
Cc: linux-kernel@vger.kernel.org; linux-mm@kvack.org; CHAWLA, RITU UTC CCS =
<RITU.CHAWLA@utc.com>; netdev@vger.kernel.org
Subject: [External] Re: linux kernel page allocation failure and tuning of =
page cache

> 1) the platform is low memory platform having memory 64MB.
>=20
> 2)  we are doing around 45MB TCP data transfer from PC to target using ne=
tcat utility .On Target , a process receives data over socket and writes th=
e data to flash disk .

>I think your network is faster than your disk ...

Ok . I need to check it . But how does this affect page reclaim procedure .

> 5) sometimes , we observed kernel memory getting exhausted as page alloca=
tion failure happens in kernel  with the backtrace is printed below :
> # [  775.947949] nc.traditional: page allocation failure: order:0,=20
> mode:0x2080020(GFP_ATOMIC)

>We're in the soft interrupt handler at this point, so we have very few opt=
ions for freeing memory; we can't wait for I/O to complete, for example.

>That said, this is a TCP connection.  We could drop the packet silently wi=
thout such a noisy warning.  Perhaps just collect statistics on how many pa=
ckets we dropped due to a low memory situation.

I will collect statistics for it .

> [  775.956362] CPU: 0 PID: 1288 Comm: nc.traditional Tainted: G          =
 O    4.9.123-pic6-g31a13de-dirty #19
> [  775.966085] Hardware name: Generic R7S72100 (Flattened Device Tree)=20
> [  775.972501] [<c0109829>] (unwind_backtrace) from [<c010796f>]=20
> (show_stack+0xb/0xc) [  775.980118] [<c010796f>] (show_stack) from=20
> [<c0151de3>] (warn_alloc+0x89/0xba) [  775.987361] [<c0151de3>]=20
> (warn_alloc) from [<c0152043>] (__alloc_pages_nodemask+0x1eb/0x634)
> [  775.995790] [<c0152043>] (__alloc_pages_nodemask) from [<c0152523>]=20
> (__alloc_page_frag+0x39/0xde) [  776.004685] [<c0152523>]=20
> (__alloc_page_frag) from [<c03190f1>] (__netdev_alloc_skb+0x51/0xb0) [ =20
> 776.013217] [<c03190f1>] (__netdev_alloc_skb) from [<c02c1b6f>]=20
> (sh_eth_poll+0xbf/0x3c0) [  776.021342] [<c02c1b6f>] (sh_eth_poll)=20
> from [<c031fd8f>] (net_rx_action+0x77/0x170) [  776.029051]=20
> [<c031fd8f>] (net_rx_action) from [<c011238f>]=20
> (__do_softirq+0x107/0x160) [  776.036896] [<c011238f>] (__do_softirq)=20
> from [<c0112589>] (irq_exit+0x5d/0x80) [  776.044165] [<c0112589>]=20
> (irq_exit) from [<c012f4db>] (__handle_domain_irq+0x57/0x8c) [  776.05200=
7] [<c012f4db>] (__handle_domain_irq) from [<c01012e1>] (gic_handle_irq+0x3=
1/0x48) [  776.060362] [<c01012e1>] (gic_handle_irq) from [<c0108025>] (__i=
rq_svc+0x65/0xac) [  776.067835] Exception stack(0xc1cafd70 to 0xc1cafdb8)
> [  776.072876] fd60:                                     0002751c c1dec6a=
0 0000000c 521c3be5
> [  776.081042] fd80: 56feb08e f64823a6 ffb35f7b feab513d f9cb0643=20
> 0000056c c1caff10 ffffe000 [  776.089204] fda0: b1f49160 c1cafdc4=20
> c180c677 c0234ace 200e0033 ffffffff [  776.095816] [<c0108025>]=20
> (__irq_svc) from [<c0234ace>] (__copy_to_user_std+0x7e/0x430) [ =20
> 776.103796] [<c0234ace>] (__copy_to_user_std) from [<c0241715>]=20
> (copy_page_to_iter+0x105/0x250) [  776.112503] [<c0241715>]=20
> (copy_page_to_iter) from [<c0319aeb>]=20
> (skb_copy_datagram_iter+0xa3/0x108)
> [  776.121469] [<c0319aeb>] (skb_copy_datagram_iter) from [<c03443a7>]=20
> (tcp_recvmsg+0x3ab/0x5f4) [  776.130045] [<c03443a7>] (tcp_recvmsg)=20
> from [<c035e249>] (inet_recvmsg+0x21/0x2c) [  776.137576] [<c035e249>]=20
> (inet_recvmsg) from [<c031009f>] (sock_read_iter+0x51/0x6e) [ =20
> 776.145384] [<c031009f>] (sock_read_iter) from [<c017795d>]=20
> (__vfs_read+0x97/0xb0) [  776.152967] [<c017795d>] (__vfs_read) from=20
> [<c01781d9>] (vfs_read+0x51/0xb0) [  776.159983] [<c01781d9>]=20
> (vfs_read) from [<c0178aab>] (SyS_read+0x27/0x52) [  776.166837] [<c0178a=
ab>] (SyS_read) from [<c0105261>] (ret_fast_syscall+0x1/0x54) [  776.174308=
] Mem-Info:
> [  776.176650] active_anon:2037 inactive_anon:23 isolated_anon:0 [ =20
> 776.176650]  active_file:2636 inactive_file:7391 isolated_file:32 [ =20
> 776.176650]  unevictable:0 dirty:1366 writeback:1281 unstable:0

>Almost all the dirty pages are under writeback at this point.

> [  776.176650]  slab_reclaimable:719 slab_unreclaimable:724 [ =20
> 776.176650]  mapped:1990 shmem:26 pagetables:159 bounce:0 [ =20
> 776.176650]  free:373 free_pcp:6 free_cma:0

>We have 373 free pages, but refused to allocate one of them to GFP_ATOMIC?
>I don't understand why that failed.  We also didn't try to steal an inacti=
ve_file or inactive_anon page, which seems like an obvious thing we might w=
ant to do.

Yes that's where I am concerned . we do not have swap device so I am assumi=
ng perhaps inactive_anon pages are not stolen , but inactive_file pages cou=
ld have been used .=20

> [  776.209062] Node 0 active_anon:8148kB inactive_anon:92kB=20
> active_file:10544kB inactive_file:29564kB unevictable:0kB=20
> isolated(anon):0kB isolated(file):128kB mapped:7960kB dirty:5464kB=20
> writeback:5124kB shmem:104kB writeback_tmp:0kB unstable:0kB=20
> pages_scanned:0 all_unreclaimable? no [  776.233602] Normal=20
> free:1492kB min:964kB low:1204kB high:1444kB active_anon:8148kB=20
> inactive_anon:92kB active_file:10544kB inactive_file:29564kB=20
> unevictable:0kB writepending:10588kB present:65536kB managed:59304kB=20
> mlocked:0kB slab_reclaimable:2876kB slab_unreclaimable:2896kB=20
> kernel_stack:1152kB pagetables:636kB bounce:0kB free_pcp:24kB=20
> local_pcp:24kB free_cma:0kB [  776.265406] lowmem_reserve[]: 0 0 [ =20
> 776.268761] Normal: 7*4kB (H) 5*8kB (H) 7*16kB (H) 5*32kB (H) 6*64kB=20
> (H) 2*128kB (H) 2*256kB (H) 0*512kB 0*1024kB 0*2048kB 0*4096kB =3D=20
> 1492kB
> 10071 total pagecache pages
> [  776.284124] 0 pages in swap cache
> [  776.287446] Swap cache stats: add 0, delete 0, find 0/0 [ =20
> 776.292645] Free swap  =3D 0kB [  776.295532] Total swap =3D 0kB [ =20
> 776.298421] 16384 pages RAM [  776.301224] 0 pages HighMem/MovableOnly=20
> [  776.305052] 1558 pages reserved
