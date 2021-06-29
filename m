Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 881153B70FD
	for <lists+netdev@lfdr.de>; Tue, 29 Jun 2021 12:52:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233242AbhF2KzF (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 29 Jun 2021 06:55:05 -0400
Received: from mail.kernel.org ([198.145.29.99]:54134 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231956AbhF2KzE (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 29 Jun 2021 06:55:04 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id CD96161D95;
        Tue, 29 Jun 2021 10:52:36 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1624963957;
        bh=iJHh3HJWzS4p43jokYeIIrJrYBdAAChCkfrJNtvQTq4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=JaKvGjHVQl9mGA2quUw0LysIQt4JTQJ8FScM84OK5+1TLeVyE1FpbgkBB5UBLbjKc
         r34lHJeXqGNja4oetO2FDP6D+JrbwHljIUrG4TvxXL0PG23V2Il2o9ID/m4veego6F
         AIj2mkcXhrqtogyGatb+DNKH5yrqN7ce+nBYPIJWo3ewMChe5cQ0Ad8wwjiHKetHUH
         HvVFzKaUQH2y+ficI1GY+gCOURmSEql+RJiKe2q1A7xIGQnQQkNO5OARdTx/FKOA6i
         +S/XNjjbnFNBNypTrCpBz4PLcACSgPUi4yVRNTHMZPy9pZ7dJ68unrdP474/cQyiFh
         5yyAyIf6Zpg2g==
Date:   Tue, 29 Jun 2021 12:52:34 +0200
From:   Marek =?UTF-8?B?QmVow7pu?= <kabel@kernel.org>
To:     Kurt Cancemi <kurt@x64architecture.com>
Cc:     netdev <netdev@vger.kernel.org>
Subject: Re: [PATCH 1/1] net: phy: marvell: Fixed handing of delays with
 plain RGMII interface
Message-ID: <20210629125234.7fcfc6bb@thinkpad>
In-Reply-To: <CADujJWXFFBUy9H3-w32uCYs_cJM5dBrWFzRg3x-Dq9+kki436g@mail.gmail.com>
References: <20210628192826.1855132-1-kurt@x64architecture.com>
        <20210628192826.1855132-2-kurt@x64architecture.com>
        <20210629004958.40f3b98c@thinkpad>
        <CADujJWWoWRyW3S+f3F_Zhq9H90QZ1W4eu=5dyad3DeMLHFp2TA@mail.gmail.com>
        <20210629022335.1d27efc9@thinkpad>
        <CADujJWXFFBUy9H3-w32uCYs_cJM5dBrWFzRg3x-Dq9+kki436g@mail.gmail.com>
X-Mailer: Claws Mail 3.17.8 (GTK+ 2.24.33; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 28 Jun 2021 21:12:41 -0400
Kurt Cancemi <kurt@x64architecture.com> wrote:

> I am using drivers/net/ethernet/freescale/dpaa. This is a T2080 soc.
> 
> The following is where I added a dev_info statement for "phy_if", it
> correctly returned -> PHY_INTERFACE_MODE_RGMII_ID.
> https://github.com/torvalds/linux/blob/master/drivers/net/ethernet/freescale/fman/mac.c#L774

It seem that dpaa / fman drivers do the same thing for both
"rgmii" and "rgmii-id". There should be code that enables the delays
for the "rgmii-id" variant...

Marek
