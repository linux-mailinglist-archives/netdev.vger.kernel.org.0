Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8EA2EEA1AC
	for <lists+netdev@lfdr.de>; Wed, 30 Oct 2019 17:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727403AbfJ3QW7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 30 Oct 2019 12:22:59 -0400
Received: from mx3.wp.pl ([212.77.101.9]:45454 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726900AbfJ3QW7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 30 Oct 2019 12:22:59 -0400
Received: (wp-smtpd smtp.wp.pl 6876 invoked from network); 30 Oct 2019 17:22:51 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1572452572; bh=Rb/x1ONrPA2ACBm+71NRPr1xqWmnxoQN+Bjddk5BR4E=;
          h=From:To:Cc:Subject;
          b=HFmIA9qjcUbLBKRyEtajpXt3QdAAQ4PaGDkIzZ5aMmGzhSGgios49tM3C/aYGasVr
           c88/nywPwI+seB1W4IWNImxredaFgrOhKC+Vfnb5YgcyoTHge9DEaZSYQHW40OgMvc
           NeWmuymwrxKNhNvmoY+A04GqfikMki2EX5E9aIyA=
Received: from c-73-202-202-92.hsd1.ca.comcast.net (HELO cakuba.hsd1.ca.comcast.net) (kubakici@wp.pl@[73.202.202.92])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <zhongjiang@huawei.com>; 30 Oct 2019 17:22:51 +0100
Date:   Wed, 30 Oct 2019 09:22:47 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     zhong jiang <zhongjiang@huawei.com>
Cc:     <kvalo@codeaurora.org>, <davem@davemloft.net>,
        <matthias.bgg@gmail.com>, <linux-wireless@vger.kernel.org>,
        <netdev@vger.kernel.org>
Subject: Re: [PATCH] mt7601u: use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs
 fops
Message-ID: <20191030092247.71e24bfe@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
References: <1572422924-58878-1-git-send-email-zhongjiang@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: b6401afc017796d6907f1950e05fd291
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [8XNk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 30 Oct 2019 16:08:44 +0800, zhong jiang wrote:
> It is more clear to use DEFINE_DEBUGFS_ATTRIBUTE to define debugfs file
> operation rather than DEFINE_SIMPLE_ATTRIBUTE.
> 
> Signed-off-by: zhong jiang <zhongjiang@huawei.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>
