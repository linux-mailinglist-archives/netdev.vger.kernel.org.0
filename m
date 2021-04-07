Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5BCB6356E43
	for <lists+netdev@lfdr.de>; Wed,  7 Apr 2021 16:15:19 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348135AbhDGOP1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 7 Apr 2021 10:15:27 -0400
Received: from mail.kernel.org ([198.145.29.99]:43816 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232839AbhDGOP0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 7 Apr 2021 10:15:26 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id E15AA611C1;
        Wed,  7 Apr 2021 14:15:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1617804917;
        bh=4dAXGkYYZB5TXeJgBHTYXt+orGZ5QFeNREc+QjqhJj8=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=fmZZgbJzkCfdBcuGSYUwDEaGWnQi9HR35nS9RCKuuW95JoL0TSnoz/xnIdhRbMpPf
         MM7cpkfZbL1jZjTl72MfUAu2Wj8zhjA3ffHWKbRueTmNwBp0XTvFd0nGieCo0FrxBn
         L+4YApu4Fcr4Auw4dkR50vEgXM8EtgdZYQYhGg1zNGESC2LWylGBdx6v7GMDnUG0Rw
         Y9X/GcXh891dUx5Mpg6sBC46pGlAjQl3Huj0utPYiJfbbrwFgPuG18Enhg4S93xYok
         3FSy+C+UGLRNRrpfeH2Low+ZoA6UfanfDaE3Vn6KzHJGbgm0hsS4bpWdAuKaeve82l
         dLMb7zBmtaYrg==
Date:   Wed, 7 Apr 2021 10:15:15 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        liuyacan <yacanliu@163.com>,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eric Dumazet <eric.dumazet@gmail.com>
Subject: Re: [PATCH AUTOSEL 5.10 09/33] net: correct sk_acceptq_is_full()
Message-ID: <YG2+cyUkFI87DRB3@sashalap>
References: <20210329222222.2382987-1-sashal@kernel.org>
 <20210329222222.2382987-9-sashal@kernel.org>
 <YGtd9kaPvfSUKERW@horizon.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <YGtd9kaPvfSUKERW@horizon.localdomain>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 05, 2021 at 03:59:02PM -0300, Marcelo Ricardo Leitner wrote:
>On Mon, Mar 29, 2021 at 06:21:57PM -0400, Sasha Levin wrote:
>> From: liuyacan <yacanliu@163.com>
>>
>> [ Upstream commit f211ac154577ec9ccf07c15f18a6abf0d9bdb4ab ]
>>
>> The "backlog" argument in listen() specifies
>> the maximom length of pending connections,
>> so the accept queue should be considered full
>> if there are exactly "backlog" elements.
>
>Hi Sasha. Can you please confirm that this one was dropped as well?
>Thanks.

Yup!

-- 
Thanks,
Sasha
