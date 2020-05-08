Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C98F61CB25E
	for <lists+netdev@lfdr.de>; Fri,  8 May 2020 16:58:38 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728015AbgEHO6h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 8 May 2020 10:58:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52428 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727891AbgEHO6g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 8 May 2020 10:58:36 -0400
X-Greylist: delayed 182 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Fri, 08 May 2020 07:58:36 PDT
Received: from mo6-p00-ob.smtp.rzone.de (mo6-p00-ob.smtp.rzone.de [IPv6:2a01:238:20a:202:5300::3])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 657ACC061A0C
        for <netdev@vger.kernel.org>; Fri,  8 May 2020 07:58:36 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; t=1588949914;
        s=strato-dkim-0002; d=fami-braun.de;
        h=Message-ID:References:In-Reply-To:Subject:Cc:To:From:Date:
        X-RZG-CLASS-ID:X-RZG-AUTH:From:Subject:Sender;
        bh=S0Jzdenw1RAdqyAMwr4Z2fs7clekZJ8D9kuiafLToWQ=;
        b=FOl/2PB2FkirUY5z6oddI+PHYZj8Sbze0hE1TtsChgUD8tXOGK9BTtruBE5Wy4QSV6
        VrLXPjrKq/6f+fraMTf8fd67CopSpz5xMX3Kc8A63O5B4mQTigPAAhyzaofsckoQ1H1h
        341Vet4cuL/4VfiWY8WSueEa8KJJdrRnbPM7m8y0F7M4swUfhVYwlQP+gdbqGCuFSs4U
        gF9+4PNb8HXwxFA+NHan17Dx5DsCJvjVu1GhiHzZQ6oznEKtuKSpFfznO/aFW1Tirk9M
        LYuT5wCVnBZCl2wrSsVHJ/2aKgj9TwrdC3gi/AFTUa+v7c1TIkSF5l3uqM4yRTBnbuvr
        4vjg==
X-RZG-AUTH: ":P20JeEWkefDI1ODZs1HHtgV3eF0OpFsRaGIBEm4ljegySSvO7VhbcRIBGrxpew95lCZXkZzYMeY7"
X-RZG-CLASS-ID: mo00
Received: from dynamic.fami-braun.de
        by smtp.strato.de (RZmta 46.6.2 DYNA|AUTH)
        with ESMTPSA id g05fffw48EtWCJ4
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256 bits))
        (Client did not present a certificate);
        Fri, 8 May 2020 16:55:32 +0200 (CEST)
Received: from dynamic.fami-braun.de (localhost [127.0.0.1])
        by dynamic.fami-braun.de (fami-braun.de) with ESMTP id 39C4F15411E;
        Fri,  8 May 2020 16:55:32 +0200 (CEST)
Received: from 37j0seOp5tpthBNpVswOMAVppT2ewdbCtXPO6YXc7vDl4HW03rSOTg==
 (Hxqut+P/ksY2c5cM8qp90OUksKeqRVV9)
 by webmail.fami-braun.de
 with HTTP (HTTP/1.1 POST); Fri, 08 May 2020 16:55:19 +0200
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Fri, 08 May 2020 16:55:19 +0200
From:   michael-dev <michael-dev@fami-braun.de>
To:     Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
Cc:     netdev@vger.kernel.org, Li RongQing <roy.qing.li@gmail.com>
Subject: Re: [PATCH] bridge: increase mtu to 64K
In-Reply-To: <5e214486-5e65-36ce-5145-b3cb77a81503@cumulusnetworks.com>
References: <aa8b1f36e80728f6fae31d98ba990a2b509b1e34.1588847509.git.michael-dev@fami-braun.de>
 <5e214486-5e65-36ce-5145-b3cb77a81503@cumulusnetworks.com>
User-Agent: Roundcube Webmail/1.4.4
Message-ID: <6fcef8210b025c250887f473adbc1636@fami-braun.de>
X-Sender: michael-dev@fami-braun.de
X-Virus-Scanned: clamav-milter 0.102.2 at gate
X-Virus-Status: Clean
X-Spam-Status: No, score=0.0 required=5.0 tests=UNPARSEABLE_RELAY
        autolearn=ham autolearn_force=no version=3.4.2
X-Spam-Checker-Version: SpamAssassin 3.4.2 (2018-09-13) on gate.zuhause.all
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 07.05.2020 13:06, schrieb Nikolay Aleksandrov:
> That isn't correct, have you tested with a recent kernel?
> After:
> commit 804b854d374e
> Author: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
> Date:   Fri Mar 30 13:46:19 2018 +0300

Thanks for pointing out, I'm sorry my test kernel was too old.

Regards,
Michael
