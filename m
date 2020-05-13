Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A8F561D22DA
	for <lists+netdev@lfdr.de>; Thu, 14 May 2020 01:17:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732517AbgEMXQu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 May 2020 19:16:50 -0400
Received: from kvm5.telegraphics.com.au ([98.124.60.144]:52394 "EHLO
        kvm5.telegraphics.com.au" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1732161AbgEMXQu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 May 2020 19:16:50 -0400
Received: from localhost (localhost.localdomain [127.0.0.1])
        by kvm5.telegraphics.com.au (Postfix) with ESMTP id BD5E829E7C;
        Wed, 13 May 2020 19:16:46 -0400 (EDT)
Date:   Thu, 14 May 2020 09:16:55 +1000 (AEST)
From:   Finn Thain <fthain@telegraphics.com.au>
To:     Markus Elfring <Markus.Elfring@web.de>
cc:     netdev@vger.kernel.org, kernel-janitors@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Christophe Jaillet <christophe.jaillet@wanadoo.fr>
Subject: Re: net/sonic: Software evolution around the application of coding
 standards
In-Reply-To: <47b7cfc3-68a1-b1da-9761-ab27dc8118ad@web.de>
Message-ID: <alpine.LNX.2.22.394.2005140853420.8@nippy.intranet>
References: <b7651b26-ac1e-6281-efb2-7eff0018b158@web.de> <alpine.LNX.2.22.394.2005100922240.11@nippy.intranet> <9d279f21-6172-5318-4e29-061277e82157@web.de> <alpine.LNX.2.22.394.2005101738510.11@nippy.intranet> <bc70e24c-dd31-75b7-6ece-2ad31982641e@web.de>
 <alpine.LNX.2.22.394.2005110845060.8@nippy.intranet> <9994a7de-0399-fb34-237a-a3c71b3cf568@web.de> <alpine.LNX.2.22.394.2005120905410.8@nippy.intranet> <3fabce05-7da9-7daa-d92c-411369f35b4a@web.de> <alpine.LNX.2.22.394.2005131028450.20@nippy.intranet>
 <47b7cfc3-68a1-b1da-9761-ab27dc8118ad@web.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 13 May 2020, Markus Elfring wrote:

> some developers care to improve the compliance with the current 
> standard at various source code places, don't they?
> 

This thread appears to be circular. Before I abandon it as folly, perhaps 
you would answer one more question. Out of all of the semantic patches in 
scripts/coccinelle, would you care to cast a vote for the best one?
