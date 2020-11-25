Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A1C882C4925
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 21:35:24 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730171AbgKYUfW (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Nov 2020 15:35:22 -0500
Received: from mail.kernel.org ([198.145.29.99]:34024 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730151AbgKYUfW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Nov 2020 15:35:22 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 707ED207BB;
        Wed, 25 Nov 2020 20:35:21 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606336521;
        bh=l/UPwKzx1xRYzzEwUTsD+zYJrusCdT3vScDYwN6DYM0=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=1ZOrQnhzZ1N8GakREmT4kY1hAereIbZfRmjHskkIddH6jFruEuHdoNFX9CwPb9pbf
         VG9Ltt27DKvjGgt1DiGDLaM9lIWmgn0+3tPRgr0WwDdjpu0aBy221fyG6aA0AcgBa4
         qtt+hD+mT4UxXUe9WEwT/fP9KrkXB+6J3uwbEE2c=
Date:   Wed, 25 Nov 2020 12:35:20 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vlad Buslov <vlad@buslov.dev>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jhs@mojatatu.com,
        xiyou.wangcong@gmail.com, jiri@resnulli.us
Subject: Re: [PATCH net-next v2] net: sched: alias action flags with
 TCA_ACT_ prefix
Message-ID: <20201125123520.051385c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124164054.893168-1-vlad@buslov.dev>
References: <20201124164054.893168-1-vlad@buslov.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 18:40:54 +0200 Vlad Buslov wrote:
> Currently both filter and action flags use same "TCA_" prefix which makes
> them hard to distinguish to code and confusing for users. Create aliases
> for existing action flags constants with "TCA_ACT_" prefix.
> 
> Signed-off-by: Vlad Buslov <vlad@buslov.dev>

Applied, thank you!
