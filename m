Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 02A721E322A
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 00:14:43 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391834AbgEZWOk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 May 2020 18:14:40 -0400
Received: from mail.kernel.org ([198.145.29.99]:50382 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2390125AbgEZWOk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 26 May 2020 18:14:40 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 745FB208E4;
        Tue, 26 May 2020 22:14:39 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1590531279;
        bh=WNNrEBrRm5KQIcFUGq2TRMx27B76ntCZRhP1oAZarAY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FMN2hWIdPIBiaMtsGkpuCZ4zzLrzXrSUx1y95Ma8wbiEOfr/GNBW3xx8zpRKFyikG
         a6sZLIiHHw9nfrPoRv23PAV2DijbnSSsTG7+sYtHRk+0Xy8QThWtb+fH3a7j+/pd86
         gTP3fwLbqPiJadktGjnaEGsuT2P/pPicoO57dWQo=
Date:   Tue, 26 May 2020 15:14:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        mlxsw@mellanox.com, Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 00/14] mlxsw: Various trap changes - part 2
Message-ID: <20200526151437.6fc3fb67@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20200525230556.1455927-1-idosch@idosch.org>
References: <20200525230556.1455927-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 26 May 2020 02:05:42 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> This patch set contains another set of small changes in mlxsw trap
> configuration. It is the last set before exposing control traps (e.g.,
> IGMP query, ARP request) via devlink-trap.

When traps were introduced my understanding was that they are for
reporting frames which hit an expectation on the datapath. IOW the
primary use for them was troubleshooting. 

Now, if I'm following things correctly we have explicit DHCP, IGMP,
ARP, ND, BFD etc. traps. Are we still in the troubleshooting realm?
