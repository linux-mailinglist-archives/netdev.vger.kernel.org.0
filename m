Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD6C535A355
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 18:29:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233978AbhDIQ3R (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Apr 2021 12:29:17 -0400
Received: from aserp2130.oracle.com ([141.146.126.79]:36436 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234139AbhDIQ3N (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 9 Apr 2021 12:29:13 -0400
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139GJE4E180819;
        Fri, 9 Apr 2021 16:27:19 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=from : to : cc :
 subject : date : message-id : references : in-reply-to : content-type :
 content-id : content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=iFAMYRQNxnaBoX7hzbwFFBdQVDGwmsy4YB2Gkh9m4yQ=;
 b=XDDC25hIT625xxFhEWxRBBOp4fzHcl2LyA5B4/x/t7+f3fhcEDiRCaWgmOvUz+0AGPY7
 SXosL/Nz/kQI0EsyiF6U/QrNud9I4IX6ZhIKflkD/wcqzPgvZmfCe6SdyXg8wcoulItd
 2xCSi5ExZDGJ9jZi+S5AXdyHf4edowzEMAKm0jtX6qxQ/P71qEPFmiIs2YhVXlxQ+kRI
 VoU52muul89GTRV1LoiCEsSPiNyAnoP7ZHzFPC3vxXdoJWRD4bDk/HKkMb6W8aqJwMOk
 KQOI4Y/xprMVdeUol7toWcanVfxHljnJT4qLlyNGFrgzgLgvMqaOl9ptdkrhIjgdrtJm hQ== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 37rvaw9ypp-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 16:27:19 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 139GQ6Eq108269;
        Fri, 9 Apr 2021 16:27:18 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by userp3030.oracle.com with ESMTP id 37rvbh7bnd-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 09 Apr 2021 16:27:18 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=KO1jt8Te4ePhZhwQDf9t3mlnqLDkduveuotkTlK+ijl7H50qQTGdu/KLeeuu3eKozJ/Jqu/M18rY0Cjozw+w44vazp+0IdlzUtIZan7qAbp/3bMlOk/9UtJo3U0M5KjcYfmM2Iujpr5PnpBzTfNRs2OrZcw3yMpqPLevzU8FeKsG/zCCI3Mku1ZvJB9RNr4VeGBAyItD2mOnhvJFC4/+LFSH60+bGc9mX1HuBuIzPkG+BxmiWutEQP12pCgAKJGiOQOoSDjliP2UkPgo9PFzPDc3+papeKmvYQIAxOG4G3DtVv0P/PxxDdcErdscHH7dV0qr4aADH2+2mlEU8bFoxw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFAMYRQNxnaBoX7hzbwFFBdQVDGwmsy4YB2Gkh9m4yQ=;
 b=ioSGWUYDzFnGICR50Glq9mmtBQTLO9BnvC602bf2zLmC19EVn19U2s1d7PQUOoivuFeZwEXhm6xSSHhFgVwU1U9FbTrFl023TRKG1fg7YtJAQDgSGqBOzEowcH5ayhZY9nldHMEOBAAWfSLd2YxykbmIYS0BPhtChl1SbHZAkM/rD6BdnYHRtSOQ8Fbobfu8Y9az3jLPR8teeY//72SXFV8JSIAd5iMBzu9E/FS6NwHJ0hMNqi+wHnoLBqEB4XEAW7dLr9V6EUhPVn5jyw4PMpNngWn4xKCJlaBeIUEVLk5DMjYpsv6ojZq0KoTl5pNmRM0QYIZ+O6i+wSngpyV2DA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=iFAMYRQNxnaBoX7hzbwFFBdQVDGwmsy4YB2Gkh9m4yQ=;
 b=dabCRZvVeiPWyu0LJ/egt+DLyZFOlQf9zG176nSdfyGh5TOwBCpkMgetJWtj2hg+8tFBlajvHarvqPPnkasmgIliHYJCpHkvhk36rzVoMoe0Ygt0v90/9zrs9c1Kbu47TSVsa8fIJTpF3LDitoPK0ekmy2oYNkGqsP0TIJzuWeM=
Received: from CY4PR10MB1989.namprd10.prod.outlook.com (2603:10b6:903:11a::12)
 by CY4PR10MB1381.namprd10.prod.outlook.com (2603:10b6:903:29::11) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4020.18; Fri, 9 Apr
 2021 16:27:11 +0000
Received: from CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5]) by CY4PR10MB1989.namprd10.prod.outlook.com
 ([fe80::ad28:97d2:76cf:3fa5%11]) with mapi id 15.20.4020.018; Fri, 9 Apr 2021
 16:27:11 +0000
From:   Haakon Bugge <haakon.bugge@oracle.com>
To:     Tom Talpey <tom@talpey.com>
CC:     Chuck Lever III <chuck.lever@oracle.com>,
        Jason Gunthorpe <jgg@nvidia.com>,
        Christoph Hellwig <hch@lst.de>,
        Leon Romanovsky <leon@kernel.org>,
        Doug Ledford <dledford@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Adit Ranadive <aditr@vmware.com>,
        Anna Schumaker <anna.schumaker@netapp.com>,
        Ariel Elior <aelior@marvell.com>,
        Avihai Horon <avihaih@nvidia.com>,
        Bart Van Assche <bvanassche@acm.org>,
        Bernard Metzler <bmt@zurich.ibm.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@cornelisnetworks.com>,
        Devesh Sharma <devesh.sharma@broadcom.com>,
        Faisal Latif <faisal.latif@intel.com>,
        Jack Wang <jinpu.wang@ionos.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Bruce Fields <bfields@fieldses.org>, Jens Axboe <axboe@fb.com>,
        Karsten Graul <kgraul@linux.ibm.com>,
        Keith Busch <kbusch@kernel.org>, Lijun Ou <oulijun@huawei.com>,
        CIFS <linux-cifs@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Linux NFS Mailing List <linux-nfs@vger.kernel.org>,
        "linux-nvme@lists.infradead.org" <linux-nvme@lists.infradead.org>,
        OFED mailing list <linux-rdma@vger.kernel.org>,
        "linux-s390@vger.kernel.org" <linux-s390@vger.kernel.org>,
        Max Gurtovoy <maxg@mellanox.com>,
        Max Gurtovoy <mgurtovoy@nvidia.com>,
        "Md. Haris Iqbal" <haris.iqbal@ionos.com>,
        Michael Guralnik <michaelgur@nvidia.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Mike Marciniszyn <mike.marciniszyn@cornelisnetworks.com>,
        Naresh Kumar PBS <nareshkumar.pbs@broadcom.com>,
        Linux-Net <netdev@vger.kernel.org>,
        Potnuri Bharat Teja <bharat@chelsio.com>,
        "rds-devel@oss.oracle.com" <rds-devel@oss.oracle.com>,
        Sagi Grimberg <sagi@grimberg.me>,
        "samba-technical@lists.samba.org" <samba-technical@lists.samba.org>,
        Santosh Shilimkar <santosh.shilimkar@oracle.com>,
        Selvin Xavier <selvin.xavier@broadcom.com>,
        Shiraz Saleem <shiraz.saleem@intel.com>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Steve French <sfrench@samba.org>,
        Trond Myklebust <trond.myklebust@hammerspace.com>,
        VMware PV-Drivers <pv-drivers@vmware.com>,
        Weihang Li <liweihang@huawei.com>,
        Yishai Hadas <yishaih@nvidia.com>,
        Zhu Yanjun <zyjzyj2000@gmail.com>
Subject: Re: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Topic: [PATCH rdma-next 00/10] Enable relaxed ordering for ULPs
Thread-Index: AQHXKdv4VwXly9yLzUySAd7Scm0t5aql7vqAgABr9YCAADwJgIAAyzgAgATit4CAAAVvAIAADRqAgAAPN4A=
Date:   Fri, 9 Apr 2021 16:27:10 +0000
Message-ID: <1FA38618-E245-4C53-BF49-6688CA93C660@oracle.com>
References: <20210405052404.213889-1-leon@kernel.org>
 <20210405134115.GA22346@lst.de> <20210405200739.GB7405@nvidia.com>
 <C2924F03-11C5-4839-A4F3-36872194EEA8@oracle.com>
 <20210406114952.GH7405@nvidia.com>
 <aeb7334b-edc0-78c2-4adb-92d4a994210d@talpey.com>
 <8A5E83DF-5C08-49CE-8EE3-08DC63135735@oracle.com>
 <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
In-Reply-To: <4b02d1b2-be0e-0d1d-7ac3-38d32e44e77e@talpey.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-mailer: Apple Mail (2.3654.60.0.2.21)
authentication-results: talpey.com; dkim=none (message not signed)
 header.d=none;talpey.com; dmarc=none action=none header.from=oracle.com;
x-originating-ip: [51.175.204.144]
x-ms-publictraffictype: Email
x-ms-office365-filtering-correlation-id: 71605f2f-58d9-4c26-aeb3-08d8fb745399
x-ms-traffictypediagnostic: CY4PR10MB1381:
x-ms-exchange-transport-forked: True
x-microsoft-antispam-prvs: <CY4PR10MB13818F5A78800593052B64B5FD739@CY4PR10MB1381.namprd10.prod.outlook.com>
x-ms-oob-tlc-oobclassifiers: OLM:6108;
x-ms-exchange-senderadcheck: 1
x-microsoft-antispam: BCL:0;
x-microsoft-antispam-message-info: 0HbSXRTE5AlZYBHfAGvhIDk0fls5xQQD8+xz7zkVwg1Vx5+fGqql5tApr8C/qA7bJz5aXJ4VluZ0wMn5H0u7JMvmrNNQk9ZpKJxXdtqF6TO1E/KHhzw3UHKEjbG76JSNuPZkoVKn5uDUTGl3okcTk+qlPlhErEjdqCAUr3ZZfL+VvZYIHFiYguN1RUFdjXPP5vSRCbCo0Rqv4dVJtAOTwMCIdJNqQKxL/VIYMhe677J0JtMsj1U2ceDHlSlNmEL4GpZ+F5iCud9sKPY2sDSQdrwxLgx1h3vP/eLBGd7l3BnrooPx+GHZGLvayV2eiybIaiwh9oNIOSlLpuhOAw9ecoxOFra5BQrb1NRDHMbwp2e2nQMO1lZXIqqzCspp++gQQThZogc1NpVD2w3LAfihdYYZ04sCC72lalW104myZXCLOtVSfYNPg+AdQvpXx9lTaQmOXaBbpPaCRM4bLtEIYY9/jb9NDOk3tDORk0V+wd6QOzl9+cuJSxl+RVr+FxvFHsc66SnPifcT2MyfAESBsbXVLF4Fhfr6RjgdmPJzSJcMOSDwOHzIZzNK8vtYZKFG+PnoezyK6TOUphdoGDmGbNaWqS7pSxEhRzoKmDtJMo9+kVcz3CN5acl4++QXc4a7ToWlow+ttcnWgbLtdmK5IzjUxCWzjXHtwvsy4iToVQkEH/5DQCmDQZfr8OrBSPUQ
x-forefront-antispam-report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:CY4PR10MB1989.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(136003)(396003)(376002)(39860400002)(366004)(346002)(4326008)(7406005)(8676002)(71200400001)(478600001)(8936002)(6506007)(66574015)(5660300002)(6486002)(6916009)(53546011)(54906003)(2616005)(316002)(44832011)(7416002)(83380400001)(7366002)(38100700001)(26005)(66446008)(86362001)(66476007)(76116006)(2906002)(91956017)(36756003)(66556008)(66946007)(6512007)(64756008)(33656002)(186003)(45980500001);DIR:OUT;SFP:1101;
x-ms-exchange-antispam-messagedata: =?utf-8?B?RFRvUVVOaXRNMEZkUzZtazFNK2YzaUZrbk9vOVlsdU9OZVEwZWRvTms2d2pO?=
 =?utf-8?B?Z2FpOE1DelVJajhDdmN4RS8rZFVJdkpyN2NKMTFEblYyYTM4b2FoNnNNSkRw?=
 =?utf-8?B?ZWtKVlFSOHpSSUdJcC9abmVLYTNGWDlRdE5abkhrRmFwaFV0c2dielFxOXE3?=
 =?utf-8?B?cEtkWWVPYnQzemhWRVFQZGpuWWlFNTBqYlV0NkQyRzlMWTZXMnViVFgyVlFr?=
 =?utf-8?B?NDVTN1VjMitVSXROd3R6RURwR0hOeWlVVFRKQzFoRnRRQUpKRU9CTElMQWtl?=
 =?utf-8?B?cGhLeWpLN1pldlh1ZkdUREtuVzJieDBHQyt5V1ZaT0gxSzJhSXI2OWtQSTY0?=
 =?utf-8?B?OUtMY2xtekNoNmd1QUtqTlYzM3Q2THRBeDh5REZiemdtUGhvWkhzbzBnUVU0?=
 =?utf-8?B?T2Qvb2RoK0Q4UlhFcUFyaEI5c21FckxBd3hzQzBzWEpqa05hdVIzenczZmlX?=
 =?utf-8?B?bjZqb2ZWZ0ttWDV2cWNwUUdCRkx3bURHNnlaSlBaTWtEUkpCWmovSHMzd1Ev?=
 =?utf-8?B?Lyt1Mkx4VDlPSmJEcTlacVZuMStUOWlvRDR3enFRckpjb0orZFVVWHBQNjF3?=
 =?utf-8?B?UHQ4QUh2RjBUd0tVd2E4bGoyL0JycWhMYWxQYTNiVkkvMVRkenJzd05haTln?=
 =?utf-8?B?SkNtbk9xVDVhUE1yV1V4YUJ2b3kyU25yOGltSHhWZzIvWFhrZTdVQlVLMFhk?=
 =?utf-8?B?bDd2UFRkT28zQUtZL0t1S1V5bENhNm9CMHhJQy9iUGE4azJoOVlVVCtjUjNx?=
 =?utf-8?B?akhncjdXT0swaGVmV1RDR1JEeGZFOHNqZ2c1U3JOb256bGxqaU1UbUEyQnVY?=
 =?utf-8?B?RExySXJ4MlJxbXozd1I0cFVpQnRBcklqVXV1TEpGTjk1RkJLMUJhOEJ3RFAx?=
 =?utf-8?B?UUNsd21vek00dVZXcyt4VVNqeGYrMzVsdXloMVFMUDRETVkvOWJQck5zZE1N?=
 =?utf-8?B?ZmFVVi9IZEhNZW4vajdoYWFuQTZDcGtMbS9LandXWmcvZXBKdEY2eitkc2hx?=
 =?utf-8?B?UTV6ZzF3ZmNIV1crSFNvT0ppaW9nNnhFM2k3dzJBdHJSYjc5SThZU09OblNu?=
 =?utf-8?B?bjVaVlc1cWJXWmt6R0lESDV3QjNSSFUyZ2FoVEZKMExXK3JnSnBHQVcxRFZE?=
 =?utf-8?B?S1dxQkkrSE93K1B2bm03ZG8rZWFZVHBBVU50cTd5ZmFFaE5rRlBMWlptUDlr?=
 =?utf-8?B?NFZTTEU4SDVlWmdqaVN5K2hVRTdUT1JXTHVWTXNoWFR4TmtpMEFlMDQwWGti?=
 =?utf-8?B?SEFVTFNQSzRXT3IrZmRUMWhBVWF1Vk85eTRIVnN1TytPTHYyYzlidzErdDMz?=
 =?utf-8?B?Q25vc3pBK2pTQUJndGo4NDZJeDQyVXBlMHFwMmhvcFJHYitUYnJPZU9ocFJ1?=
 =?utf-8?B?Ti94RmFGV2pYWGtwMlo4K1F6MnVXb0c1YVRzb09oemFSMkFDVTN5ZnhJSEwz?=
 =?utf-8?B?YXcyQ255R0lPSm1pdVpQdmErQ3lCeWltUjNvVmxGQlpwSE4xenVXand5YmZO?=
 =?utf-8?B?UWp2a0dDWGRNMkpTRVVwUEF4d295a3p0SjgvbzdmaGdyZXRSU28rQlhoOGRq?=
 =?utf-8?B?a241RDdBRUpTLzN0L3V5cG54MnViVUh6QTY1N0kxcitPVG5EN2NmL09Zdnkr?=
 =?utf-8?B?cEdEWmJ0TzlsZ0JEakNKMWkxMG05SGRGeFJEU1JBR0ZWVjBFOFJYNVl2VlVh?=
 =?utf-8?B?SllRSEt0UTNZNGZFK2VQbGEzdmRUOUNZTXF1S1JRMkNtcjlkT3g3NmtwU2dY?=
 =?utf-8?B?OTlIbnhIU3N4d1lHMEtLaVRtK2lVYm1hb25mZGovWkxGR2tlRjdQcmRzY0Z5?=
 =?utf-8?B?ZStBRk1OYzZZczU0UTl3QT09?=
Content-Type: text/plain; charset="utf-8"
Content-ID: <BCE613419DF46B45A594465039CB47DB@namprd10.prod.outlook.com>
Content-Transfer-Encoding: base64
MIME-Version: 1.0
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-AuthSource: CY4PR10MB1989.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 71605f2f-58d9-4c26-aeb3-08d8fb745399
X-MS-Exchange-CrossTenant-originalarrivaltime: 09 Apr 2021 16:27:10.8414
 (UTC)
X-MS-Exchange-CrossTenant-fromentityheader: Hosted
X-MS-Exchange-CrossTenant-id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-mailboxtype: HOSTED
X-MS-Exchange-CrossTenant-userprincipalname: qqC8PZQLqKM6h/dAbvrP2ikBeu7ZruFB3Ywfqms1EPygE89T10F9Hz4EOQxDb9RxZPNtodDkqThTCPWudYiA4A==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CY4PR10MB1381
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxlogscore=999 bulkscore=0
 suspectscore=0 phishscore=0 malwarescore=0 mlxscore=0 spamscore=0
 adultscore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104060000 definitions=main-2104090117
X-Proofpoint-ORIG-GUID: -VohchOx_7cUS5AxCINQm4jiDRm0WzN6
X-Proofpoint-GUID: -VohchOx_7cUS5AxCINQm4jiDRm0WzN6
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9949 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 lowpriorityscore=0 priorityscore=1501
 suspectscore=0 phishscore=0 mlxlogscore=999 spamscore=0 malwarescore=0
 mlxscore=0 bulkscore=0 impostorscore=0 adultscore=0 clxscore=1011
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104060000
 definitions=main-2104090116
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

DQoNCj4gT24gOSBBcHIgMjAyMSwgYXQgMTc6MzIsIFRvbSBUYWxwZXkgPHRvbUB0YWxwZXkuY29t
PiB3cm90ZToNCj4gDQo+IE9uIDQvOS8yMDIxIDEwOjQ1IEFNLCBDaHVjayBMZXZlciBJSUkgd3Jv
dGU6DQo+Pj4gT24gQXByIDksIDIwMjEsIGF0IDEwOjI2IEFNLCBUb20gVGFscGV5IDx0b21AdGFs
cGV5LmNvbT4gd3JvdGU6DQo+Pj4gDQo+Pj4gT24gNC82LzIwMjEgNzo0OSBBTSwgSmFzb24gR3Vu
dGhvcnBlIHdyb3RlOg0KPj4+PiBPbiBNb24sIEFwciAwNSwgMjAyMSBhdCAxMTo0MjozMVBNICsw
MDAwLCBDaHVjayBMZXZlciBJSUkgd3JvdGU6DQo+Pj4+ICANCj4+Pj4+IFdlIG5lZWQgdG8gZ2V0
IGEgYmV0dGVyIGlkZWEgd2hhdCBjb3JyZWN0bmVzcyB0ZXN0aW5nIGhhcyBiZWVuIGRvbmUsDQo+
Pj4+PiBhbmQgd2hldGhlciBwb3NpdGl2ZSBjb3JyZWN0bmVzcyB0ZXN0aW5nIHJlc3VsdHMgY2Fu
IGJlIHJlcGxpY2F0ZWQNCj4+Pj4+IG9uIGEgdmFyaWV0eSBvZiBwbGF0Zm9ybXMuDQo+Pj4+IFJP
IGhhcyBiZWVuIHJvbGxpbmcgb3V0IHNsb3dseSBvbiBtbHg1IG92ZXIgYSBmZXcgeWVhcnMgYW5k
IHN0b3JhZ2UNCj4+Pj4gVUxQcyBhcmUgdGhlIGxhc3QgdG8gY2hhbmdlLiBlZyB0aGUgbWx4NSBl
dGhlcm5ldCBkcml2ZXIgaGFzIGhhZCBSTw0KPj4+PiB0dXJuZWQgb24gZm9yIGEgbG9uZyB0aW1l
LCB1c2Vyc3BhY2UgSFBDIGFwcGxpY2F0aW9ucyBoYXZlIGJlZW4gdXNpbmcNCj4+Pj4gaXQgZm9y
IGEgd2hpbGUgbm93IHRvby4NCj4+PiANCj4+PiBJJ2QgbG92ZSB0byBzZWUgUk8gYmUgdXNlZCBt
b3JlLCBpdCB3YXMgYWx3YXlzIHNvbWV0aGluZyB0aGUgUkRNQQ0KPj4+IHNwZWNzIHN1cHBvcnRl
ZCBhbmQgY2FyZWZ1bGx5IGFyY2hpdGVjdGVkIGZvci4gTXkgb25seSBjb25jZXJuIGlzDQo+Pj4g
dGhhdCBpdCdzIGRpZmZpY3VsdCB0byBnZXQgcmlnaHQsIGVzcGVjaWFsbHkgd2hlbiB0aGUgcGxh
dGZvcm1zDQo+Pj4gaGF2ZSBiZWVuIHJ1bm5pbmcgc3RyaWN0bHktb3JkZXJlZCBmb3Igc28gbG9u
Zy4gVGhlIFVMUHMgbmVlZA0KPj4+IHRlc3RpbmcsIGFuZCBhIGxvdCBvZiBpdC4NCj4+PiANCj4+
Pj4gV2Uga25vdyB0aGVyZSBhcmUgcGxhdGZvcm1zIHdpdGggYnJva2VuIFJPIGltcGxlbWVudGF0
aW9ucyAobGlrZQ0KPj4+PiBIYXN3ZWxsKSBidXQgdGhlIGtlcm5lbCBpcyBzdXBwb3NlZCB0byBn
bG9iYWxseSB0dXJuIG9mZiBSTyBvbiBhbGwNCj4+Pj4gdGhvc2UgY2FzZXMuIEknZCBiZSBhIGJp
dCBzdXJwcmlzZWQgaWYgd2UgZGlzY292ZXIgYW55IG1vcmUgZnJvbSB0aGlzDQo+Pj4+IHNlcmll
cy4NCj4+Pj4gT24gdGhlIG90aGVyIGhhbmQgdGhlcmUgYXJlIHBsYXRmb3JtcyB0aGF0IGdldCBo
dWdlIHNwZWVkIHVwcyBmcm9tDQo+Pj4+IHR1cm5pbmcgdGhpcyBvbiwgQU1EIGlzIG9uZSBleGFt
cGxlLCB0aGVyZSBhcmUgYSBidW5jaCBpbiB0aGUgQVJNDQo+Pj4+IHdvcmxkIHRvby4NCj4+PiAN
Cj4+PiBNeSBiZWxpZWYgaXMgdGhhdCB0aGUgYmlnZ2VzdCByaXNrIGlzIGZyb20gc2l0dWF0aW9u
cyB3aGVyZSBjb21wbGV0aW9ucw0KPj4+IGFyZSBiYXRjaGVkLCBhbmQgdGhlcmVmb3JlIHBvbGxp
bmcgaXMgdXNlZCB0byBkZXRlY3QgdGhlbSB3aXRob3V0DQo+Pj4gaW50ZXJydXB0cyAod2hpY2gg
ZXhwbGljaXRseSkuIFRoZSBSTyBwaXBlbGluZSB3aWxsIGNvbXBsZXRlbHkgcmVvcmRlcg0KPj4+
IERNQSB3cml0ZXMsIGFuZCBjb25zdW1lcnMgd2hpY2ggaW5mZXIgb3JkZXJpbmcgZnJvbSBtZW1v
cnkgY29udGVudHMgbWF5DQo+Pj4gYnJlYWsuIFRoaXMgY2FuIGV2ZW4gYXBwbHkgd2l0aGluIHRo
ZSBwcm92aWRlciBjb2RlLCB3aGljaCBtYXkgYXR0ZW1wdA0KPj4+IHRvIHBvbGwgV1IgYW5kIENR
IHN0cnVjdHVyZXMsIGFuZCBiZSB0cmlwcGVkIHVwLg0KPj4gWW91IGFyZSByZWZlcnJpbmcgc3Bl
Y2lmaWNhbGx5IHRvIFJQQy9SRE1BIGRlcGVuZGluZyBvbiBSZWNlaXZlDQo+PiBjb21wbGV0aW9u
cyB0byBndWFyYW50ZWUgdGhhdCBwcmV2aW91cyBSRE1BIFdyaXRlcyBoYXZlIGJlZW4NCj4+IHJl
dGlyZWQ/IE9yIGlzIHRoZXJlIGEgcGFydGljdWxhciBpbXBsZW1lbnRhdGlvbiBwcmFjdGljZSBp
bg0KPj4gdGhlIExpbnV4IFJQQy9SRE1BIGNvZGUgdGhhdCB3b3JyaWVzIHlvdT8NCj4gDQo+IE5v
dGhpbmcgaW4gdGhlIFJQQy9SRE1BIGNvZGUsIHdoaWNoIGlzIElNTyBjb3JyZWN0LiBUaGUgd29y
cnksIHdoaWNoDQo+IGlzIGhvcGVmdWxseSB1bmZvdW5kZWQsIGlzIHRoYXQgdGhlIFJPIHBpcGVs
aW5lIG1pZ2h0IG5vdCBoYXZlIGZsdXNoZWQNCj4gd2hlbiBhIGNvbXBsZXRpb24gaXMgcG9zdGVk
ICphZnRlciogcG9zdGluZyBhbiBpbnRlcnJ1cHQuDQo+IA0KPiBTb21ldGhpbmcgbGlrZSB0aGlz
Li4uDQo+IA0KPiBSRE1BIFdyaXRlIGFycml2ZXMNCj4gCVBDSWUgUk8gV3JpdGUgZm9yIGRhdGEN
Cj4gCVBDSWUgUk8gV3JpdGUgZm9yIGRhdGENCj4gCS4uLg0KPiBSRE1BIFdyaXRlIGFycml2ZXMN
Cj4gCVBDSWUgUk8gV3JpdGUgZm9yIGRhdGENCj4gCS4uLg0KPiBSRE1BIFNlbmQgYXJyaXZlcw0K
PiAJUENJZSBSTyBXcml0ZSBmb3IgcmVjZWl2ZSBkYXRhDQo+IAlQQ0llIFJPIFdyaXRlIGZvciBy
ZWNlaXZlIGRlc2NyaXB0b3INCg0KRG8geW91IG1lYW4gdGhlIFdyaXRlIG9mIHRoZSBDUUU/IEl0
IGhhcyB0byBiZSBTdHJvbmdseSBPcmRlcmVkIGZvciBhIGNvcnJlY3QgaW1wbGVtZW50YXRpb24u
IFRoZW4gaXQgd2lsbCBzaHVyZSBwcmlvciB3cml0dGVuIFJPIGRhdGUgaGFzIGdsb2JhbCB2aXNp
YmlsaXR5IHdoZW4gdGhlIENRRSBjYW4gYmUgb2JzZXJ2ZWQuDQoNCg0KDQo+IAlQQ0llIGludGVy
cnVwdCAoZmx1c2hlcyBSTyBwaXBlbGluZSBmb3IgYWxsIHRocmVlIG9wcyBhYm92ZSkNCg0KQmVm
b3JlIHRoZSBpbnRlcnJ1cHQsIHRoZSBIQ0Egd2lsbCB3cml0ZSB0aGUgRVFFIChFdmVudCBRdWV1
ZSBFbnRyeSkuIFRoaXMgaGFzIHRvIGJlIGEgU3Ryb25nbHkgT3JkZXJlZCB3cml0ZSB0byAicHVz
aCIgcHJpb3Igd3JpdHRlbiBDUUVzIHNvIHRoYXQgd2hlbiB0aGUgRVFFIGlzIG9ic2VydmVkLCB0
aGUgcHJpb3Igd3JpdGVzIG9mIENRRXMgaGF2ZSBnbG9iYWwgdmlzaWJpbGl0eS4NCg0KQW5kIHRo
ZSBNU0ktWCB3cml0ZSBsaWtld2lzZSwgdG8gYXZvaWQgc3B1cmlvdXMgaW50ZXJydXB0cy4NCg0K
DQoNClRoeHMsIEjDpWtvbg0KDQo+IA0KPiBSUEMvUkRNQSBwb2xscyBDUQ0KPiAJUmVhcHMgcmVj
ZWl2ZSBjb21wbGV0aW9uDQo+IA0KPiBSRE1BIFNlbmQgYXJyaXZlcw0KPiAJUENJZSBSTyBXcml0
ZSBmb3IgcmVjZWl2ZSBkYXRhDQo+IAlQQ0llIFJPIHdyaXRlIGZvciByZWNlaXZlIGRlc2NyaXB0
b3INCj4gCURvZXMgKm5vdCogaW50ZXJydXB0LCBzaW5jZSBDUSBub3QgYXJtZWQNCj4gDQo+IFJQ
Qy9SRE1BIGNvbnRpbnVlcyB0byBwb2xsIENRDQo+IAlSZWFwcyByZWNlaXZlIGNvbXBsZXRpb24N
Cj4gCVBDSWUgUk8gd3JpdGVzIG5vdCB5ZXQgZmx1c2hlZA0KPiAJUHJvY2Vzc2VzIGluY29tcGxl
dGUgaW4tbWVtb3J5IGRhdGENCj4gCUJ6enp0DQo+IA0KPiBIb3BlZnVsbHksIHRoZSBhZGFwdGVy
IHBlcmZvcm1zIGEgUENJZSBmbHVzaGluZyByZWFkLCBvciBzb21ldGhpbmcNCj4gdG8gYXZvaWQg
dGhpcyB3aGVuIGFuIGludGVycnVwdCBpcyBub3QgZ2VuZXJhdGVkLiBBbHRlcm5hdGl2ZWx5LCBJ
J20NCj4gb3Zlcmx5IHBhcmFub2lkLg0KPiANCj4gVG9tLg0KPiANCj4+PiBUaGUgTWVsbGFub3gg
YWRhcHRlciwgaXRzZWxmLCBoaXN0b3JpY2FsbHkgaGFzIHN0cmljdCBpbi1vcmRlciBETUENCj4+
PiBzZW1hbnRpY3MsIGFuZCB3aGlsZSBpdCdzIGdyZWF0IHRvIHJlbGF4IHRoYXQsIGNoYW5naW5n
IGl0IGJ5IGRlZmF1bHQNCj4+PiBmb3IgYWxsIGNvbnN1bWVycyBpcyBzb21ldGhpbmcgdG8gY29u
c2lkZXIgdmVyeSBjYXV0aW91c2x5Lg0KPj4+IA0KPj4+PiBTdGlsbCwgb2J2aW91c2x5IHBlb3Bs
ZSBzaG91bGQgdGVzdCBvbiB0aGUgcGxhdGZvcm1zIHRoZXkgaGF2ZS4NCj4+PiANCj4+PiBZZXMs
IGFuZCAidGVzdCIgYmUgdGFrZW4gc2VyaW91c2x5IHdpdGggZm9jdXMgb24gVUxQIGRhdGEgaW50
ZWdyaXR5Lg0KPj4+IFNwZWVkdXBzIHdpbGwgbWVhbiBub3RoaW5nIGlmIHRoZSBkYXRhIGlzIGV2
ZXIgZGFtYWdlZC4NCj4+IEkgYWdyZWUgdGhhdCBkYXRhIGludGVncml0eSBjb21lcyBmaXJzdC4N
Cj4+IFNpbmNlIEkgY3VycmVudGx5IGRvbid0IGhhdmUgZmFjaWxpdGllcyB0byB0ZXN0IFJPIGlu
IG15IGxhYiwgdGhlDQo+PiBjb21tdW5pdHkgd2lsbCBoYXZlIHRvIGFncmVlIG9uIGEgc2V0IG9m
IHRlc3RzIGFuZCBleHBlY3RlZCByZXN1bHRzDQo+PiB0aGF0IHNwZWNpZmljYWxseSBleGVyY2lz
ZSB0aGUgY29ybmVyIGNhc2VzIHlvdSBhcmUgY29uY2VybmVkIGFib3V0Lg0KPj4gLS0NCj4+IENo
dWNrIExldmVyDQoNCg==
