Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B6ADF682C11
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:58:08 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230193AbjAaL6H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:58:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54838 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230007AbjAaL6F (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:58:05 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 73D5029E03
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:58:03 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 26F0DB81BF7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:58:02 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5C049C433D2;
        Tue, 31 Jan 2023 11:58:00 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675166280;
        bh=/IKKY62jNocNp42l2ZkQRkhINaQ+YxN+5s1gQtHE8og=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=SPSJGuYAVxsxg+gJklWoqHoh+q5mHY3g3ZqfCOyRXBHwrO+I6MOpnulcXa/IOi9n+
         tarDOGWLtymuNlgvvZPE1CVJaEXrac3EnXE17/z4siIujq/2OLJEPyPzYNhK5TEmJf
         rMRMX9Ujd66w6DkyslNdDPT+9KAt4jLZEJSSB4ampOXD/4pB8XSkCorWsmBHd5lczf
         d7aPqSNiHP351IM3A6ayoXecQtRHbOcI8p8T+Etz9BleIijczZGp5CwWIjIfPIuksa
         vTDYowAGY7RAefwAcL2A9rFCeAOuSvon+lsBFsdHosKEaCZkH23W5gggTWQ3LofG88
         QX/OrZKIPXH6A==
Date:   Tue, 31 Jan 2023 13:57:56 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 2/3] devlink: remove "gen" from struct
 devlink_gen_cmd name
Message-ID: <Y9kCRK2NNnwClq+Z@unreal>
References: <20230131090613.2131740-1-jiri@resnulli.us>
 <20230131090613.2131740-3-jiri@resnulli.us>
 <Y9kA01okvtKYLDZ2@unreal>
 <Y9kBbPdGYN8awqVX@nanopsycho>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <Y9kBbPdGYN8awqVX@nanopsycho>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 12:54:20PM +0100, Jiri Pirko wrote:
> Tue, Jan 31, 2023 at 12:51:47PM CET, leon@kernel.org wrote:
> >On Tue, Jan 31, 2023 at 10:06:12AM +0100, Jiri Pirko wrote:
> >> From: Jiri Pirko <jiri@nvidia.com>
> >> 
> >> No need to have "gen" inside name of the structure for devlink commands.
> >> Remove it.
> >
> >And what about devl_gen_* names? Should they be renamed too?
> 
> Yep, see the next patch :)

Ohh, I would organize them differently.

Thanks
