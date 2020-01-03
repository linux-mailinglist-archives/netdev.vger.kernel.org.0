Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2EB0312FD25
	for <lists+netdev@lfdr.de>; Fri,  3 Jan 2020 20:38:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728564AbgACTiO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 3 Jan 2020 14:38:14 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:46922 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728488AbgACTiN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 3 Jan 2020 14:38:13 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=XIf32WVRgKWUO8SMfC0JjcU81vftzRzK1CmLURrg6/Y=; b=V23sxuuNIuebNcyNQsI/qqXSei
        svb4FDGyd/iIjSfIolpU+iWqnA29z5wVMvO7uWEfMMzvWggT10nkqqugFmMBvisdutI7kaLrGfuJH
        0ISyYAmpz855jM6r5/RwwtBlFkEdDeRCo32MtPaSS1u2fZPU/mcCv5DPIffdqYg08U6Y=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1inSli-0002FQ-HX; Fri, 03 Jan 2020 20:37:58 +0100
Date:   Fri, 3 Jan 2020 20:37:58 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     Vladimir Oltean <olteanv@gmail.com>,
        Matthew Wilcox <willy@infradead.org>,
        yu kuai <yukuai3@huawei.com>, klassert@kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Jakub Kicinski <jakub.kicinski@netronome.com>,
        hslester96@gmail.com, mst@redhat.com, yang.wei9@zte.com.cn,
        netdev <netdev@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200103193758.GO1397@lunn.ch>
References: <20200103121907.5769-1-yukuai3@huawei.com>
 <20200103144623.GI6788@bombadil.infradead.org>
 <20200103175318.GN1397@lunn.ch>
 <CA+h21hqcz=QF8bq285JjdOn+gsOGvGSnDiWzDOS5-XGAGGGr9w@mail.gmail.com>
 <b4697457-51d2-c987-4138-b4b2b92e391d@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b4697457-51d2-c987-4138-b4b2b92e391d@gmail.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> And since more reviewers are on the same boat, the fix should probably
> look to eliminate the warning by doing something like:
> 
> (void)mdio_read(dev, vp->phys[0], MII_BMSR);

Yes, this is the safe option.

     Andrew
