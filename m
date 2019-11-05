Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1A347F093C
	for <lists+netdev@lfdr.de>; Tue,  5 Nov 2019 23:23:01 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730281AbfKEWW4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 5 Nov 2019 17:22:56 -0500
Received: from ssl.serverraum.org ([176.9.125.105]:33699 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729680AbfKEWW4 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 5 Nov 2019 17:22:56 -0500
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 2301F22EE9;
        Tue,  5 Nov 2019 23:22:51 +0100 (CET)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc;
        s=mail2016061301; t=1572992574;
        bh=iEKAkEOL4I/JxiQlzznezKZAeBZue8KQu78rEOeHMGU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ImHkZ+GkUqN+pUqwIxRgqEe1m4REsvEkv/41OqkvggLsU3KEQB+oHCnXXolwfF5M/
         6S5pMdMb3OgN8hrvakCGpcZTKtuQz4KPpavjPKMgDp5YAnk2DFlulL6SHnw8pxtrPk
         SmV5u66A4L9RU5621OC4qv+p5LzhbF5h0nvubIRc=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Tue, 05 Nov 2019 23:22:51 +0100
From:   Michael Walle <michael@walle.cc>
To:     David Miller <davem@davemloft.net>
Cc:     linux-kernel@vger.kernel.org, devicetree@vger.kernel.org,
        netdev@vger.kernel.org, robh+dt@kernel.org, mark.rutland@arm.com,
        andrew@lunn.ch, f.fainelli@gmail.com, hkallweit1@gmail.com,
        lgirdwood@gmail.com, broonie@kernel.org, simon.horman@netronome.com
Subject: Re: [PATCH 0/5] net: phy: at803x device tree binding
In-Reply-To: <20191105.140616.1174888253359674234.davem@davemloft.net>
References: <20191102011351.6467-1-michael@walle.cc>
 <20191105.140616.1174888253359674234.davem@davemloft.net>
Message-ID: <0265fc6d0d0eb64f578959a8883295bd@walle.cc>
X-Sender: michael@walle.cc
User-Agent: Roundcube Webmail/1.2.3
X-Virus-Scanned: clamav-milter 0.101.4 at web
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2019-11-05 23:06, schrieb David Miller:
> From: Michael Walle <michael@walle.cc>
> Date: Sat,  2 Nov 2019 02:13:46 +0100
> 
>> Adds a device tree binding to configure the clock and the RGMII 
>> voltage.
> 
> This does not apply cleanly to net-next, please respin.

That is actually just fine, because there is a bug in the AR8035 
handling. I'll fix that and rebase it on your net-next.

Thanks,
-michael
