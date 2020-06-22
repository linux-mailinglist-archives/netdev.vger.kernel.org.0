Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D24952043AD
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:31:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730969AbgFVWbx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:31:53 -0400
Received: from mail.kernel.org ([198.145.29.99]:58002 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730785AbgFVWbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:31:52 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id D9C6C20656;
        Mon, 22 Jun 2020 22:31:51 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592865112;
        bh=LuLj41vB7J88wcP6TldugCURGcbyrRV5XqhWW8ElRFE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=i3AWRNQje2/DTATyFA7oTrFX9RJq/2UuIJ64tlcVMOjl9p61pqG0utagAqXEOAj5a
         ErsTj5ao5G7zzjsIAolUerC+4ss0lTGUvDFPK1g9+SFBJwj8mplTzabAIJf19Eyu0I
         gEncGwD/aQkhTmNSRZui1E6MG9uJ+TJYgMj2f/uM=
Date:   Mon, 22 Jun 2020 15:31:50 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, jiri@mellanox.com,
        petrm@mellanox.com, mlxsw@mellanox.com,
        Ido Schimmel <idosch@mellanox.com>
Subject: Re: [PATCH net-next 0/4] mlxsw: Offload TC action pedit munge
 tcp/udp sport/dport
Message-ID: <20200622153150.44751d9f@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200621083436.476806-1-idosch@idosch.org>
References: <20200621083436.476806-1-idosch@idosch.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 21 Jun 2020 11:34:32 +0300 Ido Schimmel wrote:
> From: Ido Schimmel <idosch@mellanox.com>
> 
> Petr says:
> 
> On Spectrum-2 and Spectrum-3, it is possible to overwrite L4 port number of
> a TCP or UDP packet in the ACL engine. That corresponds to the pedit munges
> of tcp and udp sport resp. dport fields. Offload these munges on the
> systems where they are supported.
> 
> The current offloading code assumes that all systems support the same set
> of fields. This now changes, so in patch #1 first split handling of pedit
> munges by chip type. The analysis of which packet field a given munge
> describes is kept generic.
> 
> Patch #2 introduces the new flexible action fields. Patch #3 then adds the
> new pedit fields, and dispatches on them on Spectrum>1.
> 
> Patch #4 adds a forwarding selftest for pedit dsfield, applicable to SW as
> well as HW datapaths.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
