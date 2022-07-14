Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 48A06574185
	for <lists+netdev@lfdr.de>; Thu, 14 Jul 2022 04:47:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231281AbiGNCrD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 13 Jul 2022 22:47:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48842 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229943AbiGNCrC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 13 Jul 2022 22:47:02 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1E89C240BF;
        Wed, 13 Jul 2022 19:47:02 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id B07B761D65;
        Thu, 14 Jul 2022 02:47:01 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 6A36BC34114;
        Thu, 14 Jul 2022 02:47:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657766821;
        bh=nB7hJESXwNha/HYprW0VOhfMuUPYF9+nG4W8gALJDuk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=UsAoTXV3W+fwVZNIsV/qycGf0mmNA7wiEIOqqLpZUZIb3Tv5xfgxnA0jc4DGUykIy
         mifysA9QP5UuGIuuzBzHB9n3loMD/84wTtrVo/sNDclYCaw6vTd1UJFBLoTaB+g7Sz
         Pcj/IveUpF9h8ZLK5ssAGRCGADdeb4H98B3vqoAI/XxWmtZrxxrKy2K+Fm+EFj8AFc
         sxVF87+MTv3OUDvuDnLdNM3CsG37D24+pK+uEExdyCfo4+SbLOShxx/cOanTUO70wW
         XvALg0dDc+KW3aQ3SmMKk6w5wKr7krg8lj7AtBOh7XrM1UsHOFtg23HIRe0suKyFWZ
         cbCoN/XveKp/w==
Date:   Wed, 13 Jul 2022 19:46:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Wei Fang <wei.fang@nxp.com>
Cc:     davem@davemloft.net, edumazet@google.com, pabeni@redhat.com,
        robh+dt@kernel.org, krzysztof.kozlowski+dt@linaro.org,
        shawnguo@kernel.org, s.hauer@pengutronix.de,
        netdev@vger.kernel.org, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel@pengutronix.de,
        festevam@gmail.com, linux-imx@nxp.com, peng.fan@nxp.com,
        ping.bai@nxp.com, sudeep.holla@arm.com,
        linux-arm-kernel@lists.infradead.org, aisheng.dong@nxp.com
Subject: Re: [PATCH V2 0/3] Add the fec node on i.MX8ULP platform
Message-ID: <20220713194659.45e410d2@kernel.org>
In-Reply-To: <20220711094434.369377-1-wei.fang@nxp.com>
References: <20220711094434.369377-1-wei.fang@nxp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 11 Jul 2022 19:44:31 +1000 Wei Fang wrote:
> Add the fec node on i.MX8ULP platfroms.
> And enable the fec support on i.MX8ULP EVK boards.

Something odd happened to this posting, there are multiple emails
with the same Message-ID. Could you please collect the acks and post 
a clean v3? If the intention is for the patches to go via the
networking tree please repost them with the tree name in the subject 
tag i.e. [PATCH net-next]
