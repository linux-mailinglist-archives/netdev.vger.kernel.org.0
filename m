Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A8A94636E8B
	for <lists+netdev@lfdr.de>; Thu, 24 Nov 2022 00:48:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229686AbiKWXsL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Nov 2022 18:48:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50306 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229479AbiKWXsK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Nov 2022 18:48:10 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 00CC25EFA1
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 15:48:09 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 8F5EA61F64
        for <netdev@vger.kernel.org>; Wed, 23 Nov 2022 23:48:09 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id D603DC433C1;
        Wed, 23 Nov 2022 23:48:08 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1669247289;
        bh=VE8XHUGXRTyM1DwDaLuWpsY9tTcMgvaTUVsiqTEXXtY=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Icgdpf5ITWBRk+8PT32qawFRIB0QodoOMkGV8jOsDhsYWlMMwy0jsl9UjNRye0yJb
         VaPfcQQqy5clBuyC4zLham/c1rSWpqe3vnQM7qthHtu8RO0eWmS59xKunS7a4j25me
         1qLdUG7aMe9MIqCq+HmmWSLBhrR+fjrsZaKRZrprPQntNhNZCn9He2NFVwFxdEbVN2
         YQH4ERSqXQgx5a5v8vfHmkSv09itytPc9zIV+IdJCuYyhr3fVQKvk9GbDEsSMC15RP
         YD5FJWvOSiAujAmG24dQLdnVrsxf4z/GFSeSRpscmU++5AffxfrvDjV7JDUkX0UykT
         FrRzWlHtRJ0nQ==
Date:   Wed, 23 Nov 2022 15:48:07 -0800
From:   Saeed Mahameed <saeed@kernel.org>
To:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
Cc:     "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Paolo Abeni <pabeni@redhat.com>,
        Eric Dumazet <edumazet@google.com>,
        Saeed Mahameed <saeedm@nvidia.com>, netdev@vger.kernel.org,
        Tariq Toukan <tariqt@nvidia.com>,
        Moshe Shemesh <moshe@nvidia.com>,
        Shay Drory <shayd@nvidia.com>, Maor Gottlieb <maorg@nvidia.com>
Subject: Re: [net 04/14] net/mlx5: cmdif, Print info on any firmware cmd
 failure to tracepoint
Message-ID: <Y36xN31vRfajwzgb@x130.lan>
References: <20221122022559.89459-1-saeed@kernel.org>
 <20221122022559.89459-5-saeed@kernel.org>
 <Y343E18Hoy24Jolg@boxer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline
In-Reply-To: <Y343E18Hoy24Jolg@boxer>
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 23 Nov 16:06, Maciej Fijalkowski wrote:
>On Mon, Nov 21, 2022 at 06:25:49PM -0800, Saeed Mahameed wrote:
>> From: Moshe Shemesh <moshe@nvidia.com>
>>
>> While moving to new CMD API (quiet API), some pre-existing flows may call the new API
>> function that in case of error, returns the error instead of printing it as previously done.
>> For such flows we bring back the print but to tracepoint this time for sys admins to
>> have the ability to check for errors especially for commands using the new quiet API.
>>
>
>WARNING: Possible unwrapped commit description (prefer a maximum 75 chars
>per line)
>

we don't enforce this in netdev, especially when you want to share output,
etc .. 

also for future reference in mlx5 we allow up to 95 chars per code line, we
got wide screens :P, so also please ignore these warnings.

chkpatch = "!./scripts/checkpatch.pl --max-line-length=95 --strict --show-types --ignore COMMIT_LOG_LONG_LINE,FILE_PATH_CHANGES,MACRO_ARG_REUSE,MACRO_ARG_PRECEDENCE"

