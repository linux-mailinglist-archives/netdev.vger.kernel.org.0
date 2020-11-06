Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 98D852A8C35
	for <lists+netdev@lfdr.de>; Fri,  6 Nov 2020 02:42:54 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1733117AbgKFBmn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 5 Nov 2020 20:42:43 -0500
Received: from mail.kernel.org ([198.145.29.99]:59046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1733080AbgKFBmm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 5 Nov 2020 20:42:42 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 276D6206FB;
        Fri,  6 Nov 2020 01:42:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604626961;
        bh=CMorIKRDiwIPukaiFQnlTZyLkb1PPC/nuytIVJwocOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J0EHrmarrLM/f9kAZKOxRhO94iXvMilPG08DNhCv3zg0eXCiUT+ilmZcZqubpfnSD
         Li8s+zosiPR8R5VzOHd1WMiMz/zj24H8sPJZruIFQ0KYUDBl4tWLlxprZSHiLgCFTY
         tlqxbYm+ht9A4R8g6Z79kJ+n72IWfY681HMGAaMs=
Date:   Thu, 5 Nov 2020 17:42:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com, davem@davemloft.net,
        f.fainelli@gmail.com, gregkh@linuxfoundation.org,
        linux-kernel@vger.kernel.org, marek.behun@nic.cz,
        netdev@vger.kernel.org, vivien.didelot@gmail.com
Subject: Re: [PATCH v8 1/4] dt-bindings: net: Add 5GBASER phy interface mode
Message-ID: <20201105174240.0bf89caf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <57a63f8896068d9628b334e32ccbb49cd63272fe.1604388359.git.pavana.sharma@digi.com>
References: <cover.1604388359.git.pavana.sharma@digi.com>
        <57a63f8896068d9628b334e32ccbb49cd63272fe.1604388359.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Nov 2020 18:49:02 +1000 Pavana Sharma wrote:
> Add 5gbase-r PHY interface mode.
> 
> Signed-off-by: Pavana Sharma <pavana.sharma@digi.com>

Please always CC device tree maintainers and list on patches which
touch bindings. Even if there is no need for review Rob has a bot
which will catch any formatting errors.
