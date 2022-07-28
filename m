Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 8C1B25840CD
	for <lists+netdev@lfdr.de>; Thu, 28 Jul 2022 16:14:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231233AbiG1OOl (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 Jul 2022 10:14:41 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44202 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230473AbiG1OOj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 Jul 2022 10:14:39 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 8C39814000;
        Thu, 28 Jul 2022 07:14:38 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 2815E60A10;
        Thu, 28 Jul 2022 14:14:38 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 024C9C43140;
        Thu, 28 Jul 2022 14:14:37 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1659017677;
        bh=G6gX1hF4PLXi0gkv94nAzv1BT0g1WX1G8vkIVNw1/Zw=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Nie8FLHMj48h43cconZqNLxRLLC4QUUDF6PjNzfFUzfsIV3o+Tt5O65dY2HF/QI+C
         JGTWYljiv+52htx6/Xpyap6cxsW5py1VG7v4Zgn7veZCJvyIZ6DAV0BPdVd40x7IX5
         qvSek5C2u4yGXJ+KDN3ykRUrW1P3djkHDWhZe6po=
Date:   Thu, 28 Jul 2022 16:14:34 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        Kumar Kartikeya Dwivedi <memxor@gmail.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v7 12/24] HID: Kconfig: split HID support and
 hid-core compilation
Message-ID: <YuKZyvGGVZqhMEmi@kroah.com>
References: <20220721153625.1282007-1-benjamin.tissoires@redhat.com>
 <20220721153625.1282007-13-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220721153625.1282007-13-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Jul 21, 2022 at 05:36:13PM +0200, Benjamin Tissoires wrote:
> Currently, we step into drivers/hid/ based on the value of
> CONFIG_HID.
> 
> However, that value is a tristate, meaning that it can be a module.
> 
> As per the documentation, if we jump into the subdirectory by
> following an obj-m, we can not compile anything inside that
> subdirectory in vmlinux. It is considered as a bug.
> 
> To make things more friendly to HID-BPF, split HID (the HID core
> parameter) from HID_SUPPORT (do we want any kind of HID support in the
> system?), and make this new config a boolean.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 
> ---

Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
