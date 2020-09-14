Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5CD62268F76
	for <lists+netdev@lfdr.de>; Mon, 14 Sep 2020 17:17:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725997AbgINPRS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 14 Sep 2020 11:17:18 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45254 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725976AbgINPQi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 14 Sep 2020 11:16:38 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 11338C061788;
        Mon, 14 Sep 2020 08:16:38 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D571F22E0A;
        Mon, 14 Sep 2020 17:16:35 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1600096595;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ZHXHeATOvo3EWdsgocs84fKg710EwDFYuvjVR/+Sbic=;
        b=YDNuLmTAKkhGaUPGxCJByNi461fA2yWa9kSFB90BWHiYeSbT4h47auq0umzyLXwUBlu2B9
        DOR3Y3P0HWcskpyiKTEROYRDFK67VggDbpNl9VlT4daFSGLlYfWJ6QZsgVrqMXxLY6PcqF
        EkXDQpoZestu7BDtw4mppw9Gd2G5/XQ=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Mon, 14 Sep 2020 17:16:35 +0200
From:   Michael Walle <michael@walle.cc>
To:     Marc Kleine-Budde <mkl@pengutronix.de>
Cc:     Joakim Zhang <qiangqing.zhang@nxp.com>, linux-can@vger.kernel.org,
        dl-linux-imx <linux-imx@nxp.com>, netdev@vger.kernel.org
Subject: Re: [PATCH linux-can-next/flexcan] can: flexcan: fix TDC feature
In-Reply-To: <332a98a376e4becf9b10910138034be4@walle.cc>
References: <20200416093126.15242-1-qiangqing.zhang@nxp.com>
 <20200416093126.15242-2-qiangqing.zhang@nxp.com>
 <DB8PR04MB6795F7E28A9964A121A06140E6D80@DB8PR04MB6795.eurprd04.prod.outlook.com>
 <d5579883c7e9ab3489ec08a73c407982@walle.cc>
 <39b5d77bda519c4d836f44a554890bae@walle.cc>
 <e38cf40b-ead3-81de-0be7-18cca5ca1a0c@pengutronix.de>
 <332a98a376e4becf9b10910138034be4@walle.cc>
User-Agent: Roundcube Webmail/1.4.8
Message-ID: <64ec076a31c12218542cfa4fb081e3a7@walle.cc>
X-Sender: michael@walle.cc
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Marc,

Am 2020-07-23 23:09, schrieb Michael Walle:
> Am 2020-06-25 14:56, schrieb Marc Kleine-Budde:
>> On 6/25/20 2:37 PM, Michael Walle wrote:
>>> Am 2020-06-02 12:15, schrieb Michael Walle:
>>>> Hi Marc,
>>>> 
>>>> Am 2020-04-16 11:41, schrieb Joakim Zhang:
>>>>> Hi Marc,
>>>>> 
>>>>> How about FlexCAN FD patch set, it is pending for a long time. Many
>>>>> work would base on it, we are happy to see it in upstream mainline
>>>>> ASAP.
>>>>> 
>>>>> Michael Walle also gives out the test-by tag:
>>>>> 	Tested-by: Michael Walle <michael@walle.cc>
>>>> 
>>>> There seems to be no activity for months here. Any reason for that? 
>>>> Is
>>>> there anything we can do to speed things up?
>>> 
>>> ping.. There are no replies or anything. Sorry but this is really
>>> annoying and frustrating.
>>> 
>>> Marc, is there anything wrong with the flexcan patches?
>> 
>> I've cleaned up the patches a bit, can you test this branch:
>> 
>> https://git.kernel.org/pub/scm/linux/kernel/git/mkl/linux-can-next.git/log/?h=flexcan
> 
> Ping. Could we please try to get this into next soon?
> 
> See also
> https://lore.kernel.org/netdev/20200629181809.25338-1-michael@walle.cc/

Ping, another 2.5 months without any activity on this :(

-michael
