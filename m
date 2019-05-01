Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4E0B210DEA
	for <lists+netdev@lfdr.de>; Wed,  1 May 2019 22:23:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726189AbfEAUXE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 May 2019 16:23:04 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:51479 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726096AbfEAUXD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 May 2019 16:23:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=qv3nzSNeLpbWrzH4SE4vhOD1NlSAiKmEircDdM74DhU=; b=U4OGHwg8R+r5f4UXcfFFKEbGAq
        ng7R+hJ7efk7TZKXl8mgnBWXXGAWMEzaTm5nQg8WwI6pKXWkNx8c4kOnShLBWluSd3E7d4jG0T17t
        Py55U3K3piYJREyu9uyJ0oCO7zqf2ZeRFPbaaRff+NNl38HqTTSk77I8fGLlQu+RuCtg=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hLvkp-0008CT-Sj; Wed, 01 May 2019 22:22:59 +0200
Date:   Wed, 1 May 2019 22:22:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Rasmus Villemoes <rasmus.villemoes@prevas.dk>
Cc:     Vivien Didelot <vivien.didelot@savoirfairelinux.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Rasmus Villemoes <Rasmus.Villemoes@prevas.se>
Subject: Re: [RFC PATCH 3/5] net: dsa: prepare mv88e6xxx_g1_atu_op() for the
 mv88e6250
Message-ID: <20190501202259.GD19809@lunn.ch>
References: <20190501193126.19196-1-rasmus.villemoes@prevas.dk>
 <20190501193126.19196-4-rasmus.villemoes@prevas.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190501193126.19196-4-rasmus.villemoes@prevas.dk>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 01, 2019 at 07:32:12PM +0000, Rasmus Villemoes wrote:
> All the currently supported chips have .num_databases either 256 or
> 4096, so this patch does not change behaviour for any of those. The
> mv88e6250, however, has .num_databases == 64, and it does not put the
> upper two bits in ATU control 13:12, but rather in ATU Operation
> 9:8. So change the logic to prepare for supporting mv88e6250.
> 
> Signed-off-by: Rasmus Villemoes <rasmus.villemoes@prevas.dk>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
