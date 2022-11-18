Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1314B62F75C
	for <lists+netdev@lfdr.de>; Fri, 18 Nov 2022 15:32:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241833AbiKROcE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Nov 2022 09:32:04 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241807AbiKROcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Nov 2022 09:32:02 -0500
Received: from mga18.intel.com (mga18.intel.com [134.134.136.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9304676162;
        Fri, 18 Nov 2022 06:32:01 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1668781921; x=1700317921;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=IMNKeUipD75HirdcMPJOJMjA0ezj5Cys6fRL7zYsd0Q=;
  b=LmQQ93oevywe7+RUzKjJy+m252kR0q83c3YV/Nu9cy86aQr3YoNAytHF
   Uk5zHjmLlTd2gZIj1jHJ01iHoY5aJCYa9GO2sTihNE+h4qxKwSyfegUZF
   QQfPGBnmc4jh/r9kYbZriagyoS+Y3NNgefH9Rt8OvS9KtG/6Txg7hf6lN
   Fo3xSALMuaelXVQbsn1CbO9QB+lmtfAhFfrP1oGGisQ68OU2iDy204UzD
   F5m4EE7OMGrdNQkFLfqionwrRuvEcWqRI1M/pYEGVnkpeCvTAQ6eMdiMq
   FVxD3oBNxmj86wrToAPwL2HGw74y/Ylx+rRgunR+CrHTdwGIdpWTcv9gc
   w==;
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="296507517"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="296507517"
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga106.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 18 Nov 2022 06:31:58 -0800
X-ExtLoop1: 1
X-IronPort-AV: E=McAfee;i="6500,9779,10535"; a="814932687"
X-IronPort-AV: E=Sophos;i="5.96,174,1665471600"; 
   d="scan'208";a="814932687"
Received: from fmsmsx601.amr.corp.intel.com ([10.18.126.81])
  by orsmga005.jf.intel.com with ESMTP; 18 Nov 2022 06:31:56 -0800
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31; Fri, 18 Nov 2022 06:31:55 -0800
Received: from fmsedg601.ED.cps.intel.com (10.1.192.135) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.2375.31 via Frontend Transport; Fri, 18 Nov 2022 06:31:55 -0800
Received: from NAM10-BN7-obe.outbound.protection.outlook.com (104.47.70.108)
 by edgegateway.intel.com (192.55.55.70) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.1.2375.31; Fri, 18 Nov 2022 06:31:55 -0800
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=lZtooKe6v8J97Uvf/vD8xaldVegrKH+DE2EUaVST9deiEAxS4jFzBf9DdTe0717187RsvIfcUTvQusFkM1JeGOiTgBFfTeF+cpzEuJkhleswZ8/m55DKvaotg1Bvd3cbdI0gxbhGgxELMu/af0X2VHpETImAevjUCJ5i4p+FroMYjNTOS6zsOjmvSQpG/34rNTPBBli/8s74pOhEPVMdVWjrQiT4+v9n4IQbP4hC4XKb7NkXI54mr8rXNH/YCoNEY0XgJKs44AwVbpTwVlNyDGT+NA0oh9Fag8viyDq3UPbZJH8HJ9xVmGuzjSQsu3+Ng6ABOWP1nLptfx/4FhrSHw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=SzpVfvU5GfExUh1gJjD0KK5tmmNkykAHnSK2JWe/UGA=;
 b=lggT0XtDWQHYjg/T3uQq+sACRDFzMfwMqNhUPCOeVjCdukGDBgcMTdFxwP0YikdVqhB0GoSFLR2sYxLm5kXwiqzpenxIDMhiFBXptb/2kiHYwnm0LOQfQ0PtDCHxxGH7hTdHex4pZdsAwwkIHY6lS4YqR5aTJ4nJW/GqOybkxzt0mK9rZHwaTGNy5HLKIfszrnQrKHdc2VwB9jw3ua5kHZpBE/A6StQ1ggFC0R2B8f2iIpwYKEIV4VP/SEXcAaF+R9qS02SBHysFH3//JFsFqnlR1MtNhCxVJomz3FTic5fGX5/7mXxtG+bsaD9bi+Yz1h9vT8J3nwFIZoUX4hlCVA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
Received: from DM8PR11MB5621.namprd11.prod.outlook.com (2603:10b6:8:38::14) by
 SA2PR11MB4971.namprd11.prod.outlook.com (2603:10b6:806:118::18) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5834.9; Fri, 18 Nov
 2022 14:31:52 +0000
Received: from DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a]) by DM8PR11MB5621.namprd11.prod.outlook.com
 ([fe80::9f29:9c7a:f6fb:912a%7]) with mapi id 15.20.5813.018; Fri, 18 Nov 2022
 14:31:52 +0000
From:   "Jankowski, Konrad0" <konrad0.jankowski@intel.com>
To:     ivecera <ivecera@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     SlawomirX Laba <slawomirx.laba@intel.com>,
        Eric Dumazet <edumazet@google.com>,
        "moderated list:INTEL ETHERNET DRIVERS" 
        <intel-wired-lan@lists.osuosl.org>,
        open list <linux-kernel@vger.kernel.org>,
        "Piotrowski, Patryk" <patryk.piotrowski@intel.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        "sassmann@redhat.com" <sassmann@redhat.com>
Subject: RE: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues
 after reset task failure
Thread-Topic: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues
 after reset task failure
Thread-Index: AQHY81xxx2lHPg1F40icZaVs18UPPa5EziYw
Date:   Fri, 18 Nov 2022 14:31:52 +0000
Message-ID: <DM8PR11MB5621A3E2D98C584E6C4EC1E9AB099@DM8PR11MB5621.namprd11.prod.outlook.com>
References: <20221108102502.2147389-1-ivecera@redhat.com>
In-Reply-To: <20221108102502.2147389-1-ivecera@redhat.com>
Accept-Language: pl-PL, en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=intel.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM8PR11MB5621:EE_|SA2PR11MB4971:EE_
x-ms-office365-filtering-correlation-id: 17788b6d-0bc8-46b6-71cd-08dac971a287
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: GyCipI+uyP4ngN6qKLrG1qU52/d+SM8UxQsfTrCjAgawmIByCKfKFAqgiiDIYKg2nJk5BPrE6J2HjUMSyFabke7sX4UcFjJXhVZgkjJ3SjtqiDNXXR59XZVikvz05YTnsHhEiRW7VawyGB1GiwFUDpUExi3KQlKq+TV58ID79T5AswyrAmZZOAJe/4uWMqBomW1X8wXysBJjt0Ter8hqEeEIYQarNbOgViX5oSwhIZcFAntn3J9tlYKwKasCI8I0n3Qee7rmJSi1+fXnULuF8iFX1V+J+u7yl1ZOdWxi+Oa4xcIKqYm9eufeK4RC8Ruyy+LnHA4lpw1w1tgXIoMHrwYCmTJAYNJEGsGdGT/UeeMAoNyLm375Ws8WepemlBMgtLoNjt2b/hknZnxsqRHlH96FNzBBcGEGtTcA6x1+Rsmh75Xbax6ATMWCr72wnGlcIlxjxflSw1Itm8FxNahV6ZBFxJivNpwV9mcIHmfnM5uQyEh3QUFVihkBKgYu70oYVTmowXKarV88aKiflXJVj7G9x8f3RPLiStSWRY2bf8c9YxJLg25NG8V9v5wI2EzqdcODazzm76MJSufczJOa+BSI+cOZAdn60/0NdF1EbGKp/jjx23LxgFJnVwqYLIM7jP4ruOQAR+10L16p9shsTXKH/aYfDO16Kpon8Ty5hmGh9QZYfgm0vN5MtfysLeMHeucWv+X6eUoQWS5PRIq9XQ==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM8PR11MB5621.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(39860400002)(396003)(136003)(366004)(346002)(376002)(451199015)(316002)(186003)(38070700005)(54906003)(110136005)(122000001)(82960400001)(5660300002)(33656002)(52536014)(8936002)(55016003)(2906002)(83380400001)(8676002)(4326008)(66476007)(64756008)(76116006)(66446008)(66946007)(66556008)(38100700002)(41300700001)(478600001)(53546011)(26005)(9686003)(7696005)(6506007)(71200400001)(86362001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?us-ascii?Q?18OU0912scrQlPsi+ImLqTt+9q/unUv8t+WrSF0POjuryKpTxHzMr9CQ5uG7?=
 =?us-ascii?Q?El57dHSGeaNGxSUCut9DsXACpc8zbIspM/bpJ7LI9DqSfimXYcu/uyTEOCk4?=
 =?us-ascii?Q?69PV3i4U6hnDkuIbUZdN5H0bJOCJdmQTF4pYOe4DfmqBUYwqJOZmp6y2QFlA?=
 =?us-ascii?Q?DS6749q36euSM2eb+vALzc0xzEXpbEPusDFJezg+vBfe5JgbR2AxrYLysubj?=
 =?us-ascii?Q?FK6SAyLtJhItiYJFMwe+8v0orlvye5V6WkDycmIIE5hdcIhpPXFxpyzzIzxT?=
 =?us-ascii?Q?nmLfVH7AEVNvicFC6NWMIUaTkERStNLUpbul0dZpbL8+8wFOQRT3FwV9D5T8?=
 =?us-ascii?Q?fL9wmak0SxB/gsYByq+WYQXdFN0vkzBcxpDIf+6O2boAaknGYbXYShHxmaig?=
 =?us-ascii?Q?iS9Whla7LoH1Bk8tEerzgh0g+3FwK/RzpXBD8GD/XSTlpGGfSGc4sCjOUGLk?=
 =?us-ascii?Q?C/2rpEYS8VXHdzmCPmj7GDz82TFcC/gm5wuzteWT0/Jz90jWK584y8TsLzpD?=
 =?us-ascii?Q?krpnL0HMxU9FZlZ99W5kaZSmt+agkY91/MhBqudKuaBGNmw/UTE3h630RxMr?=
 =?us-ascii?Q?13Qe/lmhvOfbYMxPL0l3iUS5TpD0OJC5uj+qsljOwO3YGAHr32mSm9jF92B6?=
 =?us-ascii?Q?KaB3ryTtGJUk/Vulk3csI0EIqEf8FOu9yjzVIfbw+8FaTpXj5r9YaBpG2C1w?=
 =?us-ascii?Q?oM67gWzWwoDN2cwSmbq5pkGsJxd+KIykC21p/xoTN89qjjDih7gQp2MaUlRW?=
 =?us-ascii?Q?PXXQPTOzyXNPQXl/wXw1+wn9DMoM8DojaB1q7G6233FtjNTZyRs7btpsbvxd?=
 =?us-ascii?Q?5M4T2jZUsyjDOYJvnUk1iRCUkPpFZbWBtGNDBszJWVpUj0eP4I9QxXHEJD6w?=
 =?us-ascii?Q?jW8x2YllCSlIyqEbh9DAzE7dW4jXBOWOrhl/wNrJMTZadqDxAmn4Uxde94Su?=
 =?us-ascii?Q?n+28umgwsnvIbkib3q2s1QHf55cJOEOeq63n6xsPfh+Jqk9iWATzKOwErfES?=
 =?us-ascii?Q?Acs27qYpDDvLX2Iw8JKU5ngxALtWza6EH1YtIicVt/j4gnsV8uL/0xL4S8d4?=
 =?us-ascii?Q?9Tmz3twds3hEIuBDiUMZlgmAoqM1oIH9Hi1QZzYNLupKvY1OMYu6iFEAdCh4?=
 =?us-ascii?Q?+OaTQCb7XrijJxxG6dmIRUBZV+xorPDn1WEXiYKQZ1CeX9CkayPWpOa8XWHK?=
 =?us-ascii?Q?WduxP/nFF8vA6ltisVQ4P3devBezuRselj6wEkQxgWMdHYVprv7fNSgvt/OW?=
 =?us-ascii?Q?1ekZZYO8R8uPHR3bH6C3OVsRO1nKTjNN5wljlEpl0BO/O9Mqcci9kbv+Zr4r?=
 =?us-ascii?Q?l7lAYrpYwBcH++dd1UY3pN2frsvZRgHcP0OJMLjnsmvcOAmeJPOL0j9Sp22+?=
 =?us-ascii?Q?+Z5cMOW+Oes2rE9EMHvz8IrWN09gJJz7Lx3+IvKR3mNBc2yM2nQXi1Si7MVS?=
 =?us-ascii?Q?NayDu7Egw0abznzneEYfzOQK1CR6324Fvlg1ct/zftzL3ZgcUsWxlVD3Tygv?=
 =?us-ascii?Q?50iSVnkITY1SN9ikWIKZ1ljX2yh6ayKVF1jQeJelvicEva5VUvFkzjpkDoYh?=
 =?us-ascii?Q?3RVO2un3C3QmQ37w7vtAYDiMkb94DJVlvgp76/L6yDCHi/JTxATjT1QrhhAo?=
 =?us-ascii?Q?bw=3D=3D?=
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM8PR11MB5621.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 17788b6d-0bc8-46b6-71cd-08dac971a287
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 Nov 2022 14:31:52.1150
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: or0ESeHYpv7yPJGHsLwCCvbTr5tHMfNKz5pDal4Uql88ruSZonmx8jFyCTA1bosv71nFlcqJj3jorxqxBufamhEpEAp+gl/w8Y1LqAMgiuQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR11MB4971
X-OriginatorOrg: intel.com
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,SPF_HELO_NONE,
        SPF_NONE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



> -----Original Message-----
> From: Intel-wired-lan <intel-wired-lan-bounces@osuosl.org> On Behalf Of I=
van
> Vecera
> Sent: Tuesday, November 8, 2022 11:25 AM
> To: netdev@vger.kernel.org
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>; Eric Dumazet
> <edumazet@google.com>; moderated list:INTEL ETHERNET DRIVERS <intel-
> wired-lan@lists.osuosl.org>; open list <linux-kernel@vger.kernel.org>;
> Piotrowski, Patryk <patryk.piotrowski@intel.com>; Jakub Kicinski
> <kuba@kernel.org>; Paolo Abeni <pabeni@redhat.com>; David S. Miller
> <davem@davemloft.net>; sassmann@redhat.com
> Subject: [Intel-wired-lan] [PATCH net] iavf: Do not restart Tx queues aft=
er reset
> task failure
>=20
> After commit aa626da947e9 ("iavf: Detach device during reset task") the d=
evice
> is detached during reset task and re-attached at its end.
> The problem occurs when reset task fails because Tx queues are restarted =
during
> device re-attach and this leads later to a crash.
>=20
> To resolve this issue properly close the net device in cause of failure i=
n reset task
> to avoid restarting of tx queues at the end.
> Also replace the hacky manipulation with IFF_UP flag by device close that=
 clears
> properly both IFF_UP and __LINK_STATE_START flags.
> In these case iavf_close() does not do anything because the adapter state=
 is
> already __IAVF_DOWN.
>=20
> Reproducer:
> 1) Run some Tx traffic (e.g. iperf3) over iavf interface
> 2) Set VF trusted / untrusted in loop
>=20
> [root@host ~]# cat repro.sh
> #!/bin/sh
>=20
> PF=3Denp65s0f0
> IF=3D${PF}v0
>=20
> ip link set up $IF
> ip addr add 192.168.0.2/24 dev $IF
> sleep 1
>=20
> iperf3 -c 192.168.0.1 -t 600 --logfile /dev/null & sleep 2
>=20
> while :; do
>         ip link set $PF vf 0 trust on
>         ip link set $PF vf 0 trust off
> done
> [root@host ~]# ./repro.sh
>=20
> Result:
> [ 2006.650969] iavf 0000:41:01.0: Failed to init adminq: -53 [ 2006.67566=
2] ice
> 0000:41:00.0: VF 0 is now trusted [ 2006.689997] iavf 0000:41:01.0: Reset=
 task
> did not complete, VF disabled [ 2006.696611] iavf 0000:41:01.0: failed to=
 allocate
> resources during reinit [ 2006.703209] ice 0000:41:00.0: VF 0 is now untr=
usted [
> 2006.737011] ice 0000:41:00.0: VF 0 is now trusted [ 2006.764536] ice
> 0000:41:00.0: VF 0 is now untrusted [ 2006.768919] BUG: kernel NULL point=
er
> dereference, address: 0000000000000b4a [ 2006.776358] #PF: supervisor rea=
d
> access in kernel mode [ 2006.781488] #PF: error_code(0x0000) - not-presen=
t
> page [ 2006.786620] PGD 0 P4D 0 [ 2006.789152] Oops: 0000 [#1] PREEMPT SM=
P
> NOPTI [ 2006.792903] ice 0000:41:00.0: VF 0 is now trusted [ 2006.793501]=
 CPU:
> 4 PID: 0 Comm: swapper/4 Kdump: loaded Not tainted 6.1.0-rc3+ #2 [
> 2006.805668] Hardware name: Abacus electric, s.r.o. - servis@abacus.cz Su=
per
> Server/H12SSW-iN, BIOS 2.4 04/13/2022 [ 2006.815915] RIP:
> 0010:iavf_xmit_frame_ring+0x96/0xf70 [iavf] [ 2006.821028] ice 0000:41:00=
.0:
> VF 0 is now untrusted [ 2006.821572] Code: 48 83 c1 04 48 c1 e1 04 48 01 =
f9 48
> 83 c0 10 6b 50 f8 55 c1 ea 14 45 8d 64 14 01 48 39 c8 75 eb 41 83 fc 07 0=
f 8f e9 08
> 00 00 <0f> b7 45 4a 0f b7 55 48 41 8d 74 24 05 31 c9 66 39 d0 0f 86 da 00=
 [
> 2006.845181] RSP: 0018:ffffb253004bc9e8 EFLAGS: 00010293 [ 2006.850397]
> RAX: ffff9d154de45b00 RBX: ffff9d15497d52e8 RCX: ffff9d154de45b00 [
> 2006.856327] ice 0000:41:00.0: VF 0 is now trusted [ 2006.857523] RDX:
> 0000000000000000 RSI: 00000000000005a8 RDI: ffff9d154de45ac0 [
> 2006.857525] RBP: 0000000000000b00 R08: ffff9d159cb010ac R09:
> 0000000000000001 [ 2006.857526] R10: ffff9d154de45940 R11:
> 0000000000000000 R12: 0000000000000002 [ 2006.883600] R13:
> ffff9d1770838dc0 R14: 0000000000000000 R15: ffffffffc07b8380 [ 2006.88584=
0]
> ice 0000:41:00.0: VF 0 is now untrusted [ 2006.890725] FS:
> 0000000000000000(0000) GS:ffff9d248e900000(0000) knlGS:0000000000000000
> [ 2006.890727] CS:  0010 DS: 0000 ES: 0000 CR0: 0000000080050033 [
> 2006.909419] CR2: 0000000000000b4a CR3: 0000000c39c10002 CR4:
> 0000000000770ee0 [ 2006.916543] PKRU: 55555554 [ 2006.918254] ice
> 0000:41:00.0: VF 0 is now trusted [ 2006.919248] Call Trace:
> [ 2006.919250]  <IRQ>
> [ 2006.919252]  dev_hard_start_xmit+0x9e/0x1f0 [ 2006.932587]
> sch_direct_xmit+0xa0/0x370 [ 2006.936424]  __dev_queue_xmit+0x7af/0xd00 [
> 2006.940429]  ip_finish_output2+0x26c/0x540 [ 2006.944519]
> ip_output+0x71/0x110 [ 2006.947831]  ? __ip_finish_output+0x2b0/0x2b0 [
> 2006.952180]  __ip_queue_xmit+0x16d/0x400 [ 2006.952721] ice 0000:41:00.0=
:
> VF 0 is now untrusted [ 2006.956098]  __tcp_transmit_skb+0xa96/0xbf0 [
> 2006.965148]  __tcp_retransmit_skb+0x174/0x860 [ 2006.969499]  ?
> cubictcp_cwnd_event+0x40/0x40 [ 2006.973769]
> tcp_retransmit_skb+0x14/0xb0 ...
>=20
> Fixes: aa626da947e9 ("iavf: Detach device during reset task")
> Cc: Jacob Keller <jacob.e.keller@intel.com>
> Cc: Patryk Piotrowski <patryk.piotrowski@intel.com>
> Cc: SlawomirX Laba <slawomirx.laba@intel.com>
> Signed-off-by: Ivan Vecera <ivecera@redhat.com>
> ---
>  drivers/net/ethernet/intel/iavf/iavf_main.c | 16 +++++++++++++++-
>  1 file changed, 15 insertions(+), 1 deletion(-)
>=20
> diff --git a/drivers/net/ethernet/intel/iavf/iavf_main.c
> b/drivers/net/ethernet/intel/iavf/iavf_main.c
> index 5abcd66e7c7a..b66f8fa1d83b 100644
> --- a/drivers/net/ethernet/intel/iavf/iavf_main.c
> +++ b/drivers/net/ethernet/intel/iavf/iavf_main.c
> @@ -2921,7 +2921,6 @@ static void iavf_disable_vf(struct iavf_adapter

Tested-by: Konrad Jankowski <konrad0.jankowski@intel.com>
