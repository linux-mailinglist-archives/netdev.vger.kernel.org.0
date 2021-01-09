Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4DE1C2F03A3
	for <lists+netdev@lfdr.de>; Sat,  9 Jan 2021 21:57:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726198AbhAIU4k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 9 Jan 2021 15:56:40 -0500
Received: from mail.kernel.org ([198.145.29.99]:60546 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726062AbhAIU4k (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 9 Jan 2021 15:56:40 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id 6223623AC4;
        Sat,  9 Jan 2021 20:55:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1610225759;
        bh=KE9Rpn6rRe3yNNFAaPOB3N77Cz2hiyC9gHBMCdd0xQw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=t2HhqloDX1zPkv+jxC1rpNo+I/F5ZWhdtua5X5XYSNsOpVofI7b8DSGLFvifEWgsD
         CeBJ6HqYxiell/k7MxgvARir0MZkBkWmiDZDlpzA7RnbopL2EzscFu618PyIAtaczJ
         PswVzl/7IZWSt2Su3ZDVLnMxiWpI24tky55TXrEf0marcJ/pA6DFOETlBu1S0N0buv
         ixZgRbPkKQETQl1crIZbTy9sY49TGXEs/fyYn9Of5XYfcLhkVCEa6IN/6UsNh0Ycgu
         4tqksVmK7qOTA/+YgHFPnr+nuVtt1irrYyZJ7Uvz08SlwJbk+TCP8YSoq4DBldlvXi
         8Vxg8PBznnY+g==
Date:   Sat, 9 Jan 2021 12:55:58 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Raits <igor.raits@gmail.com>
Cc:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Kernel panic on shutdown (qede+bond+bridge) - KASAN:
 use-after-free in netif_skb_features+0x90a/0x9b0
Message-ID: <20210109125558.0d666227@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <ecd964430ff124469ba48e289cf2e7404fcdc068.camel@gmail.com>
References: <ecd964430ff124469ba48e289cf2e7404fcdc068.camel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 07 Jan 2021 00:15:24 +0100 Igor Raits wrote:
> I've been trying out the latest CentOS 8 Stream kernel and found that I
> get kernel panic (https://bugzilla.redhat.com/show_bug.cgi?id=1913481)
> when trying to reboot the server. With debug kernel I've got following:
> 
> [  531.818434]
> ==================================================================
> [  531.818435] BUG: KASAN: use-after-free in
> netif_skb_features+0x90a/0x9b0
> [  531.818436] Read of size 8 at addr ffff893c74d54b50 by task systemd-
> shutdow/1
> [  531.818436]                            
> [  531.818437] CPU: 20 PID: 1 Comm: systemd-shutdow Tainted: G        W
> I      --------- -  - 4.18.0-259.el8.x86_64+debug #1
> [  531.818438] Hardware name: HPE ProLiant DL380 Gen10/ProLiant DL380
> Gen10, BIOS U30 07/16/2020

Have you managed to find a fix? If not perhaps try an upstream build?
Unlikely someone here will be willing to help with a RHEL kernel, and
we can't even access the bug report in bugzilla.
