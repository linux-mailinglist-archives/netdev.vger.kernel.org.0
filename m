Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EFA9F43A9A4
	for <lists+netdev@lfdr.de>; Tue, 26 Oct 2021 03:13:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236105AbhJZBQL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 25 Oct 2021 21:16:11 -0400
Received: from mail.kernel.org ([198.145.29.99]:46102 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236078AbhJZBQJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 25 Oct 2021 21:16:09 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id EF66360F70;
        Tue, 26 Oct 2021 01:13:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1635210826;
        bh=uSvaxn3OqBenc7AUPkVLvTX9oMoOkdGbitLstJuS6Mg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J9ws8Nu9lYWHW1cOvBYkbxTuKM7qXbfb98XNE/e4UJyaYyYf2YUOr7HmsieqO0us0
         MEa6930amdtwxhbyxNnqy73z96jfoLqDZwbO7zeU6LytkIwMmpCaaunyQivmdFbT0d
         OBfuclkY0xLyjOCk0+dIs21u1Fk+ob1sayu67Dj7ewgajLzlrkxB4JBGVsgnEmcmJU
         twSFXToZCA+QsQgM2x2JKh+xT9qho+XG19PjHugHNohfUBGshwA9mOmduF/aowUy9m
         C6OhsWxS601YsC9lekQ7YN1XiH4+pCpiOxAOgnTOJGk372dHQvzVICU/bwuNEKlT91
         PX5iRfj0cbVrg==
Date:   Mon, 25 Oct 2021 18:13:45 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Rakesh Babu <rsaladi2@marvell.com>
Cc:     <davem@davemloft.net>, <netdev@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <sgoutham@marvell.com>,
        <gakula@marvell.com>, <sbhatta@marvell.com>, <hkelam@marvell.com>,
        Harman Kalra <hkalra@marvell.com>,
        Bhaskara Budiredla <bbudiredla@marvell.com>
Subject: Re: [net-next PATCH 2/3] octeontx2-af: cn10k: debugfs for dumping
 lmtst map table
Message-ID: <20211025181345.64b1ff66@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211025191442.10084-3-rsaladi2@marvell.com>
References: <20211025191442.10084-1-rsaladi2@marvell.com>
        <20211025191442.10084-3-rsaladi2@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 Oct 2021 00:44:41 +0530 Rakesh Babu wrote:
> Implemented a new debugfs entry for dumping lmtst map
> table present on CN10K, as this might be very useful to debug any issue
> in case of shared lmtst region among multiple pcifuncs.

Please add an explanation what "lmtst map table" is to the commit
message.
