Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 231694D027F
	for <lists+netdev@lfdr.de>; Mon,  7 Mar 2022 16:10:07 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S243664AbiCGPK5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 7 Mar 2022 10:10:57 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:42942 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S243663AbiCGPKz (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 7 Mar 2022 10:10:55 -0500
Received: from out2-smtp.messagingengine.com (out2-smtp.messagingengine.com [66.111.4.26])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 72D374FC6C
        for <netdev@vger.kernel.org>; Mon,  7 Mar 2022 07:09:59 -0800 (PST)
Received: from compute4.internal (compute4.nyi.internal [10.202.2.44])
        by mailout.nyi.internal (Postfix) with ESMTP id ACEAA5C0396;
        Mon,  7 Mar 2022 10:09:56 -0500 (EST)
Received: from mailfrontend1 ([10.202.2.162])
  by compute4.internal (MEProxy); Mon, 07 Mar 2022 10:09:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:cc:content-type:date:date:from:from
        :in-reply-to:in-reply-to:message-id:mime-version:references
        :reply-to:sender:subject:subject:to:to:x-me-proxy:x-me-proxy
        :x-me-sender:x-me-sender:x-sasl-enc; s=fm2; bh=CwWsy+Fx/CIHvLGat
        i4VgUp0A+WPPu8rkPuEP1C9SCk=; b=HC5n/0PtVIBOCaU4zMdCVrIE3TKW6NLbp
        8p0hG3Qmof4GJgYwvoFpemuZinTYVKmC/29SFhqKRibsNuZ/LyD64x5+eOnZ+7Si
        SB34GvUmEfNZr5gZP21PkhfCUfeisPKGyqi43G54ZAnj6eUBqN0KZbF3dUCLeuzi
        daDTzkDcjeNWH0DfxcvGxGH31o2Q9K4LQRWDkhHR2Mb42d2Camdk86R0LoCwyQ4+
        yk8JO9Z72m1Kngopba1zyCkWw9D60J6dJFBYfhh0LbISn2MVNd3ZCrnkJz8LTNzB
        yolBgG1NFidLv612gU7Hjr/+UjvFbG/NRrFSqH7H5N3WwfUsAKIDQ==
X-ME-Sender: <xms:RCAmYnLZPb09TCp1kpwyUqVkJ3CvBjlofs2AAzSGnWzTdEtnT_1B_A>
    <xme:RCAmYrIdwL0SLRbPaGfe4YZf_75smVNa7ZPa4rVCTPxb7AJ22ozHMsZc7E1oUU3jn
    80N-ae4-AJnRoM>
X-ME-Received: <xmr:RCAmYvvo8hgqZe7U8GQJX4n0P17vDJ9dtR4d81Xi4E_LQ4vxnJAMap_55C6AA-0OfiUaL7OpQ3QTcBW-Qmpc2ndvB38>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvvddruddugedgjeduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtuggjsehttdertddttddvnecuhfhrohhmpefkughoucfu
    tghhihhmmhgvlhcuoehiughoshgthhesihguohhstghhrdhorhhgqeenucggtffrrghtth
    gvrhhnpeetveevteehhfeuieekudeiudeuudefvedtfeeghffhudettdehtefhgffhkedu
    jeenucffohhmrghinhepfhgvughorhgrphhrohhjvggtthdrohhrghenucevlhhushhtvg
    hrufhiiigvpedtnecurfgrrhgrmhepmhgrihhlfhhrohhmpehiughoshgthhesihguohhs
    tghhrdhorhhg
X-ME-Proxy: <xmx:RCAmYgYhBpNqvDym_cNt8LFfbLDttEaFGWz8PcLYAeV5jhB8ba4zcg>
    <xmx:RCAmYuY3E_2COUnFpAnWxxwx6-xLlTvC1bwhsm6FXz3nwGp0EesTiw>
    <xmx:RCAmYkANVoJhbTUhjlRUd10OPbXbVCb7vDnwy0jCbiJlljTekvLUGQ>
    <xmx:RCAmYnAKmM_coNnbTfwgVSiRiouESteGeJygt74pvd26DU7QG5vUrw>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Mon,
 7 Mar 2022 10:09:55 -0500 (EST)
Date:   Mon, 7 Mar 2022 17:09:50 +0200
From:   Ido Schimmel <idosch@idosch.org>
To:     David Ahern <dsahern@kernel.org>
Cc:     netdev@vger.kernel.org, stephen@networkplumber.org
Subject: Re: [PATCH iproute2-next] configure: Allow command line override of
 toolchain
Message-ID: <YiYgPnn9wtXbOm0a@shredder>
References: <20220228015435.1328-1-dsahern@kernel.org>
 <Yh93f0XP0DijocNa@shredder>
 <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <dfe64c90-88ea-9d85-412e-d2064f3f5e52@kernel.org>
X-Spam-Status: No, score=-2.6 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_LOW,RCVD_IN_MSPIKE_H3,RCVD_IN_MSPIKE_WL,
        SPF_HELO_PASS,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Mar 05, 2022 at 11:11:43AM -0700, David Ahern wrote:
> On 3/2/22 6:56 AM, Ido Schimmel wrote:
> > David, are you sure this patch is needed? Even without it I can override
> > from the command line:
> > 
> > $ make V=1 CC=gcc
> > 
> > lib
> > make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> > gcc -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> > ...
> > 
> > $ make V=1 CC=clang
> > 
> > lib
> > make[1]: Entering directory '/home/idosch/code/iproute2/lib'
> > clang -Wall -Wstrict-prototypes  -Wmissing-prototypes -Wmissing-declarations -Wold-style-definition -Wformat=2 -O2 -pipe -I../include -I../include/uapi -DRESOLVE_HOSTNAMES -DLIBDIR=\"/usr/lib\" -DCONFDIR=\"/etc/iproute2\" -DNETNS_RUN_DIR=\"/var/run/netns\" -DNETNS_ETC_DIR=\"/etc/netns\" -D_GNU_SOURCE -D_FILE_OFFSET_BITS=64 -D_LARGEFILE_SOURCE -D_LARGEFILE64_SOURCE -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -DHAVE_SETNS -DHAVE_HANDLE_AT -DHAVE_SELINUX -DHAVE_ELF -DHAVE_LIBMNL -DNEED_STRLCPY -DHAVE_LIBCAP -fPIC   -c -o libgenl.o libgenl.c
> > 
> 
> interesting. As I recall the change was needed when I was testing
> Stephen's patches for a clean compile with clang. Either way, the patch
> was already merged.

I realize it was already merged (wasn't asking for academic purposes),
but rather wanted you to verify that the patch is not needed on your end
so that I could revert it. I can build with gcc/clang even without the
patch. With the patch, the build is broken on Fedora as "yacc" is not a
build dependency [1]. Verified this with a clean install of Fedora 35:
Can't build iproute with this patch after running "dnf builddep
iproute". Builds fine without it.

[1] https://src.fedoraproject.org/rpms/iproute/blob/rawhide/f/iproute.spec#_22
