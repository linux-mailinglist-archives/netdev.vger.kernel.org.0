Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B76C2CF8CE
	for <lists+netdev@lfdr.de>; Sat,  5 Dec 2020 02:51:12 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730843AbgLEBtK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Dec 2020 20:49:10 -0500
Received: from mail.kernel.org ([198.145.29.99]:58332 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727225AbgLEBtK (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 4 Dec 2020 20:49:10 -0500
Date:   Fri, 4 Dec 2020 17:48:28 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607132910;
        bh=99YpDeQm5sbHZzFHrWTNOoOMq76A7Lg2w14V/f0JXRE=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=rp8x8XvlKrSwYDydy4dlEftDPPpFZpJmD/62/1ZAXkQi4Q83ZcB2+GTI682jlGZ2k
         9LM8NNbNscJTcqxXjHJ6Yyk0O6PXrECxetliANtM5IEgOxwuAwMmWDyhYcJI+a6Ge+
         S3+Tw3DnJm68D6MEOMZASVD4cwmHvsrwubkkzDrzegE35ohZdCHAHeLRML90KCrQXx
         +l41D7CGa4N2mhudkyfLnnMP2pHYG6SBOusky/Fdm+ksry2swfixbsXlGdbT9CzomD
         F3eMMuZyup138z34RNHIgnx3OotHm9Jgn5GZheyBmM1BhwwTTZ+kHv5+JC8VrGy7q8
         f5//t0mCzjGnw==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Bongsu Jeon <bongsu.jeon2@gmail.com>
Cc:     linux-nfc@lists.01.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Bongsu Jeon <bongsu.jeon@samsung.com>
Subject: Re: [PATCH net-next v4] net/nfc/nci: Support NCI 2.x initial
 sequence
Message-ID: <20201204174828.7f2fec74@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <20201202223147.3472-1-bongsu.jeon@samsung.com>
References: <20201202223147.3472-1-bongsu.jeon@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu,  3 Dec 2020 07:31:47 +0900 Bongsu Jeon wrote:
> From: Bongsu Jeon <bongsu.jeon@samsung.com>
> 
> implement the NCI 2.x initial sequence to support NCI 2.x NFCC.
> Since NCI 2.0, CORE_RESET and CORE_INIT sequence have been changed.
> If NFCEE supports NCI 2.x, then NCI 2.x initial sequence will work.
> 
> In NCI 1.0, Initial sequence and payloads are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status, NCI version, Configuration Status.
>  CORE_INIT_CMD payloads are empty.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Number of Supported RF Interfaces, Supported RF Interface,
>     Max Logical Connections, Max Routing table Size,
>     Max Control Packet Payload Size, Max Size for Large Parameters,
>     Manufacturer ID, Manufacturer Specific Information.
> 
> In NCI 2.0, Initial Sequence and Parameters are as below:
> (DH)                     (NFCC)
>  |  -- CORE_RESET_CMD --> |
>  |  <-- CORE_RESET_RSP -- |
>  |  <-- CORE_RESET_NTF -- |
>  |  -- CORE_INIT_CMD -->  |
>  |  <-- CORE_INIT_RSP --  |
>  CORE_RESET_RSP payloads are Status.
>  CORE_RESET_NTF payloads are Reset Trigger,
>     Configuration Status, NCI Version, Manufacturer ID,
>     Manufacturer Specific Information Length,
>     Manufacturer Specific Information.
>  CORE_INIT_CMD payloads are Feature1, Feature2.
>  CORE_INIT_RSP payloads are Status, NFCC Features,
>     Max Logical Connections, Max Routing Table Size,
>     Max Control Packet Payload Size,
>     Max Data Packet Payload Size of the Static HCI Connection,
>     Number of Credits of the Static HCI Connection,
>     Max NFC-V RF Frame Size, Number of Supported RF Interfaces,
>     Supported RF Interfaces.
> 
> Signed-off-by: Bongsu Jeon <bongsu.jeon@samsung.com>

Applied, thanks!
