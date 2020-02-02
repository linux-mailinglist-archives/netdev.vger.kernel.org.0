Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DB4DC14FF25
	for <lists+netdev@lfdr.de>; Sun,  2 Feb 2020 21:43:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727072AbgBBUnI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Feb 2020 15:43:08 -0500
Received: from mail.kernel.org ([198.145.29.99]:59872 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726921AbgBBUnH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 2 Feb 2020 15:43:07 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-73-93-4-247.hsd1.ca.comcast.net [73.93.4.247])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id EAAC52067C;
        Sun,  2 Feb 2020 20:43:06 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1580676187;
        bh=Ch4njxdszvV1cbIifCfhuw/kD7hywsLYY/EAHrIrfqs=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=VwLF0qg1SF/xAqRz22Tu1hP+J14iKyikROmY2jb42K6ILlBO2QKHTgwzmk6oBq0ZB
         OVJ0WMl/BsZ+YXrUBhxDyYiuuIu8zpAXYdARYyJymEvp6uQGoaIQrdepE9rQdJyQp/
         J+NRJNxJ7ZQckfh5xCLbi7dk+8vNshwR1lY7t5hw=
Date:   Sun, 2 Feb 2020 12:43:06 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Lukas Bulwahn <lukas.bulwahn@gmail.com>
Cc:     Karsten Keil <isdn@linux-pingi.de>, Arnd Bergmann <arnd@arndb.de>,
        isdn4linux@listserv.isdn4linux.de, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] MAINTAINERS: correct entries for ISDN/mISDN section
Message-ID: <20200202124306.54bcabea@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
References: <20200201124301.21148-1-lukas.bulwahn@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat,  1 Feb 2020 13:43:01 +0100, Lukas Bulwahn wrote:
> Commit 6d97985072dc ("isdn: move capi drivers to staging") cleaned up the
> isdn drivers and split the MAINTAINERS section for ISDN, but missed to add
> the terminal slash for the two directories mISDN and hardware. Hence, all
> files in those directories were not part of the new ISDN/mISDN SUBSYSTEM,
> but were considered to be part of "THE REST".
> 
> Rectify the situation, and while at it, also complete the section with two
> further build files that belong to that subsystem.
> 
> This was identified with a small script that finds all files belonging to
> "THE REST" according to the current MAINTAINERS file, and I investigated
> upon its output.
> 
> Fixes: 6d97985072dc ("isdn: move capi drivers to staging")
> Signed-off-by: Lukas Bulwahn <lukas.bulwahn@gmail.com>

Applied to net, thanks!
