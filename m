Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 10F182AFF17
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:44:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728222AbgKLFdT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:33:19 -0500
Received: from mail.kernel.org ([198.145.29.99]:42046 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728781AbgKLEZI (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 11 Nov 2020 23:25:08 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 2917821D7F;
        Thu, 12 Nov 2020 04:25:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605155107;
        bh=8sutQP2g6+2FvcSJGm6ODqq3AlhqhuOPqB5Qtu/fCtk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=l0xIy45S9d2g6Sl7c+LPCo5WPT/s09Ad2p6fVLOHVCTq0mKg4K8stc+gYPqtyJcVj
         1qirrXznJ09DCigeAtgqyHZEQuKHpptxGTXfZjVhOxV4Yj9sNQljwRi5+BnDcnxp8w
         Yj9836lZAh2Opy2netQjjkXrOvY2Jo2Ha3JbD0i8=
Date:   Wed, 11 Nov 2020 20:25:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     David Ahern <dsahern@gmail.com>
Cc:     Ido Schimmel <idosch@idosch.org>, netdev@vger.kernel.org,
        davem@davemloft.net, mlxsw@nvidia.com,
        Ido Schimmel <idosch@nvidia.com>
Subject: Re: [PATCH net-next] ipv4: Set nexthop flags in a more consistent
 way
Message-ID: <20201111202506.46f93074@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <53a29984-1767-2017-ccae-5b821fd5fbdf@gmail.com>
References: <20201110102553.1924232-1-idosch@idosch.org>
        <53a29984-1767-2017-ccae-5b821fd5fbdf@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 08:25:50 -0700 David Ahern wrote:
> On 11/10/20 3:25 AM, Ido Schimmel wrote:
> > From: Ido Schimmel <idosch@nvidia.com>
> > 
> > Be more consistent about the way in which the nexthop flags are set and
> > set them in one go.
> > 
> > Suggested-by: Jakub Kicinski <kuba@kernel.org>
> > Signed-off-by: Ido Schimmel <idosch@nvidia.com>
> 
> Reviewed-by: David Ahern <dsahern@kernel.org>

Applied, thanks!
