Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CCC236A204F
	for <lists+netdev@lfdr.de>; Fri, 24 Feb 2023 18:11:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229504AbjBXRLv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Feb 2023 12:11:51 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42790 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229448AbjBXRLu (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Feb 2023 12:11:50 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 35BCF6A9F1
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 09:11:50 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id C9AA7B81A7F
        for <netdev@vger.kernel.org>; Fri, 24 Feb 2023 17:11:48 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4B356C433D2;
        Fri, 24 Feb 2023 17:11:47 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1677258707;
        bh=byFfpx+W9eb8UNYlXTlZEtStIg8F+sv2Nt1n1qMmUUM=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=TnbtR3Bb57fRWgLvSPSdue1BUStT6k5JiEbKjZHRi1ljF58YAjXLUbppskzdmty6Z
         cqEtk8QbIhaMyvr9jGdk7TBjP2HSsS+6PcJheIOea5EGFlt19YGnZant3IMMNsVmAf
         DaUP1nd5e2EzW33fAX4LnTJWUXiIVMTPsFAl+5Po93+I7Mkt4uutDX7+MSRAzZLmKV
         7QoCBbzzTxstLPiY9XvIsknk6Uz5v+iyR7HsLtEFfRpZPwnba+/ftnSK2rriosmrjw
         OY9/pGgDLfuwhDpjgAzxw+QY2bR/JufAFwBgGJoxU81fbx2F0rTmBSltloFzC4r117
         qLp+zccA3UkmQ==
Date:   Fri, 24 Feb 2023 09:11:46 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     dsahern@gmail.com, jhs@mojatatu.com, netdev@vger.kernel.org
Subject: Re: [PATCH iproute2] genl: print caps for all families
Message-ID: <20230224091146.39eae414@kernel.org>
In-Reply-To: <20230223192742.36fd977a@hermes.local>
References: <20230224015234.1626025-1-kuba@kernel.org>
        <20230223192742.36fd977a@hermes.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 23 Feb 2023 19:27:42 -0800 Stephen Hemminger wrote:
> What about JSON support. Is genl not json ready yet?

All the genl code looks quite dated, no JSON anywhere in sight :(
