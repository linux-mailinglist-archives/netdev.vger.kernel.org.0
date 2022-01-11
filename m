Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1352A48A5DC
	for <lists+netdev@lfdr.de>; Tue, 11 Jan 2022 03:50:09 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230438AbiAKCuI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Jan 2022 21:50:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36464 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229544AbiAKCuH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Jan 2022 21:50:07 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A283AC06173F
        for <netdev@vger.kernel.org>; Mon, 10 Jan 2022 18:50:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A3D73614B5
        for <netdev@vger.kernel.org>; Tue, 11 Jan 2022 02:50:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id CC9D1C36AE5;
        Tue, 11 Jan 2022 02:50:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1641869406;
        bh=ZhXOfBAmSaA0k85/ZjSsHel/coG683viemcCx493Q5U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SkGRbDzUsxaTCtGLsHp/YFIfejyCeMvtLCBGao5Io8fYdc3Y71+OE8fv5ux2sKOC+
         JaNwpQbQ5BrXGFNFljUnlKYjD8B314kAcdl15yzQ3JTooRJCl8fRekNFEprpNR7M8Q
         7/PGiderb7XPfuZiuIC6izNXVTDpFWQxWk6/Is6aHK9w/4ESJEG0+RPA3q4KYLQgDw
         Tp9FgwqLFM1XceGoROq57+46Jk8J74C8VBcZCs+EgD1AYROs1MNAmILW2c69sXXhwg
         BAAxq82rsuwmFPebBpQGnZwC/gkOk+Fw//7xKMw2UV0abmlSGPLXITZIqH3bP9IQt4
         f6Y1Gewchkp1w==
Date:   Mon, 10 Jan 2022 18:50:04 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Saeed Mahameed <saeed@kernel.org>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Saeed Mahameed <saeedm@nvidia.com>
Subject: Re: [pull request][net-next 00/17] mlx5 updates 2022-01-10
Message-ID: <20220110185004.78766652@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220111014335.178121-1-saeed@kernel.org>
References: <20220111014335.178121-1-saeed@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 10 Jan 2022 17:43:18 -0800 Saeed Mahameed wrote:
> This series is mostly refactoring and code improvements in mlx5.
> For more information please see tag log below.
> 
> Please pull and let me know if there is any problem.

We posted the net-next PR yesterday already -
https://lore.kernel.org/all/20220110025203.2545903-1-kuba@kernel.org/
