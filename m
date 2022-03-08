Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 19F2C4D1D23
	for <lists+netdev@lfdr.de>; Tue,  8 Mar 2022 17:27:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240251AbiCHQ2H (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Mar 2022 11:28:07 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48228 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348373AbiCHQ1v (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Mar 2022 11:27:51 -0500
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 5620450474
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 08:26:54 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id E1D3561734
        for <netdev@vger.kernel.org>; Tue,  8 Mar 2022 16:26:53 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 080DDC340EB;
        Tue,  8 Mar 2022 16:26:52 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646756813;
        bh=8E7T0hYH/DECRnXdgxBhJyG7rCWiK9mPdDoaUfiCMN4=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=mGk72ypucJ/MQtVQeTCuFyI9t7FAFTLKEgpbUYhzqsoMp5l7d9Ox1Cd5tozZje8Me
         TAtXlYmjj1FThwOJHCecdTrZmCFZCLr+tWUwrALAqMyLA12Rbk/yrz6ZUsIHHvEAcv
         tOFZr2O/4AiogSfes9fSITmrlOBnrxPGMVdAp0nemHfFHnteStAWy/0g8E+HkBFPHj
         ZyGcRrG3UYO+ljCtuy7U481o/Bi4AuI+WCflgdZBHRvmoExj+naMyLmzBCUOxFrW+r
         epNa0nKxPjNYu5a8xhS/8IIbkBtqaPG6o2mRvllj/LnmjKay1M5gA5oX/FhqQPbe8f
         5k9Um2pzInAzg==
Message-ID: <8882d949-35bb-8fad-c047-92fb5091c33b@kernel.org>
Date:   Tue, 8 Mar 2022 09:26:49 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.2
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20220228015435.1328-1-dsahern@kernel.org>
 <Yh93f0XP0DijocNa@shredder> <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
 <YiYgPnn9wtXbOm0a@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <YiYgPnn9wtXbOm0a@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/7/22 8:09 AM, Ido Schimmel wrote:
> 
> I realize it was already merged (wasn't asking for academic purposes),
> but rather wanted you to verify that the patch is not needed on your end
> so that I could revert it. I can build with gcc/clang even without the
> patch. With the patch, the build is broken on Fedora as "yacc" is not a
> build dependency [1]. Verified this with a clean install of Fedora 35:
> Can't build iproute with this patch after running "dnf builddep
> iproute". Builds fine without it.
> 
> [1] https://src.fedoraproject.org/rpms/iproute/blob/rawhide/f/iproute.spec#_22

I booted a Fedora 35 VM and see what you mean. I can not find the
difference as to why Ubuntu 20.04 is ok and Fedora 35 is not, so I
reverted the patch.
