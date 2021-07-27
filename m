Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CBC683D7AA2
	for <lists+netdev@lfdr.de>; Tue, 27 Jul 2021 18:12:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229692AbhG0QMc convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Tue, 27 Jul 2021 12:12:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229630AbhG0QMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 27 Jul 2021 12:12:30 -0400
X-Greylist: delayed 534 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 27 Jul 2021 09:12:29 PDT
Received: from ursule.remlab.net (vps-a2bccee9.vps.ovh.net [IPv6:2001:41d0:305:2100::8a0c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id ADA96C061757
        for <netdev@vger.kernel.org>; Tue, 27 Jul 2021 09:12:29 -0700 (PDT)
Received: from ursule.remlab.net (localhost [IPv6:::1])
        by ursule.remlab.net (Postfix) with ESMTP id 50E7AC0241;
        Tue, 27 Jul 2021 19:03:33 +0300 (EEST)
Received: from basile.remlab.net ([2001:14ba:a01a:be01:9434:f69e:d553:3be2])
        by ursule.remlab.net with ESMTPSA
        id sRsREVUuAGFWcAAAwZXkwQ
        (envelope-from <remi@remlab.net>); Tue, 27 Jul 2021 19:03:33 +0300
From:   =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To:     netdev@vger.kernel.org, Arnd Bergmann <arnd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, Jakub Kicinski <kuba@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Arnd Bergmann <arnd@arndb.de>,
        Remi Denis-Courmont <courmisch@gmail.com>
Subject: Re: [PATCH net-next v3 06/31] phonet: use siocdevprivate
Date:   Tue, 27 Jul 2021 19:03:32 +0300
Message-ID: <1745398.PdPXp2ZHHY@basile.remlab.net>
Organization: Remlab
In-Reply-To: <20210727134517.1384504-7-arnd@kernel.org>
References: <20210727134517.1384504-1-arnd@kernel.org> <20210727134517.1384504-7-arnd@kernel.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le tiistaina 27. heinäkuuta 2021, 16.44.52 EEST Arnd Bergmann a écrit :
> From: Arnd Bergmann <arnd@arndb.de>
> 
> phonet has a single private ioctl that is broken in compat
> mode on big-endian machines today because the data returned
> from it is never copied back to user space.
> 
> Move it over to the ndo_siocdevprivate callback, which also
> fixes the compat issue.
> 
> Cc: Remi Denis-Courmont <courmisch@gmail.com>
> Signed-off-by: Arnd Bergmann <arnd@arndb.de>

Acked-by: Rémi Denis-Courmont <courmisch@gmail.com>

-- 
This made me realise that the HSI/SSI device driver lacks the private IOCTL 
(but that's obivously not a problem of this series).

-- 
Rémi Denis-Courmont
http://www.remlab.net/



