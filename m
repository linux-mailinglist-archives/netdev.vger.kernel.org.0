Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 384055BD4D3
	for <lists+netdev@lfdr.de>; Mon, 19 Sep 2022 20:37:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229437AbiISShl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 19 Sep 2022 14:37:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38024 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229453AbiISShj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 19 Sep 2022 14:37:39 -0400
Received: from novek.ru (unknown [213.148.174.62])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 620C93BC50
        for <netdev@vger.kernel.org>; Mon, 19 Sep 2022 11:37:38 -0700 (PDT)
Received: from [192.168.0.18] (unknown [37.228.234.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES128-GCM-SHA256 (128/128 bits))
        (No client certificate requested)
        by novek.ru (Postfix) with ESMTPSA id C29A7504D10;
        Mon, 19 Sep 2022 21:34:01 +0300 (MSK)
DKIM-Filter: OpenDKIM Filter v2.11.0 novek.ru C29A7504D10
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=novek.ru; s=mail;
        t=1663612443; bh=NOb5jI0rHFAHxAbPywOk6Kzz6rpuddD9ubXb3dISz0g=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=qQ+FlwfAI29JoxdnMwqyoYX+o2lu2/X60M8TpK8sRySYK/iKhJXkOWUihR9XbttlH
         Hdky+6DWVJRPnU4nt3fhDOoCJ6l1OXV+YVAsekIwPfb/9j7KgCFBjMIB8GEOVZPhct
         Oqn8tEY7Bzny6mlXVBg9EUymF0zB/g1WKIg5EZ4s=
Message-ID: <c00c524c-1897-6167-74df-420fef9eb2b1@novek.ru>
Date:   Mon, 19 Sep 2022 19:37:04 +0100
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:91.0) Gecko/20100101
 Thunderbird/91.11.0
Subject: Re: [PATCH net] net: bnxt: replace reset with config timestamps
Content-Language: en-US
To:     Michael Chan <michael.chan@broadcom.com>,
        Pavan Chebbi <pavan.chebbi@broadcom.com>,
        netdev@vger.kernel.org
Cc:     Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>
References: <20220919174423.31146-1-vfedorenko@novek.ru>
From:   Vadim Fedorenko <vfedorenko@novek.ru>
In-Reply-To: <20220919174423.31146-1-vfedorenko@novek.ru>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-3.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,SPF_HELO_PASS,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 19.09.2022 18:44, Vadim Fedorenko wrote:
> Any change to the hardware timestamps configuration triggers nic restart,
> which breaks transmition and reception of network packets for a while.
> But there is no need to fully restart the device because while configuring
> hardware timestamps. The code for changing configuration runs after all
> of the initialisation, when the NIC is actually up and running. This patch
> changes the code that ioctl will only update configuration registers and
> will not trigger carrier status change. Tested on BCM57504.
> 

Ignore this one, plz. I'll send another with proper subject and Fixes tag.

