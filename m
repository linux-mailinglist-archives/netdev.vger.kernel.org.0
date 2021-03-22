Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6B3A9343FDD
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 12:32:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230189AbhCVLcV (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 07:32:21 -0400
Received: from mx3.wp.pl ([212.77.101.10]:32657 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S230194AbhCVLbw (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Mar 2021 07:31:52 -0400
Received: (wp-smtpd smtp.wp.pl 40326 invoked from network); 22 Mar 2021 12:31:45 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1616412705; bh=BZ6MMKjc+EXZHl3nR8G7VYMCt9QRigytS90CzC28tG8=;
          h=From:To:Cc:Subject;
          b=lEJVHsw8Ty2kwv6rJ8aebmvFJa2JyKNa3ezf4+c0botrpq2x1pb76A7c9PVrc8ftV
           DbgUQm++nD3bNt3KXky9naz491XaIfte/ZjTJPVmFFPARhO4s0TTyX0Ya2F3onyn8Y
           6v2i8lUb0+6RbcnBvx8hVB0+WMPThixcB5LiCiNs=
Received: from ip4-46-39-164-204.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.204])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <arnd@kernel.org>; 22 Mar 2021 12:31:45 +0100
Date:   Mon, 22 Mar 2021 12:31:43 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Arnd Bergmann <arnd@kernel.org>
Cc:     netdev@vger.kernel.org, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Lee Jones <lee.jones@linaro.org>,
        linux-wireless@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next 3/5] iwlegacy: avoid -Wempty-body warning
Message-ID: <20210322113143.GA324121@wp.pl>
References: <20210322104343.948660-1-arnd@kernel.org>
 <20210322104343.948660-3-arnd@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210322104343.948660-3-arnd@kernel.org>
X-WP-MailID: 197c071c323c67e66ef25da19382773c
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [sSOU]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Mar 22, 2021 at 11:43:33AM +0100, Arnd Bergmann wrote:
> From: Arnd Bergmann <arnd@arndb.de>
> 
> There are a couple of warnings in this driver when building with W=1:
> 
> drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_power_set_mode':
> drivers/net/wireless/intel/iwlegacy/common.c:1195:60: error: suggest braces around empty body in an 'if' statement [-Werror=empty-body]
>  1195 |                                 il->chain_noise_data.state);
>       |                                                            ^
> drivers/net/wireless/intel/iwlegacy/common.c: In function 'il_do_scan_abort':
> drivers/net/wireless/intel/iwlegacy/common.c:1343:57: error: suggest braces around empty body in an 'else' statement [-Werror=empty-body]
> 
> Change the empty debug macros to no_printk(), which avoids the
> warnings and adds useful format string checks.
> 
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
