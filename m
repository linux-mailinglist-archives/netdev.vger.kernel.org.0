Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 22AF713884B
	for <lists+netdev@lfdr.de>; Sun, 12 Jan 2020 21:57:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387444AbgALU5u (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 12 Jan 2020 15:57:50 -0500
Received: from mx4.wp.pl ([212.77.101.11]:36387 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1732825AbgALU5t (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 12 Jan 2020 15:57:49 -0500
Received: (wp-smtpd smtp.wp.pl 22674 invoked from network); 12 Jan 2020 21:51:07 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1578862267; bh=wnOlW/DorOR4Bf5sWNcnPeW7sAgVqqwEX2j77RKwTBU=;
          h=From:To:Cc:Subject;
          b=D3ySF0vE7HIJpjtcvNKU5cIXoRZ1RKOtsGJ2FKC9FQJuvukGWekewvwUTfuGZ42kf
           DurFa7tbK2rv4dnC8FpwYZAAnvtqfuHefMFGe80dFhSabN0aejPGuzkg39IJ+0feAK
           SMZcU4zbpGyXiU51HcCdySQz2wWfD2RFkWeTWot4=
Received: from c-73-93-4-247.hsd1.ca.comcast.net (HELO cakuba) (kubakici@wp.pl@[73.93.4.247])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <jonathan.lemon@gmail.com>; 12 Jan 2020 21:51:07 +0100
Date:   Sun, 12 Jan 2020 12:50:55 -0800
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Jonathan Lemon <jonathan.lemon@gmail.com>
Cc:     <netdev@vger.kernel.org>, <tariqt@mellanox.com>,
        <davem@davemloft.net>, <kernel-team@fb.com>,
        Jack Wang <jinpu.wang@cloud.ionos.com>
Subject: Re: [PATCH net-next] mlx4: Bump up MAX_MSIX from 64 to 128
Message-ID: <20200112125055.512b65f6@cakuba>
In-Reply-To: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
References: <20200109192317.4045173-1-jonathan.lemon@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: e716d9d303bc02983fdddcfcb4cc0d77
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [gUPk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 9 Jan 2020 11:23:17 -0800, Jonathan Lemon wrote:
> On modern hardware with a large number of cpus and using XDP,
> the current MSIX limit is insufficient.  Bump the limit in
> order to allow more queues.
> 
> Signed-off-by: Jonathan Lemon <jonathan.lemon@gmail.com>

Applied to net-next, thanks everyone!

(Jack, please make sure you spell your tags right)
