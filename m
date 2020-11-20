Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 264C72BB2FD
	for <lists+netdev@lfdr.de>; Fri, 20 Nov 2020 19:37:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730385AbgKTS2b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 20 Nov 2020 13:28:31 -0500
Received: from mail.kernel.org ([198.145.29.99]:48876 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729771AbgKTS22 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 20 Nov 2020 13:28:28 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DE97A24137;
        Fri, 20 Nov 2020 18:28:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605896908;
        bh=WqCP34BthLI/V/Ugps1321WWg/uGOwp1Bkswcw5xH0w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MUqSj9NOYZZn11h/pN7O2p8V/X30PrdaxH50CVuf4Sx707ujgZ3eddduMZ1DGNc1J
         mXCKOzblr4ZVOJKifszj/vaZYKp3T6D1jlyBkcZOWWMW7yZYgLuL+eJgFU4BL4Bspr
         1xcLf871ltFEmnZxhDbTeJUGMGIyeLXluPNBBoJw=
Date:   Fri, 20 Nov 2020 10:28:27 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Martin Schiller <ms@dev.tdt.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v5] net/tun: Call netdev notifiers
Message-ID: <20201120102827.6b432dc5@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201118063919.29485-1-ms@dev.tdt.de>
References: <20201118063919.29485-1-ms@dev.tdt.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Nov 2020 07:39:19 +0100 Martin Schiller wrote:
> Call netdev notifiers before and after changing the device type.
> 
> Signed-off-by: Martin Schiller <ms@dev.tdt.de>

This is a fix, right? Can you give an example of something that goes
wrong without this patch?
