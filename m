Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1E3EB23FE9D
	for <lists+netdev@lfdr.de>; Sun,  9 Aug 2020 15:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726207AbgHINvf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 9 Aug 2020 09:51:35 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55912 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726070AbgHINvX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 9 Aug 2020 09:51:23 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2CFA6C061756
        for <netdev@vger.kernel.org>; Sun,  9 Aug 2020 06:51:22 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=eQOvWGmUJMXPIJVB798XbgQuvkoF8pF5DTbRzf6kKvY=; b=dxmEUAxoRemR0+CrG+gfiO0wvq
        FEH+tXRLOWWkLBXYMTU756bt/EQThi6zCChVQXp51077EyOvH+q3kfO9vX33t7SG0nWGBYZz52LQH
        cmhQB319yvuw0L0edCDNSmOi0Fp2n+dJU5MjlyXLkLSZRvlx/vpzUqyBFVYcIqD0q0UKEnqy/AgY8
        XDdGrB0x3DCUe46SPPOm2ytJO0n40VKIf4UxMwDYN44g1DYO3K6eDBXDYu0G8pzhQ5OS5bF+oGHo3
        ps+K28/3ii/bS4UFfdyyjDReNGl3LvPkRdde5cIZG+XHLNX9I0PXSg/ELXMZDnVhcpn0Sqfz9mON3
        jCEIufEw==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1k4lj1-0007LC-1b; Sun, 09 Aug 2020 13:50:59 +0000
Subject: Re: [DRAFT PATCH] random32: make prandom_u32() output unpredictable
To:     George Spelvin <lkml@SDF.ORG>, netdev@vger.kernel.org
Cc:     w@1wt.eu, aksecurity@gmail.com, torvalds@linux-foundation.org,
        edumazet@google.com, Jason@zx2c4.com, luto@kernel.org,
        keescook@chromium.org, tglx@linutronix.de, peterz@infradead.org,
        tytso@mit.edu, lkml.mplumb@gmail.com, stephen@networkplumber.org,
        fw@strlen.de
References: <20200808152628.GA27941@SDF.ORG> <20200809065744.GA17668@SDF.ORG>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f6b5f582-ae4f-e019-d98a-e4fed917c3cd@infradead.org>
Date:   Sun, 9 Aug 2020 06:50:52 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200809065744.GA17668@SDF.ORG>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8/8/20 11:57 PM, George Spelvin wrote:



+#elif BITS_PER_LONG == 23


s/23/32/ ???

-- 
~Randy

