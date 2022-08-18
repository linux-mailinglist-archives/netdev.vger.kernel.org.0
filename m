Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 638B15986E7
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:09:08 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344087AbiHRPJC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:09:02 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42548 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344008AbiHRPJA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:09:00 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [176.9.125.105])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 654EA65261;
        Thu, 18 Aug 2022 08:08:59 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id DD36F2224D;
        Thu, 18 Aug 2022 17:08:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1660835337;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jILUvoK/4AEf5bTCKpEzMwlbbfJmxcZFklruzntVamw=;
        b=eGmR782JLnGqJKNqspUkU1vyHqk5kYPWehPZNE/MZ/AhjFRY0lTddJeoxyCAp81gQZFkjg
        qpofYnCMEW8U7yNU5BsQ2HR51e2VPKPuEARSwN2Z5A5wJyE3W5pjtTsyxaNZc6CVTGtxXN
        xrdtbNVz4rifSwjvNpuYC8OhB7sJh0Y=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Aug 2022 17:08:57 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Leo Li <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 2/3] arm64: dts: ls1028a: mark enetc port 3 as
 a DSA master too
In-Reply-To: <20220818144521.sctrmqcfzi6e6l3e@skbuf>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <20220818140519.2767771-3-vladimir.oltean@nxp.com>
 <f646670f8ebc64cf1a3080330d54d733@walle.cc>
 <20220818144521.sctrmqcfzi6e6l3e@skbuf>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <830a44530ce643aa111e74aa5815babf@walle.cc>
X-Sender: michael@walle.cc
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_BLOCKED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Am 2022-08-18 16:45, schrieb Vladimir Oltean:
> On Thu, Aug 18, 2022 at 04:44:28PM +0200, Michael Walle wrote:
>> status should be the last property, no?
> 
> idk, should it?

IIRC Shawn pointed that out. If I'm mistaken, then do it for the
consistency within fsl-ls1028a.dtsi :)

-michael
