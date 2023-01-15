Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7247566B01A
	for <lists+netdev@lfdr.de>; Sun, 15 Jan 2023 10:16:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230050AbjAOJQc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 15 Jan 2023 04:16:32 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:40186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229993AbjAOJQb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 15 Jan 2023 04:16:31 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F8EE3588
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 01:16:30 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 1B0EA60C6E
        for <netdev@vger.kernel.org>; Sun, 15 Jan 2023 09:16:30 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A2886C433D2;
        Sun, 15 Jan 2023 09:16:28 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1673774189;
        bh=D9X55srrEnyQm8jV2HeSDVVrwZcNjWNfIg6dBEl7vSg=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=cAvqkMzeZF+fkTH4k/QvguMYAw9zxlZAkeAiHzpaevOVpaghNSiMoW1iaG/6crHup
         ei/J0C/y5LxaEBX9sNxUEGNwlhpFPVcgX12lscefcBXfepBHwFIucrsvcGKhA2np72
         Y/ZOkret4kix0wc43BAc3mQmwSFRC0QL2mg0Ha+3AR9STLgJ2pNRoqdYw7k7fz4BQJ
         N4RbsHG5DRtum+Il5zcidAfmSFPKN4s26955sCaQ5MbHjYI2jo+Zmr76kSdS8zFvmY
         tUNwbME5/bjo1trNw1yb79sVYguDPuDaG8loeV+yzFOcS+oP2lJIOLAoF5R98CU6D1
         CLhlPhIG3mj5Q==
Date:   Sun, 15 Jan 2023 11:16:24 +0200
From:   Leon Romanovsky <leon@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, kuba@kernel.org,
        pabeni@redhat.com, edumazet@google.com, michael.chan@broadcom.com,
        yisen.zhuang@huawei.com, salil.mehta@huawei.com,
        jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        tariqt@nvidia.com, saeedm@nvidia.com, idosch@nvidia.com,
        petrm@nvidia.com, mailhol.vincent@wanadoo.fr,
        jacob.e.keller@intel.com, gal@nvidia.com
Subject: Re: [patch net-next v4 00/10] devlink: linecard and reporters
 locking cleanup
Message-ID: <Y8PEaPtKkcbNknNM@unreal>
References: <20230111090748.751505-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20230111090748.751505-1-jiri@resnulli.us>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 11, 2023 at 10:07:38AM +0100, Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> This patchset does not change functionality.

This series causes to some glitches in our CI. Jiri is looking into it.

Thanks
