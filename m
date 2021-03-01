Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A4CCA32816F
	for <lists+netdev@lfdr.de>; Mon,  1 Mar 2021 15:54:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236649AbhCAOxy (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 1 Mar 2021 09:53:54 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:48914 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236607AbhCAOxe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 1 Mar 2021 09:53:34 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121EixJo133815;
        Mon, 1 Mar 2021 14:52:39 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=kKVeL6Z4Njy8dCsEa3Q/xccUs+0XHI8mGcI65iX6xJk=;
 b=oltmwo7h6cUP7haskvP374zvRGS/wlJpnmn+J8wpnSf8bcWw5rDt65uuoEN7T/z1mmrR
 lpmAQjcYPGnC9ENLJdWTkA7GQD3oWaqIgqxbjuGIgWozaOAXCg9CnjX17Obj1tDCySAj
 E0jEvJdDRo5a/EKfZb6uky5tqL9iZc2/fwEYVN6xONHE9RXzUNPzBN6sC7QgZqkfA2mr
 VoDbvkJFNh4ofANOs+T2ZuUKlG1JCxiaRddE7QjuToi0XWwQGLVy/L2q2Cw1BUPbrLg2
 oIMA/egQjBrUBL58cvNMX8gViAYqm12jAb4itzjLs8mi6zz/KodhYmXY6QLTKfInrPYc OA== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by aserp2130.oracle.com with ESMTP id 36ybkb47mb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 14:52:38 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 121Ep9Bh021988;
        Mon, 1 Mar 2021 14:52:38 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2049.outbound.protection.outlook.com [104.47.66.49])
        by aserp3020.oracle.com with ESMTP id 36yyyxhw3e-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 01 Mar 2021 14:52:38 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=nHmWwUfTfoNi0tf6+21zfYrYC2NnIVNKD6cU99OcBhdkeu/pktmiOqQEaWCK0S0RxnqSjyxD2OQ7sJAnFs39jPA1DEmcjM5zGnOjOgkN/X50oUmoO8WQt3164/Do8rb5vSizcIyG+r9+E20s5YnaAaqjZ7M/EF117i2BGW1xLWUkwGyjY7kIz/TFyZhCty8Y2s2E488PXmlOvQH/lr4L3Nvp6Fh+nqj43mmwRZvB4bmqc5zQhNfhDqFlQmA4a5jB/mgfbYhICA0V6e1ycARL2XVWEWA1EQfxwZZPr6R1cndal3LqMp9r4P4Uvrs0tEuxnICvnUkpYWyc67P/gqMSQQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKVeL6Z4Njy8dCsEa3Q/xccUs+0XHI8mGcI65iX6xJk=;
 b=cQVZDXsmpOOI73RxLLFRgmPcKm0ihOvzls14dyO+ZCz0dHTE3RN7jyeyOP/Tcqm0LBuXavZKQ0ge1uzEwt6lLw4vdfc6Hkz5DgChUCCFR2pmczpLSpwQrTLaPF6eGYAjssZcvYjj5i9SOVjGyl7JuXotK7aiE2YwKvT06ESDuqYY+fgcEefP5FixH+Rsp/J1C5MyMNwtH5iJHUSpXZyO7gVQlk+0cGI3WJ8hEFcGAcMVrb5n9geCZD5bMeTW3Xi4s9PIWUeFCWFC/pwBPbSq7Ex1AeBju/Wq08sVnkkcjsiopXM+WD/hkdJHz1J3fpz0Q5S2V26HzadrPPsgBsYhHA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=kKVeL6Z4Njy8dCsEa3Q/xccUs+0XHI8mGcI65iX6xJk=;
 b=J9tE2WdkhPuImS/J77D4X7N97eEBDJW935Lu38beuS8aR4iYImWTIzA5RCef1r+b7yUtP7MfYhYoanHIA2p31us6wGU6DpTpuHF8PqW72vUbeO3a8NgxEElF4G10nV8UG4CZJyRjEHU8er+gtMRz29NQcGzy5p6zvZDDceG9vao=
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com (2603:10b6:a03:2db::24)
 by BYAPR10MB3558.namprd10.prod.outlook.com (2603:10b6:a03:122::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3890.20; Mon, 1 Mar
 2021 14:52:35 +0000
Received: from SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b]) by SJ0PR10MB4688.namprd10.prod.outlook.com
 ([fe80::6da8:6d28:b83:702b%4]) with mapi id 15.20.3890.028; Mon, 1 Mar 2021
 14:52:35 +0000
From:   Chuck Lever <chuck.lever@oracle.com>
To:     syzbot <syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com>
CC:     Bruce Fields <bfields@fieldses.org>,
        "David S. Miller" <davem@davemloft.net>,
        "dsahern@kernel.org" <dsahern@kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        Linux-Net <netdev@vger.kernel.org>,
        "yoshfuji@linux-ipv6.org" <yoshfuji@linux-ipv6.org>,
        "syzkaller-bugs@googlegroups.com" <syzkaller-bugs@googlegroups.com>
Subject: Re: possible deadlock in ipv6_sock_mc_close
Thread-Topic: possible deadlock in ipv6_sock_mc_close
Thread-Index: AQHXDqGtiSG5D2zqzkWadWEkB6hz2KpvN8MA
Date:   Mon, 1 Mar 2021 14:52:35 +0000
Message-ID: <974A6057-4DE8-4C9A-A71E-4EC08BD8E81B@oracle.com>
References: <0000000000001d8e2c05bc79e2fd@google.com>
In-Reply-To: <0000000000001d8e2c05bc79e2fd@google.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: syzkaller.appspotmail.com; dkim=none (message not
 signed) header.d=none;syzkaller.appspotmail.com; dmarc=none action=none
 header.from=oracle.com;
x-originating-ip: [68.61.232.219]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 8b566d66-7cc7-4ca2-c693-08d8dcc1a699
x-ms-traffictypediagnostic: BYAPR10MB3558:
x-ms-exchange-minimumurldomainage: syzkaller.appspot.com#0
x-microsoft-antispam-prvs: <BYAPR10MB355866F2ABE0A382116C3E48939A9@BYAPR10MB3558.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:2276;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: R1TTYStdw9em4LAAWj/I5kPugBH2X+RAbIsbvSI5pfiVSFBCN1TI84a00wHPuqL6aXL4Fw7uWEXTT7EpCMJZzeL5D8pFfUTYqjqDRvBkW4E78QOQGtOVIz3eDpO9lzgwz5BwVDcQKhaB8vavq69NyPDafjO+FgGQSP8kiQQAmSjDE1RXkQeqqxkTakjtQQPdDd6IdjC7N/9W7kHmrXFqgmIhZTmRF0Vo4Dt3jLgZsXJ+xHPxQ1orrwiPpM+NHu2xEqt5HLr6QppXNrnf44t7gxzas+kUvDY37faOK9DMbcSSoLY29Rz270o6VR62QjVKbnphPvooIj9fx9kBGOqpbjlQo+TnXekG6wlPOS7FS5D0Ig7/kx0ysZ6Q/su30J1KPUuYUSPtILZDncTAxuMarz3szQbQQ9HkRDWZxZEvRKwFudqj3DOSslUFqDPdO1salRlAldlAlH7CXvf8ySl6+w2AYp1Z86TMFubZbcDtXOFaBewmxW3B09bRNUGXG7qG1gYdbAN5zsvDqECt9V8zuWMSlvqMNdDJ3wsJ2Pv/3qjyodDD09UwQZppA8fnJd7FDRA/9fvedLCI1p8ym3TmONUdIEhzBc8X8EtD2L6O+vfaqggE37tego/WxEa6fAO+Od4miAda0C8VsLvb/VjvfNshzaEE7+4Rq50hSo5rdg5YVsYV0DxcoxqQ0Plr4aKE
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4688.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(39860400002)(396003)(366004)(376002)(346002)(136003)(66476007)(66946007)(2906002)(8936002)(83380400001)(76116006)(86362001)(6512007)(8676002)(7416002)(66556008)(64756008)(66446008)(966005)(6506007)(91956017)(53546011)(54906003)(316002)(2616005)(26005)(33656002)(186003)(4326008)(44832011)(478600001)(6486002)(71200400001)(36756003)(5660300002)(99710200001)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?us-ascii?Q?+mRzTLlPW9iH/7ogBs0ou8CyjcepOZ0mab+Kt9BEMnjO+h1WBsX69NLGqW2U?=
 =?us-ascii?Q?qefsrA9KjrG3LaSMI5UlJAex2Kh/q7Sw38IJDnNh3yDzJBHow3V4IQZkA63Y?=
 =?us-ascii?Q?h7SESwj7A30R26xQctVKdt/4wmdqZK8Lt3I61Ty+gVnH2OOsn+82szdHSLR8?=
 =?us-ascii?Q?U+JCvc0NqG8VwVl4t+y/aXa6bUygVS4FL9DYVSrvFqSbylSTd4lEOP+IvlaP?=
 =?us-ascii?Q?HQDxj/dbYXbxULrxgJ4u37ipojBPAuxUpgj09xp2K4IyBAs0+DZ7+BCPvQOq?=
 =?us-ascii?Q?GEnEKBZLiDrpbqY5NvW7T1QSa7Z6MUz8XxnzJF/s6ZHzZBuyNxKQ10Jiwzj5?=
 =?us-ascii?Q?jcJGh1gZxPr5BVh7EvHA4kskX9BymJwoLnKAwnFCVl26WbtA21qQOf2Q7+Fl?=
 =?us-ascii?Q?lW/BPGSAJghttu1PG36a58zt9vElaXQyrvppgbTWlSIvj0v9jieibgVqLC05?=
 =?us-ascii?Q?cbe2UeIA27iLirxziZMestB+p0ub+WO8FxON7zEolKI3W+7aJPOgN5Ujix2P?=
 =?us-ascii?Q?/pmGMoL3c9L/1CwAg6YGWOFTP8iTzyBtDv25WskXXAYx7+yy6IcgxNNxgnhp?=
 =?us-ascii?Q?GekP640s/Mi5w8nu1IlAkdvWPJSXOIVRAJO8c0jDvruVX/P96E6A9uM2zEWX?=
 =?us-ascii?Q?rVRfPeFfIa4A5hhY1m4CUGYi0gxIZ3+0qADAs6PPxaPBKbZC0WzmTB0CqhM2?=
 =?us-ascii?Q?3xkGneDgbCC/z3FFUNR7CmTtJ03Gi0eM3f5dJlIBN22Lp5etlggr/JHev4Jc?=
 =?us-ascii?Q?TXHTXmb+yXwnh2SL25gXeHMqAynVwla/fYa6B4uqznpQcfm/BWbLVzKG+jY7?=
 =?us-ascii?Q?pp0Sf0URR2Vl5QaFZT3AALWpWm+RLhYhUnMXG5Xaka7IxvvEb7RfvddsYo7f?=
 =?us-ascii?Q?sWlfOMjxTK9OxIJvJJTArYFJqxs/t+uaeVrn6BJ4EjrFSRi4CZvgZkRexgGE?=
 =?us-ascii?Q?KaMfg2Kc+TIFyS/0G0V1MWh8dj/+IH5hRZES4boX8PitLcUIydB8aKAntxMj?=
 =?us-ascii?Q?vA0GdI80wiWs885wqSMSPkjE0roguh9trkVsgQzPmECD79J8YnJH0W/Stowu?=
 =?us-ascii?Q?/rTXf1VbzQBfQU1v9uDc7BsaLtInPsBoc1mLDrdMFUAOBV5JkFPhZi6I4BFm?=
 =?us-ascii?Q?LCLMwQSywNd0PTdkEkG51CHvdjOjKp8AQkHjRamnKhMNbuKh9RJTSQ8Eo+DT?=
 =?us-ascii?Q?GfsILfecb2uMoxMsuy0WxAM3cz3p9bCjIPwmKsHprx4EffW6/yC7j5f2+JuA?=
 =?us-ascii?Q?ENKql2AFbTGMPo0dKo1L1ctSKbdsJNWqr/v8nmDYdWthLUzpaF/4LE/GfTHI?=
 =?us-ascii?Q?MKcy9oKLLDKkvwh/EN97A+yo?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-ID: <3E255B9213CCC840AC52EE90E6DFD4D3@namprd10.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4688.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 8b566d66-7cc7-4ca2-c693-08d8dcc1a699
X-MS-Exchange-CrossTenant-originalarrivaltime: 01 Mar 2021 14:52:35.4122
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 06RmsQxOlwRrnvr9Ld+nHeDQqGjk546ucwiMZ+AIXgkd18KqfozRgGPlIlzAxXsLeQGYV4nG5P9r0YVXTynliw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB3558
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9910 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxlogscore=999
 phishscore=0 bulkscore=0 mlxscore=0 spamscore=0 suspectscore=0
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010126
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9909 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 impostorscore=0
 suspectscore=0 phishscore=0 bulkscore=0 mlxscore=0 lowpriorityscore=0
 clxscore=1011 mlxlogscore=999 adultscore=0 malwarescore=0
 priorityscore=1501 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2009150000 definitions=main-2103010125
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> On Mar 1, 2021, at 8:49 AM, syzbot <syzbot+e2fa57709a385e6db10f@syzkaller=
.appspotmail.com> wrote:
>=20
> Hello,
>=20
> syzbot found the following issue on:
>=20
> HEAD commit:    eee7ede6 Merge branch 'bnxt_en-error-recovery-bug-fixes'
> git tree:       net
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D123ad632d0000=
0
> kernel config:  https://syzkaller.appspot.com/x/.config?x=3De2d5ba72abae4=
f14
> dashboard link: https://syzkaller.appspot.com/bug?extid=3De2fa57709a385e6=
db10f
> syz repro:      https://syzkaller.appspot.com/x/repro.syz?x=3D109d89b6d00=
000
> C reproducer:   https://syzkaller.appspot.com/x/repro.c?x=3D12e9e0dad0000=
0
>=20
> The issue was bisected to:
>=20
> commit c8e88e3aa73889421461f878cd569ef84f231ceb
> Author: Chuck Lever <chuck.lever@oracle.com>
> Date:   Tue Nov 3 20:06:04 2020 +0000
>=20
>    NFSD: Replace READ* macros in nfsd4_decode_layoutget()
>=20
> bisection log:  https://syzkaller.appspot.com/x/bisect.txt?x=3D13bef9ccd0=
0000
> final oops:     https://syzkaller.appspot.com/x/report.txt?x=3D107ef9ccd0=
0000
> console output: https://syzkaller.appspot.com/x/log.txt?x=3D17bef9ccd0000=
0
>=20
> IMPORTANT: if you fix the issue, please add the following tag to the comm=
it:
> Reported-by: syzbot+e2fa57709a385e6db10f@syzkaller.appspotmail.com
> Fixes: c8e88e3aa738 ("NFSD: Replace READ* macros in nfsd4_decode_layoutge=
t()")
>=20
> =3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D
> WARNING: possible circular locking dependency detected
> 5.11.0-syzkaller #0 Not tainted
> ------------------------------------------------------
> syz-executor905/8822 is trying to acquire lock:
> ffffffff8d678fe8 (rtnl_mutex){+.+.}-{3:3}, at: ipv6_sock_mc_close+0xd7/0x=
110 net/ipv6/mcast.c:323
>=20
> but task is already holding lock:
> ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock include/ne=
t/sock.h:1600 [inline]
> ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0x57/=
0x130 net/mptcp/protocol.c:3507
>=20
> which lock already depends on the new lock.

Hi, thanks for the report.

Initial analysis:

c8e88e3aa738 ("NFSD: Replace READ* macros in nfsd4_decode_layoutget()"
changes code several layers above the network layer. In addition,
neither of the stack traces contain NFSD functions. And, repro.c does
not appear to exercise any filesystem code.

Therefore the bisect result looks implausible to me. I don't see any
obvious connection between the lockdep splat and c8e88e3aa738. (If
someone else does, please let me know where to look).


> the existing dependency chain (in reverse order) is:
>=20
> -> #1 (sk_lock-AF_INET6){+.+.}-{0:0}:
>       lock_sock_nested+0xca/0x120 net/core/sock.c:3071
>       lock_sock include/net/sock.h:1600 [inline]
>       gtp_encap_enable_socket+0x277/0x4a0 drivers/net/gtp.c:824
>       gtp_encap_enable drivers/net/gtp.c:855 [inline]
>       gtp_newlink+0x2b3/0xc60 drivers/net/gtp.c:683
>       __rtnl_newlink+0x1059/0x1710 net/core/rtnetlink.c:3443
>       rtnl_newlink+0x64/0xa0 net/core/rtnetlink.c:3491
>       rtnetlink_rcv_msg+0x44e/0xad0 net/core/rtnetlink.c:5553
>       netlink_rcv_skb+0x153/0x420 net/netlink/af_netlink.c:2502
>       netlink_unicast_kernel net/netlink/af_netlink.c:1312 [inline]
>       netlink_unicast+0x533/0x7d0 net/netlink/af_netlink.c:1338
>       netlink_sendmsg+0x856/0xd90 net/netlink/af_netlink.c:1927
>       sock_sendmsg_nosec net/socket.c:654 [inline]
>       sock_sendmsg+0xcf/0x120 net/socket.c:674
>       ____sys_sendmsg+0x6e8/0x810 net/socket.c:2350
>       ___sys_sendmsg+0xf3/0x170 net/socket.c:2404
>       __sys_sendmsg+0xe5/0x1b0 net/socket.c:2437
>       do_syscall_64+0x2d/0x70 arch/x86/entry/common.c:46
>       entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> -> #0 (rtnl_mutex){+.+.}-{3:3}:
>       check_prev_add kernel/locking/lockdep.c:2936 [inline]
>       check_prevs_add kernel/locking/lockdep.c:3059 [inline]
>       validate_chain kernel/locking/lockdep.c:3674 [inline]
>       __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4900
>       lock_acquire kernel/locking/lockdep.c:5510 [inline]
>       lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
>       __mutex_lock_common kernel/locking/mutex.c:946 [inline]
>       __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1093
>       ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323
>       mptcp6_release+0xb9/0x130 net/mptcp/protocol.c:3515
>       __sock_release+0xcd/0x280 net/socket.c:599
>       sock_close+0x18/0x20 net/socket.c:1258
>       __fput+0x288/0x920 fs/file_table.c:280
>       task_work_run+0xdd/0x1a0 kernel/task_work.c:140
>       tracehook_notify_resume include/linux/tracehook.h:189 [inline]
>       exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
>       exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
>       __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
>       syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
>       entry_SYSCALL_64_after_hwframe+0x44/0xae
>=20
> other info that might help us debug this:
>=20
> Possible unsafe locking scenario:
>=20
>       CPU0                    CPU1
>       ----                    ----
>  lock(sk_lock-AF_INET6);
>                               lock(rtnl_mutex);
>                               lock(sk_lock-AF_INET6);
>  lock(rtnl_mutex);
>=20
> *** DEADLOCK ***
>=20
> 2 locks held by syz-executor905/8822:
> #0: ffff888033080750 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: inode=
_lock include/linux/fs.h:775 [inline]
> #0: ffff888033080750 (&sb->s_type->i_mutex_key#13){+.+.}-{3:3}, at: __soc=
k_release+0x86/0x280 net/socket.c:598
> #1: ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: lock_sock includ=
e/net/sock.h:1600 [inline]
> #1: ffff888024390120 (sk_lock-AF_INET6){+.+.}-{0:0}, at: mptcp6_release+0=
x57/0x130 net/mptcp/protocol.c:3507
>=20
> stack backtrace:
> CPU: 1 PID: 8822 Comm: syz-executor905 Not tainted 5.11.0-syzkaller #0
> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS G=
oogle 01/01/2011
> Call Trace:
> __dump_stack lib/dump_stack.c:79 [inline]
> dump_stack+0xfa/0x151 lib/dump_stack.c:120
> check_noncircular+0x25f/0x2e0 kernel/locking/lockdep.c:2127
> check_prev_add kernel/locking/lockdep.c:2936 [inline]
> check_prevs_add kernel/locking/lockdep.c:3059 [inline]
> validate_chain kernel/locking/lockdep.c:3674 [inline]
> __lock_acquire+0x2b14/0x54c0 kernel/locking/lockdep.c:4900
> lock_acquire kernel/locking/lockdep.c:5510 [inline]
> lock_acquire+0x1ab/0x730 kernel/locking/lockdep.c:5475
> __mutex_lock_common kernel/locking/mutex.c:946 [inline]
> __mutex_lock+0x139/0x1120 kernel/locking/mutex.c:1093
> ipv6_sock_mc_close+0xd7/0x110 net/ipv6/mcast.c:323
> mptcp6_release+0xb9/0x130 net/mptcp/protocol.c:3515
> __sock_release+0xcd/0x280 net/socket.c:599
> sock_close+0x18/0x20 net/socket.c:1258
> __fput+0x288/0x920 fs/file_table.c:280
> task_work_run+0xdd/0x1a0 kernel/task_work.c:140
> tracehook_notify_resume include/linux/tracehook.h:189 [inline]
> exit_to_user_mode_loop kernel/entry/common.c:174 [inline]
> exit_to_user_mode_prepare+0x249/0x250 kernel/entry/common.c:208
> __syscall_exit_to_user_mode_work kernel/entry/common.c:290 [inline]
> syscall_exit_to_user_mode+0x19/0x50 kernel/entry/common.c:301
> entry_SYSCALL_64_after_hwframe+0x44/0xae
> RIP: 0033:0x405b73
> Code: c7 c2 c0 ff ff ff f7 d8 64 89 02 48 c7 c0 ff ff ff ff eb b7 0f 1f 0=
0 64 8b 04 25 18 00 00 00 85 c0 75 14 b8 03 00 00 00 0f 05 <48> 3d 00 f0 ff=
 ff 77 45 c3 0f 1f 40 00 48 83 ec 18 89 7c 24 0c e8
> RSP: 002b:00007ffdbac4d208 EFLAGS: 00000246 ORIG_RAX: 0000000000000003
> RAX: 0000000000000000 RBX: 0000000000000006 RCX: 0000000000405b73
> RDX: 000000000000002a RSI: 0000000000000029 RDI: 0000000000000005
> RBP: 0000000000000000 R08: 0000000000000088 R09: 0000000000f0b5ff
> R10: 00000000200001c0 R11: 0000000000000246 R12: 0000000000010bda
> R13: 00007ffdbac4d230 R14: 00007ffdbac4d220 R15: 00007ffdbac4d214
>=20
>=20
> ---
> This report is generated by a bot. It may contain errors.
> See https://goo.gl/tpsmEJ for more information about syzbot.
> syzbot engineers can be reached at syzkaller@googlegroups.com.
>=20
> syzbot will keep track of this issue. See:
> https://goo.gl/tpsmEJ#status for how to communicate with syzbot.
> For information about bisection process see: https://goo.gl/tpsmEJ#bisect=
ion
> syzbot can test patches for this issue, for details see:
> https://goo.gl/tpsmEJ#testing-patches

--
Chuck Lever



