Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 515451A5FED
	for <lists+netdev@lfdr.de>; Sun, 12 Apr 2020 20:47:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727775AbgDLSr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Apr 2020 14:47:27 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46830 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727329AbgDLSr0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 12 Apr 2020 14:47:26 -0400
Received: from mail.kernel.org (mail.kernel.org [198.145.29.99])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id BE68BC0A3BF0;
        Sun, 12 Apr 2020 11:47:26 -0700 (PDT)
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3BAB3206DA;
        Sun, 12 Apr 2020 18:47:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1586717246;
        bh=SGq7BfR5emag/Z1qRgdvgdCtq0c9gy1l80ex14nkw2M=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=XSbSx4A4W41+0BEIb4jbQQBUBwMp6LbcZ3G/ZAZSzDvK+Yd5dYHFOQqGVlGBOsr9n
         dyse9+bLvK+1YX27M/9dTQYa/ly7vNB6Pd2+kDpHaWHxCL8Ikz0IINeCcjodzYb0UD
         58FfQsJUBDbd+BE0VSexGbnlxtJG78V6NHzGVAqg=
Date:   Sun, 12 Apr 2020 11:47:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     elder@kernel.org, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] soc: qcom: ipa: Add a missing '\n' in a log message
Message-ID: <20200412114725.2dc5844b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200411073004.8404-1-christophe.jaillet@wanadoo.fr>
References: <20200411073004.8404-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 11 Apr 2020 09:30:04 +0200 Christophe JAILLET wrote:
> Message logged by 'dev_xxx()' or 'pr_xxx()' should end with a '\n'.
> 
> Fixes: a646d6ec9098 ("soc: qcom: ipa: modem and microcontroller")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Applied, thanks!
