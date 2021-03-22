Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7EDAA344D18
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 18:18:00 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232070AbhCVRRd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 13:17:33 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232154AbhCVRRJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 13:17:09 -0400
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8AA7EC061574;
        Mon, 22 Mar 2021 10:17:08 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=lUaoQEVmOtyqsF9DcikK2Frfj8zPoup60J3e8MKVBxw=; b=IsVPi9jJSbwLH3OFCpQgFYAqeN
        xbySqHSbx103kN5qUjuCSWjjpm0WHlgTDB++a+ZmSSashbln46ZCUpVdaeyBaWfu9IU7sXN8xvFh3
        iWjl5uP8eu+nAYta3dixGjphUOaOUH+9rTj/lX7rMNiMJStSK6QvkCR1q+7MNpjcR1tXOI4uIryVL
        8OfqNzpqDTdsYqRHkulIwZOoZMQpautIqacqN9eM9RPvVCptBvjI8SDWbOK0fQidQ3HaqRXZR0dGP
        1Ml2k9egJ/8NMbSddF21VGE41qDiDLAgp5DyLxwjtjlf9RL378RLZ510EO4vlINc5efF9FAyCQFdJ
        LY5wzORQ==;
Received: from [2601:1c0:6280:3f0::3ba4]
        by casper.infradead.org with esmtpsa (Exim 4.94 #2 (Red Hat Linux))
        id 1lOOAH-008pbw-BN; Mon, 22 Mar 2021 17:16:34 +0000
Subject: Re: linux-next: Tree for Mar 22 (net/ipa)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Alex Elder <elder@kernel.org>
References: <20210322185251.66566cfd@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <83366bbc-af28-4ffd-2a25-f688a52f9239@infradead.org>
Date:   Mon, 22 Mar 2021 10:16:26 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:78.0) Gecko/20100101
 Thunderbird/78.8.0
MIME-Version: 1.0
In-Reply-To: <20210322185251.66566cfd@canb.auug.org.au>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/22/21 12:52 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Warning: Some of the branches in linux-next may still based on v5.12-rc1,
> so please be careful if you are trying to bisect a bug.
> 
> News: if your -next included tree is based on Linus' tree tag
> v5.12-rc1{,-dontuse} (or somewhere between v5.11 and that tag), please
> consider rebasing it onto v5.12-rc2. Also, please check any branches
> merged into your branch.
> 
> Changes since 20210319:
> 


on i386:

ld: drivers/net/ipa/gsi.o: in function `gsi_ring_alloc':
gsi.c:(.text+0x926): undefined reference to `__umoddi3'


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
