Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2972E4B6256
	for <lists+netdev@lfdr.de>; Tue, 15 Feb 2022 06:17:53 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231807AbiBOFR6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Feb 2022 00:17:58 -0500
Received: from mxb-00190b01.gslb.pphosted.com ([23.128.96.19]:49668 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229586AbiBOFR5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Feb 2022 00:17:57 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B3CAB95491;
        Mon, 14 Feb 2022 21:17:48 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3E899B817B0;
        Tue, 15 Feb 2022 05:17:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 798F4C340EC;
        Tue, 15 Feb 2022 05:17:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1644902265;
        bh=llfRZiS0nJDKckZ14/zXDlzRmqfPP6XX4LcakrfbBOg=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=LMlOsBVEr6D0Df7KS6ZUmW+EzpCNdalIPA323SnSZ+MgqIVv5GuvF/i0lGwv42uYs
         /QOZ5lLjelas5vVVWHoyA8x8xiJxHJTS6zq1h3xVWI0ngWO1jmFvlWDXayBlS7DjNF
         cGjxXyNm1avavzhu3071BtIGRYywyVkReO9FwhY2cTNwmvi7XTmOqyse7pDq19Obnp
         gFUZN2ShKEZEFJtgq3jTtHvZYTxIuo5v12I4YOYtrxFAJ4O+X9sAzwEi7Qe5cHW6R7
         HVrwQy+gAI8PNnsUN5hhINNb2Mjr6gGHNPT6i99R4MZmRuaqkYlu91ustfER0jnrsk
         qu0W+QONAUW8Q==
Date:   Mon, 14 Feb 2022 21:17:43 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Yevhen Orlov <yevhen.orlov@plvision.eu>
Cc:     netdev@vger.kernel.org,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        Mickey Rachamim <mickeyr@marvell.com>,
        Serhiy Pshyk <serhiy.pshyk@plvision.eu>,
        Taras Chornyi <tchornyi@marvell.com>,
        "David S. Miller" <davem@davemloft.net>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        Andrii Savka <andrii.savka@plvision.eu>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] net: marvell: prestera: Fix includes
Message-ID: <20220214211743.6fbd3075@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <20220214011228.5625-1-yevhen.orlov@plvision.eu>
References: <20220214011228.5625-1-yevhen.orlov@plvision.eu>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.2 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 14 Feb 2022 03:12:28 +0200 Yevhen Orlov wrote:
> Include prestera.h in prestera_hw.h, because it may contain common
> definitions.

*May*? Is prestera_hw.h using definitions from prestera.h today?
Dependencies between header files are best avoided completely.
