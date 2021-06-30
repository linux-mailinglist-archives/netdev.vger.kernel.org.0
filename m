Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 655383B7ADD
	for <lists+netdev@lfdr.de>; Wed, 30 Jun 2021 02:11:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235523AbhF3AN7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 20:13:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33806 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233056AbhF3AN6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 29 Jun 2021 20:13:58 -0400
Received: from mail-pg1-x52f.google.com (mail-pg1-x52f.google.com [IPv6:2607:f8b0:4864:20::52f])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5D83DC061760
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 17:11:29 -0700 (PDT)
Received: by mail-pg1-x52f.google.com with SMTP id g22so392648pgl.7
        for <netdev@vger.kernel.org>; Tue, 29 Jun 2021 17:11:29 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=xxdKls3ck6VlcWMuMFmDdEJWektJNb/3EsbN7zICsY0=;
        b=cWXL9m3mH03ek5F/RstwU68+Co2/jnhkdPCSXH9UDgRUBwVPwqB97ueoKcZCocamqT
         eu6e6TeKNvN6TB7UTPBYhXAYQlEU5tQ7eMLHxmeUnW0YhI+1TRtbaBG5TByNF6WnMnTD
         pVPaZIHhXUrFo1ZDHUCL1Bb7QJVjGV47AOwGGASKu7kaAYMyiPlfo7wQPUOMgdebUFJU
         EefaeUSu4A3vJZ1uoco0nQUk8grbDdyej2sV7La9EIbqOLYsq5HUpmxez4MlVrkap5oz
         VGVU7Yuy37fkUh6Dst98XcPB2FzP3pLA5L7saNbjxkiDEAHO4HzAI+xWeYOfqNLdcpbe
         wvQA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=xxdKls3ck6VlcWMuMFmDdEJWektJNb/3EsbN7zICsY0=;
        b=TFjLs+XobRhgkHCaoGkKUbC1D/me6m6pjl2jeyr/5vhhoPciuyipnewhYCaxmkSdzh
         Gm3iC69y0visdJS606TXhHXwJ24dhjMVLmTw3VjTZVfsrYlw28/A0U49HLtkddnUnDoY
         VDKgs7SEDjjFrO1GCcAyWWJmqGbqlTFcdKx8HnWxlUzrPs8JpmqnkVCLbFKVcM+YwQg4
         dXfjnMlfhRblRjywN7pZmSHIlO/wUbLr7aENaxTCTBFN691yeKZjHTlVT9d9vPCaCfLt
         csPqWB11C5xyv9y7/EoGo7WIeMOPhsOj6CnJj+8H3oAvFKBsjTAHToTPMg9lnRkF3Dxa
         oyIA==
X-Gm-Message-State: AOAM531IgB6qimRWNiJOgWb6HyeRW6onhuPVqy+hNYz3N9rtf9P+kEOk
        j0IxN0Q0pIqFe1enHpPyvbsFRXGhZjA=
X-Google-Smtp-Source: ABdhPJyETv4aY/cKrKRNTp/7S0bF5hU6LfxjzomCRTotuRrN1FE3gU3u2eCN1U9CwD8uiOnl+Mlt6w==
X-Received: by 2002:a63:d60b:: with SMTP id q11mr9638904pgg.270.1625011888851;
        Tue, 29 Jun 2021 17:11:28 -0700 (PDT)
Received: from hoboy.vegasvil.org ([2601:645:c000:35:e2d5:5eff:fea5:802f])
        by smtp.gmail.com with ESMTPSA id m4sm4463511pjv.41.2021.06.29.17.11.27
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Tue, 29 Jun 2021 17:11:28 -0700 (PDT)
Date:   Tue, 29 Jun 2021 17:11:26 -0700
From:   Richard Cochran <richardcochran@gmail.com>
To:     patchwork-bot+netdevbpf@kernel.org
Cc:     Jonathan Lemon <jonathan.lemon@gmail.com>, netdev@vger.kernel.org,
        kernel-team@fb.com
Subject: Re: [PATCH] ptp: Set lookup cookie when creating a PTP PPS source.
Message-ID: <20210630001126.GB21533@hoboy.vegasvil.org>
References: <20210628182533.2930715-1-jonathan.lemon@gmail.com>
 <162499200458.24074.14722653174447239621.git-patchwork-notify@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <162499200458.24074.14722653174447239621.git-patchwork-notify@kernel.org>
User-Agent: Mutt/1.10.1 (2018-07-13)
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jun 29, 2021 at 06:40:04PM +0000, patchwork-bot+netdevbpf@kernel.org wrote:
> Hello:
> 
> This patch was applied to netdev/net-next.git (refs/heads/master):

Why is this bot applying patches to net-next with issues that are
under review?

Thanks,
Richard
