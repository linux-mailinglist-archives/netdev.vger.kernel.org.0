Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB4BC35BAD1
	for <lists+netdev@lfdr.de>; Mon, 12 Apr 2021 09:26:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236883AbhDLH1H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 12 Apr 2021 03:27:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:36598 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231274AbhDLH1G (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 12 Apr 2021 03:27:06 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC7D061074;
        Mon, 12 Apr 2021 07:26:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618212408;
        bh=mAYfLLim48mm49gI5vCZfL46hyivSKIseBt28Qk79uM=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=prO+tsrN7Jy/aYYZXuxABlwpmapRm8IGVpjWhDQ1hCC7ID5WAA+MnNiT1r96f2dnd
         V/opI5sMcRMEjudFoDe/5mCEzUkPp7iMQDwXr6oByIpMdId4/Nk8TNV9TaMBnU5MrD
         pA8da4w07eO2fVbFsVvEmp8axAfgKMApkoZ3JDAiL1Nl4mWuScBekJLKKdigusPKLb
         26Ly6GRf8oYUpuP2qXveDGxI+aZkGVkWqsGx72gDuILwjTYB95oDDzEfFbFvorVYAv
         cewIOlvxgFfd04wsj+EWxGFppi8y7mX1OUsTNj2kUnZq0VU7jO4/kI+a008tewy8yo
         tQZxXiGKqPEHw==
Date:   Mon, 12 Apr 2021 10:26:24 +0300
From:   Leon Romanovsky <leon@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, kuba@kernel.org, bjorn.andersson@linaro.org,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        subashab@codeaurora.org, elder@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/7] net: ipa: ipa_stop() does not return an
 error
Message-ID: <YHP2IKZ7pB+l4a6O@unreal>
References: <20210409180722.1176868-1-elder@linaro.org>
 <20210409180722.1176868-5-elder@linaro.org>
 <YHKYWCkPl5pucFZo@unreal>
 <1f5c3d2c-f22a-ef5e-f282-fb2dec4479f3@linaro.org>
 <YHL5fwkYyHvQG2Z4@unreal>
 <6e0c08a0-aebd-83b2-26b5-98f7d46d6b2b@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <6e0c08a0-aebd-83b2-26b5-98f7d46d6b2b@linaro.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Apr 11, 2021 at 08:42:15AM -0500, Alex Elder wrote:
> On 4/11/21 8:28 AM, Leon Romanovsky wrote:
> >> I think *not* checking an available return value is questionable
> >> practice.  I'd really rather have a build option for a
> >> "__need_not_check" tag and have "must_check" be the default.
> > __need_not_check == void ???
> 
> I'm not sure I understand your statement here, but...

We are talking about the same thing. My point was that __need_not_check
is actually void. The API author was supposed to declare that by
declaring that function doesn't return anything.

Thanks
