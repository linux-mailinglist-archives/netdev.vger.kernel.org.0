Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 119015E57AC
	for <lists+netdev@lfdr.de>; Thu, 22 Sep 2022 02:57:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229459AbiIVA5j (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 21 Sep 2022 20:57:39 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40926 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229496AbiIVA5i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 21 Sep 2022 20:57:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03CAC9AFE9;
        Wed, 21 Sep 2022 17:57:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id AA98EB83383;
        Thu, 22 Sep 2022 00:57:33 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id F0CCDC433D6;
        Thu, 22 Sep 2022 00:57:31 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1663808252;
        bh=4HCrQTrZr+LgYkW3VWx0hPIfbvuWqqEzQIsHqCMNyaw=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=bW7aX3Z+OfnfRyOvCzxSZ1oHdfSdrcgvQRC/RRX0zw0L7miameCp3FMimK1a/Mo80
         aAD3nP9CcRDyGYsf3aDtrFVDWw7ekjO5UFIj4jkf0FPTHqOR/FoVC30DPs9IF6jd5C
         emhkKOGljKjqIw/M3stSvLv8yc0pSCqVPAGwgLCHVHsQO5rPuFrw40N/c4lNOgqi8E
         G6AGiPZmjoVkzMpnRy46R/+phURgsT8JAENY+Mg05GyCD3Swy4saY976+cCty/pNGR
         P64f/+AB8ijx8N3pEKnUK8rDqtl+7G56LBgjJWXidF3AJgysDnWQCG71ddS5r0cUfA
         bYf344WQ4UZgg==
Date:   Wed, 21 Sep 2022 17:57:30 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Gerhard Engleder <gerhard@engleder-embedded.com>
Cc:     davem@davemloft.net, robh+dt@kernel.org, netdev@vger.kernel.org,
        devicetree@vger.kernel.org
Subject: Re: [PATCH net-next 3/7] tsnep: Move interrupt from device to queue
Message-ID: <20220921175730.7d69d5e5@kernel.org>
In-Reply-To: <20220915203638.42917-4-gerhard@engleder-embedded.com>
References: <20220915203638.42917-1-gerhard@engleder-embedded.com>
        <20220915203638.42917-4-gerhard@engleder-embedded.com>
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

On Thu, 15 Sep 2022 22:36:33 +0200 Gerhard Engleder wrote:
> +	const char *name = queue->adapter->netdev->name;

nit: netdev_name()
