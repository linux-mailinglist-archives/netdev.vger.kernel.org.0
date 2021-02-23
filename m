Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 07D63322DE2
	for <lists+netdev@lfdr.de>; Tue, 23 Feb 2021 16:47:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233381AbhBWPrI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 23 Feb 2021 10:47:08 -0500
Received: from userp2130.oracle.com ([156.151.31.86]:47026 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233356AbhBWPqN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 23 Feb 2021 10:46:13 -0500
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NFjH7s123659;
        Tue, 23 Feb 2021 15:45:17 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=NtEUi/ZzaRq0ckwBefxzpmmUWbdZ5Kv+7+Dnxrn0dUw=;
 b=YbZIRMyh9Hv9FgskCfQkcpmmA/Pe+qx2JOOqvfTLil+BUccb7taRiCsxMxRNW362Fe2K
 OdBNhjNZoD6YrYF3NO42/oI2VKnMT0l+GC+sizImIX0D8xsiofm3j2iJDrJahBOgZssU
 FkB7KM6cBRtbT3VWZj8s3wcs2g2Y4ibpgwmipRP+Cw4eW8RZ60UwcaotUvWXd6abgIGF
 XwoPz/t+fzu6h3bMk3ZYH6OzenrVWQC/p4TJ61FhSl6XaISs44+AdOabW+WuofZH7sxl
 XUzh+k/6CzMM47tF4N2UqkKCOCk+PAt88WaRb7z3oQlDNXT+fHTdX/RiccgghkkCm215 GA== 
Received: from userp3020.oracle.com (userp3020.oracle.com [156.151.31.79])
        by userp2130.oracle.com with ESMTP id 36tsuqyufq-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:45:17 +0000
Received: from pps.filterd (userp3020.oracle.com [127.0.0.1])
        by userp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 11NFQN1q108475;
        Tue, 23 Feb 2021 15:45:17 GMT
Received: from nam12-mw2-obe.outbound.protection.outlook.com (mail-mw2nam12lp2041.outbound.protection.outlook.com [104.47.66.41])
        by userp3020.oracle.com with ESMTP id 36uc6rvweb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Tue, 23 Feb 2021 15:45:16 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Yp4q6DXoQfeoxCYn55dJw69YvA0AIkX39xELR0l+RNzZTXMtkaXzoQaHd/ohuMYIqMzPXBWEM0gCA6K+7HhBUsnuCGSISzbA6f+gJQnYd1fvdSPrjwi5EJ8YovMOPZ9mStQNy+3iY/BuT/9H4PnwC2N1mRasiieycF9XodaPF0ziiJE9iqdN7ZGAQ17Ir7vvFLWJj2FHrIz03U5nzBlvo9uftcJ/kcQqSjFDs17rRLLKJtOuAJuWYcNFAYnOavcxjmEeDck3xKYz0Ed5wWO69wEtQEP0B7Ky9S8z0S7dPhjD53dabEN+Boay8vpXINnwIWGL9uAlUx9M0ReFhBW3xA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtEUi/ZzaRq0ckwBefxzpmmUWbdZ5Kv+7+Dnxrn0dUw=;
 b=GZ8gIb1DgwBKwRA9bXs646JY1fqNco/Cq366lHdDakJ09d5aDxYIc4k6E3v4WU1VnmwX3mTy12xuQtlKiwfc/q6fEWDO8WLUrawqhEEku4ZllQ+GWzjgh4JIO204x6gHDAJSs0WIcsDWx2XLt0lDp7tOIc7aKoDOUQFSvs8bE1B0Fs5CPk4Rgyx7O2O7L4AoCP3LV1rQX4wKOtpk4QKHm/0Ax/Ky4PZVUNiHe3QqbeiL7oX53qK2D4Zha4LM1x0cvu/0Qnol8KRE5ik2M//66k6rXvBdiIJAW+X7tpsF0CBZex3/x1EeHcGCUlBldJva1wi7hKiUlkRfY9TrphQLsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=NtEUi/ZzaRq0ckwBefxzpmmUWbdZ5Kv+7+Dnxrn0dUw=;
 b=wkbxys8TDn6Zt4FD10XRKxZ7Itf1FsIRsh0RAklsIpEU1NoDFxsafzaxNLyxvy90RQypUofE6JrtpSXTrIKDzmteYY3sDKnNZYugDuVPXv0sYY+gO4NLeaRqqgQOrAjmXhyCw/XRDY+E+jNjaLcjJrHTZd/9WjPh/NWu1N8mswk=
Authentication-Results: kernel.dk; dkim=none (message not signed)
 header.d=none;kernel.dk; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3288.namprd10.prod.outlook.com (2603:10b6:a03:156::21)
 by BY5PR10MB4129.namprd10.prod.outlook.com (2603:10b6:a03:210::21) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.32; Tue, 23 Feb
 2021 15:45:05 +0000
Received: from BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721]) by BYAPR10MB3288.namprd10.prod.outlook.com
 ([fe80::f489:4e25:63e0:c721%7]) with mapi id 15.20.3868.031; Tue, 23 Feb 2021
 15:45:05 +0000
Subject: Re: [PATCH v3 0/8] xen/events: bug fixes and some diagnostic aids
To:     Juergen Gross <jgross@suse.com>, xen-devel@lists.xenproject.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        linux-block@vger.kernel.org, linux-scsi@vger.kernel.org
Cc:     Stefano Stabellini <sstabellini@kernel.org>,
        stable@vger.kernel.org, Wei Liu <wei.liu@kernel.org>,
        Paul Durrant <paul@xen.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        =?UTF-8?Q?Roger_Pau_Monn=c3=a9?= <roger.pau@citrix.com>,
        Jens Axboe <axboe@kernel.dk>
References: <20210219154030.10892-1-jgross@suse.com>
From:   Boris Ostrovsky <boris.ostrovsky@oracle.com>
Message-ID: <67b7a01c-9de5-d520-d465-e4e3954302e2@oracle.com>
Date:   Tue, 23 Feb 2021 10:44:58 -0500
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:78.0)
 Gecko/20100101 Thunderbird/78.7.1
In-Reply-To: <20210219154030.10892-1-jgross@suse.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [138.3.200.52]
X-ClientProxiedBy: SN4PR0701CA0031.namprd07.prod.outlook.com
 (2603:10b6:803:2d::34) To BYAPR10MB3288.namprd10.prod.outlook.com
 (2603:10b6:a03:156::21)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [10.74.102.180] (138.3.200.52) by SN4PR0701CA0031.namprd07.prod.outlook.com (2603:10b6:803:2d::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3868.28 via Frontend Transport; Tue, 23 Feb 2021 15:45:02 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7cb1e208-8ac8-49c3-833e-08d8d811fd63
X-MS-TrafficTypeDiagnostic: BY5PR10MB4129:
X-MS-Exchange-Transport-Forked: True
X-Microsoft-Antispam-PRVS: <BY5PR10MB412999BBC5E10E7418CFF9288A809@BY5PR10MB4129.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:5797;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: V6Eb2wugrSCpaJhdrDS7bhszSnHIg7n478K/s+yDrJmTn/QfuRwFgYOZHOTlifteaxnF1vSY0pZRL9jPNR9rXeJVLG0n5kg7cTtyzpGGwifgqUx+NF+DH2dYjZFlZLmwZ7SIHTYl7k+Ao9n5nRAHjVeyVsjN1/N1pR8N/GFKzzDpCp5jFF/H+lhUcVcqPAJYNiobF+5BDldb+tw64R8C8va5GHvEQPcHPTT5/+CTKbY2I/WYJ9NhA/F9aMTbqosPNHNuKceGXGFtwE9dKsKkeZoIctH9x6xfN1YxEXkfaojghHMrLkh5GsOlo3kBFPen5LlG2n7K4o4hJPzHsPF8dfbhXFBtXdeZCaWdw8Ujj7oveLLYIEnKwvha5UHS4aqQbOETzJq/qT3ya/13ca8IUf3fT47d6tuxmKKV86Hg4x26wqQTFR6LEw32MN7HctIIPvl/ZMVJsLqUomPF83iMpaOjTLyXSocbS+x6z0v1aWyhL654/CQjQ4Y94mc3gZ9HKOelKS8cnYOjTM4mcajTF2PruF3cE5KkCeJ78ecNtKIpyDG4QJcH3Tg3O0mNY2k5jQ7l3pp1wP2W9hx2JuB3SYXJM6uUSiysR7/mvbBrPNc=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3288.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(346002)(366004)(376002)(39860400002)(136003)(396003)(31686004)(31696002)(316002)(478600001)(2906002)(66946007)(5660300002)(53546011)(16576012)(186003)(6666004)(8936002)(6486002)(54906003)(86362001)(36756003)(26005)(7416002)(16526019)(2616005)(66476007)(66556008)(44832011)(956004)(8676002)(4326008)(83380400001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?b2JGcjVWZUZRRzhPeVRQb0pPUHQ3dEZhcHFyWU1EeFFJR1d5aGdPNWMxNXJH?=
 =?utf-8?B?QlhTVVpuNHdISVFTTitKUzZlQU54SHhZWW93TVJTLy9ZLzJqTEY3MkRncEw0?=
 =?utf-8?B?RTE2azFKcDdiKzcxbkxhUnFIKzBkQzRLdEF3TXp4aGMwSlFmSytVLzR5S2hT?=
 =?utf-8?B?KzVmcXNacTlua1BpbDMwOFhXN080L293UjBmaEwvYjFkMWt5VGhwcHJ5d0Vr?=
 =?utf-8?B?NFpCTnU0MU41Q01Qc1JQM2V0a1ZxMjUxMHR2aWpVUDhESklNbzFUVnJqa1Rm?=
 =?utf-8?B?RTJoQVM1ZEpNUlBrOGVSQ2xBNDRZMXpUSGsyeDNxSWtVSUNEUWthbkVZak9t?=
 =?utf-8?B?dWJoMTNnQVdXbDM3YURoM28rQWJtK0RPNGIrTTFaTm00UkYvblQwbUVaQWZp?=
 =?utf-8?B?djU0NU5oSTRmTDhXU0k3YVg2VGxLbFhxVjlDUWVPMVdtMlpOYlZ2VlhITXBj?=
 =?utf-8?B?UkhlcDZRTjZ6QzQ2U3FoaTIzZzhRNWh1VG50OGFEM1dmdGRYOFdxQ1JkdlJ4?=
 =?utf-8?B?cnBlSDFTTWpCOXYxRHk0a1h1UDd5Z1ZlVW1tTkRlTVBjYUJNSlFlQXJYaGxk?=
 =?utf-8?B?bjBZREJ0VjY4NnlyZU4zbkhLTG9EMnNxZUthQjJvNVc1MUNzMlhWTGxaVGxs?=
 =?utf-8?B?QlAyTTJ5dnc4M2t0WnFISlM5NksrWXl1d3U4djBXdUZQcXNFVnpZWlRuRUNR?=
 =?utf-8?B?OHJ4MjdDSVFCdG9IaDlXV0o0YTAzdUdKWFd5QmtFNW5LUE5pV2Nld0lDY09U?=
 =?utf-8?B?MGNxbzNqUEZ6OU9oejFCekVkcllOMHNZSEluNXdPaEVEcjYvZU5hTng0SFM3?=
 =?utf-8?B?YzB0RkJySzhsb2FVZmhHRkE2WWNiMkJMNGtsNWFobS9SRkVneXJ1eE94SC9l?=
 =?utf-8?B?OUVrZ2RqQm1xcXJuNEJXdXZpTkJUeVVyazB5TlF3MGRDejczMlR5WnlKNXIr?=
 =?utf-8?B?QWd4TmlWOE5UY3g3WnpROFVaQlVyVEx0d3pSWEpEMFFsNVQyUGNtUFNjV0lN?=
 =?utf-8?B?K0NmS2dsc1UwTElseml2R1ZmT3N6SHVPYjVpTWUxSnk3Z2Fja3IzaHFTSDhx?=
 =?utf-8?B?SURjVUJNalNIVEFVNjgyY1Q3SXhIM0xpVlRqV1ZYQmRDL1IyL3lZb1RJcmY0?=
 =?utf-8?B?VkFZQXZyc2pMakxzSDAxNEtVaFdablB6WTBSU24vZDgxNlVBanBoU01xUWo4?=
 =?utf-8?B?K2ROZ3FpZmMxRnhIckpsTVZRTDFFSG1yVzZaZzJZVkI2YkxPZlI4MjVFSVVE?=
 =?utf-8?B?bHI2VWhyclFuL3lPckJzMklES2hzdktnK1gveDJHOHlOSmtQWkJvR3kxSjlN?=
 =?utf-8?B?RzNHVXc4U3BvNENQWm1GaFVTWkp4WWZPU21NSzkrZjB0S0t3Z0lMaG9lNXFM?=
 =?utf-8?B?elRwQ1lEancvTjNkd0REU1U1Q2tIcTVrWWtBaURmZnVHa1Y0NS9KZWNteVRy?=
 =?utf-8?B?MEhiTWdXR1ZlQUJabjVXc0lCVEpYWjU3VFNlWkhoR2NLWEdESE9rVC9lM3Rt?=
 =?utf-8?B?ZUl0a1k0dm8yTVR0UE05bGp5TzBwNjU1R2g4clVubU03Ni9iTFZmS1lRL1J3?=
 =?utf-8?B?R0o0YktLalZrSHZlV0JiOTdKdzRLMnkyZDZaL0MxU0txdFJyYkNnLzBZMFhw?=
 =?utf-8?B?NlorNGRCaXRQVUFpQkdRaWpnQjQzQzQzSzhPZ01WcW56RVRTZWlndEhIRG9B?=
 =?utf-8?B?R2grWmljTlhxU0tnd2dBUkgyUWdqSVI3a3ExUHRHSERTMDB5ODM2SUZNVmlr?=
 =?utf-8?Q?8NtCBQedf8dDWzYL1fpF1PEe6S6e0zef30h/LLE?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7cb1e208-8ac8-49c3-833e-08d8d811fd63
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3288.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 23 Feb 2021 15:45:05.5493
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: fJFnGFw6Fzg0uuIts7hqMA+aPOoaI5fHd2m6wskw/EYB5UyL7tmmWqlTu9lrBpO+ZJAaPxHkxML9o9SikE0fT9Et7ZKr4BGIPNhH1sWiNGA=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4129
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 mlxscore=0 spamscore=0
 mlxlogscore=999 adultscore=0 bulkscore=0 malwarescore=0 phishscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230131
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9903 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 spamscore=0
 priorityscore=1501 impostorscore=0 bulkscore=0 mlxscore=0 malwarescore=0
 clxscore=1011 phishscore=0 mlxlogscore=999 lowpriorityscore=0 adultscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2102230132
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 2/19/21 10:40 AM, Juergen Gross wrote:
> The first four patches are fixes for XSA-332. The avoid WARN splats
> and a performance issue with interdomain events.
>
> Patches 5 and 6 are some additions to event handling in order to add
> some per pv-device statistics to sysfs and the ability to have a per
> backend device spurious event delay control.
>
> Patches 7 and 8 are minor fixes I had lying around.
>
> Juergen Gross (8):
>   xen/events: reset affinity of 2-level event when tearing it down
>   xen/events: don't unmask an event channel when an eoi is pending
>   xen/events: avoid handling the same event on two cpus at the same time
>   xen/netback: fix spurious event detection for common event case
>   xen/events: link interdomain events to associated xenbus device
>   xen/events: add per-xenbus device event statistics and settings
>   xen/evtchn: use smp barriers for user event ring
>   xen/evtchn: use READ/WRITE_ONCE() for accessing ring indices
>

I am going to pick up the last 3 patches since Ross appears to be having some issues with #2 (and 4 and 5 went in via netdev tree)


-boris

