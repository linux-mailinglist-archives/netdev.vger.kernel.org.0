Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id E0E211CDC22
	for <lists+netdev@lfdr.de>; Mon, 11 May 2020 15:54:33 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730431AbgEKNyT (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 11 May 2020 09:54:19 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53602 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730407AbgEKNyJ (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 11 May 2020 09:54:09 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=WaLCPKDlYTN7PG6jziEvzv4jpBO1YzFsUfFc0Au8bEo=; b=Ybxhfi/J86rdLrb2W+md8xD1zn
        2SdswnS9uuxPvv51+c7kNLDqcjpB93cvzVI43Yk1wxbP6CDkStuXXl1+fTVRjKZa9A8QOQekPO9d5
        wZxKgMKXkEG5pC4KCIN9yXmfcCrb6VSBm4kRimkf/4iBKIY4WFBqspKMohL6E9tvFILQ=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.93)
        (envelope-from <andrew@lunn.ch>)
        id 1jY8sZ-001rH1-NC; Mon, 11 May 2020 15:53:59 +0200
Date:   Mon, 11 May 2020 15:53:59 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Vadym Kochan <vadym.kochan@plvision.eu>
Cc:     Jiri Pirko <jiri@resnulli.us>, netdev@vger.kernel.org,
        "David S. Miller" <davem@davemloft.net>,
        Oleksandr Mazur <oleksandr.mazur@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Jiri Pirko <jiri@mellanox.com>,
        Ido Schimmel <idosch@mellanox.com>,
        Chris Packham <Chris.Packham@alliedtelesis.co.nz>
Subject: Re: [RFC next-next v2 1/5] net: marvell: prestera: Add driver for
 Prestera family ASIC devices
Message-ID: <20200511135359.GB413878@lunn.ch>
References: <20200430232052.9016-1-vadym.kochan@plvision.eu>
 <20200430232052.9016-2-vadym.kochan@plvision.eu>
 <20200511103222.GF2245@nanopsycho>
 <20200511111134.GD25096@plvision.eu>
 <20200511112905.GH2245@nanopsycho>
 <20200511124245.GA409897@lunn.ch>
 <20200511130252.GE25096@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20200511130252.GE25096@plvision.eu>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Looks like it might be hard for the board manufacturing? I mean each
> board item need to have updated dtb file with base mac address, instead
> to have common dtb for the board type.
> 
> And it sounds that platform data might be the way in case if the vendor
> will implement platform device driver which will handle reading base mac
> from eeprom (or other storage) depending on the board and put it to the
> platform data which will be provided to prestera driver ?

Hi Vadym

This is not a new problem. Go look at the standard solutions to this.

of_get_mac_address(), eth_platform_get_mac_address(),
nvmem_get_mac_address(), of_get_mac_addr_nvmem(), etc.

  Andrew
