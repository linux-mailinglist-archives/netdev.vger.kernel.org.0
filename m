Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 583276AE0D7
	for <lists+netdev@lfdr.de>; Tue,  7 Mar 2023 14:40:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229556AbjCGNkN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 7 Mar 2023 08:40:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37774 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229621AbjCGNkE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 7 Mar 2023 08:40:04 -0500
Received: from madras.collabora.co.uk (madras.collabora.co.uk [IPv6:2a00:1098:0:82:1000:25:2eeb:e5ab])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 980E228D2C;
        Tue,  7 Mar 2023 05:39:29 -0800 (PST)
Received: from [192.168.10.12] (unknown [39.45.145.7])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits)
         key-exchange X25519 server-signature RSA-PSS (4096 bits))
        (No client certificate requested)
        (Authenticated sender: usama.anjum)
        by madras.collabora.co.uk (Postfix) with ESMTPSA id 0F2216602082;
        Tue,  7 Mar 2023 13:39:23 +0000 (GMT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=collabora.com;
        s=mail; t=1678196366;
        bh=WMlBdvHIScuFkkoGPtchKNS9u9P7bVVOeTivxhzjEG8=;
        h=Date:Cc:Subject:To:References:From:In-Reply-To:From;
        b=OzGvfTjKJ4s7PoMfHks/3lUdyc4iM4qP/SliI7hK+EiFlD3OiRuFDXM+UdgBdtW6L
         XuTMtTrI9hme7OJX95cfox8cbNQdcrUFLid4o2gO4Wz5jmMfuoUqbd0ME2+CYyKxZ7
         aKd2wo27Xgs6qAbez7XMauEjCogyMUeENDi9+fJYq6NVb/8BRLVPVP3958xWERIi+I
         d7xKJ5KY6i1CYrU7JIR1jAEfgIlB7XSdPFajWTgHzMgjdTpjWTHC0MlkDs0yztjR/+
         EBZCF1x/XWmiihGF2RCt6sMZUeRj31TDFVWbHioTiNI3LV+yWhmM9MxC2eRB9B8R82
         HoJPKpOeWgGDg==
Message-ID: <df8a446a-e8a9-3b3d-fd0f-791f0d01a0c9@collabora.com>
Date:   Tue, 7 Mar 2023 18:39:20 +0500
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.2
Cc:     Muhammad Usama Anjum <usama.anjum@collabora.com>,
        Ariel Elior <aelior@marvell.com>,
        Manish Chopra <manishc@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, kernel@collabora.com,
        kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] qede: remove linux/version.h and linux/compiler.h
Content-Language: en-US
To:     Jakub Kicinski <kuba@kernel.org>
References: <20230303185351.2825900-1-usama.anjum@collabora.com>
 <20230303155436.213ee2c0@kernel.org>
From:   Muhammad Usama Anjum <usama.anjum@collabora.com>
In-Reply-To: <20230303155436.213ee2c0@kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_NONE,
        SPF_PASS,URIBL_BLOCKED autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/4/23 4:54 AM, Jakub Kicinski wrote:
> On Fri,  3 Mar 2023 23:53:50 +0500 Muhammad Usama Anjum wrote:
>> make versioncheck reports the following:
>> ./drivers/net/ethernet/qlogic/qede/qede.h: 10 linux/version.h not needed.
>> ./drivers/net/ethernet/qlogic/qede/qede_ethtool.c: 7 linux/version.h not needed.
>>
>> So remove linux/version.h from both of these files. Also remove
>> linux/compiler.h while at it as it is also not being used.
>>
>> Signed-off-by: Muhammad Usama Anjum <usama.anjum@collabora.com>
> 
> # Form letter - net-next is closed
> 
> The merge window for v6.3 has begun and therefore net-next is closed
> for new drivers, features, code refactoring and optimizations.
> We are currently accepting bug fixes only.
> 
> Please repost when net-next reopens after Mar 6th.
It is Mar 7th. Please review.

> 
> RFC patches sent for review only are obviously welcome at any time.

-- 
BR,
Muhammad Usama Anjum
