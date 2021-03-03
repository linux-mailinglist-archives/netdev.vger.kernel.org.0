Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 21BE832C449
	for <lists+netdev@lfdr.de>; Thu,  4 Mar 2021 01:53:19 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1389042AbhCDAMZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 3 Mar 2021 19:12:25 -0500
Received: from mx13.kaspersky-labs.com ([91.103.66.164]:31931 "EHLO
        mx13.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348477AbhCCMFQ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 3 Mar 2021 07:05:16 -0500
Received: from relay13.kaspersky-labs.com (unknown [127.0.0.10])
        by relay13.kaspersky-labs.com (Postfix) with ESMTP id 50F76521376;
        Wed,  3 Mar 2021 13:42:28 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1614768148;
        bh=9y/BJdUHyFlRN7zac60l/id5LHRMFKNykaUU53/wMDw=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=RozWfglqTR+416IePLAMDg0840KvM0it659pfzn4DFGiBGQTnA8L3VqYI0Gu8aLj+
         bmzaja6Sxl1AjUKcBZbSnltzcD1gx8jk57rAthPy7VsUGAV67vUgNsSWbYd0Spi62O
         EEkF5ohI6l7nTo6bwu6eDV+zZwWypgNNocd+S80I5smXdbf7A24+vt2oZNSiU4Oo3L
         uqGvwCva1KeDvrCj/HT1bFIj/hCs1413iaPumgf2adJ62Ow0d0b9BDeWcMs9eYdbKK
         WTiWICKkO9LLisHNbplxvUmH9IvNLeOWGUnKGfYkgLc96WvjHdMKmEz2J4a/VuDdB2
         Sut6l4LxZVbFw==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub13.kaspersky-labs.com (Postfix) with ESMTPS id 51BC3521259;
        Wed,  3 Mar 2021 13:42:27 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2044.4; Wed, 3 Mar
 2021 13:42:26 +0300
Subject: Re: [RFC PATCH v5 19/19] virtio/vsock: update trace event for
 SEQPACKET
To:     Steven Rostedt <rostedt@goodmis.org>
CC:     Stefan Hajnoczi <stefanha@redhat.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Jorgen Hansen <jhansen@vmware.com>,
        Norbert Slusarek <nslusarek@gmx.net>,
        Andra Paraschiv <andraprs@amazon.com>,
        Colin Ian King <colin.king@canonical.com>,
        "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "stsp2@yandex.ru" <stsp2@yandex.ru>,
        "oxffffaa@gmail.com" <oxffffaa@gmail.com>
References: <20210218053347.1066159-1-arseny.krasnov@kaspersky.com>
 <20210218054219.1069224-1-arseny.krasnov@kaspersky.com>
 <20210302172542.605b3795@gandalf.local.home>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <c80f403d-9fec-dd78-bb91-44c9e0bd74a2@kaspersky.com>
Date:   Wed, 3 Mar 2021 13:42:20 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210302172542.605b3795@gandalf.local.home>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx1.avp.ru (10.64.67.241) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 03/03/2021 10:31:43
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 162194 [Mar 03 2021]
X-KSE-AntiSpam-Info: LuaCore: 430 430 36bea03808f03ef3db4e56410ed9bb7ad8f7e286
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: {Macro_CONTENT_PLAIN}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TEXT_PLAIN_OR_HTML}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_8_BIT_WITH_7_BIT_C_TRANSFER_ENCODING}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_JAPANESE}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_ENCODING_NOT_RUS}
X-KSE-AntiSpam-Info: {Macro_CONTENT_TYPE_INCORRECT_BIT_FOR_C_TRANSFER_ENCODING}
X-KSE-AntiSpam-Info: {Macro_DATE_MOSCOW}
X-KSE-AntiSpam-Info: {Macro_FROM_DOUBLE_ENG_NAME}
X-KSE-AntiSpam-Info: {Macro_FROM_LOWCAPS_DOUBLE_ENG_NAME_IN_EMAIL}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RU}
X-KSE-AntiSpam-Info: {Macro_FROM_NOT_RUS_CHARSET}
X-KSE-AntiSpam-Info: {Macro_FROM_REAL_NAME_MATCHES_ALL_USERNAME_PROB}
X-KSE-AntiSpam-Info: {Macro_HEADERS_NOT_LIST}
X-KSE-AntiSpam-Info: {Macro_MAILER_THUNDERBIRD}
X-KSE-AntiSpam-Info: {Macro_MISC_X_PRIORITY_MISSED}
X-KSE-AntiSpam-Info: {Macro_MSGID_LOWHEX_8_4_4_4_12}
X-KSE-AntiSpam-Info: {Macro_NO_DKIM}
X-KSE-AntiSpam-Info: {Macro_REPLY_TO_MISSED}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_AT_LEAST_2_WORDS}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_ENG_UPPERCASE_BEGINNING}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_LONG_TEXT}
X-KSE-AntiSpam-Info: {Macro_SUBJECT_WITH_FWD_OR_RE}
X-KSE-AntiSpam-Info: kaspersky.com:7.1.1;d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 03/03/2021 10:34:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 03.03.2021 9:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/03/03 09:54:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/03/03 08:59:00 #16322941
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 03.03.2021 01:25, Steven Rostedt wrote:
> On Thu, 18 Feb 2021 08:42:15 +0300
> Arseny Krasnov <arseny.krasnov@kaspersky.com> wrote:
>
> Not sure if this was pulled in yet, but I do have a small issue with this
> patch.
No, it is in RFC state.
>
>> @@ -69,14 +82,19 @@ TRACE_EVENT(virtio_transport_alloc_pkt,
>>  		__entry->type = type;
>>  		__entry->op = op;
>>  		__entry->flags = flags;
>> +		__entry->msg_len = msg_len;
>> +		__entry->msg_cnt = msg_cnt;
>>  	),
>> -	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x",
>> +	TP_printk("%u:%u -> %u:%u len=%u type=%s op=%s flags=%#x "
>> +		  "msg_len=%u msg_cnt=%u",
> It's considered poor formatting to split strings like the above. This is
> one of the exceptions for the 80 character limit. Do not break strings just
> to keep it within 80 characters.
>
> -- Steve
Ok, will fix in next version, Thank You
>
>
>>  		  __entry->src_cid, __entry->src_port,
>>  		  __entry->dst_cid, __entry->dst_port,
>>  		  __entry->len,
>>  		  show_type(__entry->type),
>>  		  show_op(__entry->op),
>> -		  __entry->flags)
>> +		  __entry->flags,
>> +		  __entry->msg_len,
>> +		  __entry->msg_cnt)
>>  );
