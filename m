Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 109946AC1DC
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:51:32 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229896AbjCFNvZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:51:25 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43756 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229587AbjCFNvT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:51:19 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E05D65FD4;
        Mon,  6 Mar 2023 05:51:13 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Reply-To:Content-ID:Content-Description;
        bh=gs78BnrXzspSAJXd2cmWY8QxFgsu7tsQcXW0ygWqXj8=; b=s1Z5ESnBs2+xRfUha1CV2oe9jM
        H+C+VnwGpJpANkbab5ewcRCSVC7l14aY5wEkGeE8icqLzHLuIUNxRUa+oBgIINFzkYsVDyq9j70N8
        OaxeU4gXhzQxfbTp4XaPYPPGBmcL1GZgXUv4Tucb848rNxfwv5HQCcE0vkL0ge1luLXhmpoZxc9fi
        B0nKimJhvkXoEEFe9KXBR8hliBk2c0GrFGYH10pDoUw9TH4qU2jrcQTsNpYi3pMhzY2ThzsXTiBce
        bctx/0P9MUMshcJfThxb3ZPlpcuq9yRuemZrzoIpywBIgK7jSoN83B5EqnrWCgEEq11O7RSDLI/kW
        sw4MKJdw==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pZBF9-001rCG-2F; Mon, 06 Mar 2023 13:51:11 +0000
Message-ID: <0e708039-1a1d-92a8-28c5-ebb69cd1aad0@debian.org>
Date:   Mon, 6 Mar 2023 14:51:09 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
Content-Language: de-DE-frami
To:     Kalle Valo <kvalo@kernel.org>
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230305210245.9831-1-bage@debian.org>
 <20230306125041.2221-1-bage@debian.org> <87wn3uowov.fsf@kernel.org>
 <f73bd7ce-dd44-cd10-8727-38f8cf6354bd@debian.org> <87sfeioupw.fsf@kernel.org>
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <87sfeioupw.fsf@kernel.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Debian-User: bage
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_MED,SPF_HELO_NONE,SPF_NONE,UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 06.03.23 um 14:49 schrieb Kalle Valo:
> Bastian Germann <bage@debian.org> writes:
> 
>> Am 06.03.23 um 14:07 schrieb Kalle Valo:
>>> Bastian Germann <bage@debian.org> writes:
>>>
>>>> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
>>>> correctly claimed to be supported by carl9170.
>>>>
>>>> Supposedly, the successor 802AIN2 which has an ath9k compatible chip

The "which" should be removed as well.

>>>> whose USB ID (unknown) could be inserted instead.
>>>>
>>>> Drop the ID from the wrong driver.
>>>>
>>>> Signed-off-by: Bastian Germann <bage@debian.org>
>>>
>>> Thanks, I see this patch now.
>>>
>>> I guess there's a bug report somewhere, do you have a link?
>>
>> No, I happened to find this by chance while packaging the ath9k and
>> carl9170 firmware for Debian,
>> which have the ID represented in an XML format:
>> https://salsa.debian.org/debian/open-ath9k-htc-firmware/-/blob/master/debian/firmware-ath9k-htc.metainfo.xml
> 
> Do you mind if we add this (without the link) to the commit log? It's
> good to always document the background of the patch.

Please go ahead.
