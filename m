Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C5944260551
	for <lists+netdev@lfdr.de>; Mon,  7 Sep 2020 21:57:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728907AbgIGT5a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Sep 2020 15:57:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37386 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728834AbgIGT5a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Sep 2020 15:57:30 -0400
Received: from merlin.infradead.org (merlin.infradead.org [IPv6:2001:8b0:10b:1231::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id CE83AC061573
        for <netdev@vger.kernel.org>; Mon,  7 Sep 2020 12:57:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=merlin.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=dhJwYxcrL8N8oLjXGhjsLOC1RU4xAcvTtpyKRfTXb+8=; b=BreetQWaTglU7EXNsC3SypeAug
        /0XCyDmax9yA1Row/pRMkqJt8zml1dLoec7x+F6K0Ra1JL/RCpPtxApVkD4EMbOuYE0rns7cjK6MS
        h0gFGMYE61zgDC28MKMh/qEYprkYnt4aXA7JCWgsBLeHiETALadMG/oGHejOhPeKBuZV3Y2Ru9xOW
        dnquVgAdRxRqFpDfZeKVZVNR9t0sNLzx65OBoY1Ga9kwRQ5WH0HHpWeKvrqul91rGTn7u5HDxCPKj
        pfOw1T1nYCCbFqHkBk4v5rNCJhJbnuM3wjqyCas3QHZouh0o2sbOv7Ol/dNs/pQrje01gpdaca/60
        iu6T9Nrw==;
Received: from [2601:1c0:6280:3f0::19c2]
        by merlin.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1kFNGQ-0004qf-Sq; Mon, 07 Sep 2020 19:57:21 +0000
Subject: Re: [PATCH net] netdevice.h: fix proto_down_reason kernel-doc warning
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>,
        Roopa Prabhu <roopa@cumulusnetworks.com>
References: <7275c711-b313-b78c-bea5-e836f323b0ef@infradead.org>
 <20200907124951.044d34be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <390aab79-1577-a4aa-be59-d51966126a99@infradead.org>
Date:   Mon, 7 Sep 2020 12:57:14 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.11.0
MIME-Version: 1.0
In-Reply-To: <20200907124951.044d34be@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/7/20 12:49 PM, Jakub Kicinski wrote:
> On Sun, 6 Sep 2020 20:31:16 -0700 Randy Dunlap wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> Fix kernel-doc warning in <linux/netdevice.h>:
>>
>> ../include/linux/netdevice.h:2158: warning: Function parameter or member 'proto_down_reason' not described in 'net_device'
>>
>> Fixes: 829eb208e80d ("rtnetlink: add support for protodown reason")
>> Signed-off-by: Randy Dunlap <rdunlap@infradead.org>
>> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
> 
> Applied, but I had to fix a checkpatch warning about a space before a
> tab..

Ohhh, thanks.
I blame that on (g)vim providing some automatic indentation that I didn't want.

-- 
~Randy

