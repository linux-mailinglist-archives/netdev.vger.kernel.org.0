Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1C1E245D160
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:48:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236677AbhKXXvX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:51:23 -0500
Received: from mail.kernel.org ([198.145.29.99]:46132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S236517AbhKXXvX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:51:23 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id B2C9960E73;
        Wed, 24 Nov 2021 23:48:12 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797693;
        bh=4CdX71zL+7l5r2q5yyR6jr4el5WvjLvhrzjFQhiaA3U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=SJNOLez/tYFIuBzdqj/T28aWVhuXgnVeyxPJu9D0iJTyvZ+C9dtV3ImTpx51xtVm+
         rH2NCK/35AGmcS4405bNF+PznkZUIxc4ydInCml2jqoa1cJYbHFZovEi2RD9kjdM2c
         5HS4sZ8iR4Byfrr4dz0LbeTcdaWVAN9UrFD6DLUb7uloc/OKxIj4gScQ8xPHAhiXt6
         b+GUgow2hl1EkjDx2wlwbLE5vnRCtx79x/8gvOy9IPPY1fgahD+nlbnjkRBUY31VKE
         hkbpMJ1XnMG8GLbRo3Uy8vYORQXmmlye45I4cimiAe0EJvF9iJdIej6LknQRWeQpz1
         zUs/Trc1sRdlA==
Date:   Wed, 24 Nov 2021 15:48:11 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Jedrzej Jagielski <jedrzej.jagielski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Arkadiusz Kubalewski <arkadiusz.kubalewski@intel.com>,
        Konrad Jankowski <konrad0.jankowski@intel.com>
Subject: Re: [PATCH net-next 06/12] iavf: Add trace while removing device
Message-ID: <20211124154811.6d9c48cb@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124171652.831184-7-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-7-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:16:46 -0800 Tony Nguyen wrote:
> Add kernel trace that device was removed.
> Currently there is no such information.
> I.e. Host admin removes a PCI device from a VM,
> than on VM shall be info about the event.
> 
> This patch adds info log to iavf_remove function.

Why is this an important thing to print to logs about?
If it is why is PCI core not doing the printing?
