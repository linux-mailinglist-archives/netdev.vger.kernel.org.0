Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A839F2BBC63
	for <lists+netdev@lfdr.de>; Sat, 21 Nov 2020 03:51:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727111AbgKUCtZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 21:49:25 -0500
Received: from mail.kernel.org ([198.145.29.99]:50638 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726334AbgKUCtZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 21:49:25 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 56412223FD;
        Sat, 21 Nov 2020 02:49:24 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605926964;
        bh=9QYJckpyjdULNUKieI6TKMpdUzCzKSWi4fHXZkK8bmY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=csIn9vy4wkwa3n/8VboW75DntPNdSOw+NCGzQ4wepOJyn9YG+xB6EoWS+P95xJHS+
         ITzonIoCVxeAIJ1l5lKbonJ/zDA5HCanW1ng79Rwh1D7SQyCBC0T6tAxCm20LSk6rC
         oOUGLbB4PakR8dTKEFnyCe6sOPQ9xArrnr5vyY48=
Date:   Fri, 20 Nov 2020 18:49:23 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Alex Elder <elder@linaro.org>
Cc:     davem@davemloft.net, evgreen@chromium.org, subashab@codeaurora.org,
        cpratapa@codeaurora.org, bjorn.andersson@linaro.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 4/6] net: ipa: support retries on generic GSI
 commands
Message-ID: <20201120184923.404c30bb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201119224929.23819-5-elder@linaro.org>
References: <20201119224929.23819-1-elder@linaro.org>
        <20201119224929.23819-5-elder@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 19 Nov 2020 16:49:27 -0600 Alex Elder wrote:
> +	do
> +		ret = gsi_generic_command(gsi, channel_id,
> +					  GSI_GENERIC_HALT_CHANNEL);
> +	while (ret == -EAGAIN && retries--);

This may well be the first time I've seen someone write a do while loop
without the curly brackets!
