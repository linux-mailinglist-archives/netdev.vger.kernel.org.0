Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 9B8997352B
	for <lists+netdev@lfdr.de>; Wed, 24 Jul 2019 19:23:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728666AbfGXRX3 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jul 2019 13:23:29 -0400
Received: from mx3.wp.pl ([212.77.101.9]:55270 "EHLO mx3.wp.pl"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728590AbfGXRX0 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 24 Jul 2019 13:23:26 -0400
Received: (wp-smtpd smtp.wp.pl 30481 invoked from network); 24 Jul 2019 19:16:43 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=wp.pl; s=1024a;
          t=1563988604; bh=z41DzGtUFzaWWcpQAVjI+8rAtK/VXbLYrGHn+dMjo3I=;
          h=From:To:Cc:Subject;
          b=YeeC3awkT/FVcvjk+fURFqdyv0r3NGECJaqSruBjt2MEMxHyXyddFZaA64nkaxrka
           0lLpbm0O7VZrCjgigBSnZ19v6fCSXRbOMwIZThg3hxH5pulTydVwW1xI4EtrctTXRp
           wUor382uyQhCqpSoEE8V8sOX195Tb9e+kJQh7ApQ=
Received: from 014.152-60-66-biz-static.surewest.net (HELO cakuba.netronome.com) (kubakici@wp.pl@[66.60.152.14])
          (envelope-sender <kubakici@wp.pl>)
          by smtp.wp.pl (WP-SMTPD) with ECDHE-RSA-AES256-GCM-SHA384 encrypted SMTP
          for <navid.emamdoost@gmail.com>; 24 Jul 2019 19:16:43 +0200
Date:   Wed, 24 Jul 2019 10:16:36 -0700
From:   Jakub Kicinski <kubakici@wp.pl>
To:     Navid Emamdoost <navid.emamdoost@gmail.com>
Cc:     kvalo@codeaurora.org, emamd001@umn.edu, kjlu@umn.edu,
        smccaman@umn.edu, secalert@redhat.com,
        "David S. Miller" <davem@davemloft.net>,
        Matthias Brugger <matthias.bgg@gmail.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org,
        linux-mediatek@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mt7601u: null check the allocation
Message-ID: <20190724101636.4699c30a@cakuba.netronome.com>
In-Reply-To: <20190724141736.29994-1-navid.emamdoost@gmail.com>
References: <87d0i00z4t.fsf@kamboji.qca.qualcomm.com>
        <20190724141736.29994-1-navid.emamdoost@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-WP-MailID: fe13a5d9e194338bda75b16965620f67
X-WP-AV: skaner antywirusowy Poczty Wirtualnej Polski
X-WP-SPAM: NO 000000A [QTPk]                               
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 24 Jul 2019 09:17:36 -0500, Navid Emamdoost wrote:
> devm_kzalloc may fail and return NULL. So the null check is needed.
> 
> Signed-off-by: Navid Emamdoost <navid.emamdoost@gmail.com>

Ah, I replied to the wrong one..

Acked-by: Jakub Kicinski <kubakici@wp.pl>
