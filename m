Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F5A8C9E27
	for <lists+netdev@lfdr.de>; Thu,  3 Oct 2019 14:14:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729891AbfJCMNX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 3 Oct 2019 08:13:23 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:59216 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728898AbfJCMNX (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 3 Oct 2019 08:13:23 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=TLtfXy8zO9jSt6E+uaZBiqXbOAv8kiYOCjw3jo40S1g=; b=by+wWEl/uyH5x7RXcIwTzAss2N
        yLivx1NWE2o9WObXcibRSnridELaIIyIq09BQloBPOFYavQA6vtlaby7tDmU6f8fniihbIgnwFhP1
        9+fvUPRBDZMqLAht15lqQItIVTEzTLmkUt04csz2bPJgKSXpxMuwiAOVQxPNGM8lAjWc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iFzys-0004Ch-NN; Thu, 03 Oct 2019 14:13:14 +0200
Date:   Thu, 3 Oct 2019 14:13:14 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Denis Odintsov <d.odintsov@traviangames.com>
Cc:     "vivien.didelot@gmail.com" <vivien.didelot@gmail.com>,
        "h.feurstein@gmail.com" <h.feurstein@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: Re: Marvell 88E6141 DSA degrades after
 7fb5a711545d7d25fe9726a9ad277474dd83bd06
Message-ID: <20191003121314.GB15916@lunn.ch>
References: <DE1D3FAD-959D-4A56-8C68-F713D44A1FED@traviangames.com>
 <20191002121916.GB20028@lunn.ch>
 <73A3CAFD-56DB-4E09-8830-606B489C3754@traviangames.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <73A3CAFD-56DB-4E09-8830-606B489C3754@traviangames.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 03, 2019 at 08:52:34AM +0000, Denis Odintsov wrote:
> Hello,
> 
> Thank you for your reply, now that you've said that I actually put WARN_ON(1) into mv88e6xxx_adjust_link and found out that it is not actually being called. Not even on 5.3. What I saw was a warning produced by block like "if (ds->ops->adjust_link)" in net/dsa/ code, but not the actual call. My bad. So it seems the content of the function is irrelevant, and as I can see there are many block like this, so most probably it is something one of these blocks were doing on 5.3 which changed to 5.4, which is way harder to debug I guess. Any other things I could check in that matter?
> 
> Denis. 

Hi Danis

Please don't top post. And wrap your emails to around 75 characters.

How did you decide on 7fb5a711545d7d25fe9726a9ad277474dd83bd06? Did
you do a git bisect?

    Andrew
