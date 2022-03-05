Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 20EBF4CE661
	for <lists+netdev@lfdr.de>; Sat,  5 Mar 2022 19:11:51 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231892AbiCESMh (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 5 Mar 2022 13:12:37 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55054 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229806AbiCESMh (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 5 Mar 2022 13:12:37 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1CD43EE5
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 10:11:47 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 358ECB800C1
        for <netdev@vger.kernel.org>; Sat,  5 Mar 2022 18:11:46 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 8F4C5C004E1;
        Sat,  5 Mar 2022 18:11:44 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1646503904;
        bh=fvVszc/E/CGNX5Tm9qPuzDHOjIaFpZRVjdn3y1+5pP8=;
        h=Date:Subject:To:Cc:References:From:In-Reply-To:From;
        b=BVEhJgKe5FMuqaOY0FaERW41GDvWiuY3aX5e82nnNWxxFl1A+vJ1g/oebnXk2+JVp
         rEv60WbeOS+NKZ76bcDUGESLBzNBxMlXZaonwPeoZeGy3MK0QRmKYZ6G3ImutQTMS1
         Zg30yvU70Z+hr+RnihPOz6UMa3KZKcFvEbgv17kY5ZHELFBrKZRLDZdZ/M0DjgZdJg
         nJE1Cz373GBBJPa1ey6+W9xoCe9TADqb7HF8EsdOJFdwT1xSqTQNYHNmaPIR2r6k63
         tKp/wia/El/1NZ+bFO3eAq6XLWd5rgcMKT0PqcmA9EdLpxfaHF2RfChRiRpflL3nsj
         bGr7mIpn6nMbA==
Message-ID: <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
Date:   Sat, 5 Mar 2022 11:11:43 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Macintosh; Intel Mac OS X 10.15; rv:91.0)
 Gecko/20100101 Thunderbird/91.6.1
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Content-Language: en-US
To:     Ido Schimmel <idosch@idosch.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
References: <20220228015435.1328-1-dsahern@kernel.org>
 <Yh93f0XP0DijocNa@shredder>
From:   David Ahern <dsahern@kernel.org>
In-Reply-To: <Yh93f0XP0DijocNa@shredder>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,NICE_REPLY_A,
        RCVD_IN_DNSWL_HI,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/2/22 6:56 AM, Ido Schimmel wrote:
> David, are you sure this patch is needed? Even without it I can override
> from the command line:
> 
> $ make V=1 CC=gcc
> 
> lib
> make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> gcc -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> ...
> 
> $ make V=1 CC=clang
> 
> lib
> make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> clang -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> 

interesting. As I recall the change was needed when I was testing
Stephen's patches for a clean compile with clang. Either way, the patch
was already merged.

