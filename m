Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0488F3C185E
	for <lists+netdev@lfdr.de>; Thu,  8 Jul 2021 19:38:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230081AbhGHRlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Jul 2021 13:41:12 -0400
Received: from smtprelay0011.hostedemail.com ([216.40.44.11]:46104 "EHLO
        smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S229815AbhGHRlM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Jul 2021 13:41:12 -0400
Received: from omf16.hostedemail.com (clb03-v110.bra.tucows.net [216.40.38.60])
        by smtprelay04.hostedemail.com (Postfix) with ESMTP id A11C1180A9C98;
        Thu,  8 Jul 2021 17:38:29 +0000 (UTC)
Received: from [HIDDEN] (Authenticated sender: joe@perches.com) by omf16.hostedemail.com (Postfix) with ESMTPA id 3C77425511A;
        Thu,  8 Jul 2021 17:38:28 +0000 (UTC)
Message-ID: <ccf9f07a72c911652d24ceb6c6e925f834f1d338.camel@perches.com>
Subject: Re: [PATCH net-next v2] drivers: net: Follow the indentation coding
 standard on printks
From:   Joe Perches <joe@perches.com>
To:     Carlos Bilbao <bilbao@vt.edu>, davem@davemloft.net
Cc:     kuba@kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, andrew@lunn.ch,
        gregkh@linuxfoundation.org
Date:   Thu, 08 Jul 2021 10:38:26 -0700
In-Reply-To: <5183009.Sb9uPGUboI@iron-maiden>
References: <1884900.usQuhbGJ8B@iron-maiden>
         <03ad1f2319a608bbfe3fc09e901742455bf733a0.camel@perches.com>
         <5183009.Sb9uPGUboI@iron-maiden>
Content-Type: text/plain; charset="ISO-8859-1"
User-Agent: Evolution 3.40.0-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-2.88
X-Stat-Signature: 4r8o453uawndmydoihpe9mb65adrwyw8
X-Rspamd-Server: rspamout05
X-Rspamd-Queue-Id: 3C77425511A
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Session-ID: U2FsdGVkX18aO+OxNVt0tR2tBbw9r7VAFqEi8lL67G4=
X-HE-Tag: 1625765908-184590
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 2021-07-08 at 13:33 -0400, Carlos Bilbao wrote:
> Fix indentation of printks that start at the beginning of the line. Change this 
> for the right number of space characters, or tabs if the file uses them. 

You are touching 2 different drivers and this should really be
2 separate patches.

> diff --git a/drivers/net/ethernet/dec/tulip/de4x5.c.rej b/drivers/net/ethernet/dec/tulip/de4x5.c.rej
[]
> +++ b/drivers/net/ethernet/dec/tulip/de4x5.c.rej
> @@ -0,0 +1,11 @@
> +--- drivers/net/ethernet/dec/tulip/de4x5.c
> ++++ drivers/net/ethernet/dec/tulip/de4x5.c
> +@@ -3169,7 +3169,7 @@ dc2114x_autoconf(struct net_device *dev)
> + 
> +     default:
> +        lp->tcount++;
> +-printk("Huh?: media:%02x\n", lp->media);
> ++       printk("Huh?: media:%02x\n", lp->media);
> +        lp->media = INIT;
> +        break;
> +     }

This is an interdiff that should not be part of this change.


