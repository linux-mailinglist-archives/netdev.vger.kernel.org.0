Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (unknown [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A2F5B1A62E8
	for <lists+netdev@lfdr.de>; Mon, 13 Apr 2020 08:06:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728255AbgDMGFv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 Apr 2020 02:05:51 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.18]:46922 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726967AbgDMGFv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 13 Apr 2020 02:05:51 -0400
Received: from shells.gnugeneration.com (shells.gnugeneration.com [66.240.222.126])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id D261FC0A3BE0;
        Sun, 12 Apr 2020 23:05:50 -0700 (PDT)
Received: by shells.gnugeneration.com (Postfix, from userid 1000)
        id 967BE1A402DF; Sun, 12 Apr 2020 23:05:50 -0700 (PDT)
Date:   Sun, 12 Apr 2020 23:05:50 -0700
From:   Vito Caputo <vcaputo@pengaru.com>
To:     =?utf-8?B?UsOpbWk=?= Denis-Courmont <remi@remlab.net>
Cc:     netdev@vger.kernel.org, courmisch@gmail.com, davem@davemloft.net,
        kuba@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: kernel BUG at net/phonet/socket.c:LINE!
Message-ID: <20200413060550.347r47zp7kmn4vkh@shells.gnugeneration.com>
References: <00000000000062b41d05a2ea82b0@google.com>
 <1806223.auBmcZeozp@basile.remlab.net>
 <20200413054914.euz7g2fcxsr74lfm@shells.gnugeneration.com>
 <2585533.60Y2ixrnJE@basile.remlab.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <2585533.60Y2ixrnJE@basile.remlab.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 13, 2020 at 09:01:58AM +0300, Rémi Denis-Courmont wrote:
> Le maanantaina 13. huhtikuuta 2020, 8.49.14 EEST Vito Caputo a écrit :
> > > If we are to distinguish the two error scenarii, then it's the rebind 
> > > case
> > > that needs a different error, but EINVAL is consistent with INET.
> > 
> > Isn't the existing code is bugged if treating -EINVAL as valid and a rebind?
> > 
> > The invalid size will return a NULL sobject but -EINVAL, triggering the
> > BUG_ON.
> 
> How do you pass an invalid size? It's a constant `sizeof(struct sockaddr_pn)` 
> in that code path.
> 

duh, sorry for the noise, I should have re-read the code before replying.
