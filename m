Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id F093470933
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 21:01:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729188AbfGVTBl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 15:01:41 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:57016 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727646AbfGVTBk (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 22 Jul 2019 15:01:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=l9bRvGYH3XRPkQyhYau9cH//jdY+2RalVJi8pH2PNWQ=; b=RDY2P7K0jIgySjc7lVsmVFCdNv
        vtwKEMeZmbIp7a06wMD230HDZ07Xnb8TpWA6kP6XQ89GYTpn31gIKdJeDyjU0yR6ZR3LBJBBgiN2Y
        yWUa2KGE1AOsf4aQU81XHnFkQ8hsG1oNKeV51YEN/3h8mRrInpYqvDC/K2cadhoWxzTY=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hpdYz-0004aS-Gq; Mon, 22 Jul 2019 21:01:33 +0200
Date:   Mon, 22 Jul 2019 21:01:33 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Matthias Kaehlcke <mka@chromium.org>
Cc:     Rob Herring <robh+dt@kernel.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S . Miller" <davem@davemloft.net>,
        Mark Rutland <mark.rutland@arm.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        netdev <netdev@vger.kernel.org>, devicetree@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Douglas Anderson <dianders@chromium.org>
Subject: Re: [PATCH v2 6/7] dt-bindings: net: realtek: Add property to
 configure LED mode
Message-ID: <20190722190133.GF8972@lunn.ch>
References: <20190703193724.246854-1-mka@chromium.org>
 <20190703193724.246854-6-mka@chromium.org>
 <e8fe7baf-e4e0-c713-7b93-07a3859c33c6@gmail.com>
 <20190703232331.GL250418@google.com>
 <CAL_JsqL_AU+JV0c2mNbXiPh2pvfYbPbLV-2PHHX0hC3vUH4QWg@mail.gmail.com>
 <20190722171418.GV250418@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190722171418.GV250418@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 10:14:18AM -0700, Matthias Kaehlcke wrote:
> I'm working on a generic binding.
> 
> I wonder what is the best process for reviewing/landing it, I'm
> doubting between two options:
> 
> a) only post the binding doc and the generic PHY code that reads
>    the configuration from the DT. Post Realtek patches once
>    the binding/generic code has been acked.
> 
>    pros: no churn from Realtek specific patches
>    cons: initially no (real) user of the new binding
> 
> b) post generic and Realtek changes together
> 
>    pros: the binding has a user initially
>    cons: churn from Realtek specific patches
> 
> I can do either, depending on what maintainers/reviewers prefer. I'm
> slightly inclined towards a)

Hi Matthias

It is normal to include one user of any generic API which is added,
just to make is clear how an API should be used.

     Andrew
