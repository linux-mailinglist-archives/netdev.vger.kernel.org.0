Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3219BD9941
	for <lists+netdev@lfdr.de>; Wed, 16 Oct 2019 20:32:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2394233AbfJPScP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 16 Oct 2019 14:32:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37772 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727610AbfJPScP (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 16 Oct 2019 14:32:15 -0400
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 2D5D53090FCF;
        Wed, 16 Oct 2019 18:32:15 +0000 (UTC)
Received: from localhost (ovpn-112-25.phx2.redhat.com [10.3.112.25])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3CD1D643D6;
        Wed, 16 Oct 2019 18:32:14 +0000 (UTC)
Date:   Wed, 16 Oct 2019 14:32:13 -0400 (EDT)
Message-Id: <20191016.143213.348461731462881986.davem@redhat.com>
To:     rmk+kernel@armlinux.org.uk
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: sfp: move fwnode parsing into sfp-bus
 layer
From:   David Miller <davem@redhat.com>
In-Reply-To: <E1iKKDv-0000fA-Um@rmk-PC.armlinux.org.uk>
References: <E1iKKDv-0000fA-Um@rmk-PC.armlinux.org.uk>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.43]); Wed, 16 Oct 2019 18:32:15 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Russell King <rmk+kernel@armlinux.org.uk>
Date: Tue, 15 Oct 2019 11:38:39 +0100

> Rather than parsing the sfp firmware node in phylink, parse it in the
> sfp-bus code, so we can re-use this code for PHYs without having to
> duplicate the parsing.
> 
> Signed-off-by: Russell King <rmk+kernel@armlinux.org.uk>

Applied, thank you.
