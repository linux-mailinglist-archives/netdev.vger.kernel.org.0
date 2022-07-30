Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 6792158582D
	for <lists+netdev@lfdr.de>; Sat, 30 Jul 2022 05:10:18 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231173AbiG3DEl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 29 Jul 2022 23:04:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:43014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230251AbiG3DEi (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 29 Jul 2022 23:04:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2D430BE00
        for <netdev@vger.kernel.org>; Fri, 29 Jul 2022 20:04:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id B4970B82A2E
        for <netdev@vger.kernel.org>; Sat, 30 Jul 2022 03:04:36 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 0557BC433D6;
        Sat, 30 Jul 2022 03:04:34 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1659150275;
        bh=5Khruul0BPsP1wOrcoFAWPXsHf2V3FUxd/jAbFI32kA=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=A1N8ZOvfyUhjlWlykmnnajFULj7root0TrRfRTk08UMMpJnPrxLaYliAFyhmB8+VA
         z3cYu845UW2rYWdXnXLQ83HuHEd2L9PT7H06M215NHswKGdCxIL78SAIhuI2qjbOfD
         FrGEmxF0iHYrG4q3RDxgF3qME5Salvzilmh95rzz4wr9d+SD7MwU1s2+TWbLxcj7ME
         CGkwU9GyJhM5Rbl+ox6x1zLIUHJ+VVC3ka3FBVGx3E+z7Fg6xGjlYMJgSpVNPYZZHQ
         mkF8OJ8C/aWWmzFQs6+QxhKAd7+EPoGYZYwdz2aqbzZeYmR2tADprvvZTsVBM8mp4x
         1dUHV+CY8OPZw==
Date:   Fri, 29 Jul 2022 20:04:34 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>, idosch@nvidia.com, leon@kernel.org,
        moshe@nvidia.com
Cc:     netdev@vger.kernel.org, davem@davemloft.net, petrm@nvidia.com,
        pabeni@redhat.com, edumazet@google.com, mlxsw@nvidia.com,
        saeedm@nvidia.com, tariqt@nvidia.com
Subject: Re: [patch net-next 0/4] net: devlink: allow parallel commands on
 multiple devlinks
Message-ID: <20220729200434.4c20db10@kernel.org>
In-Reply-To: <20220729071038.983101-1-jiri@resnulli.us>
References: <20220729071038.983101-1-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 29 Jul 2022 09:10:34 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Aim of this patchset is to remove devlink_mutex and eventually to enable
> parallel ops on devlink netlink interface.

Let's do this! Worse comes to worst it's a relatively small revert.

Reviewed-by: Jakub Kicinski <kuba@kernel.org>

Thanks to everyone involved!
