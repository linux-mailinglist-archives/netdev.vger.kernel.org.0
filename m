Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 087283F7978
	for <lists+netdev@lfdr.de>; Wed, 25 Aug 2021 17:54:21 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241415AbhHYPzC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 25 Aug 2021 11:55:02 -0400
Received: from mail.kernel.org ([198.145.29.99]:43436 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S237144AbhHYPzB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 25 Aug 2021 11:55:01 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 788C561101;
        Wed, 25 Aug 2021 15:54:15 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1629906855;
        bh=S4xgUaRQU3NPwE5tuMJi8LDeK3Zlm5SrF269EOwAmsc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Mt/2QQEt0TspzGpLj6dtasMSdwMKWchfL6gSbJBLX7aLdKhO77fwDRc7revIu4Bvw
         +ZOKN5CTgyUWi/PQXv//1+4ZD3Es+uplscg+Je9RU86hvEGx7IHKVI0ummuUaPOTgj
         suMPxRxWm+R2GPnyRe1mds+BgxsLqguJTeXUnzWkRgTQl9RLEPrmgd7s4ZtTVS+PIZ
         gNVq9AIqWbVo1Yhm7yHuUOjzPpDS55dgSC9aalSNIvrpFO5pXcSUHNK9u1b77xmv1b
         +OqVUFCTGMCjC63wQPto/vAlkmHVdfDpXoQsoTUQGLnjRYTSaYAfJ5khEes2jNeLnm
         fNcVD9FiXDM1w==
Date:   Wed, 25 Aug 2021 08:54:14 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sunil Goutham <sgoutham@marvell.com>
Cc:     <netdev@vger.kernel.org>, <davem@davemloft.net>
Subject: Re: [net-next PATCH 0/9] Octeontx2: Traffic shaping and SDP link
 config support
Message-ID: <20210825085414.13da8ce6@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
References: <1629893926-18398-1-git-send-email-sgoutham@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 25 Aug 2021 17:48:37 +0530 Sunil Goutham wrote:
> This patch series adds support for traffic shaping configuration
> on all silicons available after 96xx C0. And also adds SDP link
> related configuration needed when Octeon is connected as an end-point
> and traffic needs to flow from end-point to host and vice versa.

Please only post patches for features used by the PF / netdev driver.
It'd be useful if you listed in commit messages which netdev APIs in PF
exercise the AF functionality.
