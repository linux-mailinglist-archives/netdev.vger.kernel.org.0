Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BEB1D3F1E61
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:53:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229612AbhHSQyE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:54:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:34040 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229451AbhHSQyD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:54:03 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id AE0F06101A;
        Thu, 19 Aug 2021 16:53:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629392007;
        bh=V5n2joBBJ7/6phLyDLJ+0KM7i4GHf9jwmLm3M4r4Bf8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=DDnB8PiouJJRqQr/GgClBEdq3HKDC6SvDU+75agSH1eSapJtYoqwNufpCiRbqoM94
         v7O4zoazNsluaiRkXDR2e/Qts5MIbzBIfdoXRSbspPFGK6h+ONfo7o0xvCzXgBNPVW
         Z5INvFcem5zkwdbRnUjeqxFKMbKiHmfNIz2LUINu1J/DuTMGt0I46WJ6Jp8ewXlEM0
         vWfcZHQcgA88qni7OiDJStE5GqoFGw9HvO1yBZFuNbi5JLXDSNYaJvh9bLs7vkYZF/
         Tn8L1PLIgc9XQzuVgcS0qnm9BSPKAv9IS+HPB2Yv6uuoevKGOQmPYpNrT3hX9uocYp
         9U5akzH/w5Zfw==
Date:   Thu, 19 Aug 2021 09:53:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, Jacob Keller <jacob.e.keller@intel.com>,
        netdev@vger.kernel.org, Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net 1/1] ice: do not abort devlink info if PBA can't be
 found
Message-ID: <20210819095325.5694e925@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
References: <20210818174659.4140256-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 10:46:59 -0700 Tony Nguyen wrote:
> From: Jacob Keller <jacob.e.keller@intel.com>
> 
> The devlink dev info command reports version information about the
> device and firmware running on the board. This includes the "board.id"
> field which is supposed to represent an identifier of the board design.
> The ice driver uses the Product Board Assembly identifier for this.

Since I'm nit picking I would not use PBA in the subject 'cause to most
devs this means pending bit array.
