Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A6DC12E1D33
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 15:15:10 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729153AbgLWOPD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 09:15:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:55968 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728705AbgLWOPB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 09:15:01 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1276C2313C;
        Wed, 23 Dec 2020 14:14:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608732861;
        bh=A37SSG8eWeOuwQ8uyZJAhWEriNMTI/mw/UyINjzNu4A=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=p6zvua8a42L42/819eIXq6I+lLKWtfzjstmWe8yYFS6kifaHIm/rPDJriH5BOmBOG
         JgQJ5n+b0kFkmCcG3BDmbvEWHlGP929GWvQogCOQrI+mzj+QPUoyPA/CT012cmEfM+
         HSdYSgXTdkUz2Cy9ngCVWlzsXSwB8YS3ZhYuu7qE78GKL6rKttultdNGfx82006/Vj
         hT2QqVHvQJ1jtLjvim62kQNuMoDRvaXKs6VzKGAFc4dG2AHAI2Ek4dwi5FH5QL+A7/
         nTJxMZs+UfMayIhkaBz32pTSnLdPFBuMqvgB0khXTTuqS7LSHD/95IrRGW7TAcQMU3
         yWxzNTYgN99Eg==
Date:   Wed, 23 Dec 2020 09:14:19 -0500
From:   Sasha Levin <sashal@kernel.org>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Randy Dunlap <rdunlap@infradead.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 4.4 03/38] staging: wimax: depends on NET
Message-ID: <20201223141419.GA2790422@sasha-vm>
References: <20201223022516.2794471-1-sashal@kernel.org>
 <20201223022516.2794471-3-sashal@kernel.org>
 <20201222183801.327b964f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20201222183801.327b964f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Dec 22, 2020 at 06:38:01PM -0800, Jakub Kicinski wrote:
>On Tue, 22 Dec 2020 21:24:41 -0500 Sasha Levin wrote:
>> From: Randy Dunlap <rdunlap@infradead.org>
>>
>> [ Upstream commit 9364a2cf567187c0a075942c22d1f434c758de5d ]
>>
>> Fix build errors when CONFIG_NET is not enabled. E.g. (trimmed):
>
>This one can be dropped, before wimax moved to staging the dependency
>was met thru the directory structure.

I'll drop it, thanks.

-- 
Thanks,
Sasha
