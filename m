Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 476AB3E4DE5
	for <lists+netdev@lfdr.de>; Mon,  9 Aug 2021 22:34:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236279AbhHIUeR (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Aug 2021 16:34:17 -0400
Received: from mx0a-00069f02.pphosted.com ([205.220.165.32]:35638 "EHLO
        mx0a-00069f02.pphosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S233281AbhHIUeP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Aug 2021 16:34:15 -0400
Received: from pps.filterd (m0246617.ppops.net [127.0.0.1])
        by mx0b-00069f02.pphosted.com (8.16.0.43/8.16.0.43) with SMTP id 179KTelM010101;
        Mon, 9 Aug 2021 20:31:32 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2021-07-09;
 bh=IRLHK+tLMSk4HMPU+gMIGAXwL91AIEJk4rXe2EXW15g=;
 b=GFrOTFjHJ88H60v+SDOVp5JxpkKbsnYflmeDdDY5JvfSwkH2NJW9ltVe7YxT2wAlC0Ps
 gYB0Jp2vJD0nhV/ysl90AQ6IFJyxOuRAWJlfjRYnCq9D+BKFGBWeqFczll/f6xhGFsR7
 zHA9AVzNIeWPZqZepOg/+oWsQC1ZdPNw8aH3fs2BcG4Nl3oaX/04e7aBQRR2UKTubXE+
 8yE9lCWcQwK4sRVwCQ/7qo0xy9TphWZF7Jh1GsND9ZjDY5M0qZcK4ustk1m/85sj9768
 w21FylHjRvbL0wYbykhf+ENCcPQznnNgtV//+0OSc83ckicpqze0qFQgPJBy05kgtLOC qw== 
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=IRLHK+tLMSk4HMPU+gMIGAXwL91AIEJk4rXe2EXW15g=;
 b=eklL7MP5JEHkUiDtEmNNbQ0NIHuSWl5IuzIoCk14vdax2yGbsxj/ynUvidBKqUXkiFZH
 Pk46k4cDxKlIZmtt9guLQRuCH5a1ezxoE0sZC10oJHsVtf0p7AhaegDjscu7tAS4MMQI
 bZ3OEgeyuAlDfR0qoyK6sPBZL4oOBDAcUW7y0RHtdCmUPvzHVIWB4+hHt7aSWo5CxMqB
 nbVV9dFuEDRpQowv3xqBxjUzs8LuKTRlHOcUTaHCrnr3oK6QfjsXTCAMtdc9hAqDKI+m
 GlEYZdPffHEmhieND8MLScZSoxaXiwlKROqSAwacmv5F12uQCm5nXQ0Fz9ZEHEPXNKCC 1w== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by mx0b-00069f02.pphosted.com with ESMTP id 3aav18j978-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:31:31 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 179KU5mI078570;
        Mon, 9 Aug 2021 20:31:30 GMT
Received: from nam11-dm6-obe.outbound.protection.outlook.com (mail-dm6nam11lp2174.outbound.protection.outlook.com [104.47.57.174])
        by userp3030.oracle.com with ESMTP id 3a9f9vmsap-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Mon, 09 Aug 2021 20:31:30 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=P9mtOpTtGblnf3cKPRTEpD1g7DbjU9njbuqAehxPY4TiUwbkmLGN+ZtBUVfNzWmcQrXDh/4I0puJG7KEO+lx8TUKB3cKddOCzaU1ktP/Bw6edOnLhBCpo6BijFzNT6u0RDOp94MQyIsntZTYv7KD2ooSMXPLlAa05Acf1pMLjnkLFkvn+tlnbQT/AhiH7hw+d5zRf6fsJrcKVvPq3i7B2xqemgdk4VBAe3tle+FriLI3YyLPTbSJaW8wJKZx/NPBOFdI24neuXrtLxJKP8ti65wWJBYZRJxtZhiYb+FgvwYeeRzjwhTRUdtgKP1heB6CLlI3WEFpqYvun7LwWYj7ZA==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRLHK+tLMSk4HMPU+gMIGAXwL91AIEJk4rXe2EXW15g=;
 b=UvKnlmd1lq/rk2qbP6HsKfU5TJWaEqsCK99VF667hFlfSWcJSk3uIICK6NTfMyqLS+gMviQmp9GG1lfX5Ri6Xn1KGXjI5vZH1Dr9bOZsqzxOFGEof2Fc6KLJBmoKn/o3XVP6mvwdPL5Gf33/3dELTIxMZcp6frRIxrgqPDxntdwMBJeq4OeGNKdecI6F3et21T+8dZG7GVpCTSNMZYIrvwLYSBt58MEYcjjivXW4mrOpHDbOco7gcXc6Tcy4gcXJxsEKzoRPq/Hsy/t9B+DffeFzE+ejYAFi6qmyEyQDNmFHJXnf2Lza+iGPkf/x3mQupV5O0bT9xaMW3NZPy69LEA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=IRLHK+tLMSk4HMPU+gMIGAXwL91AIEJk4rXe2EXW15g=;
 b=P2zd+KAYf+/ZCR+Tp6p9JpVwZU9zCkiJ+D62k20r6IiS5jxI/fhuxF4HgNgxXpaAkukAWGfTHjB1Y+2SeXopjLZmZnYf9AjZ2ZjIhWG0w1eYYz995ptrtxnV90ChijT7PXC/SvaMTi3R8l5HmtlPYwkHOealzv2XG90SxYLreps=
Authentication-Results: fb.com; dkim=none (message not signed)
 header.d=none;fb.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BYAPR10MB2871.namprd10.prod.outlook.com (2603:10b6:a03:83::31) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.16; Mon, 9 Aug
 2021 20:31:27 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::588f:a774:17de:1d1b%3]) with mapi id 15.20.4394.023; Mon, 9 Aug 2021
 20:31:27 +0000
Subject: Re: [syzbot] BUG: sleeping function called from invalid context in
 _copy_to_iter
To:     Eric Dumazet <edumazet@google.com>
Cc:     Dmitry Vyukov <dvyukov@google.com>,
        syzbot <syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>, bpf <bpf@vger.kernel.org>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        Cong Wang <cong.wang@bytedance.com>,
        Daniel Borkmann <daniel@iogearbox.net>,
        David Miller <davem@davemloft.net>,
        jamorris@linux.microsoft.com,
        John Fastabend <john.fastabend@gmail.com>,
        Martin KaFai Lau <kafai@fb.com>, kpsingh@kernel.org,
        Jakub Kicinski <kuba@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "open list:KERNEL SELFTEST FRAMEWORK" 
        <linux-kselftest@vger.kernel.org>, netdev <netdev@vger.kernel.org>,
        Shuah Khan <shuah@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        syzkaller-bugs <syzkaller-bugs@googlegroups.com>,
        Al Viro <viro@zeniv.linux.org.uk>, Yonghong Song <yhs@fb.com>
References: <0000000000006bd0b305c914c3dc@google.com>
 <0c106e6c-672f-474e-5815-97b65596139d@oracle.com>
 <CACT4Y+bK61B3r5Rx150FwKt5WJ8T-q-X0nC-r=oH7x4ZU5vdVw@mail.gmail.com>
 <e99cc036-2f83-ff9e-ea68-3eeb19bd4147@oracle.com>
 <CACT4Y+bFLFg9WUiGWq=8ubKFug47=XNjqQJkTX3v1Hos0r+Z_A@mail.gmail.com>
 <2901262f-1ba7-74c0-e5fc-394b65414d12@oracle.com>
 <CANn89iKcSvJ5U37q1Jz2gVYxVS=_ydNmDuTRZuAW=YvB+jGChg@mail.gmail.com>
 <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <ca6a188a-6ce4-782b-9700-9ae4ac03f83e@oracle.com>
Date:   Mon, 9 Aug 2021 13:31:23 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.12.0
In-Reply-To: <CANn89iKqv4Ca8A1DmQsjvOqKvgay3-5j9gKPJKwRkwtUkmETYg@mail.gmail.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-ClientProxiedBy: SA0PR11CA0029.namprd11.prod.outlook.com
 (2603:10b6:806:d3::34) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:744d:8000::918] (2606:b400:8301:1010::16aa) by SA0PR11CA0029.namprd11.prod.outlook.com (2603:10b6:806:d3::34) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4394.17 via Frontend Transport; Mon, 9 Aug 2021 20:31:25 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 7fbf26aa-1b8e-44e6-1f4d-08d95b74a9e1
X-MS-TrafficTypeDiagnostic: BYAPR10MB2871:
X-Microsoft-Antispam-PRVS: <BYAPR10MB2871DDC2053F7D02CA1F35A9EFF69@BYAPR10MB2871.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:8882;
X-MS-Exchange-SenderADCheck: 1
X-MS-Exchange-AntiSpam-Relay: 0
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: e7eoOjP3hkLLwntIOI8kbKWT4ELctVG/arPS+pfp8IkKdU5UCX+uiHyYgzuEh1vJ8sR0N/Oy++qI6BMNgg5xu6jK/F4mp8Eqx4EUMYxUqVmHtcIITsR8Bz/k0jX/i7vGud/6vAPX7ABNRcK+tMEmGWqtYCLb45c0tnoFHU2xDNZ61O3ottoiPIRXEX/X0W4BFKJKRpAvwpB0e9HSFxUzT5YJ4/2GOPrYlsjvxNHZOCVF2HxO3I/Jf9NNg084LD52RYoQglU4JzQxvl54o9OE9ZkK10blFf0GubDiNPJYKReJDd2cjTqflVOWA/XS5XlF6GBN6e0rNqkYSD9gZlB0be28lWNo35puZ8X1KCKumN6U1wkJoBfcIbEU2vwTak2+/X50nwrehuOjFvj/nIYN+x9+aC3M7xkdJl3Sb0dCHtDGeo/eieEvckpLXvuyweVauDudYXOeg6Qyg281v0/vmv+phm/f3fm5p4Kaqzsk5hQoslEC1UVDdaHVUNd5qzDjozG6SnPK3AbSRVNZZ6Uean54TJdHswMgNY9xhIEJn27nyeNTvHSqXNXMMuO5peQr6wMg7bgGI6xFEDdvnsTU7T2FXvrdHPV8plK7YY7G9WpYqX5M3oDDwQ6uTmxq6GvCcg3UGDnbbXrbx5qM6QDLoczoVGgGb5vlZlsQIndpZ4YONfTwUrVnwhPkN2cMMXmmQu1Sw3aurDt8zj84V09JE2AfcOKx1QlFe8Bu/vmVVHX/lquy53SH6Ob5+K94U/wqID/HRIQgt2JHyQVIkw+ZCoeJP5YI1ahD7PTPKNvHbph1hdicEaYvB3VaJ6JjunaIOufj4LzkLbo0FZ68R23SGt+zJMRTTLl59fPX4WU0riqErDKDc4NlQTY6HV+Qyczc
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(136003)(366004)(346002)(376002)(39860400002)(83380400001)(8936002)(8676002)(86362001)(31696002)(36756003)(6916009)(966005)(2906002)(478600001)(186003)(316002)(54906003)(38100700002)(7416002)(66946007)(31686004)(66476007)(66556008)(5660300002)(4326008)(53546011)(6486002)(30864003)(2616005)(99710200001)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData-ChunkCount: 1
X-MS-Exchange-AntiSpam-MessageData-0: =?utf-8?B?eXVwdDVnNTF0Vis4MGtuTk5YOXhKNm42QzFINVAzUldVaFVJWEJ2eG5vMGth?=
 =?utf-8?B?cjdQR1ExRVNnSk5VdzJKYklubzBFTWhtZ0l5MXJQaFV1NGJibWp4dXJtV1FB?=
 =?utf-8?B?K0JWd0lCL3JHbTN1bG40ZWEyeGZYVXFCbnNodUd6WHRjRTIxOVBoRWFnaWxj?=
 =?utf-8?B?eU9wNjdBOXFIcXNsUEc1cTBCZmh3d2xUWkpMRVA5S0ZyaFQ5cVpSc0VCOFpl?=
 =?utf-8?B?RzlxNTVrcWdpeUMvZDhxeEJsL0RSQXkyWmhlbGR2b0xuUjMxTE9uSlFNdTJR?=
 =?utf-8?B?WlBzaVJJdDkvSkxjSGlSRm1EZHBRZGZrMXpRUklRYUhJU3Iwem0zdjV4c0Zk?=
 =?utf-8?B?MXJrZUt1cEFoTEhmd28yMzVnUWFmMXBVakRFZng4SWthK1VtN1kwSGdNekYx?=
 =?utf-8?B?NCs4c0NWaFJvbDZrV3ZSTFhJNll2Q0hNMEFnMnhQRmRsT2IwRmdtSWxLaVpr?=
 =?utf-8?B?TG5ROW1TZ1pKYXNTUjFWcGlMcWJYbThndERhOUhVZy9IUk84dEZPWVkxbExh?=
 =?utf-8?B?RzNSODJURiszRFNoRWY0MXFhOXB4alRTdklqdnQyQTV5dlExc2FWekZWY2J1?=
 =?utf-8?B?WHJUVzlqQ3ZxZDQxcis2eGlRY1ltN2EwL0U1Y0pwZTN3OWFxM01GUzkySnVL?=
 =?utf-8?B?SHNMS3ZDYUQyK3NBVWxtcVVVeFhienp2VXF5TzNRODIxOFBUc0F4UzlFMFRi?=
 =?utf-8?B?UWVFLzRnS2RRU2w5aU5WbDJPRDMwaHlnWndXQzVJSFUyVkJRSExSMnpnKzFP?=
 =?utf-8?B?TXV1UnpLTkdkVGJsVWJDZTdaeWg5aXNkVDl6NFIrbk9DMzBxWEI4ZGtpVFFG?=
 =?utf-8?B?UkwwK1k3V2lwejRkOGh2VDJ1Q1VRK1FZV3QzU3FXc2FlbW1mT0drOGJSVEVJ?=
 =?utf-8?B?bHFKbW9sSHRqcVBmeThGcDR2K1gzSVFIOHJIU2k0ek1IcHF0bSt6SGRPY3o1?=
 =?utf-8?B?N3k1dGRXZVBZUlFZYXdxMFhzZGViemhjL1ZyR0RGUWVFL1V4RWFQeXZmSGx0?=
 =?utf-8?B?amxINEgrdTQyOExpZU5IUFl6aFJ5b1FyeFR4TENVUEJwK3ZSdVJCdnl6RWZv?=
 =?utf-8?B?ZVJEUVV3ZFlkVFprYmFZSnJlVEhLZjU5UlE3N1lLcldCTW1iekc2OFJLTzVm?=
 =?utf-8?B?TGRRaVVuby9PRmdxWnBwUElGUW16WldycW9CRVphTlZvZjhmK3dWT1VZVmpx?=
 =?utf-8?B?aXYrVHArM3VGbGR4d0VUT05kb0NKM2o5YVp6elh5RnVva2RpblhxVGNUMmNS?=
 =?utf-8?B?Zmc2WlpMQWpNWmsyRnY5elIyV0I0M1ZQTjlNS2RoU0NjZnk5akhMTWZzaXk3?=
 =?utf-8?B?ekttMHArZm5BRktJWm9VTi9qN0cyZFRSZmNseWdvMUo3dHVVOG5vWlJSbnc1?=
 =?utf-8?B?SHpzUmJHNVFUSmVNR2pKZmdiY3JJWHFLK3ovUlBhZzZaM3NmUmh0SXZoZ2JT?=
 =?utf-8?B?UDcrMXNWaGJiUEszU3dZNy9UelUvVWhoNmFzUjFhbkxUSnQyUDFZdS82QzZW?=
 =?utf-8?B?cS8vdXN5eTlsd3RVZlVWbEw0QVBqRGVxNVVhUUVOeFJFM0kwVVVITzdmd3RC?=
 =?utf-8?B?OElKNmVvL1hpcll5ZFd6R09NUVNlVHQrY3JrMWNLQ0ZmTGN5TkNnRDQ0UEZD?=
 =?utf-8?B?L0I2dmx3bEpPZ0lIdlNtaStaOStGQUVSTjlpQklsckMrZ3M1dTlLSXpZUytI?=
 =?utf-8?B?b3lpMHpLaFNIOUNqc0dObm0xdXA4eURSVmUrU3A2QWgreW5JODJ3QlgrVHNu?=
 =?utf-8?B?K09XemZwZFJoTVVTUnp3UzNPenBveDNCZEVrZHJ2eFJWTXpMKzArdnowNytp?=
 =?utf-8?Q?Z7oqN10niPvlVLwo62IJYt10tciAlyFUO2kEQ=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 7fbf26aa-1b8e-44e6-1f4d-08d95b74a9e1
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 09 Aug 2021 20:31:27.7458
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: I1HTz+/jnrdZ7I9V+Rk20+vNvGfToF5By0/6fIS2uYLZfzBQyIQQH0EkA5UT7YF+YGxwox31sjW+hBgZZMXAyQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BYAPR10MB2871
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=10071 signatures=668682
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 suspectscore=0 phishscore=0
 adultscore=0 bulkscore=0 spamscore=0 mlxscore=0 mlxlogscore=999
 malwarescore=0 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2107140000 definitions=main-2108090145
X-Proofpoint-ORIG-GUID: gynfNc9lQTyqC2o7Kf3KuIdaLR2uXzXU
X-Proofpoint-GUID: gynfNc9lQTyqC2o7Kf3KuIdaLR2uXzXU
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 8/9/21 1:09 PM, Eric Dumazet wrote:
> On Mon, Aug 9, 2021 at 10:02 PM Eric Dumazet <edumazet@google.com> wrote:
>> On Mon, Aug 9, 2021 at 9:40 PM Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>>
>>> On 8/9/21 12:21 PM, Dmitry Vyukov wrote:
>>>> On Mon, 9 Aug 2021 at 21:16, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>>>> On 8/9/21 11:06 AM, Dmitry Vyukov wrote:
>>>>>> On Mon, 9 Aug 2021 at 19:33, Shoaib Rao <rao.shoaib@oracle.com> wrote:
>>>>>>> This seems like a false positive. 1) The function will not sleep because
>>>>>>> it only calls copy routine if the byte is present. 2). There is no
>>>>>>> difference between this new call and the older calls in
>>>>>>> unix_stream_read_generic().
>>>>>> Hi Shoaib,
>>>>>>
>>>>>> Thanks for looking into this.
>>>>>> Do you have any ideas on how to fix this tool's false positive? Tools
>>>>>> with false positives are order of magnitude less useful than tools w/o
>>>>>> false positives. E.g. do we turn it off on syzbot? But I don't
>>>>>> remember any other false positives from "sleeping function called from
>>>>>> invalid context" checker...
>>>>> Before we take any action I would like to understand why the tool does
>>>>> not single out other calls to recv_actor in unix_stream_read_generic().
>>>>> The context in all cases is the same. I also do not understand why the
>>>>> code would sleep, Let's assume the user provided address is bad, the
>>>>> code will return EFAULT, it will never sleep,
>>>> I always assumed that it's because if user pages are swapped out, it
>>>> may need to read them back from disk.
>>> Page faults occur all the time, the page may not even be in the cache or
>>> the mapping is not there (mmap), so I would not consider this a bug. The
>>> code should complain about all other calls as they are also copying  to
>>> user pages. I must not be following some semantics for the code to be
>>> triggered but I can not figure that out. What is the recommended
>>> interface to do user copy from kernel?
>> Are you aware of the difference between a mutex and a spinlock ?
>>
>> When copying data from/to user, you can not hold a spinlock.
>>
>>
> I am guessing that even your test would trigger the warning,
> if you make sure to include CONFIG_DEBUG_ATOMIC_SLEEP=y in your kernel build.

Eric,

Thanks for the pointer, have you ever over looked at something when coding?

Shoaib

>
>>> Shoaib
>>>
>>>>> if the kernel provided
>>>>> address is bad the system will panic. The only difference I see is that
>>>>> the new code holds 2 locks while the previous code held one lock, but
>>>>> the locks are acquired before the call to copy.
>>>>>
>>>>> So please help me understand how the tool works. Even though I have
>>>>> evaluated the code carefully, there is always a possibility that the
>>>>> tool is correct.
>>>>>
>>>>> Shoaib
>>>>>
>>>>>>
>>>>>>> On 8/8/21 4:38 PM, syzbot wrote:
>>>>>>>> Hello,
>>>>>>>>
>>>>>>>> syzbot found the following issue on:
>>>>>>>>
>>>>>>>> HEAD commit:    c2eecaa193ff pktgen: Remove redundant clone_skb override
>>>>>>>> git tree:       net-next
>>>>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=12e3a69e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHEdQcWD$
>>>>>>>> kernel config:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/.config?x=aba0c23f8230e048__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPLGp1-Za$
>>>>>>>> dashboard link: https://urldefense.com/v3/__https://syzkaller.appspot.com/bug?extid=8760ca6c1ee783ac4abd__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPCORTNOH$
>>>>>>>> compiler:       gcc (Debian 10.2.1-6) 10.2.1 20210110, GNU ld (GNU Binutils for Debian) 2.35.1
>>>>>>>> syz repro:      https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.syz?x=15c5b104300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPAjhi2yc$
>>>>>>>> C reproducer:   https://urldefense.com/v3/__https://syzkaller.appspot.com/x/repro.c?x=10062aaa300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNzAjzQJ$
>>>>>>>>
>>>>>>>> The issue was bisected to:
>>>>>>>>
>>>>>>>> commit 314001f0bf927015e459c9d387d62a231fe93af3
>>>>>>>> Author: Rao Shoaib <rao.shoaib@oracle.com>
>>>>>>>> Date:   Sun Aug 1 07:57:07 2021 +0000
>>>>>>>>
>>>>>>>>         af_unix: Add OOB support
>>>>>>>>
>>>>>>>> bisection log:  https://urldefense.com/v3/__https://syzkaller.appspot.com/x/bisect.txt?x=10765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPK2iWt2r$
>>>>>>>> final oops:     https://urldefense.com/v3/__https://syzkaller.appspot.com/x/report.txt?x=12765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKAb0dft$
>>>>>>>> console output: https://urldefense.com/v3/__https://syzkaller.appspot.com/x/log.txt?x=14765f8e300000__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPNlW_w-u$
>>>>>>>>
>>>>>>>> IMPORTANT: if you fix the issue, please add the following tag to the commit:
>>>>>>>> Reported-by: syzbot+8760ca6c1ee783ac4abd@syzkaller.appspotmail.com
>>>>>>>> Fixes: 314001f0bf92 ("af_unix: Add OOB support")
>>>>>>>>
>>>>>>>> BUG: sleeping function called from invalid context at lib/iov_iter.c:619
>>>>>>>> in_atomic(): 1, irqs_disabled(): 0, non_block: 0, pid: 8443, name: syz-executor700
>>>>>>>> 2 locks held by syz-executor700/8443:
>>>>>>>>      #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>>>>>>      #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>>>>>>      #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>>>>>>> Preemption disabled at:
>>>>>>>> [<0000000000000000>] 0x0
>>>>>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Not tainted 5.14.0-rc3-syzkaller #0
>>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>>>>> Call Trace:
>>>>>>>>      __dump_stack lib/dump_stack.c:88 [inline]
>>>>>>>>      dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>>>>>>      ___might_sleep.cold+0x1f1/0x237 kernel/sched/core.c:9154
>>>>>>>>      __might_fault+0x6e/0x180 mm/memory.c:5258
>>>>>>>>      _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>>>>>>      copy_to_iter include/linux/uio.h:139 [inline]
>>>>>>>>      simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>>>>>>      __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>>>>>>      skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>>>>>>      skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>>>>>>      unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>>>>>>      unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>>>>>>      unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>>>>>>      unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>>>>>>      sock_recvmsg_nosec net/socket.c:944 [inline]
>>>>>>>>      sock_recvmsg net/socket.c:962 [inline]
>>>>>>>>      sock_recvmsg net/socket.c:958 [inline]
>>>>>>>>      ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>>>>>>      ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>>>>>>      do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>>>>>>      __sys_recvmmsg net/socket.c:2837 [inline]
>>>>>>>>      __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>>>>>>      __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>>>>>>      __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>>>>>>      do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>      do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>>      entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>>>>> RIP: 0033:0x43ef39
>>>>>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>>>>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>>>>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>>>>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>>>>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>>>>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000000000402fb0
>>>>>>>> R13: 0000000000000000 R14: 00000000004ac018 R15: 0000000000400488
>>>>>>>>
>>>>>>>> =============================
>>>>>>>> [ BUG: Invalid wait context ]
>>>>>>>> 5.14.0-rc3-syzkaller #0 Tainted: G        W
>>>>>>>> -----------------------------
>>>>>>>> syz-executor700/8443 is trying to lock:
>>>>>>>> ffff8880212b6a28 (&mm->mmap_lock#2){++++}-{3:3}, at: __might_fault+0xa3/0x180 mm/memory.c:5260
>>>>>>>> other info that might help us debug this:
>>>>>>>> context-{4:4}
>>>>>>>> 2 locks held by syz-executor700/8443:
>>>>>>>>      #0: ffff888028fa0d00 (&u->iolock){+.+.}-{3:3}, at: unix_stream_read_generic+0x16c6/0x2190 net/unix/af_unix.c:2501
>>>>>>>>      #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: spin_lock include/linux/spinlock.h:354 [inline]
>>>>>>>>      #1: ffff888028fa0df0 (&u->lock){+.+.}-{2:2}, at: unix_stream_read_generic+0x16d0/0x2190 net/unix/af_unix.c:2502
>>>>>>>> stack backtrace:
>>>>>>>> CPU: 1 PID: 8443 Comm: syz-executor700 Tainted: G        W         5.14.0-rc3-syzkaller #0
>>>>>>>> Hardware name: Google Google Compute Engine/Google Compute Engine, BIOS Google 01/01/2011
>>>>>>>> Call Trace:
>>>>>>>>      __dump_stack lib/dump_stack.c:88 [inline]
>>>>>>>>      dump_stack_lvl+0xcd/0x134 lib/dump_stack.c:105
>>>>>>>>      print_lock_invalid_wait_context kernel/locking/lockdep.c:4666 [inline]
>>>>>>>>      check_wait_context kernel/locking/lockdep.c:4727 [inline]
>>>>>>>>      __lock_acquire.cold+0x213/0x3ab kernel/locking/lockdep.c:4965
>>>>>>>>      lock_acquire kernel/locking/lockdep.c:5625 [inline]
>>>>>>>>      lock_acquire+0x1ab/0x510 kernel/locking/lockdep.c:5590
>>>>>>>>      __might_fault mm/memory.c:5261 [inline]
>>>>>>>>      __might_fault+0x106/0x180 mm/memory.c:5246
>>>>>>>>      _copy_to_iter+0x199/0x1600 lib/iov_iter.c:619
>>>>>>>>      copy_to_iter include/linux/uio.h:139 [inline]
>>>>>>>>      simple_copy_to_iter+0x4c/0x70 net/core/datagram.c:519
>>>>>>>>      __skb_datagram_iter+0x10f/0x770 net/core/datagram.c:425
>>>>>>>>      skb_copy_datagram_iter+0x40/0x50 net/core/datagram.c:533
>>>>>>>>      skb_copy_datagram_msg include/linux/skbuff.h:3620 [inline]
>>>>>>>>      unix_stream_read_actor+0x78/0xc0 net/unix/af_unix.c:2701
>>>>>>>>      unix_stream_recv_urg net/unix/af_unix.c:2433 [inline]
>>>>>>>>      unix_stream_read_generic+0x17cd/0x2190 net/unix/af_unix.c:2504
>>>>>>>>      unix_stream_recvmsg+0xb1/0xf0 net/unix/af_unix.c:2717
>>>>>>>>      sock_recvmsg_nosec net/socket.c:944 [inline]
>>>>>>>>      sock_recvmsg net/socket.c:962 [inline]
>>>>>>>>      sock_recvmsg net/socket.c:958 [inline]
>>>>>>>>      ____sys_recvmsg+0x2c4/0x600 net/socket.c:2622
>>>>>>>>      ___sys_recvmsg+0x127/0x200 net/socket.c:2664
>>>>>>>>      do_recvmmsg+0x24d/0x6d0 net/socket.c:2758
>>>>>>>>      __sys_recvmmsg net/socket.c:2837 [inline]
>>>>>>>>      __do_sys_recvmmsg net/socket.c:2860 [inline]
>>>>>>>>      __se_sys_recvmmsg net/socket.c:2853 [inline]
>>>>>>>>      __x64_sys_recvmmsg+0x20b/0x260 net/socket.c:2853
>>>>>>>>      do_syscall_x64 arch/x86/entry/common.c:50 [inline]
>>>>>>>>      do_syscall_64+0x35/0xb0 arch/x86/entry/common.c:80
>>>>>>>>      entry_SYSCALL_64_after_hwframe+0x44/0xae
>>>>>>>> RIP: 0033:0x43ef39
>>>>>>>> Code: 28 c3 e8 2a 14 00 00 66 2e 0f 1f 84 00 00 00 00 00 48 89 f8 48 89 f7 48 89 d6 48 89 ca 4d 89 c2 4d 89 c8 4c 8b 4c 24 08 0f 05 <48> 3d 01 f0 ff ff 73 01 c3 48 c7 c1 c0 ff ff ff f7 d8 64 89 01 48
>>>>>>>> RSP: 002b:00007ffca8776d68 EFLAGS: 00000246 ORIG_RAX: 000000000000012b
>>>>>>>> RAX: ffffffffffffffda RBX: 0000000000400488 RCX: 000000000043ef39
>>>>>>>> RDX: 0000000000000700 RSI: 0000000020001140 RDI: 0000000000000004
>>>>>>>> RBP: 0000000000402f20 R08: 0000000000000000 R09: 0000000000400488
>>>>>>>> R10: 0000000000000007 R11: 0000000000000246 R12: 0000
>>>>>>>>
>>>>>>>>
>>>>>>>> ---
>>>>>>>> This report is generated by a bot. It may contain errors.
>>>>>>>> See https://urldefense.com/v3/__https://goo.gl/tpsmEJ__;!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPG1UhbpZ$  for more information about syzbot.
>>>>>>>> syzbot engineers can be reached at syzkaller@googlegroups.com.
>>>>>>>>
>>>>>>>> syzbot will keep track of this issue. See:
>>>>>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*status__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPKlEx5v1$  for how to communicate with syzbot.
>>>>>>>> For information about bisection process see: https://urldefense.com/v3/__https://goo.gl/tpsmEJ*bisection__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPJk7KaIr$
>>>>>>>> syzbot can test patches for this issue, for details see:
>>>>>>>> https://urldefense.com/v3/__https://goo.gl/tpsmEJ*testing-patches__;Iw!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPMhq2hD3$
>>>>>>> --
>>>>>>> You received this message because you are subscribed to the Google Groups "syzkaller-bugs" group.
>>>>>>> To unsubscribe from this group and stop receiving emails from it, send an email to syzkaller-bugs+unsubscribe@googlegroups.com.
>>>>>>> To view this discussion on the web visit https://urldefense.com/v3/__https://groups.google.com/d/msgid/syzkaller-bugs/0c106e6c-672f-474e-5815-97b65596139d*40oracle.com__;JQ!!ACWV5N9M2RV99hQ!fbn9ny5Bw51Jl6yrU93iULDBXa_DPjyVIgQuZWyQbCo5IRkAzvYs6JKlPHjmYAGZ$ .
