Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D84053C6F1B
	for <lists+netdev@lfdr.de>; Tue, 13 Jul 2021 13:03:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235804AbhGMLGQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 13 Jul 2021 07:06:16 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:12380 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S229784AbhGMLGP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 13 Jul 2021 07:06:15 -0400
Received: from pps.filterd (m0246627.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 16DB1Qvx007979;
        Tue, 13 Jul 2021 11:02:46 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=date : from : to : cc
 : subject : message-id : references : content-type : in-reply-to :
 mime-version; s=corp-2020-01-29;
 bh=bJjYanza1S94svd51N3qTB5JtzOYaZZJ17wynlJ79pY=;
 b=zH1fyTFGq6F7TV0dZQsDZmG7PLx6w+F79mxiqymAWv5WvnbZminL/KtweL5OZ1asQeG9
 fr7Pf+PaZryMCoyqSmyrJ3NNv3XdxypeJyiRHIoXd35IkVRdAPc2YJBZ9gFxIgH5GY41
 Kwpj8JbSlbdyB9TQ6VGcl+K2f+xbKXdEki/ofRg6zxkTXkhyBamhT+AooLBe6Ell0Amk
 OfXANXFe9XsC8zefyboDX49DQm/uUU++BKIYg4mrg14r1WZsObodll0UQjnxulGQazNj
 qSZvHqJ42SNN90zA3t4VRhCSGu9gcB74ZG/J3p2I6J4kikGDhheS9oDxvJKpB5zH/AU4 7Q== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 39r9hckb9n-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 11:02:45 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 16DAsfLe140212;
        Tue, 13 Jul 2021 11:02:44 GMT
Received: from nam12-dm6-obe.outbound.protection.outlook.com (mail-dm6nam12lp2172.outbound.protection.outlook.com [104.47.59.172])
        by aserp3020.oracle.com with ESMTP id 39q3cas8qc-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 13 Jul 2021 11:02:44 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=JxFqVzQUJVmeYxsJHe7j0XS9EusKlvb2s53l3S20rDpcWiAfPfY1bahr5fv/BiCZCSW2nXmhUGp7AZXZaAKktnumAMaFOX1UNh0qVVuqW/KAH/Cp1OCJjb00+QdEdAwjVPxPPremkYW9zTd685JSazlHBtUm5XddqnlBtgf8CBX0jI/OniUEBcfqcBnmEl6gKc2sKKmQVQd4mWX9cDx07VHjjCePGgTU98Gkae0f58NrEqJ+NGfCEdT2nbyxVt3LxGuIMjDOvDH2cuJcfTxXgXz0bHKX9+KTeE1WQbc7fAg8ysZUG5IGVBLIQsaRjBlb+/X6XhvTkbfGiatRWzm+Qw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJjYanza1S94svd51N3qTB5JtzOYaZZJ17wynlJ79pY=;
 b=dBbHUf7ieShb2GSGLTmImPIxvaioM7MzDDzZGyX+b8oppNvO27tgplELmYKJZJ1ruKHb1BBE7sJIpvBHchUBu1Q3yAHzl8DS+/b6Z0CnbM+UNLfxThaVryfanQrr/8DbSz3QtbAZXnh48641s3o/vfH1A+y1QaTIpo3p703bokirOB83S0Dalr4DyeU+jBDhn98eMyNwqyU1T5d4sUj9ROTS8eMGIGhlduET4P8YALeRBya9XJLvl13oca8Ow+Xf3tJuBjUI1sFMDZMASyKmK/PvpOVn+md0tOA1T5K0dKyT99uAwMhLL+VLiQ1dFXOFoaxRwoX3GIb/BcDLQOQlEQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=bJjYanza1S94svd51N3qTB5JtzOYaZZJ17wynlJ79pY=;
 b=mj84pwQEKcharaCiHQD0nItI2ZMd1yjs+B8gJJnKQC19FCWX2wjpOmy7vzrfHiVRYjKN6dc/smzCVH5Ju7hZK+pjnxwCpxIhscTjCRGvE50/KhmJZxqOTOck8nmow31MH1C96dHcWgFMAPDE87NQsSqSNm1p6J1TtKKHYOhx8G0=
Authentication-Results: bytedance.com; dkim=none (message not signed)
 header.d=none;bytedance.com; dmarc=none action=none header.from=oracle.com;
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 (2603:10b6:301:2d::28) by CO1PR10MB4706.namprd10.prod.outlook.com
 (2603:10b6:303:9d::11) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.20; Tue, 13 Jul
 2021 11:02:42 +0000
Received: from MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73]) by MWHPR1001MB2365.namprd10.prod.outlook.com
 ([fe80::3413:3c61:5067:ba73%5]) with mapi id 15.20.4308.027; Tue, 13 Jul 2021
 11:02:42 +0000
Date:   Tue, 13 Jul 2021 14:02:11 +0300
From:   Dan Carpenter <dan.carpenter@oracle.com>
To:     Xie Yongji <xieyongji@bytedance.com>
Cc:     mst@redhat.com, jasowang@redhat.com, stefanha@redhat.com,
        sgarzare@redhat.com, parav@nvidia.com, hch@infradead.org,
        christian.brauner@canonical.com, rdunlap@infradead.org,
        willy@infradead.org, viro@zeniv.linux.org.uk, axboe@kernel.dk,
        bcrl@kvack.org, corbet@lwn.net, mika.penttila@nextfour.com,
        joro@8bytes.org, gregkh@linuxfoundation.org, zhe.he@windriver.com,
        xiaodong.liu@intel.com, songmuchun@bytedance.com,
        virtualization@lists.linux-foundation.org, netdev@vger.kernel.org,
        kvm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        iommu@lists.linux-foundation.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v9 07/17] virtio: Don't set FAILED status bit on device
 index allocation failure
Message-ID: <20210713110211.GK1954@kadam>
References: <20210713084656.232-1-xieyongji@bytedance.com>
 <20210713084656.232-8-xieyongji@bytedance.com>
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210713084656.232-8-xieyongji@bytedance.com>
User-Agent: Mutt/1.9.4 (2018-02-28)
X-ClientProxiedBy: JN2P275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::30)
 To MWHPR1001MB2365.namprd10.prod.outlook.com (2603:10b6:301:2d::28)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from kadam (102.222.70.252) by JN2P275CA0018.ZAFP275.PROD.OUTLOOK.COM (2603:1086:0:3::30) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4308.19 via Frontend Transport; Tue, 13 Jul 2021 11:02:27 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ea0f191e-4339-4e89-4adf-08d945edbc55
X-MS-TrafficTypeDiagnostic: CO1PR10MB4706:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <CO1PR10MB4706A0B2FFFE16DE7AD48D3C8E149@CO1PR10MB4706.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:1728;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: rpdNG6Y+TZgpyuFZA7SVbUDQheP54Pam3v1gDqisOyRoU9EDqfPKzZEw209umAW+FJOSeuDjm2MgGq0BRc4py8uoBTBrutu384grdYgid2RI7sUOWv9Q4/43oKoo4oj0NIFlTuaSS1Q7vStWelr5pOsvNESB3GA3n/0vVRDWU28+PBCy6FP7MGAuKH8RUZJ4riQyUmKaEaEObReMT+/iIjAomKqW8OE8W4K0Epf9EZDVgDFGpJDwPOYUEqJxLdSKeBz4Urm9d7JvaaMpq5FNsQdJGE91Inx3gXvtmstG7v3Ybq9EJ32708XjjOtggKrO600Lj8DUBmdc1aeTa9o9w93366pDbbfszin5nVwpjqqrkEMsdFFuiJ0kZY6Lijhh1BP/32LxsXwobxVtLQWDH2yqHgZLBrY9RQ6QhuU1cnyvkEBgzdC2Z4xFpmnDnH6JYAZbFhgxkW0f5u8slLvVCMjMlTwr6xTps/XTgjGG/3sW3GTsw0UonsBUlzf+hR6qUt6B18moGkWa0MTbiHcb/ukuV4ADBufonPPTwnJivPKqCdTOMvdFD37b2ukaIoc0aTE1fUf3uf7ge3ainhI1IvgDgcnSeYTtJNnZu227AXy5JEy6JEPWQICYUEibct8LHNdK7iZjtAvzBkZO3VfmCLVcjst3cIySlZUV61G0gnO48ZBCObE7hfq1apm7H7FjvGemJxTHVP2Au5NtY2GnEQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:MWHPR1001MB2365.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(366004)(39860400002)(396003)(346002)(86362001)(6496006)(316002)(55016002)(66476007)(4326008)(33716001)(66946007)(1076003)(44832011)(66556008)(6916009)(83380400001)(52116002)(5660300002)(26005)(33656002)(38350700002)(8676002)(186003)(478600001)(6666004)(8936002)(956004)(38100700002)(9576002)(4744005)(7416002)(9686003)(2906002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?WboQdJFAps6YvlryAunlFrzyZD0UU79y8FhIPmZr7Ah8/9fAioLTAMIbl9Kr?=
 =?us-ascii?Q?6Fk8A2nH5Hjpi7ZxnOD3FHFosd9SO2Vqa3mwmN+Ckdqj/0s6JHEkKpcmbWR1?=
 =?us-ascii?Q?h24Tgf0VO+p+IP2+qz/+zI6UHGyiiMXgAXwuvNJOpfTD5zyS6dE86KNlsXt/?=
 =?us-ascii?Q?GdLnrN2YyW9AfwmnoTmApeS322qlDLfVcEQWhi55engwZl40jfOs+upycPrM?=
 =?us-ascii?Q?yySZdZe3EIwtwtk83rJuvOmFT2nTZXbLKp5Lspy5iFBA40n7/xIHpD0jSA+L?=
 =?us-ascii?Q?gR5/JIOMaXJK2yYHOO4DN142GzSad8fe2AoJadhAdw5Ty/9PRIH8in+s4esz?=
 =?us-ascii?Q?lg9QODu3TeVEiXkQ6UW0xkJ8KbLYXxT1IIrcZqe6fxgabwBwrcQlL6WmG5tv?=
 =?us-ascii?Q?WDERjZeyC9SPBcsIUl85db3x4buGRWXCAb0rV1w9I8otWA12qm2yLTxlqLo+?=
 =?us-ascii?Q?ONbLBl260bZnu8cQf7ONSLYN72mWn6/S8HJ9d1P4tqfkvaK44Q3+RSMwPzk0?=
 =?us-ascii?Q?V9Ix8KWPrUdodNfjfCOgJRwCz0wCbeco+ND1YrUzOOoFZyB+1vteoA/cYacU?=
 =?us-ascii?Q?ozmkh3EORNcGKxplck1zq16wZZb3Oscxv2qZUKTjY1/81qXZ1t7IcBcjSfvZ?=
 =?us-ascii?Q?1D6gfZn1zs76r8qCjYHOZuOE5v6p+7YuTHGXSpZSadQ2JYo7m6L7iHhTLiaF?=
 =?us-ascii?Q?QHK+RRfN712z8fbxtJfI75dFAmMlIPyoLdHHe3IUvpWH7jrYlVjsCbDETo7h?=
 =?us-ascii?Q?FSNKNkw7lgoE7CwPxTlCQRkRRZ50gb/z3d4r2hJAP4x+0j82CTEDT+nsfVOX?=
 =?us-ascii?Q?jrLWTOWkaaGOiv5L6bPCz74DnrN1A91pas/Cj5bups6GyXNyI13+Rb3aUm3f?=
 =?us-ascii?Q?y6kidH8sB/jsxu7lXbsXfuPcMg7avE5OyfingsZkq55k5bR5WkatVmn4t4Ya?=
 =?us-ascii?Q?4jdndSftT2TMmDg8MS73GVs5othSWLK2BVD6SkUg701xzEozt/KntdSlJZAK?=
 =?us-ascii?Q?0PbRzC1jRM7ZnW/vRnNkOvs4i6/5YbH3dS1wtPjZg9FnOvchLBDnW0xT7nb5?=
 =?us-ascii?Q?/MwuGe+TEqKoRPaL2IdaITSIlP98xRl6+CpZt9kJfMXEAjTIQZwJ5qPrqHlS?=
 =?us-ascii?Q?2UHTq4WAOpvqVK+zo+6lM3nkGwdKdRSkllV7hyTaF1eVzGASUZK2FnLY04UT?=
 =?us-ascii?Q?zepItgOH8EC+wMfcLDF8Bw6s2gg21DAI2lnl/icYUaAwoeza3E1rwIbIOUO5?=
 =?us-ascii?Q?0a5FgWz20gwttJUGteKEhfTmIMaZfgptHEdCOlGbrVnfVKPEJ1PWDZUyEhmi?=
 =?us-ascii?Q?xy306PM8XOFuqohYG/BF5bEa?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ea0f191e-4339-4e89-4adf-08d945edbc55
X-MS-Exchange-CrossTenant-AuthSource: MWHPR1001MB2365.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 13 Jul 2021 11:02:42.1126
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: XpJCTAcd9jqhz8kFdygfGjEpvo5kDivkdYwPBDtzGykHuiTSw+z6+Rcgw+KBgEj9LDIiQ05qPQ9+GieqHclmHENvIPPo/BP7FtuxH5dfl5I=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: CO1PR10MB4706
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10043 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 spamscore=0 malwarescore=0 mlxscore=0
 suspectscore=0 phishscore=0 adultscore=0 mlxlogscore=999 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2107130070
X-Proofpoint-ORIG-GUID: DFUk50LmBfb8Xb2NUJqW4oISIaKeSfxW
X-Proofpoint-GUID: DFUk50LmBfb8Xb2NUJqW4oISIaKeSfxW
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 13, 2021 at 04:46:46PM +0800, Xie Yongji wrote:
> We don't need to set FAILED status bit on device index allocation
> failure since the device initialization hasn't been started yet.

The commit message should say what the effect of this change is to the
user.  Is this a bugfix?  Will it have any effect on runtime at all?

To me, hearing your thoughts on this is valuable even if you have to
guess.  "I noticed this mistake during review and I don't think it will
affect runtime."

regards,
dan carpenter

