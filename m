Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4FAE147F165
	for <lists+netdev@lfdr.de>; Sat, 25 Dec 2021 00:01:23 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231202AbhLXXBV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Dec 2021 18:01:21 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:41004 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230441AbhLXXBU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Dec 2021 18:01:20 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 47CBC620DB;
        Fri, 24 Dec 2021 23:01:20 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D457C36AE8;
        Fri, 24 Dec 2021 23:01:19 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1640386879;
        bh=nuJKknkW46ZYkyeyo4TJBnHqTQW4tQQyj2wh1vwIHoA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=kTdes8FgvpVBnRwtbpNUrFF/jWyw1vvNk+I9wDiwRY3r3KYgKGR+gMNdREAWoaEUL
         GBjb/9s3jIGNggbBCWrTuUQE3SmExLacqliF3EeTeg62nRYCNzAmLCoDfDl6vyw9QN
         4kiqBURqfiysFFuEqRox0HMS4/at+Rrd+OXafeYcIVBrYM6j7Zlfsd/Sdm7kaOkCzh
         JYlDIufgSxV0xT68JxoxwtPqK7v4aR74UeE2Ow/XnfZhdS/wSDhd+fkYVoi+JLg3WK
         TWxacrfEx153c9DvkeHc+DiYeQtkJladIhF+6LTtKe65N1FZpXzQfqEq80crKDI/a1
         mPUiSUTn7VpHQ==
Date:   Fri, 24 Dec 2021 15:01:18 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiasheng Jiang <jiasheng@iscas.ac.cn>
Cc:     davem@davemloft.net, u.kleine-koenig@pengutronix.de, marex@denx.de,
        trix@redhat.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: ks8851: Fix wrong check for irq
Message-ID: <20211224150118.17e24b88@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20211224051753.1565175-1-jiasheng@iscas.ac.cn>
References: <20211224051753.1565175-1-jiasheng@iscas.ac.cn>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 24 Dec 2021 13:17:53 +0800 Jiasheng Jiang wrote:
> Because netdev->irq is unsigned

It is not.
