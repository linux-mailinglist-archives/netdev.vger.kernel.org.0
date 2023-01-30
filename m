Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id EA39868105F
	for <lists+netdev@lfdr.de>; Mon, 30 Jan 2023 15:03:05 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237047AbjA3ODD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Jan 2023 09:03:03 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42766 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236987AbjA3OCv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Jan 2023 09:02:51 -0500
Received: from phobos.denx.de (phobos.denx.de [IPv6:2a01:238:438b:c500:173d:9f52:ddab:ee01])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B1A423B0E2;
        Mon, 30 Jan 2023 06:02:42 -0800 (PST)
Received: from [127.0.0.1] (p578adb1c.dip0.t-ipconnect.de [87.138.219.28])
        (using TLSv1.3 with cipher TLS_AES_128_GCM_SHA256 (128/128 bits))
        (No client certificate requested)
        (Authenticated sender: marex@denx.de)
        by phobos.denx.de (Postfix) with ESMTPSA id E9DB2852C0;
        Mon, 30 Jan 2023 15:02:38 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=denx.de;
        s=phobos-20191101; t=1675087360;
        bh=I9qoCeiFdZwWtoDstV4Bw6+TIyjJzJfTohVx+3k+nHM=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=aHzsJyV4HCWjKDnrmzaXgjc6ANf9EO2SGRrlOJyxOSPQ9qOh3Z5d881HR1PoTK+B9
         fkxy05jJPp2wCXOsNbno+htj1nkobuTCQCXmqYxscBG6ycPBltVapv33SVS3lwVGOg
         TN/f9zDXcjSREe7toqfiYbDc1W6XUYxuV7ZzCNAMf5aEi3Qgn5ym5fUg/zg+l46LRT
         Xbrwnl8YufnLMbodkaPzbEHmZG2FjbNFX7vxkbERKBPuqOtO/Jsc/gxY0QWy9MxcXP
         RU0oWmuOIMu9VOVQQrf6UGzDYYWJpf6CClqJjIFj8FOUceJXKRoyQ7aUlurhTc/0JL
         XxMCHbUUHhP1Q==
Message-ID: <22ab680d-cb57-74ab-1a37-c7d7b5c29895@denx.de>
Date:   Mon, 30 Jan 2023 15:02:38 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.7.1
Subject: Re: [PATCH] wifi: rsi: Adding new driver Maintainers
To:     Ganapathi Kondraju <ganapathi.kondraju@silabs.com>,
        linux-wireless@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        Johannes Berg <johannes@sipsolutions.net>,
        Kalle Valo <kvalo@kernel.org>,
        Martin Fuzzey <martin.fuzzey@flowbird.group>,
        Martin Kepplinger <martink@posteo.de>,
        Sebastian Krzyszkowiak <sebastian.krzyszkowiak@puri.sm>,
        netdev@vger.kernel.org,
        Jerome Pouiller <Jerome.Pouiller@silabs.com>,
        Angus Ainslie <angus@akkea.ca>,
        Amitkumar Karwar <amitkarwar@gmail.com>,
        Siva Rebbagondla <siva8118@gmail.com>,
        narasimha.anumolu@silabs.com, amol.hanwate@silabs.com,
        shivanadam.gude@silabs.com, srinivas.chappidi@silabs.com
References: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
Content-Language: en-US
From:   Marek Vasut <marex@denx.de>
In-Reply-To: <1675071591-7138-1-git-send-email-ganapathi.kondraju@silabs.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-Virus-Scanned: clamav-milter 0.103.6 at phobos.denx.de
X-Virus-Status: Clean
X-Spam-Status: No, score=-4.5 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 1/30/23 10:39, Ganapathi Kondraju wrote:
> Silicon Labs acquired Redpine Signals recently. It needs to continue
> giving support to the existing REDPINE WIRELESS DRIVER. Added new
> Maintainers for it.
> 
> Signed-off-by: Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> ---
>   MAINTAINERS | 7 ++++++-
>   1 file changed, 6 insertions(+), 1 deletion(-)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index ea941dc..af07b88 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -17709,8 +17709,13 @@ S:	Maintained
>   F:	drivers/net/wireless/realtek/rtw89/
>   
>   REDPINE WIRELESS DRIVER
> +M:	Narasimha Anumolu <narasimha.anumolu@silabs.com>
> +M:	Ganapathi Kondraju <ganapathi.kondraju@silabs.com>
> +M:	Amol Hanwate <amol.hanwate@silabs.com>
> +M:	Shivanadam Gude <shivanadam.gude@silabs.com>
> +M:	Jérôme Pouiller <jerome.pouiller@silabs.com>

Please keep the list sorted.
