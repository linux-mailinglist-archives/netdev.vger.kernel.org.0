Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 46BD25A1DFE
	for <lists+netdev@lfdr.de>; Fri, 26 Aug 2022 03:11:45 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S244060AbiHZBLn (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Aug 2022 21:11:43 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57288 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243837AbiHZBLl (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Aug 2022 21:11:41 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 20D79C59E1
        for <netdev@vger.kernel.org>; Thu, 25 Aug 2022 18:11:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id CE53AB82A67
        for <netdev@vger.kernel.org>; Fri, 26 Aug 2022 01:11:39 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 47389C433C1;
        Fri, 26 Aug 2022 01:11:38 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661476298;
        bh=1Vz7dYok02btWrXevN/6EiogNF0T7BjmRohFBb10lCM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=fwPyPxLMzrVbZ8T4TDLz0sf/qGLyIMlOiowWfcCY+dDNQnOwroEvDPTaMewU6fkgC
         QOPCLtCcTa5iWFXGPYTCj0WQfJthy2c4OZh7UDe08cjfZNmk9a+LPONyj/uw9tuQv2
         awjWtC4fVhIFRlXZCee52ePj3F3vIcXYMCUdu7zANHYM62NILVoHUnIfCJ0DArKXvf
         wMS9JwphuI4q6bdlws3Lr2YG8wVl2x86N+o7Hv1ulCw2THbCqeb3wnJeUjp+zlIaE2
         EPw4t1ZIah6LCM2ug2vkLTmjqFlT9nlMcKMLf92FDqFu/I6SEKrftqoFAkrsUF5N3P
         AV45J05ZzqxCg==
Date:   Thu, 25 Aug 2022 18:11:37 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, pabeni@redhat.com,
        edumazet@google.com
Subject: Re: [patch net-next] net: devlink: stub port params cmds for they
 are unused internally
Message-ID: <20220825181137.4a83b6e2@kernel.org>
In-Reply-To: <20220825082628.1285458-1-jiri@resnulli.us>
References: <20220825082628.1285458-1-jiri@resnulli.us>
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

On Thu, 25 Aug 2022 10:26:28 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> Follow-up the removal of unused internal api of port params made by
> commit 42ded61aa75e ("devlink: Delete not used port parameters APIs")
> and stub the commands and add extack message to tell the user what is
> going on.
> 
> If later on port params are needed, could be easily re-introduced,
> but until then it is a dead code.
> 
> Signed-off-by: Jiri Pirko <jiri@nvidia.com>

Why no extack on the dump, tho? Wouldn't iproute2 do dumps mostly?

With that answered/addressed:

Reviewed-by: Jakub Kicinski <kuba@kernel.org>
