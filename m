Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 412E535FE70
	for <lists+netdev@lfdr.de>; Thu, 15 Apr 2021 01:28:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237650AbhDNX2l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 14 Apr 2021 19:28:41 -0400
Received: from mail.kernel.org ([198.145.29.99]:50156 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235971AbhDNX2j (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 14 Apr 2021 19:28:39 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9AF5B611CC;
        Wed, 14 Apr 2021 23:28:17 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1618442897;
        bh=dy7aNrO04QFwWVi0TV4Vj3S4OttDB2RvWOrM4jZoi2E=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=nZ/JnmEv66PVk4c0dZefuK6GX2QTqwq70kap7EazmBvc0Nkl75EEgcHkxlbtE7XP/
         15TDaRlb+NE3kTm97Cy+pAMU8KOr+4gKBIQ6IuAxpTN/Hju4/r64Ou0wMoN2/BhYiU
         GN/k1/kkW/Bkk3UWPj9KW+P43+5eVuAt19gYfncQsFbftD3Du7B9bVLKh9KwB7D7QA
         /7PgN/E0J2HmwxPHFgcgUG4z/OGNSBUgRfKht67BXplyG0uBSuOGkJPGJPNXfn6JEo
         pvcQoIFuywrwmfsvOXJmmpEMZ3/mj154uc59tySrY3imjJf+eO+GI3MDEPWqqu8soe
         tUPj/AwFnCcBQ==
Date:   Wed, 14 Apr 2021 16:28:16 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com
Subject: Re: [PATCH net 0/3][pull request] Intel Wired LAN Driver Updates
 2021-04-14
Message-ID: <20210414162816.0bae6791@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
References: <20210414162032.3846384-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 14 Apr 2021 09:20:29 -0700 Tony Nguyen wrote:
> This series contains updates to ixgbe and ice drivers.
> 
> Alex Duyck fixes a NULL pointer dereference for ixgbe.
> 
> Yongxin Liu fixes an unbalanced enable/disable which was causing a call
> trace with suspend for ixgbe.
> 
> Colin King fixes a potential infinite loop for ice.

Acked-by: Jakub Kicinski <kuba@kernel.org>
