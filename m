Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0D36A316B5A
	for <lists+netdev@lfdr.de>; Wed, 10 Feb 2021 17:35:38 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232466AbhBJQe0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 10 Feb 2021 11:34:26 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:60938 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232299AbhBJQcN (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 10 Feb 2021 11:32:13 -0500
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1l9sOk-005LrK-UE; Wed, 10 Feb 2021 17:31:26 +0100
Date:   Wed, 10 Feb 2021 17:31:26 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     John Efstathiades <john.efstathiades@pebblebay.com>
Cc:     UNGLinuxDriver@microchip.com, davem@davemloft.net,
        netdev@vger.kernel.org, Woojung.Huh@microchip.com
Subject: Re: [PATCH net-next 1/9] lan78xx: add NAPI interface support
Message-ID: <YCQKXp98nNbO4qtM@lunn.ch>
References: <20210204113121.29786-1-john.efstathiades@pebblebay.com>
 <20210204113121.29786-2-john.efstathiades@pebblebay.com>
 <YBv4VVhsswYtX6qc@lunn.ch>
 <004601d6ffc0$bbf46c90$33dd45b0$@pebblebay.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <004601d6ffc0$bbf46c90$33dd45b0$@pebblebay.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks for the other comments. I'll sort out the issues before preparing an
> update but it will take a few weeks to re-test the driver and prepare a new
> patch.

Given the complexity of these patches, you can expect to go around the
cycle a few times. So do testing, but also assume you are going to
have to retest it a few times. Don't spend a huge amount of time on
testing, and maybe consider automating what testing you can.

	 Andrew
