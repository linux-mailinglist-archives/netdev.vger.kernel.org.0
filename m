Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0477B1C7A4D
	for <lists+netdev@lfdr.de>; Wed,  6 May 2020 21:31:25 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729152AbgEFTbX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 6 May 2020 15:31:23 -0400
Received: from mail.kernel.org ([198.145.29.99]:55178 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728433AbgEFTbW (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 6 May 2020 15:31:22 -0400
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 368AF20735;
        Wed,  6 May 2020 19:31:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1588793482;
        bh=1TP8rtzV7O0raEK5e9E1kjqnmHw7XH1LJQgjF7ZCdOU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=EWRNVTbRpdy42CZcpOf28algdTNaGRelKTNNOe7G9MxS5bDBwBdjFT4VhjVTkoAoq
         Aljx/ABNyvP7P7VIyFnwijouXLagJ06Cc7EX1tdZJVQg63E11QzhYMbo1xlyfuFc0h
         ict+863Vt3XQbtz9veCmkqBHjfbiakJztkFlMIq0=
Date:   Wed, 6 May 2020 12:31:20 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Igor Russkikh <irusskikh@marvell.com>
Cc:     <netdev@vger.kernel.org>, "David S . Miller" <davem@davemloft.net>,
        Ariel Elior <aelior@marvell.com>,
        Michal Kalderon <mkalderon@marvell.com>,
        Denis Bolotin <dbolotin@marvell.com>,
        Ariel Elior <ariel.elior@marvell.com>,
        Michal Kalderon <michal.kalderon@marvell.com>
Subject: Re: [PATCH net-next 06/12] net: qed: gather debug data on hw errors
Message-ID: <20200506123120.02d4c04f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <a380a45a885034c9b19cd1fe786854e8a65a8088.1588758463.git.irusskikh@marvell.com>
References: <cover.1588758463.git.irusskikh@marvell.com>
        <a380a45a885034c9b19cd1fe786854e8a65a8088.1588758463.git.irusskikh@marvell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 6 May 2020 14:33:08 +0300 Igor Russkikh wrote:
> To implement debug dump retrieval on a live system we add callbacks to
> collect the same data which is collected now during manual `ethtool -d`
> call.
> 
> But we instead collect the dump immediately at the moment bad thing
> happens, and save it for later retrieval by the same `ethtool -d`.
> 
> To have ability to track this event, we add kobject uevent trigger,
> so udev event handler script could be used to automatically collect dumps.

No way. Please use devlink health. Instead of magic ethtool dumps and
custom udev.
