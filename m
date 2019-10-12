Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 68675D5158
	for <lists+netdev@lfdr.de>; Sat, 12 Oct 2019 19:21:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729573AbfJLRVC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 12 Oct 2019 13:21:02 -0400
Received: from smtp.duncanthrax.net ([89.31.1.170]:38196 "EHLO
        smtp.duncanthrax.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728162AbfJLRVB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 12 Oct 2019 13:21:01 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=duncanthrax.net; s=dkim; h=In-Reply-To:Content-Transfer-Encoding:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date;
        bh=UfXVJgl3M8MWL2edg+efyKWcd9i2rDggtEJ51Z/1Twk=; b=Ij1zwyaCJv1sYuxWEE3Y2FUydB
        4qKitFdByEvV7QDkepdQjEC0uyDSZvE4zVcQSz45WSG+nqqKWp4jY909Rm3p462/pPjveAKMFMcpH
        u5CrJrvchwNrs3yv/239if5jgtqrtwO4M1duiTeGC8xwcivvHc/UFV2FvMyrWpCmxhGY=;
Received: from hsi-kbw-046-005-233-221.hsi8.kabel-badenwuerttemberg.de ([46.5.233.221] helo=t470p.stackframe.org)
        by smtp.eurescom.eu with esmtpsa (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        (Exim 4.86_2)
        (envelope-from <svens@stackframe.org>)
        id 1iJL4b-000115-5q; Sat, 12 Oct 2019 19:20:57 +0200
Date:   Sat, 12 Oct 2019 19:20:55 +0200
From:   Sven Schnelle <svens@stackframe.org>
To:     Markus Elfring <Markus.Elfring@web.de>
Cc:     netdev@vger.kernel.org, linux-parisc@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Yang Wei <yang.wei9@zte.com.cn>,
        LKML <linux-kernel@vger.kernel.org>,
        kernel-janitors@vger.kernel.org, Aditya Pakki <pakki001@umn.edu>,
        Kangjie Lu <kjlu@umn.edu>, Navid Emamdoost <emamd001@umn.edu>,
        Stephen McCamant <smccaman@umn.edu>
Subject: Re: net: tulip: de2104x: Checking a kmemdup() call in
 de21041_get_srom_info()
Message-ID: <20191012172055.GA22569@t470p.stackframe.org>
References: <eb1f904a-a2e4-fe9b-c50e-b8087d7e57c4@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <eb1f904a-a2e4-fe9b-c50e-b8087d7e57c4@web.de>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Oct 12, 2019 at 07:03:09PM +0200, Markus Elfring wrote:
> Hello,
> 
> I tried another script for the semantic patch language out.
> This source code analysis approach points out that the implementation
> of the function “de21041_get_srom_info” contains still an unchecked call
> of the function “kmemdup”.
> https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/tree/drivers/net/ethernet/dec/tulip/de2104x.c?id=1c0cc5f1ae5ee5a6913704c0d75a6e99604ee30a#n1940
> https://elixir.bootlin.com/linux/v5.4-rc2/source/drivers/net/ethernet/dec/tulip/de2104x.c#L1940
> 
> How do you think about to improve it?

If i have not missed a place, the only user is de_get_eeprom(), which checks
whether de->ee_data is valid. So i think although not obvious, there's no
problem here.

Regards
Sven
