Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 27C363FDD08
	for <lists+netdev@lfdr.de>; Wed,  1 Sep 2021 15:20:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1343768AbhIANDM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Sep 2021 09:03:12 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:52214 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1344156AbhIANC7 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 1 Sep 2021 09:02:59 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Transfer-Encoding:Content-Disposition:
        Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:From:
        Sender:Reply-To:Subject:Date:Message-ID:To:Cc:MIME-Version:Content-Type:
        Content-Transfer-Encoding:Content-ID:Content-Description:Content-Disposition:
        In-Reply-To:References; bh=XJ9p4HdwD5YVUcVStTTsObEbtRFsXgvAQSj9U5CFgnE=; b=TP
        QM18l9B4f9qsw7IzMoazkOEE/HDhmGx12HRdP7pWFYesmTMah+2WRpIPgTpuZQp/0NCm+0LchzOuv
        OF5d/l58xV8LWGZL2ZGcCSdVu61NyqvfOwjWWkxXsdthAEuEMG5BI1CZbOOXC7xRdK/I3yJ/haHhn
        i8POquXSXk+S92c=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.94.2)
        (envelope-from <andrew@lunn.ch>)
        id 1mLPsI-004rkE-IL; Wed, 01 Sep 2021 15:01:54 +0200
Date:   Wed, 1 Sep 2021 15:01:54 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     =?utf-8?B?6ams5by6?= <maqianga@uniontech.com>
Cc:     "f.fainelli" <f.fainelli@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ming Wang <wangming01@loongson.cn>
Subject: Re: [PATCH] net: phy: fix autoneg invalid error state of GBSR
 register.
Message-ID: <YS95wn6kLkM9vHUl@lunn.ch>
References: <20210901105608.29776-1-maqianga@uniontech.com>
 <YS91biZov3jE+Lrd@lunn.ch>
 <tencent_405C539D1A6BA06876B7AC05@qq.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <tencent_405C539D1A6BA06876B7AC05@qq.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> > It looks like you are using an old tree.
> Yes, it is linux-4.19.y, since 4.19.y does not have autoneg_complete flag,，
> This patch adds the condition before
> reading GBSR register to fix this error state.

So you first need to fix it in net/master, and then backport it to
older kernels.

   Andrew
