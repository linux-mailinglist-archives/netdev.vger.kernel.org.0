Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BE1C0E2864
	for <lists+netdev@lfdr.de>; Thu, 24 Oct 2019 04:43:01 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2408292AbfJXCnA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 22:43:00 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:60870 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2408288AbfJXCnA (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 23 Oct 2019 22:43:00 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=zDYBgon5UhlK4awg+VCam1Uhngtd8ytTSRuFIonrn5E=; b=5KIB3Rttew+KXafCVK2Z2jst62
        pymKOdH6PHuIV51YARJtwU/R3Q1bKOVj482rQAbasTEdx4+VGhepVPT76pk/K/IXpeEiUlvh96QCz
        eHAFDuPILcfjMBBXRdJn0HzuM2au+aQL1z6Pq54GuNSFpl3vMJ6wFPB4mjtBl2pZA/hc=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iNT5U-0001Gd-UM; Thu, 24 Oct 2019 04:42:56 +0200
Date:   Thu, 24 Oct 2019 04:42:56 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     David Miller <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, jiri@mellanox.com
Subject: Re: [PATCH v5 0/2] mv88e6xxx: Allow config of ATU hash algorithm
Message-ID: <20191024024256.GL5707@lunn.ch>
References: <20191022013436.29635-1-andrew@lunn.ch>
 <20191023.191830.347702095940587406.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191023.191830.347702095940587406.davem@davemloft.net>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Oct 23, 2019 at 07:18:30PM -0700, David Miller wrote:
> 
> Andrew, this only applies to 'net' but it feels more like a feature
> to me.

Hi David

It was intended for net-next. Sorry. It could be that Viviens port
list patches got in the middle so that these did not cleanly apply to
net-next.

> Please give me some guidance and use [PATCH net-next .. ] in the future.

I wonder if we could get checkpatch to warn about this?

  Andrew
