Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 201B94D05E0
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 19:02:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240997AbiCGSDb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 13:03:31 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57098 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S240970AbiCGSDa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 13:03:30 -0500
Received: from sender4-op-o14.zoho.com (sender4-op-o14.zoho.com [136.143.188.14])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 903A2A1B2
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 10:02:31 -0800 (PST)
ARC-Seal: i=1; a=rsa-sha256; t=1646676134; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=H6kJ73BTvTM89pbbEcIgXfLdeW6ybphrgleHz0iYIZuROZLY3dxS3andotv6XQIuaueaUKDJlvOHqk8Ag88iY6F3DZ8IX+9O1zDtgt5nqCbWx2or9ykZjvdtIOAq/TUw7EtsCMIKyKvQ/96+jcp3AHiPu+Dzu0SKYMgCOrmr/7Q=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1646676134; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:References:Subject:To; 
        bh=3zaNSM2djHaq1jK2Y4VT0MLmk8lZJP4e5aOZer73E3o=; 
        b=UQxKc1Tg0FrqMGqXWm1sykT3UpTjaFEPT9ZM4CRBM0olWUM7QL4V+dVz+2WtHRcY+8NHmOt7r1t+YINqBNWmZVHyvLObxJkhNqbSmVBvz4LRtvYbBvo1qJQxzmjVRIWkdgoxtdRhOPKRy3TyYG3SYtJnx2g7wTNbw/UUIvrKtr0=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=arinc9.com;
        spf=pass  smtp.mailfrom=arinc.unal@arinc9.com;
        dmarc=pass header.from=<arinc.unal@arinc9.com>
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; t=1646676134;
        s=zmail; d=arinc9.com; i=arinc.unal@arinc9.com;
        h=Message-ID:Date:MIME-Version:Subject:To:Cc:References:From:In-Reply-To:Content-Type:Content-Transfer-Encoding;
        bh=3zaNSM2djHaq1jK2Y4VT0MLmk8lZJP4e5aOZer73E3o=;
        b=aGcyHPnTqXZMzsSzNXMbt62KHDdXZqrASZCYuZv9CZ+asZJkX/vBO+CnAoCPcCEK
        03vGQjQgS0l5uaJbnJZphsU4ZccWP4JpKHBDVareeMjDZLC3E0JRkREeG1b+E9QzI2J
        Rq/qrZ9l7w7eAxsCC7AigKVk8hpFdnTPYXYfLrT4=
Received: from [10.10.10.3] (85.117.236.245 [85.117.236.245]) by mx.zohomail.com
        with SMTPS id 1646676133020191.72314401815788; Mon, 7 Mar 2022 10:02:13 -0800 (PST)
Message-ID: <07287e42-bd51-a868-bfaa-6fd0213cc818@arinc9.com>
Date:   Mon, 7 Mar 2022 21:02:09 +0300
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.6.2
Subject: Re: [PATCH net-next] net: dsa: tag_rtl8_4: typo in modalias name
Content-Language: en-US
To:     Luiz Angelo Daros de Luca <luizluca@gmail.com>,
        netdev@vger.kernel.org
Cc:     linus.walleij@linaro.org, andrew@lunn.ch, vivien.didelot@gmail.com,
        f.fainelli@gmail.com, olteanv@gmail.com, davem@davemloft.net,
        kuba@kernel.org, alsi@bang-olufsen.dk
References: <20220307170927.25572-1-luizluca@gmail.com>
From:   =?UTF-8?B?QXLEsW7DpyDDnE5BTA==?= <arinc.unal@arinc9.com>
In-Reply-To: <20220307170927.25572-1-luizluca@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
X-ZohoMailClient: External
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_PASS,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 07/03/2022 20:09, Luiz Angelo Daros de Luca wrote:
> DSA_TAG_PROTO_RTL8_4L is not defined. It should be
> DSA_TAG_PROTO_RTL8_4T.
> 
> Reported-by: Arınç ÜNAL <arinc.unal@arinc9.com>
> Signed-off-by: Luiz Angelo Daros de Luca <luizluca@gmail.com>
> ---
>   net/dsa/tag_rtl8_4.c | 2 +-
>   1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/net/dsa/tag_rtl8_4.c b/net/dsa/tag_rtl8_4.c
> index 71fec45fd0ea..a593ead7ff26 100644
> --- a/net/dsa/tag_rtl8_4.c
> +++ b/net/dsa/tag_rtl8_4.c
> @@ -247,7 +247,7 @@ static const struct dsa_device_ops rtl8_4t_netdev_ops = {
>   
>   DSA_TAG_DRIVER(rtl8_4t_netdev_ops);
>   
> -MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4L);
> +MODULE_ALIAS_DSA_TAG_DRIVER(DSA_TAG_PROTO_RTL8_4T);
>   
>   static struct dsa_tag_driver *dsa_tag_drivers[] = {
>   	&DSA_TAG_DRIVER_NAME(rtl8_4_netdev_ops),

Might as well add Fixes: tag since this fixes cd87fecdedd7 ("net: dsa: 
tag_rtl8_4: add rtl8_4t trailing variant") and "fix typo in modalias 
name" on the subject to clearly state the change.

Arınç
