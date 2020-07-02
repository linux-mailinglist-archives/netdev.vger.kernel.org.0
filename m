Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5C1782129E2
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 18:41:00 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726754AbgGBQk4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Jul 2020 12:40:56 -0400
Received: from mail.kernel.org ([198.145.29.99]:53132 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726724AbgGBQkz (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 2 Jul 2020 12:40:55 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 4371120720;
        Thu,  2 Jul 2020 16:40:55 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1593708055;
        bh=sITdUNLyXFWjTkrderpxZI6bqO0tr/PEyKDQbo4VZ68=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=oehgM+uIjFQ8KVeBUvERvmjFBCP88qGv3qanhUXOWa5yT8iLP4u4Cdag26xaXw+/S
         b+AjjfQ982tiEBKXbsN9iGIU13Ri+AMw5hSez+KXfYU7A3zRLFFIVdpNrsn1ZjC40x
         Oi0FO6ciuIMOfFGCBMX8c6z1LTu4qcozK77D2V+g=
Date:   Thu, 2 Jul 2020 09:40:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Moshe Shemesh <moshe@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jiri Pirko <jiri@mellanox.com>, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Vladyslav Tarasiuk <vladyslavt@mellanox.com>
Subject: Re: [PATCH net-next 5/7] devlink: Add devlink health port reporters
 API
Message-ID: <20200702094053.50252366@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1593702493-15323-6-git-send-email-moshe@mellanox.com>
References: <1593702493-15323-1-git-send-email-moshe@mellanox.com>
        <1593702493-15323-6-git-send-email-moshe@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Jul 2020 18:08:11 +0300 Moshe Shemesh wrote:
> From: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> 
> In order to use new devlink port health reporters infrastructure, add
> corresponding constructor and destructor functions.
> 
> Signed-off-by: Vladyslav Tarasiuk <vladyslavt@mellanox.com>
> Reviewed-by: Moshe Shemesh <moshe@mellanox.com>
> Reviewed-by: Jiri Pirko <jiri@mellanox.com>

net/core/devlink.c:5361: warning: Function parameter or member 'port' not described in 'devlink_port_health_reporter_create'
net/core/devlink.c:5361: warning: Excess function parameter 'devlink_port' description in 'devlink_port_health_reporter_create'
net/core/devlink.c:5462: warning: Excess function parameter 'port' description in 'devlink_port_health_reporter_destroy'
