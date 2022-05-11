Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 1C760524133
	for <lists+netdev@lfdr.de>; Thu, 12 May 2022 01:49:15 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1349477AbiEKXtM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 May 2022 19:49:12 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39470 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1349476AbiEKXtJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 May 2022 19:49:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8FC7E140C57
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 16:49:07 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 28F3CB82642
        for <netdev@vger.kernel.org>; Wed, 11 May 2022 23:49:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8C85BC340EE;
        Wed, 11 May 2022 23:49:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652312944;
        bh=EBZOdYaUDs8xUe7jyuGWf7TTOiP8GRmEEKzZ39ubbwU=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=m3M27QWtI2ssBP+PJTDf1LzJJWoDEnyQPPX7O/rQXwANROVVho+nZrPdeoLDMYipT
         U2KqZgTCuITX+zt/j4VI1FiTgK+a4ePH+BYST9OPmjTZulZHU63Y0njGbfsexoZ0qy
         N/F/6j2WlUtB9tTtvXHo3vPG8bnBLuS1FeJpGy+XMKtMCXK0t/UT3InKI9nOn4G1EU
         Kr4bupm+HDG4YIrAr8CpQoXWTKyy29SVeEiDtlS9ZrvdJp8fI8jFco3/GPrpM2RmUN
         I8k8v0yuN0JVxSpUO0MjW0WH+Ato1Od779q2WYhBs40GQuNMeOm3yabsr0OLhCxbFk
         kJ1nljruy76zA==
Date:   Wed, 11 May 2022 16:49:03 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Simon Horman <simon.horman@corigine.com>
Cc:     David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        oss-drivers@corigine.com, Bin Chen <bin.chen@corigine.com>
Subject: Re: [PATCH v2 net-next 0/2] *nfp: VF rate limit support
Message-ID: <20220511164903.075b01bc@kernel.org>
In-Reply-To: <20220511113932.92114-1-simon.horman@corigine.com>
References: <20220511113932.92114-1-simon.horman@corigine.com>
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

On Wed, 11 May 2022 13:39:30 +0200 Simon Horman wrote:
> this short series adds VF rate limiting to the NFP driver.
> 
> The first patch, as suggested by Jakub Kicinski, adds a helper
> to check that ndo_set_vf_rate() rate parameters are sane.
> It also provides a place for further parameter checking to live,
> if needed in future.
> 
> The second patch adds VF rate limit support to the NFP driver.
> It addresses several comments made on v1, including removing
> the parameter check that is now provided by the helper added
> in the first patch.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
