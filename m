Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B95D355719D
	for <lists+netdev@lfdr.de>; Thu, 23 Jun 2022 06:42:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229744AbiFWEkD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 23 Jun 2022 00:40:03 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55492 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229656AbiFWDCS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 22 Jun 2022 23:02:18 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6CC1F11E
        for <netdev@vger.kernel.org>; Wed, 22 Jun 2022 20:02:16 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 179AEB821B5
        for <netdev@vger.kernel.org>; Thu, 23 Jun 2022 03:02:15 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8BAAFC34114;
        Thu, 23 Jun 2022 03:02:13 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655953333;
        bh=pXbB6EtiPvaKzLV16OpFcp5x6sNtO7dgF89KjXEaVjE=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=FDQ2jOzz7TPG/l2AegW/NOPquZ/FtW6nB85wHANW56HXKoIGko5GjRqE9U7D3SGL8
         jV1w+qKJEsTtgl2DTLvEFBuJgl8QbvXTEngRT6RI6gSSiuMyGiIxI4Xl/O6jRzj1MH
         gMuAV+vErdlv9IaA2OwTtk4n1REjMit6kfF3oKNLHU9ymbBjVhey+Q5UslX6kij9kz
         t5uptftixes9PT8PV9CeRBhD3QeCUSZalccmViEtATpc5mVDhCyFylFdb+okcYQTZX
         /SrP6FS0dHQc+TPFgiLv4dFtwfCNEwjIx3fcnagI+W+e82kgCCRhdO2iUhM+Yhdj8i
         PhToHvvC6R9ng==
Date:   Wed, 22 Jun 2022 20:02:12 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Sixiang Chen <sixiang.chen@corigine.com>
Subject: Re: [PATCH net-next] nfp: add 'ethtool --identify' support
Message-ID: <20220622200212.70d9555d@kernel.org>
In-Reply-To: <20220622083938.291548-1-simon.horman@corigine.com>
References: <20220622083938.291548-1-simon.horman@corigine.com>
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

On Wed, 22 Jun 2022 10:39:38 +0200 Simon Horman wrote:
> From: Sixiang Chen <sixiang.chen@corigine.com>
> 
> Add support for ethtool -p|--identify
> by enabling blinking of the panel LED if supported by the NIC firmware.
> 
> Signed-off-by: Sixiang Chen <sixiang.chen@corigine.com>
> Signed-off-by: Simon Horman <simon.horman@corigine.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>
