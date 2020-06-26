Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9CC7D20B791
	for <lists+netdev@lfdr.de>; Fri, 26 Jun 2020 19:53:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726441AbgFZRw7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 26 Jun 2020 13:52:59 -0400
Received: from mga03.intel.com ([134.134.136.65]:57533 "EHLO mga03.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726002AbgFZRw6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 26 Jun 2020 13:52:58 -0400
IronPort-SDR: SQkrzBNkx0Cug5B6hw7D5aLOpElfwzJ2jxwTA5tIsSJVynIQ59K6mx5t+Wg7dYbwg9VNomxyaX
 vx5XGOUqnZMw==
X-IronPort-AV: E=McAfee;i="6000,8403,9664"; a="145485869"
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="145485869"
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from fmsmga005.fm.intel.com ([10.253.24.32])
  by orsmga103.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 26 Jun 2020 10:52:57 -0700
IronPort-SDR: 3XsleSW/qCyGOpEBfCzDvMrkcgd2SD4ogjd0zqbnDy7qvHItY80KbRSg3Ok+4bQJfveF6OwCtx
 GHXPKkjOa2ag==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.75,284,1589266800"; 
   d="scan'208";a="480074674"
Received: from orsmsx103.amr.corp.intel.com ([10.22.225.130])
  by fmsmga005.fm.intel.com with ESMTP; 26 Jun 2020 10:52:57 -0700
Received: from orsmsx121.amr.corp.intel.com (10.22.225.226) by
 ORSMSX103.amr.corp.intel.com (10.22.225.130) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:52:56 -0700
Received: from ORSEDG002.ED.cps.intel.com (10.7.248.5) by
 ORSMSX121.amr.corp.intel.com (10.22.225.226) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:52:56 -0700
Received: from NAM12-DM6-obe.outbound.protection.outlook.com (104.47.59.168)
 by edgegateway.intel.com (134.134.137.101) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Fri, 26 Jun 2020 10:52:56 -0700
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=cHglsh/e+iQ/T1hP/Tw15EwUKKz07IFNLLfzDJ7V+SA7NPZ3CHnX/ShVKFGYZh6bsYRxaUvHWEWSbObKKrKVKkHw+queir1lJ4qfwglv08VBIeJdyDSqJU2ncyLFzmcMH50FxLjv65AAaboM8Hc3Qo53HJmu77lABWKyuiw72izLeXiUPj1EhKoxi3Eu82vQtYUFCsLt3NBJAE1nPSr9Fqs4RWzMM5zBM+FV4rKBwp32siM+XWOwySnjCwdF/6NIY56q4G18BqnQ4SvYKCj3dUhgWFYw2xFA54wMF81FyjLKqsu3zdp5J+GthoFF60HgMAroQ+zjWPDmnNZuRLZ8EA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olHD/TqHkw+bHfaExOMKVWxmznJJF8uQmIdjtkuBl48=;
 b=faB1nEGrRWCgwMjkJnf5vRnS6iKVRsq5Okq9Ml0nHAEiXOe/CWPOXJ/8z2tbwrzhmUupYPhHf0Uqa56Hq2zSdx0YRuBnSZUp8BejLTaBxku9SreD6zo0qVMSGcDEYZ3O7oIVqanrYqxnKvhPh3LrI9XV8ns/8KgAZdhTy2shS8HYiUIGx1xGbEJjL1EXEqCB5TA9QmrzGTwRFtrnKN8gXbsJ/iqqIV/KLW9NBFh0ZGTHww61rUFkIjCm3Wck3jdk8FMzCatuTeHTmvJlpGHGMEu1lBnOUXElMq2X2a7ggM6TTQhalKfiCHxW0Jfm/RXsN+/kKWvBQS00VlE+xvgVlg==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=intel.com; dmarc=pass action=none header.from=intel.com;
 dkim=pass header.d=intel.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=intel.onmicrosoft.com;
 s=selector2-intel-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=olHD/TqHkw+bHfaExOMKVWxmznJJF8uQmIdjtkuBl48=;
 b=w2NdYe+fGOferN6eYrBJIdptKoCi+uceir3AJohLBXf3abEy25FAiRsvr8MK9F0z+XPbsrTCJavyu/H40oA3vm0Z3nU9B8PqjtUP5wP/twn9Vrc/zDyHYVC95qx2tDE4epCKKbSntGup4qi1FTP/zlJHq4+wUCnvuGAeEl0j+cQ=
Received: from MW3PR11MB4522.namprd11.prod.outlook.com (2603:10b6:303:2d::8)
 by MWHPR11MB1870.namprd11.prod.outlook.com (2603:10b6:300:10f::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3131.21; Fri, 26 Jun
 2020 17:52:52 +0000
Received: from MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50]) by MW3PR11MB4522.namprd11.prod.outlook.com
 ([fe80::4021:b214:94b3:3c50%6]) with mapi id 15.20.3131.023; Fri, 26 Jun 2020
 17:52:52 +0000
From:   "Brady, Alan" <alan.brady@intel.com>
To:     Joe Perches <joe@perches.com>,
        "Kirsher, Jeffrey T" <jeffrey.t.kirsher@intel.com>,
        "davem@davemloft.net" <davem@davemloft.net>
CC:     "Michael, Alice" <alice.michael@intel.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "nhorman@redhat.com" <nhorman@redhat.com>,
        "sassmann@redhat.com" <sassmann@redhat.com>,
        "Burra, Phani R" <phani.r.burra@intel.com>,
        "Hay, Joshua A" <joshua.a.hay@intel.com>,
        "Chittim, Madhu" <madhu.chittim@intel.com>,
        "Linga, Pavan Kumar" <pavan.kumar.linga@intel.com>,
        "Skidmore, Donald C" <donald.c.skidmore@intel.com>,
        "Brandeburg, Jesse" <jesse.brandeburg@intel.com>,
        "Samudrala, Sridhar" <sridhar.samudrala@intel.com>
Subject: RE: [net-next v3 12/15] iecm: Add singleq TX/RX
Thread-Topic: [net-next v3 12/15] iecm: Add singleq TX/RX
Thread-Index: AQHWS16dMJ15cu8SjEaJlvIjsim4KKjqOGOAgAD1wCA=
Date:   Fri, 26 Jun 2020 17:52:52 +0000
Message-ID: <MW3PR11MB45228441F903267FBEC31EF98F930@MW3PR11MB4522.namprd11.prod.outlook.com>
References: <20200626020737.775377-1-jeffrey.t.kirsher@intel.com>
         <20200626020737.775377-13-jeffrey.t.kirsher@intel.com>
 <de66eb53b15376161bca59e13f147a5ee4f36c33.camel@perches.com>
In-Reply-To: <de66eb53b15376161bca59e13f147a5ee4f36c33.camel@perches.com>
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
x-ms-office365-filtering-correlation-id: a4e206f9-dea2-456a-4b5e-08d819f9bfcd
x-ms-traffictypediagnostic: MWHPR11MB1870:
x-ld-processed: 46c98d88-e344-4ed4-8496-4ed7712e255d,ExtAddr
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <MWHPR11MB1870AA3778F3AB2BFB18843E8F930@MWHPR11MB1870.namprd11.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-forefront-prvs: 0446F0FCE1
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: tdlv71H6WA0U+mVl3EnAHfRQXZH1TbUeXhf8gBwox3K3liaCX13uUXyHnBIoDiuWjxO1Nyo+hE1Up7nuiIurVd1IZ1eoEiMp6tJS4d9O6iGVMA0wTRht8Q0jaxYj2BI2/xZMh6QZS0xtaR2Jlx3k7P1uj29e24phzo3bPw6+pyVXEPB57fXIPdPjW32DvW3FrPqfeOJqZHLi6QtA0+29RZyYBOKTeQV3lmGoqUhDHXKsLMz338tTEZ+r578W0dsoJgd2BnX2jVo20ipaUNZtb7ReT2x//y6ZUX0KnUYUoC6W5iBKMWO6g+QkajMvFFuw
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MW3PR11MB4522.namprd11.prod.outlook.com;PTR:;CAT:NONE;SFTY:;SFS:(4636009)(396003)(376002)(136003)(39860400002)(346002)(366004)(66556008)(316002)(52536014)(5660300002)(8676002)(9686003)(66476007)(8936002)(55016002)(86362001)(76116006)(64756008)(107886003)(33656002)(54906003)(66446008)(26005)(66946007)(83380400001)(4326008)(186003)(478600001)(110136005)(2906002)(7696005)(6506007)(53546011)(71200400001);DIR:OUT;SFP:1102;
x-ms-exchange-antispam-messagedata: YexOX15gJom//WDTHqrM/VCDaH9Ncs2Z4UXiXUovLAUF204qfn7w3e49fqe1KHwSql66TQvRrAAbbSv3zwVd45xLom/xiz+DJ4uggXhajbeawhOPGQazGf+1pWfE2kvAHwlSXGRDbaTt6xa7wJnwp2uJqxizo0gmvShOZ0NSnUP7ZiT8EBl43W8VaNbm8fwMGlaOafW1oPHBYABA6s5f0XUIVVrz5fBsPUdpoYG/4LS3Qnu8FXdG0eftkgZbJ5M6lVgfpjKjOlU49O8mkE7g8HT9azgGL/PlklWW/xdYSBhRQ0AzfZRPnQTjgW1pTqwjfd9nCG0B9WSZNYbYzgUQf9ULqPDTil5GDQ0JIttbn26AJ4JtRKrSvU7sUmvAy3gY/aJZhBN/1eRxWQHwlVD2WFJ4KrWJmGPmGHj2/2x6Vbv2sNmRd+A9XSNcfLQWeq4v4Xl7l94XxPPpCPhDcTORxj0SRhAQNze9F0y/kjRH0EWZN6UPw++gDSbHkEuhdcC6
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: MW3PR11MB4522.namprd11.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: a4e206f9-dea2-456a-4b5e-08d819f9bfcd
X-MS-Exchange-CrossTenant-originalarrivaltime: 26 Jun 2020 17:52:52.6029
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 46c98d88-e344-4ed4-8496-4ed7712e255d
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: iFGWSno4u7rfCD93tq4hMNaA6iQYK2gYbQFsc4o7NbDRvEIrtxE+pdNvGPLGLToGz4weXoVHjMupcYFAxkgejA==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: MWHPR11MB1870
X-OriginatorOrg: intel.com
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> -----Original Message-----
> From: Joe Perches <joe@perches.com>
> Sent: Thursday, June 25, 2020 8:12 PM
> To: Kirsher, Jeffrey T <jeffrey.t.kirsher@intel.com>; davem@davemloft.net
> Cc: Michael, Alice <alice.michael@intel.com>; netdev@vger.kernel.org;
> nhorman@redhat.com; sassmann@redhat.com; Brady, Alan
> <alan.brady@intel.com>; Burra, Phani R <phani.r.burra@intel.com>; Hay,
> Joshua A <joshua.a.hay@intel.com>; Chittim, Madhu
> <madhu.chittim@intel.com>; Linga, Pavan Kumar
> <pavan.kumar.linga@intel.com>; Skidmore, Donald C
> <donald.c.skidmore@intel.com>; Brandeburg, Jesse
> <jesse.brandeburg@intel.com>; Samudrala, Sridhar
> <sridhar.samudrala@intel.com>
> Subject: Re: [net-next v3 12/15] iecm: Add singleq TX/RX
>=20
> On Thu, 2020-06-25 at 19:07 -0700, Jeff Kirsher wrote:
> > From: Alice Michael <alice.michael@intel.com>
> >
> > Implement legacy single queue model for TX/RX flows.
> []
> > diff --git a/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
> > b/drivers/net/ethernet/intel/iecm/iecm_singleq_txrx.c
> []
> > @@ -145,7 +508,63 @@ static void iecm_rx_singleq_csum(struct iecm_queue
> *rxq, struct sk_buff *skb,
> >  				 struct iecm_singleq_base_rx_desc *rx_desc,
> >  				 u8 ptype)
> >  {
> []
> > +	if (ipv4 && (rx_error & (BIT(IECM_RX_BASE_DESC_ERROR_IPE_S) |
> > +				 BIT(IECM_RX_BASE_DESC_ERROR_EIPE_S))))
> > +		goto checksum_fail;
> > +	else if (ipv6 && (rx_status &
> > +		 (BIT(IECM_RX_BASE_DESC_STATUS_IPV6EXADD_S))))
> > +		goto checksum_fail;
> > +
> > +	/* check for L4 errors and handle packets that were not able to be
> > +	 * checksummed due to arrival speed
> > +	 */
> > +	if (rx_error & BIT(IECM_RX_BASE_DESC_ERROR_L3L4E_S))
> > +		goto checksum_fail;
> []
> > +checksum_fail:
> > +	dev_dbg(rxq->dev, "RX Checksum not available\n");
>=20
> If there's an actual checksum arrival speed issue, then likely this dbg o=
utput
> should be ratelimited too.
>=20

Yeah this is an issue.  I think we want to add a counter here instead of pr=
inting anything out anyway.  Will fix.

Alan

