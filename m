Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 840CB44D7BC
	for <lists+netdev@lfdr.de>; Thu, 11 Nov 2021 15:00:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231739AbhKKODD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Nov 2021 09:03:03 -0500
Received: from mail.kernel.org ([198.145.29.99]:51256 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233507AbhKKODC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 11 Nov 2021 09:03:02 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1966E601FF;
        Thu, 11 Nov 2021 14:00:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1636639213;
        bh=RGIWpnQXoQk6xjwoi/RBFJb74jkEb+yGI5rUAIw8faY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=rZEeaPAE2kZbIJUxfS5iNzmi1KITHUzCUSNijYdFCHY4gj20xTnYp80gCw9nEtF+e
         XP1UHvKGDKd+dr7gLz7S4OgehIG2yj7Nu5ebz164Ij779B9gBnWP//1iSzD0mNbcHG
         EkEwDN37fM+ROV54+rLN60McRb+7bsGdbUIgAhPKfR9k3eC4j9k+YQz+eG04CIVAjV
         GP1b2o9XJqJVs+IhAIexvforIiTW2l5Kf10aDQ0/suDJ+xW+FyAzMjp1xNwB3+4SK9
         4UVP/CMeeCzurd7c+3nu7IKZf9Hti78hkn4x9CAIEAJ1y6H617t6JrkQ8lOvHBl8Qa
         GJOwYmMp+7GAQ==
Date:   Thu, 11 Nov 2021 06:00:12 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Matt Johnston <matt@codeconstruct.com.au>
Cc:     Zev Weiss <zev@bewilderbeest.net>, Wolfram Sang <wsa@kernel.org>,
        Rob Herring <robh+dt@kernel.org>,
        "David S . Miller" <davem@davemloft.net>,
        Brendan Higgins <brendanhiggins@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Joel Stanley <joel@jms.id.au>,
        Andrew Jeffery <andrew@aj.id.au>,
        Avi Fishman <avifishman70@gmail.com>,
        Tomer Maimon <tmaimon77@gmail.com>,
        Tali Perry <tali.perry1@gmail.com>,
        Patrick Venture <venture@google.com>,
        Nancy Yuen <yuenn@google.com>,
        Benjamin Fair <benjaminfair@google.com>,
        Jeremy Kerr <jk@codeconstruct.com.au>,
        linux-i2c@vger.kernel.org, netdev@vger.kernel.org
Subject: Re: [PATCH net-next v2 0/6] MCTP I2C driver
Message-ID: <20211111060005.01343703@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211111015548.2892849-1-matt@codeconstruct.com.au>
References: <20211111015548.2892849-1-matt@codeconstruct.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 11 Nov 2021 09:55:42 +0800 Matt Johnston wrote:
> Hi,
> 
> This patch series adds a netdev driver providing MCTP transport over
> I2C. 
> 
> It applies against net-next using recent MCTP changes there, though also
> has I2C core changes for review. I'll leave it to maintainers where it
> should be applied - please let me know if it needs to be submitted
> differently.
> 
> The I2C patches were previously sent as RFC though the only feedback
> there was an ack to 255 bytes for aspeed.
> 
> The dt-bindings patch went through review on the list.

net-next is still closed, you'll need to repost in a couple of days 
so we can get this back into patchwork. Thanks!
