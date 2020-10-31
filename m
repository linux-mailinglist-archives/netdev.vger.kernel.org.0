Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EBBF52A1B44
	for <lists+netdev@lfdr.de>; Sun,  1 Nov 2020 00:36:37 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726159AbgJaXgg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Oct 2020 19:36:36 -0400
Received: from mail.kernel.org ([198.145.29.99]:58784 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725873AbgJaXgf (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Oct 2020 19:36:35 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3013D2087E;
        Sat, 31 Oct 2020 23:36:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1604187395;
        bh=YEARdnKOZH0aDSOEZP6ZnSefnbwtqJqGkLQjHS4+dvw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W7El9f/h/XdyTZIYXpjWqUPhtRKISouRVzXb1eld9eI06f3rcDzvZ/IIUjSH1gI22
         xRjgVACqoCIf+gTcGFGz5JIsuRA0o0KwMpspVk84kbAtJAUTrr0cptQM+ERmSkSH7/
         mugtNkKCQ7miadhTwC6bG56HbcmjwkiJeJqaLi3g=
Date:   Sat, 31 Oct 2020 16:36:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     David Miller <davem@davemloft.net>,
        Realtek linux nic maintainers <nic_swsd@realtek.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: [PATCH net-next] r8169: use pm_runtime_put_sync in rtl_open
 error path
Message-ID: <20201031163634.445fa21b@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <aa093b1e-f295-5700-1cb7-954b54dd8f17@gmail.com>
References: <aa093b1e-f295-5700-1cb7-954b54dd8f17@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 29 Oct 2020 19:02:53 +0100 Heiner Kallweit wrote:
> We can safely runtime-suspend the chip if rtl_open() fails. Therefore
> switch the error path to use pm_runtime_put_sync() as well.
> 
> Signed-off-by: Heiner Kallweit <hkallweit1@gmail.com>

Applied, thanks!
