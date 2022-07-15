Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 0C4F4575AB0
	for <lists+netdev@lfdr.de>; Fri, 15 Jul 2022 07:01:09 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229899AbiGOFAo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 15 Jul 2022 01:00:44 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:41040 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229706AbiGOFAn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 15 Jul 2022 01:00:43 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [139.178.84.217])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E192378581;
        Thu, 14 Jul 2022 22:00:41 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id 77AF462246;
        Fri, 15 Jul 2022 05:00:41 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 4C0E5C3411E;
        Fri, 15 Jul 2022 05:00:40 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1657861240;
        bh=Hek494Yetd3XN90he4BxOJbpQ2dkKLCIYiZNf3+pfA0=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=Kxxg6dz9/3aBwvkXZ/oAaWLb6NKzJXAis2DXFBUvPhL2zy1R85keS7nHBElPKZbtM
         O65XQ6pyPng/miykZf3kmYGUkxWYT8HnUnS0tJoIRm/iNm3C7rsel2zNh+gt5VLHIc
         gDGof+fdyvGyLtLP/cD6fWSDs0clD/lSbI+7NUIg=
Date:   Fri, 15 Jul 2022 07:00:38 +0200
From:   Greg KH <gregkh@linuxfoundation.org>
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Jiri Kosina <jikos@kernel.org>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>, Shuah Khan <shuah@kernel.org>,
        Dave Marchevsky <davemarchevsky@fb.com>,
        Joe Stringer <joe@cilium.io>, Jonathan Corbet <corbet@lwn.net>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org, linux-doc@vger.kernel.org
Subject: Re: [PATCH bpf-next v6 09/23] HID: core: store the unique system
 identifier in hid_device
Message-ID: <YtD0dt3MxjSozgXg@kroah.com>
References: <20220712145850.599666-1-benjamin.tissoires@redhat.com>
 <20220712145850.599666-10-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220712145850.599666-10-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Jul 12, 2022 at 04:58:36PM +0200, Benjamin Tissoires wrote:
> This unique identifier is currently used only for ensuring uniqueness in
> sysfs. However, this could be handful for userspace to refer to a specific
> hid_device by this id.
> 
> 2 use cases are in my mind: LEDs (and their naming convention), and
> HID-BPF.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
