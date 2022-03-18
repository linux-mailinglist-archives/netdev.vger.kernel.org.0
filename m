Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 76F5E4DE0B7
	for <lists+netdev@lfdr.de>; Fri, 18 Mar 2022 19:05:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240000AbiCRSHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Mar 2022 14:07:13 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44014 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S239969AbiCRSHL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 18 Mar 2022 14:07:11 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C56E2BD23E;
        Fri, 18 Mar 2022 11:05:52 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 4D609B82519;
        Fri, 18 Mar 2022 18:05:51 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id EEA95C340F5;
        Fri, 18 Mar 2022 18:05:49 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1647626750;
        bh=zIkEvsZc/kt2D5So3dCzeb7vp7iTdkL0bnV/3Yh8e6o=;
        h=References:In-Reply-To:From:Date:Subject:To:Cc:From;
        b=bHrLverKp3mcWzc1G29Sb/a1reCKciGcsMTF1EDF2zrLXmvg6DkYO+pfabwrx7aIM
         XNcbRfZ7mfkQf1NfRH3CxdG9oIhkPkUluzdp1I8DlBEkX0HZuMopArqj9d0c/v4VKY
         uS0Ve7y5J2MNgd297ck+IGgl70X/MkJjVhGrz1+uLUi2uXf88Av0PCTUU0RqB3Ivwb
         oyaXLOPDjQSfkB84vopOizd4hjySbGbzI13W/0/6jtu3RJIl5cGRYo7liaUC9qWFsy
         f042OPdcM8WSEKU2F2OR7OTdSdDG9hKVfxBf6KNxxo4Q0Vj3ukRU90WaUuyiqZ7JTX
         kGqWp/Nm4jyDw==
Received: by mail-yw1-f174.google.com with SMTP id 00721157ae682-2dbd97f9bfcso99068487b3.9;
        Fri, 18 Mar 2022 11:05:49 -0700 (PDT)
X-Gm-Message-State: AOAM533j/W5XU6R0myNtfS4lqq4QNu5SKxrnoZvz0sDbM0TIO4iJ6D5o
        TsD0VkngYZLR01IGdna9vkXR42G3gZ/93KFMzuw=
X-Google-Smtp-Source: ABdhPJxU3eil1V5K5GaKG42/whotQoFT+jQjFfgiF8ydKM3XEv8FLTKY6+WlHvQaK+D7ZByxlpUwobzVGsn3qOHQ9co=
X-Received: by 2002:a81:951:0:b0:2e5:9e38:147c with SMTP id
 78-20020a810951000000b002e59e38147cmr12482496ywj.211.1647626748837; Fri, 18
 Mar 2022 11:05:48 -0700 (PDT)
MIME-Version: 1.0
References: <20220318161528.1531164-1-benjamin.tissoires@redhat.com> <20220318161528.1531164-18-benjamin.tissoires@redhat.com>
In-Reply-To: <20220318161528.1531164-18-benjamin.tissoires@redhat.com>
From:   Song Liu <song@kernel.org>
Date:   Fri, 18 Mar 2022 11:05:37 -0700
X-Gmail-Original-Message-ID: <CAPhsuW77u64mxxLxp3B99cvu8NbqgNv1oW5Ffv0yn-k=YBw6GQ@mail.gmail.com>
Message-ID: <CAPhsuW77u64mxxLxp3B99cvu8NbqgNv1oW5Ffv0yn-k=YBw6GQ@mail.gmail.com>
Subject: Re: [PATCH bpf-next v3 17/17] Documentation: add HID-BPF docs
To:     Benjamin Tissoires <benjamin.tissoires@redhat.com>
Cc:     Greg KH <gregkh@linuxfoundation.org>,
        Jiri Kosina <jikos@kernel.org>,
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
        open list <linux-kernel@vger.kernel.org>,
        "open list:HID CORE LAYER" <linux-input@vger.kernel.org>,
        Networking <netdev@vger.kernel.org>, bpf <bpf@vger.kernel.org>,
        linux-kselftest@vger.kernel.org,
        Linux Doc Mailing List <linux-doc@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-8.6 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Mar 18, 2022 at 9:22 AM Benjamin Tissoires
<benjamin.tissoires@redhat.com> wrote:
>
> Gives a primer on HID-BPF.
>
> Signed-off-by: Benjamin Tissoires <benjamin.tissoires@redhat.com>
>
> ---
>
> new in v3
> ---
>  Documentation/hid/hid-bpf.rst | 444 ++++++++++++++++++++++++++++++++++
>  Documentation/hid/index.rst   |   1 +
>  include/uapi/linux/bpf_hid.h  |  54 ++++-
>  3 files changed, 492 insertions(+), 7 deletions(-)
>  create mode 100644 Documentation/hid/hid-bpf.rst
>
> diff --git a/Documentation/hid/hid-bpf.rst b/Documentation/hid/hid-bpf.rst
> new file mode 100644
> index 000000000000..0bf0d937b0e1
> --- /dev/null
> +++ b/Documentation/hid/hid-bpf.rst
> @@ -0,0 +1,444 @@
> +.. SPDX-License-Identifier: GPL-2.0
> +
> +=======
> +HID-BPF
> +=======
> +
> +HID is a standard protocol for input devices and it can greatly make use
> +of the eBPF capabilities to speed up development and add new capabilities
> +to the existing HID interfaces.
> +
> +.. contents::
> +    :local:
> +    :depth: 2
> +
> +
> +When (and why) using HID-BPF
> +============================
> +
> +We can enumerate several use cases for when using HID-BPF is better than
> +using a standard kernel driver fix.
> +
> +dead zone of a joystick
> +-----------------------
> +
> +Assuming you have a joystick that is getting older, it is common to see it
> +wobbling around its neutral point. This is usually filtered at the application
> +level by adding a *dead zone* for this specific axis.
> +
> +With HID-BPF, we can put the filtering of this dead zone in the kernel directly
> +so we don't wake up userspace when nothing else is happening on the input
> +controller.
> +
> +Of course, given that this dead zone is device specific, we can not create a

nit: s/can not/cannot

There are a few more "can not" below.

[...]

> +firewall
> +--------
> +
> +What if we want to prevent other users to access a specific feature of a
> +device? (think a possibly bonker firmware update entry popint)
nit: point

> +
> +With eBPF, we can intercept any HID command emitted to the device and
> +validate it or not.
> +
> +This also allows to sync the state between the userspace and the
> +kernel/bpf program because we can intercept any incoming command.
> +
[...]

> +
> +The main idea behind HID-BPF is that it works at an array of bytes level.
> +Thus, all of the parsing of the HID report and the HID report descriptor
> +must be implemented in the userspace component that loads the eBPF
> +program.
> +
> +For example, in the dead zone joystick from above, knowing which fields
> +in the data stream needs to be set to ``0`` needs to be computed by userspace.
> +
> +A corrolar of this is that HID-BPF doesn't know about the other subsystems

nit: corollary?

> +available in the kernel. *You can not directly emit input event through the
> +input API from eBPF*.
> +
> +When a BPF program need to emit input events, it needs to talk HID, and rely
> +on the HID kernel processing to translate the HID data into input events.
> +
> +Available types of programs
> +===========================
[...]
> +
> +``BPF_HID_RDESC_FIXUP``
> +~~~~~~~~~~~~~~~~~~~~~~~
> +
> +Last, the ``BPF_HID_RDESC_FIXUP`` program works in the similar maneer than
nit: manner.

> +``.report_fixup`` of ``struct hid_driver``.
> +

[...]
