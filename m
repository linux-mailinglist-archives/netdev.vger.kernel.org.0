Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DEDE01A62EB
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:08:26 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726292AbgDMGIX convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Mon, 13 Apr 2020 02:08:23 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:47344 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725842AbgDMGIX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:08:23 -0400
X-Greylist: delayed 381 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Sun, 12 Apr 2020 23:08:22 PDT
Received: from ns207790.ip-94-23-215.eu (poy.remlab.net [IPv6:2001:41d0:2:5a1a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D3089C0A3BE0
        for <netdev@vger.kernel.org>; Sun, 12 Apr 2020 23:08:22 -0700 (PDT)
Received: from basile.remlab.net (87-92-31-51.bb.dnainternet.fi [87.92.31.51])
        (Authenticated sender: remi)
        by ns207790.ip-94-23-215.eu (Postfix) with ESMTPSA id A829D5FC58;
        Mon, 13 Apr 2020 08:01:59 +0200 (CEST)
From:   =?ISO-8859-1?Q?R=E9mi?= Denis-Courmont <remi@remlab.net>
To:     Vito Caputo <vcaputo@pengaru.com>
Cc:     netdev@vger.kernel.org, courmisch@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/phonet/socket.c:LINE!
Date:   Mon, 13 Apr 2020 09:01:58 +0300
Message-ID: <2585533.60Y2ixrnJE@basile.remlab.net>
Organization: Remlab
In-Reply-To: <20200413054914.euz7g2fcxsr74lfm@shells.gnugeneration.com>
References: <00000000000062b41d05a2ea82b0@google.com> <1806223.auBmcZeozp@basile.remlab.net> <20200413054914.euz7g2fcxsr74lfm@shells.gnugeneration.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Le maanantaina 13. huhtikuuta 2020, 8.49.14 EEST Vito Caputo a écrit :
> > If we are to distinguish the two error scenarii, then it's the rebind 
> > case
> > that needs a different error, but EINVAL is consistent with INET.
> 
> Isn't the existing code is bugged if treating -EINVAL as valid and a rebind?
> 
> The invalid size will return a NULL sobject but -EINVAL, triggering the
> BUG_ON.

How do you pass an invalid size? It's a constant `sizeof(struct sockaddr_pn)` 
in that code path.

-- 
Rémi Denis-Courmont
Tapiolan uusi kaupunki, Uudenmaan tasavalta



