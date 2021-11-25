Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DB98945D23A
	for <lists+netdev@lfdr.de>; Thu, 25 Nov 2021 01:48:56 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343797AbhKYAwA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Nov 2021 19:52:00 -0500
Received: from mail.kernel.org ([198.145.29.99]:51672 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1343836AbhKYAuA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Nov 2021 19:50:00 -0500
Received: by mail.kernel.org (Postfix) with ESMTPSA id DC6F9610C8;
        Thu, 25 Nov 2021 00:46:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1637801210;
        bh=x+Irm6BBVdjUP/y8Y6kPW6Nbe6aQsnPfkWZ4NsriQUY=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RDzYWH6LBtXYm7prrirggR9VskCFOFpiEnEPAm+Liy0TDI6gtCo6jd8us2Mv+gpFM
         zGom5nHuoiGDm5CFocYNteKtZ4XtKfc/QgG+zuoJJ1V+ksgUyQZqN4xAdOTD+Ftrsd
         d5XrvAsFeWoHf2ul4LVxVOLyas8EVPuOO8LD8QiZ5QHFZuAxyXFr4D9z5/HXuu3zPO
         inPSzf6mDg6Mc1N7hpQr7jcyaQaVNGVZ4zQboP5iSJybuzil/CzPh1kHuJ5laNC2mm
         kefbv9pQmXPPVLkl5/eB1oNn7FSnaQ+3Kx5EWHEmtD4uFUVIOIgYzx7Ge3W/BjPOGa
         G/vaXhxDqLqsg==
Date:   Wed, 24 Nov 2021 16:46:48 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org, ath10k@lists.infradead.org,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Kalle Valo <kvalo@codeaurora.org>
Subject: Re: [Bug 215129] New: Linux kernel hangs during power down
Message-ID: <20211124164648.43c354f4@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20211124144505.31e15716@hermes.local>
References: <20211124144505.31e15716@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Adding Kalle and Hainer.

On Wed, 24 Nov 2021 14:45:05 -0800 Stephen Hemminger wrote:
> Begin forwarded message:
> 
> Date: Wed, 24 Nov 2021 21:14:53 +0000
> From: bugzilla-daemon@bugzilla.kernel.org
> To: stephen@networkplumber.org
> Subject: [Bug 215129] New: Linux kernel hangs during power down
> 
> 
> https://bugzilla.kernel.org/show_bug.cgi?id=215129
> 
>             Bug ID: 215129
>            Summary: Linux kernel hangs during power down
>            Product: Networking
>            Version: 2.5
>     Kernel Version: 5.15
>           Hardware: All
>                 OS: Linux
>               Tree: Mainline
>             Status: NEW
>           Severity: normal
>           Priority: P1
>          Component: Other
>           Assignee: stephen@networkplumber.org
>           Reporter: martin.stolpe@gmail.com
>         Regression: No
> 
> Created attachment 299703
>   --> https://bugzilla.kernel.org/attachment.cgi?id=299703&action=edit    
> Kernel log after timeout occured
> 
> On my system the kernel is waiting for a task during shutdown which doesn't
> complete.
> 
> The commit which causes this behavior is:
> [f32a213765739f2a1db319346799f130a3d08820] ethtool: runtime-resume netdev
> parent before ethtool ioctl ops
> 
> This bug causes also that the system gets unresponsive after starting Steam:
> https://steamcommunity.com/app/221410/discussions/2/3194736442566303600/
> 

