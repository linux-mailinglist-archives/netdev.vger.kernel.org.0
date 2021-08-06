Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B51C13E220C
	for <lists+netdev@lfdr.de>; Fri,  6 Aug 2021 05:05:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240983AbhHFDFl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 23:05:41 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:54992 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231679AbhHFDFj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 23:05:39 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 1762v4qt023067;
        Fri, 6 Aug 2021 03:04:37 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2021-07-09;
 bh=RFlk/4n9YjHv95qLTUAeUlBQHaWHNmXOvqmaDpogwLw=;
 b=pAlNtAhKRYrHUjBpk1NgIXH11dikoxJrLh5SjbvHCGiRTlkYbheFPVTU/OtLmg7/RLC3
 IryDgTEb9ej+1/KUH4pok10wDxhzDOPMJd0c9yqG5DS+fpAfQthykMg3IAXaojZd7CeX
 maEs2LTb+AaRlVfVEYnQTqPxdjSewscnZn/hJ9ZgehdxLrWn3E1oqRel9xQXmKIURrrz
 Dht/COsbD55rhl5EZbjpFwLgc04h/t2w5czBe8Ztgo4UeRIFAZOQ1SlPaSodDtSXAv+N
 h40XtujdR1RlflP+5cu/i67VnONxGgTwGIMcrLOcf9oRsCmG/PA1XleRUbNUJ/vQ0rfE iA== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=to : cc : subject :
 from : message-id : references : date : in-reply-to : content-type :
 mime-version; s=corp-2020-01-29;
 bh=RFlk/4n9YjHv95qLTUAeUlBQHaWHNmXOvqmaDpogwLw=;
 b=oCoLEYYsadmfblU7qfxCoadphrD+7Nh9Mf3vXSIbADhyDt8mOmmuUhBiuafkkHLex0YO
 HTWl+h+xh/5fv8fA32FSbPq5CCd8VW4OPTC3dD3VXipEwiMt8FizWbjbBhcFx97m23uz
 QFtGWJfz3PewYmNP1xTnhLJVjgbwExqsTm059NrH6ZprpyxvE6LfMCSXwOiXg0ij4S+G
 4OrGK8XM/1wLpo3mNRmsqbsunL6YUhpxOrtJxQVIXM169Hky7fAPiPEIYJH9gZHb3ick
 jVh/T4pOuG83MAbjOZopiUO8z5Otk6JwkqIMsrr4fKtme90a+kqhqVLHpkT42v2KUzDn gQ== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by mx0b-00069f02.pphosted.com with ESMTP id 3a7hxpnk32-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:04:37 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 1762u7I0100016;
        Fri, 6 Aug 2021 03:04:36 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2040.outbound.protection.outlook.com [104.47.66.40])
        by aserp3020.oracle.com with ESMTP id 3a7r4aurk4-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 06 Aug 2021 03:04:36 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=bVXPEHJNNE1hd+ucT6z4Yet5ozzsfqulACOH4gO4ob5nE3PF2jer+gtFb9c2QWy1IAA1Qf6gu6h9516m3Rgtjk1prel38Rhvww1ikq8gKEPTQl1fhFKrcKTeR5zHuUWrgy2PFAZ83CLDEWjmviKaloBNDzdT2Q5lj+gdx/EYyJOFLngX8c7x+4UDzLAQTzxECy83UFlcU6Pwu46D8YvGk7UX8oIk0q8L/n2EjJGXKB8M6sMTyJFtfED+APbTOKdubH2dPJjOKTC7pgHJCbmVPueDLUq+1rsXEdoXplw1NT55ruTaXA40vvnOIEt0osyQjKuivKG+V+kSUrkpa8qneg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFlk/4n9YjHv95qLTUAeUlBQHaWHNmXOvqmaDpogwLw=;
 b=SS4HylG6Wm5od4SgT4xfQ8Kaa+Mh+21pJP5Hwb93bE6s4RDhhLEPgetMKrqOGQEocMLB6J4trmO6oLgsUC5xbvekwVFEtmvmvrl1VruhGnJQL38sn+eq01o3+Nw4qrMGrNhOe+M/mVjqWMUOrH0H0szJkePQfxptOj6JuT4PWZh73Qi0f0xd/i7sElwuFY2G06Fx6uFmR2/Ew49Fa+H8G518BmHgbUkBiApRx9Pat1147P3IdHr8zkpM88OrvsbNe7FDgwOgkL3raIrlLAlp12ASp0msu0FBTxjTwoHDy9VSYmQW2B1agSjUcwavWGwcFGooWv8JnzlxeQGxSC1b8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=RFlk/4n9YjHv95qLTUAeUlBQHaWHNmXOvqmaDpogwLw=;
 b=OyKPcLBcL232lVdrDMT9DP2kCcJ7bMjBwhHBwb01+/X3qsMfxFcn5PuTCkJ4L+b+3LrKB7HgxF6tdr6H+gRRIfQZGEg3jHT/Dd5k6g0B38k4oTFtC2lxW8JVcKanF71VdAFbO3JYqDVZ6vNQH232XuJTQSVmN97UYEDvon3k3SA=
Authentication-Results: redhat.com; dkim=none (message not signed)
 header.d=none;redhat.com; dmarc=none action=none header.from=oracle.com;
Received: from PH0PR10MB4759.namprd10.prod.outlook.com (2603:10b6:510:3d::12)
 by PH0PR10MB4648.namprd10.prod.outlook.com (2603:10b6:510:30::5) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4373.24; Fri, 6 Aug
 2021 03:04:33 +0000
Received: from PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1]) by PH0PR10MB4759.namprd10.prod.outlook.com
 ([fe80::153e:22d1:d177:d4f1%8]) with mapi id 15.20.4373.026; Fri, 6 Aug 2021
 03:04:32 +0000
To:     Nitesh Lal <nilal@redhat.com>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org, jassisinghbrar@gmail.com,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Tushar.Khandelwal@arm.com, manivannan.sadhasivam@linaro.org,
        lewis.hanly@microchip.com, ley.foon.tan@intel.com,
        kabel@kernel.org, huangguangbin2@huawei.com, davem@davemloft.net,
        benve@cisco.com, govind@gmx.com, kashyap.desai@broadcom.com,
        Sumit Saxena <sumit.saxena@broadcom.com>,
        shivasharan.srikanteshwara@broadcom.com,
        sathya.prakash@broadcom.com,
        Sreekanth Reddy <sreekanth.reddy@broadcom.com>,
        suganath-prabu.subramani@broadcom.com, ajit.khaparde@broadcom.com,
        sriharsha.basavapatna@broadcom.com, somnath.kotur@broadcom.com,
        linux-pci@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        rostedt@goodmis.org, Marc Zyngier <maz@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Robin Murphy <robin.murphy@arm.com>,
        Marcelo Tosatti <mtosatti@redhat.com>,
        Ingo Molnar <mingo@kernel.org>, jbrandeb@kernel.org,
        Frederic Weisbecker <frederic@kernel.org>,
        Juri Lelli <juri.lelli@redhat.com>,
        Alex Belits <abelits@marvell.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        akpm@linuxfoundation.org, sfr@canb.auug.org.au,
        stephen@networkplumber.org, rppt@linux.vnet.ibm.com,
        chris.friesen@windriver.com, Neil Horman <nhorman@tuxdriver.com>,
        pjwaskiewicz@gmail.com, Stefan Assmann <sassmann@redhat.com>,
        Tomas Henzl <thenzl@redhat.com>, james.smart@broadcom.com,
        Dick Kennedy <dick.kennedy@broadcom.com>,
        Ken Cox <jkc@redhat.com>, faisal.latif@intel.com,
        shiraz.saleem@intel.com, tariqt@nvidia.com,
        Alaa Hleihel <ahleihel@redhat.com>,
        Kamal Heib <kheib@redhat.com>, borisp@nvidia.com,
        saeedm@nvidia.com,
        "Nikolova, Tatyana E" <tatyana.e.nikolova@intel.com>,
        "Ismail, Mustafa" <mustafa.ismail@intel.com>,
        Al Stone <ahs3@redhat.com>,
        Leon Romanovsky <leonro@nvidia.com>,
        Chandrakanth Patil <chandrakanth.patil@broadcom.com>,
        bjorn.andersson@linaro.org, chunkuang.hu@kernel.org,
        yongqiang.niu@mediatek.com, baolin.wang7@gmail.com,
        Petr Oros <poros@redhat.com>, Ming Lei <minlei@redhat.com>,
        Ewan Milne <emilne@redhat.com>, jejb@linux.ibm.com,
        martin.petersen@oracle.com, Jakub Kicinski <kuba@kernel.org>
Subject: Re: [PATCH v5 00/14] genirq: Cleanup the abuse of
 irq_set_affinity_hint()
From:   "Martin K. Petersen" <martin.petersen@oracle.com>
Organization: Oracle Corporation
Message-ID: <yq11r77gtq0.fsf@ca-mkp.ca.oracle.com>
References: <20210720232624.1493424-1-nitesh@redhat.com>
        <CAFki+LkNzk0ajUeuBnJZ6mp1kxB0+zZf60tw1Vfq+nPy-bvftQ@mail.gmail.com>
Date:   Thu, 05 Aug 2021 23:04:28 -0400
In-Reply-To: <CAFki+LkNzk0ajUeuBnJZ6mp1kxB0+zZf60tw1Vfq+nPy-bvftQ@mail.gmail.com>
        (Nitesh Lal's message of "Mon, 2 Aug 2021 11:26:39 -0400")
Content-Type: text/plain
X-ClientProxiedBy: SA0PR12CA0012.namprd12.prod.outlook.com
 (2603:10b6:806:6f::17) To PH0PR10MB4759.namprd10.prod.outlook.com
 (2603:10b6:510:3d::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from ca-mkp.ca.oracle.com (138.3.200.58) by SA0PR12CA0012.namprd12.prod.outlook.com (2603:10b6:806:6f::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Fri, 6 Aug 2021 03:04:31 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: ab48ed34-4aa0-410c-84e6-08d95886ea06
X-MS-TrafficTypeDiagnostic: PH0PR10MB4648:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <PH0PR10MB4648AC32D0D6969750ECA7428EF39@PH0PR10MB4648.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:6430;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: K+wo+KFhAWE3OISkkQDhNnMBFJScsoGUC1EqMNowmp6M9Hnsrksqcw22AfmZzmOq0faAr4aGF0zcUtll6blLzKPX+l7Q1/1KIwCNzDkVaZywv7Iwh1PpwOf9Ht501DW/xjpKAqlUcsBT7RuNY0O0Z9KTfhdxbRTX79WVmdbXfk34nrWNS6g+erpDoArLj7ibJRfA2QUPhrZ20294X6VH0iV6aSNa45FODwOYSV0Y6Lqr8sOPPtYeTPeGfW3XBJFEKccVWdOnBAAN8lZncK070kOfggSWB4LRBXUoje2Sr8PrmZ8kplC5cco+qz+s+kRlqb221c2+b8KTkt93RBvYi9O0F9+EPKvZarAaMhZxDyLq7rJxYiERS5CAZFt9p+m+zCCfW3Z14izTonXeK509+AnKMkPpmLISPNuYZqeWZE7zlwRYyr1lkthJrylknHKhX+rbStHsLQKWF46lcicbmHAaDcaqZ5pXBfide4WNkHW6xjeMN6qpN42+jg5UNnfkWOL5dXbkHUKSzjbXbpYHZOtcQ0gKADIbPOTHbodsmkuI+UkL8vFp/+fyF41UFxFToO6N4mXd8QgeLqKuBzYrS8mVn4jBCswYM9kDcegAU74Y9INWNk9j+XK5xCddVEMbQGfh4PhMUJCVXNAwu/pvCA+OABLnCc3DO17RE9BD5y1CcaIQvGjTJdMDAiFaT44jHVQPTADNYmX8gBiwFeo2EQ==
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:PH0PR10MB4759.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(136003)(346002)(396003)(39860400002)(366004)(5660300002)(55016002)(186003)(86362001)(558084003)(478600001)(956004)(8676002)(316002)(54906003)(66476007)(66556008)(66946007)(7406005)(7696005)(36916002)(38100700002)(4326008)(6666004)(7416002)(6916009)(7366002)(8936002)(38350700002)(26005)(2906002)(52116002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?us-ascii?Q?S5mdj/itJrqcM8RrZ74MjLcPjYmbfrb0igFGwFgOy9EXbq5FeTRKXCikGUFA?=
 =?us-ascii?Q?eVFIq8DUVqMAWxM80oAG69NrtDJUVIHDsVE03HtR6V/AZoo9ara4ElAQbO45?=
 =?us-ascii?Q?PVGPRy/CnfyWhhjru/cHfBCkqEjBFnq6PJNvfXgqbk+YacddLWBz2cObu50l?=
 =?us-ascii?Q?1CfaN1MsijD8vxG4uYXnhSFhPee717fRhbQd41F8bZVm0pg6H0J19VRSUG4e?=
 =?us-ascii?Q?h6EpcFipnZCV/WO75KyIC0KeK0mARNqEZ5Sbvv0fyQAIaDECvhRFDTbcYMpU?=
 =?us-ascii?Q?BiDOQ13uyk6RuJi/dyBaWsiY5RO0GOH7KLUjWhocaE/0hcQeGMkYqUushnNl?=
 =?us-ascii?Q?lGWhm4ozBpziAJ/cr+lIt1vqD/445HmJUbnfmRIeJ7RIy88MenBXygSaAXXz?=
 =?us-ascii?Q?lewj0tZzfbs4Q8laMfhB/n1WB6Cg1PEElEzmo0HHPwybaXuy77ikgCzv+MXM?=
 =?us-ascii?Q?cnAKvx9NndV5NDmtKOyuODcjF8S789ny4LElYBV1S/1DKJWO050yMEq4J3TA?=
 =?us-ascii?Q?w2jwk3F384Xp9TS2LtLAYA3r3A/piMbWAa13wGZXIn9m+p5nloT6VT3Vcxv/?=
 =?us-ascii?Q?o4bvUUoFDliYYPlDUZw8p1t4rpEa7Lz4X+iEudp+4vuxtuPHbJEyxn/qeAMm?=
 =?us-ascii?Q?hg1Llaaur6hj4cMPdL5rxc88uYwilfd5m8TdobRUp97MssFySqkbUAUmPB5g?=
 =?us-ascii?Q?432eO4LLI5ZJQ0gfNQ3B8YeL53qcVeSXs6CO79BRd0tB9WMQNpvCRHrdNTR7?=
 =?us-ascii?Q?q5riBiqREv9+UKk1mhvp7/9ReCxtj09LHyyPrk/Pj7AU0GN1sFf60hG88Xc5?=
 =?us-ascii?Q?MH2A0zlQ22FiwMFqtpDDUkiBI0AQKCER1YhQaACsYqjEqnYlOoT1T1clvnei?=
 =?us-ascii?Q?y7dXaK/vNoWod+1lQ/yX2ruqX5h4+tpJjq1dx7WmE6YsADE5Gh2+fLydAqMV?=
 =?us-ascii?Q?bikdLIPyEl2OGQ+id+DdHWwgVMgI4nbFsm4fUFdKDJfYkfqjGDLKpezB4Giv?=
 =?us-ascii?Q?cmV5O3+6+O4/NvoG9gnqndvCoebF7gb4IL/rP27M2DIE89Nwo5gb/S+11SAt?=
 =?us-ascii?Q?hyofjPj8TP40KgkcwowHRuZt04i6pDPr6um5Gqlm7yVth1gSRIO5JhmgDBnN?=
 =?us-ascii?Q?vN/rBTyW3OMs8it1Zd9MUOqqxkfoDRFctfmVQlLpWlh+a6Wj9nDyQsJvw0Tf?=
 =?us-ascii?Q?6lpaHzDrvGnBZdBvtUmoa+3a1MZaoKJTgYgdMK5dqyPskuk0YgyoyPDdMO72?=
 =?us-ascii?Q?PY2DdhzidEg6/h4TrmLdZ94VtPdxGRzWsHAT6tolWFJPjSD0nzgFA6N6VUW1?=
 =?us-ascii?Q?DTfgqE8Cbqc+Gq/k778JtHv6?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: ab48ed34-4aa0-410c-84e6-08d95886ea06
X-MS-Exchange-CrossTenant-AuthSource: PH0PR10MB4759.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 06 Aug 2021 03:04:32.7760
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 7vXuWf/Fegg79HMRDXXgirViFLIUu7RUDt+igoKM3+jOLb4gLKZsWDvkbfdiVAnfhfRkU1WfQmR8cmdNeIWN2TqQMprFxkEOu0fqxhAo9sU=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: PH0PR10MB4648
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10067 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 malwarescore=0 adultscore=0
 suspectscore=0 mlxlogscore=999 phishscore=0 spamscore=0 mlxscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2107140000
 definitions=main-2108060016
X-Proofpoint-GUID: Ct0jbMyeE6PnI9tLBopNWGxgARRVhlyX
X-Proofpoint-ORIG-GUID: Ct0jbMyeE6PnI9tLBopNWGxgARRVhlyX
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


Nitesh,

> Gentle ping.
> Any comments on the following patches:
>
>   scsi: megaraid_sas: Use irq_set_affinity_and_hint
>   scsi: mpt3sas: Use irq_set_affinity_and_hint

Sumit and Sreekanth: Please review.

Thanks!

-- 
Martin K. Petersen	Oracle Linux Engineering
