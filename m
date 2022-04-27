Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A7276512514
	for <lists+netdev@lfdr.de>; Thu, 28 Apr 2022 00:09:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231383AbiD0WMP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 Apr 2022 18:12:15 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37568 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229937AbiD0WMO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 Apr 2022 18:12:14 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0F7C685967;
        Wed, 27 Apr 2022 15:09:02 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id D983422249;
        Thu, 28 Apr 2022 00:08:59 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1651097340;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=L8xYu1iXgm+TYcxL4faL06Ceulm834J452X3VtAcUW4=;
        b=DVXC8FARH4/3NAcp7WtDd1Hh+MXaxKAk09VGK3USqhkZZuh3h/XpFacEyCibKH/srRIX2k
        TzkVgW4nIzUa5Glqh3x+PkJim4Z8qrf33q2SKcLY4rjt37VsATmMnJQhIoX7SsdwB5cs0H
        IGq1VKTXpn6XvX+1gQ9Rs8gq+lpyZks=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 28 Apr 2022 00:08:59 +0200
From:   Michael Walle <michael@walle.cc>
To:     Florian Fainelli <f.fainelli@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        Andrew Lunn <andrew@lunn.ch>,
        Heiner Kallweit <hkallweit1@gmail.com>,
        Russell King <linux@armlinux.org.uk>, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1 3/3] net: phy: micrel: add coma mode GPIO
In-Reply-To: <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
References: <20220427214406.1348872-1-michael@walle.cc>
 <20220427214406.1348872-4-michael@walle.cc>
 <652a5d64-4f06-7ac8-a792-df0a4b43686f@gmail.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <635fd80542e089722e506bba0ff390ff@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-04-28 00:06, schrieb Florian Fainelli:
> On 4/27/2022 2:44 PM, Michael Walle wrote:
>> The LAN8814 has a coma mode pin which puts the PHY into isolate and
>> power-dowm mode. Unfortunately, the mode cannot be disabled by a
s/dowm/down/

>> register. Usually, the input pin has a pull-up and connected to a GPIO
>> which can then be used to disable the mode. Try to get the GPIO and
>> deassert it.
> 
> Poor choice of word, how about deep sleep, dormant, super isolate?

Which one do you mean? Super isolate sounded like broadcom wording ;)

-michael
