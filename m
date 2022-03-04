Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 2605E4CDC95
	for <lists+netdev@lfdr.de>; Fri,  4 Mar 2022 19:33:42 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S241723AbiCDSe1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 4 Mar 2022 13:34:27 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:55672 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S241763AbiCDSeO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 4 Mar 2022 13:34:14 -0500
Received: from sin.source.kernel.org (sin.source.kernel.org [IPv6:2604:1380:40e1:4800::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 937A615B984;
        Fri,  4 Mar 2022 10:33:16 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by sin.source.kernel.org (Postfix) with ESMTPS id E5895CE2BF5;
        Fri,  4 Mar 2022 18:33:14 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 2105DC340E9;
        Fri,  4 Mar 2022 18:33:05 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=linuxfoundation.org;
        s=korg; t=1646418793;
        bh=oh6K4828NJ6PlOTyn19BY42pcI859VwVqoiEDViV8sk=;
        h=Date:From:To:Cc:Subject:References:In-Reply-To:From;
        b=iGYaznCvrI8jRQ5Jq1PYUkieDADP5PCSyEIFL8cOxB/E5+f7Dwf0Ely8tAVwmNKcM
         kf2F6PDzy0mjmcP5BevT+ROUFxp0tHfhpL3ELs1Fdx5QMYSB/1qjpPA7deEGZmF1sN
         Sral4FiYICTM+F8EyiATbcbFSvOk1JNY+td968wI=
Date:   Fri, 4 Mar 2022 19:32:55 +0100
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
        Joe Stringer <joe@cilium.io>,
        Tero Kristo <tero.kristo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org,
        linux-kselftest@vger.kernel.org
Subject: Re: [PATCH bpf-next v2 08/28] HID: allow to change the report
 descriptor from an eBPF program
Message-ID: <YiJbVw/9v23wNt3a@kroah.com>
References: <20220304172852.274126-1-benjamin.tissoires@redhat.com>
 <20220304172852.274126-9-benjamin.tissoires@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20220304172852.274126-9-benjamin.tissoires@redhat.com>
X-Spam-Status: No, score=-7.5 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE,URIBL_RED autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 04, 2022 at 06:28:32PM +0100, Benjamin Tissoires wrote:
> Make use of BPF_HID_ATTACH_RDESC_FIXUP so we can trigger an rdesc fixup
> in the bpf world.
> 
> Whenever the program gets attached/detached, the device is reconnected
> meaning that userspace will see it disappearing and reappearing with
> the new report descriptor.
> 
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
> 


Reviewed-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
