Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0E83359AFFA
	for <lists+netdev@lfdr.de>; Sat, 20 Aug 2022 21:47:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229550AbiHTTpK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 20 Aug 2022 15:45:10 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36142 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229488AbiHTTpJ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 20 Aug 2022 15:45:09 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A5E9433A20
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 12:45:08 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 6B882B80AE8
        for <netdev@vger.kernel.org>; Sat, 20 Aug 2022 19:45:07 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 91C4AC433C1;
        Sat, 20 Aug 2022 19:45:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1661024706;
        bh=1ZTE9W9mK9qGGqpnuzK1al3wLyvD4TU0e0kL6I/GK5s=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=ah2WAX4YoOEBVcSjx22hO817Mf6TEHhHmRTC39Q3jAokRXE/95VwQv1xon98SwoWB
         bhLT71qW6R/gyk0pKLpUJ0RLrUXr0b+mV7wr8mON/V8g2bxIUhPing7Qv7FjvX/YmR
         iimptJCURNfn9ftBPG5iygKEBQdmMf8ofJN77htSIL71MzyW7LDNWr0w9ySIbo6C/o
         VWaryhHXPAJbTu2LXm3og1xRI93II6SYCtCk0EnVoe0lnQZM+IsZ4OnHbvZgIqIBt8
         G1naghDFmDPYgqP6QYxKQ6oyReTR4NBQYvMZDI3IZOVvAeZQkfc38W6ipeyAfrYacr
         4j7abVtcohjew==
Date:   Sat, 20 Aug 2022 12:44:59 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, idosch@nvidia.com,
        petrm@nvidia.com, pabeni@redhat.com, edumazet@google.com,
        mlxsw@nvidia.com, saeedm@nvidia.com, tariqt@nvidia.com,
        leon@kernel.org, moshe@nvidia.com
Subject: Re: [patch net-next 4/4] net: devlink: enable parallel ops on
 netlink interface
Message-ID: <20220820124459.44bf1677@kernel.org>
In-Reply-To: <20220729071038.983101-5-jiri@resnulli.us>
References: <20220729071038.983101-1-jiri@resnulli.us>
        <20220729071038.983101-5-jiri@resnulli.us>
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

On Fri, 29 Jul 2022 09:10:38 +0200 Jiri Pirko wrote:
> From: Jiri Pirko <jiri@nvidia.com>
> 
> As the devlink_mutex was removed and all devlink instances are protected
> individually by devlink->lock mutex, allow the netlink ops to run
> in parallel and therefore allow user to execute commands on multiple
> devlink instances simultaneously.

Could you update the "Locking" section of
Documentation/networking/devlink/index.rst
with the full info and recommendations?
