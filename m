Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 97DBA2B8431
	for <lists+netdev@lfdr.de>; Wed, 18 Nov 2020 19:53:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726780AbgKRSwx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Nov 2020 13:52:53 -0500
Received: from mail.kernel.org ([198.145.29.99]:57294 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726761AbgKRSwx (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 18 Nov 2020 13:52:53 -0500
Received: from kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net (unknown [163.114.132.5])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 3E75D2064B;
        Wed, 18 Nov 2020 18:52:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605725572;
        bh=m95j+MMbl8dIKdGyA+uhKh147WdWtosEWCwUGFbYbWo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=yY4aSBHLNnQDYXbc94PtzuDgUUs11CFtlBlTY+mSxb2B0r4jKgDThuFWfniaAhMi8
         WGnyGHgWLENSJygCyaV/lePAsG3pfEOnqbBoIAfVj0bgN0iCkzq5qy6yluIMHd0M+Q
         tSrIMJqgYqeMtXxIxIrSkgWjK7rHl+lYo87iOXlI=
Date:   Wed, 18 Nov 2020 10:52:51 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     "Ruslan V. Sushko" <rus@sushko.dev>, netdev@vger.kernel.org
Subject: Re: [PATCH] net: dsa: mv88e6xxx: Wait for EEPROM done after HW
 reset
Message-ID: <20201118105251.0f3c9ac8@kicinski-fedora-PC1C0HJN.hsd1.ca.comcast.net>
In-Reply-To: <20201116164301.977661-1-rus@sushko.dev>
References: <20201116164301.977661-1-rus@sushko.dev>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Nov 2020 08:43:01 -0800 Ruslan V. Sushko wrote:
> From: Andrew Lunn <andrew@lunn.ch>
> 
> When the switch is hardware reset, it reads the contents of the
> EEPROM. This can contain instructions for programming values into
> registers and to perform waits between such programming. Reading the
> EEPROM can take longer than the 100ms mv88e6xxx_hardware_reset() waits
> after deasserting the reset GPIO. So poll the EEPROM done bit to
> ensure it is complete.
> 
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> Signed-off-by: Ruslan Sushko <rus@sushko.dev>

Andrew, do we need this in net?
