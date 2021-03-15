Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CA9733C6EA
	for <lists+netdev@lfdr.de>; Mon, 15 Mar 2021 20:38:02 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233699AbhCOTh3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 15 Mar 2021 15:37:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:41266 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232186AbhCOThC (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 15 Mar 2021 15:37:02 -0400
Received: by mail.kernel.org (Postfix) with ESMTPSA id 1D3B564F47;
        Mon, 15 Mar 2021 19:37:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1615837022;
        bh=7AS2ErSF9VADFihPyC5/QYX3XsV2M2u9VPECi3UVeLI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=GyaOHwOkqIZ68av56VKfmKJcJ0gSj7eeg0xL+t1m/7ARc8pOUYIs2MHwI7tjQycAq
         1Glb/SuiHCiN9OBDzeuGBgM8p1KOkbPXUXlGtGQvvD0NgIQ0sa7psLlwjlqDifoVhV
         9M0ltJfimaGMpzbGSXY+E4q3dOZymJRg5hhSqwGQt6o/xPzQQfd4HCocZkjdpWQtEt
         +ptnX5GhAb4ojO00X5AwXlIS4gHYjca/tpcY1N+FvRs4ERSzZukr9EVgMZpubOTRy1
         Zkz6WBYgI/9MMt1CoDMmK96IzEnKNgpWlhlHTKFw5G4NIr5LUOR3ptxfJ/CZnt4aRC
         4KQqAH7DNKBgQ==
Date:   Mon, 15 Mar 2021 12:37:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, weiwan@google.com,
        nbd@nbd.name, pabeni@redhat.com, edumazet@google.com,
        hannes@stressinduktion.org, lorenzo.bianconi@redhat.com
Subject: Re: [PATCH net-next] net: export dev_set_threaded symbol
Message-ID: <20210315123701.736e5803@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <9ee5ba9ca7506620b1a9695896992bfdfb000469.1615733129.git.lorenzo@kernel.org>
References: <9ee5ba9ca7506620b1a9695896992bfdfb000469.1615733129.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, 14 Mar 2021 15:49:19 +0100 Lorenzo Bianconi wrote:
> For wireless devices (e.g. mt76 driver) multiple net_devices belongs to
> the same wireless phy and the napi object is registered in a dummy
> netdevice related to the wireless phy.
> Export dev_set_threaded in order to be reused in device drivers enabling
> threaded NAPI.
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jakub Kicinski <kuba@kernel.org>
