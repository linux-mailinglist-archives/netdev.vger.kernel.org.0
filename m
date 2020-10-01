Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D91052808D8
	for <lists+netdev@lfdr.de>; Thu,  1 Oct 2020 22:55:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727172AbgJAUy4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 1 Oct 2020 16:54:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:44788 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726515AbgJAUy4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 1 Oct 2020 16:54:56 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 8A52F20738;
        Thu,  1 Oct 2020 20:54:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1601585695;
        bh=SjmdQT/xowg1GrQZByhxKNZm5Btq5Bqi/jfw9XlnQP4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=WLCTM/cDciFV0g70Qi2DEeiebne3c1E03kClrfL9hPXhRh5qQMMyMxSrJvawYbhA4
         KLaetytFp1AO/ABrSOIHlgGGDERI2Mq56Ee2EyNbnp8aXROdhLveJgfL5txuOne9Qu
         gfP9RFXQj2iC7aA/5ScMHra7r1vQwhWGVf4XVrIU=
Date:   Thu, 1 Oct 2020 13:54:54 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 01/16] devlink: Change
 devlink_reload_supported() param type
Message-ID: <20201001135454.668bafca@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1601560759-11030-2-git-send-email-moshe@mellanox.com>
References: <1601560759-11030-1-git-send-email-moshe@mellanox.com>
        <1601560759-11030-2-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  1 Oct 2020 16:59:04 +0300 Moshe Shemesh wrote:
> Change devlink_reload_supported() function to get devlink_ops pointer
> param instead of devlink pointer param.
> This change will be used in the next patch to check if devlink reload is
> supported before devlink instance is allocated.
> 
> Signed-off-by: Moshe Shemesh <moshe@mellanox.com>

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
