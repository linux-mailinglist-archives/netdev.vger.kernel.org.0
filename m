Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2698A585835
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:20:05 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S239854AbiG3DUD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:20:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiG3DUC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:20:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 853B567157;
        Fri, 29 Jul 2022 20:20:01 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2033A61DF1;
        Sat, 30 Jul 2022 03:20:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id DB269C433C1;
        Sat, 30 Jul 2022 03:19:59 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659151200;
        bh=tfSWoMkwODNxGSKsRUG2sf1d8iEa2jTje7Hk6HGFtbo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=NpfvAzBTjlgeEtINtYLbdRudI7auMNgzKMM5BxUIEK7PBV2+0MP7eUAOUW81QT1w4
         fRia9z5pQmXrkC8U5tnRqRx1azIOMuu0k36fk4pdtNsT8oc2n3MeFqflVtmQHClQ8v
         B/Xgho/+PofnvTQ0RMLJ/GIiblBrQbuUyDcachC/euGEQo91SedHadaXlxpqFpZGVx
         +Jc3Z7x9+YPxGCM0rhBFnik3nHsRNIqSHkrAMqp7BGJwbe4cNT1xrjPcEmgxpfRL7x
         0P7wSSbc9nhLvA5B1TPpoIeNqAVfBi8XwVrsC2Rcet8dAzCJAXvly2MxF4FGRuDpOj
         NZfYJ5rDNeNgw==
Date:   Fri, 29 Jul 2022 20:19:58 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     wei.fang@nxp.com
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V4 0/3] Add the fec node on i.MX8ULP platform
Message-ID: <20220729201958.307d8a86@kernel.org>
In-Reply-To: <20220726143853.23709-1-wei.fang@nxp.com>
References: <20220726143853.23709-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 Jul 2022 00:38:50 +1000 wei.fang@nxp.com wrote:
> From: Wei Fang <wei.fang@nxp.com>
> 
> Add the fec node on i.MX8ULP platfroms.
> And enable the fec support on i.MX8ULP EVK boards.

FWIW the dts patches do not apply cleanly to netdev so if someone wants
to take the whole thing please LMK/LUK otherwise we can take the schema
in separately for 5.20 and leave the rest to whoever.
