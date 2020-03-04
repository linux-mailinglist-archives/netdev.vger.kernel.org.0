Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A723D179670
	for <lists+netdev@lfdr.de>; Wed,  4 Mar 2020 18:13:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729906AbgCDRN0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 4 Mar 2020 12:13:26 -0500
Received: from mail-eopbgr30129.outbound.protection.outlook.com ([40.107.3.129]:14275
        "EHLO EUR03-AM5-obe.outbound.protection.outlook.com"
        rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
        id S1726748AbgCDRN0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 4 Mar 2020 12:13:26 -0500
ARC-Seal: i=1; a=rsa-sha256; s=arcselector9901; d=microsoft.com; cv=none;
 b=jat8PJqtVvo7Oyrp4OWGTIU1hYU8sXy/qnmhdQdTsAlr13+5CtwWRTycj5JiMD3+e2+F3NcwTcA/TgOU2cN8W938rB+I07jwNhQVm1l9JLFQ3Y4ft4PSb3J1V4QiC+Ii7bgMUsT7n+79+/+L2OUOEhiXd9st0zQdO1r3t/sqMsPRtGmxb4zOw54oaklJxjijjlrsArFgWyQTl4tpFnbPJr4EeWgdpZgL6oK0aCg9Q8ToKli5hgOqoPE46B3vJq7ph23+vTzLFIqSxzF86Oc5zD+FiCpJ1HLIyt6v1GOMPEdVjoXXdOSLM+QQOrhp304nI36irGsxvky3nzvQiCFhtg==
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=microsoft.com;
 s=arcselector9901;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnDqXbB677En8ue+4aVadLX8cTTgKy4dlBlAJqNN49E=;
 b=X1qUlCIefIsI9+4ctPQ/gzTxc5hsPqtju4Pe78WwuKRghTC6wKcRdiDVH1ebkq2dgaiBVEtXaoY8On/FmbBSc00DXDc5rBqM9kpo/tHhu+H6ylM92JsC85R7Yswj/FMVt/iDqG9Rbo6EzxDV5hGg+IAcJ0fFRh6GJtqv9Pfwj6dgyFZOUKyT2EssYKj9Mt+ddmSLtvvneHLP2df9Yw8DAgqZYbTiPP45vCz1wK8CKq1QFYAJCGd51bmmTCazQsYdUEfcyvfiupH3Ixpydu0dGD/59+Ki6hYP2YtMY/2RXPYhqt/Yfb5H6j9Udmg5ljZpE8EdHJswzVn7k9l6oUgPsQ==
ARC-Authentication-Results: i=1; mx.microsoft.com 1; spf=pass
 smtp.mailfrom=nokia.com; dmarc=pass action=none header.from=nokia.com;
 dkim=pass header.d=nokia.com; arc=none
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=nokia.onmicrosoft.com;
 s=selector1-nokia-onmicrosoft-com;
 h=From:Date:Subject:Message-ID:Content-Type:MIME-Version:X-MS-Exchange-SenderADCheck;
 bh=BnDqXbB677En8ue+4aVadLX8cTTgKy4dlBlAJqNN49E=;
 b=ZKjPPf5GQg0e6hhxmMM+QgC4vwECfumM1yVsSYSqLYJv6WObsXHfKMiFaKVHezDPyY4GJmAke0d83oMDK/ICg+NtSOoY3Z4vqpwEKysPj+OZN8ULd63EknijY2OoYg6o5wFiHIkxRVe2fRoPQi6OT55LdEbKca/bYutDDTTpyEs=
Authentication-Results: spf=none (sender IP is )
 smtp.mailfrom=jere.leppanen@nokia.com; 
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com (10.167.124.27) by
 HE1PR0702MB3531.eurprd07.prod.outlook.com (10.167.35.160) with Microsoft SMTP
 Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id
 15.20.2793.5; Wed, 4 Mar 2020 17:13:22 +0000
Received: from HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a]) by HE1PR0702MB3610.eurprd07.prod.outlook.com
 ([fe80::fd31:53d3:1e20:be4a%7]) with mapi id 15.20.2793.011; Wed, 4 Mar 2020
 17:13:22 +0000
Date:   Wed, 4 Mar 2020 19:13:14 +0200 (EET)
From:   Jere Leppanen <jere.leppanen@nokia.com>
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
To:     Xin Long <lucien.xin@gmail.com>
cc:     network dev <netdev@vger.kernel.org>,
        "linux-sctp@vger.kernel.org" <linux-sctp@vger.kernel.org>,
        "davem@davemloft.net" <davem@davemloft.net>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Neil Horman <nhorman@tuxdriver.com>,
        "michael.tuexen@lurchi.franken.de" <michael.tuexen@lurchi.franken.de>
Subject: Re: [PATCH net] sctp: return a one-to-one type socket when doing
 peeloff
In-Reply-To: <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
Message-ID: <alpine.LFD.2.21.2003041349400.19073@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net>
References: <b3091c0764023bbbb17a26a71e124d0f81349f20.1583132235.git.lucien.xin@gmail.com> <HE1PR0702MB3610BB291019DD7F51DBC906ECE40@HE1PR0702MB3610.eurprd07.prod.outlook.com> <CADvbK_ewk7mGNr6T4smWeQ0TcW3q4yabKZwGX3dK=XcH7gv=KQ@mail.gmail.com>
Content-Type: text/plain; format=flowed; charset=US-ASCII
X-ClientProxiedBy: AM4P190CA0013.EURP190.PROD.OUTLOOK.COM
 (2603:10a6:200:56::23) To HE1PR0702MB3610.eurprd07.prod.outlook.com
 (2603:10a6:7:7f::27)
MIME-Version: 1.0
X-MS-Exchange-MessageSentRepresentingType: 1
Received: from sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net (131.228.2.10) by AM4P190CA0013.EURP190.PROD.OUTLOOK.COM (2603:10a6:200:56::23) with Microsoft SMTP Server (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_256_GCM_SHA384) id 15.20.2772.16 via Frontend Transport; Wed, 4 Mar 2020 17:13:21 +0000
X-X-Sender: jeleppan@sut4-server4-pub.sut-1.archcommon.nsn-rdnet.net
X-Originating-IP: [131.228.2.10]
X-MS-PublicTrafficType: Email
X-MS-Office365-Filtering-HT: Tenant
X-MS-Office365-Filtering-Correlation-Id: 5cb7bce6-ba30-4ee2-567a-08d7c05f579c
X-MS-TrafficTypeDiagnostic: HE1PR0702MB3531:
X-Microsoft-Antispam-PRVS: <HE1PR0702MB353174D3674BFADBFB173CBCECE50@HE1PR0702MB3531.eurprd07.prod.outlook.com>
X-MS-Oob-TLC-OOBClassifiers: OLM:10000;
X-Forefront-PRVS: 0332AACBC3
X-Forefront-Antispam-Report: SFV:NSPM;SFS:(10019020)(4636009)(39860400002)(136003)(396003)(366004)(376002)(346002)(199004)(189003)(16526019)(66476007)(54906003)(6916009)(4326008)(66556008)(5660300002)(316002)(81156014)(53546011)(86362001)(186003)(6506007)(8676002)(81166006)(66946007)(26005)(6666004)(44832011)(956004)(55016002)(9686003)(2906002)(8936002)(7696005)(52116002)(478600001);DIR:OUT;SFP:1102;SCL:1;SRVR:HE1PR0702MB3531;H:HE1PR0702MB3610.eurprd07.prod.outlook.com;FPR:;SPF:None;LANG:en;PTR:InfoNoRecords;A:1;MX:1;
Received-SPF: None (protection.outlook.com: nokia.com does not designate
 permitted sender hosts)
X-MS-Exchange-SenderADCheck: 1
X-Microsoft-Antispam: BCL:0;
X-Microsoft-Antispam-Message-Info: ftle18DIN3CniwyYG0rEXPp37dkWjRYgjIQMSRWSQPGrQpkGn3Kk5tEN5scniVvT040B9yB+vMBZ8pOgMKJqIXpijQIhXWJnJX4O4dszSmWtUP/XSZ/vTJynyWwwzy/Ods1f9piJ4O6XgXTraDDo7cwOt/B1/9Qhesg4e0CzrReEnjeWvK4LJ+DN6i3jW3pr9/cftHHykvOLNE1DeXdC9zqz/cnevsHbjUrF2Slp/yXV01B8E4BSq4ZkfWzloswUO8fyA891jlDqtcncnBJQKZWd7KWTrvprY4/pk7yworvuBkWMA9S+U5YOPf1GeqnXaear5xH6XjOLHXcR+nMUwBNrjotFS3mc/Oiml8HllCKsZW9MjA1qzCKpSD2Qi/g7kvmTeixuOKckqlV+luXy3vIlt/1r7y7+myqo/kRhxDcA1TpaK6OEAy+3mtAKT5nn6Q1vtjSsAowgmCSD2st9DD+Hy3PPf11uc2o+P5m/18MoPgz+uWZiJuzYlZ5mIUmGjBen6Y8X2f86/ekLaaBSyw==
X-MS-Exchange-AntiSpam-MessageData: kW1AkEsRwQabHzqo+tB8iLYT1U7jvyy3Me5akco/ObAlvfHm2994wQKAoqXUVFv6Kx3kjLpphfudGAbNpaYvEo7lJGeCDREsi2OQxV3R706oZ/bZyBCTIkv4qMhcUEIOGPdprQ6SCZCJX2ZPGiteEw==
X-OriginatorOrg: nokia.com
X-MS-Exchange-CrossTenant-Network-Message-Id: 5cb7bce6-ba30-4ee2-567a-08d7c05f579c
X-MS-Exchange-CrossTenant-OriginalArrivalTime: 04 Mar 2020 17:13:22.2742
 (UTC)
X-MS-Exchange-CrossTenant-FromEntityHeader: Hosted
X-MS-Exchange-CrossTenant-Id: 5d471751-9675-428d-917b-70f44f9630b0
X-MS-Exchange-CrossTenant-MailboxType: HOSTED
X-MS-Exchange-CrossTenant-UserPrincipalName: /LxNDIT4EsedDaZHi3DCbK2sfPVSxJp2r+WQ0ubkFuRamlh37PEsf2xqWJZrYpO/HocQSROJ307WQCKqO+XIzQ==
X-MS-Exchange-Transport-CrossTenantHeadersStamped: HE1PR0702MB3531
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 4 Mar 2020, Xin Long wrote:

> On Wed, Mar 4, 2020 at 2:38 AM Leppanen, Jere (Nokia - FI/Espoo)
> <jere.leppanen@nokia.com> wrote:
>>
>> On Mon, 2 Mar 2020, Xin Long wrote:
>>
>>> As it says in rfc6458#section-9.2:
>>>
>>>   The application uses the sctp_peeloff() call to branch off an
>>>   association into a separate socket.  (Note that the semantics are
>>>   somewhat changed from the traditional one-to-one style accept()
>>>   call.)  Note also that the new socket is a one-to-one style socket.
>>>   Thus, it will be confined to operations allowed for a one-to-one
>>>   style socket.
>>>
>>> Prior to this patch, sctp_peeloff() returned a one-to-many type socket,
>>> on which some operations are not allowed, like shutdown, as Jere
>>> reported.
>>>
>>> This patch is to change it to return a one-to-one type socket instead.
>>
>> Thanks for looking into this. I like the patch, and it fixes my simple
>> test case.
>>
>> But with this patch, peeled-off sockets are created by copying from a
>> one-to-many socket to a one-to-one socket. Are you sure that that's
>> not going to cause any problems? Is it possible that there was a
>> reason why peeloff wasn't implemented this way in the first place?
> I'm not sure, it's been there since very beginning, and I couldn't find
> any changelog about it.
>
> I guess it was trying to differentiate peeled-off socket from TCP style
> sockets.

Well, that's probably the reason for UDP_HIGH_BANDWIDTH style. And maybe 
there is legitimate need for that differentiation in some cases, but I 
think inventing a special socket style is not the best way to handle it.

But actually I meant why is a peeled-off socket created as SOCK_SEQPACKET 
instead of SOCK_STREAM. It could be to avoid copying from SOCK_SEQPACKET 
to SOCK_STREAM, but why would we need to avoid that?

Mark Butler commented in 2006 
(https://sourceforge.net/p/lksctp/mailman/message/10122693/):

     In short, SOCK_SEQPACKET could/should be replaced with SOCK_STREAM
     right there, but there might be a minor dependency or two that would
     need to be fixed.

>
>>
>> With this patch there's no way to create UDP_HIGH_BANDWIDTH style
>> sockets anymore, so the remaining references should probably be
>> cleaned up:
>>
>> ./net/sctp/socket.c:1886:       if (!sctp_style(sk, UDP_HIGH_BANDWIDTH) && msg->msg_name) {
>> ./net/sctp/socket.c:8522:       if (sctp_style(sk, UDP_HIGH_BANDWIDTH))
>> ./include/net/sctp/structs.h:144:       SCTP_SOCKET_UDP_HIGH_BANDWIDTH,
>>
>> This patch disables those checks. The first one ignores a destination
>> address given to sendmsg() with a peeled-off socket - I don't know
>> why. The second one prevents listen() on a peeled-off socket.
> My understanding is:
> UDP_HIGH_BANDWIDTH is another kind of one-to-one socket, like TCP style.
> it can get asoc by its socket when sending msg, doesn't need daddr.

But on that association, the peer may have multiple addresses. The RFC 
says (https://tools.ietf.org/html/rfc6458#section-4.1.8):

     When sending, the msg_name field [...] is used to indicate a preferred
     peer address if the sender wishes to discourage the stack from sending
     the message to the primary address of the receiver.

>
> Now I thinking to fix your issue in sctp_shutdown():
>
> @@ -5163,7 +5163,7 @@ static void sctp_shutdown(struct sock *sk, int how)
>        struct net *net = sock_net(sk);
>        struct sctp_endpoint *ep;
>
> -       if (!sctp_style(sk, TCP))
> +       if (sctp_style(sk, UDP))
>                return;
>
> in this way, we actually think:
> one-to-many socket: UDP style socket
> one-to-one socket includes: UDP_HIGH_BANDWIDTH and TCP style sockets.
>

That would probably fix shutdown(), but there are other problems as well. 
sctp_style() is called in nearly a hundred different places, I wonder if 
anyone systematically went through all of them back when 
UDP_HIGH_BANDWIDTH was added.

I think getting rid of UDP_HIGH_BANDWIDTH altogether is a much cleaner 
solution. That's what your patch does, which is why I like it. But such a 
change could easily break something.
