Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3178214FA3A
	for <lists+netdev@lfdr.de>; Sat,  1 Feb 2020 20:30:29 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726514AbgBATaY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 1 Feb 2020 14:30:24 -0500
Received: from mail.kernel.org ([198.145.29.99]:50068 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726270AbgBATaX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 1 Feb 2020 14:30:23 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id F3D0B20723;
        Sat,  1 Feb 2020 19:30:22 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580585423;
        bh=nu/AJbl37PympHlny43SrRpga+1Uh5lijiXfR2VivmI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=2ajHIZ1ZWnLdPlIgya3iRwr+SvQIC8DDhgTTI+wdFVt+nIXm3QBsgPLTxCAymNaPZ
         jCsJj0g1qdmmXuKGjbFIK5PwQmdVRJak64SabqHdJVqWPaOYGUvhopcomp+I2kRzvF
         ZWCryZd6hy8mls1VwWjaE4uh0dbk3p+89w7Tf5TA=
Date:   Sat, 1 Feb 2020 11:30:22 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Harini Katakam <harini.katakam@xilinx.com>
Cc:     nicolas.ferre@microchip.com, davem@davemloft.net,
        claudiu.beznea@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, michal.simek@xilinx.com,
        harinikatakamlinux@gmail.com
Subject: Re: [PATCH 0/2] TSO bug fixes
Message-ID: <20200201113022.47424f55@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
References: <1580466455-27288-1-git-send-email-harini.katakam@xilinx.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 31 Jan 2020 15:57:33 +0530, Harini Katakam wrote:
> orkaround the same by limiting this size to 0x3FC0 as recommended by
> Cadence. There was no performance impact on 1G system that I tested
> with.
> 
> Note on patch 1: The alignment code may be unused but leaving it there
> in case anyone is using UFO.

Hi Harini! Please provide Fixes tags when you post v2, thanks!
