Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6D53F6459C7
	for <lists+netdev@lfdr.de>; Wed,  7 Dec 2022 13:24:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229741AbiLGMYO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Dec 2022 07:24:14 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45654 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229650AbiLGMYL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 7 Dec 2022 07:24:11 -0500
Received: from esa5.hc3370-68.iphmx.com (esa5.hc3370-68.iphmx.com [216.71.155.168])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DD8B04B76E;
        Wed,  7 Dec 2022 04:24:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple;
  d=citrix.com; s=securemail; t=1670415850;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-transfer-encoding:mime-version;
  bh=NuVeA9jBOsba946Ns2ab3ycurirFl8Qf6pAOL0nL5mY=;
  b=iJ2r6JYjDBbvBDOh/OhTJf0KE3Q0W1njRkkYsBLkLbojGLtvDhSH8Z7b
   MQ9/qSjpCUJZyJKsrhZHbbsrD4+s2btTIdcJ1SCgdQ40ZG2q01nPgsMqq
   pF1t5WiFx9gS9McGC4mpOInTk2xtRwBis+4gEqVREi74gWsGR3NIb/Ld1
   w=;
X-IronPort-RemoteIP: 104.47.56.174
X-IronPort-MID: 86044776
X-IronPort-Reputation: None
X-IronPort-Listener: OutboundMail
X-IronPort-SenderGroup: RELAY_O365
X-IronPort-MailFlowPolicy: $RELAYED
IronPort-Data: A9a23:4CsJ16D5KmP8ORVW/5Piw5YqxClBgxIJ4kV8jS/XYbTApDsr1TUHy
 zEeXjiFbvqCMGvxKo0ibN638E5XscLXyYJkQQY4rX1jcSlH+JHPbTi7wuUcHAvJd5GeExg3h
 yk6QoOdRCzhZiaE/n9BCpC48T8nk/nNHuCnYAL9EngZbRd+Tys8gg5Ulec8g4p56fC0GArIs
 t7pyyHlEAbNNwVcbyRFtcpvlDs15K6o4WlA4QRkDRx2lAS2e0c9Xcp3yZ6ZdxMUcqEMdsamS
 uDKyq2O/2+x13/B3fv8z94X2mVTKlLjFVDmZkh+AsBOsTAbzsAG6Y4pNeJ0VKtio27hc+ada
 jl6ncfYpQ8BZsUgkQmGOvVSO3kW0aZuoNcrLZUj2CA6IoKvn3bEmp1T4E8K0YIw49pMXDpLy
 OEjMDFdUCndvc+onaK6Rbw57igjBJGD0II3nFhFlGicJtF/BJfJTuPN+MNS2yo2ioZWB/HCa
 sEFaD1pKhPdfxlIPVRRA5U79AuqriCnL3sE9xTI++xuvDS7IA9ZidABNPLPfceRA8FckUuCu
 WvC+0zyAw0ANczZwj2Amp6prr+RxX+nB91MfFG+3vJrw1+45WUJMg0LbXq/o/LgmlaBS90Kf
 iT4/QJr98De7neDTNbnWAajiGWZpRNaUN1Ve8U+6QeQ2u/X7hyfC2wsUDFMcpoludUwSDhs0
 UWG9/vvCCBjvaO9V32Q7PGXoCm0NCxTKnUNDQcbQApD59j+iII+lBTCSpBkCqHdpsX8BDXY0
 z2M6i8kiN07gccV2qCT8VnZjjeooZbVCAg4+m3/U2646wpraZKNaIuv5lzWq/1HKe6xTUSLt
 VAHltKY4eRICouC/ASVSe8AGrCB/fuJMDTAx1VoGvEJ5zmrvnKuY41UyDV/P1tydNYJfyfzZ
 03esh8X44VcVEZGdodyaoO1Ts8tlK7pEI28UuiON4USJJ9saAWA4SdiI1aK2Hzgm1Qtlqd5P
 oqHdcGrDjARDqEPICeKetrxGIQDnkgWrV4/j7iip/h7+dJyvEKodIo=
IronPort-HdrOrdr: A9a23:imjZpaDibRpc7ELlHekX55DYdb4zR+YMi2TDGXoRdfUzSL3/qy
 nOpoV96faQslwssR4b9OxoVJPtfZqYz+8X3WH+VY3SIDUO+1HYUb2L1OPZskLd8lTFh5BgPM
 VbE5SWeeeAaWSS1vyKmTVQeuxIqLK6GeKT9IXjJhFWIj2CAJsQijuRZDz0LqRefng2ObMJUL
 Sd++tarH6adXwMaMPTPAh+Y8Hz4/PKibP7alo8CxQm8QmDii7A0s+ALzGomjkfThJSyvMY/W
 LEigz04bjmm/y30RPHzQbonuRrseqk5NtfJdCGzvIYLTjhkW+TFfxcZ4E=
X-IronPort-AV: E=Sophos;i="5.96,225,1665460800"; 
   d="scan'208";a="86044776"
Received: from mail-co1nam11lp2174.outbound.protection.outlook.com (HELO NAM11-CO1-obe.outbound.protection.outlook.com) ([104.47.56.174])
  by ob1.hc3370-68.iphmx.com with ESMTP/TLS/ECDHE-RSA-AES128-GCM-SHA256; 07 Dec 2022 07:24:08 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=IoFxOLizeRYZKxhK4euNCWLv6NCVc/t0LkndeFlbyfYjXGnvf1S74SKzjg3mCsYmj3fbeqYTXE2OEj8xRfxp+Zz446YdOtbpNdX0lshGihYe1XvBeBI8zKK9q0Kkn9Ykep5eG9yCajCFS1kovjhQubBa6dASnq5cyib7/eQPk+dIZh+D58Am0XraxRO6Qd23fRuRADGSsIN9WkmngKwOolLf1ETIH6+//FggUlqEaWxU2PDisyU9M2D3b0bOnKVeiMpHpDgk/0iK+XFYQ4HXyyuSeFfX8hA+xBNU7VaCEfEamBfJLByXU8oAmaDwJJwGUX5f32ZxvgsLtXaxv5qi9Q==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-AntiSpam-MessageData-ChunkCount:X-MS-Exchange-AntiSpam-MessageData-0:X-MS-Exchange-AntiSpam-MessageData-1;
 bh=NuVeA9jBOsba946Ns2ab3ycurirFl8Qf6pAOL0nL5mY=;
 b=hy0lAxHO/TCIBfXjZ0xYo0gV3HxvN+TYbrNIHPI3g/XDUYQVQbKqm/O4MdlPMvF9Uc06IlD/AQkPYlQGqhxzjwgL1LX6MtV4V8qHrRRWmIKsV2EbQtOKcTZVG1ZEIvEKGl3HSXbfQ0LH+/LEQWSskztnhMOXCxeCSlJBS39WMIvptJ/1RMVnompMcrM868mbVIOS7HIkmUx287mI9m7JHbBOq/nEUmSRVi6dLiOGJIT+83c+Cwx3CgcfGcZb7wmQCtI9UPJybmXcIPizfpd91dD4NwnyYKEJ+BiZZR+HwhvNlVj2rrbjM+uUqQpBsIA2fUBFFNMGUXH9hhu5XYAdvw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=citrix.com; dmarc=pass action=none header.from=citrix.com;
 dkim=pass header.d=citrix.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=citrix.onmicrosoft.com; s=selector2-citrix-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NuVeA9jBOsba946Ns2ab3ycurirFl8Qf6pAOL0nL5mY=;
 b=ki2rY1Edfj6J3mb/t2/2fXLJx/o0NPN3WGXYQGhijpbDvv56fnN//pvz0ccM3HwhoeqYm/5retjSYJ29ewZ72r86e+v4VLGzVsUGFGxu1259ndUh63GWLn+PHxdx55sPIlPOoKvp4AAip7rWScl/Nf5SBX+FZRVpOYN31rDDfjY=
Received: from DM6PR03MB5372.namprd03.prod.outlook.com (2603:10b6:5:24f::15)
 by SA2PR03MB5931.namprd03.prod.outlook.com (2603:10b6:806:119::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.5880.14; Wed, 7 Dec
 2022 12:24:07 +0000
Received: from DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::acc3:67c:60ef:bf99]) by DM6PR03MB5372.namprd03.prod.outlook.com
 ([fe80::acc3:67c:60ef:bf99%4]) with mapi id 15.20.5880.014; Wed, 7 Dec 2022
 12:24:07 +0000
From:   Ross Lagerwall <ross.lagerwall@citrix.com>
To:     Juergen Gross <jgross@suse.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     Wei Liu <wei.liu@kernel.org>, Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>
Subject: Re: [PATCH] xen/netback: fix build warning
Thread-Topic: [PATCH] xen/netback: fix build warning
Thread-Index: AQHZCgz9SnYWXgdp6UKlNSlfWigTB65iWQxA
Date:   Wed, 7 Dec 2022 12:24:06 +0000
Message-ID: <DM6PR03MB537213DE848B611A61BE38DEF01A9@DM6PR03MB5372.namprd03.prod.outlook.com>
References: <20221207072349.28608-1-jgross@suse.com>
In-Reply-To: <20221207072349.28608-1-jgross@suse.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
msip_labels: 
authentication-results: dkim=none (message not signed)
 header.d=none;dmarc=none action=none header.from=citrix.com;
x-ms-publictraffictype: Email
x-ms-traffictypediagnostic: DM6PR03MB5372:EE_|SA2PR03MB5931:EE_
x-ms-office365-filtering-correlation-id: 32c68fc1-a682-4132-1ea7-08dad84def8e
x-ms-exchange-senderadcheck: 1
x-ms-exchange-antispam-relay: 0
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: AUHaHywPiXB4CBP3ha370IVME3nqsxrUx3/aIEbMnhSFzBWKGEa50JvSVW1v5YhjbGfrYDXIgnrldnMywpyrTR7n97lw0EWDYXc6BNmdHv6t3S7roHcOhy1lsj5FfmivKBy74ekQZ4jalF911PAsZZfL/kfQY/lp3UFqV0U5g+Zy2M1XVMrjTtkdHhw+EG1BceroFjRW7+8pEztq2mdk+UX1mbqTgty415QWJNSyGIYgTa6l0ww7jGDi25PP9w4QcNZv+j0FbxHn5Dc3euz/DDmpgCwII8S6SRlKOUrh9lIXNYOjDxwWWjc6mC7cRG2HWzJrjbELQjHvDsKGeYFc4Y6zYRG2g6wO343I3Fz6ZWKYxtMMU8n5polU76HYvZmqSs5RVu66pmatkJnMaxlkxvBEy9ehAe81YxLRQPs/6jkCHtc20o6K5LVaIdUMdP48Oj78QHIOzx3ou0t2+AiRhplNjD93krBWY1Be0H2VbJrUUiUeTLrJsvyMkz15RtHtTcQwhK3wVgY40gfJkaeIhtqWnrNAK4bwypnqNO7QfvOm/Ef2iXcZFW915rAAgr+GJEWxuUs6cZkpVdIS7O8bxEc4lGcB1CnLyBMBXTBB0UHFnknE/VTaMWBHt9/fnRr3tCHmccSAUNBecoWwBKjNVoYDoGjB1FrFSqDi70JCizLWoSvugR2r4ljPYnnhWvm2cIaM4kZJ7iNV0GpM1G7Adw==
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:DM6PR03MB5372.namprd03.prod.outlook.com;PTR:;CAT:NONE;SFS:(13230022)(4636009)(346002)(366004)(376002)(39860400002)(396003)(136003)(451199015)(38100700002)(5660300002)(44832011)(86362001)(2906002)(122000001)(33656002)(41300700001)(4326008)(8936002)(7416002)(82960400001)(38070700005)(4744005)(66476007)(83380400001)(8676002)(66556008)(76116006)(66946007)(91956017)(316002)(54906003)(110136005)(71200400001)(478600001)(55016003)(9686003)(66446008)(64756008)(26005)(52536014)(53546011)(186003)(6506007)(7696005);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?iso-8859-1?Q?JOOHRyWuF6IJDgDmeb6powv4X915HOAgA/4lY0Wqe2rpzDYjP15XTh2xA6?=
 =?iso-8859-1?Q?mP7f+kWO4UqZtLMGdSwGDNiZukjNx+cYrRm68S1sBRWgaa/KgWuzewlpw9?=
 =?iso-8859-1?Q?NJsgTd1e4/DVJ9nOfTFysFI+ozqFV13zr15VOXD4h2YKMf5ZumZou8Jqz6?=
 =?iso-8859-1?Q?AXtKYYJeMp/LRS366ZJuRv9NEjttFt/2gnE1aZ63YJKqYqfhw5IH+8XC45?=
 =?iso-8859-1?Q?So9qoM1dxKaUkv3iZjUXtY4Rd6+kK210DxMdfg4DEEsKm644vL80JYcdj7?=
 =?iso-8859-1?Q?t+/+aUxzBq/wp1Yy4pQQzuHw/kEJwNyHO2nK7foAv2UltF4OSz/PhABC+H?=
 =?iso-8859-1?Q?W19+z7Z6lXA3CfNrI4KepjV5aCWUsmLhknhpQ7jqnR5mcc/UWySujXkroe?=
 =?iso-8859-1?Q?xEjb3/oCBaDQJs9/FexvR0Mz/tpn55AEQUCoU7wmEk697/6WdTUi6rPpxT?=
 =?iso-8859-1?Q?ZD1nDlWUhmHqVTC0vlsTFEEwPg5mpxJnNPc5VQVUGddIZGH0fNaytQp7Xz?=
 =?iso-8859-1?Q?rPamh3CGhXMrF7xt9lsmRxmohki43WlrOPnrRC9oOede5ei98hzbQwMOOy?=
 =?iso-8859-1?Q?GLnYLljYitfQyypJLNC8bmcUa1P9HK9xoTfjgrM62V1xkThDsRhvB718DX?=
 =?iso-8859-1?Q?745K7oxrFMevHP2bwAh+yB+tiTGmm2RQykKmcHz0SH36iT2d+gecvhT0Vp?=
 =?iso-8859-1?Q?sdiFoYcFjy1PKgGyMtM0isR9ltkBQ/uxLK5VSh207sSLjnTV4DBSCP4xCV?=
 =?iso-8859-1?Q?+1RPfydizLJVMe54+YHp5n6ww6HWgqFQ93ufoHnMMjgns3WQYCvURBZz2h?=
 =?iso-8859-1?Q?rokb1sUEwB6tuQ8R1R5mSjToUzXr9uQB/l3Jdi/xO51LVoghr7MhqLgAbK?=
 =?iso-8859-1?Q?V7UEKwkJbaRz35PTeLDqnrVUS8XPmjG++DykkWPXEgfSK4PydPCb0mQeuQ?=
 =?iso-8859-1?Q?oxBL4nZ+G2KZuC0xBxz4qKW8ch8NBB3DcTMW92u2w4eVo5U9QwYVYw5/Vf?=
 =?iso-8859-1?Q?Zl/dwhcLaawN+CbIJzodnJe8qyaLAnqFbdTg0xf8XqmlthmiyMTZIjn/fr?=
 =?iso-8859-1?Q?LGjfE74f50nVYVFoiXmULoIOY7UnF+iOk/C2wkxSlbLRJwSuslgBhCG/Y4?=
 =?iso-8859-1?Q?McwCyXE9rzmsDNsbsY8sx4R6133/NjzfDEVyGJyk2Z2EnwlyKx2oCfAOFP?=
 =?iso-8859-1?Q?bgkJi9OIeOl0xYuMLGvRuwxz8DDthjD6Pq0TGZRFn4LacvzLw/At11cada?=
 =?iso-8859-1?Q?fVWioztPUWP+tV5FyjMCSXB4K3jhYU1ZO9q0vBNtwNUyc+tjIn0IBwBdGR?=
 =?iso-8859-1?Q?Zsh0qoxVH9zK83theIMp1rcpeHyXR+xcKs3wp4rp7MQQ4OZfxhL7yxJ+gY?=
 =?iso-8859-1?Q?hYSYz8whXoIEtJdLbC+5JGF1TrhAaUKcWorAnhbFtk2Ixe7OPha+AO3Sa9?=
 =?iso-8859-1?Q?u0gTd/f43RKTX+TcmfWyzLQGqBRJvgQFuxNZXVIkPaStjX0WzS184daFUz?=
 =?iso-8859-1?Q?L+VtfvYos8pfCrOIIO2UzjDPENGt2p0DZzu0YANMEkqdYnEOkCf9bsDY9A?=
 =?iso-8859-1?Q?W/ieN9ChBj4g7Iacb7WnYNVsNTA6ZVmjnKu5/2PWLXRgLRYSBlP1AeeTp2?=
 =?iso-8859-1?Q?phdsv3yE+qsqrhx7MrFbaj+7xVwYkT47YN?=
Content-Type: text/plain; charset="iso-8859-1"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-ExternalHop-MessageData-0: =?iso-8859-1?Q?McmoRfAYXTgnCljxJKHH0ciGduq6PPTeXRVk3ra/SFqQPB1EMC7YXOxMAK?=
 =?iso-8859-1?Q?7VciPiVh9nOiu6bhG40Nj+2KujZXFouqPiRk2kDwy8GI1eawidOP3alYVw?=
 =?iso-8859-1?Q?4qeZpeWt8yA/aTYtS8T28kpGNAZPGEagu9rWLPs5o59qTsOIU3CCPZncaM?=
 =?iso-8859-1?Q?e2afh/AHCndlQvvmFfmY95xRsYRyw7b7f/ljFhLB/2492rjIhPAw80Mw6D?=
 =?iso-8859-1?Q?aOekenwsN0P/qbzn6W9+QzQdUo5llFXwsehor1AX7NKtCIP9tDF3+tgLX8?=
 =?iso-8859-1?Q?oZfzIbS48LLpkxuuAAe46wIk4kMQSGfx61IEbx/FNnpoKN/L8z+oYDXFJw?=
 =?iso-8859-1?Q?9WQMq8DC2EdpegP6KfXtcgDBZZLNorhxNJeRZ9sdfc2XtoVvkEvwvlT0rN?=
 =?iso-8859-1?Q?8z6pZrq1TLulAwRPZti3ASsD2RDo3liq0V2CNdNNkPCuwH3VU09cqjeY/m?=
 =?iso-8859-1?Q?WFlP6vfyuY/eg7NxyBtdfK81GZXCppq/eoO5EJ0KjE96HtVtarjKKqU+Fm?=
 =?iso-8859-1?Q?dYYlrY77ddpBB48nJlrQrdL901kDpJ7l4AYI+J5LZwc4Pbm5kOs/dUXLhL?=
 =?iso-8859-1?Q?ef0Mhp9w/rcGCwKWScX2SiUK4dd81sw7NqTUPqw7uRMRHsumswStD+4XfV?=
 =?iso-8859-1?Q?64nCxZ/zyDFG+qwRBu7/buqRzc2UfRe6Q2FOUW1W3CRGjTqDpSriLm+fYK?=
 =?iso-8859-1?Q?dUn0Tg1Ig8xsQNN7FwUKcYR15a/Q4aJ3VmSgP/YH1ZshIwp8rIJZriIziM?=
 =?iso-8859-1?Q?tP6yUOAU3/1wV4eanoNTYiNKIQGXbPWSYv1k1qAnFPDQQdTq0U8W0OXa0K?=
 =?iso-8859-1?Q?8WLMCfhO0owGZgtDqkoHUF/l5rCt1mBU54KW7V27TLV/ntfjpivYBQif+O?=
 =?iso-8859-1?Q?2QU/NmbfpkLs898GFbT8sn1IzdTRk9F/xqsebMWusnLycIXN58M+GLX7Ww?=
 =?iso-8859-1?Q?bIvAlVZKdJVF7nnVYZiXv2L8G+m0xkEd1HzlmpnDpaq8/fdrTxNvcFF2YP?=
 =?iso-8859-1?Q?FzqXPkQTEbvKHYJCw4eBgAKwm2FFHwy79CjuIkngwfZaVlMQb5+fOMnR4m?=
 =?iso-8859-1?Q?dbPDm8WS9edwOipkrcjOwH07mkjsw0hVjA3yHOghIsLX?=
X-OriginatorOrg: citrix.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: DM6PR03MB5372.namprd03.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 32c68fc1-a682-4132-1ea7-08dad84def8e
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Dec 2022 12:24:06.8871
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 335836de-42ef-43a2-b145-348c2ee9ca5b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: ITFv0njD3xXENB9a4DCEZw1nSFVC2H6x2VjKKqea5Es8B57H8wu7pmyyW4k8EcaaC8dOCYDKxjJgIfU2MDkTHLlIHNEzIiLk4IZD3X/HVKQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SA2PR03MB5931
X-Spam-Status: No, score=-4.2 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_MED,SPF_HELO_PASS,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> From: Xen-devel <xen-devel-bounces@lists.xenproject.org> on behalf of Jue=
rgen Gross <jgross@suse.com>=0A=
> Sent: Wednesday, December 7, 2022 7:23 AM=0A=
> To: linux-kernel@vger.kernel.org <linux-kernel@vger.kernel.org>; netdev@v=
ger.kernel.org <netdev@vger.kernel.org>=0A=
> Cc: Juergen Gross <jgross@suse.com>; Wei Liu <wei.liu@kernel.org>; Paul D=
urrant <paul@xen.org>; David S. Miller <davem@davemloft.net>; Eric Dumazet =
<edumazet@google.com>; Jakub Kicinski <kuba@kernel.org>; Paolo Abeni <paben=
i@redhat.com>; xen-devel@lists.xenproject.org <xen-devel@lists.xenproject.o=
rg>=0A=
> Subject: [PATCH] xen/netback: fix build warning =0A=
> =A0=0A=
> Commit ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in=
=0A=
> the non-linear area") introduced a (valid) build warning.=0A=
> =0A=
> Fix it.=0A=
> =0A=
> Fixes: ad7f402ae4f4 ("xen/netback: Ensure protocol headers don't fall in =
the non-linear area")=0A=
> Signed-off-by: Juergen Gross <jgross@suse.com>=0A=
=0A=
Reviewed-by: Ross Lagerwall <ross.lagerwall@citrix.com>=
