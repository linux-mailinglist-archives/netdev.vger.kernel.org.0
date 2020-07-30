Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C51E0233BEE
	for <lists+netdev@lfdr.de>; Fri, 31 Jul 2020 01:11:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730625AbgG3XLE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Jul 2020 19:11:04 -0400
Received: from mail.kernel.org ([198.145.29.99]:53170 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728588AbgG3XLD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 30 Jul 2020 19:11:03 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id DAE4020809;
        Thu, 30 Jul 2020 23:11:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1596150663;
        bh=d7EuQ0AAcl/JAtg15EpS6qwrrRhGuijEjeshu+bi+fQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yKMAJx19arwhG8RMKjMSXZm20W5syYg2r9Vfi5N5havOQGeHUQ0zxA6h+j/rEJYdH
         xZH2sLoG8q8tRRYG6pQ8qa/bDOapthREjYdv+uodN7gaLgpudBs065yAV/57MLiQda
         E/YRl27bjYeYXfOi/qIT8O7fVCLPYDJnyoTBT+0I=
Date:   Thu, 30 Jul 2020 16:11:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     Jacob Keller <jacob.e.keller@intel.com>,
        Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>,
        Vasundhara Volam <vasundhara-v.volam@broadcom.com>
Subject: Re: [PATCH net-next RFC 01/13] devlink: Add reload level option to
 devlink reload command
Message-ID: <20200730161101.48f42c5b@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
References: <1595847753-2234-1-git-send-email-moshe@mellanox.com>
        <1595847753-2234-2-git-send-email-moshe@mellanox.com>
        <20200727175802.04890dd3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <20200728135808.GC2207@nanopsycho>
        <464add44-3ab1-21b8-3dba-a88202350bb9@intel.com>
        <20200728114458.762b5396@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <d6fbfedd-9022-ff67-23ed-418607beecc2@intel.com>
        <20200728130653.7ce2f013@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <04f00024-758c-bc19-c187-49847c24a5a4@mellanox.com>
        <20200729140708.5f914c15@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <3352bd96-d10e-6961-079d-5c913a967513@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 30 Jul 2020 15:30:45 +0300 Moshe Shemesh wrote:
> >>> My expectations would be that the driver must perform the lowest
> >>> reset level possible that satisfies the requested functional change.
> >>> IOW driver may do more, in fact it should be acceptable for the
> >>> driver to always for a full HW reset (unless --live or other
> >>> constraint is specified).  
> >> OK, but some combinations may still not be valid for specific driver
> >> even if it tries lowest level possible.  
> > Can you give an example?  
> 
> For example take the combination of fw-live-patch and param-init.
> 
> The fw-live-patch needs no re-initialization, while the param-init 
> requires driver re-initialization.
> 
> So the only way to do that is to the one command after the other, not 
> really combining.

You need to read my responses more carefully. I don't have
fw-live-patch in my proposal. The operation is fw-activate,
--live is independent and an constraint, not an operation.
