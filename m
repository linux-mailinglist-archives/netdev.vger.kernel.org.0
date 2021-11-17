Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 201E6453F19
	for <lists+netdev@lfdr.de>; Wed, 17 Nov 2021 04:44:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232723AbhKQDrM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Nov 2021 22:47:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:48402 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229614AbhKQDrM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Nov 2021 22:47:12 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id D6F09619EA;
        Wed, 17 Nov 2021 03:44:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637120654;
        bh=akLGag+9G8+X0Kz573PAyY2LHf6F1DS4rXYI7heQpX0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=gV+gCWVVKrTTlihm3bKQV+kkaV8koY3WDsRrUGDM2+mnvZlw72BQI8ygfJs2jW2vT
         JowRrX6oMPkqT15XqC02/BmdlecmSvMJ8TOiIzUYMMtvhoR17I0GuH0ueCQiwlzxwa
         jliipKN4ixKS3K+olP0/nZiGja96MqoeGdxZThj4/srD608FgYxTCyUF4Te+sNC10I
         ydmX22nosmWr2/+pCLn0BubOOIWitB4N9OTszm2PHgf+pxerV/lZtEJtnz9L6uZPxi
         /4Bl8LuXoLYj8wju3F+UjTVzGy6etcFNn9RlPUb4UzWzjuNE5TWMPLc+Afx4JGL0GQ
         zawwrjRrhjDNQ==
Date:   Tue, 16 Nov 2021 19:44:13 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     "Riccardo Paolo Bestetti" <pbl@bestov.io>
Cc:     "David S. Miller" <davem@davemloft.net>,
        "Hideaki YOSHIFUJI" <yoshfuji@linux-ipv6.org>,
        "David Ahern" <dsahern@kernel.org>,
        "Shuah Khan" <shuah@kernel.org>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-kselftest@vger.kernel.org>
Subject: Re: [PATCH v2] ipv4/raw: support binding to nonlocal addresses
Message-ID: <20211116194413.32c7f584@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <CFPVQWNG02LG.3DHWUZ0JCAMVS@enhorning>
References: <20210321002045.23700-1-pbl@bestov.io>
        <CFPVQWNG02LG.3DHWUZ0JCAMVS@enhorning>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 15 Nov 2021 00:09:44 +0100 Riccardo Paolo Bestetti wrote:
> Add support to inet v4 raw sockets for binding to nonlocal addresses
> through the IP_FREEBIND and IP_TRANSPARENT socket options, as well as
> the ipv4.ip_nonlocal_bind kernel parameter.

FWIW this patch did not make it to patchwork or any of the mailing
lists. Not immediately obvious why. Can you try re-sending?
