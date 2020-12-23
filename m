Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B432A2E20F4
	for <lists+netdev@lfdr.de>; Wed, 23 Dec 2020 20:40:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728429AbgLWThX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Dec 2020 14:37:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:33254 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgLWThX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Dec 2020 14:37:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4222422473;
        Wed, 23 Dec 2020 19:36:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1608752202;
        bh=b9PHf+sc0JgKLo+shuIsVtILQUqU5M25ZJsoEBuwTtY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=lbvBxs6rN4zXjbkRFr5Hivzw8qSeJF0kqttSdovV3ua8EWydYAXk8HkZtlJGTwCgV
         wGO2klBioXmnO7WffWYADZQiaa04WzxEVBY8L80b8hgsiGlZAuLIq1xYWjnOCYUC97
         j/2yMspeT7lpCKjHaNZV9qIt0MKFE97maAapccq8Aa01/hp68NzAetVM9/gR6Bo11B
         d2267rN4hjJ1jfT/MSxicLOX04q7aY1KYLBZSl20877oh/gHmgG8sqC4HND62KaTkY
         1pfHJRNAb2TkeIE/WmPUEDTo81SRQT09OaKIozg3D1eT7qyHq+GeqB1vFZ57pQCMl0
         OLvI4xD4EMTAA==
Date:   Wed, 23 Dec 2020 11:36:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Georgi Djakov <georgi.djakov@linaro.org>
Cc:     Alex Elder <elder@linaro.org>, davem@davemloft.net,
        evgreen@chromium.org, cpratapa@codeaurora.org,
        bjorn.andersson@linaro.org, subashab@codeaurora.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net] net: ipa: fix interconnect enable bug
Message-ID: <20201223113641.0d1e5b02@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9601b599-3edb-8fff-5b22-904cca62fbda@linaro.org>
References: <20201222151613.5730-1-elder@linaro.org>
        <9601b599-3edb-8fff-5b22-904cca62fbda@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 22 Dec 2020 18:18:31 +0200 Georgi Djakov wrote:
> On 12/22/20 17:16, Alex Elder wrote:
> > When the core clock rate and interconnect bandwidth specifications
> > were moved into configuration data, a copy/paste bug was introduced,
> > causing the memory interconnect bandwidth to be set three times
> > rather than enabling the three different interconnects.
> > 
> > Fix this bug.
> > 
> > Fixes: 91d02f9551501 ("net: ipa: use config data for clocking")
> > Signed-off-by: Alex Elder <elder@linaro.org>  
> 
> Reviewed-by: Georgi Djakov <georgi.djakov@linaro.org>

Applied, thanks!
