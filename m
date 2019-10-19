Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 92930DDB18
	for <lists+netdev@lfdr.de>; Sat, 19 Oct 2019 23:12:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726152AbfJSVMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 19 Oct 2019 17:12:37 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:54108 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726129AbfJSVMh (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 19 Oct 2019 17:12:37 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=QuhXblKebvm8Ovdew3DyPgpt/jzERcohGhRblaJeUhY=; b=MTKMQ6aKsb77iAsh1dF+FEZrmF
        J4JRgU1FKYk4z11Kgyr+7FKDmV8/+YilOgIBBVe5DkiLqH+POFO3NHT66aYSjG6x87mo65QTuCn6/
        KNWMfrbjxZaKYAVrqtifHjWpmKO+i/RgsbBCxwUgVHYako2C+O7JDFaUHX8TbBUxuGKs=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLw1a-0006yI-4K; Sat, 19 Oct 2019 23:12:34 +0200
Date:   Sat, 19 Oct 2019 23:12:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     David Miller <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        Vivien Didelot <vivien.didelot@gmail.com>
Subject: Re: [PATCH net-next v4 2/2] net: dsa: mv88e6xxx: Add devlink param
 for ATU hash algorithm.
Message-ID: <20191019211234.GH25148@lunn.ch>
References: <20191019185201.24980-1-andrew@lunn.ch>
 <20191019185201.24980-3-andrew@lunn.ch>
 <20191019191656.GL2185@nanopsycho>
 <20191019192750.GB25148@lunn.ch>
 <20191019210202.GN2185@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191019210202.GN2185@nanopsycho>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could you please follow the rest of the existing params?

Why are params special? Devlink resources can and do have upper case
characters. So we get into inconsistencies within devlink,
particularly if there is a link between a parameter and a resources.

And i will soon be adding a resource, and it will be upper case, since
that is allowed. And it will be related to the ATU.

     Andrew


