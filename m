Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3A2096F04E
	for <lists+netdev@lfdr.de>; Sat, 20 Jul 2019 20:17:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726901AbfGTSQj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Jul 2019 14:16:39 -0400
Received: from albireo.enyo.de ([5.158.152.32]:37214 "EHLO albireo.enyo.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726594AbfGTSQj (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 20 Jul 2019 14:16:39 -0400
X-Greylist: delayed 362 seconds by postgrey-1.27 at vger.kernel.org; Sat, 20 Jul 2019 14:16:37 EDT
Received: from [172.17.203.2] (helo=deneb.enyo.de)
        by albireo.enyo.de with esmtps (TLS1.2:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1hotoT-0005X9-Ta; Sat, 20 Jul 2019 18:10:29 +0000
Received: from fw by deneb.enyo.de with local (Exim 4.92)
        (envelope-from <fw@deneb.enyo.de>)
        id 1hotoQ-0003IG-OG; Sat, 20 Jul 2019 20:10:26 +0200
From:   Florian Weimer <fw@deneb.enyo.de>
To:     Sergei Trofimovich <slyfox@gentoo.org>
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        libc-alpha@sourceware.org, Arnd Bergmann <arnd@arndb.de>,
        "David S. Miller" <davem@davemloft.net>, mtk.manpages@gmail.com,
        linux-man@vger.kernel.org
Subject: Re: linux-headers-5.2 and proper use of SIOCGSTAMP
References: <20190720174844.4b989d34@sf>
Date:   Sat, 20 Jul 2019 20:10:26 +0200
In-Reply-To: <20190720174844.4b989d34@sf> (Sergei Trofimovich's message of
        "Sat, 20 Jul 2019 17:48:44 +0100")
Message-ID: <87wogca86l.fsf@mid.deneb.enyo.de>
MIME-Version: 1.0
Content-Type: text/plain
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

* Sergei Trofimovich:

> Should #include <linux/sockios.h> always be included by user app?
> Or should glibc tweak it's definition of '#include <sys/socket.h>'
> to make it available on both old and new version of linux headers?

What is the reason for dropping SIOCGSTAMP from <asm/socket.h>?

If we know that, it will be much easier to decide what to do about
<sys/socket.h>.
