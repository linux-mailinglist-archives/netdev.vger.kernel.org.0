Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E19F46AC166
	for <lists+netdev@lfdr.de>; Mon,  6 Mar 2023 14:36:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231279AbjCFNgI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Mar 2023 08:36:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52006 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230489AbjCFNgH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Mar 2023 08:36:07 -0500
Received: from stravinsky.debian.org (stravinsky.debian.org [IPv6:2001:41b8:202:deb::311:108])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 426F729415;
        Mon,  6 Mar 2023 05:36:06 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=debian.org;
        s=smtpauto.stravinsky; h=X-Debian-User:Content-Transfer-Encoding:Content-Type
        :In-Reply-To:From:References:Cc:To:Subject:MIME-Version:Date:Message-ID:
        Reply-To:Content-ID:Content-Description;
        bh=8B5AJ56fLYgF8+5G01U3yzZnePuTzTzIDRmtdJ5XokE=; b=vM/dvZUlIAqAXLF0vrVU5NJUGM
        tOtlUdoXoy9mZ2QfXr8GD7YiIcsOSXOzCDUpOq12CrOwSFCDNHXz3vpKVQOrnPIeGJyHy6hkbKrkx
        PwXlUw90ujCFbv3mjqS+V8P0eqAim13qlvpiTYNwgmKpiIQqSTrX/k1kWVE9EYgt+5rmspR5ru+Br
        u1IgJfY0yZpZ6nVfXAVPThhlpVmw4uWDGepmGDcQ5Mi7T7tDEbwFXCogeVu9LPtF0KXbYDWzVgqcl
        Iqr06dijl4rV6V8+9l132mwhQf7BlUC3z6+b+nh333kBAdzv8l8ekgC0Yfj/r0qButMD8mT6aIV6M
        cLQssuWQ==;
Received: from authenticated user
        by stravinsky.debian.org with esmtpsa (TLS1.3:ECDHE_X25519__RSA_PSS_RSAE_SHA256__AES_128_GCM:128)
        (Exim 4.94.2)
        (envelope-from <bage@debian.org>)
        id 1pZB0V-001qcu-Qw; Mon, 06 Mar 2023 13:36:04 +0000
Message-ID: <f73bd7ce-dd44-cd10-8727-38f8cf6354bd@debian.org>
Date:   Mon, 6 Mar 2023 14:36:02 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:102.0) Gecko/20100101
 Thunderbird/102.8.0
Subject: Re: [PATCH 1/1] wifi: ath9k: Remove Qwest/Actiontec 802AIN ID
To:     Kalle Valo <kvalo@kernel.org>
Cc:     toke@toke.dk, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
References: <20230305210245.9831-1-bage@debian.org>
 <20230306125041.2221-1-bage@debian.org> <87wn3uowov.fsf@kernel.org>
Content-Language: en-US
From:   Bastian Germann <bage@debian.org>
In-Reply-To: <87wn3uowov.fsf@kernel.org>
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

Am 06.03.23 um 14:07 schrieb Kalle Valo:
> Bastian Germann <bage@debian.org> writes:
> 
>> The USB device 1668:1200 is Qwest/Actiontec 802AIN which is also
>> correctly claimed to be supported by carl9170.
>>
>> Supposedly, the successor 802AIN2 which has an ath9k compatible chip
>> whose USB ID (unknown) could be inserted instead.
>>
>> Drop the ID from the wrong driver.
>>
>> Signed-off-by: Bastian Germann <bage@debian.org>
> 
> Thanks, I see this patch now.
> 
> I guess there's a bug report somewhere, do you have a link?

No, I happened to find this by chance while packaging the ath9k and carl9170 firmware for Debian,
which have the ID represented in an XML format: 
https://salsa.debian.org/debian/open-ath9k-htc-firmware/-/blob/master/debian/firmware-ath9k-htc.metainfo.xml
