Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 62E8B45711B
	for <lists+netdev@lfdr.de>; Fri, 19 Nov 2021 15:48:16 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236094AbhKSOvC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 19 Nov 2021 09:51:02 -0500
Received: from mout.kundenserver.de ([212.227.126.134]:48197 "EHLO
        mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236059AbhKSOu6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 19 Nov 2021 09:50:58 -0500
Received: from mail-ot1-f43.google.com ([209.85.210.43]) by
 mrelayeu.kundenserver.de (mreue010 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1N332D-1mg05n2lLh-013QTC; Fri, 19 Nov 2021 15:47:54 +0100
Received: by mail-ot1-f43.google.com with SMTP id x43-20020a056830246b00b00570d09d34ebso17180282otr.2;
        Fri, 19 Nov 2021 06:47:53 -0800 (PST)
X-Gm-Message-State: AOAM533IGLLFKWbdPAcyMBAQuYLXxHjUCAolI8JP4oECn1K0wQUuEKiR
        G0Z7+oduPubJTRq6fH9cylUDzXfxYz1nT3NCm7g=
X-Google-Smtp-Source: ABdhPJyEA9Cm9jWRHlNRoILV4HxXKS70yYn95cfqEWkgZ0erwiDK8IdJrB6FynNXAmz1W8+x37fIqweN9je4/+8NifA=
X-Received: by 2002:a05:6830:453:: with SMTP id d19mr5257576otc.72.1637333272785;
 Fri, 19 Nov 2021 06:47:52 -0800 (PST)
MIME-Version: 1.0
References: <20211119113644.1600-1-alx.manpages@gmail.com>
In-Reply-To: <20211119113644.1600-1-alx.manpages@gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Fri, 19 Nov 2021 15:47:35 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
Message-ID: <CAK8P3a0qT9tAxFkLN_vJYRcocDW2TcBq79WcYKZFyAG0udZx5Q@mail.gmail.com>
Subject: Re: [PATCH 00/17] Add memberof(), split some headers, and slightly
 simplify code
To:     Alejandro Colomar <alx.manpages@gmail.com>
Cc:     LKML <linux-kernel@vger.kernel.org>,
        Ajit Khaparde <ajit.khaparde@broadcom.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Bjorn Andersson <bjorn.andersson@linaro.org>,
        Borislav Petkov <bp@suse.de>,
        Corey Minyard <cminyard@mvista.com>, Chris Mason <clm@fb.com>,
        Christian Brauner <christian.brauner@ubuntu.com>,
        David Sterba <dsterba@suse.com>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Jason Wang <jasowang@redhat.com>,
        Jitendra Bhivare <jitendra.bhivare@broadcom.com>,
        John Hubbard <jhubbard@nvidia.com>,
        "John S . Gruber" <JohnSGruber@gmail.com>,
        Jonathan Cameron <Jonathan.Cameron@huawei.com>,
        Joonas Lahtinen <joonas.lahtinen@linux.intel.com>,
        Josef Bacik <josef@toxicpanda.com>,
        Kees Cook <keescook@chromium.org>,
        Ketan Mukadam <ketan.mukadam@broadcom.com>,
        Len Brown <lenb@kernel.org>,
        "Michael S. Tsirkin" <mst@redhat.com>,
        Miguel Ojeda <ojeda@kernel.org>,
        Mike Rapoport <rppt@linux.ibm.com>,
        Nick Desaulniers <ndesaulniers@google.com>,
        "Rafael J. Wysocki" <rafael@kernel.org>,
        Rasmus Villemoes <linux@rasmusvillemoes.dk>,
        Rodrigo Vivi <rodrigo.vivi@intel.com>,
        Russell King <linux@armlinux.org.uk>,
        Somnath Kotur <somnath.kotur@broadcom.com>,
        Sriharsha Basavapatna <sriharsha.basavapatna@broadcom.com>,
        Subbu Seetharaman <subbu.seetharaman@broadcom.com>,
        intel-gfx@lists.freedesktop.org, linux-acpi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-btrfs@vger.kernel.org,
        linux-scsi@vger.kernel.org, netdev@vger.kernel.org,
        virtualization@lists.linux-foundation.org
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:GFuoAY7cBVxv1hE6c2usNm2Wzsn2Ca40ybiDicGvG/6dGFof8Fl
 ID0Pq6SFVJbjL61tfm7FjmaodejJMFDsPkYnXv4+0SqsD5VSMqYGe5P8y8kQZcgFvFZ2Wvw
 2+3326h4X/ARP1UPrxV3qklM8pCGwHAjxb9un9kn8xAcJW0s3i9rm2/3KxUXgJ7Iczcyxnd
 W7FQ+CznKlyJn19hp5a/Q==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:wr5stG4BzOA=:DSALNYYDwQYB/SOa2CCFkL
 Kzvd3pgCIToq/LtQAv5xDRBKvgzJJ2zNtM64VfmIKJzBwFU7nQuETkJtBQfuGVfvjwNSGr439
 LF9P2vwTKAkc57yNo4gzt7PjyCnZxQ001xr5L+SBIxuW4eOYBem5X7j8wQzbZReNtLw7zxT4b
 rTYugxC2QHhQnEfvbQhrcnd+/wozG6LACe6fKXnHrwAEgf4MiJsN+Rr0JQ8S26r2/qlmnrOkH
 HsiuT4Ealqd0G99KqoHouBvM3iQ7ufMeSMbi0UE2rLiMKLeWcK0JfyHC50q5nuMZuEZaQJKYL
 9Y8w1+xSbxmV6BrJFH75pQZlW1ge+w/9u4UDFgPT1IRiX29v5WYxDO9Zpk3d77tskoMXtSabL
 TCIXunYWR9TWsfOHjWmgis2Je5Jbm5Cgv7ERKiRbCiMvaE/9YvVKUWx6AHjbD4niCI3ZfrEMG
 L2E7aa9lLHPhqIcG4GtvxXkxii/Awf+LwCqPhv9nzKM8/Ic5yJoga2AICJgVs43yybk0QlKdb
 /WqxlTY+HeETKJfxfxt314bJgGEHgXDWoILwkJFzKTaK0EwSiXLcAhIbGSFjPhmXN4YdsPaL2
 By1B3hJry0Gtuwtgs/o1f9LFC/Pik/gSd5WDy6xBMQF5xUX9khaaw7ZNXFw1f8tayeVYQ9Fk5
 8u7vKqKV+SPskbzpUtgso0rEClDfDbPZqUv2fgUCZi0iDmM/gIZ00pr4afESKZwv/cvbZ8cso
 Lb1Puv174QQUX3ziPGCm2YDD28Kk8vDKkZ+LNCVqDvduxQ739SKJsQVlZjTwe2wjnMv8DZ7e2
 k0VkzUhq6VkJ5WriSHpihXISaxaDbc19NyluTevBEbeTrri08o=
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Nov 19, 2021 at 12:36 PM Alejandro Colomar
<alx.manpages@gmail.com> wrote:
>
> Alejandro Colomar (17):
>   linux/container_of.h: Add memberof(T, m)
>   Use memberof(T, m) instead of explicit NULL dereference
>   Replace some uses of memberof() by its wrappers
>   linux/memberof.h: Move memberof() to separate header
>   linux/typeof_member.h: Move typeof_member() to a separate header
>   Simplify sizeof(typeof_member()) to sizeof_field()
>   linux/NULL.h: Move NULL to a separate header
>   linux/offsetof.h: Move offsetof(T, m) to a separate header
>   linux/offsetof.h: Implement offsetof() in terms of memberof()
>   linux/container_of.h: Implement container_of_safe() in terms of
>     container_of()
>   linux/container_of.h: Cosmetic
>   linux/container_of.h: Remove unnecessary cast to (void *)

My feeling is that this takes the separation too far: by having this many header
files that end up being included from practically every single .c file
in the kernel,
I think you end up making compile speed worse overall.

If your goal is to avoid having to recompile as much of the kernel
after touching
a header, I think a better approach is to help untangle the dependencies, e.g.
by splitting out type definitions from headers with inline functions (most
indirect header dependencies are on type definitions) and by focusing on
linux/fs.h, linux/sched.h, linux/mm.h and how they interact with the rest of the
headers. At the moment, these are included in most .c files and they in turn
include a ton of other headers.

          Arnd
