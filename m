Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8A244250A46
	for <lists+netdev@lfdr.de>; Mon, 24 Aug 2020 22:48:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727123AbgHXUst (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Aug 2020 16:48:49 -0400
Received: from mail.kernel.org ([198.145.29.99]:38226 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726090AbgHXUst (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Aug 2020 16:48:49 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 66D792067C;
        Mon, 24 Aug 2020 20:48:48 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1598302128;
        bh=VY4oO7v0XkFesA6GrScKc8z8fmrFa3YfhqrK4++icyE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=srU2fq5yXC6HTrbHepG+qmK98aZ/GeNr6PYOfQ09OpvRdx8gr3hjeZfri2ybFx5Ni
         R0olAqmEm8aFJFwcSpuRWTZgXcpvEF0ZXbe+fs5OEafRHw/tQiYmCwpMfHY1YJ5Mnf
         6r4Apz08VXTeph3SVsY6kVi4bIogbhxbYs0aIF8U=
Date:   Mon, 24 Aug 2020 13:48:46 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Parav Pandit <parav@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net,
        Parav Pandit <parav@nvidia.com>
Subject: Re: [PATCH net-next 0/2] devlink fixes for port and reporter field
 access
Message-ID: <20200824134846.6125c838@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200821191221.82522-1-parav@mellanox.com>
References: <20200821191221.82522-1-parav@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Aug 2020 22:12:19 +0300 Parav Pandit wrote:
> From: Parav Pandit <parav@nvidia.com>
> 
> Hi Dave,
> 
> These series contains two small fixes of devlink.
> 
> Patch-1 initializes port reporter fields early enough to
> avoid access before initialized error.
> Patch-2 protects port list lock during traversal.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Why did you tag this for net-next, instead of net?
