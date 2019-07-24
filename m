Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 236E6735B5
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:42:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2387740AbfGXRmG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:42:06 -0400
Received: from mx4.wp.pl ([212.77.101.12]:15902 "EHLO mx4.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2387616AbfGXRmF (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 13:42:05 -0400
X-Greylist: delayed 1598 seconds by postgrey-1.27 at vger.kernel.org; Wed, 24 Jul 2019 13:42:04 EDT
Received: (wp-smtpd smtp.wp.pl 7512 invoked from network); 24 Jul 2019 19:15:23 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1563988524; bh=gEkDwIuDO2Mlt47g7fHTqzHcSxdtZTDr5XQG+4+AvdU=;
          h=From:To:Cc:Subject;
          b=ntAPjIlLwGvOxgC2v+xm/bV3mQvMUDMExK5e9IszAZdswFVOM1CMFo9sCJ1pKqGLF
           kpQZCuccigvIcEx+x1AdexCezOy9xB+tz6O3Y7xqR2h9mmc1Ypn5frAT1xfDiD+D4g
           91q1Fzzc/O8xKBgRvC2r2763CVpjRIG6Mu7bIfb0=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <navid.emamdoost@gmail.com>; 24 Jul 2019 19:15:23 +0200
Date:   Wed, 24 Jul 2019 10:15:14 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     emamd001@umn.edu, kjlu@umn.edu, smccaman@umn.edu,
        secalert@redhat.com, Kalle Valo <kvalo@codeaurora.org>,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt76_init_sband_2g: null check the allocation
Message-ID: <20190724101514.29efc10a@cakuba.netronome.com>
In-Reply-To: <20190723221954.9233-1-navid.emamdoost@gmail.com>
References: <20190723221954.9233-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: 3fa229c2b67e2a6425aaa1fc737c8941
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [EYOU]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jul 2019 17:19:54 -0500, Navid Emamdoost wrote:
> devm_kzalloc may fail and return NULL. So the null check is needed.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Acked-by: Jakub Kicinski <kubakici@wp.pl>

Thanks!
