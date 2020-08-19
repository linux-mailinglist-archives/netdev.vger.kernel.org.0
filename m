Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D56B924A37E
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 17:46:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728846AbgHSPqT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 11:46:19 -0400
Received: from mail.kernel.org ([198.145.29.99]:50550 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728719AbgHSPqT (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 11:46:19 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 721E420639;
        Wed, 19 Aug 2020 15:46:18 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1597851979;
        bh=CJwbKVNUmJOXhRgFJJgoOckO0OJ6/1b+dHAJjBQa9bo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=acOCmIKLcDz1iWQgjWvxFIdyhU490plsIzd7Egzc/QV1YIC9qoozu9wSeURLl+yM0
         JfmSsjYskgFatsHZQ/uZiXNt1pTkVOjHmZTjszDn2XZtnZfCxnaNKOmk3KKAaYUsZJ
         +mQ2BxELsPdBS2QXBeVzbuk83c3/oaoGmG0HTqvU=
Date:   Wed, 19 Aug 2020 08:46:17 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shay Agroskin <shayagr@amazon.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>, <dwmw@amazon.com>,
        <zorik@amazon.com>, <matua@amazon.com>, <saeedb@amazon.com>,
        <msw@amazon.com>, <aliguori@amazon.com>, <nafea@amazon.com>,
        <gtzalik@amazon.com>, <netanel@amazon.com>, <alisaidi@amazon.com>,
        <benh@amazon.com>, <akiyano@amazon.com>, <sameehj@amazon.com>,
        <ndagan@amazon.com>
Subject: Re: [PATCH V2 net 1/3] net: ena: Prevent reset after device
 destruction
Message-ID: <20200819084617.67cc69a1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200819090443.24917-2-shayagr@amazon.com>
References: <20200819090443.24917-1-shayagr@amazon.com>
        <20200819090443.24917-2-shayagr@amazon.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 19 Aug 2020 12:04:41 +0300 Shay Agroskin wrote:
> Fixes: 84a629e ("[New feature] ena_netdev: Add hibernation support")

Fixes tag: Fixes: 84a629e ("[New feature] ena_netdev: Add hibernation support")
Has these problem(s):
	- Target SHA1 does not exist


Also hash needs to be 12 characters.
