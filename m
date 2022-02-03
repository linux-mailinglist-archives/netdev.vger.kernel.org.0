Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E5A3E4A7C56
	for <lists+netdev@lfdr.de>; Thu,  3 Feb 2022 01:07:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348302AbiBCAGk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Feb 2022 19:06:40 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33782 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348299AbiBCAGf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Feb 2022 19:06:35 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8A040C06173D;
        Wed,  2 Feb 2022 16:06:34 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2883661706;
        Thu,  3 Feb 2022 00:06:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 3D197C340EC;
        Thu,  3 Feb 2022 00:06:33 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643846793;
        bh=dGZvdQzdOZtVcN74nAhfxuEEnHPJRLYx/VBd8b7uCHY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X03zhYpxeEU4a8YashBLV/UTetRkvXLn4plkwInNLCiEbQBYGmZxSJJDqt3Sdr3+q
         LsZwmKAKx904TXfWFHLLZOP4KC7nVME+7kjYAN6PJBnT/uy54UllJYfTRi9vEbVZ68
         0thpn8xOF7hZgxjbnEEE/FYm7cPQ6XsKMZi1PeKs4CAi4Vnxp/+ybTw9F/PXBqtiIS
         8Z83xvE5n4JRqxOn5ea3CewpVTTbYgJaIxD+sL+kayCd/NqoQYySqjb2gJS1WeBbzu
         bFvJ6H71u1sZR3X50OiRgYP3dFELGZ/71HM1ifjbvc2KfmlfSEMjzhkRTOwvKE1gbJ
         WpJ4i5eNZDj2A==
Date:   Wed, 2 Feb 2022 16:06:31 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jonathan Toppins <jtoppins@redhat.com>
Cc:     netdev@vger.kernel.org, intel-wired-lan@lists.osuosl.org,
        lihong.yang@intel.com,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ice: change "can't set link" message to dbg level
Message-ID: <20220202160631.7db4e729@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
References: <b25f9e524c404820b310c73012507c8e65a2ef97.1643834329.git.jtoppins@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  2 Feb 2022 15:38:49 -0500 Jonathan Toppins wrote:
> -			dev_warn(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
> +			dev_dbg(dev, "can't set link to %s, err %d aq_err %s. not fatal, continuing\n",
>  				 (ena ? "ON" : "OFF"), status,
>  				 ice_aq_str(hw->adminq.sq_last_status));

Start of continuation lines needs to be adjusted.
