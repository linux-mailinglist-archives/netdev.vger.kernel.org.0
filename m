Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7D97A425505
	for <lists+netdev@lfdr.de>; Thu,  7 Oct 2021 16:08:11 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241953AbhJGOKD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Oct 2021 10:10:03 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54318 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S240542AbhJGOKD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 7 Oct 2021 10:10:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Disposition:Content-Type:MIME-Version:
        References:Message-ID:Subject:Cc:To:From:Date:From:Sender:Reply-To:Subject:
        Date:Message-ID:To:Cc:MIME-Version:Content-Type:Content-Transfer-Encoding:
        Content-ID:Content-Description:Content-Disposition:In-Reply-To:References;
        bh=9LV4y1hYeKQDb8QZoMP1V/zgClE/dilQ5gehR54OJUY=; b=1w2l4ZVs8eO2VnlEVxK8jB6nL8
        u1ShFk7DMnL0TWzTDn/DGuvrQXq7oX4WYqsbVrrserwomaU5O1nddSu5xYv8ijVKHP+IdPTyB96cr
        1M/Cp7M+shQCvF32fUyfXHB+Z8U6XrFIDsvffdnXm28ZNdn8vNTYELfP5D21N4E9rhW4=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mYU43-009xKU-Oa; Thu, 07 Oct 2021 16:08:03 +0200
Date:   Thu, 7 Oct 2021 16:08:03 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     davem@davemloft.net, netdev@vger.kernel.org,
        vladimir.oltean@nxp.com, michael@walle.cc
Subject: Re: [PATCH net-next 1/3] ethernet: un-export nvmem_get_mac_address()
Message-ID: <YV7/QyPuLHHZoKfT@lunn.ch>
References: <20211007132511.3462291-1-kuba@kernel.org>
 <20211007132511.3462291-2-kuba@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20211007132511.3462291-2-kuba@kernel.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 07, 2021 at 06:25:09AM -0700, Jakub Kicinski wrote:
> nvmem_get_mac_address() is only called from of_net.c
> we don't need the export.
> 
> Signed-off-by: Jakub Kicinski <kuba@kernel.org>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
