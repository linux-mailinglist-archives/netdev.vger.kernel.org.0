Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EF57117C259
	for <lists+netdev@lfdr.de>; Fri,  6 Mar 2020 16:58:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726974AbgCFP62 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 6 Mar 2020 10:58:28 -0500
Received: from vps0.lunn.ch ([185.16.172.187]:49670 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726099AbgCFP62 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 6 Mar 2020 10:58:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=3LfItnB8/NprnVb5Jvhh1rqtasLaLb6p1u49/JmUdPY=; b=sCDHbXy+WXbbjKvsZyUWKL+hix
        7Kxl6z7hKVxrreLrIynJcofc12fVId/MJlSKrWFnddGLHSffKmEy0mtjWzi8vLvA31NdtSH/rJ3DO
        f8M26GGp5BHTX1Gu/s3kOlBVO0zgAgg2AtpFs9dTdqstLa+YjcMpW00G7+BKRN8wX9OU=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jAFMm-0005mR-8d; Fri, 06 Mar 2020 16:58:24 +0100
Date:   Fri, 6 Mar 2020 16:58:24 +0100
From:   Andrew Lunn <andrew@lunn.ch>
To:     Hau <hau@realtek.com>
Cc:     Kai-Heng Feng <kai.heng.feng@canonical.com>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Linux Netdev List <netdev@vger.kernel.org>,
        Kernel development list <linux-kernel@vger.kernel.org>,
        Anthony Wong <anthony.wong@canonical.com>,
        Jason Yen <jason.yen@canonical.com>
Subject: Re: SFP+ support for 8168fp/8117
Message-ID: <20200306155824.GH25183@lunn.ch>
References: <02F7CBDE-B877-481C-A5AF-2F4CBF830A2C@canonical.com>
 <80E9C881-91C8-4F29-B9CE-652F9EE0B018@canonical.com>
 <995bddbc4f9d48cbb3a289a7e9799f15@realtek.com>
 <12EA7285-06D7-44D3-B033-4F52A06123CC@canonical.com>
 <cae39cfbb5174c8884328887cdfb5a89@realtek.com>
 <9AAC75D4-B04F-49CD-BBB9-11AE3382E4D8@canonical.com>
 <5A21808E-C9DA-44BF-952B-4A5077B52E9B@canonical.com>
 <e10eef58d8fc4b67ac2a73784bf86381@realtek.com>
 <20200304152849.GE3553@lunn.ch>
 <1252a766545b48aeafdff9702566565c@realtek.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1252a766545b48aeafdff9702566565c@realtek.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> This chip can get fiber info through I2C. It also can detect LOS or control TX Disable via GPIO.

O.K. Good

You should be looking at using phylink to manage the SFP.

    Andrew
