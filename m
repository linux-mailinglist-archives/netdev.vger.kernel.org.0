Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F2DF54681B5
	for <lists+netdev@lfdr.de>; Sat,  4 Dec 2021 02:06:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235129AbhLDBKI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Dec 2021 20:10:08 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:37716 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1354595AbhLDBKG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 3 Dec 2021 20:10:06 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 0C8C462D84
        for <netdev@vger.kernel.org>; Sat,  4 Dec 2021 01:06:42 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 34B66C341C1;
        Sat,  4 Dec 2021 01:06:41 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1638580001;
        bh=RuvL2fKixHgILgSiXvahR10MdGY667oAQ7GijQdJHS4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ICK72OyZ6fsO7XGx0lehkVo3e9HZIvvnNkt83PyXk2R71TyYZXPEWi4Uk+ldqlShI
         ZrelKOQbD2U/haTeeDhrjI6cTSwxPdFnYDRVZyEnPY6uvV48JUhBpeM78DRB0jfYlB
         fiNhQIEh16bMKepN+SQG++nIK10Z11Zt9ifO5+5KaXxCRnkEG/9u1dH4EEcQnDxSrR
         99VJ75mnyf8OW3CQnjNVYs4Lxc308NSLt/F26q69cFjP1UcqLiHTrbbXCl65dy7iHA
         lX9SSWrnr8S/vsg244JUHvhudvJM/pMEkqAEYLFMebZ3QkOCOHCgEiwHqCfvVTO1zI
         CPA4i3ndYY2og==
Date:   Fri, 3 Dec 2021 17:06:40 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     dsahern@gmail.com, Nicolas Dichtel <nicolas.dichtel@6wind.com>
Cc:     Lahav Schlesinger <lschlesinger@drivenets.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next v4] rtnetlink: Support fine-grained netdevice
 bulk deletion
Message-ID: <20211203170640.5ab42d00@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211202174502.28903-1-lschlesinger@drivenets.com>
References: <20211202174502.28903-1-lschlesinger@drivenets.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  2 Dec 2021 19:45:02 +0200 Lahav Schlesinger wrote:
> Under large scale, some routers are required to support tens of thousands
> of devices at once, both physical and virtual (e.g. loopbacks, tunnels,
> vrfs, etc).
> At times such routers are required to delete massive amounts of devices
> at once, such as when a factory reset is performed on the router (causing
> a deletion of all devices), or when a configuration is restored after an
> upgrade, or as a request from an operator.

LGTM, David, Nicolas, ack?

https://lore.kernel.org/all/20211202174502.28903-1-lschlesinger@drivenets.com/
