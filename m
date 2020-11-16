Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 263A42B4627
	for <lists+netdev@lfdr.de>; Mon, 16 Nov 2020 15:46:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730349AbgKPOqA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Nov 2020 09:46:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:47978 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730344AbgKPOp7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 16 Nov 2020 09:45:59 -0500
Received: from localhost (otava-0257.koleje.cuni.cz [78.128.181.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2A18420657;
        Mon, 16 Nov 2020 14:45:58 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605537959;
        bh=/QSnbwlFNlwXuiMp9x6Nhzyt69x4Wc/Ic4Kt08hd3Tw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ooiMfXkvfoETcwoQ+2owXyX+7vh/DQkpQWjmH7hgPGtd/ANyMIPlv1rvW2Yusy7z4
         EPaBQOJ31dm9twCH5AW8V6ZVkZetJBV8Y9ARb/7OfLPzUJAl54orU96G6A/vXBWjmf
         Xu3SzMkZT7WMPg5sBE5T8BYmDyrDOB0atLwd/0yM=
Date:   Mon, 16 Nov 2020 15:45:52 +0100
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Russell King <rmk+kernel@armlinux.org.uk>, netdev@vger.kernel.org,
        davem@davemloft.net, Jakub Kicinski <kuba@kernel.org>
Cc:     Andrew Lunn <andrew@lunn.ch>
Subject: Re: [PATCH net-next v3 4/5] net: phy: marvell10g: change MACTYPE if
 underlying MAC does not support it
Message-ID: <20201116154552.5a1e4b02@kernel.org>
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

Hi Russell,

previously you replied on this patch:

> This'll do as a stop-gap until we have a better way to determine which
> MACTYPE mode we should be using.

Can we consider this as Acked-by ?
