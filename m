Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D9B52B4377
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 13:18:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728975AbgKPMSH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 07:18:07 -0500
Received: from mail.kernel.org ([198.145.29.99]:43788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726754AbgKPMSH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 07:18:07 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 9BED02224B;
        Mon, 16 Nov 2020 12:18:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605529086;
        bh=XVAQ/h4xYHwCPjy+u9DmK1ykRKWqFicwPcoyLFbWRTs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MxQFXZ3doGpf2NtL7dGgAF8MGEJS2xl3sZekmwEuWF+uPg1B1nEGJJEAowYrPLAIM
         6TpY1gNqj5EOZTmGdsenu4bLd53sgVskYJbSxxKdZU6aI4msBKfODPBd0ZLw82x1zE
         KVawSU6r/YuMtD2aj9zFTdz6DdJViXIVdnAZ+Lss=
Date:   Mon, 16 Nov 2020 13:18:00 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 4/5] net: phy: marvell10g: change MACTYPE if
 underlying MAC does not support it
Message-ID: <20201116131800.25c7276d@kernel.org>
In-Reply-To: <20201116111511.5061-5-kabel@kernel.org>
References: <20201116111511.5061-1-kabel@kernel.org>
        <20201116111511.5061-5-kabel@kernel.org>
X-Mailer: Claws Mail 3.17.6 (GTK+ 2.24.32; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> 5gbase-r, 2500base-x ans SGMII depending on copper speed) if this is the

s/ans/and/

It would seem I have a consistent problem with this typo. Should I send
another version?

Marek
