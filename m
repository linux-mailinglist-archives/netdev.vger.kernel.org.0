Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D3A232BBCC9
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 04:49:33 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727186AbgKUDqn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 22:46:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:56490 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726189AbgKUDqn (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 22:46:43 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id A952522269;
        Sat, 21 Nov 2020 03:46:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605930403;
        bh=9geNxRcf6dcDFV5lHHSHK2IXpU9aW1atMIg2Avsic38=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zMfU3edBuZTidhvllTU1/znfs9HdCC1Ei1HDKHBoJRf2KJHpHmZAgLnMuGLOQMiW9
         /3SDOw8o5i2ukZtmYZDxuB1bINeRK63JazyfIGGxRPJDm3L36WpS2e/cGFRMyk1FKD
         E6aRhjo7GCI+Eqf19K8hjqM0LSTnE6Am2hwgorOA=
Date:   Fri, 20 Nov 2020 19:46:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: ipa: support retries on generic GSI
 commands
Message-ID: <20201120194641.159a54bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <88104bdd-f464-326a-264e-570a8e4a81c0@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
        <20201119224929.23819-5-elder@linaro.org>
        <20201120184923.404c30bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <88104bdd-f464-326a-264e-570a8e4a81c0@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 20 Nov 2020 21:31:09 -0600 Alex Elder wrote:
> On 11/20/20 8:49 PM, Jakub Kicinski wrote:
> > On Thu, 19 Nov 2020 16:49:27 -0600 Alex Elder wrote:  
> >> +	do
> >> +		ret = gsi_generic_command(gsi, channel_id,
> >> +					  GSI_GENERIC_HALT_CHANNEL);
> >> +	while (ret == -EAGAIN && retries--);  
> > 
> > This may well be the first time I've seen someone write a do while loop
> > without the curly brackets!  
> 
> I had them at one time, then saw I could get away
> without them.  I don't have a preference but I see
> you accepted it as-is.

It was just an offhand comment, I don't have anything against it :)
