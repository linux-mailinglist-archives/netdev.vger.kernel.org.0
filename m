Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 23CD6E1465
	for <lists+netdev@lfdr.de>; Wed, 23 Oct 2019 10:37:40 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390420AbfJWIh1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 23 Oct 2019 04:37:27 -0400
Received: from mail-qt1-f196.google.com ([209.85.160.196]:37675 "EHLO
        mail-qt1-f196.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2390353AbfJWIh0 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 23 Oct 2019 04:37:26 -0400
Received: by mail-qt1-f196.google.com with SMTP id g50so16968108qtb.4
        for <netdev@vger.kernel.org>; Wed, 23 Oct 2019 01:37:24 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=8lz7pb4FteEgyJv9IPQ/OLCtPnphrxWGvxhOP9Cg5xg=;
        b=JwTjN6vydN0+Zf4u7pB30rwoE59an2gXmw4CK43Gw2mUgwv6sHB8dRu5ef+CPKrKi9
         t37NRMXY7Pqn+GOXFnQVRUhDon6l/NVQ8pA0BemeHOS2xV5gnJeOluyURTVwqiqciHLr
         qDsbygaUpKyOoJQGtYGQCZ1Z1qPmuIERBA+CkHYIsho9310tefDA69PATQdcjEBUxKvZ
         zccwGPi/rBKb1ABlUBTM4DzoW7/ny0B2e4mksE9SWdW/VXPMMYWRkgwBwgTZmF6XoI/2
         9Klci3Rpbj2E75wUXAhDRIwV2xUCPGOaB+CkTyurziCQ8SokD8YBhlXIMeY8vmxGNMh9
         CpEQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=8lz7pb4FteEgyJv9IPQ/OLCtPnphrxWGvxhOP9Cg5xg=;
        b=httiWbmUUANTpDIez4W6BLr3TiqKybNFKtbzK2ZOQ8UdHpq4bKRyKpY+P8HxCMzp87
         m75TJY3ebLgR1FF4tdHjEF5v7yaWdJOaTx9vl+C01N39AbV++lbyZOr5hPQSvZLrA13f
         yBQZdA0vyBP4qmnJdsCR9Z23f+usc8UXmnub26schteWxpEdAs5YHR6YB9XLtPU4w6HW
         33xpO49ouUfTrsYgxkPXou9JUDmgDfynwhMKSCEYAi8gf596B3cqWL/zUPXjJ2iCH7ow
         9nuGOT2kUqJNTYD7wTPymkZTxsBU4jnbtWsPzxJ6ne85ce4kCc8n28iT65JQyTV8E21+
         fL4w==
X-Gm-Message-State: APjAAAV9BzDfXeuMu/cCsBTsHyqTrRJ01AN7+Q1YK1FYF0lLnX32Je0X
        C069STV+4MG146Pamampw8NRGXlsJ5D9x5JFlKh+qQ==
X-Google-Smtp-Source: APXvYqzx+Vk1M8As38RQ4hIHR6mJF2kC4m1fQbj0srob4XtBiTnVVZbS/2BQAN6f9QjBuuoyoWNpTyhH+FFLQW+4r9s=
X-Received: by 2002:a0c:fec3:: with SMTP id z3mr7697922qvs.122.1571819843712;
 Wed, 23 Oct 2019 01:37:23 -0700 (PDT)
MIME-Version: 1.0
References: <cover.1571762488.git.andreyknvl@google.com>
In-Reply-To: <cover.1571762488.git.andreyknvl@google.com>
From:   Dmitry Vyukov <dvyukov@google.com>
Date:   Wed, 23 Oct 2019 10:37:12 +0200
Message-ID: <CACT4Y+aUf5_+U90BD=1FsS1vVFrH=kskkUJWFyg2cdeRjL1LVw@mail.gmail.com>
Subject: Re: [PATCH 0/3] kcov: collect coverage from usb and vhost
To:     Andrey Konovalov <andreyknvl@google.com>
Cc:     USB list <linux-usb@vger.kernel.org>,
        KVM list <kvm@vger.kernel.org>,
        virtualization@lists.linux-foundation.org,
        netdev <netdev@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>,
        "Michael S . Tsirkin" <mst@redhat.com>,
        Jason Wang <jasowang@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        David Windsor <dwindsor@gmail.com>,
        Elena Reshetova <elena.reshetova@intel.com>,
        Anders Roxell <anders.roxell@linaro.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Oct 22, 2019 at 6:46 PM Andrey Konovalov <andreyknvl@google.com> wrote:
>
> This patchset extends kcov to allow collecting coverage from the USB
> subsystem and vhost workers. See the first patch description for details
> about the kcov extension. The other two patches apply this kcov extension
> to USB and vhost.
>
> These patches have been used to enable coverage-guided USB fuzzing with
> syzkaller for the last few years, see the details here:
>
> https://github.com/google/syzkaller/blob/master/docs/linux/external_fuzzing_usb.md
>
> This patchset has been pushed to the public Linux kernel Gerrit instance:
>
> https://linux-review.googlesource.com/c/linux/kernel/git/torvalds/linux/+/1524

Oh, so much easier to review with side-by-side diffs, context and
smart in-line colouring!

> Changes from RFC v1:
> - Remove unnecessary #ifdef's from drivers/vhost/vhost.c.
> - Reset t->kcov when area allocation fails in kcov_remote_start().
> - Use struct_size to calculate array size in kcov_ioctl().
> - Add a limit on area_size in kcov_remote_arg.
> - Added kcov_disable() helper.
> - Changed encoding of kcov remote handle ids, see the documentation.
> - Added a comment reference for kcov_sequence task_struct field.
> - Change common_handle type to u32.
> - Add checks for handle validity into kcov_ioctl_locked() and
>     kcov_remote_start().
> - Updated documentation to reflect the changes.
>
> Andrey Konovalov (3):
>   kcov: remote coverage support
>   usb, kcov: collect coverage from hub_event
>   vhost, kcov: collect coverage from vhost_worker
>
>  Documentation/dev-tools/kcov.rst | 120 ++++++++
>  drivers/usb/core/hub.c           |   5 +
>  drivers/vhost/vhost.c            |   6 +
>  drivers/vhost/vhost.h            |   1 +
>  include/linux/kcov.h             |   6 +
>  include/linux/sched.h            |   6 +
>  include/uapi/linux/kcov.h        |  20 ++
>  kernel/kcov.c                    | 464 ++++++++++++++++++++++++++++---
>  8 files changed, 593 insertions(+), 35 deletions(-)
>
> --
> 2.23.0.866.gb869b98d4c-goog
>
