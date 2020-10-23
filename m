Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 019682976CA
	for <lists+netdev@lfdr.de>; Fri, 23 Oct 2020 20:20:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1754385AbgJWSUa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Oct 2020 14:20:30 -0400
Received: from mail.kernel.org ([198.145.29.99]:51460 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1750463AbgJWSU3 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Oct 2020 14:20:29 -0400
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.6])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id B64832192A;
        Fri, 23 Oct 2020 18:20:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1603477229;
        bh=QjJQ1djuvt9qqAazUX+8bLpM2PEI9Imum/LHktieF4U=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FHRrRMChg5JF4NMkb06ect8VeyjcQkkpZjw/lBsYd5FVj/jdsAKRNLA2vVWgXb/0h
         GEVAsYEq3ZplQtFI3JAdPdYb1e7XuYlmpmWl4WRUo0PewI2tvHghjSqP/QSgnAP8QH
         oRMlm9EVrdKb9zeIxe3ojJYHpuGWfOp3DeYN1GGc=
Date:   Fri, 23 Oct 2020 11:20:27 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     izabela.bakollari@gmail.com
Cc:     nhorman@tuxdriver.com, davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        linux-kernel-mentees@lists.linuxfoundation.org
Subject: Re: [PATCHv4 net-next] dropwatch: Support monitoring of dropped
 frames
Message-ID: <20201023112027.74ae41d1@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201023042943.563284-1-izabela.bakollari@gmail.com>
References: <20200707171515.110818-1-izabela.bakollari@gmail.com>
        <20201023042943.563284-1-izabela.bakollari@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 23 Oct 2020 06:29:43 +0200 izabela.bakollari@gmail.com wrote:
> From: Izabela Bakollari <izabela.bakollari@gmail.com>
> 
> Dropwatch is a utility that monitors dropped frames by having userspace
> record them over the dropwatch protocol over a file. This augument
> allows live monitoring of dropped frames using tools like tcpdump.
> 
> With this feature, dropwatch allows two additional commands (start and
> stop interface) which allows the assignment of a net_device to the
> dropwatch protocol. When assinged, dropwatch will clone dropped frames,
> and receive them on the assigned interface, allowing tools like tcpdump
> to monitor for them.
> 
> With this feature, create a dummy ethernet interface (ip link add dev
> dummy0 type dummy), assign it to the dropwatch kernel subsystem, by using
> these new commands, and then monitor dropped frames in real time by
> running tcpdump -i dummy0.
> 
> Signed-off-by: Izabela Bakollari <izabela.bakollari@gmail.com>

Doesn't seem to apply to net-next, also the tree is closed during the
merge window so please rebase and repost after the weekend.
