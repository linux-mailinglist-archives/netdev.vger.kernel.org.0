Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E481D37F1EC
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 06:19:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230329AbhEMEUV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 00:20:21 -0400
Received: from mail-mw2nam12on2121.outbound.protection.outlook.com ([40.107.244.121]:12449
        "EHLO NAM12-MW2-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S229471AbhEMEUS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 13 May 2021 00:20:18 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=WukBPkcLruETHLPwA4gXmcWAKMJx8VwyNmxRl2SN3gsV+LhBZUvk2M/Yg4MfMbvXgw4uizR0et73ZiRan3rXfr5jW+aZPuuJpW1uVnkvaWwGRhlmnmPAraZFz8M1QAejeFN7/5sUDpq8QlBkqTHGeD59hco2PtZiPsq6NwGHFowCjDvrdFFXucBHYTayfWZc9Zybl00q+QE0BGPhto05QllLOMjQcEkVTMcNaGFVb5IHqbkDMlda4fv+UFx04ttK6qjs+r3dHOBM1k3bz2s6ams4SaWmSna2VbFdv2GXc79Ra5NnshR5M/rcG5BVMx4k9J/pDbforgbrewFR1oG2vA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhNcq++sUm/e7q30tV1vQSynQKhWdsK5pR6opyv5vcI=;
 b=KFJkZDVYABSQOAkXK8nk+fEOa+7qX2XQ9F+gbpxnbjoHsB9ZpLuUCBUlJvJFnGQ/hPyymyVU6yoS7lTdqRuL1zkG+EjIGyjO4tclk9C+iWLGw/fqzjRuptGelfQ6eUALrVWjwsSHekh6S57rRbwLgxvhAw90kX4en1UBlC2R/fOuZW5eb5aMO7ed+fvMbLeZho8UYYGVdqGTfYKnumK7e+HqF8OVVf3r5PhTLL9Nv7rgjxsg4BxnGaU07EyeEoWz5eYSTEr92P9SykusxRx+gZuHeYjiFJXnhZkCLFdSrvD4ckavEQa+MTCr+HC46QTw8wpN73ciy6ezL8K4rqWk5A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=microsoft.com; dmarc=pass action=none
 header.from=microsoft.com; dkim=pass header.d=microsoft.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=qhNcq++sUm/e7q30tV1vQSynQKhWdsK5pR6opyv5vcI=;
 b=NkYs6H988cnS4i81GhuUT5MFkz4R/4TNMWPfLSY+u+3bLyS7VVZcjmuSXh0mSJqOixw8UHCcBm1bsWVUHyDceHurJmTBwZlelDcm2661vG0YmOohOR9a3204r0bVdzjjKV22xrxrx0dnTi00vtQiu3GKinLY3ocdsWnSLmc9HgQ=
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 (2603:10b6:302:10::24) by MWHPR21MB0751.namprd21.prod.outlook.com
 (2603:10b6:300:76::13) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4150.7; Thu, 13 May
 2021 04:19:07 +0000
Received: from MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d]) by MW2PR2101MB0892.namprd21.prod.outlook.com
 ([fe80::5548:cbd8:43cd:aa3d%5]) with mapi id 15.20.4150.012; Thu, 13 May 2021
 04:19:07 +0000
From:   Dexuan Cui <decui@microsoft.com>
To:     "'netfilter-devel@vger.kernel.org'" <netfilter-devel@vger.kernel.org>,
        "'netdev@vger.kernel.org'" <netdev@vger.kernel.org>
CC:     Stephen Hemminger <sthemmin@microsoft.com>,
        Haiyang Zhang <haiyangz@microsoft.com>,
        "'linux-kernel@vger.kernel.org'" <linux-kernel@vger.kernel.org>
Subject: RE: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Topic: netfilter: iptables-restore: setsockopt(3, SOL_IP,
 IPT_SO_SET_REPLACE, "security...", ...) return -EAGAIN 
Thread-Index: AddHdN+snMbFwQLHQSmZ6J2vO7HZjQAM7kqQ
Date:   Thu, 13 May 2021 04:19:06 +0000
Message-ID: <MW2PR2101MB0892864684CFDB096E0DBF02BF519@MW2PR2101MB0892.namprd21.prod.outlook.com>
References: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
In-Reply-To: <MW2PR2101MB0892FC0F67BD25661CDCE149BF529@MW2PR2101MB0892.namprd21.prod.outlook.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ActionId=356357d2-2a65-4b3e-86cf-03509df80d8d;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_ContentBits=0;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Enabled=true;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Method=Standard;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_Name=Internal;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SetDate=2021-05-12T21:20:54Z;MSIP_Label_f42aa342-8706-4288-bd11-ebb85995028c_SiteId=72f988bf-86f1-41af-91ab-2d7cd011db47;
authentication-results: vger.kernel.org; dkim=none (message not signed)
 header.d=none;vger.kernel.org; dmarc=none action=none
 header.from=microsoft.com;
x-originating-ip: [2601:600:8b00:6b90:9d16:8ec9:e190:4c0c]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: ec44c5fb-2226-4053-c3ea-08d915c63ff1
x-ms-traffictypediagnostic: MWHPR21MB0751:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR21MB0751045392E9CEB3F238D9CFBF519@MWHPR21MB0751.namprd21.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:3631;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: c1g1stuDx3rajWyqLq4yDp1sXB1Ru2Yg+kfTO2yC6pH23D+Tc8lR5L9cxeOdmUD5AntnttP+SB19IozuMbFzDl/fewGgvtSdEk3HttFO73RToBV2nGllqlW8eOgUpaKDFaE4SN8+7930/vtoLNvoOecEHRnGTdjsgvN75hjlLX5CjDlGDCssW/abvWzoNpiMTBgzLY6gxy/+2ptKP/7X5UTfCdkS+ItCNxsGjCjUGb59fCwyqqZTOZTVcI6++rzMMYZ1UaKB1ec5de48CoFbEZJRweqfVfhABpySZbPb777mPG/6ObLB0+VH+jxiFHkzhvaUjb9bb9NlLNw/C0MMsi/Sg5J6ACLJXRbFjCCegVLZ9QTjrg0i5nlAR7X1D/etacLEmAfi8202mvabO8EmClj31bMmrWh6kbIcvuDHmojnOkXfeRTJA1WdL925D3+CIhdCouE0Awuw9c9GWcCdGYUzjmM04lKphhG25d3P++Io+xJ6IySmU2mq0aw38DXaHNs0vbvR/TtaUmneU1DqPJV1eNUFkQ7Qo0FLqg4+Ld1oiWsa/gcYw518zzV9dEg0BWCqOvAT83fvjxfyh7sbRczQJpxCA2xQuJhD1ulH1JehDn/P3ukUwD8R+GU1lLP882xC7imH9mxdpv8Uv7U38+5QvqYbl4LzB8W/G1ngDkTqcOca+IxoJkZCctP4BoNPPyApePynEuqDHxmLKLaBfETkqQyAipqW9j6z96IIThNnI/Np8kJ4vZxzDtxBmVd0RaypAH6K+7xhl58RTBBDCg==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW2PR2101MB0892.namprd21.prod.outlook.com;PTR:;CAT:NONE;SFS:(4636009)(366004)(64756008)(66556008)(66476007)(66946007)(83380400001)(8676002)(6506007)(76116006)(66446008)(7696005)(38100700002)(122000001)(10290500003)(33656002)(8936002)(4743002)(2906002)(86362001)(186003)(54906003)(52536014)(8990500004)(110136005)(82950400001)(15650500001)(55016002)(478600001)(316002)(82960400001)(450100002)(4326008)(5660300002)(71200400001)(9686003)(491001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 2
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?2GCmt2jdqwpGPdkQLdVL9jYi3tQMxPDrrr6/t90YiN9sUfhvI/avFDMw4+Zg?=
 =?us-ascii?Q?DUxbNYeFP/13By5E+lTuKLSKPjTXGkOyp0yAxEMqMs3rT1Cq/WcRefpTe6yL?=
 =?us-ascii?Q?ufIh4wnBaO5PmsYIDx2ICpr3PmAGp3OlzDa6SgDTg4bJOZVZ/582tFN/0+hp?=
 =?us-ascii?Q?4aQF0h1U5gHOjIktgRweZwPP3vNd2ypBaV0kAsucODyAGpfnPAOc36kq3kMH?=
 =?us-ascii?Q?QVE1xc6UcJrxLpAdpobq9k33m+mB5STcGoXWSJd+B6rNgtQV++0KR2rgVtNm?=
 =?us-ascii?Q?MXh+bWxn2akxCpQiAe2dLjdTZDuXJEKOaTzWCqWnaPFeFi3jVSn5B2nY9Hl/?=
 =?us-ascii?Q?OHP2oFXFqQTQyKbKSxod3tIncHVsuAwFhJRY7lmI4uKdKAFEpb4J1gOhqYNO?=
 =?us-ascii?Q?KBr6lOtfjLHW8XBbeskgiDZ04wj7Z/d0hEcWS5WJl6EFTrK5tAjNEd2qKO6G?=
 =?us-ascii?Q?kJDxGCyEtZhqDbMxgErV/BQhv1E5K+lh6JRafhPb7ZpYstvd65351yO06d6e?=
 =?us-ascii?Q?wFNahflxXXbFfHUQPRKTEMs69lEPXEhNs3KbwpyuPPLRQkbbEchOu7aqSvgt?=
 =?us-ascii?Q?guqnN2lzY5XTU57PY8PZ1nChcMqDbmvO9+EayGlrk1up9azcDRI4y9sz74jX?=
 =?us-ascii?Q?LOc1DE6ReBBBidbJerAPf29qDn2rHcesB2ZaKdGtYGDDGj7CbRcwK2/KSqYl?=
 =?us-ascii?Q?Q/EJQLWQU2gDOlpBBFFndILzJpEVaKA509HxdavbeCmm4KUWXwk/hHa1/Adw?=
 =?us-ascii?Q?mbADxFWDgO7vaQLtWK/XQiGDyHlZQ5XDG5+f6yTwWyPpgfdz6nueUOHI8R+z?=
 =?us-ascii?Q?5FFUwFkDLjgEspeGx8JdvHhTe/lEDM/W49D85npxZq7Bzh5bGUPTexLGMdLw?=
 =?us-ascii?Q?s1iQ/pI0XQlUBHdlVW+AHjDLo9N7K3Yw+s71gpOovg0vKWOFOfahgyOCxgg0?=
 =?us-ascii?Q?bUpS1COmQvI5zBZUWMx1q9MU0jG2Zvvz+/QJ8M7M?=
x-ms-exchange-antispam-messagedata-1: r9wNn/FgVmrhSSNS4KVcjasV49qGpbWdajF96VndQORxzj9bUu4KDC+zyfaWW8pd/ULKAC9BoEfHcVEXuVJsDt4ozuKApHgaMzK8TE6khmBI4h0aB3+zeBDp7NwnNFRI/vqpt0bW7NsOaD5fsSPOAcqH/Gm0gyhZLeZWaMp4UU7uS0A61dYIbBI+YPrHFk5Vx43kwcL2TVqic0K4pBx4GCQgdQyAAx9i9hG3dTCafpCr4oEACzhitm/fSatd7Mu0NclxajrRmWkEOhqxA9QDdEQIN2j9aMWb6e0kSEQZtI8vLfRVoU3NBKngJrwVVRxUA0G1gL6DkvCrkFY/orPr7viOKZmmqJDYdPGLBmaABCNB/IcT+QfQT0TP3LVhT2Jkh0F79AgPBbGuGdKcif2pwhz7
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: microsoft.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW2PR2101MB0892.namprd21.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ec44c5fb-2226-4053-c3ea-08d915c63ff1
X-MS-Exchange-CrossTenant-originalarrivaltime: 13 May 2021 04:19:06.7983
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 72f988bf-86f1-41af-91ab-2d7cd011db47
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: PPvxCE/Bopi29eOjd187sQz7xTfEQdUonU9iAuOe/alRJMFerll0I9j8VYbS2BHKj3LG03iOt8ehtajeibrUJg==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR21MB0751
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Dexuan Cui
> Sent: Wednesday, May 12, 2021 3:17 PM
> ...
> It looks like there is a race condition between iptables-restore calls
> getsockopt() to get the number of table entries and iptables call
> setsockopt() to replace the entries? Looks like some other program is
> concurrently calling getsockopt()/setsockopt() -- but it looks like this =
is
> not the case according to the messages I print via trace_printk() around
> do_replace() in do_ipt_set_ctl(): when the -EAGAIN error happens, there i=
s
> no other program calling do_replace(); the table entry number was changed
> to 5 by another program 'iptables' about 1.3 milliseconds ago, and then
> this program 'iptables-restore' calls setsockopt() and the kernel sees
> 'num_counters' being 5 and the 'private->number' being 6 (how can this
> happen??); the next setsockopt() call for the same 'security' table
> happens in about 1 minute with both the numbers being 6.

Well, after tracing the code more closely, it turns out that the program
'iptables' indeed concurrently changes the number from 5 to 6, and this
causes the 'iptable-restores' program to get EAGAIN:

1. iptables-906 (906 is the process ID) calls IPT_SO_GET_ENTRIES and the
current num_entries is 4; the process calls IPT_SO_SET_REPLACE and the
private->number becomes 5.

2. iptables-restor-895 calls IPT_SO_GET_ENTRIES, and gets num_entries=3D=3D=
5.

3. iptables-906 calls IPT_SO_GET_ENTRIES again, and also gets num_entries=
=3D=3D5;
the process calls IPT_SO_SET_REPLACE and the private->number becomes 6.

4. iptables-restor-895 calls IPT_SO_SET_REPLACE and the kernel function
xt_replace_table() returns -EAGAIN due to num_counters =3D=3D 5 and
private->number =3D=3D 6.

I think the latest mainline kernel should also have the same race.
It looks like this by-design race exists since day one?

> BTW, iptables does have a retry mechanism for getsockopt():
> 2f93205b375e ("Retry ruleset dump when kernel returns EAGAIN.")
> (https://git.netfilter.org/iptables/commit/libiptc?id=3D2f93205b375e&cont=
ext=3D10
> &ignorews=3D0&dt=3D0)
>=20
> But it looks like this is enough? e.g. here getsockopt() returns 0, but
> setsockopt() returns -EAGAIN.

It looks like we need to add a retry mechanism to the iptables-restore
program: iptables/iptables-restore.c: ip46tables_restore_main():

if cb->ops->commit(handle) -> ... -> setsockopt(...,IPT_SO_SET_REPLACE, ...=
)
fails due to EAGAIN, it should start over from the very begining, i.e. call
create_handle() -> handle =3D cb->ops->init(tablename) again to get the new
num_entries, and retry the commit op. But I'm not sure how to easily
re-create the context associated with the old handle (should/can it re-pars=
e
the rules?), as I'm not really familiar with iptables.

Or, is it possible to fix the race condition from the netfilter module?

Thanks,
-- Dexuan

