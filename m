Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 892221B665
	for <lists+netdev@lfdr.de>; Mon, 13 May 2019 14:51:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730009AbfEMMvH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 13 May 2019 08:51:07 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33723 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727818AbfEMMvH (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 13 May 2019 08:51:07 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=hGvdGIUxp9e75fiwBQkqtijB9g3Z7ApL0Bq8e9122vM=; b=MfBb+Vk7qNS+UXmPw2yb1dBZ6N
        ssBfcSllZs7ks/5I5h6swJJhr5q5VBoaf93KM5+/GaPT5w/RaGYjHBjKS9EE6ftOfuLAQwwjTuQQ6
        vPUON91F0UPtMOuM6HH+F7Q4NMS29xptaMEFpFwVI+LSifsXQDgpW5dbnd/NjtWd7SHk=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hQAQ3-0008Dj-9b; Mon, 13 May 2019 14:51:03 +0200
Date:   Mon, 13 May 2019 14:51:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Serge Semin <fancer.lancer@gmail.com>, g@lunn.ch
Cc:     Vicente Bergas <vicencb@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <rmk+kernel@armlinux.org.uk>,
        Florian Fainelli <f.fainelli@gmail.com>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: net: phy: realtek: regression, kernel null pointer dereference
Message-ID: <20190513125103.GC28969@lunn.ch>
References: <16f75ff4-e3e3-4d96-b084-e772e3ce1c2b@gmail.com>
 <742a2235-4571-aa7d-af90-14c708205c6f@gmail.com>
 <11446b0b-c8a4-4e5f-bfa0-0892b500f467@gmail.com>
 <61831f43-3b24-47d9-ec6f-15be6a4568c5@gmail.com>
 <0f16b2c5-ef2a-42a1-acdc-08fa9971b347@gmail.com>
 <20190513102941.4ocb3tz3wmh3pj4t@mobilestation>
 <20190513105104.af7d7n337lxqac63@mobilestation>
 <cf1e81d9-6f91-41fe-a390-b9688e5707f7@gmail.com>
 <20190513124225.odm3shcfo3tsq6xk@mobilestation>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190513124225.odm3shcfo3tsq6xk@mobilestation>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Ahh, I see. Then using lock-less version of the access methods must fix the
> problem. You could try something like this:

Kunihiko Hayash is way ahead of you.

	 Andrew
