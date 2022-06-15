Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 54C3354D568
	for <lists+netdev@lfdr.de>; Thu, 16 Jun 2022 01:40:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346801AbiFOXiA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 15 Jun 2022 19:38:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52814 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241580AbiFOXh6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 15 Jun 2022 19:37:58 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B68CD186C9
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 16:37:57 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B231B821FA
        for <netdev@vger.kernel.org>; Wed, 15 Jun 2022 23:37:56 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B5D26C3411A;
        Wed, 15 Jun 2022 23:37:54 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1655336275;
        bh=nRU/sJQxNmyrVVA3TXnQhxFaIH2aMAbsgA8XkGTVyIk=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fjNDVv5NE8ATHgVuacooQs0plfRlAiCKPlhYwNboBM/9JISJKG0dBZD5ooVLSaU3g
         GbJ1JlLgyvqO56MYJGiqcW0jmp2PswYBJzqEoEDwLmIb7DBoqJI+MOrPzKwUGERXh4
         AE/AIDLK2TFrepNInw1zeXwoZc2V79duRbQafWkih4s7/umVuCivY5QNaKIGhKdSFz
         Tew0t9dVH8dKIWd/fjxXTGEnmbjF1/VLH24Wh2F2Ye1hco5Pi/leD28O/s/iz8vY7C
         SnxAJIXdH+S5ZV2LbmQGdn8iKCL0IfxGLRGs8YTjid6WweZCRlzPBm0WIhMwxNRAPo
         b7Eys9LKqMwdg==
Date:   Wed, 15 Jun 2022 16:37:53 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com
Subject: Re: [patch net-next 01/11] devlink: introduce nested devlink entity
 for line card
Message-ID: <20220615163753.56e65d39@kernel.org>
In-Reply-To: <20220614123326.69745-2-jiri@resnulli.us>
References: <20220614123326.69745-1-jiri@resnulli.us>
        <20220614123326.69745-2-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-8.3 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 14 Jun 2022 14:33:16 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> For the purpose of exposing device info and allow flash updated which is
> going to be implemented in follow-up patches, introduce a possibility
> for a line card to expose relation to nested devlink entity. The nested
> devlink entity represents the line card.
> 
> Example:
> 
> $ devlink lc show pci/0000:01:00.0 lc 1
> pci/0000:01:00.0:
>   lc 1 state active type 16x100G nested_devlink auxiliary/mlxsw_core.lc.0
>     supported_types:
>        16x100G
> $ devlink dev show auxiliary/mlxsw_core.lc.0
> auxiliary/mlxsw_core.lc.0
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Acked-by: Jakub Kicinski <kuba@kernel.org>

Thanks!
