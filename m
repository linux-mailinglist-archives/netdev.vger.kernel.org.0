Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 852742B30D0
	for <lists+netdev@lfdr.de>; Sat, 14 Nov 2020 21:57:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726362AbgKNU4I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 14 Nov 2020 15:56:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:35916 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726112AbgKNU4I (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 14 Nov 2020 15:56:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F26D922409;
        Sat, 14 Nov 2020 20:56:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605387368;
        bh=Cz8DuKKRSUpvdBtnMx7k+m0Qg9qvocj0D4LYh7Ztxz4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=V6wUR9HrJgvdvAi45+kd4HgyLiaC797bNxZLrjta+AK4LBrfxwCxlmL1eyyqMTReJ
         FfbTrERlF1UNBBMYLanrqh1wpJZ/Eu6LDgYcAjIdaUzV4pBzP3BBeyJcdY/mgUIBQ3
         /g0FpTPwXPrYrE+FkDjkRpAW7h2lZwvSNp1YvUkg=
Date:   Sat, 14 Nov 2020 12:56:07 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Armin Wolf <W_Armin@gmx.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, joe@perches.com
Subject: Re: [PATCH net-next] lib8390: Use eth_skb_pad()
Message-ID: <20201114125607.659583e7@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201112163134.11880-1-W_Armin@gmx.de>
References: <20201112163134.11880-1-W_Armin@gmx.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 17:31:34 +0100 Armin Wolf wrote:
> Use eth_skb_pad() instead of a custom padding solution
> and replace associated variables with skb->* expressions.

These are two separate changes, please split them out to two patches.
