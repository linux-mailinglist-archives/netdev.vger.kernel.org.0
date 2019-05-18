Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4674622550
	for <lists+netdev@lfdr.de>; Sat, 18 May 2019 23:56:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729651AbfERV4g (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 18 May 2019 17:56:36 -0400
Received: from mx0b-00272701.pphosted.com ([208.86.201.61]:56358 "EHLO
        mx0b-00272701.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1727958AbfERV4g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 18 May 2019 17:56:36 -0400
X-Greylist: delayed 1506 seconds by postgrey-1.27 at vger.kernel.org; Sat, 18 May 2019 17:56:34 EDT
Received: from pps.filterd (m0107986.ppops.net [127.0.0.1])
        by mx0b-00272701.pphosted.com (8.16.0.27/8.16.0.27) with SMTP id x4ILNn6Z026987;
        Sat, 18 May 2019 16:31:23 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=ou.edu; h=from : to : cc : subject
 : date : message-id : references : in-reply-to : content-type : content-id
 : content-transfer-encoding : mime-version; s=domainkey;
 bh=TD6GiZhShaT8nwKLi5u0bkgB2wz4yzRA+7DywnhFMzw=;
 b=IvY4VfcRX9zFvTZyuYk1+M/nZBV1ONIGpPRzNo4bJ/C+TUDA4C58VKNR/F+0n5Q3Z+73
 KQSQXFRHXwvKAHQL7GfEgIjaB7LLt5WLCkdF0b3wlOJMtTuqJSyEyb5QhHLfi5A71ERw
 WRxQmKG0DONJyYOidwkWdOuam6IXkRE/PRjapJ2ZbX6UvMnSMdJVEpLesrVCsr/4ij73
 wNpqdhH4LFSCvxjHQ/O/rqNI+1WRxGwMEq1D+u5Aji//qMRlRCgGWo/7SVOAFyTf+gYp
 gTCqVwUBYEuSPLIqCbEzHj7DLvon5a7/Gl+hZGm/FcTUgngj/y1tEVNUmWoX/Y+Rup5E oQ== 
Received: from nam05-by2-obe.outbound.protection.outlook.com (mail-by2nam05lp2058.outbound.protection.outlook.com [104.47.50.58])
        by mx0b-00272701.pphosted.com with ESMTP id 2sjbjruwkg-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-SHA384 bits=256 verify=NOT);
        Sat, 18 May 2019 16:31:23 -0500
Received: from SN6PR03MB4064.namprd03.prod.outlook.com (52.135.110.223) by
 SN6PR03MB3471.namprd03.prod.outlook.com (52.135.79.24) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.1900.18; Sat, 18 May 2019 21:31:20 +0000
Received: from SN6PR03MB4064.namprd03.prod.outlook.com
 ([fe80::b5da:c33c:a5cf:d867]) by SN6PR03MB4064.namprd03.prod.outlook.com
 ([fe80::b5da:c33c:a5cf:d867%7]) with mapi id 15.20.1900.010; Sat, 18 May 2019
 21:31:20 +0000
From:   "Kenton, Stephen M." <skenton@ou.edu>
To:     Michael Grzeschik <mgr@pengutronix.de>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: ARCNET Contemporary Controls PCI20EX PCIe Card
Thread-Topic: ARCNET Contemporary Controls PCI20EX PCIe Card
Thread-Index: AQHVDOMwL9Lwp3ugSkunlAk2Zkk/FaZvtm8AgAGx1gA=
Date:   Sat, 18 May 2019 21:31:20 +0000
Message-ID: <8a3be156-19d5-6f18-861d-9e2d814d2072@ou.edu>
References: <be572630-98e4-95bc-f50a-e711ded62526@ou.edu>
 <20190517193829.effwzuu4pfjlp7rn@pengutronix.de>
In-Reply-To: <20190517193829.effwzuu4pfjlp7rn@pengutronix.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [99.63.185.115]
user-agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.6.1
x-clientproxiedby: MWHPR11CA0035.namprd11.prod.outlook.com
 (2603:10b6:300:115::21) To SN6PR03MB4064.namprd03.prod.outlook.com
 (2603:10b6:805:bf::31)
x-ms-exchange-messagesentrepresentingtype: 1
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 6d109a48-ad7c-4413-10bb-08d6dbd82b14
x-microsoft-antispam: BCL:0;PCL:0;RULEID:(2390118)(7020095)(4652040)(8989299)(4534185)(4627221)(201703031133081)(201702281549075)(8990200)(5600141)(711020)(4605104)(2017052603328)(7193020);SRVR:SN6PR03MB3471;
x-ms-traffictypediagnostic: SN6PR03MB3471:
x-microsoft-antispam-prvs: <SN6PR03MB347156DD136E72450C6AF10CDC040@SN6PR03MB3471.namprd03.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:10000;
x-forefront-prvs: 0041D46242
x-forefront-antispam-report: SFV:NSPM;SFS:(10019020)(366004)(136003)(39860400002)(376002)(346002)(396003)(189003)(199004)(8676002)(486006)(81156014)(81166006)(6486002)(229853002)(31696002)(36756003)(86362001)(256004)(14444005)(71190400001)(71200400001)(4326008)(8936002)(53546011)(2616005)(186003)(64756008)(446003)(6512007)(99286004)(6506007)(25786009)(786003)(11346002)(58126008)(66446008)(66556008)(66476007)(6436002)(7736002)(386003)(66946007)(476003)(305945005)(73956011)(5660300002)(76176011)(316002)(52116002)(102836004)(88552002)(65806001)(65956001)(75432002)(66066001)(14454004)(26005)(64126003)(68736007)(6116002)(3846002)(53936002)(478600001)(65826007)(6246003)(2906002)(6916009)(31686004);DIR:OUT;SFP:1102;SCL:1;SRVR:SN6PR03MB3471;H:SN6PR03MB4064.namprd03.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;MX:1;A:1;
received-spf: None (protection.outlook.com: ou.edu does not designate
 permitted sender hosts)
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam-message-info: 15SMqUVY6zCcpB0lfj78XNvkLJeQBZ/vn5EZs9mgxD8TTFOdyubrGuhSRhMxJM2QEYwZBJUhYekQaG1HWp03EaVnRaXuKEYY1vbpnMSDy97mPx4dvnz9Ym/lmSq102jLQ5t3bQ/nTP/PfvrCeTtEKgF4rLhxY8wlq3scrrpqRvngmxfveqrXNdZK4WXJWJLuZWDw03lqT9tS3DkBEoqFfVjqJF0M24YEyhbJu1idgxJc5tdzJUWhKuk2OgdUh+sU6E/ARdcmoc1tAZ94GQ/FsJ6sQOIflJ2vIxQz6z8NVDqsdcjHK4GtuKFMEQBwvNNlgAvzrXW54F83K8BnOMEm/npfQKH7V/rS04+dsbifnvazICZ2GokeJ/Yt6OMR4Obj9yuBtqGYcHmyzI8So3aLBc6jXJ6cH2SHFyCCxe4+ELE=
Content-Type: text/plain; charset="iso-8859-15"
Content-ID: <7989C89B72FECA4CB545B90ECAD6AA81@namprd03.prod.outlook.com>
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
X-OriginatorOrg: ou.edu
X-MS-Exchange-CrossTenant-Network-Message-Id: 6d109a48-ad7c-4413-10bb-08d6dbd82b14
X-MS-Exchange-CrossTenant-originalarrivaltime: 18 May 2019 21:31:20.4526
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 9c7de09d-9034-44c1-b462-c464fece204a
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SN6PR03MB3471
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10434:,, definitions=2019-05-18_17:,,
 signatures=0
X-Proofpoint-Spam-Details: rule=outbound_notspam policy=outbound score=0 priorityscore=1501
 malwarescore=0 suspectscore=0 phishscore=0 bulkscore=0 spamscore=0
 clxscore=1011 lowpriorityscore=0 mlxscore=0 impostorscore=0
 mlxlogscore=999 adultscore=0 classifier=spam adjust=0 reason=mlx
 scancount=1 engine=8.0.1-1810050000 definitions=main-1905180155
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/17/19 2:38 PM, Michael Grzeschik wrote:

> On Fri, May 17, 2019 at 07:03:19PM +0000, Kenton, Stephen M. wrote:
>> I've got some old optical (as in eyeglasses) equipment that only talks
>> over ARCNET that I want to get up and running. The PEX PCIe-to-PCI
>> bridge is on the card with the SMC COM20022 and lspci sees them
>>
>> 02:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX 8111 PCI
>> Express-to-PCI Bridge [10b5:8111] (rev 21)
>> 03:04.0 Network controller [0280]: Contemporary Controls Device
>> [1571:a0e4] (rev aa)
>>    =A0=A0=A0 Subsystem: Contemporary Controls Device [1571:a0e4]
>>
>> I just pulled the current kernel source and 1571:a0e4 does not seem to b=
e supported by the driver.
>>
>> Before I start trying to invent wheels, is/has anyone else looking in th=
is area?
> Hi,
>
> you should probably add a new entry into com20020pci_id_table
> with the mentioned id 1571:a0e4 in drivers/net/arcnet/com20020-pci.c
> and try how far you will come.
>
> Regards,
> Michael
>
I thought I would try temporarily adding support for the card id via=20
sysfs before trying to build from source

cd /sys/bus/pci/drivers

sudo modprobe com20020_pci
This creates the com20020 directory but not a com20020_pci directory if tha=
t matters

echo 1571 A0E4 | sudo tee com20020/new_id
This immediately generated two "killed" message in addition to echoing the =
PCI address to the console
which is probably not a good sign although it now claims to have a kernel d=
river, see below

lspci -nnk
<snip>
20:00.0 PCI bridge [0604]: PLX Technology, Inc. PEX 8111 PCI Express-to-PCI=
 Bridge [10b5:8111] (rev 21)
21:04.0 Network controller [0280]: Contemporary Controls Device [1571:a0e4]=
 (rev aa)
 =A0=A0=A0 Subsystem: Contemporary Controls Device [1571:a0e4]
 =A0=A0=A0 Kernel driver in use: com20020

Not surprisingly "ifconfig -a" does *NOT* show an arc0 interface

There are references to the COM20022 chip in the com20020 driver source so =
I was hoping it was really com2002x :-(

How now? My desktop is Ubuntu 14.04LTS (4.4.0-148) up-to-date will be much =
easier to use for testing but the intended target is running Ubuntu 18.04LT=
S up-to-date

Thanks,

Steve Kenton



 =20

