Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0EE824D03AE
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 17:06:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238275AbiCGQHg convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 7 Mar 2022 11:07:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41544 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231715AbiCGQHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 11:07:35 -0500
X-Greylist: delayed 472 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Mon, 07 Mar 2022 08:06:40 PST
Received: from ursule.remlab.net (vps-a2bccee9.vps.ovh.net [51.75.19.47])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 0C85993182
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 08:06:40 -0800 (PST)
Received: from ursule.remlab.net (localhost [IPv6:::1])
        by ursule.remlab.net (Postfix) with ESMTP id EC495C023E;
        Mon,  7 Mar 2022 17:58:45 +0200 (EET)
Received: from basile.remlab.net ([2001:14ba:a008:9b01:102c:2fc5:1c3e:ec7b])
        by ursule.remlab.net with ESMTPSA
        id dgWzNrUrJmJPtBIAwZXkwQ
        (envelope-from <remi@remlab.net>); Mon, 07 Mar 2022 17:58:45 +0200
From:   =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To:     netdev@vger.kernel.org,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Remi Denis-Courmont <courmisch@gmail.com>
Subject: Re: [PATCH net-next 07/10] phonet: Use netif_rx().
Date:   Mon, 07 Mar 2022 17:58:45 +0200
Message-ID: <2619197.mvXUDI8C0e@basile.remlab.net>
Organization: Remlab
In-Reply-To: <20220306215753.3156276-8-bigeasy@linutronix.de>
References: <20220306215753.3156276-1-bigeasy@linutronix.de> <20220306215753.3156276-8-bigeasy@linutronix.de>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le sunnuntaina 6. maaliskuuta 2022, 23.57.50 EET Sebastian Andrzej Siewior a 
écrit :
> Since commit
>    baebdf48c3600 ("net: dev: Makes sure netif_rx() can be invoked in any
> context.")
> 
> the function netif_rx() can be used in preemptible/thread context as
> well as in interrupt context.
> 
> Use netif_rx().
> 
> Cc: Remi Denis-Courmont <courmisch@gmail.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>

Acked-by: Rémi Denis-Courmont <courmisch@gmail.com>

-- 
Rémi Denis-Courmont
http://www.remlab.net/



