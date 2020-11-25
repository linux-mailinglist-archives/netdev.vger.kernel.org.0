Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 39A982C35C4
	for <lists+netdev@lfdr.de>; Wed, 25 Nov 2020 01:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727849AbgKYAu6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 24 Nov 2020 19:50:58 -0500
Received: from mail.kernel.org ([198.145.29.99]:41258 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727794AbgKYAu6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 24 Nov 2020 19:50:58 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E299320872;
        Wed, 25 Nov 2020 00:50:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1606265458;
        bh=yg12gmuir6M2ZpCWoMdS1rJ/4UMYDbpi5MyEOOXoDog=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=qDk2M2z8c8QSIPlKDi5pekHHOZTeMRoCTHJ2KGmM1ijhttGnTrlyJAwxs6fhEPRs7
         l1U7wgifboSY09yjArYFYlVp0kETYwbdhPhrVPxO99r+BIm3kkpAnNCM49mGRRuoOn
         YojqEWyCq/GSInAYe4ZrL1JX52YZm7wtZj9y2qx0=
Date:   Tue, 24 Nov 2020 16:50:57 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Wunderlich <sw@simonwunderlich.de>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        b.a.t.m.a.n@lists.open-mesh.org
Subject: Re: [PATCH 0/1] pull request for net: batman-adv 2020-11-24
Message-ID: <20201124165057.0fa59de4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20201124134417.17269-1-sw@simonwunderlich.de>
References: <20201124134417.17269-1-sw@simonwunderlich.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 24 Nov 2020 14:44:16 +0100 Simon Wunderlich wrote:
> Hi David, hi Jakub,
> 
> here is a bugfix for batman-adv which we would like to have integrated into net.

Pulled, thanks!
