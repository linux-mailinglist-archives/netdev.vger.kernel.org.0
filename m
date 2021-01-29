Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 38D71308ED1
	for <lists+netdev@lfdr.de>; Fri, 29 Jan 2021 21:58:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233293AbhA2Uwm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jan 2021 15:52:42 -0500
Received: from aserp2130.oracle.com ([141.146.126.79]:43902 "EHLO
        aserp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233287AbhA2Uuv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jan 2021 15:50:51 -0500
Received: from pps.filterd (aserp2130.oracle.com [127.0.0.1])
        by aserp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TKnJVQ164431;
        Fri, 29 Jan 2021 20:49:51 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : from : to :
 cc : references : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=EFzN5/FMbOknUk3enKFydmPcydIk5NkKHtLJtLOhRss=;
 b=kY0p2Q5I7IwhIVj3BL6ufsCdCeDqJMxFlj7dzEO8OZ0mFHU5NHlvDTBcEll4Sj7Qu+/6
 nF/94/HrLFd5TaBn2fwTA31Gdn8p5jSrz1rC3E1wV7T8DyRcly7ZJPoZUckoz/Yprcau
 ClEkmdYSbbcd9ZJq8RAEiJc33QrjyEfv9R6ZaKoe+IsXGpsbQfoFHxYHJBXKn57eEVQR
 SGu0dUOemFTuoweQDvN8if6kGUd2XRFSLx9ntgNLilJYp3tWQ3MbYvT0F9/MJKfid9gM
 CiLJKQBNvX2xzlrzWcWZsGPLY+LBhgx9OW4Bnv9BqPmgWH1mirBNC8kvAPHID/eZGAp0 vw== 
Received: from userp3030.oracle.com (userp3030.oracle.com [156.151.31.80])
        by aserp2130.oracle.com with ESMTP id 3689ab3c43-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:49:50 +0000
Received: from pps.filterd (userp3030.oracle.com [127.0.0.1])
        by userp3030.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 10TKeIUf147360;
        Fri, 29 Jan 2021 20:49:50 GMT
Received: from nam10-bn7-obe.outbound.protection.outlook.com (mail-bn7nam10lp2107.outbound.protection.outlook.com [104.47.70.107])
        by userp3030.oracle.com with ESMTP id 368wr2fjhr-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Fri, 29 Jan 2021 20:49:50 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=DH7aZDpSiuJBPLb1QBbRF1u7ClJt1aDH4H8s6VVjUHqoDojE1TWBSF6cYtsC0BU8OHDK4jiZ8oB0rXL7tpL6e4fvuaV9bSjZ8jj94bfjOBjyfqTIca7JiRl+z1JIC9qFmta+/49+e7BY2G2AVo8xm2g8ivwS+Sr2OcffneNyavJAoYNsUN1yfyN6eGTnfJGhK4+edhQSHfGnQpkmiNSrvlwpOY3DI1aKcVE9ji8Oany23+IeaDxbKhtlRJV2OnLJV4JsI7SbOKoPaaIOuOkfbfZC23/fo52XLm+Xh2C77FPmlpWUYQGNBH562THLJ+kEKZf0FJYzw/PTcrFypO+j7w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFzN5/FMbOknUk3enKFydmPcydIk5NkKHtLJtLOhRss=;
 b=Y7gzKKuLWmKcWcbsTSp0h8c9NuafkjHD4OykJGQGc1uRiF6SCtxLkYjDP4UaDGFCMfPqSFju2r5L2HU8gboJ3ldiBIlJJVxX9PO8dDSSnfNmQNlLhBDOVoL4fJ5/7Z/7KbAtjFD1etzZ5OFRRgqKsaKZxS8tFekmcornSuCST9STvCSSchG8nbYRhEGkfXHjKKymp49ePrmoEl8IuRtxK/jvwjDj1rowC5/er81O8B2BpEBE34J9MLy1yRssK6sqc2isyNGB8zrnU8aBSNx2iFyUBrAzdQDLGZyTmChIy3iX2YW8OTLcz6wFzqHyu2yLACDyEDMyqdMVN3d3gnMw8A==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=EFzN5/FMbOknUk3enKFydmPcydIk5NkKHtLJtLOhRss=;
 b=S5oSqPJX8aFS0FlPfJI3xNOkqBR8GKsihS93PYXHclTUIkgjaSc1+I0/X+7TmY6ZnV3g/ridBDZhcWEF0lvpUXGtnrrf12k9b9Fc6x6tjo2U6K7/vpf45GfmU/FGbCapWAMJQmQavqouAoKbRx5eEI+9kBAf0EjHk+5X1M/Hf4w=
Authentication-Results: intel.com; dkim=none (message not signed)
 header.d=none;intel.com; dmarc=none action=none header.from=oracle.com;
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com (2603:10b6:a03:2d4::12)
 by BY5PR10MB4275.namprd10.prod.outlook.com (2603:10b6:a03:210::24) with
 Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.19; Fri, 29 Jan
 2021 20:49:47 +0000
Received: from SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07]) by SJ0PR10MB4494.namprd10.prod.outlook.com
 ([fe80::7445:f44:72aa:da07%4]) with mapi id 15.20.3805.017; Fri, 29 Jan 2021
 20:49:47 +0000
Subject: Re: [PATCH] af_unix: Allow Unix sockets to raise SIGURG
From:   Shoaib Rao <rao.shoaib@oracle.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "Matthew Wilcox (Oracle)" <willy@infradead.org>,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org,
        netdev@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        andy.rudoff@intel.com
References: <20210122150638.210444-1-willy@infradead.org>
 <20210125153650.18c84b1a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <23fc3de2-7541-04c9-a56f-4006a7dc773f@oracle.com>
 <20210129110605.54df8409@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <a21dc26a-87dc-18c8-b8bd-24f9797afbad@oracle.com>
 <20210129120250.269c366d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <cef52fb0-43cb-9038-7e48-906b58b356b6@oracle.com>
 <20210129121837.467280fb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
Message-ID: <8915ad19-4a22-9124-8f79-4f003a512bd5@oracle.com>
Date:   Fri, 29 Jan 2021 12:49:45 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.6.1
In-Reply-To: <e1047be3-2d53-49d3-67b4-a2a99e0c0f0f@oracle.com>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8bit
Content-Language: en-US
X-Originating-IP: [2606:b400:8301:1010::16aa]
X-ClientProxiedBy: BYAPR11CA0056.namprd11.prod.outlook.com
 (2603:10b6:a03:80::33) To SJ0PR10MB4494.namprd10.prod.outlook.com
 (2603:10b6:a03:2d4::12)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [IPv6:2606:b400:400:7446:8000::12a8] (2606:b400:8301:1010::16aa) by BYAPR11CA0056.namprd11.prod.outlook.com (2603:10b6:a03:80::33) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.3805.16 via Frontend Transport; Fri, 29 Jan 2021 20:49:47 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: 56380984-f57d-422e-cf46-08d8c4976a56
X-MS-TrafficTypeDiagnostic: BY5PR10MB4275:
X-Microsoft-Antispam-PRVS: <BY5PR10MB4275EF27BEB5983DC1CA9875EFB99@BY5PR10MB4275.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: L53r5kknglpGnjo+WzUFFz2cvNt4vLNAXEj17OkftFaIsDUAWaShV+IS79WR/qmWQoevtcVFW/mh3dB/6TpyHtUVlWHbBsJ3lPMw7l/WlLx9JlfEmqR8Ms7TB4TmTRDMzRlo+KHEWNeK4OKnFeufhyEBwoG+SJDuSDIcVBPX+nSBzDKqi4WCzetf1m5Xa/K2rYegJOuNRmd/nzqHyYE72yYVgp2md2E0x6/he7bUy0gS+FfKtQWK78VZS9CQOenhy+eY0J8eCb0XbI2TXMYC64SRLjlXK2nfFEcKl4S40BAacpE2VQGG2WnU0ERmYAX1XABTuAwGiIwMDmWTbYvk7nWuSoOAubDIFlICBID7aZ8102//v1MmJNcwmnkzHrw0GGSirR71axZjfuK+ZlvN6a4uw2mbuNF7jPXFvAglUtXpYpOm/tvjN2+VBbAiwzEHV3sbqSUiBo3+ytT8DfsmYp0tSC4BrN5N5Xz7hGsAB3zAWNBgwiXOlX85dCas7OVGR1tJ7S3Ta6iHK13Vj0fl9arvZ8sr7zv9AdDal96WtDb3PxrdoEB64ud53WZsYoEAvRsoWNBxQ/iSyy4HzCZuzRWPyX5AWrSq/g3a4AGEpQo=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:SJ0PR10MB4494.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(366004)(346002)(376002)(396003)(136003)(39860400002)(6486002)(2616005)(54906003)(4326008)(316002)(186003)(16526019)(478600001)(83380400001)(53546011)(31686004)(8936002)(6916009)(8676002)(31696002)(86362001)(2906002)(36756003)(5660300002)(66556008)(66946007)(66476007)(43740500002)(45980500001);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?eW5zQ2Q0Rm5paFUyNmtPTFI1KzFoZ2x3QVg4b1MyVDV1MGRZL2J5alYva2Y2?=
 =?utf-8?B?bWU1eDI0WDZBMFZBa1JQMVZ2eHFESm5mUE4xV2pKSEY4UlVLUDN1V2JYMWh0?=
 =?utf-8?B?V05zbVhLTzBSOWFGaG1QU0MrTVAwSW53YkplREdjR0lRZDd6cVNFQ2UyRDNv?=
 =?utf-8?B?WEYrdzczWFBCQ2JrZ0lNSk9UL0t0eHlMd0p3cW5ncml5c00wQXhhNGgvejlR?=
 =?utf-8?B?anR6dnlTYVR2YkUwcGN1UUMxa1NXTk1RRnJMd0lQSDE0S3IyTGF2NnRMYjJN?=
 =?utf-8?B?a2IwZjN3NnRxYmZhMEUvaTNJSmNHT1hoTHNkTW9CN3dCcmZFLzdhUVVGdHU1?=
 =?utf-8?B?R3oxOGlaSGtyNlR1ZU0yYkZZMUFEUFpCQTJqc2JrK1lqWjFEUXRYYUZFaUlC?=
 =?utf-8?B?UklILzJpZ1B2OExSbkhWTTJUemlRVC9tRk91dXFuVUowYm9XNTNIMk1jM1Mx?=
 =?utf-8?B?NGdsTDcwaFRTNHNjbjBVR1U4U1g1RXh6dXBqcUtlRThNNlZRN0p6STRWMXBx?=
 =?utf-8?B?L0hXYzdxYzljQ2JoOW8xc3JHT2xteW5EdGVFZDMwaWtFdlllSCs4Y2NZR3dH?=
 =?utf-8?B?OGZFQnhJQkZsS2VZQTVhMWQ2U0FTZnJnVE1qWmpBK2MyQjF0bjNncklMVXdp?=
 =?utf-8?B?dVQvcGNYRXlWckRFUFlkQmExcHBZZnpTaVZlWURqS2Z1NDRTMHdWYnhPVFEv?=
 =?utf-8?B?QWhITzFZNnZNdWdObVY5UHh2bk9kZFJjdFRUbDRIRVNZbXBtSUErckVZV3lL?=
 =?utf-8?B?YUFSc2x2d3hDZWwxaENFazJ5bWhzb0VjQWdxd3JFVURaUTlMclpoYjdwNTBy?=
 =?utf-8?B?WXR1RFJoSmZlOCs3SWNVTmg5U3VKY3k2eUlpenBPV1ZWa3lESHhualZ6STRq?=
 =?utf-8?B?WXV4SmZrc3F6em5oK1F6MkhMRTdLVVQwZXowRm5CSUJlWE5vclNibk9xNCs2?=
 =?utf-8?B?aGNYcXJjc3c3ZldHbjUzM1ZIQ1ROYkRBaHhKZHE5Um5HY1FkUDlrMnVEWXgz?=
 =?utf-8?B?bWJYamFZeHJrNVJvM1plbmRweXI0eWF0S1NGQ0Qza3pCZkkweGdSQklQY2Yx?=
 =?utf-8?B?R1l0bzdTaFo2Y2I5WTk0c0hDUmlybGRoY2x4NnJDQ2x0ZFNTS1BZMm1kUy9F?=
 =?utf-8?B?citpTExmcllVNVVPTlhRVnJ2Z1FuT3VjcTVUZHdwd0hVRHlSb0FQM0M1YVZB?=
 =?utf-8?B?K2J1dE4rNlZhY3licmQ0aU80SCswbXU5cWY2UmVGNVdHVlVsSVFBbzBCcWhW?=
 =?utf-8?B?YVVvZ0dOR2kzdnoyQ0RUT1E1TXV3dUlvNFhvVEtLeVJIRi84Q2tkWnZHZGJM?=
 =?utf-8?B?OUpOcXVCcmZUc24rOFdDcGtia3NSS0J4QnZOUkpsbSswR08vckZ6TFRadzdG?=
 =?utf-8?B?MDlLbHpIRjYySUw1QWw3cFVjVklseTY1Tmp4Ym5FdElxV0o1cEI5RnJNVkFh?=
 =?utf-8?B?UmpMOGc3UlRSZWplQ1dkTFN4VUs1T0xsNy80R1VVc2RicEl3Ry9VcGNKczlx?=
 =?utf-8?Q?9wHcqw=3D?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 56380984-f57d-422e-cf46-08d8c4976a56
X-MS-Exchange-CrossTenant-AuthSource: SJ0PR10MB4494.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 29 Jan 2021 20:49:47.7170
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: TwHROFyNf2LDLtqOTiso7DEkF6kHBy4+Ilk4QhHrHvFCLxkLF+r7XUHeN656SU+kAHT32z9D86SgF8hY9IDF/Q==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB4275
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 mlxscore=0 spamscore=0 phishscore=0
 adultscore=0 mlxlogscore=924 malwarescore=0 suspectscore=0 bulkscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290101
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9879 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 malwarescore=0 adultscore=0
 lowpriorityscore=0 mlxlogscore=999 clxscore=1015 phishscore=0 bulkscore=0
 spamscore=0 priorityscore=1501 mlxscore=0 suspectscore=0 impostorscore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2009150000
 definitions=main-2101290102
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 1/29/21 12:44 PM, Shoaib Rao wrote:
>
> On 1/29/21 12:18 PM, Jakub Kicinski wrote:
>> On Fri, 29 Jan 2021 12:10:21 -0800 Shoaib Rao wrote:
>>> On 1/29/21 12:02 PM, Jakub Kicinski wrote:
>>>> On Fri, 29 Jan 2021 11:48:15 -0800 Shoaib Rao wrote:
>>>>> Data was discarded because the flag was not supported, this patch
>>>>> changes that but does not support any urgent data.
>>>> When you say it does not support any urgent data do you mean the
>>>> message len must be == 0 because something is checking it, or that
>>>> the code does not support its handling?
>>>>
>>>> I'm perfectly fine with the former, just point me at the check, 
>>>> please.
>>> The code does not care about the size of data -- All it does is that if
>>> MSG_OOB is set it will deliver the signal to the peer process
>>> irrespective of the length of the data (which can be zero length). 
>>> Let's
>>> look at the code of unix_stream_sendmsg() It does the following 
>>> (sent is
>>> initialized to zero)
>> Okay. Let me try again. AFAICS your code makes it so that data sent
>> with MSG_OOB is treated like any other data. It just sends a signal.
> Correct.
>> So you're hijacking the MSG_OOB to send a signal, because OOB also
>> sends a signal.
> Correct.
>>   But there is nothing OOB about the data itself.
> Correct.
>>   So
>> I'm asking you to make sure that there is no data in the message.
> Yes I can do that.
>> That way when someone wants _actual_ OOB data on UNIX sockets they
>> can implement it without breaking backwards compatibility of the
>> kernel uAPI.
>
> I see what you are trying to achieve. However it may not work.
>
> Let's assume that __actual__ OOB data has been implemented. An 
> application sends a zero length message with MSG_OOB, after that it 
> sends some data (not suppose to be OOB data). How is the receiver 
> going to differentiate if the data an OOB or not.
>
> We could use a different flag (MSG_SIGURG) or implement the _actual_ 
> OOB data semantics (If anyone is interested in it). MSG_SIGURG could 
> be a generic flag that just sends SIGURG irrespective of the length of 
> the data.
>
> Shoaib

There is a relevant issue that I want to point out, Is it acceptable to 
send SIGURG without the receiver having any means to know what the 
urgent condition is?

Shoaib

>
>>
>>> while (sent < len) {
>>>                   size = len - sent;
>>> <..>
>>>
>>> }
>>>
>>>           if (msg->msg_flags & MSG_OOB)
>>>                   sk_send_sigurg(other);
>>>
>>> Before the patch there was a check above the while loop that checked 
>>> the
>>> flag and returned and error, that has been removed.
