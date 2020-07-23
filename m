Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 248DC22B85C
	for <lists+netdev@lfdr.de>; Thu, 23 Jul 2020 23:09:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726437AbgGWVJU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jul 2020 17:09:20 -0400
Received: from ssl.serverraum.org ([176.9.125.105]:36805 "EHLO
        ssl.serverraum.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726258AbgGWVJT (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 23 Jul 2020 17:09:19 -0400
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 574F722F2E;
        Thu, 23 Jul 2020 23:09:16 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1595538556;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=bEcb6vSDQsnzOcchwltvx/jb9b32oo0bZooPAH9Llos=;
        b=ui0IFJsnI3HhMAiLGNOtmSZ/mN1rN4nSr7rj1Ec3xxEJLSyNbdwfK6gvVUfYG3Vj1XABl6
        gmsLvfbJXY3Sx6o3SA/+RTOxESV0i/bU5gbF8KZW1U9HJlImepJN5EqxPW3c7JlWM6Ww5a
        pzijJaLr3INbI43QRGodgp64OLCIu6k=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 23 Jul 2020 23:09:15 +0200
From:   Michael Walle <michael@walle.cc>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org,
        dl-linux-imx <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
In-Reply-To: <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
User-Agent: Roundcube Webmail/1.4.7
Message-ID: <332a98a376e4becf9b10910138034be4@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2020-06-25 14:56, schrieb Marc Kleine-Budde:
> On 6/25/20 2:37 PM, Michael Walle wrote:
>> Am 2020-06-02 12:15, schrieb Michael Walle:
>>> Hi Marc,
>>> 
>>> Am 2020-04-16 11:41, schrieb Joakim Zhang:
>>>> Hi Marc,
>>>> 
>>>> How about FlexCAN FD patch set, it is pending for a long time. Many
>>>> work would base on it, we are happy to see it in upstream mainline
>>>> ASAP.
>>>> 
>>>> Michael Walle also gives out the test-by tag:
>>>> 	Tested-by: Michael Walle <michael@walle.cc>
>>> 
>>> There seems to be no activity for months here. Any reason for that? 
>>> Is
>>> there anything we can do to speed things up?
>> 
>> ping.. There are no replies or anything. Sorry but this is really
>> annoying and frustrating.
>> 
>> Marc, is there anything wrong with the flexcan patches?
> 
> I've cleaned up the patches a bit, can you test this branch:
> 
> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=flexcan

Ping. Could we please try to get this into next soon?

See also
https://lore.kernel.org/netdev/20200629181809.25338-1-michael@walle.cc/

-michael
