Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id C4F241DD714
	for <lists+netdev@lfdr.de>; Thu, 21 May 2020 21:20:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729988AbgEUTUH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 21 May 2020 15:20:07 -0400
Received: from mail.kernel.org ([198.145.29.99]:55540 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1729475AbgEUTUH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 21 May 2020 15:20:07 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id C1FCC207D3;
        Thu, 21 May 2020 19:20:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590088807;
        bh=AotBGvflE9/qgaVOMmFLR34xOAF7kiBzW/FbEMI7FRI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=aKbpUw90Tb3/IPQunft00NmMhLFCyPhujOfe2+QpdZ7YK7n+yRQLE90WjbnDHIk0J
         5Uoee6C+525yJFnMNJLK5oEo4CdjmZIYYwb9lBmzwBog2ew38GucOAVpFsTrSKxqmf
         D3u3EulQl6ioOzEihT253FF9K1H2DQ1YFt3OcWF4=
Date:   Thu, 21 May 2020 12:20:05 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>,
        Ido Schimmel <idosch@mellanox.com>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [PATCH net 0/2] netdevsim: Two small fixes
Message-ID: <20200521122002.7cadc814@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20200521114617.1074379-1-idosch@idosch.org>
References: <20200521114617.1074379-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 21 May 2020 14:46:15 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Fix two bugs observed while analyzing regression failures.
> 
> Patch #1 fixes a bug where sometimes the drop counter of a packet trap
> policer would not increase.
> 
> Patch #2 adds a missing initialization of a variable in a related
> selftest.

Acked-by: Jakub Kicinski <kuba@kernel.org>
