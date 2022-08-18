Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 279F05986DB
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 17:06:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1344132AbiHRPGb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 11:06:31 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35854 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1344036AbiHRPG2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 11:06:28 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C58BD6C746;
        Thu, 18 Aug 2022 08:06:27 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 0F05E22239;
        Thu, 18 Aug 2022 17:06:26 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1660835186;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Qcax6uaZsHPWuFNQE145mYTHuKllWtPuyOe94GRGP74=;
        b=aZ/rKsJxvj0xLLTZaOHgSTD/bLc/LFZygPZbFeFDS/C/2wSym0L+eWpKR3kepF14U6jLJS
        gNCsX8nrQv6V517yp2hEFtHcyzO7CqqYdf2eeTQenZBmAzZ647NTg2qnGKGiuWsy1BM4TB
        H//261q8kXUkPSmwocCx0Gx3bJyyM+Y=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Aug 2022 17:06:25 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 3/3] arm64: dts: ls1028a: enable swp5 and eno3
 for all boards
In-Reply-To: <20220818140519.2767771-4-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
 <20220818140519.2767771-4-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <6ad1c08e44a9a20399e706fced8218cd@walle.cc>
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

Am 2022-08-18 16:05, schrieb Vladimir Oltean:
> In order for the LS1028A based boards to benefit from support for
> multiple CPU ports, the second DSA master and its associated CPU port
> must be enabled in the device trees. This does not change the default
> CPU port from the current port 4.
> 
> Signed-off-by: Vladimir Oltean <vladimir.oltean@nxp.com>

Acked-by: Michael Walle <michael@walle.cc>

