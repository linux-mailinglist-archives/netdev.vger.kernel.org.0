Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D978C209E8F
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 14:37:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404686AbgFYMhr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 08:37:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57556 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404285AbgFYMhr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 08:37:47 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0B1D0C061573;
        Thu, 25 Jun 2020 05:37:47 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 7634E22F99;
        Thu, 25 Jun 2020 14:37:43 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1593088663;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Kko6KPRJbrrxd/OzuO+4kiTUvVjfUZwSZ/cLISnq5wo=;
        b=igFGtRzt+YksWixMjHX1+e8P0eA9n7wLET+6ciylTzLs3QGHj5aRji1JuSOwVs6PvKmZZD
        dEmE22dfVtJnA6swBgnijO9RgDvaj2jz5oCIIQpGnq/yreoGsxDBLQ9yL3oypYVDDIAl5M
        yfJQ3pH2ZlTgDxirtpZlZnHCb5xZZhw=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 25 Jun 2020 14:37:43 +0200
From:   Michael Walle <michael@walle.cc>
To:     Joakim Zhang <qiangqing.zhang@nxp.com>, mkl@pengutronix.de
Cc:     linux-can@vger.kernel.org, dl-linux-imx <linux-imx@nxp.com>,
        netdev@vger.kernel.org
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
In-Reply-To: <d5579883c7e9ab3489ec08a73c407982@walle.cc>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
User-Agent: Roundcube Webmail/1.4.5
Message-ID: <39b5d77bda519c4d836f44a554890bae@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-06-02 12:15, schrieb Michael Walle:
> Hi Marc,
> 
> Am 2020-04-16 11:41, schrieb Joakim Zhang:
>> Hi Marc,
>> 
>> How about FlexCAN FD patch set, it is pending for a long time. Many
>> work would base on it, we are happy to see it in upstream mainline
>> ASAP.
>> 
>> Michael Walle also gives out the test-by tag:
>> 	Tested-by: Michael Walle <michael@walle.cc>
> 
> There seems to be no activity for months here. Any reason for that? Is
> there anything we can do to speed things up?

ping.. There are no replies or anything. Sorry but this is really
annoying and frustrating.

Marc, is there anything wrong with the flexcan patches?

-michael
