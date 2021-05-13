Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D1B8137F9DF
	for <lists+netdev@lfdr.de>; Thu, 13 May 2021 16:42:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234644AbhEMOnk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 May 2021 10:43:40 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:17219 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234612AbhEMOnc (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 May 2021 10:43:32 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id D1CEA76B06;
        Thu, 13 May 2021 17:42:17 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1620916937;
        bh=cvAMnx0j++B1S8leH4A1OKRsY7smTmc8AgAE5OIS9I4=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=AJV/oPhBxPeSXQTp7h5iU4XEl/9kQxybmZxxptz9sl3t58uSxq9ezah0ca0Lhf8f0
         fuxnsiWJK7qHXXUe5ISsLzh+LyWobf81qsw32tPwQgKmFpTfVMUH/EqobqcbV+ExlX
         f08xATMR2lUOi3qFkdD6d4DbF7AVkMIlxI06lKPGbOKXBm2aa/l7a1eqhSq1dbhwmY
         pnHBqViLgbNegyYyKYN3dRqI/SIn1X5pEtNgMuG3gXCbdhfBlAm4aSOkWQ7tPL4e/u
         ICfnubqBZspBk7P/MK8O7NTfbktJlCI/wzgqRBA6Ozes32wq9iAUBJFCbN/49ABI/A
         B4d8qGsshw+pQ==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 7F4707693F;
        Thu, 13 May 2021 17:42:17 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.2; Thu, 13
 May 2021 17:42:16 +0300
Subject: Re: [RFC PATCH v9 10/19] virtio/vsock: defines and constants for
 SEQPACKET
To:     Stefano Garzarella <sgarzare@redhat.com>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jorgen Hansen <jhansen@vmware.com>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210508163027.3430238-1-arseny.krasnov@kaspersky.com>
 <20210508163508.3431890-1-arseny.krasnov@kaspersky.com>
 <20210513114543.hucvkhky3tlmvabl@steredhat>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <5c077288-8380-3d71-1958-59254b4d8dc4@kaspersky.com>
Date:   Thu, 13 May 2021 17:42:16 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210513114543.hucvkhky3tlmvabl@steredhat>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 05/13/2021 14:30:02
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 163644 [May 13 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 445 445 d5f7ae5578b0f01c45f955a2a751ac25953290c9
X-KSE-AntiSpam-Info: {Tracking_uf_ne_domains}
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: lists.oasis-open.org:7.1.1;kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 05/13/2021 14:33:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 13.05.2021 13:39:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/05/13 13:03:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/05/13 10:44:00 #16575454
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 13.05.2021 14:45, Stefano Garzarella wrote:
> On Sat, May 08, 2021 at 07:35:05PM +0300, Arseny Krasnov wrote:
>> This adds set of defines and constants for SOCK_SEQPACKET
>> support in vsock. Here is link to spec patch, which uses it:
>>
>> https://lists.oasis-open.org/archives/virtio-comment/202103/msg00069.html
> Will you be submitting a new version?
Yes, i'll send new patch to spec in next few days.
>
>> Signed-off-by: Arseny Krasnov <arseny.krasnov@kaspersky.com>
>> ---
>> include/uapi/linux/virtio_vsock.h | 9 +++++++++
>> 1 file changed, 9 insertions(+)
>>
>> diff --git a/include/uapi/linux/virtio_vsock.h b/include/uapi/linux/virtio_vsock.h
>> index 1d57ed3d84d2..3dd3555b2740 100644
>> --- a/include/uapi/linux/virtio_vsock.h
>> +++ b/include/uapi/linux/virtio_vsock.h
>> @@ -38,6 +38,9 @@
>> #include <linux/virtio_ids.h>
>> #include <linux/virtio_config.h>
>>
>> +/* The feature bitmap for virtio vsock */
>> +#define VIRTIO_VSOCK_F_SEQPACKET	1	/* SOCK_SEQPACKET supported */
>> +
>> struct virtio_vsock_config {
>> 	__le64 guest_cid;
>> } __attribute__((packed));
>> @@ -65,6 +68,7 @@ struct virtio_vsock_hdr {
>>
>> enum virtio_vsock_type {
>> 	VIRTIO_VSOCK_TYPE_STREAM = 1,
>> +	VIRTIO_VSOCK_TYPE_SEQPACKET = 2,
>> };
>>
>> enum virtio_vsock_op {
>> @@ -91,4 +95,9 @@ enum virtio_vsock_shutdown {
>> 	VIRTIO_VSOCK_SHUTDOWN_SEND = 2,
>> };
>>
>> +/* VIRTIO_VSOCK_OP_RW flags values */
>> +enum virtio_vsock_rw {
>> +	VIRTIO_VSOCK_SEQ_EOR = 1,
>> +};
>> +
>> #endif /* _UAPI_LINUX_VIRTIO_VSOCK_H */
>> -- 
>> 2.25.1
>>
> Looks good:
>
> Reviewed-by: Stefano Garzarella <sgarzare@redhat.com>
>
>
