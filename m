Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A0B463E1137
	for <lists+netdev@lfdr.de>; Thu,  5 Aug 2021 11:22:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234535AbhHEJWQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Aug 2021 05:22:16 -0400
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:34166 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230407AbhHEJWP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 5 Aug 2021 05:22:15 -0400
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 1CFC952100E;
        Thu,  5 Aug 2021 12:21:59 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1628155319;
        bh=q/nY3mg1zoRXBa0CkWMzDyLWbxj4TJMvTsYS6U//0C8=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=59gj2U5kMTfsdWIG3jmKnGdW//PoxQFzmRmaBc8MbKMMlzg3LfbNLudEgGdE8MFQw
         6PgLJVOmgRWkgFwRf5IsnUk0JQXLVDDe4zdd985NxP2wDklcgGFPFNIy+UIM52Eq9I
         QVfpifDcuOKC1iQU8NOdYdbwvMFGRQlbwRJP0JYsjtU4BB/wa9BBmWSmHjlvp+rhxO
         XmBUZYjZFnBmE2QEYViW8HKyxZlCfVivVvgSmC1jm/LljKJXabeFgGCQD6Be6gpYDn
         p8uwEirsWgTRwwZsyMJtp4hnHEi+Kg87QWfND1ZIEDIHWaWMToUGtFWH1Jh84inaqg
         kmH6hR7cWRq2Q==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 5B88D521014;
        Thu,  5 Aug 2021 12:21:58 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Thu, 5
 Aug 2021 12:21:57 +0300
Subject: Re: [!!Mass Mail KSE][MASSMAIL KLMS] Re: [RFC PATCH v1 0/7]
 virtio/vsock: introduce MSG_EOR flag for SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Colin Ian King <colin.king@canonical.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210726163137.2589102-1-arseny.krasnov@kaspersky.com>
 <20210804125737.kbgc6mg2v5lw25wu@steredhat>
 <8e44442c-4cac-dcbc-a88d-17d9878e7d32@kaspersky.com>
 <20210805090657.y2sz3pzhruuolncq@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <8bd80d3f-3e00-5e31-42a1-300ff29100ae@kaspersky.com>
Date:   Thu, 5 Aug 2021 12:21:57 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210805090657.y2sz3pzhruuolncq@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 08/05/2021 09:11:24
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165423 [Aug 05 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: pubs.opengroup.org:7.1.1;kaspersky.com:7.1.1;127.0.0.199:7.1.2;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 08/05/2021 09:13:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 04.08.2021 22:55:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/08/05 08:35:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/08/04 22:55:00 #16982736
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 05.08.2021 12:06, Stefano Garzarella wrote:
> Caution: This is an external email. Be cautious while opening links or attachments.
>
>
>
> On Thu, Aug 05, 2021 at 11:33:12AM +0300, Arseny Krasnov wrote:
>> On 04.08.2021 15:57, Stefano Garzarella wrote:
>>> Caution: This is an external email. Be cautious while opening links or attachments.
>>>
>>>
>>>
>>> Hi Arseny,
>>>
>>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>>> AF_VSOCK sockets over virtio transport.
>>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>>> etc. It has fixed maximum length, and it bounds are visible using
>>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>>> Current implementation based on message definition above.
>>> Okay, so the implementation we merged is wrong right?
>>> Should we disable the feature bit in stable kernels that contain it? Or
>>> maybe we can backport the fixes...
>> Hi,
>>
>> No, this is correct and it is message boundary based. Idea of this
>> patchset is to add extra boundaries marker which i think could be
>> useful when we want to send data in seqpacket mode which length
>> is bigger than maximum message length(this is limited by transport).
>> Of course we can fragment big piece of data too small messages, but
>> this
>> requires to carry fragmentation info in data protocol. So In this case
>> when we want to maintain boundaries receiver calls recvmsg() until
>> MSG_EOR found.
>> But when receiver knows, that data is fit in maximum datagram length,
>> it doesn't care about checking MSG_EOR just calling recv() or
>> read()(e.g.
>> message based mode).
> I'm not sure we should maintain boundaries of multiple send(), from
> POSIX standard [1]:

Yes, but also from POSIX: such calls like send() and sendmsg()

operates with "message" and if we check recvmsg() we will

find the following thing:


For message-based sockets, such as SOCK_DGRAM and SOCK_SEQPACKET, the entire

message shall be read in a single operation. If a message is too long to fit in the supplied

buffers, and MSG_PEEK is not set in the flags argument, the excess bytes shall be discarded.


I understand this, that send() boundaries also must be maintained.

I've checked SEQPACKET in AF_UNIX and AX_25 - both doesn't support

MSG_EOR, so send() boundaries must be supported.

>
>    SOCK_SEQPACKET
>      Provides sequenced, reliable, bidirectional, connection-mode
>      transmission paths for records. A record can be sent using one or
>      more output operations and received using one or more input
>      operations, but a single operation never transfers part of more than
>      one record. Record boundaries are visible to the receiver via the
>      MSG_EOR flag.
>
>  From my understanding a record could be sent with multiple send() and
> received, for example, with a single recvmsg().
> The only boundary should be the MSG_EOR flag set by the user on the last
> send() of a record.
You are right, if we talking about "record".
>
>  From send() description [2]:
>
>    MSG_EOR
>      Terminates a record (if supported by the protocol).
>
>  From recvmsg() description [3]:
>
>    MSG_EOR
>      End-of-record was received (if supported by the protocol).
>
> Thanks,
> Stefano
>
> [1]
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/socket.html
> [2] https://pubs.opengroup.org/onlinepubs/9699919799/functions/send.html
> [3]
> https://pubs.opengroup.org/onlinepubs/9699919799/functions/recvmsg.html

P.S.: seems SEQPACKET is too exotic thing that everyone implements it in

own manner, because i've tested SCTP seqpacket implementation, and found

that:

1) It doesn't support MSG_EOR bit at send side, but uses MSG_EOR at receiver

side to mark MESSAGE boundary.

2) According POSIX any extra bytes that didn't fit in user's buffer must be dropped,

but SCTP doesn't drop it - you can read rest of datagram in next calls.

>
>
