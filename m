Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 5EC834CA6C1
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 14:56:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233979AbiCBN5I (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 08:57:08 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44286 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233874AbiCBN5I (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 08:57:08 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id ABEDB26EC
        for <netdev@vger.kernel.org>; Wed,  2 Mar 2022 05:56:24 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id 851735C0070;
        Wed,  2 Mar 2022 08:56:21 -0500 (EST)
Received: from mailfrontend2 ([10.202.2.163])
  by compute4.internal (MEProxy); Wed, 02 Mar 2022 08:56:21 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=HuoM2lH7HqeFXoJLt
        3a7JNo/CGL4rZnxXpdHDZZvIL4=; b=SIzfBhOt4IkxqoT8gJ663a9YhgeiwZbHB
        AtOiY6X5xv5fINtc+wpqXfAtVCdSUyjGoSTcBVgibVobMKc6X8rwXQRNrVEvx0Gs
        mcnl9bBzS8ED0RJMJLu07QqVhJCOYOQgqO5qAKZk1bFXmTzu8MzCVUuBhBOcxnYm
        T0qhELUPvGpeKB030+/T+uHtQSR2XVetxzRvBRdHFxWRauhWx3YGhFUmWSL9ZGe+
        WWchiphE478dlRyzy1is/kJKBnWDfC0jLNPukI3YkT1dFRDQ+h8248KzXCerUZdf
        6FnMgB5d4JX5wXuVjR1DNmOl3es22bTcU+qMYRfvEhWYjTnM7PXFQ==
X-ME-Sender: <xms:hXcfYoj1A0-pLXZ-H-dlWleRcAcs78-moHAKsyZrOfGJAXayMU__1A>
    <xme:hXcfYhDXncSkPNk7DGFrq82QljT1vpuB-4hqF5QNT1ZBjtCvy0Dv1C8e9mUXwewiJ
    x7XlXDKHT2QmcQ>
X-ME-Received: <xmr:hXcfYgFKjaC5r5LtAaknJ_ugb1zCVnk6EjVovSkEgfWSH9S2DQ1B91X3Unhbznq8XgS_82gCk20IVaILI4nOPOOUQq4>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddtgedgheduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeeikeefleduuedufeegieefhfdvleegtdfgiefgffevffffuefhtdffledvfeeg
    heenucffohhmrghinhepghhnuhdrohhrghenucevlhhushhtvghrufhiiigvpedtnecurf
    grrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhstghhrdhorhhg
X-ME-Proxy: <xmx:hXcfYpTUdKhIq1x7WQsXfGCktoou71zIMFpYPUiv36ldlODDFWCdZA>
    <xmx:hXcfYlw_bz1VsVNz5kLsWD9iI99egIkHyy9r1I9Onu80ehOjyy4UwQ>
    <xmx:hXcfYn4-Ac0vBOUp4Ctt1AqUy3pkFwrzBXmwBSmTYy978Yoe8-PiTg>
    <xmx:hXcfYjZGn-yAzACt6AOotiFAPdi4DNW9HXu8UxWAXviCmKs9YiJ_vg>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 2 Mar 2022 08:56:20 -0500 (EST)
Date:   Wed, 2 Mar 2022 15:56:15 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Message-ID: <Yh93f0XP0DijocNa@shredder>
References: <20220228015435.1328-1-dsahern@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220228015435.1328-1-dsahern@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sun, Feb 27, 2022 at 06:54:35PM -0700, David Ahern wrote:
> Easy way to build for both gcc and clang.
> 
> Signed-off-by: David Ahern <dsahern@kernel.org>
> ---
>  configure | 8 ++++----
>  1 file changed, 4 insertions(+), 4 deletions(-)
> 
> diff --git a/configure b/configure
> index 8ddff43c6a7d..13f2d1739b99 100755
> --- a/configure
> +++ b/configure
> @@ -19,10 +19,10 @@ check_toolchain()
>      : ${AR=ar}
>      : ${CC=gcc}
>      : ${YACC=bison}
> -    echo "PKG_CONFIG:=${PKG_CONFIG}" >>$CONFIG
> -    echo "AR:=${AR}" >>$CONFIG
> -    echo "CC:=${CC}" >>$CONFIG
> -    echo "YACC:=${YACC}" >>$CONFIG
> +    echo "PKG_CONFIG?=${PKG_CONFIG}" >>$CONFIG
> +    echo "AR?=${AR}" >>$CONFIG
> +    echo "CC?=${CC}" >>$CONFIG
> +    echo "YACC?=${YACC}" >>$CONFIG
>  }

David, are you sure this patch is needed? Even without it I can override
from the command line:

$ make V=1 CC=gcc

lib
make[1]: Entering directory '/home/idosch/code/iproute2/lib'
gcc -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
...

$ make V=1 CC=clang

lib
make[1]: Entering directory '/home/idosch/code/iproute2/lib'
clang -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c

Also created this test file:

$ cat bla.mk
CC := foo

all:
        echo $(origin CC)
        echo $(CC)

$ make -f bla.mk
echo file
file
echo foo
foo

$ make -f bla.mk CC=clang
echo command line
command line
echo clang
clang

$ make -v
GNU Make 4.3
Built for x86_64-redhat-linux-gnu
Copyright (C) 1988-2020 Free Software Foundation, Inc.
License GPLv3+: GNU GPL version 3 or later <http://gnu.org/licenses/gpl.html>
This is free software: you are free to change and redistribute it.
There is NO WARRANTY, to the extent permitted by law.

I'm asking because this change broke the build on our Fedora machines
and my laptop. None of them have 'yacc' installed, but they do have
'bison', which was used unconditionally before the change. After the
change, 'YACC' is set to 'yacc', as it's an implicit variable that
defaults to 'yacc':

https://www.gnu.org/software/make/manual/html_node/Implicit-Variables.html
