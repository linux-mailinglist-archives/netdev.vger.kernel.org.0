Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E2F03496993
	for <lists+netdev@lfdr.de>; Sat, 22 Jan 2022 04:27:36 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232316AbiAVD1b (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 21 Jan 2022 22:27:31 -0500
Received: from dfw.source.kernel.org ([139.178.84.217]:50864 "EHLO
        dfw.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231519AbiAVD1b (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 21 Jan 2022 22:27:31 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 9048861458;
        Sat, 22 Jan 2022 03:27:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 93ECFC340E1;
        Sat, 22 Jan 2022 03:27:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1642822050;
        bh=bmRAT8C/EEONJIfjt1Zr5giPTeAmn7yg1Bjde1SvRLc=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=C2sHKznPK1+co4HUheXh5IMQYSZ2jtD6oDGNqxv/NZbH/FsLokFvPjffrC+Z6aUUS
         jP0XkojMQ8nNwzzzdjMd9svgOWHxfN39f2Oq917U8EUXcTRbgN5oDdT8U+JVdzW5qg
         7j1zwm6pRISELpGrsZ0bXFT7Tue8hmqwrG4XfSzZxG/3DN/9VYtSjnXntua4XIuQm6
         LO1Qc05KdgPRyWOQad06+vH9elBnD2H1lWWqr50w53OxL2eKDu27jO/OQ9IUOsUJJ0
         aQ2ZXM2znzNatOM8s+R3MsFp/mLrBUAkcbqEJ3yt45+CbkmT9nMX7C+Ns1TqXC3w+8
         Aqh4gqtNWmjFQ==
Date:   Fri, 21 Jan 2022 19:27:28 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Justin Iurman <justin.iurman@uliege.be>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, shuah@kernel.org,
        linux-kselftest@vger.kernel.org, linux-kernel@vger.kernel.org,
        oliver.sang@intel.com, idosch@nvidia.com, lkp@lists.01.org,
        lkp@intel.com
Subject: Re: [PATCH net] selftests: net: ioam: Fixes b63c5478e9
Message-ID: <20220121192728.5f9170a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220121173449.26918-1-justin.iurman@uliege.be>
References: <20220121173449.26918-1-justin.iurman@uliege.be>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 21 Jan 2022 18:34:49 +0100 Justin Iurman wrote:
> Subject: [PATCH net] selftests: net: ioam: Fixes b63c5478e9

selftests: net: ioam: expect support for Queue depth data

> Date: Fri, 21 Jan 2022 18:34:49 +0100
> X-Mailer: git-send-email 2.25.1
> 
> The IOAM queue-depth data field was added a few weeks ago, but the test unit
> was not updated accordingly. Here is the fix, thanks for the report.

s/Here.*//

> Reported-by: kernel test robot <oliver.sang@intel.com>

Fixes: b63c5478e9cb ("ipv6: ioam: Support for Queue depth data field")

> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>

Applied, thanks!
