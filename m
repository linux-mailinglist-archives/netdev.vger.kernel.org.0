Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 9928D682C12
	for <lists+netdev@lfdr.de>; Tue, 31 Jan 2023 12:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229903AbjAaL6P (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 31 Jan 2023 06:58:15 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:54966 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229579AbjAaL6O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 31 Jan 2023 06:58:14 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 63A8D193D7
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 03:58:13 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 18E3CB81BF2
        for <netdev@vger.kernel.org>; Tue, 31 Jan 2023 11:58:12 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id E9C4CC433EF;
        Tue, 31 Jan 2023 11:58:09 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1675166290;
        bh=AEzKR8X0PS7Fxzp0Rdkk8kD7QUSSEc1LDlS7wNO7Zgs=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=NEP3wTGUcJvpIiFKGK21VfpJ7wUjsDBxysz4ID8cGfvpIF51J2SwLzHjfsgvUz5c4
         +Aavhm6uN28jLxUutM4b2md7gEE2ce1i2o1DpV7beaf4DJ9aOIcerLHZCDiN9+YcVN
         EQAcrkMab6YizS00MLcl6LVRkW+hp0KO/GVlvLD8HeQkVXaNgF8IQF/xHB3nY1gYFf
         PtbaHELWQYxUx0rkIDiyIgBpLdME9Mcvio47EOsrOTif1KTur18+9fJn2fNTFumyJ2
         xwU6kTPUg+ezn/5NNDWJoS7dlvZMI4EJjxjSd9le8N3SaOS52dW7mxABYUy+wu1xku
         gy4PFmHyDQaCA==
Date:   Tue, 31 Jan 2023 13:58:06 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, jacob.e.keller@intel.com
Subject: Re: [patch net-next 0/3] devlink: trivial names cleanup
Message-ID: <Y9kCTq//4yXyDSM1@unreal>
References: <20230131090613.2131740-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230131090613.2131740-1-jiri@resnulli.us>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jan 31, 2023 at 10:06:10AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This is a follow-up to Jakub's devlink code split and dump iteration
> helper patchset. No functional changes, just couple of renames to makes
> things consistent and perhaps easier to follow.
> 
> Jiri Pirko (3):
>   devlink: rename devlink_nl_instance_iter_dump() to "dumpit"
>   devlink: remove "gen" from struct devlink_gen_cmd name
>   devlink: rename and reorder instances of struct devlink_cmd
> 

Thanks,
Reviewed-by: Leon Romanovsky <leonro@nvidia.com>
