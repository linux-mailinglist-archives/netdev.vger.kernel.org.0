Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 740033ACDE8
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 16:50:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234720AbhFROwo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 10:52:44 -0400
Received: from mx12.kaspersky-labs.com ([91.103.66.155]:55083 "EHLO
        mx12.kaspersky-labs.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S234710AbhFROwn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Jun 2021 10:52:43 -0400
Received: from relay12.kaspersky-labs.com (unknown [127.0.0.10])
        by relay12.kaspersky-labs.com (Postfix) with ESMTP id 0330F762AF;
        Fri, 18 Jun 2021 17:50:31 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=kaspersky.com;
        s=mail202102; t=1624027831;
        bh=mioIxcKn1dUte/rgRLgYR39/5M/DokLmC2JiaDqlwUM=;
        h=Subject:To:From:Message-ID:Date:MIME-Version:Content-Type;
        b=rW1+7mq38xP+IdNDdBJgMHmo+K1nIdgK0vSkPb52gBLuBHd+m89rZrxtvN7K0iJY2
         Vq6MIS1/9VpQ/EVwjm/GBjr1w2HjUkCZpYM1GDv11GdX5JUGkD64bjAqv2AQT5k1qJ
         Yhg50PVZ9Tn0ca76vHPiiJ9+TH+f4VFBi7GM5o/25W2H7XwHDvi9PuJ4AaGGMaHw24
         JAHf9X37yOohX7UMmk4MSfr45TAqHaqkr0I+5IMWaCkJEY1JbbiXBZXECGJmDrd5X2
         cPlZjmBcS69o1dyHPAV+tO8+/SIUuML/TreUhfESF169wXoo+1Hn1nGRd0semLpRt5
         qkid4ukbeUEMA==
Received: from mail-hq2.kaspersky.com (unknown [91.103.66.206])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-SHA256 (128/128 bits))
        (Client CN "mail-hq2.kaspersky.com", Issuer "Kaspersky MailRelays CA G3" (verified OK))
        by mailhub12.kaspersky-labs.com (Postfix) with ESMTPS id 6413B762A9;
        Fri, 18 Jun 2021 17:50:30 +0300 (MSK)
Received: from [10.16.171.77] (10.64.68.128) by hqmailmbx3.avp.ru
 (10.64.67.243) with Microsoft SMTP Server (version=TLS1_2,
 cipher=TLS_ECDHE_RSA_WITH_AES_128_CBC_SHA256_P256) id 15.1.2176.14; Fri, 18
 Jun 2021 17:50:29 +0300
Subject: Re: [PATCH net-next 1/3] vsock: rename vsock_has_data()
To:     Stefano Garzarella <sgarzare@redhat.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
CC:     "kvm@vger.kernel.org" <kvm@vger.kernel.org>,
        Jakub Kicinski <kuba@kernel.org>,
        "virtualization@lists.linux-foundation.org" 
        <virtualization@lists.linux-foundation.org>,
        "David S. Miller" <davem@davemloft.net>,
        Stefan Hajnoczi <stefanha@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <20210618133526.300347-1-sgarzare@redhat.com>
 <20210618133526.300347-2-sgarzare@redhat.com>
From:   Arseny Krasnov <arseny.krasnov@kaspersky.com>
Message-ID: <74271c7b-fb61-2f54-0ca6-6ea315cb758f@kaspersky.com>
Date:   Fri, 18 Jun 2021 17:50:29 +0300
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20210618133526.300347-2-sgarzare@redhat.com>
Content-Type: text/plain; charset="koi8-r"
Content-Transfer-Encoding: 7bit
Content-Language: en-US
X-Originating-IP: [10.64.68.128]
X-ClientProxiedBy: hqmailmbx3.avp.ru (10.64.67.243) To hqmailmbx3.avp.ru
 (10.64.67.243)
X-KSE-ServerInfo: hqmailmbx3.avp.ru, 9
X-KSE-AntiSpam-Interceptor-Info: scan successful
X-KSE-AntiSpam-Version: 5.9.20, Database issued on: 06/18/2021 14:29:51
X-KSE-AntiSpam-Status: KAS_STATUS_NOT_DETECTED
X-KSE-AntiSpam-Method: none
X-KSE-AntiSpam-Rate: 0
X-KSE-AntiSpam-Info: Lua profiles 164482 [Jun 18 2021]
X-KSE-AntiSpam-Info: Version: 5.9.20.0
X-KSE-AntiSpam-Info: Envelope from: arseny.krasnov@kaspersky.com
X-KSE-AntiSpam-Info: LuaCore: 448 448 71fb1b37213ce9a885768d4012c46ac449c77b17
X-KSE-AntiSpam-Info: {Tracking_from_domain_doesnt_match_to}
X-KSE-AntiSpam-Info: d41d8cd98f00b204e9800998ecf8427e.com:7.1.1;127.0.0.199:7.1.2;kaspersky.com:7.1.1
X-KSE-AntiSpam-Info: Rate: 0
X-KSE-AntiSpam-Info: Status: not_detected
X-KSE-AntiSpam-Info: Method: none
X-KSE-Antiphishing-Info: Clean
X-KSE-Antiphishing-ScanningType: Deterministic
X-KSE-Antiphishing-Method: None
X-KSE-Antiphishing-Bases: 06/18/2021 14:32:00
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-Antivirus-Interceptor-Info: scan successful
X-KSE-Antivirus-Info: Clean, bases: 18.06.2021 12:17:00
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KSE-AttachmentFiltering-Interceptor-Info: no applicable attachment filtering
 rules found
X-KSE-BulkMessagesFiltering-Scan-Result: InTheLimit
X-KLMS-Rule-ID: 52
X-KLMS-Message-Action: clean
X-KLMS-AntiSpam-Status: not scanned, disabled by settings
X-KLMS-AntiSpam-Interceptor-Info: not scanned
X-KLMS-AntiPhishing: Clean, bases: 2021/06/18 13:10:00
X-KLMS-AntiVirus: Kaspersky Security for Linux Mail Server, version 8.0.3.30, bases: 2021/06/18 12:17:00 #16756757
X-KLMS-AntiVirus-Status: Clean, skipped
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


On 18.06.2021 16:35, Stefano Garzarella wrote:
> vsock_has_data() is used only by STREAM and SEQPACKET sockets,
> so let's rename it to vsock_connectible_has_data(), using the same
> nomenclature (connectible) used in other functions after the
> introduction of SEQPACKET.
>
> Signed-off-by: Stefano Garzarella <sgarzare@redhat.com>
> ---
>  net/vmw_vsock/af_vsock.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/net/vmw_vsock/af_vsock.c b/net/vmw_vsock/af_vsock.c
> index 67954afef4e1..de8249483081 100644
> --- a/net/vmw_vsock/af_vsock.c
> +++ b/net/vmw_vsock/af_vsock.c
> @@ -860,7 +860,7 @@ s64 vsock_stream_has_data(struct vsock_sock *vsk)
>  }
>  EXPORT_SYMBOL_GPL(vsock_stream_has_data);
>  
> -static s64 vsock_has_data(struct vsock_sock *vsk)
> +static s64 vsock_connectible_has_data(struct vsock_sock *vsk)
>  {
>  	struct sock *sk = sk_vsock(vsk);
>  
> @@ -1880,7 +1880,7 @@ static int vsock_wait_data(struct sock *sk, struct wait_queue_entry *wait,
>  	err = 0;
>  	transport = vsk->transport;
>  
> -	while ((data = vsock_has_data(vsk)) == 0) {
> +	while ((data = vsock_connectible_has_data(vsk)) == 0) {
>  		prepare_to_wait(sk_sleep(sk), wait, TASK_INTERRUPTIBLE);
>  
>  		if (sk->sk_err != 0 ||
LGTM
