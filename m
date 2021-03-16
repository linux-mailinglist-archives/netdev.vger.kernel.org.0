Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 15CF533E0BA
	for <lists+netdev@lfdr.de>; Tue, 16 Mar 2021 22:43:49 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229517AbhCPVnQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 16 Mar 2021 17:43:16 -0400
Received: from mail.kernel.org ([198.145.29.99]:48248 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229482AbhCPVnC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 16 Mar 2021 17:43:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 9263A64F4F;
        Tue, 16 Mar 2021 21:43:01 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615930981;
        bh=pftnTCirYYPRJ/EliI+dWUWVFCFGrjBxpPq9IiFYGDg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=P9BGSy54fvXi7arKwZKE0jGcDow2pfKvokASednuBd+dKcVNA4lwxLq5aFgwhg+Yj
         Sg1JhreNZndnsesJHbQVsjwa6QJvlsuF5I+qkZPzd34YhPMI4A3h2eIqJCZQnvbWCX
         nyp8XIEcqiwGwLhujXLGMjhyvQLgrMEL0RAr11B2d/k5GHPxKrwKSvKzHqO1bzN4kz
         Gsey3WgWlBt2Qyl+8bL8hTnI8vNkUR29pow5gtnqPgO4C2iMHkuA9KHOioD8cKaZ8M
         8E1QCozSZUEh3MSHKjYkhxodV8XxQrYWazQxwQ+8OWBHI2PoWGqXqBOLtpNflrAKTK
         New4yBmZfy64g==
Date:   Tue, 16 Mar 2021 14:43:00 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Tony Nguyen <anthony.l.nguyen@intel.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, sassmann@redhat.com,
        bjorn.topel@intel.com, maciej.fijalkowski@intel.com,
        magnus.karlsson@intel.com
Subject: Re: [PATCH net-next 0/3][pull request] 40GbE Intel Wired LAN Driver
 Updates 2021-03-16
Message-ID: <20210316144300.3eaab365@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
References: <20210316164254.3744059-1-anthony.l.nguyen@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 16 Mar 2021 09:42:51 -0700 Tony Nguyen wrote:
> Optimize run_xdp_zc() for the XDP program verdict being XDP_REDIRECT
> in the xsk zero-copy path. This path is only used when having AF_XDP
> zero-copy on and in that case most packets will be directed to user
> space. This provides around 100k extra packets in throughput on my
> server when running l2fwd in xdpsock.

Looks reasonable:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
