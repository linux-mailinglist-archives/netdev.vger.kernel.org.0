Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BA89C3D751E
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 14:37:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236529AbhG0MfX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 27 Jul 2021 08:35:23 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:56324 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232013AbhG0MfW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 08:35:22 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 97F70760CD;
        Tue, 27 Jul 2021 15:35:19 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1627389319;
        bh=2Jbg49wm1nKQfWcvmiv4u6oMYFbkwARwVe5gsiANj7o=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=t6uOT/RWSsIBaPT/2Thhyz0E1R1WrBnwkWPceE/rJetuJGDeEYrIIqR2kglWqMdfA
         eM7kOQdBbT19/sDD0c5aehNUlWPS1gE2NP/8SsmJ0GsaPDPVDz3ABP9ma3f5xXSpZv
         TfRyLBbwoZg+oZJL7wVfRK6ZrDnuoKGjlpFmT9J603KyrGSEqnkQB2htdXk+4XWqsG
         ZtjFJgQ1mKoe3gyKInjXZBRxFd6+KZ3WtdW/zkg8cN1mcky3F4uaGUmKUC/kQoJ+US
         NX21bSpzyNegvvY9AI39yjt7n9ApqGYHBTjeOX3+lfwxJM+4TAs+3Hi4jI//JBBU3k
         1CnUY0W1Pjv8g==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id D864C760A0;
        Tue, 27 Jul 2021 15:35:18 +0300 (MSK)
Received: from [10.16.171.77] (10.64.64.121) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2308.14; Tue, 27
 Jul 2021 15:35:07 +0300
Subject: Re: [MASSMAIL KLMS] Re: [MASSMAIL KLMS] Re: [RFC PATCH v1 0/7]
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
 <20210727075948.yl4w3foqa6rp4obg@steredhat>
 <2df68589-96b9-abd4-ad1c-e25918b908a9@kaspersky.com>
 <20210727095803.s26subp3pgclqzvi@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <2f2d580f-75b4-91c8-cbd5-ad15d7a7ec21@kaspersky.com>
Date:   Tue, 27 Jul 2021 15:35:06 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210727095803.s26subp3pgclqzvi@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.64.121]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 07/27/2021 11:50:20
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 165274 [Jul 27 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 449 449 5db59deca4a4f5e6ea34a93b13bc730e229092f4
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 07/27/2021 11:55:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 27.07.2021 11:26:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/07/27 10:45:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/07/27 11:28:00 #16963359
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 27.07.2021 12:58, Stefano Garzarella wrote:
> Caution: This is an external email. Be cautious while opening links or attachments.
>
>
>
> On Tue, Jul 27, 2021 at 12:34:36PM +0300, Arseny Krasnov wrote:
>> On 27.07.2021 10:59, Stefano Garzarella wrote:
>>> Caution: This is an external email. Be cautious while opening links or attachments.
>>>
>>>
>>>
>>> On Mon, Jul 26, 2021 at 07:31:33PM +0300, Arseny Krasnov wrote:
>>>>       This patchset implements support of MSG_EOR bit for SEQPACKET
>>>> AF_VSOCK sockets over virtio transport.
>>>>       Idea is to distinguish concepts of 'messages' and 'records'.
>>>> Message is result of sending calls: 'write()', 'send()', 'sendmsg()'
>>>> etc. It has fixed maximum length, and it bounds are visible using
>>>> return from receive calls: 'read()', 'recv()', 'recvmsg()' etc.
>>>> Current implementation based on message definition above.
>>>>       Record has unlimited length, it consists of multiple message,
>>>> and bounds of record are visible via MSG_EOR flag returned from
>>>> 'recvmsg()' call. Sender passes MSG_EOR to sending system call and
>>>> receiver will see MSG_EOR when corresponding message will be processed.
>>>>       To support MSG_EOR new bit was added along with existing
>>>> 'VIRTIO_VSOCK_SEQ_EOR': 'VIRTIO_VSOCK_SEQ_EOM'(end-of-message) - now it
>>>> works in the same way as 'VIRTIO_VSOCK_SEQ_EOR'. But 'VIRTIO_VSOCK_SEQ_EOR'
>>>> is used to mark 'MSG_EOR' bit passed from userspace.
>>> At this point it's probably better to rename the old flag, so we stay
>>> compatible.
>>>
>>> What happens if one of the two peers does not support MSG_EOR handling,
>>> while the other does?
>>>
>>> I'll do a closer review in the next few days.
>> Thank You, also i think MSG_EOR support must be described in spec
> Yep, sure!
>
> What do you think about the concerns above?
I think you are right, i'll rename EOR -> EOM, and EOR will be added by patch
>
> Stefano
>
>
