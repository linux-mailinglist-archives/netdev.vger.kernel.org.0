Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 518BD30EF77
	for <lists+netdev@lfdr.de>; Thu,  4 Feb 2021 10:18:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234765AbhBDJR7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 4 Feb 2021 04:17:59 -0500
Received: from mx3.wp.pl ([212.77.101.10]:28961 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S235203AbhBDJO6 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 4 Feb 2021 04:14:58 -0500
Received: (wp-smtpd smtp.wp.pl 17215 invoked from network); 4 Feb 2021 10:14:04 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1612430044; bh=dXyM1tiDTBaOMaxbN/xXSQ8MKB+qXFyMO23iFtqxKK8=;
          h=From:To:Cc:Subject;
          b=qBgN3AKB3AxrCIiPZzpAe/UPp4tgk+81I3c0DNXU0mZ/7OQVcZd85zyD8aICCzEoA
           q/3YEwXL2Mt5vo6wz1CyAHZ6Zid0W/+y2hKMizsPhKXuFuFVyKDeK8vNI0S0O6Jg43
           7dWwjREBuC5sDkIYJyPINgW8g6ziuUS+XkEUcwSE=
Received: from ip4-46-39-164-203.cust.nbox.cz (HELO localhost) (stf_xl@wp.pl@[46.39.164.203])
          (envelope-sender <stf_xl@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jiapeng.chong@linux.alibaba.com>; 4 Feb 2021 10:14:04 +0100
Date:   Thu, 4 Feb 2021 10:14:03 +0100
From:   Stanislaw Gruszka <stf_xl@wp.pl>
To:     Jiapeng Chong <jiapeng.chong@linux.alibaba.com>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, kuba@kernel.org,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] iwlegacy: 4965-mac: Simplify the calculation of variables
Message-ID: <20210204091403.GA189022@wp.pl>
References: <1612425608-40450-1-git-send-email-jiapeng.chong@linux.alibaba.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1612425608-40450-1-git-send-email-jiapeng.chong@linux.alibaba.com>
X-WP-MailID: ac201b005bf07a06ef65f9ac6fd1eb06
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000000 [gVO0]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 04, 2021 at 04:00:08PM +0800, Jiapeng Chong wrote:
> Fix the following coccicheck warnings:
> 
> ./drivers/net/wireless/intel/iwlegacy/4965-mac.c:2596:54-56: WARNING !A
> || A && B is equivalent to !A || B.
> 
> Reported-by: Abaci Robot <abaci@linux.alibaba.com>
> Signed-off-by: Jiapeng Chong <jiapeng.chong@linux.alibaba.com>

Acked-by: Stanislaw Gruszka <stf_xl@wp.pl>
