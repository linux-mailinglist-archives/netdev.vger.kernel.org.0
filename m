Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6F0253F619F
	for <lists+netdev@lfdr.de>; Tue, 24 Aug 2021 17:29:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238247AbhHXPaO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Aug 2021 11:30:14 -0400
Received: from mail.kernel.org ([198.145.29.99]:41286 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235683AbhHXPaN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Aug 2021 11:30:13 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 7E66561265;
        Tue, 24 Aug 2021 15:29:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629818968;
        bh=6+biN29D5WoAzfO9BDov2cPTbiGldallkUXFPOK88js=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=ZbXQuqv9UCGWSbmnuGM2/SP4M86QwDXHD/0D0Ely67U4o2yVP56OBp6jRRMlh1oSF
         5veYNBtnUJ3pXEHicLmMF6V/a9iOwysLhlt/vsqQUdHtlgwaAorueBnqOszTuJSabv
         TsEt6GGwl8QO6aCvLpqHWBQUw6JqRhg75NNX81YzwXOx0HUEZje9xsvcaExeSvMI1Q
         omsbDbz5VS00VWVaLSIgWWbzeK3lBiYYH22ewdgCCICvGcvsvui8HzCvkjo9B8XdgL
         WVVI1RDoxyNZJwEMsnopBguQZG1QXEfa/8eYw9wpje9g2LWHi/mRztpi9Xb943SZLm
         ISBlKzlij56ew==
Date:   Tue, 24 Aug 2021 11:29:27 -0400
From:   Sasha Levin <sashal@kernel.org>
To:     DENG Qingfang <dqfext@gmail.com>
Cc:     stable@vger.kernel.org, Sean Wang <sean.wang@mediatek.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        "open list:MEDIATEK SWITCH DRIVER" <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-arm-kernel@lists.infradead.org>,
        "moderated list:ARM/Mediatek SoC support" 
        <linux-mediatek@lists.infradead.org>
Subject: Re: [PATCH 4.19.y] net: dsa: mt7530: disable learning on standalone
 ports
Message-ID: <YSUQV3jhfbhbf5Ct@sashalap>
References: <20210824055509.1316124-1-dqfext@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <20210824055509.1316124-1-dqfext@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 24, 2021 at 01:55:08PM +0800, DENG Qingfang wrote:
>This is a partial backport of commit 5a30833b9a16f8d1aa15de06636f9317ca51f9df
>("net: dsa: mt7530: support MDB and bridge flag operations") upstream.
>
>Make sure that the standalone ports start up with learning disabled.

What's the reasoning behind:

1. Backporting this patch?
2. A partial backport of this patch?

-- 
Thanks,
Sasha
