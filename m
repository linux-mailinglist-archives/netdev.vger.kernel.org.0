Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id A6EB0DDAB2
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 21:27:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726145AbfJST1x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 15:27:53 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54040 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726101AbfJST1x (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 15:27:53 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=dmwP55X2u7cRvzhNokxAVdZTYg2gKBiSKnC2TfKDeiA=; b=MtTcyoP38XX0k4Bb/T55kXOL9q
        QRKKfYdgiTN9hGTYXxgJQb4D7PPqip4X3rpdF+daxmdpluld/nTQbbFzBTtg661EE7tcnFJlrwAOE
        XmaKq5hLyh7TOkuULN0F5USA68auXRsMwWbQYzqJQAhvLyQmJdzYpMihieDsc2lmBves=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLuOE-0006eh-3f; Sat, 19 Oct 2019 21:27:50 +0200
Date:   Sat, 19 Oct 2019 21:27:50 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191019192750.GB25148@lunn.ch>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019191656.GL2185@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> >+address_translation_unit_hash	[DEVICE, DRIVER-SPECIFIC]
> 
> This is quite verbose. Can't you name this just "atu_hash" and be
> aligned with the function names and MV88E6XXX_DEVLINK_PARAM_ID_ATU_HASH
> and others?

Hi Jiri

I would use ATU_hash, but not atu_hash, sorry.

Hopefully somebody will implement bash command completion, making it
easier.

  Andrew
