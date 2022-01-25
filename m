Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5DCD949BAE6
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:04:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351703AbiAYSDz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:03:55 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58740 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1358481AbiAYSBg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:01:36 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 34B87C06174E
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 10:01:35 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id E5ED9B819FE
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:01:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 71FA9C340E0;
        Tue, 25 Jan 2022 18:01:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133692;
        bh=x+dtwyN0BOEpI/QVOmzfAvsO03gVDH//PXByH5S+MNI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=MDEH/gVWtTE+ZGqrkPesRYtuzzhkA40KyV7SRoBynxNpQ+F+0LvbrHb/5oa/upuo1
         XsQcqp1mzWHJGuUsi+VRDTXbpBFIb50POuF54cM2lAh5S45773AzSceFy3bUlia3sT
         NNqIaIexg+YeuxrCfUlB227MBADdHIMBm4ryzqXXlA2OwV14XecfHonqTp/8wmb+Cx
         9vKxy1w3lNRryxjQOHwOZmULAvPZk71zzEu+6ZJCt/GMYe011sxKMY2aEAuuFlEuHJ
         KqXtp+CzBZobYgRSVXc7pWcugmmH9ifBynp9pPyr2eQFqAnsbAVHfhRx4Np/Cwi7Ze
         qHhNddCR3n8IQ==
Date:   Tue, 25 Jan 2022 10:01:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tobias Waldekranz <tobias@waldekranz.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org
Subject: Re: [PATCH net 0/2] net: dsa: Avoid cross-chip syncing of VLAN
 filtering
Message-ID: <20220125100131.1e0c7beb@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124210944.3749235-1-tobias@waldekranz.com>
References: <20220124210944.3749235-1-tobias@waldekranz.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 22:09:42 +0100 Tobias Waldekranz wrote:
> This bug has been latent in the source for quite some time, I suspect
> due to the homogeneity of both typical configurations and hardware.
> 
> On singlechip systems, this would never be triggered. The only reason
> I saw it on my multichip system was because not all chips had the same
> number of ports, which means that the misdemeanor alien call turned
> into a felony array-out-of-bounds access.

Applied, thanks, 934d0f039959 ("Merge branch
'dsa-avoid-cross-chip-vlan-sync'") in net-next.
