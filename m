Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5E497382AB6
	for <lists+netdev@lfdr.de>; Mon, 17 May 2021 13:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236640AbhEQLSd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 17 May 2021 07:18:33 -0400
Received: from ozlabs.org ([203.11.71.1]:49725 "EHLO ozlabs.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236514AbhEQLSc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 17 May 2021 07:18:32 -0400
Received: from authenticated.ozlabs.org (localhost [127.0.0.1])
        (using TLSv1.3 with cipher TLS_AES_256_GCM_SHA384 (256/256 bits)
         key-exchange ECDHE (P-256) server-signature RSA-PSS (4096 bits) server-digest SHA256)
        (No client certificate requested)
        by mail.ozlabs.org (Postfix) with ESMTPSA id 4FkGn600Vgz9sWQ;
        Mon, 17 May 2021 21:17:13 +1000 (AEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=ellerman.id.au;
        s=201909; t=1621250235;
        bh=nJjXqApLsijq4iamHZjICarpBzR+JQck/GF+uqkszS8=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=N+V8hRpEakOARG2G2zsylDtnrtm26/IFpj+b8IdhWtSPtzR0ev66qahUuCSAGoHAN
         hfsdx08YzYKbX54mNSOnzz6lXmiGemNxw+pbeu3VKi+wYKXseahPwGzJ23NTSANaUh
         xHwGCewelibArv6jzWXb3uBBpegWOMQL0FvHcxreOmoGXvQsHdREig+Mco8inN2fLW
         yUCyLkDIrpCUOTET0vsu942jlCOOgjCNMjTU/+inmTUqbkqhsEP3lnUVJbw3ykYlBK
         fkn1/1hWfVKZzV1UNQKhWHj8U36M4+EXfZM47XlKtCbcJeoysuFvgGbUFAYs889gPp
         msLJxeIat6hdA==
From:   Michael Ellerman <mpe@ellerman.id.au>
To:     Guenter Roeck <linux@roeck-us.net>,
        Christophe Leroy <christophe.leroy@csgroup.eu>,
        Wim Van Sebroeck <wim@linux-watchdog.org>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
Cc:     linux-kernel@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        linux-watchdog@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH] watchdog: Remove MV64x60 watchdog driver
In-Reply-To: <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
References: <9c2952bcfaec3b1789909eaa36bbce2afbfab7ab.1616085654.git.christophe.leroy@csgroup.eu>
 <31d702e5-22d1-1766-76dd-e24860e5b1a4@roeck-us.net>
Date:   Mon, 17 May 2021 21:17:13 +1000
Message-ID: <87im3hk3t2.fsf@mpe.ellerman.id.au>
MIME-Version: 1.0
Content-Type: text/plain
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Guenter Roeck <linux@roeck-us.net> writes:
> On 3/18/21 10:25 AM, Christophe Leroy wrote:
>> Commit 92c8c16f3457 ("powerpc/embedded6xx: Remove C2K board support")
>> removed the last selector of CONFIG_MV64X60.
>> 
>> Therefore CONFIG_MV64X60_WDT cannot be selected anymore and
>> can be removed.
>> 
>> Signed-off-by: Christophe Leroy <christophe.leroy@csgroup.eu>
>
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
>
>> ---
>>  drivers/watchdog/Kconfig       |   4 -
>>  drivers/watchdog/Makefile      |   1 -
>>  drivers/watchdog/mv64x60_wdt.c | 324 ---------------------------------
>>  include/linux/mv643xx.h        |   8 -
>>  4 files changed, 337 deletions(-)
>>  delete mode 100644 drivers/watchdog/mv64x60_wdt.c

I assumed this would go via the watchdog tree, but seems like I
misinterpreted.

Should I take this via the powerpc tree for v5.14 ?

cheers
