Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4F3711D044A
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:20:59 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732035AbgEMBUw (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:20:52 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:48866 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731604AbgEMBUv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:20:51 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id F311729CEA;
        Tue, 12 May 2020 21:14:48 -0400 (EDT)
Date:   Wed, 13 May 2020 11:14:56 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Markus Elfring <Markus.Elfring@web.de>
cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: Re: net/sonic: Fix some resource leaks in error handling paths
In-Reply-To: <3fabce05-7da9-7daa-d92c-411369f35b4a@web.de>
Message-ID: <alpine.LNX.2.22.394.2005131028450.20@nippy.intranet>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de> <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet> <9d279f21-6172-5318-4e29-061277e82157@web.de> <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet> <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet> <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de> <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet> <3fabce05-7da9-7daa-d92c-411369f35b4a@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 12 May 2020, Markus Elfring wrote:

> > Markus, if you were to write a patch to improve upon coding-style.rst, 
> > who should review it?
> 
> All involved contributors have got chances to provide constructive 
> comments.

But how could someone be elevated to "involved contributor" if their 
patches were to be blocked by arbitrary application of the rules?

> I would be curious who will actually dare to contribute further ideas 
> for this area.
> 

You seem to be uniquely positioned to do that, if only because you cited 
rules which don't appear to support your objection.

> 
> > If you are unable to write or review such a patch, how can you hope to 
> > adjudicate compliance?
> 
> I can also try to achieve more improvements here to see how the 
> available software documentation will evolve.
> 

When the people who write and review the coding standards are the same 
people who write and review the code, the standards devolve (given the 
prevailing incentives).

> Regards, 
> Markus
> 
