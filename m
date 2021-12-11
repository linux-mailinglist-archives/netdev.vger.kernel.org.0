Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 3C15D471111
	for <lists+netdev@lfdr.de>; Sat, 11 Dec 2021 04:03:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235308AbhLKDHQ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 22:07:16 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33872 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229886AbhLKDHP (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 22:07:15 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9EEF0C061714;
        Fri, 10 Dec 2021 19:03:39 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id C2F28CE2ECB;
        Sat, 11 Dec 2021 03:03:37 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 5B12EC00446;
        Sat, 11 Dec 2021 03:03:35 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1639191815;
        bh=fp05CQC7c8K6DRnfQlRipFz8HVpGJXQ/NNYXDb70RuQ=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=Xeb6uzx5ksXMb6q4X4tethuk9B0yrexQjyYJZ5DabmZywp4yB72SM6AZvL5YJi9G5
         LGmNW8Dnsud4tIWQmaq+p87HHzVhDXPU9aicHB85v30nH9bXjxqmj0ZffKkvBW5Ux5
         AN81KpxKvfWBJ/+4PxP/aZLvVwHG6bm5gi5Yurp2i3nFGYw51GtFYB1xm7NMOVPNZE
         /5egZKoGUFgJ59n73ID4EFHWMUqBmJSa8OmAVgb2TPZCNltiW2m4YF97cfl3/lKHfo
         owAhjm8TSmd9M1zR4wxxbMKaWWZ9fqm83AVf2K2spBJeBasR9UPtTJmCILrjbA+Ry0
         koo2JZAL91S5Q==
Date:   Fri, 10 Dec 2021 19:03:34 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Shuah Khan <skhan@linuxfoundation.org>
Cc:     catalin.marinas@arm.com, will@kernel.org, shuah@kernel.org,
        keescook@chromium.org, mic@digikod.net, davem@davemloft.net,
        peterz@infradead.org, paulmck@kernel.org, boqun.feng@gmail.com,
        akpm@linux-foundation.org, linux-kselftest@vger.kernel.org,
        linux-security-module@vger.kernel.org, netdev@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 07/12] selftests/net: remove ARRAY_SIZE define from
 individual tests
Message-ID: <20211210190334.215795cc@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <1356c830b8155ddd37a6330c1f5d4df7a1bdb86a.1639156389.git.skhan@linuxfoundation.org>
References: <cover.1639156389.git.skhan@linuxfoundation.org>
        <1356c830b8155ddd37a6330c1f5d4df7a1bdb86a.1639156389.git.skhan@linuxfoundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, 10 Dec 2021 10:33:17 -0700 Shuah Khan wrote:
> ARRAY_SIZE is defined in several selftests. Remove definitions from
> individual test files and include header file for the define instead.
> ARRAY_SIZE define is added in a separate patch to prepare for this
> change.
> 
> Remove ARRAY_SIZE from net tests and pickup the one defined in
> kselftest.h.

Acked-by: Jakub Kicinski <kuba@kernel.org>
