Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 337AF2524C2
	for <lists+netdev@lfdr.de>; Wed, 26 Aug 2020 02:32:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726716AbgHZAcG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Aug 2020 20:32:06 -0400
Received: from mail.kernel.org ([198.145.29.99]:47094 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726706AbgHZAcF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 25 Aug 2020 20:32:05 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EB75020707;
        Wed, 26 Aug 2020 00:32:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598401925;
        bh=MsToiOnzjzM9qd5VZ9Ti1hSzs9vQPVCx0r7VsqOTjsU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=zljRmqvDf1BFxbKYN7lpZPMc7VLFEH9NaNSocswv2KajgPwaDGNg5+P13+8ud/J9N
         6x2U3hM32bTq8kHHl+FQ1veaXo5/fhTh6KdcT0M6NZ4xH1gQoRtMYu9J+zoB3Bc2L4
         7nGte4LHTByR/iQMVkp03O9Ht9qbAhSFIVrSqRt4=
Date:   Tue, 25 Aug 2020 17:32:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, roid@mellanox.com,
        saeedm@mellanox.com, Jiri Pirko <jiri@nvidia.com>
Subject: Re: [PATCH net-next 2/3] devlink: Consider other controller while
 building phys_port_name
Message-ID: <20200825173203.2c80ed48@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200825135839.106796-3-parav@mellanox.com>
References: <20200825135839.106796-1-parav@mellanox.com>
        <20200825135839.106796-3-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 25 Aug 2020 16:58:38 +0300 Parav Pandit wrote:
> A devlink port may be for a controller consist of PCI device.
> A devlink instance holds ports of two types of controllers.
> (1) controller discovered on same system where eswitch resides
> This is the case where PCI PF/VF of a controller and devlink eswitch
> instance both are located on a single system.
> (2) controller located on other system.
> This is the case where a controller is located in one system and its
> devlink eswitch ports are located in a different system. In this case
> devlink instance of the eswitch only have access to ports of the
> controller.
> 
> When a devlink eswitch instance serves the devlink ports of both
> controllers together, PCI PF/VF numbers may overlap.
> Due to this a unique phys_port_name cannot be constructed.

This description is clear as mud to me. Is it just me? Can someone
understand this?
