Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 84322698BFF
	for <lists+netdev@lfdr.de>; Thu, 16 Feb 2023 06:31:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229656AbjBPFbP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 16 Feb 2023 00:31:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33640 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229740AbjBPFbO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 16 Feb 2023 00:31:14 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 047762E837;
        Wed, 15 Feb 2023 21:30:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 89B3061E6F;
        Thu, 16 Feb 2023 05:30:54 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99ECEC433D2;
        Thu, 16 Feb 2023 05:30:53 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676525454;
        bh=1VsPNnYeRFvE9WehIWeJyF9w+0mF9+1lmQFmtiNLZoQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=j/GQNyvYJbKk1PnOHPcLWmiwF/gsKDdIyzYfoTBbIkdJxj9jv8iFj1NuQHkZ7gAtr
         /xJQSyGQK1LN7n6Sd8wv2X6/lVCTdMWoIbUQelCg8+X2U4NXAR0zSbxNzdKGlkS9bD
         RBxtC8rbbXYdaLEbE3NiEY1ofdEs3WdaBHAWolfH/ogt5njCaw4uuDdtFe9uw8qhWW
         GqeuDZG8lkopfwm9StpB81BYxhHd6db+d84tTOdwl2YnzQFdYzbR3b42e/6ihjru9P
         ckhZ0yQwQZrwpNbrURHW6J/BwlcqltfMn02uWG9SD0pnTMeQsP2LPa8H6bSJj0tv9G
         YOnbHkC+pWXPQ==
Date:   Wed, 15 Feb 2023 21:30:52 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Horatiu Vultur <horatiu.vultur@microchip.com>
Cc:     <netdev@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <davem@davemloft.net>, <edumazet@google.com>, <pabeni@redhat.com>,
        <UNGLinuxDriver@microchip.com>
Subject: Re: [PATCH net-next] net: lan966x: Use automatic selection of VCAP
 rule actionset
Message-ID: <20230215213052.6ecea372@kernel.org>
In-Reply-To: <20230214084206.1412423-1-horatiu.vultur@microchip.com>
References: <20230214084206.1412423-1-horatiu.vultur@microchip.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Feb 2023 09:42:06 +0100 Horatiu Vultur wrote:
> Now the VCAP API automatically selects the action set, therefore is
> not needed to be hardcoded anymore to hardcode the action in the
> lan966x. Therefore remove this.

The commit message needs some attention here.
While at it - instead of saying "now" could you provide the commit
reference? E.g. "Since commit $hash ("$title") the VCAP API...".
