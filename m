Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E39F631FDEA
	for <lists+netdev@lfdr.de>; Fri, 19 Feb 2021 18:33:15 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229840AbhBSRcm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Feb 2021 12:32:42 -0500
Received: from mail.kernel.org ([198.145.29.99]:36128 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229810AbhBSRcl (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 19 Feb 2021 12:32:41 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 2624B64E67;
        Fri, 19 Feb 2021 17:32:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1613755920;
        bh=WWA01gKLavXvx07cxmJW1uoeLQuBksjLA4f/DZLGVz8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=X8pVwdifz26BqzsUThsmPuu5uW8kg2qiQXn3NJ4fNPLTlibguOdxuEAfs+d4Jw4Et
         WGKK81DR6j2WknGAk7cE64RYdK5wGD0ZipruyF6ftLgcRrZyr0ZAr3dYFBV+AwrfzI
         hTAWS9TeM1M02ytHApFrSo3eQ/2Jc+Sw6YkhjP7fKrwbsozd8tsTu35aWrM12ZwC1K
         CgfQgb7i0E4bRXR0tDFffz1m/xP/pL2WcH3Txlp4yvJSLTiADfUKBMScJ1nDI5SiIc
         +e+P3dMXKOISL7dyJNi1rLRsfNjS0y/6hZZJXp8MrEoZ45GQz2JWwAPLXytWIGjUlG
         rEx5QxFFafmwA==
Date:   Fri, 19 Feb 2021 09:31:59 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net,
        Mateusz Palczewski <mateusz.palczewski@intel.com>,
        netdev@vger.kernel.org, sassmann@redhat.com,
        Grzegorz Szczurek <grzegorzx.szczurek@intel.com>,
        Jaroslaw Gawin <jaroslawx.gawin@intel.com>,
        Tony Brelinski <tonyx.brelinski@intel.com>
Subject: Re: [PATCH net 7/8] i40e: Fix add TC filter for IPv6
Message-ID: <20210219093159.4a6fc853@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210218232504.2422834-8-anthony.l.nguyen@intel.com>
References: <20210218232504.2422834-1-anthony.l.nguyen@intel.com>
        <20210218232504.2422834-8-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Feb 2021 15:25:03 -0800 Tony Nguyen wrote:
> From: Mateusz Palczewski <mateusz.palczewski@intel.com>
> 
> Fix insufficient distinction between IPv4 and IPv6 addresses
> when creating a filter.
> IPv4 and IPv6 are kept in the same memory area. If IPv6 is added,
> then it's caught by IPv4 check, which leads to err -95.
> 
> Fixes: 2f4b411a3d67("i40e: Enable cloud filters via tc-flower")

Small issue with the fixes tag here - missing space after hash.

Dave said he can't take any patches until Linus gets power back and
pulls so since we're waiting perhaps you could fix and repost?

The patches look good to me.
