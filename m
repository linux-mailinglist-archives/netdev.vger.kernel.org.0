Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 72A5520D373
	for <lists+netdev@lfdr.de>; Mon, 29 Jun 2020 21:12:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729091AbgF2S7B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 29 Jun 2020 14:59:01 -0400
Received: from mga09.intel.com ([134.134.136.24]:65096 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730234AbgF2S64 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 29 Jun 2020 14:58:56 -0400
IronPort-SDR: i4sBOwB+P7IXJ+NGMhiRMN3mJhrARxwULclMog00oCPmHnJEpuTcvsiRJyPGoSFL1xZc+W76Qu
 E9qVSZF6jzIQ==
X-IronPort-AV: E=McAfee;i="6000,8403,9666"; a="147580812"
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="147580812"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga001.jf.intel.com ([10.7.209.18])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 29 Jun 2020 11:47:46 -0700
IronPort-SDR: cmPIgizF64ELc0HKZ0rXvZpx3fAk8NNM+r7Ep1oltdDugg0+F/wGbwH+DWaRP2eu5z5XlFppXS
 uk3yEFqYKw8A==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,295,1589266800"; 
   d="scan'208";a="355539779"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga001.jf.intel.com with ESMTP; 29 Jun 2020 11:47:46 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Mon, 29 Jun 2020 11:47:22 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Mon, 29 Jun 2020 11:47:20 -0700
Received: from FMSEDG001.ED.cps.intel.com (10.1.192.133) by
 fmsmsx602.amr.corp.intel.com (10.18.126.82) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256) id 15.1.1713.5
 via Frontend Transport; Mon, 29 Jun 2020 11:47:20 -0700
Received: from NAM02-BL2-obe.outbound.protection.outlook.com (104.47.38.51) by
 edgegateway.intel.com (192.55.55.68) with Microsoft SMTP Server (TLS) id
 14.3.439.0; Mon, 29 Jun 2020 11:47:20 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=n1pSbdeBCtZYuj028q6D8PhVFgQyfC5TCHzNMk58NFbt2YzrptMOJC8/QQpSfoebmHvO8cs5VIYG9Ra4DQ5sdQ5MIxPGXWpnKN7RMQmHTTm1tBTOzHH8UMZ+TTwk2HdaAtAZ4dh06+9PNs5r4fteD9QIGQxPzgrneGkOTZE3rc8Mah1FKHHWQ1o35JJfncI315WiSzpue8eaDKfcmrldfYP66xyrQeyQNfOocdQT+7Q8USi3DbPYgBzhhU+TMKt42Jf/QUD6uoHktN3PL5+5Ihh7xtXuVoagqwrHhILN+wZ7ua5R9rYZuzFggHMT/vPd4aXs5KxcECC3QbKX2ZokAw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2WE8151XR1dP5UBYOkzqkw5Nr/d5hvBlxhoPiO5T/o=;
 b=mzA3Qj5AbEVQ9ZZOPCC8intjk7eDHwDI0m9wx+oCVliSx7RyRneWHPHM++Y+bVDl2PZ2uIYCyy0cjoRcWndB4w/pvPbjK5KmxzXaUBK6RNKkNb6IZp0noL0Z9hJWb3O2nXgi2ws1IzYgfaaF6jYOimWfkUTiOVEPJhEzmGonc5t9u6jpBOHf2J1F3c8dzdSQNN6buePYeg63j+Fgj3YcnDScNE2g9akL9b80sWR0lIAba2hDXNM2VwWWz+frtJxr3KzhDXhV4TckOJYq9UUdBpLe46YI5A96sYMgw0In7cCgU0keva+0GzCx88kYQ/B1O4M3PB2p/HRpSdjvKAPJfw==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=J2WE8151XR1dP5UBYOkzqkw5Nr/d5hvBlxhoPiO5T/o=;
 b=BckIn26dC/ARRNKE5QYZWGEZgWQlPgCCKfKZJEP7P5u63Hus904rAMnQPnxeIPMj+UIGWoCbB+ykCW7yO9t9kkgtV4BNWEuukZ364HfHrQYUoXh2BzqPIr+qrlNvwurcYuKxo0deaC1fMjlSCjToP+Zlq8+xeVt//GlodgquXlE=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MW3PR11MB4748.namprd11.prod.outlook.com (2603:10b6:303:2e::9) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.23; Mon, 29 Jun
 2020 18:47:18 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.027; Mon, 29 Jun 2020
 18:47:17 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Michael, Alice" <alice.michael@intel.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>,
        lkp <lkp@intel.com>
Subject: RE: [net-next v3 15/15] idpf: Introduce idpf driver
Thread-Topic: [net-next v3 15/15] idpf: Introduce idpf driver
Thread-Index: AQHWS16dw6+5edmw8ECPFJMrnHofWajqPwEAgAW1mkA=
Date:   Mon, 29 Jun 2020 18:47:17 +0000
Message-ID: <MW3PR11MB4522BE337570E8A27D36C51E8F6E0@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-16-jeffrey.t.kirsher@intel.com>
 <b7101ba0cd470df3be74a970c2a2e50de43ed7e6.camel@perches.com>
In-Reply-To: <b7101ba0cd470df3be74a970c2a2e50de43ed7e6.camel@perches.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
authentication-results: perches.com; dkim=none (message not signed)
 header.d=none;perches.com; dmarc=none action=none header.from=intel.com;
x-originating-ip: [174.127.217.60]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6bb55cb2-214e-42c2-0935-08d81c5cd93a
x-ms-traffictypediagnostic: MW3PR11MB4748:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MW3PR11MB4748FAB6004D5D40E85AC7018F6E0@MW3PR11MB4748.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:519;
x-forefront-prvs: 044968D9E1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: lwfOZuJN62KVKc3MBwechER84dRqZFHw2jZWuB6/ZwTeBjuUqRFZPEPDxes+q+Amk4pBW/FIoGfiAU/FaLkIHL8UL5yq+n4A1InxPnAFfXcGzBk6Bxi4IGsCAtE7PcO8XFCTvwVf8PruIDBZhLqETiFweuOxvY+LNRis4oSq5wBAdsILv5E6rchWUYaEO6oK9N1FFbiKumz8QKxo6ZIzexNcd4LGtESyAeZ0N2KOkxhkO+PGUR56nCa/XaYH5CNtQdoJVxip/paCwrUO+EPQzNrWQ3mstgKW+VzdFj4lYUJyJCiiOj0BCJJ63mfEfs+2
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(366004)(39860400002)(396003)(346002)(136003)(376002)(52536014)(7696005)(6506007)(53546011)(2906002)(86362001)(478600001)(186003)(26005)(5660300002)(4326008)(316002)(83380400001)(71200400001)(110136005)(54906003)(66946007)(66556008)(64756008)(66476007)(8936002)(76116006)(33656002)(9686003)(66446008)(8676002)(107886003)(55016002);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: tIyI5/lwVvymn56TKwIiFmb3VhbiGvWzKVtXwj1WkBRXOEhFRjZeQNcpWWKge45FDhr3BKIj92yVYiUhNKga+82tC3SizzL9b2rgFJ6RbtawP0BOHL1IeictqFB4L1Jd+uCuFv9uQOdjmJhKIHIog4MU8gsFrFsJz5P1nYs8iDA9uwRXmzdS3XqMVjH3r/rdRCxSeMv/aCpGJLcJX1llR6uZiWcGsfhYh6C4HQnlTKBlSN/AipaufX787T7Co4b/Xi89DX5dhMjPQ9TYxK9TNVJLGnSPqd09T6GpSgAzqWZ+8iLEez4wY9tfilEyn0wkeg4M+E0qJZXfR9M7NVcbXJSxEEaxxdSE12thMJyigSNbvvOP5MtlKso0N5H2p1DPjZ/m9bV0PxDeAOCKgpe+5ZimYptRUx7VhseLnvGTJLje4+B6dBquxDlnxpOqZ3iiJoZ0935KX5/MT3xuYw/d2WRGepvJBxmGXgMFOqRGfupQ8q71Vt8Y6vCscYhN1c4I
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 6bb55cb2-214e-42c2-0935-08d81c5cd93a
X-MS-Exchange-CrossTenant-originalarrivaltime: 29 Jun 2020 18:47:17.8021
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: vC0Ggq3s6LCJQ4R4T/zl/dUzrCwPScVon6I+nhdVYE7Ygj7WtnJYdoVFauimWimxPTi+TWGZ3Vr1bLRhMbfsWA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MW3PR11MB4748
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 8:36 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Brady, Alan <alan.brady@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Michael, Alice
> <alice.michael@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>; lkp <lkp@intel.com>
> Subject: Re: [net-next v3 15/15] idpf: Introduce idpf driver
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alan Brady <alan.brady@intel.com>
> >
> > Utilizes the Intel Ethernet Common Module and provides a device
> > specific implementation for data plane devices.
> []
> > diff --git a/drivers/net/ethernet/intel/idpf/idpf_main.c
> > b/drivers/net/ethernet/intel/idpf/idpf_main.c
> []
> > @@ -0,0 +1,136 @@
> > +// SPDX-License-Identifier: GPL-2.0-only
> > +/* Copyright (C) 2020 Intel Corporation */
> > +
> > +#define pr_fmt(fmt) KBUILD_MODNAME ": " fmt
> > +
> > +#include "idpf_dev.h"
> > +#include "idpf_devids.h"
> > +
> > +#define DRV_SUMMARY	"Intel(R) Data Plane Function Linux Driver"
> > +static const char idpf_driver_string[] =3D DRV_SUMMARY; static const
> > +char idpf_copyright[] =3D "Copyright (c) 2020, Intel Corporation.";
> > +
> > +MODULE_AUTHOR("Intel Corporation, <linux.nics@intel.com>");
> > +MODULE_DESCRIPTION(DRV_SUMMARY); MODULE_LICENSE("GPL v2");
> []
> > +static int __init idpf_module_init(void) {
> > +	int status;
> > +
> > +	pr_info("%s", idpf_driver_string);
>=20
> missing format terminating newline.
>=20
> > +	pr_info("%s\n", idpf_copyright);
>=20
>=20


Will fix, thanks.

Alan
