Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 58D6B3773A6
	for <lists+netdev@lfdr.de>; Sat,  8 May 2021 20:33:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229650AbhEHSe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 8 May 2021 14:34:26 -0400
Received: from userp2130.oracle.com ([156.151.31.86]:37210 "EHLO
        userp2130.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229489AbhEHSeX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 8 May 2021 14:34:23 -0400
Received: from pps.filterd (userp2130.oracle.com [127.0.0.1])
        by userp2130.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148IU4KK046455;
        Sat, 8 May 2021 18:32:43 GMT
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=oracle.com; h=subject : to : cc :
 references : from : message-id : date : in-reply-to : content-type :
 content-transfer-encoding : mime-version; s=corp-2020-01-29;
 bh=L85oM6gpwWx0bE0I+Gh/Z7LdyxK2L50viS3EzBc7EpY=;
 b=mjTriBBH31SwcELACQJkavKtRmbi1RFUIcO7VyDXixXNQn/JjnbbgT9jf1dAwayH/PAW
 o8NFn1VAcdA/QMmnQFJJivUcHgzQTaIiOof3/aZRvlfBUi7nYey/HccD4lJGjRSjH2hT
 xrVwd5AfmWfeSUAjbMbT5XVNa0PPZQPSnDIQXifdSzFQDuCgHiA+4nfSipNJkakdfc+6
 ZFx+068JHpODCVGRihQ5Nzt0ny6M11fcjCLu24YpxHYCBYrCscqgQ4CiNRSN4+6Kfjdb
 ugkWfaf3z8CYmQ53zkzeqYPHdS9avR9hWDi9deLj+GQJjb7hAWV4qrKZDdVDnsLAFvR7 uw== 
Received: from aserp3020.oracle.com (aserp3020.oracle.com [141.146.126.70])
        by userp2130.oracle.com with ESMTP id 38dj2r0p5b-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 May 2021 18:32:43 +0000
Received: from pps.filterd (aserp3020.oracle.com [127.0.0.1])
        by aserp3020.oracle.com (8.16.0.42/8.16.0.42) with SMTP id 148IUSjE113921;
        Sat, 8 May 2021 18:32:42 GMT
Received: from nam02-dm3-obe.outbound.protection.outlook.com (mail-dm3nam07lp2047.outbound.protection.outlook.com [104.47.56.47])
        by aserp3020.oracle.com with ESMTP id 38djf1qmuu-1
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=OK);
        Sat, 08 May 2021 18:32:42 +0000
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=HtG2ZwVTUjQOCUcYluHllYS6+kl+pck58YiUTNAbiKcCecxdCwfG3zin5KmY+Esy+pdEw5wHv2YaTPX5VGgp20Bz12d4OhSH8TfmEYPuOR0SDv0mUeOqRxRHfao+QPXyfKQ2u/fOtN5fKieHiSrKaRFckrJB62q8jwWlSmgxw/+pmNrii8sKHndO4b+IJN2SUtO/pXRXLDv3bekclRlfz1Gyl9Mysvd1hzyk7xvSD2FgBjJ+qDjH39Jd8DlTb3BBktIEhVNOiRu9fpgZGk16STBorgszqSial29gbIVhOchweA2+DRDYXqxyFUAfZ7GQGx61BX+Arsg49TUzYwLF2w==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L85oM6gpwWx0bE0I+Gh/Z7LdyxK2L50viS3EzBc7EpY=;
 b=lNxr6ExdqflinZf3zGTI4Um7QOohNB1XoGr32Ck70zMYqrhE+pubmPwM4ft3A1GNGx8GjmUiampAOrccQkIw13+k8PDVgF7qtg9P3xIZHXEeEIaGWXQbAzTUyf714wq0C1QyXcjssL7iOFDSTppJyeO4lyDwcvkp9AClufH2DaUb+wGNCA1US8R8zp+oi84TgdKhZdBIWDbRkuGeSTW7hc5zV1DKVnb/FTqVk7o0vfJHcYwZdXLyfcgQO8MQ6dtR4kEQQ6PXcY4I2x/rYTsOS2jmaFdlCcKMJfnF3L8uCDiK0WMCXdTMcDWq8YXQFXG6vcYgbkBeBDf8yUaIjE3QnA==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=oracle.com; dmarc=pass action=none header.from=oracle.com;
 dkim=pass header.d=oracle.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
 d=oracle.onmicrosoft.com; s=selector2-oracle-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=L85oM6gpwWx0bE0I+Gh/Z7LdyxK2L50viS3EzBc7EpY=;
 b=RUvwObmBZ1IiEtjcgMOdphqSPWLU8pWYh97qO+iA16PeyloeUaJP0xp7d4eQwW7FEFiBOYqcTpa/S2/t9ByBqfcqcyX8H09ELuPV88Xm4kSuCBr9BNy13QR70UKN3oigf8NMZXa02hwLJb8QFAE+JFKGof6ICff1ZEu+qoOzDdY=
Authentication-Results: davemloft.net; dkim=none (message not signed)
 header.d=none;davemloft.net; dmarc=none action=none header.from=oracle.com;
Received: from BYAPR10MB3573.namprd10.prod.outlook.com (20.179.63.32) by
 BY5PR10MB3938.namprd10.prod.outlook.com (52.133.255.89) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.4108.24; Sat, 8 May 2021 18:32:39 +0000
Received: from BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4]) by BYAPR10MB3573.namprd10.prod.outlook.com
 ([fe80::50bb:7b66:35ee:4a4%7]) with mapi id 15.20.4108.030; Sat, 8 May 2021
 18:32:39 +0000
Subject: Re: [RFC][PATCH] vhost/vsock: Add vsock_list file to map cid with
 vhost tasks
To:     Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc:     Joel Fernandes <joelaf@google.com>, kvm@vger.kernel.org,
        "Michael S. Tsirkin" <mst@redhat.com>, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org,
        Linux Trace Devel <linux-trace-devel@vger.kernel.org>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20210505163855.32dad8e7@gandalf.local.home>
From:   Mike Christie <michael.christie@oracle.com>
Message-ID: <b21a00f5-b3fc-ba01-0660-a1decadaff6f@oracle.com>
Date:   Sat, 8 May 2021 13:32:36 -0500
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.10.1
In-Reply-To: <20210505163855.32dad8e7@gandalf.local.home>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Originating-IP: [73.88.28.6]
X-ClientProxiedBy: DM5PR19CA0062.namprd19.prod.outlook.com
 (2603:10b6:3:116::24) To BYAPR10MB3573.namprd10.prod.outlook.com
 (2603:10b6:a03:11e::32)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from [20.15.0.204] (73.88.28.6) by DM5PR19CA0062.namprd19.prod.outlook.com (2603:10b6:3:116::24) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.4108.25 via Frontend Transport; Sat, 8 May 2021 18:32:38 +0000
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-Correlation-Id: e83f908b-015f-49b8-3f5b-08d9124fa89c
X-MS-TrafficTypeDiagnostic: BY5PR10MB3938:
X-Microsoft-Antispam-PRVS: <BY5PR10MB3938A3824A69955EC9EC9BE9F1569@BY5PR10MB3938.namprd10.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftv731o7rVyG+R82/a0XosZvFLm+k6x7M2SuCsjqUtrCqpgW3XV0DRZAjNiTagoPPWACqwwBvN54wo8wPEbX0N/BaPndrIruHHdDkhRDhYiQa8cV8tI8ZbGmjeHX4BERy1rnR3zbNqopgwpnWPQYN/0rxdwzCUsKdtevoMu+br9pjmAF16HRt3iWIpsXsd1YTleIpxfYmaS1Ij9SYnzSAUwEjHM479376E6caDEs971H37a65arOai+7Ee3NYLc4aNxMk+KIACJ9dW3z+nTBkrJteMF+OiSpBl5COjtXTraLLW3FTKUMNfqE61JeGwULOUzYH0zEsMMwFWdI1GDIyfzcdyOBEmOPgGyMImkVqYcGWNs1Cp0kWtC16uuaVtFoKR2F4hXK9gNrtnb+602nX3lrV+6NsRde9wvflRTjcIcb7S5hR78DeLX3L7/F1cyOiqSu7n7DpaKXZJidE4zYTLYcXZKoCseMJbwhJa5UoeDUFHrMWd6I5oMtlRtWpVu4m+O4xNiesME5eLrLTBshdLJRmcaD5r7BGxzmTi+aaZCGk1gaQ73nJIAdjQS2E2HRBeXs0ZLgCAWyzeOnEHJoD1I6yydqphBz3a4cYxh+CY4/KDwaXcCZzwwCm7KLJ78iPwWijxb9FCvIJVl4azJJwtRs1R9en/06+W5SnVg8OZnmFi8hPGGiSSgbfCtbpdGQp28DL646+QJAoz3G5EtOjvJfzzPo6CDtBNfIMgzWtnfZGEr6ABXvhTqhNI2K4UFN6neL9PGVMWc/OdqD9guFWy/rcMfXB5Z1ot5CP5mjTi8=
X-Forefront-Antispam-Report: CIP:255.255.255.255;CTRY:;LANG:en;SCL:1;SRV:;IPV:NLI;SFV:NSPM;H:BYAPR10MB3573.namprd10.prod.outlook.com;PTR:;CAT:NONE;SFS:(396003)(366004)(39850400004)(136003)(376002)(346002)(66556008)(4326008)(66476007)(8676002)(16526019)(36756003)(7416002)(16576012)(6486002)(186003)(53546011)(86362001)(2616005)(956004)(8936002)(31686004)(26005)(66946007)(6706004)(316002)(54906003)(2906002)(478600001)(83380400001)(31696002)(966005)(110136005)(5660300002)(38100700002)(78286007)(45980500001)(43740500002);DIR:OUT;SFP:1101;
X-MS-Exchange-AntiSpam-MessageData: =?utf-8?B?djNrSGlEeTZhNlBsQW9IQ29jQk5JdGhMM1piOHpFQ0lrT3hjN1hVS2g3RUJx?=
 =?utf-8?B?emJ3MVRmVHZyZzdLU0NoVXA3dnBxdkRuL1hxMTFneUdPQ3VITll0dkU0SklX?=
 =?utf-8?B?UWNSSDlZd3ZES2NzSUptaVF3YlQ3UnNyekdKNndDQlJMdWxZWnczZ0hFbWtT?=
 =?utf-8?B?aW0wVDhmM3RmRzRpSzhkUUlmVEk1OTJyNEcrbXY1ODR2OFNkVkZabHY2NEo3?=
 =?utf-8?B?bVhLMkJub2d0dXAvNytobTBQZ0t0SWgxYzVZWTJXVEx1WGRObFdJa2RrTDNP?=
 =?utf-8?B?TG4wRzJ1Mk5lTVIyM2RuYjdMNDRIdHd1L3R4UkRDT28vRjRrWERaYk5DMTNZ?=
 =?utf-8?B?QkVXMnBVSm5zem1hTXVPMTA4ZXRpK0NCaXlhVDRxK2IzRkFmWTR2QlFXNndI?=
 =?utf-8?B?TU9yeUgrbVFMVERndFpqMjFQbkdCK0dYYWtEWDhJM2tDOXdDL0VVSEM5L212?=
 =?utf-8?B?VFNJWGtKZDdGSnRNOUpuRklnNEtGR0g0dEpsTnZ4b1RMUkxRWHZYdlVSMHgw?=
 =?utf-8?B?NkJ5c1MvVUc3a2Y2T2NGbW5FQXV5MXIrM0ZaVWJxTkV4N0tCY0RFdkQrUXV1?=
 =?utf-8?B?SUpsY2hBN25jSWZYd0RpYnR2RlBYMmtuKzVaZmdWc1lOc3MwcXpNNkhuQUR6?=
 =?utf-8?B?M1kzNzZMSDNZY0M2YlZ5Z3hmT2FTcEhaVWoxYWtzNHhNanNYOEhxZkI5WDRD?=
 =?utf-8?B?b0ZLSEEwVm5LbzA0WmF4TVZ5WXhYSk5Da1Zvb2JIOVR2WDVYWUtLOUNYd29J?=
 =?utf-8?B?bGYyRmVMajArOUZ4Wnp0aWVBeDdjYWxveW5lNm9BZ1dLejF6YzlQLzNaUzBn?=
 =?utf-8?B?ZGRZblNrUUZaSlVJajBQZTFCRWdqem9ueDB2VHdodFUwdUhHZTFGVzh2QjRT?=
 =?utf-8?B?VEt0T0FXbHUrRkV5YlQ0dmI2RE03eEVYVVViV1laS3lrSHNwZFNQV0UwVUxv?=
 =?utf-8?B?bXRDUW41S1BZWk1YZ0Z4OExabnJNWDAvODFiQnFYWEs1V2wzRm5GbXRsSFBq?=
 =?utf-8?B?TFJ5eDMvUFFnUGNhekFpZTVySWJLb2VhbzFPUjNBZlo1Y1c2Z2NZcWtDN0Uw?=
 =?utf-8?B?V0RwQjdGTmc5SDVKbjVUcUd4TVk2V0hPOUt5Sm5lTVlwN2xmRHZ2cXpFaHN2?=
 =?utf-8?B?K2k1QXRPUDZUcGRmb2FnUVNkMGxIRm9PZzRaMGpKQzE4REwzQTRKM0JXdkxE?=
 =?utf-8?B?WGlOVUVOazl5NFZoRTBOT3VFZnZwNEtIczNESjl5cmFZdEJldGMwbU42NkUy?=
 =?utf-8?B?TVQ1WGdIT0c0ejMwSTM5SFlaSHByRTFYSkNCekhXaGVxNjViN3Y5QXlpa01x?=
 =?utf-8?B?QU1TOEk2T3FJM3lCSVEvWUcvb0w5QUhxcHI4Tm9uWUZlaXdiOHJLL1dBWmFw?=
 =?utf-8?B?VHpXQUNmTlVmaWpmclU0Z0o2dlBWVG5DaUsxUWhQMXVVR0M1S1VaOEQzMVVi?=
 =?utf-8?B?NUNuQU91MWU4M1VCZUYvT2dPakRFNTVrVWZnR2FLbk14UlI2SS9iMlVyb1Z0?=
 =?utf-8?B?WGdjUm5lNmJUNEZMYUxUYTh2RXFXZkRlVTdmYlBYMWI3d1pIMzAxMk5DOXNI?=
 =?utf-8?B?N1RpU3lxbWl4eHNOYmtlYVlSVThhNlg1U2VCL0RtVm1UN1lHakFsTGRXVjFs?=
 =?utf-8?B?aDBveVl3aVFvempJc2k1bVQ3NjJFdHhUYXhHd1lBR1NRYzhFZjFDeTJDakJB?=
 =?utf-8?B?amZVQ3M5MUdUVFpKR3JJUVRhbFlUdFJ6a1M5dFlnTlA0RTRjdjVpTGduRkFo?=
 =?utf-8?Q?K92fs2w2B2TuUEh2PDPfzKsMThP+lI1MkL5e4wZ?=
X-OriginatorOrg: oracle.com
X-MS-Exchange-CrossTenant-Network-Message-Id: e83f908b-015f-49b8-3f5b-08d9124fa89c
X-MS-Exchange-CrossTenant-AuthSource: BYAPR10MB3573.namprd10.prod.outlook.com
X-MS-Exchange-CrossTenant-AuthAs: Internal
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 08 May 2021 18:32:39.3922
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 4e2c6054-71cb-48f1-bd6c-3a9705aca71b
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: iAIKS95sep2VU0o/8zBO7JwMuCUQzluK3cT6Gfr3eU7xpIw5CHgG/aVUohVMCPOzu91AR2sy4Na7dklwIZFlTy+J01YO6xaItQmqbrOE+iQ=
X-MS-Exchange-Transport-CrossTenantHeadersStamped: BY5PR10MB3938
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9978 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 bulkscore=0 spamscore=0 mlxlogscore=999
 adultscore=0 phishscore=0 mlxscore=0 suspectscore=0 malwarescore=0
 classifier=spam adjust=0 reason=mlx scancount=1 engine=8.12.0-2104190000
 definitions=main-2105080149
X-Proofpoint-ORIG-GUID: 5DyZPCaJIgg-OECBLVJGLIBwr7M_4oMu
X-Proofpoint-GUID: 5DyZPCaJIgg-OECBLVJGLIBwr7M_4oMu
X-Proofpoint-Virus-Version: vendor=nai engine=6200 definitions=9978 signatures=668683
X-Proofpoint-Spam-Details: rule=notspam policy=default score=0 clxscore=1011 spamscore=0
 suspectscore=0 mlxscore=0 phishscore=0 lowpriorityscore=0 malwarescore=0
 adultscore=0 impostorscore=0 priorityscore=1501 bulkscore=0
 mlxlogscore=999 classifier=spam adjust=0 reason=mlx scancount=1
 engine=8.12.0-2104190000 definitions=main-2105080149
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 5/5/21 3:38 PM, Steven Rostedt wrote:
> The new trace-cmd 3.0 (which is almost ready to be released) allows for
> tracing between host and guests with timestamp synchronization such that
> the events on the host and the guest can be interleaved in the proper order
> that they occur. KernelShark now has a plugin that visualizes this
> interaction.
> 
> The implementation requires that the guest has a vsock CID assigned, and on
> the guest a "trace-cmd agent" is running, that will listen on a port for
> the CID. The on the host a "trace-cmd record -A guest@cid:port -e events"
> can be called and the host will connect to the guest agent through the
> cid/port pair and have the agent enable tracing on behalf of the host and
> send the trace data back down to it.
> 
> The problem is that there is no sure fire way to find the CID for a guest.
> Currently, the user must know the cid, or we have a hack that looks for the
> qemu process and parses the --guest-cid parameter from it. But this is
> prone to error and does not work on other implementation (was told that
> crosvm does not use qemu).
> 
> As I can not find a way to discover CIDs assigned to guests via any kernel
> interface, I decided to create this one. Note, I'm not attached to it. If
> there's a better way to do this, I would love to have it. But since I'm not
> an expert in the networking layer nor virtio, I decided to stick to what I
> know and add a debugfs interface that simply lists all the registered CIDs
> and the worker task that they are associated with. The worker task at
> least has the PID of the task it represents.
> 
> Now I can find the cid / host process in charge of the guest pair:
> 
>   # cat /sys/kernel/debug/vsock_list
>   3	vhost-1954:2002
> 

I think I need the same thing for vhost-scsi. We want to know a vhost-scsi
devs worker thread's pid. If we use multiple vhost-devs in one VM then we
wanted to be able to know which thread goes with which dev.

For the vhost thread patches I added an ioctl:

https://lists.linuxfoundation.org/pipermail/virtualization/2021-April/054014.html

but I had originally implemented it in sysfs. For sysfs we can add a struct
device in the vhost_dev and struct deice in the vhost_virtqueue. We then
have a 2 new classes /sys/class/vhost_device and vhost_virtqueue with the
vhost_device device the parent of vhost_virtqueue device.

The nice thing is that it's a common interface and works for every vhost_dev
and all their virtqueues. It works for non libvirt users.

The drawback is adding in refcounts/releases and that type of code for the
vhost_dev and vhost_virtqueue. Also I'm not sure about security.

Note that I'm not tied to sysfs. netlink would be fine. I just need any
interface.
