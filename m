Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B2927308DBA
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 20:52:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233032AbhA2TtT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 14:49:19 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:51882 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232855AbhA2TtQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 14:49:16 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJjY2I035684;
        Fri, 29 Jan 2021 19:48:20 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=y1B2n9QgpxUbUAn1e3wwzGvOie7W7RnDQ8GwBgPfCYA=;
 b=OsKAz5/8auKiOMgwq7MVu2mT4TSdjCvcgLMeVebbvdK8Td9+UH+3UixSsPNSpA60MgaM
 caY3W9KZdp4ruJyx8IWfCVAWw/hXE9Z/0Sp28mM/tFZdpSn9ULJVTN72kHJ2j6aYDQ8v
 63M+MHoEPe1FWWd63dWVhSaKX+kea1mnigyRPdIo8Ui9TXbZtO6XMZsakY62mJi+tATN
 ObDb/4K/Zj8eW4yaVP7aabkB9ffS1kMMgK2hAw/IgP6Vi8MIu2IHVv7j9RDTXdoeSos0
 36wfH6tXADiK9qdJREu7qDPBw3cv3CcIThS+XKvB90NKRpJdlvY0hMDPdOR/JjZSMXBw /A== 
Received: from aserp3030.oracle.com (aserp3030.oracle.com [141.146.126.71])
        by aserp2130.oracle.com with ESMTP id 3689ab35fb-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:48:20 +0000
Received: from pps.filterd (aserp3030.oracle.com [127.0.0.1])
        by aserp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TJjT6m035665;
        Fri, 29 Jan 2021 19:48:20 GMT
Received: from nam10-dm6-obe.outbound.protection.outlook.com (mail-dm6nam10lp2105.outbound.protection.outlook.com [104.47.58.105])
        by aserp3030.oracle.com with ESMTP id 368wcsndyu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 19:48:20 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=Y2zU5HwyeMTrqtb1yB0zY/yx1ct2qAu8k297KdnHmJen09BuSvMqvOOOK8wQgxh/uxgi/nvWn5g7H9eNkS8gjd1Ff9GYAwEJMXDO1ku676Ey3Gkug7S4uAbqmlAOoz1TxKjpwKCdpKjuzthnaCtLL0KyZV7i2pnthO8E8YnI78vpIRwk39GNpuIZmNlaxllV40jYKRDFQkd4cdjiOWhEX5ygVWq+IWpdCWAQQPs8/bo3Xf/dD1nYQrP0qMGLwhUZNI2wClw9OIZMtP1IQiUykgSXn6xMOz/HU47GsNSjrcw33zm6tr42GmuK1CoURLe0PhLLgJ8XqNjZn3DfoX64Gw==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1B2n9QgpxUbUAn1e3wwzGvOie7W7RnDQ8GwBgPfCYA=;
 b=a+dqerskrllGLDF4uSvwWwHn7SdugskTzZHyrqf+nIss01zsfUtsmb8UUrKCHpnIwVeKozq9A6c9/y/+3UZ+KpRPVkpRdAz7+qYe7Bqw0TDX0tCeyIFdZbId7oThCeB0upQ4ueM1IgqAGRQAfIMs7Lfv2qOoIroYutjmYUGgfpzxvLF0lp83B33g95LrUxjFEa69UHRJJ3/9/is2SALWOH90v4oIT05ruhXg30m4eslelGkg3+VgRK9GmUxRDMdTe8MInLn6b4qEtLGQkD1LJIjV03VmbIXD00ZEarwrh9TQi43jOxlKZhB3i4GbNF9ya2wiusuRnJHFrKYlhV9S2w==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=y1B2n9QgpxUbUAn1e3wwzGvOie7W7RnDQ8GwBgPfCYA=;
 b=g3VQGjGPb6q7HatsyV7Br15Sh2H3+p7Yut6VsxsoGIPtOiap78OAlGcCn/TURtnOC2JWNp693IENSnhQ4v3ZI9svEwnz5+/gJ9uoduawFwYk11mJw+7GzUmtEmt0oqMvruivxMoSuR2qBr2rc03sHp85f3OqaePAacLp7vB0j5o=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by SJ0PR10MB4510.namprd10.prod.outlook.com (2603:10b6:a03:2d6::22) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3784.16; Fri, 29 Jan
 2021 19:48:18 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 19:48:18 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Shoaib Rao <rao.shoaib@oracle.com>
Message-ID: <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
Date:   Fri, 29 Jan 2021 11:48:15 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: SJ0PR03CA0042.namprd03.prod.outlook.com
 (2603:10b6:a03:33e::17) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by SJ0PR03CA0042.namprd03.prod.outlook.com (2603:10b6:a03:33e::17) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.17 via Frontend Transport; Fri, 29 Jan 2021 19:48:17 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 539e73b1-a6f4-4744-d7e3-08d8c48ed313
X-MS-TrafficTypeDiagnostic: SJ0PR10MB4510:
X-Microsoft-Antispam-PRVS: <SJ0PR10MB451008131E616D7CC7F8EAADEFB99@SJ0PR10MB4510.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:9508;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: HDS52U0hk2yrx/EKwQMpt/9M9w2iJfPw5ANyyI6OzB9pAbhOv4wSUxQwYqTDg2lpBgIx+6JCeCi6tf/1Jgo9CVRHAs7QrdvlMDsJ4GQt/HZvxri4ZL6x6Cxp2+ux9r7L1RWB9P/5vAGCo9oCitkEENAWPDEa0cdC+VxaEApUxlrQqe/c3xE1vBJMMU4NUr7aQAyIK9ur+X+GrJtCwBnkGLI7vDW2ur7sH/w6uS41UYElM4gYipU5G3/eYwZ3DirWrXXOI86OcQwnkr3p91wzZqYtyVtgegiAIDHqu/AtrY9zF12eRs5FWXUmbxq6XueEf8wYbQCdjyEkNws68Ph2v20uKtrz6lJ54JyrpRnszucCtTeJr/qj+OU4ag2bhBrhU8xuO34heCOobBKHPieMOcMT7xnz7Ia/KHbcpV4R5y7f5knnGILSzTP/8g/X1TlhKWTYf4Iyw0FYIXcvGXas0xoXPTNrcOF109Lwruqwp6tvkP30FpGn7iT1HHr/6Sa2olqNTE7vWcMX4LbZ8AfUWSUNsLM+cSQtlAx0msiPbHCI+zvzLlkXs4qle4cz6jXSE5CMLfpxomKkluPq9a8LaNCykHwaPJc2m6+Lrll2NYw=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(376002)(366004)(39860400002)(396003)(136003)(346002)(2906002)(54906003)(31686004)(36756003)(66946007)(478600001)(6486002)(83380400001)(186003)(31696002)(86362001)(16526019)(4326008)(66476007)(316002)(66556008)(6916009)(2616005)(53546011)(5660300002)(8936002)(8676002)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?U1FlYjNidkNqbU54Sm1tb0QwazRSbVFISE1wb3NISUwyTC83ekxJZ0FSUDhq?=
 =?utf-8?B?UEJEVWN0WGNjWk5WTXI5TXhwejZHTHNUbGIwNGtLV1BieEIwTUlCdkRGTnA5?=
 =?utf-8?B?VyszR2ZaN1VPTXk2UlZSZWpPcFF3LzJYRTZ2QktPS0JYejFxVGkvTCs4MWFV?=
 =?utf-8?B?Sk1NVkVCZGUrQWJJaVBxUzNZVFhMME1jTGVGakYySEMzRXh6OHd0UXcxYnQ0?=
 =?utf-8?B?UWFuZ0x2ZU0ySnNQUEgrN3hyRURMYXRLMGpRa2phQ0t6R2lNUUdkc2VkTTFi?=
 =?utf-8?B?QjVHdllzdlg4OTVoL3Qyb0NXNFpnUGNpV3JuYk51YncrMDBXZEhTeHpaRUhi?=
 =?utf-8?B?OGQwZFJ0bVN6eFJXNGJ0cHVMT3BLaFRJZjRWUGtNeC8yTjZycSsvMzFOb3NC?=
 =?utf-8?B?bjd2NGthR3Q3elYweDQ1dkZaWDdLcU56S3llNjRIRHJtTmNCMEl5YTRtZlhr?=
 =?utf-8?B?L1hvZWU1cWp4dysvMTVYRnQ2ckhNRnZxSUg0RTNmK1Vjc1c3VUhRT2h0UHZI?=
 =?utf-8?B?a1NibVUyeXdmV0xVcnZxZTFqSnpPMU9lNVJpcFNLZmp3SmYwNHh4SG9ZOGlQ?=
 =?utf-8?B?WGJNUDkya2hEemxQMXBuQzhYVHhwTzNMY1ZQNUk5ekdTWlpSaVF0QkM2dDk4?=
 =?utf-8?B?b0xCWFl6YWlZc2UvQ0NldVJrMzE2TDh6dHFIck9Vb21FdWo2Qlp6QU8vVXRr?=
 =?utf-8?B?cm5aMnNrek10Wm05UmFINmRWM25NQnpCbERBVlZhZi9ncGJFcUxCQTBOc04r?=
 =?utf-8?B?alR5SHJJeTVHTjdHalRmc0xJbGZyZ1NtckVKU09iY0M0WWpMWWVyVXF6bzh3?=
 =?utf-8?B?UGhtQUZUaE1qakJwZmRKbHc4UTRBV3VtSDBWRnBzNjZWSjlKZzlxbktBKzJO?=
 =?utf-8?B?SnhOSkZ5NkdwZGJEWi9EdWhkcjhCcHJ2OFVxcFU3ekF6OHUra0dwN0lVUTNF?=
 =?utf-8?B?bE51dENtYld1OWdQcjRCdjZjQUVVL2pObFI1K2JiY2M4bjhESWp2VXNIWW16?=
 =?utf-8?B?Si9zR0NVME83cmFBMHRCb21jYlRCV3cwWmFRQTkxT2lBYTdRTzN6TGt2S1l6?=
 =?utf-8?B?MExaa3V0SHVERVo0NkVFT1o2Z0puVGQ2Y0EzdG5nTFFrT2hWd1BSdWFPSnNx?=
 =?utf-8?B?cVJtWFM5OVRNaGpSSUtqK3dIVlhWUkVLeDd4UXpIRGNTYnQ0UlltZm55Q3NB?=
 =?utf-8?B?bVRmekhXTHhQQlhQZ1RNemV6WHhNdmF4NElrdkt0c1RobG5hRTM5Z2NDK3hn?=
 =?utf-8?B?azdmalRVNi9LQjJUU21BZkpteUJBTjAzWjlWZCtFM0FqSzZ6T2ZXbzg2cWhE?=
 =?utf-8?B?eUgzMUFaYmtVZllzM2xFYkc4VlBMUFEwZ051UnNQdjFxWlJzZWtFeHFFbzAw?=
 =?utf-8?B?ZlB3YmgzbFBFK2ZLSTYxZ0xSM1VsZVpMVldpV1l5L2Y2MGhtb3RWQW52azNv?=
 =?utf-8?B?cGcyeXVwb0VDVVNhVUs1clZHclRGMVFYMkdGL0J2OTZYM1MrZjNZcWdZeXBm?=
 =?utf-8?Q?xnGWkA=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 539e73b1-a6f4-4744-d7e3-08d8c48ed313
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 19:48:18.0400
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: 0/4GaqxNM5yZ1nlT6LbCK6D9Ce3DLwU59lO4svjfdo7P8LF0GiBRZslRFx6zyJQ/8iPs/mRNDJASbhPvDexRkQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: SJ0PR10MB4510
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 adultscore=0 mlxscore=0 suspectscore=0
 phishscore=0 mlxlogscore=999 bulkscore=0 malwarescore=0 spamscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290095
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290095
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 11:06 AM, Jakub Kicinski wrote:
> On Fri, 29 Jan 2021 09:56:48 -0800 Shoaib Rao wrote:
>> On 1/25/21 3:36 PM, Jakub Kicinski wrote:
>>> On Fri, 22 Jan 2021 15:06:37 +0000 Matthew Wilcox (Oracle) wrote:
>>>> From: Rao Shoaib <rao.shoaib@oracle.com>
>>>>
>>>> TCP sockets allow SIGURG to be sent to the process holding the other
>>>> end of the socket.  Extend Unix sockets to have the same ability.
>>>>
>>>> The API is the same in that the sender uses sendmsg() with MSG_OOB to
>>>> raise SIGURG.  Unix sockets behave in the same way as TCP sockets with
>>>> SO_OOBINLINE set.
>>> Noob question, if we only want to support the inline mode, why don't we
>>> require SO_OOBINLINE to have been called on @other? Wouldn't that
>>> provide more consistent behavior across address families?
>>>
>>> With the current implementation the receiver will also not see MSG_OOB
>>> set in msg->msg_flags, right?
>> SO_OOBINLINE does not control the delivery of signal, It controls how
>> OOB Byte is delivered. It may not be obvious but this change does not
>> deliver any Byte, just a signal. So, as long as sendmsg flag contains
>> MSG_OOB, signal will be delivered just like it happens for TCP.
> Not as far as I can read this code. If MSG_OOB is set the data from the
> message used to be discarded, and EOPNOTSUPP returned. Now the data gets
> queued to the socket, and will be read inline.

Data was discarded because the flag was not supported, this patch 
changes that but does not support any urgent data.

OOB data has some semantics that would have to be followed and if we 
support SO_OOBINLINE we would have to support NOT SO_OOBINLINE.

One can argue that we add a socket option to allow this OR just do what 
TCP does.

Shoaib


>
> Sure, you also add firing of the signal, which is fine. The removal of
> the error check is the code I'm pointing at, so to speak.
That is the change in behavior that this change is making.
>
>>>> SIGURG is ignored by default, so applications which do not know about this
>>>> feature will be unaffected.  In addition to installing a SIGURG handler,
>>>> the receiving application must call F_SETOWN or F_SETOWN_EX to indicate
>>>> which process or thread should receive the signal.
>>>>
>>>> Signed-off-by: Rao Shoaib <rao.shoaib@oracle.com>
>>>> Signed-off-by: Matthew Wilcox (Oracle) <willy@infradead.org>
>>>> ---
>>>>    net/unix/af_unix.c | 5 +++--
>>>>    1 file changed, 3 insertions(+), 2 deletions(-)
>>>>
>>>> diff --git a/net/unix/af_unix.c b/net/unix/af_unix.c
>>>> index 41c3303c3357..849dff688c2c 100644
>>>> --- a/net/unix/af_unix.c
>>>> +++ b/net/unix/af_unix.c
>>>> @@ -1837,8 +1837,6 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>    		return err;
>>>>    
>>>>    	err = -EOPNOTSUPP;
>>>> -	if (msg->msg_flags&MSG_OOB)
>>>> -		goto out_err;
>>>>    
>>>>    	if (msg->msg_namelen) {
>>>>    		err = sk->sk_state == TCP_ESTABLISHED ? -EISCONN : -EOPNOTSUPP;
>>>> @@ -1903,6 +1901,9 @@ static int unix_stream_sendmsg(struct socket *sock, struct msghdr *msg,
>>>>    		sent += size;
>>>>    	}
>>>>    
>>>> +	if (msg->msg_flags & MSG_OOB)
>>>> +		sk_send_sigurg(other);
>>>> +
>>>>    	scm_destroy(&scm);
>>>>    
>>>>    	return sent;
