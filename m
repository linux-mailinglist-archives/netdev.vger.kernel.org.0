Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 37E2F492BB3
	for <lists+netdev@lfdr.de>; Tue, 18 Jan 2022 17:56:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243585AbiARQ4o (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 18 Jan 2022 11:56:44 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:34722 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231494AbiARQ4n (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 18 Jan 2022 11:56:43 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 7B57960B3B;
        Tue, 18 Jan 2022 16:56:43 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A7488C340E0;
        Tue, 18 Jan 2022 16:56:42 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642525002;
        bh=Ju/Q+t8liA9n9d0kVnBQwMlama48+8Kb5bDFdizZR7w=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=KMsh0z7CJqD6FsPcp+1+BgiTrBaEd+23qNE9OoGMxhk66Cb1sPHcajJbQKIU9uKrt
         UAW6bH+L1dgvuRIiU88zgyyUra/bV+qX0UqVVrlQoIvJQWgHkBYt4junVVQ9VH9QRK
         QV1qwjsfkHigEzzVYdUGG+wTD+2/yyoJFWqQzNo/0u/sdgOI2proROQfTvIauxRqYr
         3HvyzmV9YyIwfMKbO8mDzu3P5ztnQYjLI82KdEaAFGNw+c8LHT2k8sHmrVy3Q9BhXl
         tmi/j5EkKoeOjKrmUywvZBkyiS3iIdOjhy1mKzg8WF0pZcldeqH8c7V59qSi1QoUNN
         /xzyTgL6wHGmg==
Date:   Tue, 18 Jan 2022 08:56:41 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sasha Levin <sashal@kernel.org>
Cc:     linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "David S . Miller" <davem@davemloft.net>, netdev@vger.kernel.org
Subject: Re: [PATCH AUTOSEL 5.16 047/217] cirrus: mac89x0: use
 eth_hw_addr_set()
Message-ID: <20220118085641.6c0c7cc9@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220118021940.1942199-47-sashal@kernel.org>
References: <20220118021940.1942199-1-sashal@kernel.org>
        <20220118021940.1942199-47-sashal@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 17 Jan 2022 21:16:50 -0500 Sasha Levin wrote:
> From: Jakub Kicinski <kuba@kernel.org>
> 
> [ Upstream commit 9a962aedd30f7fceb828d3161a80e0526e358eb5 ]
> 
> Byte by byte assignments.
> 
> Fixes build on m68k.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>
> Signed-off-by: David S. Miller <davem@davemloft.net>
> Signed-off-by: Sasha Levin <sashal@kernel.org>

Hi Sasha! You can drop all the eth_hw_addr_set() patches.
They aren't fixes, I should have used a different verb, the point 
was to mention the arch where the driver is built. The patches are 
only needed in 5.17 where netdev->dev_addr becomes a const.

I think that's patches 34-47, 53.
