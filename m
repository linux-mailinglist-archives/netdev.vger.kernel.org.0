Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id AE6506D14B2
	for <lists+netdev@lfdr.de>; Fri, 31 Mar 2023 03:11:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229671AbjCaBLM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Mar 2023 21:11:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:59662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229505AbjCaBLL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Mar 2023 21:11:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DB866CC36;
        Thu, 30 Mar 2023 18:11:10 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 75920B82B48;
        Fri, 31 Mar 2023 01:11:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6D808C433EF;
        Fri, 31 Mar 2023 01:11:07 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1680225068;
        bh=30/StbXX4tOMYh7YN4vO/XXF1i3Qrgije1YIniKeCnw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=n8GWvp5mLbz6yVKHYEKm7jo1LKiFjd16bI48wjq9CH2RDvvCKjfIu9oGCjwFJLgkj
         AseL+XRPrsrS9A09n9XiUENyOrLz1YDoyG6s8CSfTDg2RQ89A9Djn0IofjWEma9gOY
         GUexQeSVqIEFPSYk5PT6Q3mQJWsEkd5FppU9gAdKjybfn02VVZpUU1SDiT8BC0EzTp
         2Pk0FEp/oIZtyT+6RjOOLwxOVMDVnWcBs5Dwo5TOzw0yBWJyH+WbF6f16/FvDXd+No
         YFqwZtteAdk8+SX0ck8GFtaWnfFpARFp2J/p1nXczETMLX1tpMYXKRp7qBcA+f0oko
         UKyvQN0X9+vLA==
Date:   Thu, 30 Mar 2023 18:11:06 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org
Cc:     "Peng Fan (OSS)" <peng.fan@oss.nxp.com>, wei.fang@nxp.com,
        shenwei.wang@nxp.com, xiaoning.wang@nxp.com, davem@davemloft.net,
        edumazet@google.com, pabeni@redhat.com, shawnguo@kernel.org,
        linux-imx@nxp.com, netdev@vger.kernel.org,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        Peng Fan <peng.fan@nxp.com>
Subject: Re: [PATCH] dt-bindings: net: fec: add power-domains property
Message-ID: <20230330181106.4ba1edd8@kernel.org>
In-Reply-To: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
References: <20230328061518.1985981-1-peng.fan@oss.nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-5.2 required=5.0 tests=DKIMWL_WL_HIGH,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,SPF_HELO_NONE,
        SPF_PASS autolearn=unavailable autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 28 Mar 2023 14:15:18 +0800 Peng Fan (OSS) wrote:
> From: Peng Fan <peng.fan@nxp.com>
> 
> Add optional power domains property
> 
> Signed-off-by: Peng Fan <peng.fan@nxp.com>

Rob, Krzysztof, this one still on your radar?
