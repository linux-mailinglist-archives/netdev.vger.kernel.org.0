Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 40EE637BC3E
	for <lists+netdev@lfdr.de>; Wed, 12 May 2021 14:07:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230328AbhELMIS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 12 May 2021 08:08:18 -0400
Received: from mail.kernel.org ([198.145.29.99]:45504 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230300AbhELMIQ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 12 May 2021 08:08:16 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 086F3613E9;
        Wed, 12 May 2021 12:07:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1620821228;
        bh=Z3u92mwEiPpBuhI2rclnyGnQAxi2F9twt2mXrH5RtNc=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=DHStd+X7jPF02VQfePqpH3U5UMHi15M3klOIlLq/XuvmwLz5w4laYgyhAJyLEY/8j
         KR5s+Iq4AMH6qHLiANqvBoDVV0R9IkPnSnSiDHnvR6fuLefOWoiJEZSRcMRtlK3jju
         dMcGQhIlgQro2NAFtIMoGjbuFgbI//qbjvbBrMXU=
Date:   Wed, 12 May 2021 14:07:06 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Jonathon Reinhart <jonathon.reinhart@gmail.com>
Cc:     stable@vger.kernel.org, Linux Netdev List <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: Backport: "net: Only allow init netns to set default tcp cong to
 a restricted algo"
Message-ID: <YJvE6pNot+Fy/RVS@kroah.com>
References: <CAPFHKzezkWSjZtkU-0h2D8q=uW5QEBvZcbcw91dwta24=VU+tA@mail.gmail.com>
 <CAPFHKzcxgxG_VxaS12r61Zj25TLnBQ=M2AcqRdWV7MZMZAirbw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAPFHKzcxgxG_VxaS12r61Zj25TLnBQ=M2AcqRdWV7MZMZAirbw@mail.gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 10, 2021 at 10:28:36PM -0400, Jonathon Reinhart wrote:
> Hello,
> 
> Please apply upstream git commit 8d432592f30f ("net: Only allow init
> netns to set default tcp cong to a restricted algo") to the stable
> trees.

Now queued up, thanks.

greg k-h
