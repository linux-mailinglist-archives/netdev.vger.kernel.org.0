Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4B8D14553C5
	for <lists+netdev@lfdr.de>; Thu, 18 Nov 2021 05:24:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242956AbhKRE07 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 17 Nov 2021 23:26:59 -0500
Received: from mail.kernel.org ([198.145.29.99]:38440 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S242950AbhKRE0x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 17 Nov 2021 23:26:53 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 0632261502;
        Thu, 18 Nov 2021 04:23:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637209434;
        bh=uwY7nwmQd+1LT9KnHGyvcUhCYJlQMs2xtR5V6pFNyoY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Zal7pTrrTUiD3gcHebrTtq4sP9hJSand+qT9C8vsJgjVIre9ijKxq4JNwXEM7KXVK
         YlAOUhU7MxM0IZ851EcHK+jCGZwVW7UcHw5eq+9RUujIB+affWOl2oyUdt0Md7sFxz
         eioBr3ia6/HeYU2YAZS0BpNJHaLqJhoFLWMEaBl2hCDnWGUcwaUhzxYGi2uchA24oY
         omkRG6eZ9fr0kL9ScL+jg//OKJjOl0532lg7qNGtnABF8Ys7rRSTSURCCIJ7ZM8eXF
         iIkRyDnl7HlrsuY4t5OGsWgwAcXFiqz9dyl4TMXhM4OumUGA3Rt6Jgim1CUiamljYc
         ndaA6ykwaAq2Q==
Date:   Wed, 17 Nov 2021 20:23:53 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Riccardo Paolo Bestetti <pbl@bestov.io>,
        Denis Kirjanov <dkirjanov@suse.de>,
        David Ahern <dsahern@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Hideaki YOSHIFUJI <yoshfuji@linux-ipv6.org>,
        Shuah Khan <shuah@kernel.org>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-kselftest@vger.kernel.org
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Message-ID: <20211117202353.0560d9ad@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a8d9f99d-8aa8-3186-fcca-c0f7b7f37327@gmail.com>
References: <CFSH0AY7X60L.1KW9K4CV82NQG@enhorning>
        <a8d9f99d-8aa8-3186-fcca-c0f7b7f37327@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 17 Nov 2021 20:59:16 -0700 David Ahern wrote:
> On 11/17/21 5:14 PM, Riccardo Paolo Bestetti wrote:
> >> That was done intentionally in commit 0ce779a9f501
> > 
> > Should I remove this from the patch? Is there a particular reason why
> > this was done in ping.c but not in the other places?
> 
> exactly. I did not see the big deal about changing it.

Applied, thanks!
