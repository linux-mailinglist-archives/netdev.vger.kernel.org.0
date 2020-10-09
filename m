Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C54EF28919B
	for <lists+netdev@lfdr.de>; Fri,  9 Oct 2020 21:10:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2388456AbgJITKo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 9 Oct 2020 15:10:44 -0400
Received: from mail.kernel.org ([198.145.29.99]:37564 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726118AbgJITKo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 9 Oct 2020 15:10:44 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.7])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 966C62222C;
        Fri,  9 Oct 2020 19:10:43 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1602270643;
        bh=v2fLNDNw9E5Dxf8cWXPkBgDsi23Ey8d9d78t/u8unGE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=so9ZYu/RvKHhe4TT+/IS7Ctz3muGp/460kSp6a9O+esdDaYnsraNUdCiL1N0EK7GD
         Wbw8mu0rPAQqdXhfNyB/DxsGCa9i6IiNOa2D9bjjzQYKNHCW9QPZlqIHPNcmISuOMd
         RqqGTofCZDA0y+/Kf4QVp0M+e5dYZ5ViOf+TQZlg=
Date:   Fri, 9 Oct 2020 12:10:41 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@nvidia.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v2 00/16] Add devlink reload action and limit
 options
Message-ID: <20201009121041.7370f573@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
References: <1602050457-21700-1-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  7 Oct 2020 09:00:41 +0300 Moshe Shemesh wrote:
> Introduce new options on devlink reload API to enable the user to select
> the reload action required and constrains limits on these actions that he
> may want to ensure. Complete support for reload actions in mlx5.
> The following reload actions are supported:
>   driver_reinit: driver entities re-initialization, applying devlink-param
>                  and devlink-resource values.
>   fw_activate: firmware activate.

Applied, thanks everyone!
