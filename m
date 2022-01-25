Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AFA4649BAEF
	for <lists+netdev@lfdr.de>; Tue, 25 Jan 2022 19:06:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1388338AbiAYSEz (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 25 Jan 2022 13:04:55 -0500
Received: from ams.source.kernel.org ([145.40.68.75]:34208 "EHLO
        ams.source.kernel.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1387978AbiAYSDh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 25 Jan 2022 13:03:37 -0500
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id EA6BEB817EF
        for <netdev@vger.kernel.org>; Tue, 25 Jan 2022 18:03:35 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 756A1C340E0;
        Tue, 25 Jan 2022 18:03:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1643133814;
        bh=ztQatopzBcrDNgqSmbXixT+nvnwQrpH36UxPH3sKo7I=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TNiHeaK3bZl4isx0SQx9pD/tGFoC271khbFtXzHLyeFqKTTPU92+EblsmdQsEhkgU
         VxZOkZbl6z8lfDKq6xLSXXdex4VW2bdu8wn7IuVmoMh01+/FhdjbYbzklswDSJP2H9
         hPcjZzeGr9jrb/hhKaBp4s52olqjKdl5oMowUScppZWDq3udnXgiIW4ZiLi/UhQ6qN
         BmY2DmkemueZh/mhW8KCrkIfnfC8dfxs+xJ5PS7qf42D37KrDEvwumACSeqo0zvadH
         MODhV7/tVycqcpRoHAmTRkF5WNSmQed86+59BROxgnVKOtbaWsBhZ0J24aGZZwXHYR
         MMfoIGmXSP6pw==
Date:   Tue, 25 Jan 2022 10:03:33 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shannon Nelson <snelson@pensando.io>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, drivers@pensando.io
Subject: Re: [PATCH net 00/16] ionic: updates for stable FW recovery
Message-ID: <20220125100333.4e5580a7@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20220124185312.72646-1-snelson@pensando.io>
References: <20220124185312.72646-1-snelson@pensando.io>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Jan 2022 10:52:56 -0800 Shannon Nelson wrote:
> Recent FW work has tightened up timings in its error recovery
> handling and uncovered weaknesses in the driver's responses,
> so this is a set of updates primarily for better handling of
> the firmware's recovery mechanisms.

Applied, thanks, 8a0de61c40af ("Merge branch 'ionic-fw-recovery'")
in net-next.
