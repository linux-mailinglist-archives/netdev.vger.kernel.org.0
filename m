Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0F062405F14
	for <lists+netdev@lfdr.de>; Thu,  9 Sep 2021 23:51:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231217AbhIIVwc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 9 Sep 2021 17:52:32 -0400
Received: from mail.kernel.org ([198.145.29.99]:57456 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229872AbhIIVwZ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 9 Sep 2021 17:52:25 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id F080761186;
        Thu,  9 Sep 2021 21:51:14 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1631224275;
        bh=LuTkFJCkx2jIEKd92PXCf5RctiOhEk0nHFUmepq/UXE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ubsceNimpSiz5HM0gpmI/u9LWZ4E3EB6eb+hYIQn66lc8zEPo848oU/rhH9Nw1nuS
         WjLuZ0+C+ip+Btuf/GP/KwKX55G6Emow6Ul7chyjpAhIgMnhUqvHtO9eHkRLg5DbPR
         r9qSb1xrAgv0QlmxF5xc9Ef0bwdl007BY7pHsgoij97qKuvs7PTAnSaK1w94sHqtz9
         OJUwjIfTnUn0gINUVQQLfSrYoqdd1CxkH+uPbfCwQZYE571svRbyqPW7nyEMEk5yEO
         7Vz6atA06aJhbLzvG2VZDPSmiTLC3QyAEpIpQiX+9h/z8Rv4OWcvdML0FOi2NLbuzw
         vgbTJPBIubT7Q==
Date:   Thu, 9 Sep 2021 14:51:13 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shai Malin <smalin@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>,
        <aelior@marvell.com>, <malin1024@gmail.com>
Subject: Re: [PATCH net-next] qed: Handle management FW error
Message-ID: <20210909145113.78d48c3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210909173222.10627-1-smalin@marvell.com>
References: <20210909173222.10627-1-smalin@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Sep 2021 20:32:22 +0300 Shai Malin wrote:
> Handle MFW (management FW) error response in order to avoid a crash
> during recovery flows.
> 
> Signed-off-by: Ariel Elior <aelior@marvell.com>
> Signed-off-by: Shai Malin <smalin@marvell.com>

Since you say crash I'm assuming this is a fix.

Please repost with a Fixes tag and [PATCH net] in the subject.
