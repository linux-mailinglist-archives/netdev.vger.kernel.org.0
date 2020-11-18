Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA4C22B8365
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 18:53:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728133AbgKRRxA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 12:53:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:33452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726310AbgKRRxA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 12:53:00 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 6B0E224903;
        Wed, 18 Nov 2020 17:52:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605721979;
        bh=EDqoGlQelT4gtKuEWrwQXFVJ1Vwq7G3OajEem2L4Ee4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=0jVdy6qu931VA+n8siOthUNSJyOlHY3mMoAibxL5hjEF9DxxWUhgayu4iJy950a8i
         gpTTgYrelCu3VJEsdQi6g/GjED7DSas3wyWqIL5Xq1HbDPhEO/HoIi6gcI9J4T2i/+
         LX7eWakaNJvU3Ulwdnojwpg2gyjJ8f75hLDVmzOs=
Date:   Wed, 18 Nov 2020 09:52:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Claudiu Manoil <claudiu.manoil@nxp.com>
Cc:     netdev@vger.kernel.org, "David S . Miller" <davem@davemloft.net>
Subject: Re: [PATCH net-next 0/2] enetc: Clean endianness warnings up
Message-ID: <20201118095258.4f129839@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201117182004.27389-1-claudiu.manoil@nxp.com>
References: <20201117182004.27389-1-claudiu.manoil@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 17 Nov 2020 20:20:02 +0200 Claudiu Manoil wrote:
> Cleanup patches to address the outstanding endianness issues
> in the driver reported by sparse.

Build bot says this doesn't apply to net-next, could you double check?
