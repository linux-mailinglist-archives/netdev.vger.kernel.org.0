Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DF1341785D4
	for <lists+netdev@lfdr.de>; Tue,  3 Mar 2020 23:44:39 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727502AbgCCWoi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Mar 2020 17:44:38 -0500
Received: from mail.kernel.org ([198.145.29.99]:36950 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725796AbgCCWoi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 3 Mar 2020 17:44:38 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.128])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 40E452072A;
        Tue,  3 Mar 2020 22:44:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1583275477;
        bh=wixUo3/bOUefOuSzQGthsOIHrt76K+VV3+YF3AvUrhk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KcmurqlZmsefMeWnaVWussQcXLh6jtQEEPsyErnWlijbrJCkdQFrC/L6SwRmsc7c/
         y15PvO/6oggNSbkuj34xDoKY5Ieo+O59sOqNU0wlu5KXoFMn7RX5Eb9rzQEe3QNU3R
         Y+sm6fm8JwOI5tEj11Jr0WNUyjr378af82KKckFY=
Date:   Tue, 3 Mar 2020 14:44:35 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        moshe@mellanox.com, vladyslavt@mellanox.com, saeedm@mellanox.com,
        leon@kernel.org
Subject: Re: [PATCH net-next 1/2] devlink: Introduce devlink port flavour
 virtual
Message-ID: <20200303144435.5aedb892@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200303141243.7608-2-parav@mellanox.com>
References: <20200303141243.7608-1-parav@mellanox.com>
        <20200303141243.7608-2-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue,  3 Mar 2020 08:12:42 -0600 Parav Pandit wrote:
> Currently mlx5 PCI PF and VF devlink devices register their ports as
> physical port in non-representors mode.
> 
> Introduce a new port flavour as virtual so that virtual devices can
> register 'virtual' flavour to make it more clear to users.
> 
> An example of one PCI PF and 2 PCI virtual functions, each having
> one devlink port.
> 
> $ devlink port show
> pci/0000:06:00.0/1: type eth netdev ens2f0 flavour physical port 0
> pci/0000:06:00.2/1: type eth netdev ens2f2 flavour virtual port 0
> pci/0000:06:00.3/1: type eth netdev ens2f3 flavour virtual port 0
> 
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>
> Signed-off-by: Parav Pandit <parav@mellanox.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
