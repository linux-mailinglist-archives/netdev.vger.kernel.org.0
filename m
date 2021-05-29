Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D2DA6394DA1
	for <lists+netdev@lfdr.de>; Sat, 29 May 2021 20:17:20 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229800AbhE2SK0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 29 May 2021 14:10:26 -0400
Received: from mail.kernel.org ([198.145.29.99]:44768 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229726AbhE2SKZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 29 May 2021 14:10:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7B2B361153;
        Sat, 29 May 2021 18:08:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1622311728;
        bh=5Qdz461gMcaT09Lh5nRC5Tb/An/G/cXNZMLamFs1vJ8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aGvwISJwdQSEUTZ1W21Ne/p0qVOT1HSliRX1SJiUdEHhYZ1LLC9P+z/Xcqq88+jsy
         xVtlgnndaeVtwwNCnWVc6XCy8bDz17gMgNwruR+9BmJZFKDt1PJxnDcyON3dWZlsC1
         wSsmtdF3+PUpvmntQxliCDnmIYDUDXffAALr6nI6Kr2vclgEzKIdm4E+pd78+58EPF
         xT1ZYcbBwqbw1VABRj6Gt49JGuhKlwd62Clp+Xana6hw8q379k6NxLRqYv1w5QtZtL
         OfROJ7fGf1Pa0kvFdbOCAXP+pB4wtXZXVWdwQHg+yIV5UU/m9iVpR3lRI+RIcIax2E
         InTnOJevhKr9w==
Date:   Sat, 29 May 2021 11:08:47 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     YueHaibing <yuehaibing@huawei.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net-next] pktgen: Use BIT(x) macro
Message-ID: <20210529110847.53473ab0@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20210529114559.24604-1-yuehaibing@huawei.com>
References: <20210529114559.24604-1-yuehaibing@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 29 May 2021 19:45:59 +0800 YueHaibing wrote:
> BIT(x) improves readability and safety with respect to shifts.

Some developers prefer not to use BIT(). I'm not applying these.
