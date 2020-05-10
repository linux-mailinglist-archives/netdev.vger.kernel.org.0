Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id B83B21CCD26
	for <lists+netdev@lfdr.de>; Sun, 10 May 2020 21:04:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729210AbgEJTEi (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 10 May 2020 15:04:38 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52296 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728385AbgEJTEi (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 10 May 2020 15:04:38 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l/N1Ay1A6HSSGOawCmi/lQN5NwZW3PV2zfv6jgNU9r0=; b=F+EU+gfg/3I+GqHxl6nmVUZN/P
        3YL26ocxp9fOv9gUOZbr8AAPo7ivD9VAqIF5l7jT6aHn8xXJeYvyTd/R6Olf83FU6BrmyIHCfaVmE
        UhtMYSA9TkWyYr4TmyaEj4mnsZz7dEOyYlPZeShz+pd61dmgfju+aFgjj0As7RHEr+2U=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jXrFY-001jYn-JA; Sun, 10 May 2020 21:04:32 +0200
Date:   Sun, 10 May 2020 21:04:32 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Joe Perches <joe@perches.com>, davem@davemloft.net,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] checkpatch: warn about uses of ENOTSUPP
Message-ID: <20200510190432.GB411829@lunn.ch>
References: <20200510185148.2230767-1-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200510185148.2230767-1-kuba@kernel.org>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, May 10, 2020 at 11:51:48AM -0700, Jakub Kicinski wrote:
> ENOTSUPP often feels like the right error code to use, but it's
> in fact not a standard Unix error. E.g.:

Hi Jakub

You said ENOTSUPP is for NFS? Would it make sense to special case
fs/nfs* files and not warn there? I assume that would reduce the number
of false positives?

   Andrew
