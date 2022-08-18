Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6DDA4598667
	for <lists+netdev@lfdr.de>; Thu, 18 Aug 2022 16:51:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S245587AbiHROt7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 10:49:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58242 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S245520AbiHROtw (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 10:49:52 -0400
Received: from ssl.serverraum.org (ssl.serverraum.org [IPv6:2a01:4f8:151:8464::1:2])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A6D0A7DF5B;
        Thu, 18 Aug 2022 07:49:51 -0700 (PDT)
Received: from ssl.serverraum.org (web.serverraum.org [172.16.0.2])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ssl.serverraum.org (Postfix) with ESMTPSA id 9339A22239;
        Thu, 18 Aug 2022 16:49:49 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=walle.cc; s=mail2016061301;
        t=1660834189;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=jY1twBjLYosPm8HpbJJVDyZ0uNW0GmRMhPk2jKbPVEM=;
        b=m1/g13R6IY8xGEpW1NbvicdyrugCw4pwAPyzX+T8CAlW53fy5I7cEdt7i4Lf9w9ODAfEgf
        kITSbLpspvvFTJK+p+1P+gLAa9LP4zMyC3Sb6VM6jJvYkOAkTsUG9ZE4LsWvmK2Iph8dnP
        X7oITZLmqTOk6jYjztKpt+XCUtkF7uA=
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII;
 format=flowed
Content-Transfer-Encoding: 7bit
Date:   Thu, 18 Aug 2022 16:49:49 +0200
From:   Michael Walle <michael@walle.cc>
To:     Vladimir Oltean <vladimir.oltean@nxp.com>
Cc:     devicetree@vger.kernel.org, netdev@vger.kernel.org,
        Shawn Guo <shawnguo@kernel.org>, Li Yang <leoyang.li@nxp.com>,
        Rob Herring <robh+dt@kernel.org>,
        Krzysztof Kozlowski <krzysztof.kozlowski+dt@linaro.org>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH devicetree 0/3] NXP LS1028A DT changes for multiple switch
 CPU ports
In-Reply-To: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
References: <20220818140519.2767771-1-vladimir.oltean@nxp.com>
User-Agent: Roundcube Webmail/1.4.13
Message-ID: <8d3d96cdede2f1e40ed9ae5742a0468d@walle.cc>
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
> The Ethernet switch embedded within the NXP LS1028A has 2 Ethernet 
> ports
> towards the host, for local packet termination. In current device 
> trees,
> only the first port is enabled. Enabling the second port allows having 
> a
> higher termination throughput.

Is it used automatically or does the userspace has to configure 
something?

> Care has been taken that this change does not produce regressions when
> using updated device trees with old kernels that do not support 
> multiple
> DSA CPU ports. The only difference for old kernels will be the
> appearance of a new net device (for &enetc_port3) which will not be 
> very
> useful for much of anything.

Mh, I don't understand. Does it now cause regressions or not? I mean
besides that there is a new unused interface?

I was just thinking of that systemready stuff where the u-boot might
supply its (newer) device tree to an older kernel, i.e. an older debian
or similar.

-michael
