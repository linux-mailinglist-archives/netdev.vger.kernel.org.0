Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 867712D4A8A
	for <lists+netdev@lfdr.de>; Wed,  9 Dec 2020 20:39:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387823AbgLITiN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 9 Dec 2020 14:38:13 -0500
Received: from mail.kernel.org ([198.145.29.99]:40912 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387803AbgLITiK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 9 Dec 2020 14:38:10 -0500
Date:   Wed, 9 Dec 2020 11:37:27 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607542649;
        bh=6Us6fY/6rkYgkZHdQt/DFMvdhHWAXIdbJPZtbrUcdjU=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=PhJMBnLltgKtJSzXrachkqadwU9+zvyq4Vpgai8lqsTNnn2OcjTP5liuyMnfBLd0A
         lsqW03huClsWzfjOKDvG1LHRxlnDyybblLkhgycOLCyADiowk/Reoi8oJ/brH6NqG6
         tGUjwAxZ41+k4M6BIkUwXw/7B7Rltgn4/ylAFUiI6WrxMRt5A+mCqYhJUpY74ts6L8
         GhWbKoGuS4d98gvIzgGJN17pO3yNbEs7zDd3vs/f9dt3rJ9t3DLnmIDVww6f/ci7fu
         WZYa30f5y6oS20as4ict2OEECGMXNOICBCzUeAfFrWfZW2v/zjqHs40CYLKCpfF1uh
         7e/1DA4LutTvA==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Pavana Sharma <pavana.sharma@digi.com>
Cc:     andrew@lunn.ch, ashkan.boldaji@digi.com,
        clang-built-linux@googlegroups.com, davem@davemloft.net,
        devicetree@vger.kernel.org, f.fainelli@gmail.com,
        gregkh@linuxfoundation.org, kbuild-all@lists.01.org,
        linux-kernel@vger.kernel.org, lkp@intel.com, marek.behun@nic.cz,
        netdev@vger.kernel.org, robh+dt@kernel.org,
        vivien.didelot@gmail.com
Subject: Re: [PATCH v11 0/4] Add support for mv88e6393x family of Marvell
Message-ID: <20201209113727.1b4bd319@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <cover.1607488953.git.pavana.sharma@digi.com>
References: <20201120015436.GC1804098@lunn.ch>
        <cover.1607488953.git.pavana.sharma@digi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed,  9 Dec 2020 15:02:54 +1000 Pavana Sharma wrote:
> Updated patchset after incorporating feedback.

This set does not apply to net-next. Please rebase.
