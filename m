Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5FE213CCBD5
	for <lists+netdev@lfdr.de>; Mon, 19 Jul 2021 02:40:55 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233877AbhGSAnp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 18 Jul 2021 20:43:45 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:33010 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232895AbhGSAnp (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sun, 18 Jul 2021 20:43:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=nrSh15+jVJgpIHHIxFDLFWk0lV0UfRCMtJjeWBcMPyc=; b=txAT0nABMAEIqQVKfrUetA3QZB
        ufxbq68mD1np7teV7+9mRmQfHjun2x5/F+3txQUCOOo2D4dSBmHDlmKrYaAnfOZnXlAxbqn047GiO
        vd10PKJlf9Qe5ENywNmsENfh177bI25wdI74+98/YJm2CcHoiEzZ/Z75zKU7vXagfOLc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1m5HKp-00DpzQ-7E; Mon, 19 Jul 2021 02:40:39 +0200
Date:   Mon, 19 Jul 2021 02:40:39 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Heiner Kallweit <hkallweit1@gmail.com>
Cc:     Tony Nguyen <anthony.l.nguyen@intel.com>, davem@davemloft.net,
        kuba@kernel.org, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, sasha.neftin@intel.com,
        vitaly.lifshits@intel.com, vinicius.gomes@intel.com,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>,
        Dvora Fuxbrumer <dvorax.fuxbrumer@linux.intel.com>
Subject: Re: [PATCH net-next 5/5] igc: Export LEDs
Message-ID: <YPTKB0HGEtsydf9/@lunn.ch>
References: <20210716212427.821834-1-anthony.l.nguyen@intel.com>
 <20210716212427.821834-6-anthony.l.nguyen@intel.com>
 <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <f705bcd6-c55c-0b07-612f-38348d85bbee@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> In general I'm not sure using the LED API provides a benefit here.
> The brightness attribute is simply misused. Maybe better add
> a sysfs attribute like led_mode under the netdev sysfs entry?

I _think_ you can put LED sys files other places than
/sys/class/led. It should be possible to put them into netdev sysfs
directory. However you need to consider what affect network name
spaces have on this and what happens when an interface changes
namespace.

     Andrew
