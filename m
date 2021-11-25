Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 93FD745DD19
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 16:15:20 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1355687AbhKYPS3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Nov 2021 10:18:29 -0500
Received: from mail.kernel.org ([198.145.29.99]:53460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1355994AbhKYPQ3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Nov 2021 10:16:29 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 88BA760462;
        Thu, 25 Nov 2021 15:13:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637853197;
        bh=Ouc9oBwXTUyyhfC4NywCB7OvF8HAkgyNnU+xh5PIjeA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jh98czJ2C3/lP94m4l5RqVaGcdPAv4YnTJ0o+wauUJM/e4nRIynlaYsRXL19tv40z
         81m19lTm3yfBUEVD0Vsc89EVswtXtZP6ilCSZWKKaItfHWtp9dtsYBF25+AzKtWpRo
         PXG9yoKc/jTjm/gI7UAAcksjoug2xe1ZI32d6gYb6EqgiyLLnzqBqzP2y1//lpMOlP
         gTwgyuupSmjralidLWHnQxZU1X7SUWmn8sQbmLDD582BBjZGc4x4Gx79c4XylgxVzI
         wr/IQvdsvJQpErqiTzOD/3FNgiZj1JGEKFlGvnlGUgP8pnhKIksaHRTd4Aso0l/1WI
         l7YsOEWu5Sb6Q==
Date:   Thu, 25 Nov 2021 07:13:16 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stefan Assmann <sassmann@redhat.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211125071316.69c3319a@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211125065049.hwubag5eherksrle@x230>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-7-anthony.l.nguyen@intel.com>
        <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20211125065049.hwubag5eherksrle@x230>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 25 Nov 2021 07:50:49 +0100 Stefan Assmann wrote:
> On 2021-11-24 15:48, Jakub Kicinski wrote:
> > On Wed, 24 Nov 2021 09:16:46 -0800 Tony Nguyen wrote:  
> > > Add kernel trace that device was removed.
> > > Currently there is no such information.
> > > I.e. Host admin removes a PCI device from a VM,
> > > than on VM shall be info about the event.
> > > 
> > > This patch adds info log to iavf_remove function.  
> > 
> > Why is this an important thing to print to logs about?
> > If it is why is PCI core not doing the printing?
> 
> From personal experience I'd say this piece of information has value,
> especially when debugging it can be interesting to know exactly when
> the driver was removed.

But there isn't anything specific to iavf here, right? If it really 
is important then core should be doing the printing for all drivers.

Actually, I can't come up with any uses for this print on the spot.
What debugging scenarios do you have in mind?
