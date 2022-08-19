Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 43E7E599335
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 04:53:52 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S242028AbiHSCxH (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 18 Aug 2022 22:53:07 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57478 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235159AbiHSCxG (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 18 Aug 2022 22:53:06 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8BC68CCE11
        for <netdev@vger.kernel.org>; Thu, 18 Aug 2022 19:53:05 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3D0F9B82557
        for <netdev@vger.kernel.org>; Fri, 19 Aug 2022 02:53:04 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 99D07C433D6;
        Fri, 19 Aug 2022 02:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660877582;
        bh=7Wk3MpufZk7C+KYUDzEM9422NJY03Ojf/N/CIOI37Po=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ExpmucKC151ojUFA58pA5hBJ/zYIpeE5PY/9SiAt+q0VxWvOmzjweOfiuIAS9N2uV
         g6BUH0jTXCm6y/Wfqd0VgeTTlCd9sLpJaTjt53qiRwYImnuTmF3aymzRD0u12jpfNQ
         CSQrvy0UFydLZgCSG8w+AmeVtmyjueTZuTl+kb2IkNXlO+xQL/7i0ZLQQ6Gdp3z0s4
         K/I+aNJp8eSKAkBhwnNKZRDulIY6/aQsO3pfI68RcCv5b+95afBKE8Hv45hhN4cEGr
         wnxjwjKbylrWU6d7kygPX04epgt+BXoanf+vGWgeyfPZuYqQodDV5ec7nz7SHsSsR9
         xRvoK3LF8pK6g==
Date:   Thu, 18 Aug 2022 19:53:01 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, saeedm@nvidia.com,
        jacob.e.keller@intel.com, vikas.gupta@broadcom.com,
        gospo@broadcom.com
Subject: Re: [patch net-next 4/4] net: devlink: expose default flash update
 target
Message-ID: <20220818195301.27e76539@kernel.org>
In-Reply-To: <20220818130042.535762-5-jiri@resnulli.us>
References: <20220818130042.535762-1-jiri@resnulli.us>
        <20220818130042.535762-5-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 18 Aug 2022 15:00:42 +0200 Jiri Pirko wrote:
> Allow driver to mark certain version obtained by info_get() op as
> "flash update default". Expose this information to user which allows him
> to understand what version is going to be affected if he does flash
> update without specifying the component. Implement this in netdevsim.

My intuition would be that if you specify no component you're flashing
the entire device. Is that insufficient? Can you explain the use case?

Also Documentation/ needs to be updated.
