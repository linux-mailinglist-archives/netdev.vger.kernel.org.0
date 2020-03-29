Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 54081196E3A
	for <lists+netdev@lfdr.de>; Sun, 29 Mar 2020 17:49:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728190AbgC2Pta (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 29 Mar 2020 11:49:30 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:42266 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727167AbgC2Pta (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 29 Mar 2020 11:49:30 -0400
Received: by mail-wr1-f65.google.com with SMTP id h15so17936493wrx.9
        for <netdev@vger.kernel.org>; Sun, 29 Mar 2020 08:49:28 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=googlemail.com; s=20161025;
        h=subject:from:to:references:message-id:date:user-agent:mime-version
         :in-reply-to:content-language:content-transfer-encoding;
        bh=WWNf4QIbiCM2d6T95ruQhS1Yvp/xubacQPkn6eUm8OY=;
        b=Z5yQHCdKrsLAku1p6u4n/FAtUHmcqKwdbTZ1iGK+Ck4EhprttTwy7k6zlW6JnmNFKz
         iQbkF+iBql3+zfS1+CrZBD3BpKN7+45wLjFMZeain04p+cEtBkLV2ZzwTjbj8olzrSNx
         +eEDuRH8+sxYtRFOdj1t8vKI6JLt4DjOkqDLhbVzf+ZYXRLiBdUQvjaF7aSDC0ogwg6P
         HJCN2zeDUNApoWOhvYJGttOJ0nyfamw+qlK0FYl5GQIflSieEc0jbXJUAxzEeDda9wNF
         soOYlYChgbpW8g60kDDJUOMLvm+LVBwIsBAF8co6FjDMZofin4PwFn44NjpMOldOXsJt
         mrjg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:from:to:references:message-id:date
         :user-agent:mime-version:in-reply-to:content-language
         :content-transfer-encoding;
        bh=WWNf4QIbiCM2d6T95ruQhS1Yvp/xubacQPkn6eUm8OY=;
        b=cUX8iyNP3NhY2tkEzU+KUOQy/c+wwflUGpv74Rj6pjzF4lHVkSuqiZC6gjAwk3CuGo
         t0nqZN27QSZVB+NaRt7g6Af0plEnN4gQueC2BKotE4vSEIQQzW9xbf0kMpDZcTDnM2Zu
         RmpgvxJ7ftvFa9aQxXYH3CtihuhA6+9BSZgXnE73BBMZCI5JtpL4wkhfNBtNcqhNIKZt
         g3IX28D0gHPnhCHjy4kRr7a9PgyxTu4sgLm45WoM7dMksRvi2v8gRFKkTeYXRR56MZ+s
         b01azR5hzybovINjyl/W1kCwwTZwWDZ64vh+iuO8+eZaialJJWMO+8Xq9tD2Dd23/9D9
         cfUA==
X-Gm-Message-State: ANhLgQ3sZq1nekejNyIB0WCRow3BUKGGdm7GmRDhleq9jEQLsRjKucG1
        FVfCINyStZKUwvYvfaQlJaw=
X-Google-Smtp-Source: ADFU+vseVzXs1hHJjOno3MM6BxumkRg2ABhwQSfEuJAyWkLO6g31CJae1JcsA12DGMdgWJDgRWy14Q==
X-Received: by 2002:a5d:5112:: with SMTP id s18mr10529734wrt.306.1585496968000;
        Sun, 29 Mar 2020 08:49:28 -0700 (PDT)
Received: from [10.8.0.2] (host81-135-135-131.range81-135.btcentralplus.com. [81.135.135.131])
        by smtp.googlemail.com with ESMTPSA id w4sm15188142wmc.18.2020.03.29.08.49.26
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Sun, 29 Mar 2020 08:49:27 -0700 (PDT)
Subject: Re: 5.6.0-rc7+ fails to connect to wifi network
From:   Chris Clayton <chris2553@googlemail.com>
To:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>, jouni@codeaurora.org,
        johannes.berg@intel.com
References: <870207cc-2b47-be26-33b6-ec3971122ab8@googlemail.com>
 <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
Message-ID: <ba3e6cfa-3de3-7445-f7e1-bb1a7e6e175f@googlemail.com>
Date:   Sun, 29 Mar 2020 16:49:23 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <58a4d4b4-a372-9f38-2ceb-8386f8444d61@googlemail.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-GB
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On 29/03/2020 11:54, Chris Clayton wrote:
> 
> 
> On 29/03/2020 11:06, Chris Clayton wrote:
>> Hi,
>>
>> I did a pull from Linus' tree this morning. It included the latest network fixes. Unfortunately, the resultant kernel
>> fails to connect to my home wifi network. 5.4.28 connects fine as does 5.6.0-rc7+ built at the parent commit of the
>> network merge (i.e. commit 906c40438bb669b253d0daeaf5f37a9f78a81b41 - Merge branch 'i2c/for-current' of
>> git://git.kernel.org/pub/scm/linux/kernel/git/wsa/linux).
>>
>> The output from dmesg from the failed boot is attached. I've obfuscated the mac addresses of my BT router and of a
>> wifi-extender.
>>
>> Let me know if I can provide any additional diagnostics and/or test any patches.
> 
> I've bisected this and landed at:
> 
> ce2e1ca703071723ca2dd94d492a5ab6d15050da is the first bad commit
> commit ce2e1ca703071723ca2dd94d492a5ab6d15050da
> Author: Jouni Malinen <jouni@codeaurora.org>
> Date:   Thu Mar 26 15:51:34 2020 +0100
> 
>     mac80211: Check port authorization in the ieee80211_tx_dequeue() case
> 
>     mac80211 used to check port authorization in the Data frame enqueue case
>     when going through start_xmit(). However, that authorization status may
>     change while the frame is waiting in a queue. Add a similar check in the
>     dequeue case to avoid sending previously accepted frames after
>     authorization change. This provides additional protection against
>     potential leaking of frames after a station has been disconnected and
>     the keys for it are being removed.
> 
>     Cc: stable@vger.kernel.org
>     Signed-off-by: Jouni Malinen <jouni@codeaurora.org>
>     Link: https://lore.kernel.org/r/20200326155133.ced84317ea29.I34d4c47cd8cc8a4042b38a76f16a601fbcbfd9b3@changeid
>     Signed-off-by: Johannes Berg <johannes.berg@intel.com>
> 
>  net/mac80211/tx.c | 19 ++++++++++++++++++-
>  1 file changed, 18 insertions(+), 1 deletion(-)
> 
> Jouni and Johannes added to recipients.
> 

...and reverting the change gives me working wifi again. :-)

>>
>> Please cc me in any reply as I'm not subscribed.
>>
>> Thanks.
>>
