Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 4EB21572B0C
	for <lists+netdev@lfdr.de>; Wed, 13 Jul 2022 03:46:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233846AbiGMBp7 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 Jul 2022 21:45:59 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48418 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230085AbiGMBpv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 Jul 2022 21:45:51 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 1CFCCD4479
        for <netdev@vger.kernel.org>; Tue, 12 Jul 2022 18:45:51 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id A558861962
        for <netdev@vger.kernel.org>; Wed, 13 Jul 2022 01:45:50 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id AB34FC3411E;
        Wed, 13 Jul 2022 01:45:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1657676750;
        bh=uqnsUlQhzbS0z8F8G1yJT9K4iE+FZ/i3coa9r9n43u4=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=J0HaFnscLdMNucIiMX88MQz9SLZTEF69hmL5+zzra2Y7dMRcHusceF+pnVtUzfp0Z
         MWQ8NBwGL1Fpg8WJVWy9mc2DdUKdM3DxKziNdKv3lIBTGdwmO69w6yGEeG4kwouOxS
         PbagOEKtm7AouSZhY6r40apgUN6a0d9SanqxErc9kzJIhWeoi7Ujwl8TPrNTZrDKSq
         tIYpeYmEBS9owPQnkPjzhgS6LoDm+1vHsxq08wKiLqd4bjeIElUdTUaUKLshRsbLCb
         n+aYsh46tjlhEB9IdI0GFwVMjZxyo7A72lul2qUHoY7qIEbzYfaF+ZFh86M+RubI2X
         eEW4mYnzT5QtA==
Date:   Tue, 12 Jul 2022 18:45:40 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com, mlxsw@nvidia.com, saeedm@nvidia.com,
        moshe@nvidia.com
Subject: Re: [patch net-next 0/3] net: devlink: couple of trivial fixes
Message-ID: <20220712184540.16fe6ea9@kernel.org>
In-Reply-To: <20220712104853.2831646-1-jiri@resnulli.us>
References: <20220712104853.2831646-1-jiri@resnulli.us>
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

On Tue, 12 Jul 2022 12:48:50 +0200 Jiri Pirko wrote:
> Just a couple of trivial fixes I found on the way.

Acked-by: Jakub Kicinski <kuba@kernel.org>
