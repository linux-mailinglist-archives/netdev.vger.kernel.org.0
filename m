Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 08E143B2B7D
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 11:35:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231925AbhFXJhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 05:37:47 -0400
Received: from alln-iport-4.cisco.com ([173.37.142.91]:4314 "EHLO
        alln-iport-4.cisco.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230299AbhFXJhq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 05:37:46 -0400
X-Greylist: delayed 441 seconds by postgrey-1.27 at vger.kernel.org; Thu, 24 Jun 2021 05:37:46 EDT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=cisco.com; i=@cisco.com; l=1508; q=dns/txt; s=iport;
  t=1624527328; x=1625736928;
  h=from:to:cc:subject:date:message-id:references:
   in-reply-to:content-id:content-transfer-encoding:
   mime-version;
  bh=jfrI3bqvqqU0mk9P9bIHoON5cP210IMceX3zKeRe3Xw=;
  b=TW0h3+ROMfcZP4MFbOJZ63L6Skp9wjphY72NIPhuwq7aw5MMW+zOgZ+E
   GRRQohMgkaogjt+nJVXABVD8n2/3W549MBXQR5pJrufKhL5R8BL83yfuu
   gHQh/Bt1q4qNOCRwcKF3VTEZFOHA7+QY7FmZelvYhz0qhv8PAAPzG2Zan
   0=;
X-IPAS-Result: =?us-ascii?q?A0BaBADVT9Rgl49dJa1aHgEBCxIMQIMqUYFYNzGESINIA?=
 =?us-ascii?q?4U5iEowmh2CUwNUCwEBAQ0BAT8CBAEBhFICF4JXAiU4EwIEAQEBAQMCAwEBA?=
 =?us-ascii?q?QEFAQEFAQEBAgEGBBQBAQEBAQEBAWiFaA2GRgEBBBIREQwBATcBDwIBCA4KA?=
 =?us-ascii?q?gImAgICMBUQAgQNAQUCAQEegk+CVgMvAZppAYE8AoofeoEygQGCBwEBBgQEh?=
 =?us-ascii?q?RcYgjEJgRAqgnuEDoZhJxyBSUSBFSeCTS8+hEQXgwCCZIQVB1aBK4EFlDdDp?=
 =?us-ascii?q?0AKgx+dcgYOBSaDX6IYl3iiNQICAgIEBQIOAQEGgWsigVtwFYMkUBcCDo4fG?=
 =?us-ascii?q?YNXil5zOAIGCgEBAwl8iSEtghgBAQ?=
IronPort-PHdr: A9a23:prlHDx9UmhjQc/9uWD/oyV9kXcBvk67oJAoY7NwrhuEGfqei+sHkO
 0rSrbVogUTSVIrWo/RDl6LNsq/mVGBBhPTJsH0LfJFWERNQj8IQkl87HNSBBEu9IPO5JyA/F
 d5JAVli+XzzOENJGcH4MlvVpHD67TMbFhjlcwRvIeGgEY/JhMPx3Oe3qPXu
IronPort-HdrOrdr: A9a23:QKYPS6m/e1NYQPFZd0QFTfK5prLpDfOGimdD5ihNYBxZY6Wkfp
 +V/cjzhCWbtN9OYh4dcIi7Sda9qXO1z+8T3WGIVY3SHzUOy1HYUr2KirGSgQEIeheOttK1sJ
 0BT0EQMqyKMbEXt7ee3OD8Kadd/DDlytHsuQ699QYWcegCUcgJhG0VZnf5Yy9LrUt9dOcE/f
 Gnl6x6Tk+bCAwqh7OAdwA4tob41rn2vaOjRSRDKw8s6QGIgz/twqX9CQKk0hAXVC4K6as+8E
 De+jaJopmLgrWe8FvxxmXT55NZlJ/K0d1YHvGBjcATN3HFlhuoXoJ8QLeP1QpF591HqWxa1u
 UkkS1QZ/ib2EmhJV1dZiGdgTUI5QxeskMKD2Xo3EcL7/aJGA7SQPAx9L6xOiGpm3bI+usMj5
 6iGwmixstq5dSqplWi2zGAbWAZqqL/y0BS4tI7njhRV5ATZ6RWqpFa9ERJEI0YFCa/84w/Fv
 JyZfusqMq+XGnqJUwxhFMfjeBEn05DVyuuUwwHoIiYwjJWlHd2ww8Rw9EehG4J8NY4R4Nf7+
 rJP6x0nPUWJ/VmI55VFaMEW4+6G2bNSRXDPCabJknmDrgOPzbIp4Ts6Ls46em2cNgDzYc0mp
 7GTFRE3FRCNH4Gyff+l6Gj1yq9AVlVcQ6dvf221qIJ8oEUHoCbRRFrYGpe5fdIjc9vd/HmZw
 ==
X-IronPort-Anti-Spam-Filtered: true
X-IronPort-AV: E=Sophos;i="5.83,296,1616457600"; 
   d="scan'208";a="705782168"
Received: from rcdn-core-7.cisco.com ([173.37.93.143])
  by alln-iport-4.cisco.com with ESMTP/TLS/DHE-RSA-SEED-SHA; 24 Jun 2021 09:27:42 +0000
Received: from mail.cisco.com (xbe-rcd-001.cisco.com [173.37.102.16])
        by rcdn-core-7.cisco.com (8.15.2/8.15.2) with ESMTPS id 15O9Rf2k009515
        (version=TLSv1.2 cipher=AES256-SHA bits=256 verify=FAIL);
        Thu, 24 Jun 2021 09:27:42 GMT
Received: from xfe-rcd-002.cisco.com (173.37.227.250) by xbe-rcd-001.cisco.com
 (173.37.102.16) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.2.792.15; Thu, 24 Jun
 2021 04:27:41 -0500
Received: from xhs-rtp-002.cisco.com (64.101.210.229) by xfe-rcd-002.cisco.com
 (173.37.227.250) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_CBC_SHA384) id 15.2.792.15; Thu, 24 Jun
 2021 04:27:40 -0500
Received: from NAM02-BN1-obe.outbound.protection.outlook.com (64.101.32.56) by
 xhs-rtp-002.cisco.com (64.101.210.229) with Microsoft SMTP Server (TLS) id
 15.0.1497.18 via Frontend Transport; Thu, 24 Jun 2021 05:27:40 -0400
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=FfpbOnOKIZPqxLvYjHEsYb80LZxaIPKUB3hx/qBgtQeqE7w4bkBDqZ30SzoEHHn/wREilkZRr1Ferv3T2YIun05FC7FLkQYgTuoIJccbyjUHi9TbNGO3BxMJy5XVDCn8RTPee9Ksn2yiaUeDNDGAwhGZWy/7JO5OOduWra48Ees5AChyfOX0CmJiOZJkDw2kALmT1iXDJdZqI/ZmFbrK3D38j8MGUteWlOckQS5szfPqFVBkhPR8HmEwhfPLt8kGEiEXXTvsXnsg63gUVaVC+5HDWorij2e/gwlmqh1GneAKBiIU19rG6nVVOswLQiFZ6jutRbinlP3FE3OTokQbCw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfrI3bqvqqU0mk9P9bIHoON5cP210IMceX3zKeRe3Xw=;
 b=lWXYEtqY68UhRNR+/7xvIPU0Nkzvj95jWicqlM7SZfF1pgixBb+9oqTpeA/1NNqDnhft6GWw616AH2E/Jgp9BeYNS8p7A37NEEtDQmsVvYx05Z9y64BEp0iqAwujS5Fnd2SqSJocni/z70gWjIbgTSmlE7ukvmPWSLa/wxq3X5fd29lr+LeYIXGqfcIc2evmQzBB2zx76itN6cr1wc8saBAKJcjTcY54MhFBLHnYtAmNjQyC8TjzUdpkKOlE/loCBpMhJT67vmxkuqUMg2fU0flbHwdQBC+Blrf+DbZZdRPybV2SVmWphuJkk8CR0vL2FCbGHk3xl96w65HJ2TZU9Q==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=cisco.com; dmarc=pass action=none header.from=cisco.com;
 dkim=pass header.d=cisco.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=cisco.onmicrosoft.com;
 s=selector2-cisco-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=jfrI3bqvqqU0mk9P9bIHoON5cP210IMceX3zKeRe3Xw=;
 b=bqzUTpnimME7ZAXJV46QLoEDJMqoP+HKGb87Or5a3aWKaxUR4k1XYg6cA01yKR8BbczwCnHo0lqG0D8j8n/iDjEHjyCnTGiauv0ujReFtp7rHVKLciytpd4wOxl/amj/As1Oh3NFA24Pah6wiTfhIaphHD6lDoz1v49AwR6ZGzA=
Received: from MN2PR11MB4429.namprd11.prod.outlook.com (2603:10b6:208:18b::12)
 by BL0PR11MB3362.namprd11.prod.outlook.com (2603:10b6:208:61::29) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4264.19; Thu, 24 Jun
 2021 09:27:39 +0000
Received: from MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::c877:5af5:4ccb:bf28]) by MN2PR11MB4429.namprd11.prod.outlook.com
 ([fe80::c877:5af5:4ccb:bf28%7]) with mapi id 15.20.4242.025; Thu, 24 Jun 2021
 09:27:39 +0000
From:   "Georg Kohmann (geokohma)" <geokohma@cisco.com>
To:     Florian Westphal <fw@strlen.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "coreteam@netfilter.org" <coreteam@netfilter.org>,
        "netfilter-devel@vger.kernel.org" <netfilter-devel@vger.kernel.org>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kadlec@netfilter.org" <kadlec@netfilter.org>,
        "pablo@netfilter.org" <pablo@netfilter.org>
Subject: Re: [PATCH net] ipv6/netfilter: Drop Packet Too Big with invalid
 payload
Thread-Topic: [PATCH net] ipv6/netfilter: Drop Packet Too Big with invalid
 payload
Thread-Index: AQHXaNecmV/MwdNwy0ygrqNr4FFGi6si3pWAgAAGFAA=
Date:   Thu, 24 Jun 2021 09:27:38 +0000
Message-ID: <a8723a1c-ca6c-ffbe-9a8a-395bef9da8e2@cisco.com>
References: <20210624090135.22406-1-geokohma@cisco.com>
 <20210624090553.GB24271@breakpoint.cc>
In-Reply-To: <20210624090553.GB24271@breakpoint.cc>
Accept-Language: nb-NO, en-US
Content-Language: nb-NO
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
authentication-results: strlen.de; dkim=none (message not signed)
 header.d=none;strlen.de; dmarc=none action=none header.from=cisco.com;
x-originating-ip: [2001:420:c0c0:1003::4a8]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 35403879-5d40-4bd4-c59e-08d936f24f5e
x-ms-traffictypediagnostic: BL0PR11MB3362:
x-microsoft-antispam-prvs: <BL0PR11MB3362F326789FD87F70BE01A6CD079@BL0PR11MB3362.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:8882;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 64gIQbQwEVJ6aKU3do8rVAGOnlVliCBZSzddBwtFiiPZGRsJPnHKskhrI9cqGYGvOwMUVdrrX5ArEM27i+z/r24cqntkiSdoMhkmYaZa4/nvr+Qy6rjHKa9RC/l+p1ni3YbUtxXcMwsyP7eV0afgfUwQJsQqNJZ8nsbLNSTPwf3NI2TgBSCSbYURVUQ3k8kGg2x6KBIgxZ7TDRP+Hq9+xhhOL3+B9fRIzoneqbZyHpURQvjXkUr0LctdG45DN59MbLM84HCwsajVq5m2BJVwIci4DULlpBUcfxwEhbutvyXzvUt4CdtV7B/V4Z3l86aMn5e5cqIZR9BGRnZPNaEfxajB5cltAsdea8VIRgUMMK2+s/zntvkcEF+nhXDeEHNOONDRSRrXYKf3P0qIHNyNkk6mPIuQ8KrDuTr6YpAw3QmM1d5kQLAdfMhuV08C1hPSlEhO/4u+Cd3l2wB9/hRsbOVPziVxQWtSCYt0RnzXArOWUkWmTZZVeU93briUUh8wcoRXjby3/LoicYwrCqJ1WvLVlHYVyCLvRmfGise/b/pMezCR/XOL0kRSxVtJz07Dya8nz4w67X5QVU7QFWOyKubWrx5hm2Puo3JOZBDBZTLqNY/huan49/grmvewfXEhsD2jmm+CP/zrHciyUOo68Spx/3gKFbSsywi2bhTjoQ22vSL3Nb3s3T72Ag2CHV95
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MN2PR11MB4429.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(376002)(366004)(346002)(136003)(39860400002)(71200400001)(4326008)(6506007)(53546011)(8936002)(31696002)(38100700002)(478600001)(86362001)(2616005)(76116006)(122000001)(66476007)(8676002)(6486002)(66446008)(66946007)(36756003)(66556008)(186003)(6512007)(64756008)(6916009)(91956017)(54906003)(2906002)(316002)(5660300002)(83380400001)(31686004)(43740500002)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata-chunkcount: 1
x-ms-exchange-antispam-messagedata-0: =?utf-8?B?NzdNdjEvNkVpZnBmZDRUUWg1VURZM001MjluZWw0U2YxczBIMVlVM1pDRGxL?=
 =?utf-8?B?MjN0dE5WQ3ZUeEEyVjNvQit5TDN3SnJIN29QNTdrY1lJL1FKOUZSclQvWm1v?=
 =?utf-8?B?Z1NMU1U2a2prRmdqdGZBMlNJQmVBRUxPYzNyR2dCZXVPUEJvUCt1eEJMNXpn?=
 =?utf-8?B?WWd4dUtMcjdIbGVUSEJhM2VBT3BTNEFBS0txS2xTRW1LbFhoSlY3SDFreDhS?=
 =?utf-8?B?WGtTVkI3UURsVDhHdjNpKzllZzhlMlRybFBmZHRaMWV6d1B6VWJNNDAxcW5h?=
 =?utf-8?B?Y3dTcGhqQ1hoMU80bmJucEZkSnYvSzhEN1pleDFUVW1RMFJDUjdmSDB4ek1T?=
 =?utf-8?B?YnExY05ONk90MWZsZ3RlZllicWVLYmR3ZXNZN0FvRlpHaXEyWlpGYUI3N1V0?=
 =?utf-8?B?UUFFVVZzSXIzZHRiRmV3RXk0SFZ0RWs4SFB1dHJTVEFUWTdONm81OFNhM0Rq?=
 =?utf-8?B?Z3p6SHZ6WHJTZHBSMGlTZ2w4ek8zalc3c2FQRUtQNmNKdk5xQkxVUDBTRmZs?=
 =?utf-8?B?alYxTDJ1KzU4RDczV1VMMHJKSzBiR3VRaThOYzg4TDloUGZZa01aNWlGc1lZ?=
 =?utf-8?B?RExsSDBjMXdRdDJvREp3enczTGFNaUdvK3YrV010Z1RpNEJhQmlCYTVnUFRY?=
 =?utf-8?B?L1BOMnBoR3NIVXpYSGNyTzQvZThDWWNQSkFQZjhJRStvNm9vYWlPVEw1eDFG?=
 =?utf-8?B?UkRiM0xna2RzWnlnV1dUMlF6TkNERFRiMzJEUnZGQ3NrM1NRSXNxTk9vYUhn?=
 =?utf-8?B?ajRVbGJDZlBHcHQ3d0pzT1VVSFAxc1k4TWFVZjBzeGI0UUU5Q1BLWnZCaWps?=
 =?utf-8?B?VytYVGUvTHhIMEtYQVZqRWJIeG1aVUFkTUNuSnlQQnJsWTd0S3hNTXJXbExK?=
 =?utf-8?B?RmRtVGsxalBnbTFXVnRjUUg4NW1kUUhSOG80Vktmd2c5dExHcDNiWmg5ZDNv?=
 =?utf-8?B?a2tSdHhQeEp6YmQxeTJaUGlybi9VY1I4V0w0Uk5veXdDVkhETVhwcWFqNm0y?=
 =?utf-8?B?OWZUdjZHeE8xWmxSRUcrblJRcnMrd1pMaGdtKzJEMFR4dWdFamhjQ0tnSWM1?=
 =?utf-8?B?MEJBeFRvQ21mbjd5cWcyejlmUVN2QVdOMTlRUjVqWWgzR3JJZVkrdUVWU0Rt?=
 =?utf-8?B?LzRWcDB6OTMyZWNyWDhvbEVOcUVqTXlubC9aSFNFMjB4ZFBDdjVTMjJpZ0JM?=
 =?utf-8?B?WGhRbjBBdGNnQTc0K2IrTjYwd29EZWNUZWFhRG9Ja2xHMlVtcjJTY3BKUTA5?=
 =?utf-8?B?NmszUGZMWkovbUF4R2d3Tlhvak9HaDNmL1NOTHR5TC9ZeWNrYVZJTnloeTNw?=
 =?utf-8?B?czRrYWx2R0VtY1hhWkJlYkkyUU8vS2U2eXJ4L2pVQlBrckdpcmMzZmd4ZU1O?=
 =?utf-8?B?a3FwNzI2ZlNFY0pTQTUwNGpVOVdMQUxFNXU4WkpudEZNU3k3dHVIY2lEblpY?=
 =?utf-8?B?N0E1MHYvZmRodjRQM1NoQXJUd0JlM1pEcUVPK3pLSENqaVRlNS9XRkJlSXc2?=
 =?utf-8?B?ZUVUQkxmUm9UZzdpVGMzSlpoZE5PVDdvNkRmNXowNmpNZWEzbXM2YUJpV2hw?=
 =?utf-8?B?a2R4VjFvc0JEdEJhc1N1LytCeG9FQ09YeFJUY0dFNU1VS2JFbFRCRE1RZTNn?=
 =?utf-8?B?WjZwU3Uxb3Zic2djVUNWR0h2SHBtcWUyUDV1SFdrdkpQOXhvZFUzdysrWHhQ?=
 =?utf-8?B?Q0ZjMUh3ckFKd2FERXVvUkRvRVY4N01aMzJ2NnBrUkU4T0hFOWlscHRlWnNM?=
 =?utf-8?Q?Yh6piU4En7Z/gsw6DppXZfJH7ocZokyIHLu/DED?=
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="utf-8"
Content-ID: <95686E50D5B73B459490678FEC1DA81F@namprd11.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MN2PR11MB4429.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 35403879-5d40-4bd4-c59e-08d936f24f5e
X-MS-Exchange-CrossTenant-originalarrivaltime: 24 Jun 2021 09:27:38.9213
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 5ae1af62-9505-4097-a69a-c1553ef7840e
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 8pLgqOUMoL92kOGVMkEuG2/gAPoQJxtbu/zIOUy5X3b+VMWUGa3Dg+ZvVcZFrNPO6hfjk/jMrFo8JdiAOAY7uw==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BL0PR11MB3362
X-OriginatorOrg: cisco.com
X-Outbound-SMTP-Client: 173.37.102.16, xbe-rcd-001.cisco.com
X-Outbound-Node: rcdn-core-7.cisco.com
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

T24gMjQuMDYuMjAyMSAxMTowNSwgRmxvcmlhbiBXZXN0cGhhbCB3cm90ZToNCj4gR2VvcmcgS29o
bWFubiA8Z2Vva29obWFAY2lzY28uY29tPiB3cm90ZToNCj4+IFBNVFUgaXMgdXBkYXRlZCBldmVu
IHRob3VnaCByZWNlaXZlZCBJQ01QdjYgUFRCIGRvIG5vdCBtYXRjaCBhbnkNCj4+IHRyYW5zbWl0
dGVkIHRyYWZmaWMuIFRoaXMgYnJlYWtzIFRBSEkgSVB2NiBDb3JlIENvbmZvcm1hbmNlIFRlc3QN
Cj4+IFJldmlzaW9uIDUuMC4xLCB2NkxDLjQuMS4xMiBWYWxpZGF0ZSBQYWNrZXQgVG9vIEJpZ1sx
XS4NCj4+DQo+PiBSZWZlcnJpbmcgdG8gUkZDODIwMSBJUHY2IFBhdGggTVRVIERpc2NvdmVyeSwg
c2VjdGlvbiA0OiAiTm9kZXMgc2hvdWxkDQo+PiBhcHByb3ByaWF0ZWx5IHZhbGlkYXRlIHRoZSBw
YXlsb2FkIG9mIElDTVB2NiBQVEIgbWVzc2FnZXMgdG8gZW5zdXJlDQo+PiB0aGVzZSBhcmUgcmVj
ZWl2ZWQgaW4gcmVzcG9uc2UgdG8gdHJhbnNtaXR0ZWQgdHJhZmZpYyAoaS5lLiwgYSByZXBvcnRl
ZA0KPj4gZXJyb3IgY29uZGl0aW9uIHRoYXQgY29ycmVzcG9uZHMgdG8gYW4gSVB2NiBwYWNrZXQg
YWN0dWFsbHkgc2VudCBieSB0aGUNCj4+IGFwcGxpY2F0aW9uKSBwZXIgW0lDTVB2Nl0uIg0KPj4N
Cj4+IG5mX2Nvbm50cmFja19pbmV0X2Vycm9yKCkgcmV0dXJuIC1ORl9BQ0NFUFQgaWYgdGhlIGlu
bmVyIGhlYWRlciBvZg0KPj4gSUNNUHY2IGVycm9yIHBhY2tldCBpcyBub3QgcmVsYXRlZCB0byBh
biBleGlzdGluZyBjb25uZWN0aW9uLiBEcm9wIFBUQg0KPj4gcGFja2V0IHdoZW4gdGhpcyBvY2N1
ci4gVGhpcyB3aWxsIHByZXZlbnQgaXB2NiBmcm9tIGhhbmRsaW5nIHRoZSBwYWNrZXQNCj4+IGFu
ZCB1cGRhdGUgdGhlIFBNVFUuDQo+IFRoaXMgaXMgaW50ZW50aW9uYWwuIFdlIHRyeSB0byBub3Qg
YXV0by1kcm9wIHBhY2tldHMgaW4gY29ubnRyYWNrLg0KPg0KPiBQYWNrZXQgaXMgbWFya2VkIGFz
IGludmFsaWQsIHVzZXJzIGNhbiBhZGQgbmZ0L2lwdGFibGVzIHJ1bGVzIHRvIGRpc2NhcmQNCj4g
c3VjaCBwYWNrZXRzIGlmIHRoZXkgd2FudCB0byBkbyBzby4NCkFoLCBkcm9wcGluZyBwYXRjaCB0
aGVuLCB0aGFuayB5b3UuDQo=
