Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9C282F280E
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 08:34:50 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726730AbfKGHep (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 02:34:45 -0500
Received: from mail-eopbgr30045.outbound.protection.outlook.com ([40.107.3.45]:45479
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726514AbfKGHep (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Nov 2019 02:34:45 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HaFap97Wi0+uLXmGqxtAzlH3YuYm4sbD2BpoHj7OEdDVuhHjICueOUUA5DZZY4VEqBR5LuiX7DHRBx+k8QRz/ZnCaxliNPOMWozEZl4bhfsjF6SUcO5MEaIe1H4pe+gfFn9EJxl65mhVm2mRzWJYbvHrthveszVTm6A1bqGvbeB4uOCZYqP9b/B3cy+Lvwi1gpBaEqfsxdHcqyATzm7XVID0dl+TWzWaYK4rGsfmi8AI0MRgC/iq3jPZgmMf/lOMRbsYCFscELj3QvxZo/dLjkpDJQ1dcDU0NiRu9s0kh5+z4l45dx+111LD6OXVlSFjfkRA+g23tVpKi+sfmdt7cQ==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eAJbFHaQ/cdT3+IIEIM1jbKhydqauE2QxTlolNoF4Q=;
 b=oIyt0OBRpjGDHK6ztgF+g+Xm3hHBzQwQYdWOzksdswyGjjb6GdT0hm6QajdmlB8MYRSGp0qOm8hpSUCEJ/gBOumVLmmLvqVIKPYrKSD51MGej7lDJmssAH4QE1vnMV7TDnDf2vMNtANQ2lGIq0dti5f+blATtiwXhXIJM9QNPW1JRpBZkKiZ3hFcodSFw+Sw/zc64uTBOh5W/rJB+Xcr+EbduaTS5nPj2gBtRn7DOjrjCv2M+K24SpNhVwCdrEuN66mLtf/bfrECmMoKrdBH9oQsCjMotD62RysrhFuhhIp1hIHZ9h5RdIyfumn5Vl6TlkMtQMZg7E1hDj01D1pB8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nxp.com; dmarc=pass action=none header.from=nxp.com; dkim=pass
 header.d=nxp.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nxp.com; s=selector2;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=+eAJbFHaQ/cdT3+IIEIM1jbKhydqauE2QxTlolNoF4Q=;
 b=hgnGKk6Nk8Rsm2dEmS1Q8F8vaJSfzLK12UtWAUFvfsArGVW4g6fTB8f/Fu85YU+qmJmAywA7Al7tkKBHrDeqWk1ey+nENhw3YwoCHZbo8HIa9RL9a8RXHJLMKIzDcausW2bqicYgziSJq5a3FJQH2oMNEAt7eMgqn3p07qKjlJg=
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com (10.175.24.138) by
 VI1PR0402MB3568.eurprd04.prod.outlook.com (52.134.7.155) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2430.22; Thu, 7 Nov 2019 07:34:41 +0000
Received: from VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa]) by VI1PR0402MB2800.eurprd04.prod.outlook.com
 ([fe80::749b:178a:b8c5:5aaa%11]) with mapi id 15.20.2430.020; Thu, 7 Nov 2019
 07:34:41 +0000
From:   Ioana Ciornei <ioana.ciornei@nxp.com>
To:     Andrew Lunn <andrew@lunn.ch>
CC:     "davem@davemloft.net" <davem@davemloft.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] dpaa2-eth: add ethtool MAC counters
Thread-Topic: [PATCH net-next] dpaa2-eth: add ethtool MAC counters
Thread-Index: AQHVlQUyuUBdS7aIHkqxSS3y37H4uA==
Date:   Thu, 7 Nov 2019 07:34:41 +0000
Message-ID: <VI1PR0402MB280021AE88E253270FEEC02CE0780@VI1PR0402MB2800.eurprd04.prod.outlook.com>
References: <1573087748-31303-1-git-send-email-ioana.ciornei@nxp.com>
 <20191107014758.GA8978@lunn.ch>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
authentication-results: spf=none (sender IP is )
 smtp.mailfrom=ioana.ciornei@nxp.com; 
x-originating-ip: [86.121.29.241]
x-ms-publictraffictype: Email
x-ms-office365-filtering-ht: Tenant
x-ms-office365-filtering-correlation-id: 75e42622-9866-47b4-ffba-08d76354f3c7
x-ms-traffictypediagnostic: VI1PR0402MB3568:
x-microsoft-antispam-prvs: <VI1PR0402MB3568727A0A98111F5D110876E0780@VI1PR0402MB3568.eurprd04.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:7691;
x-forefront-prvs: 0214EB3F68
x-forefront-antispam-report: SFV:NSPM;SFS:(10009020)(4636009)(136003)(366004)(39860400002)(346002)(376002)(396003)(199004)(189003)(33656002)(25786009)(8936002)(81156014)(86362001)(8676002)(9686003)(55016002)(81166006)(66946007)(6116002)(3846002)(66476007)(66446008)(64756008)(66556008)(99286004)(6506007)(26005)(53546011)(102836004)(76176011)(7696005)(76116006)(186003)(316002)(54906003)(486006)(446003)(476003)(6436002)(44832011)(2906002)(4326008)(5660300002)(6246003)(71190400001)(71200400001)(52536014)(14454004)(478600001)(229853002)(6916009)(66066001)(305945005)(7736002)(74316002)(256004);DIR:OUT;SFP:1101;SCL:1;SRVR:VI1PR0402MB3568;H:VI1PR0402MB2800.eurprd04.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
received-spf: None (protection.outlook.com: nxp.com does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: bEeZAsDnaxVPUhU4XTasqI4EXNFb2ZKneXfg9wMDRL+/TEvE6GrrnTw/jyDw7SGCRtXvlhQJO2ps9jIlVn7SbMFSDGf5xOKKCBGp3nUUfmAwB1aD5S1VH+arI7WhJx1Dreo1QAVneUWBcZkWasUVtenacQydlsAKe3r/34xK7KRaJzw1K9pEK3FKiNdWN61xWA/+Wp/dn2ljqoVt06JAkGk0AgKGKaJY+HRoFy1YXgxFjBFdUCAinY55IgG+Y0yI2VXOrUlu8IVam9K5xntCBTBzyAJcjkW/ZOsxx0HMHndlq2lSteqq09Q9tzdpsfbwsstNITiJjspmVWk0yNzX91Yqqmi18mfEaeNC/o/0rW+oEHJWtxJq3waPi5wY3wy5Cw3R7PovxJCvVJiFLnc9L10WifmhY98ETZklooN1T7DXaOsTIim7h8j51iuD/R4i
x-ms-exchange-transport-forked: True
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: nxp.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 75e42622-9866-47b4-ffba-08d76354f3c7
X-MS-Exchange-CrossTenant-originalarrivaltime: 07 Nov 2019 07:34:41.3408
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 686ea1d3-bc2b-4c6f-a92c-d99c5c301635
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: 5LPJecDPIfo/pPQnaBitYfGG7hfJtPAPyjyOH8D1t3gGXpfRfR6JPkyCeV1jwjTP/dE0dHpGWX4cdSL+oDSkBQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: VI1PR0402MB3568
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/7/19 3:48 AM, Andrew Lunn wrote:=0A=
> On Thu, Nov 07, 2019 at 02:49:08AM +0200, Ioana Ciornei wrote:=0A=
>> +void dpaa2_mac_get_ethtool_stats(struct dpaa2_mac *mac, u64 *data)=0A=
>> +{=0A=
>> +	struct fsl_mc_device *dpmac_dev =3D mac->mc_dev;=0A=
>> +	int i, err;=0A=
>> +	u64 value;=0A=
>> +=0A=
>> +	for (i =3D 0; i < DPAA2_MAC_NUM_STATS; i++) {=0A=
>> +		err =3D dpmac_get_counter(mac->mc_io, 0, dpmac_dev->mc_handle,=0A=
>> +					i, &value);=0A=
>> +		if (err) {=0A=
>> +			netdev_err(mac->net_dev,=0A=
>> +				   "dpmac_get_counter error %d\n", err);=0A=
>> +			return;=0A=
> =0A=
> Hi Ioana=0A=
> =0A=
> I've seen quite a few drivers set *data to U64_MAX when there is an=0A=
> error. A value like that should stand out. The kernel message might=0A=
> not be seen.=0A=
=0A=
Hi Andrew,=0A=
=0A=
I was wondering also how to make the error stand out. I myself missed =0A=
the error message, especially when the error is printed before a full =0A=
screen of counters.=0A=
=0A=
Thanks, I'll do this in v2.=0A=
=0A=
> =0A=
>> +/**=0A=
>> + * dpmac_get_counter() - Read a specific DPMAC counter=0A=
>> + * @mc_io:	Pointer to opaque I/O object=0A=
>> + * @cmd_flags:	Command flags; one or more of 'MC_CMD_FLAG_'=0A=
>> + * @token:	Token of DPMAC object=0A=
>> + * @id:		The requested counter ID=0A=
>> + * @value:	Returned counter value=0A=
>> + *=0A=
>> + * Return:	The requested counter; '0' otherwise.=0A=
>> + */=0A=
>> +int dpmac_get_counter(struct fsl_mc_io *mc_io, u32 cmd_flags, u16 token=
,=0A=
>> +		      enum dpmac_counter_id id, u64 *value)=0A=
>> +{=0A=
>> +	struct dpmac_cmd_get_counter *dpmac_cmd;=0A=
>> +	struct dpmac_rsp_get_counter *dpmac_rsp;=0A=
>> +	struct fsl_mc_command cmd =3D { 0 };=0A=
>> +	int err =3D 0;=0A=
>> +=0A=
>> +	cmd.header =3D mc_encode_cmd_header(DPMAC_CMDID_GET_COUNTER,=0A=
>> +					  cmd_flags,=0A=
>> +					  token);=0A=
>> +	dpmac_cmd =3D (struct dpmac_cmd_get_counter *)cmd.params;=0A=
>> +	dpmac_cmd->id =3D id;=0A=
>> +=0A=
>> +	err =3D mc_send_command(mc_io, &cmd);=0A=
>> +	if (err)=0A=
>> +		return err;=0A=
>> +=0A=
>> +	dpmac_rsp =3D (struct dpmac_rsp_get_counter *)cmd.params;=0A=
>> +	*value =3D le64_to_cpu(dpmac_rsp->counter);=0A=
>> +=0A=
>> +	return 0;=0A=
>> +}=0A=
> =0A=
> How expensive is getting a single value? Is there a way to just get=0A=
> them all in a single command? The ethtool API always returns them all,=0A=
> so maybe you can optimise the firmware API to do the same?=0A=
> =0A=
>     Andrew=0A=
> =0A=
=0A=
I don't know exact numbers for how expensive a single fw command is but =0A=
you definitely do not wait for the output of 'ethtool -S'.=0A=
At the moment, we do not have an API to just get all the counters at =0A=
once (as we have for the DPNI object). I would argue that even though I =0A=
can optimise the fw API, I still want to have counters on older firmware =
=0A=
images.=0A=
Anyhow, I'll add this to the list of things to improve in the fw :)=0A=
=0A=
   Ioana=0A=
=0A=
