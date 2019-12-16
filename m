Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 75CD9121AD0
	for <lists+netdev@lfdr.de>; Mon, 16 Dec 2019 21:21:26 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727706AbfLPUVS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Dec 2019 15:21:18 -0500
Received: from mail-lj1-f195.google.com ([209.85.208.195]:46106 "EHLO
        mail-lj1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726616AbfLPUVS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Dec 2019 15:21:18 -0500
Received: by mail-lj1-f195.google.com with SMTP id z17so8190303ljk.13
        for <netdev@vger.kernel.org>; Mon, 16 Dec 2019 12:21:17 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=netronome-com.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :organization:mime-version:content-transfer-encoding;
        bh=Coj/0TiMCvz30A/R8txuCVhc5n1pm41RNaOjJUWUaS0=;
        b=fPZkCIk0sJHFLthoSa2l0yCn2V8lLSwii17NEqkwT98ikRbJYd1twQVIIGQw7ltrH6
         J6doHz2eDuvnDERtdF9jYiFBsZs/SpGZwOcVAugBoU9E3jT41G/1ZigNahbIa1J8rg5K
         kSbJqo+ITbb2zxFaZluYltZ1isGPfKYAAXcte6U5wo82/wR2RXiPcnHGvaAKqPXV0Dnk
         NKG2rqg84KUceg2vu6AL70Z+Ieyhw9hnEIQ5ol8TGm1ChMs4pc0/vpjrVAQGMVZuPzes
         sXe0f9brx+3rHfDB2mBiVtY6XH6BhzvHiPtE68xp98dm6LygxTRY0c3DDKJPoAoGnVLW
         xjPw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:organization:mime-version:content-transfer-encoding;
        bh=Coj/0TiMCvz30A/R8txuCVhc5n1pm41RNaOjJUWUaS0=;
        b=aPmoLTCbR6GePfMsIVcz0x7TlsikMymCWvvGE1K52rT1E5dGRERIzlJLQr+/Tu3Dof
         YTIEDTScSyjyv1RN2VgxvnLbm3ZUXuapNKs3H0c93y2itsVAx9QMWKoPuUwLVm/xDQE4
         lgjLAV0NNNLajCbtNq2zohvMvS15fL9Fy0IKPW14Hc90FRI+pZuXAYGPWIIA4bcMzfeE
         1w8QvkGHyH5nP9Xad6VDkra67v4zyaiq2MErh7NhiCxkiSSqSdbcaDacClsC1ITjVzY+
         sulJfvSNoJ+mO+o7hHz4vqVCkJUODklk059ya9lblUL7PGdTe7+qyVDO1jfiad/teIPR
         /uqg==
X-Gm-Message-State: APjAAAWcs97eSFzt8mWBXECDwP4O9I/m4l8NRQpo6hTIyoAefh5+8lW7
        ZKBxwRUH9dRmZVJoHqtg4amSqQ==
X-Google-Smtp-Source: APXvYqwvffi+Q+fIIrfBgnRjuyf8h/Vz0+Y6j1dBgFciwrLYs7AYC/zjAUfMezy6GLiXnMwUcjT2XQ==
X-Received: by 2002:a05:651c:c4:: with SMTP id 4mr644180ljr.131.1576527676330;
        Mon, 16 Dec 2019 12:21:16 -0800 (PST)
Received: from cakuba.netronome.com ([66.60.152.14])
        by smtp.gmail.com with ESMTPSA id r26sm9508344lfm.82.2019.12.16.12.21.13
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 16 Dec 2019 12:21:16 -0800 (PST)
Date:   Mon, 16 Dec 2019 12:21:06 -0800
From:   Jakub Kicinski <jakub.kicinski@netronome.com>
To:     Jose Abreu <Jose.Abreu@synopsys.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        Joao Pinto <Joao.Pinto@synopsys.com>,
        Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        "David S. Miller" <davem@davemloft.net>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        "linux-stm32@st-md-mailman.stormreply.com" 
        <linux-stm32@st-md-mailman.stormreply.com>,
        "linux-arm-kernel@lists.infradead.org" 
        <linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH net 0/8] net: stmmac: Fixes for -net
Message-ID: <20191216122106.582b6cc9@cakuba.netronome.com>
In-Reply-To: <BN8PR12MB326639325F465266DEACAA64D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
References: <cover.1576005975.git.Jose.Abreu@synopsys.com>
        <20191213162216.2dc8a108@cakuba.netronome.com>
        <BN8PR12MB326639325F465266DEACAA64D3510@BN8PR12MB3266.namprd12.prod.outlook.com>
Organization: Netronome Systems, Ltd.
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Dec 2019 09:26:22 +0000, Jose Abreu wrote:
> From: Jakub Kicinski <jakub.kicinski@netronome.com>
> Date: Dec/14/2019, 00:22:16 (UTC+00:00)
> 
> > On Tue, 10 Dec 2019 20:33:52 +0100, Jose Abreu wrote:  
> > > Fixes for stmmac.
> > > 
> > > 1) Fixes the filtering selftests (again) for cases when the number of multicast
> > > filters are not enough.
> > > 
> > > 2) Fixes SPH feature for MTU > default.
> > > 
> > > 3) Fixes the behavior of accepting invalid MTU values.
> > > 
> > > 4) Fixes FCS stripping for multi-descriptor packets.
> > > 
> > > 5) Fixes the change of RX buffer size in XGMAC.
> > > 
> > > 6) Fixes RX buffer size alignment.
> > > 
> > > 7) Fixes the 16KB buffer alignment.
> > > 
> > > 8) Fixes the enabling of 16KB buffer size feature.  
> > 
> > Hi Jose!
> > 
> > Patches directed at net should have a Fixes tag identifying the commit
> > which introduced the problem. The commit messages should also describe
> > user-visible outcomes of the bugs. Without those two its hard to judge
> > which patches are important for stable backports.
> > 
> > Could you please repost with appropriate Fixes tags?  
> 
> I agree with you Jakub but although these are bugs they are either for 
> recently introduced features (such as SPH and selftests), or for 
> features that are not commonly used. I can dig into the GIT history and 
> provide fixes tag for them all or I can always provide a backport fix if 
> any user requires so. Can you please comment on which one you prefer ?

I think Fixes tags helps either way, if the fix is not important enough
upstream maintainers should be able to figure that out based on the
commit message (or you can give advice on backporting below the ---
line, like "Probably not worth backporting").

For the recent features it's quite useful to see the fixes tag so both
humans and bots can immediately see its a recent feature and we don't
have to worry about backports.
