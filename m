Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3F61A2E18B
	for <lists+netdev@lfdr.de>; Wed, 29 May 2019 17:49:29 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727133AbfE2PtU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 29 May 2019 11:49:20 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:39346 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725936AbfE2PtU (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 29 May 2019 11:49:20 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=FSmVTVfY0fmsLVjAxB2ZUOOjOUzRYdgko89LUfDdwZ4=; b=Uk2Xn1lulr7crQVgIg/wiqa1Qr
        PfbtwLmuLkpOvqM8lYWKlcWN/foi/tlU25F+qc/rdMJw2otunk9xuEhT87IzH7fIb7UqYxgRXgIqa
        GXwb4AqEujzlrDmUPhur5CO75qQBqDA47y0rhS5h+34A40Gn4Iywq+fX5ZCYZKS9Q++I=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.89)
        (envelope-from <andrew@lunn.ch>)
        id 1hW0pA-0000fP-2F; Wed, 29 May 2019 17:49:08 +0200
Date:   Wed, 29 May 2019 17:49:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Ruslan Babayev <ruslan@babayev.com>
Cc:     mika.westerberg@linux.intel.com, wsa@the-dreams.de,
        linux@armlinux.org.uk, f.fainelli@gmail.com, hkallweit1@gmail.com,
        davem@davemloft.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-i2c@vger.kernel.org,
        linux-acpi@vger.kernel.org, xe-linux-external@cisco.com
Subject: Re: [net-next,v4 1/2] i2c: acpi: export
 i2c_acpi_find_adapter_by_handle
Message-ID: <20190529154908.GX18059@lunn.ch>
References: <20190528230233.26772-1-ruslan@babayev.com>
 <20190528230233.26772-2-ruslan@babayev.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190528230233.26772-2-ruslan@babayev.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, May 28, 2019 at 04:02:32PM -0700, Ruslan Babayev wrote:
> This allows drivers to lookup i2c adapters on ACPI based systems similar to
> of_get_i2c_adapter_by_node() with DT based systems.
> 
> Signed-off-by: Ruslan Babayev <ruslan@babayev.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
