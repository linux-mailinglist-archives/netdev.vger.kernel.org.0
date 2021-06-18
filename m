Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 36C393AD3CC
	for <lists+netdev@lfdr.de>; Fri, 18 Jun 2021 22:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234033AbhFRUpG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Jun 2021 16:45:06 -0400
Received: from mx4.wp.pl ([212.77.101.12]:26044 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S233972AbhFRUpB (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Jun 2021 16:45:01 -0400
Received: (wp-smtpd smtp.wp.pl 1651 invoked from network); 18 Jun 2021 22:36:06 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1624048566; bh=+T2bcNC2sHv5Q9iE59Xr1PSmlQKpTEY5+sa+qobzycw=;
          h=From:To:Cc:Subject;
          b=iTOJJf9fUeROTjRNWRZ3n2W1HNDuKCswwPfIsbedBObs/qoFDNXFdejAdoli5mfo2
           f9yQ/O201owv5rCglHhXy2sEcXFr3QGezP+/PqKq9vPzGtsuxDf6/+QX3+p1uZdS19
           TPqBDN6kI21sqYGxaeU9UtthBJXkSVStcwzmXwIU=
Received: from unknown (HELO kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com) (kubakici@wp.pl@[163.114.132.3])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <whistler@member.fsf.org>; 18 Jun 2021 22:36:06 +0200
Date:   Fri, 18 Jun 2021 13:35:54 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Wei Mingzhi <whistler@member.fsf.org>
Cc:     kvalo@codeaurora.org, davem@davemloft.net, matthias.bgg@gmail.com,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: add USB device ID for some versions of XiaoDu
 WiFi Dongle.
Message-ID: <20210618133554.7d5c8e3d@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20210618160840.305024-1-whistler@member.fsf.org>
References: <20210618160840.305024-1-whistler@member.fsf.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 056658d67fe8a0af829ae53f4852c704
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 0000001 [8UKz]                               
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, 19 Jun 2021 00:08:40 +0800 Wei Mingzhi wrote:
> USB device ID of some versions of XiaoDu WiFi Dongle is 2955:1003
> instead of 2955:1001. Both are the same mt7601u hardware.
> 
> Signed-off-by: Wei Mingzhi <whistler@member.fsf.org>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
