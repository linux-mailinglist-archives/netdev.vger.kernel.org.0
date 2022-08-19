Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2345C59A6D6
	for <lists+netdev@lfdr.de>; Fri, 19 Aug 2022 22:04:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1351658AbiHST4a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Aug 2022 15:56:30 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:34088 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231364AbiHST4a (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Aug 2022 15:56:30 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 01908C2EB6;
        Fri, 19 Aug 2022 12:56:28 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 987DC61662;
        Fri, 19 Aug 2022 19:56:28 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8B713C433C1;
        Fri, 19 Aug 2022 19:56:27 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1660938988;
        bh=R15Qb+OLlNqRZSGMU5MWR6KhlR+Gkm9K/IxVi/7+3NI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=g7epPLszBomNGPZHmWYjX/sFn+DFJP2v3I0z88Rg41CvtiNZimvc30ZKi8WldubBL
         ogmxBZiYt8B+ng9WKb7axSe1UPaL95g0m8lv4C/51eyR9oqubU3zMSpXbK8M4x8uto
         6SPZUGk/j67GElJuadY4p57kYTWow+T5ry5NRfrxsONkgbG5o/qKNcmZZox59qcgIK
         a0vp4hLmbGIJIWAWNXkilQ6RAVmiJAjxxPIhiSU/cMaIuZeqzjqCNMQhbyTVUQS2Xf
         JvcaKbPKnOfyKutIWf0seCu00Q/O4gTfS4mowLJo0pzH0AT7afEVic19iBUKtJfkj7
         2jK/CbG3vn82A==
Date:   Fri, 19 Aug 2022 12:56:26 -0700
From:   Jakub Kicinski <kuba@kernel.org>
To:     netdev@vger.kernel.org, davem@davemloft.net, edumazet@google.com,
        pabeni@redhat.com
Cc:     sdf@google.com, jacob.e.keller@intel.com, vadfed@fb.com,
        johannes@sipsolutions.net, jiri@resnulli.us, dsahern@kernel.org,
        stephen@networkplumber.org, fw@strlen.de, linux-doc@vger.kernel.org
Subject: Re: [RFC net-next 0/4] ynl: YAML netlink protocol descriptions
Message-ID: <20220819125626.6ebf7ccc@kernel.org>
In-Reply-To: <20220811022304.583300-1-kuba@kernel.org>
References: <20220811022304.583300-1-kuba@kernel.org>
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

On Wed, 10 Aug 2022 19:23:00 -0700 Jakub Kicinski wrote:
> Netlink seems simple and reasonable to those who understand it.
> It appears cumbersome and arcane to those who don't.

FWIW I put the work in progress code on GH hoping this will be more
engaging to user space devs who are a pretty important here:

https://github.com/kuba-moo/ynl

If anyone is interested in helping out, it'd be most welcome.
