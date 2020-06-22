Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2C3ED204377
	for <lists+netdev@lfdr.de>; Tue, 23 Jun 2020 00:20:32 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730932AbgFVWU3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jun 2020 18:20:29 -0400
Received: from mail.kernel.org ([198.145.29.99]:55148 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730840AbgFVWU1 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jun 2020 18:20:27 -0400
Received: from kicinski-fedora-PC1C0HJN (unknown [163.114.132.1])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id E843220656;
        Mon, 22 Jun 2020 22:20:26 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1592864427;
        bh=1NRes6tqWPpRjkmuZsoVJZPBDDPOsrGS/yAgki5tKpI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=E75PiAxo4ZTX0v0m4UaHrdrI4r0XnavqVm9f/cznUFFPsT0cHKcPgcfy8NA9OejwM
         +jq0wbkmm5TlHWOnRduI9aJXIWDp+E+FsjuTRS5qHlHxBcGoN2nd8FS1Va43HI0oQS
         j1nJKHOLzRXURFvpaHWjszObknd29RUwBg6LxLek=
Date:   Mon, 22 Jun 2020 15:20:25 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Vladimir Oltean <olteanv@gmail.com>
Cc:     davem@davemloft.net, netdev@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, vivien.didelot@gmail.com
Subject: Re: [PATCH net-next 0/3] Cosmetic cleanup in SJA1105 DSA driver
Message-ID: <20200622152025.5e0c88e1@kicinski-fedora-PC1C0HJN>
In-Reply-To: <20200620171832.3679837-1-olteanv@gmail.com>
References: <20200620171832.3679837-1-olteanv@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 20 Jun 2020 20:18:29 +0300 Vladimir Oltean wrote:
> From: Vladimir Oltean <vladimir.oltean@nxp.com>
> 
> This removes the sparse warnings from the sja1105 driver and makes some
> structures constant.

Errors and warnings before: 526 this patch: 0 

Whoop!
