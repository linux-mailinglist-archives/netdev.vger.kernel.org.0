Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 653BC2B7E0E
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 14:09:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726404AbgKRNFq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 08:05:46 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54360 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725747AbgKRNFp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Nov 2020 08:05:45 -0500
Received: from mail-pf1-x444.google.com (mail-pf1-x444.google.com [IPv6:2607:f8b0:4864:20::444])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6F6D5C0613D4;
        Wed, 18 Nov 2020 05:05:45 -0800 (PST)
Received: by mail-pf1-x444.google.com with SMTP id a18so1396919pfl.3;
        Wed, 18 Nov 2020 05:05:45 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=XRVwRvPUpO5lAeVSCk/RI3t5RFkIeM28InItYQR1/4E=;
        b=frehTg+LLpugLVl/IMcRdIiXpZ2FLawcL2JTXU/bwbIMCNX8hGnGPXZRRCamL2JEPg
         09oSLsWsWZ6EMWIcKrpQA5XSWFsE2gk2SBc/kwABBjn6NgZshxtjASa18n1yjpKY4dLy
         Rtzo8NCuoXnPqi5dAhRJtDLJLzHjbxf1kzIZXpYVyYc6AWA8A2DnAQ6PzEpXlJ0/Eee6
         E3+cTmUskWV5o7YWnNn6phxNBcEMMnE6s3IZr2JKnMN9fYmPPWxxPwdi15BZ926X9QwW
         IT3r36868mOH+6lytJgCyejBgmKiBm4ieB7VmgMDH/QXOE45rL6dmdygUbYQe43Vsxlf
         wSwQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=XRVwRvPUpO5lAeVSCk/RI3t5RFkIeM28InItYQR1/4E=;
        b=PPvrtvoqkHP2gL5uAl8SQH2RwAgc+jywJUSOaXAbq3BGLn0hJwup9Vy6Nt7y4ECUu3
         v94+WFXYeAEFo4K1kcQgLSe81R6aemEfFIgUgo+Mw1xNPBw2YIwV/SgsLu7JCYClC7bL
         dZRJP9YmOsMmX25s5tAPnFxOQmQ99O68655SlD09UzJ/6adNrenYSNb0VwapVSS+/HXM
         +nTZld+8IptKQwKFvtVMWJZEj/64zkeV8FfhEXI1xhOlxLT43KhOuIp3b07rOOV04GFP
         pk3nInw9eL0Vh4oRzYRKIvwhvzbA/tSRkIy6/n5NRtx+MDrrB1FEHRv9tpoJsJw3394N
         kxYA==
X-Gm-Message-State: AOAM532M+EluICXg+Bul44ocO+9DEHX36TlTdx1H8AA4oMN90+EnoB7n
        7nVl0s67e+3HjaMz3iz5c+FHnbFrVcM=
X-Google-Smtp-Source: ABdhPJxHctIx3YTqv+g94WC6V+QjEzSazTgaeB1lpWI9fpFF29pVpFuHPC1ZdlAIbvv2Gvx/+YO1JQ==
X-Received: by 2002:a65:40ca:: with SMTP id u10mr7908935pgp.71.1605704745049;
        Wed, 18 Nov 2020 05:05:45 -0800 (PST)
Received: from hoboy.vegasvil.org (c-73-241-114-122.hsd1.ca.comcast.net. [73.241.114.122])
        by smtp.gmail.com with ESMTPSA id j26sm7743054pgn.27.2020.11.18.05.05.43
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 18 Nov 2020 05:05:43 -0800 (PST)
Date:   Wed, 18 Nov 2020 05:05:41 -0800
From:   Richard Cochran <richardcochran@gmail.com>
To:     Ahmad Fatoum <a.fatoum@pengutronix.de>
Cc:     kernel@pengutronix.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] ptp: document struct ptp_clock_request
 members
Message-ID: <20201118130541.GD23320@hoboy.vegasvil.org>
References: <20201117213826.18235-1-a.fatoum@pengutronix.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20201117213826.18235-1-a.fatoum@pengutronix.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Nov 17, 2020 at 10:38:26PM +0100, Ahmad Fatoum wrote:
> It's arguable most people interested in configuring a PPS signal
> want it as external output, not as kernel input. PTP_CLK_REQ_PPS
> is for input though. Add documentation to nudge readers into
> the correct direction.
> 
> Signed-off-by: Ahmad Fatoum <a.fatoum@pengutronix.de>

Thanks!

Acked-by: Richard Cochran <richardcochran@gmail.com>
