Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 5C2AF1996E8
	for <lists+netdev@lfdr.de>; Tue, 31 Mar 2020 14:59:17 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730770AbgCaM7M (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Mar 2020 08:59:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:40994 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730473AbgCaM7L (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 31 Mar 2020 08:59:11 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=mFwgAlR7Lk3HX7sPCyBzL0qhRjsF1JNGuPfhbeEkszU=; b=KxQalpqH3raFULxaqMR/cAt8sT
        dSV0sMsR3f0sYGvo/CKKbMKdbjR0jJ12Rej8KbjPfdFEmVcf29rfF3WcdkjBuCeoUbxbMF01q41HE
        NhQ7LowcBhtLm9ITFjlTqgZsZZjShX8kP/GEQPj5/z4FceDBdcbBptGmFPgyNe+qoZN8=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jJGU0-000D0f-KK; Tue, 31 Mar 2020 14:59:08 +0200
Date:   Tue, 31 Mar 2020 14:59:08 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Codrin.Ciubotariu@microchip.com
Cc:     f.fainelli@gmail.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        hkallweit1@gmail.com, linux@armlinux.org.uk, davem@davemloft.net
Subject: Re: [PATCH] net: mdio: of: Do not treat fixed-link as PHY
Message-ID: <20200331125908.GB24486@lunn.ch>
References: <20200330160136.23018-1-codrin.ciubotariu@microchip.com>
 <20200330163028.GE23477@lunn.ch>
 <9bbbe2ed-985b-49e7-cc16-8b6bae3e8e8e@gmail.com>
 <bd9f2507-958e-50bf-2b84-c21adf6ab588@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <bd9f2507-958e-50bf-2b84-c21adf6ab588@microchip.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Thanks guys. I thought there might be other controllers that have the 
> PHY nodes inside the ethernet node.

Hi Codrin

There are some still using this deprecated feature. But macb is the
only one doing this odd looping over child nodes. It is this looping
which is breaking things, not the use of the deprecated feature
itself.

	Andrew
