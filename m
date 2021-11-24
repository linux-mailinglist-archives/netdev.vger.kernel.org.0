Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8DD45D155
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 00:42:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232638AbhKXXp5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 18:45:57 -0500
Received: from mail.kernel.org ([198.145.29.99]:40452 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231135AbhKXXp4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 18:45:56 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id E592B60F12;
        Wed, 24 Nov 2021 23:42:45 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637797366;
        bh=P8Fzihl53yiLybvz3apsLgnQuDs7FjNFDTzfggAIbHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GNXcTNuJKc0/fU5FsTdyiG7id4y34FZJPj2HwZ7oygHbzNtsVQJMUmx25fNrONU25
         cCU3HFE1PmrkG5ODtljW1DpiWUaFAj3XpMKm0knLSIxNm8K1mxDjdB1gZD+DGVAuMP
         N9TE78WtLkahx+d52TlowHowMFe8xwWfREqShHmXYfPLPZMdAJAJMrJ0qn8dqkIXwe
         UbDHS6MPYS2rFjeRqmYi8Ni/kwtT1ytA6H59eJYTV/dxMqbyr6M3KSCbKOb98YxJpP
         7e3o7QzvIUrNBNEma+B4v7yFjB9R4xTSaMLnf7YeXi4ac4Ow8onfVRwuGEY3kZ9aq5
         5Jc6WleSDv8uw==
Date:   Wed, 24 Nov 2021 15:42:45 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Mitch Williams <mitch.a.williams@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        George Kuruvinakunnel <george.kuruvinakunnel@intel.com>
Subject: Re: [PATCH net-next 01/12] iavf: restore MSI state on reset
Message-ID: <20211124154245.3305f785@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124171652.831184-2-anthony.l.nguyen@intel.com>
References: <20211124171652.831184-1-anthony.l.nguyen@intel.com>
        <20211124171652.831184-2-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Nov 2021 09:16:41 -0800 Tony Nguyen wrote:
> If the PF experiences an FLR, the VF's MSI and MSI-X configuration will
> be conveniently and silently removed in the process. When this happens,
> reset recovery will appear to complete normally but no traffic will
> pass. The netdev watchdog will helpfully notify everyone of this issue.
> 
> To prevent such public embarrassment, restore MSI configuration at every
> reset. For normal resets, this will do no harm, but for VF resets
> resulting from a PF FLR, this will keep the VF working.

Why is this not a fix?
