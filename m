Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1F86A35911D
	for <lists+netdev@lfdr.de>; Fri,  9 Apr 2021 03:02:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233119AbhDIBDD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Apr 2021 21:03:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:41632 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S232918AbhDIBDD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 8 Apr 2021 21:03:03 -0400
Received: from andrew by vps0.lunn.ch with local (Exim 4.94)
        (envelope-from <andrew@lunn.ch>)
        id 1lUfXq-00Fe8S-CB; Fri, 09 Apr 2021 03:02:46 +0200
Date:   Fri, 9 Apr 2021 03:02:46 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Sven Van Asbroeck <thesven73@gmail.com>
Cc:     Bryan Whitehead <bryan.whitehead@microchip.com>,
        David S Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        George McCollister <george.mccollister@gmail.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        UNGLinuxDriver@microchip.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net v1] lan743x: fix ethernet frame cutoff issue
Message-ID: <YG+ntliV37vBZ9RR@lunn.ch>
References: <20210409003904.8957-1-TheSven73@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20210409003904.8957-1-TheSven73@gmail.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Sven

> Many thanks to Heiner Kallweit for suggesting this solution. 

Adding a Suggested-by: would be good. And it might sometime help
Johnathan Corbet extract some interesting statistics from the commit
messages if everybody uses the same format.

    Andrew
