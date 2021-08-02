Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id BCDB13DDDDA
	for <lists+netdev@lfdr.de>; Mon,  2 Aug 2021 18:41:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232781AbhHBQlJ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Aug 2021 12:41:09 -0400
Received: from mail.kernel.org ([198.145.29.99]:47744 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S229612AbhHBQlH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 2 Aug 2021 12:41:07 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id D9C4C61029;
        Mon,  2 Aug 2021 16:40:57 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1627922458;
        bh=j46n+fzH5oXsOa9Zy9IkpP71yOZ3R1yL/FG7pmQZfu8=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=W3y+R+aq521LvyDwmtmPKxz0ID3yBw+1fbIjJv0JQ6m27vXXy8YtqPvwcNk/QCw9V
         OrPAq7ETtbdaJD/oDIbyp3cmUfabcQke8PlGKAVhYNb2QsjprBvoE6jAStMSIianft
         xFSfHYSJ2tur7oNqyN5EwEaFbYYen4UvfR8NVjz2e3vGAJXn3IbkUX6Gkb4vijljqC
         hE1UQo7enBo19wi9tNWGIPnIRDyMpHpUcOM8WCB/zZcvDps9ZaIDaJsB04Zfhe3eaZ
         hUMmnAlHILf5o0yz6+yJIwMSA4PtF+zkI0iJcS09S6TnPeUcZ9HQ9hHSWQRKRxAjeM
         woIh2EtYA+QOw==
Date:   Mon, 2 Aug 2021 09:40:57 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Loic Poulain <loic.poulain@linaro.org>
Cc:     netdev@vger.kernel.org, johannes@sipsolutions.net,
        richard.laing@alliedtelesis.co.nz
Subject: Re: [PATCH net-next RESEND 2/2] net: mhi: Remove MBIM protocol
Message-ID: <20210802094057.57758281@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1627890663-5851-3-git-send-email-loic.poulain@linaro.org>
References: <1627890663-5851-1-git-send-email-loic.poulain@linaro.org>
        <1627890663-5851-3-git-send-email-loic.poulain@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon,  2 Aug 2021 09:51:03 +0200 Loic Poulain wrote:
> The MBIM protocol has now been integrated in a proper WWAN driver. We
> can then revert back to a simpler driver for mhi_net, which is used
> for raw IP or QMAP protocol (via rmnet link).
>=20
> - Remove protocol management
> - Remove WWAN framework usage (only valid for mbim)
> - Remove net/mhi directory for a simpler mhi_net.c file

drivers/net/mhi_net.c: In function =E2=80=98mhi_net_newlink=E2=80=99:
drivers/net/mhi_net.c:306:32: warning: variable =E2=80=98info=E2=80=99 set =
but not used [-Wunused-but-set-variable]
  306 |  const struct mhi_device_info *info;
      |                                ^~~~
