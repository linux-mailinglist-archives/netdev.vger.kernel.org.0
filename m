Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 421B66CB56C
	for <lists+netdev@lfdr.de>; Tue, 28 Mar 2023 06:33:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230227AbjC1EdU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 28 Mar 2023 00:33:20 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:49670 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229631AbjC1EdS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 28 Mar 2023 00:33:18 -0400
Received: from mx.sberdevices.ru (mx.sberdevices.ru [45.89.227.171])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1F12310FF;
        Mon, 27 Mar 2023 21:33:16 -0700 (PDT)
Received: from s-lin-edge02.sberdevices.ru (localhost [127.0.0.1])
        by mx.sberdevices.ru (Postfix) with ESMTP id DE2845FD07;
        Tue, 28 Mar 2023 07:33:13 +0300 (MSK)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=sberdevices.ru;
        s=mail; t=1679977993;
        bh=jEkG0B3F20Ma9JMiBaqimk9VgT1INHNX1SXr1j26Ukw=;
        h=Message-ID:Date:MIME-Version:Subject:To:From:Content-Type;
        b=SDc0tbegqcRFkqKjdCUQV1G9A0gZe9U09kxv4vjk4eTzR5eRYjwO+A1nplEuU4BQl
         Q6vxiNW9ErERkndRLnRlxgi9yXeLn2c0WG2RhdMk5yhkHXpZR5DKkhBVe2uXqbncmT
         6DzUsPQah40agAWr6nCSEgGiFzZAUoeQLiL8DIFSpKcAFdCli4tKjWDpjrqLaZ6LXa
         iwfnLwlYh/eZr91ifOnX+JiABoxegp5Uwk0xeERWc9bl5oGPqtE1fKFpASJWgYY4FI
         HYEiAh6EgOR4SfejiPhxKYYcVvxbnMPjs5m2KM7HRa3gJLmOH553qWs2FDFbeQnEKj
         YEr6yfwIDxJqA==
Received: from S-MS-EXCH01.sberdevices.ru (S-MS-EXCH01.sberdevices.ru [172.16.1.4])
        by mx.sberdevices.ru (Postfix) with ESMTP;
        Tue, 28 Mar 2023 07:33:11 +0300 (MSK)
Message-ID: <f5fd22e5-472d-3c96-437c-4451574890fa@sberdevices.ru>
Date:   Tue, 28 Mar 2023 07:29:51 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH net-next] testing/vsock: add vsock_perf to gitignore
Content-Language: en-US
To:     Bobby Eshleman <bobby.eshleman@bytedance.com>,
        Stefano Garzarella <sgarzare@redhat.com>,
        Paolo Abeni <pabeni@redhat.com>
CC:     <virtualization@lists.linux-foundation.org>,
        <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>
References: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
From:   Arseniy Krasnov <avkrasnov@sberdevices.ru>
In-Reply-To: <20230327-vsock-add-vsock-perf-to-ignore-v1-1-f28a84f3606b@bytedance.com>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [172.16.1.6]
X-ClientProxiedBy: S-MS-EXCH01.sberdevices.ru (172.16.1.4) To
 S-MS-EXCH01.sberdevices.ru (172.16.1.4)
X-KSMG-Rule-ID: 4
X-KSMG-Message-Action: clean
X-KSMG-AntiSpam-Status: not scanned, disabled by settings
X-KSMG-AntiSpam-Interceptor-Info: not scanned
X-KSMG-AntiPhishing: not scanned, disabled by settings
X-KSMG-AntiVirus: Kaspersky Secure Mail Gateway, version 1.1.2.30, bases: 2023/03/28 03:13:00 #21020490
X-KSMG-AntiVirus-Status: Clean, skipped
X-Spam-Status: No, score=-0.2 required=5.0 tests=DKIM_SIGNED,DKIM_VALID,
        DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,SPF_PASS
        autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 28.03.2023 01:16, Bobby Eshleman wrote:
> This adds the vsock_perf binary to the gitignore file.
> 
> Fixes: 8abbffd27ced ("test/vsock: vsock_perf utility")
> Signed-off-by: Bobby Eshleman <bobby.eshleman@bytedance.com>
> ---
>  tools/testing/vsock/.gitignore | 1 +
>  1 file changed, 1 insertion(+)

Reviewed-by: Arseniy Krasnov <AVKrasnov@sberdevices.ru>

> 
> diff --git a/tools/testing/vsock/.gitignore b/tools/testing/vsock/.gitignore
> index 87ca2731cff9..a8adcfdc292b 100644
> --- a/tools/testing/vsock/.gitignore
> +++ b/tools/testing/vsock/.gitignore
> @@ -2,3 +2,4 @@
>  *.d
>  vsock_test
>  vsock_diag_test
> +vsock_perf
> 
> ---
> base-commit: e5b42483ccce50d5b957f474fd332afd4ef0c27b
> change-id: 20230327-vsock-add-vsock-perf-to-ignore-82b46b1f3f6f
> 
> Best regards,
