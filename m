Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0B613F1E80
	for <lists+netdev@lfdr.de>; Thu, 19 Aug 2021 18:58:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230447AbhHSQ7P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Aug 2021 12:59:15 -0400
Received: from mail.kernel.org ([198.145.29.99]:35474 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229642AbhHSQ7O (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 19 Aug 2021 12:59:14 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 4715760FE6;
        Thu, 19 Aug 2021 16:58:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629392318;
        bh=PEQYFrl8AN9mGBQxokduoEjP7E9oNDxFhMgsVGO86EI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Uv0OHyyfTUWPdwkeXdGKNnhJLwAsVS7z3d+315svEyboFbCJG2BgzlpcSPX+9soWA
         Exnc46EaeB38GfUwakwEHng3lOQXOJBRb91Z6BZlNI3EVkv7o9MhRBOvCwtDmZlLkT
         ary7f5cMn86RQkqDcj3tX94DB1egNK4ORyVTJZxoDLtaYzBhZeVSa0xFzrfWPMps+V
         VTbyp7U4GDr7bkzzj7c+STWwruzSvUaYDq9wbi6wxLmBIdYMATw8SfkYIadc7MvhF1
         n3aTQ+GE0c1Geor7w0T65xM8/PUcQOErecqHFbnRkGMuoxZkR7cTwcPLR/2BTJKf7M
         S/eN9mmR0W3kg==
Date:   Thu, 19 Aug 2021 09:58:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [PATCH net 0/2][pull request] Intel Wired LAN Driver Updates
 2021-08-18
Message-ID: <20210819095837.261a0dbf@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210818174217.4138922-1-anthony.l.nguyen@intel.com>
References: <20210818174217.4138922-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 18 Aug 2021 10:42:15 -0700 Tony Nguyen wrote:
> This series contains updates to i40e and iavf drivers.
> 
> Arkadiusz fixes Flow Director not using the correct queue due to calling
> the wrong pick Tx function for i40e.
> 
> Sylwester resolves traffic loss for iavf when it attempts to change its
> MAC address when it does not have permissions to do so.

Applied from the list because I had to correct the Fixes tag in 
the first patch, please be careful with those. Thanks!
