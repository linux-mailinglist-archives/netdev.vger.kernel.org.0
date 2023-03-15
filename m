Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D2C2A6BAA07
	for <lists+netdev@lfdr.de>; Wed, 15 Mar 2023 08:52:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231968AbjCOHwn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Mar 2023 03:52:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53984 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231544AbjCOHwW (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Mar 2023 03:52:22 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id C7ECB738B3;
        Wed, 15 Mar 2023 00:51:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 6022861BBC;
        Wed, 15 Mar 2023 07:51:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5FBC2C433EF;
        Wed, 15 Mar 2023 07:51:50 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1678866710;
        bh=YfFQqq75awBd7Pw++4x+oSxaVgIPQsuzmuaYg4h2dRo=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=RFZynXac3BciEANW6BVxP645V8F9vniI3XPvinqTe2xrkKMt5FTf1eE/xPqusxdND
         MdUh7YMdHx6r2kyPBBcP75ofw6FasMycORtVF6/7hOMZzFIABkcfK8kkrpl4hRbQrA
         +3W1NUgPnkk4EO/4PM2ZDhgm4aPYwQ7GjD6TiUgW41mPYe4fgQZsTUBkvSRqiBocMH
         xSbvy1bHKnQbXtVCkG+wCUIXQ8j7d7d7oT2G2zJiRe/oyD26JuznPrUOQjWgI8ZRvj
         BgosuSJO8iLcOU16hf9sX8/yFL4fR+wDBhmW+HaZfabjr2k8yKbXPDyjf4hR5VdGF5
         z+lgzi+/69DAw==
Date:   Wed, 15 Mar 2023 00:51:49 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Sean Anderson <seanga2@gmail.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Eric Dumazet <edumazet@google.com>,
        Paolo Abeni <pabeni@redhat.com>, netdev@vger.kernel.org,
        Simon Horman <simon.horman@corigine.com>,
        linux-kernel@vger.kernel.org, kernel test robot <lkp@intel.com>,
        Dan Carpenter <error27@gmail.com>
Subject: Re: [PATCH net-next v3 8/9] net: sunhme: Inline error returns
Message-ID: <20230315005149.6e06c2bb@kernel.org>
In-Reply-To: <20230314003613.3874089-9-seanga2@gmail.com>
References: <20230314003613.3874089-1-seanga2@gmail.com>
        <20230314003613.3874089-9-seanga2@gmail.com>
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

On Mon, 13 Mar 2023 20:36:12 -0400 Sean Anderson wrote:
> Fixes: 96c6e9faecf1 ("sunhme: forward the error code from pci_enable_device()")

No such	commit in our trees :(
