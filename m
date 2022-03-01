Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 188574C976E
	for <lists+netdev@lfdr.de>; Tue,  1 Mar 2022 21:59:57 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S238444AbiCAVAg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 1 Mar 2022 16:00:36 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:51424 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236863AbiCAVAe (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 1 Mar 2022 16:00:34 -0500
X-Greylist: delayed 303 seconds by postgrey-1.37 at lindbergh.monkeyblade.net; Tue, 01 Mar 2022 12:59:52 PST
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.130])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 623AF70337;
        Tue,  1 Mar 2022 12:59:52 -0800 (PST)
Received: from mail-wm1-f42.google.com ([209.85.128.42]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MwQw1-1oF3sg3Nxt-00sMy4; Tue, 01 Mar 2022 21:54:47 +0100
Received: by mail-wm1-f42.google.com with SMTP id c18-20020a7bc852000000b003806ce86c6dso1959111wml.5;
        Tue, 01 Mar 2022 12:54:47 -0800 (PST)
X-Gm-Message-State: AOAM530a05NOVHd+QWqarIZf3oTnW50d/On0hNZyH3ZK8It+IbmP7+V+
        fxvPVWo0MFrrnGUtvC4Pviunihc0Wd3YCjRAppU=
X-Google-Smtp-Source: ABdhPJyfexIsGrgwygzot8G9sKT9XjsIQsKTtfBymt2kmTT/NR84Ozb3Ztyvv7y1MPCl2UVcmgGXd7qIz2qyYblVz+s=
X-Received: by 2002:a05:600c:4f8e:b0:381:6de4:fccc with SMTP id
 n14-20020a05600c4f8e00b003816de4fcccmr7841096wmq.82.1646168087390; Tue, 01
 Mar 2022 12:54:47 -0800 (PST)
MIME-Version: 1.0
References: <20220301075839.4156-2-xiam0nd.tong@gmail.com> <202203020135.5duGpXM2-lkp@intel.com>
 <CAHk-=wiVF0SeV2132vaTAcL1ccVDP25LkAgNgPoHXdFc27x-0g@mail.gmail.com>
In-Reply-To: <CAHk-=wiVF0SeV2132vaTAcL1ccVDP25LkAgNgPoHXdFc27x-0g@mail.gmail.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 1 Mar 2022 21:54:30 +0100
X-Gmail-Original-Message-ID: <CAK8P3a0QAECV=_Bu5xnBxjxUHLcaGjBgJEjfMaeKT7StR=acyQ@mail.gmail.com>
Message-ID: <CAK8P3a0QAECV=_Bu5xnBxjxUHLcaGjBgJEjfMaeKT7StR=acyQ@mail.gmail.com>
Subject: Re: [PATCH 1/6] Kbuild: compile kernel with gnu11 std
To:     Linus Torvalds <torvalds@linux-foundation.org>
Cc:     kernel test robot <lkp@intel.com>,
        Xiaomeng Tong <xiam0nd.tong@gmail.com>,
        kbuild-all@lists.01.org, Arnd Bergmann <arnd@arndb.de>,
        Jakob Koschel <jakobkoschel@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kees Cook <keescook@chromium.org>,
        Jann Horn <jannh@google.com>,
        Linux Kbuild mailing list <linux-kbuild@vger.kernel.org>,
        Linux-MM <linux-mm@kvack.org>, Netdev <netdev@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:UyQiCNWs1ZLtkg6WG9++n+3GsQgzK+acpBbi33NPnZxg9U8Lwx5
 seheEZG2JPgKWzfHK4xhcCJfRX4t/+iKXpgvmzXtudKoVUDl/F6sHKr3OP6lhu9/RZwifnY
 p1tya+JEk/e9rTfqSpw8IKmfPNNWvzEnpKoLpJ61OmhzKwQwpLD82bRl6diLuPrLup6AlWx
 B5VLEJrpOJWgaCHKW8SjA==
X-UI-Out-Filterresults: notjunk:1;V03:K0:Vsttm/+D7CU=:1Sdx8KiiSCJPouRELWDGHf
 McMVhzXoPD6nxUL5Qa6xVnXmQaDnuJ4BPuvlpXeGWtGQGb3uT5XRGHRAqOob9lvzW/D9x21HQ
 KjPLwKIz/9xy1KBDym75bhpLIOzRfj1UJiPeKUR1EqCSOZnMlw5O5agGUEgd01h+SUhro5RYk
 9oL32khYM6kg1OV00AqTZHSrSFLzCus7s9Gc3RnhMmbMmo0GIR2EzppSiqVOt+MHjg5DO4Qf1
 MS1LioWFVBx+EJ32Z+4DZV3sqKsOcywJfCptJskcOnGX5hYIG6jVqqrNoxsOBB9JLC53sSz6r
 2t5kr3KlKMb80s3T8vbvwr4hsceNlMEWTfKDYLMIcZcGsDg7v6vRnzLEfulCftPOniBFolE1h
 llT3qd/BX+uACDvqIWYrT4kDsEh6Up8xVIjdkZ2YFMHLXYFwpSTpKKTVB6EdTqIG9NSkoidtP
 CuufGeDP+y/Qp/4XrsHpuK+lNTWaZRKqaxF56rVANrrD/QrRRxNQLCWuBql43lBb1ynMT0sed
 jCjIQ42M3xvHRb9jk6o2HferAFWWDG5lTjp25tcK0NdH2uc7E2khsDwqIghdVbfym8+r8DrOD
 E5B06qpZiqviKYgh95sVwV+3VSs5ylaTyWEDYQqk3OjYZYwqOQPUAGB8JrFLXkvi+MHD6XKjL
 lQZQr1bsH1+jZn+lyeNbYEqV5IPDxXldImVroekpUudyzFAXBgUv6nwJ6FezX2GYrs2PsvAze
 mNqaTePmRAVkoyvPBeXX3XJ51Nk4xNet65FkdmP2mdQ8un4QEZpeeRmWbtWc0kf0Ern0BNIRQ
 jgIWUab9aPQPilgM5t5qiR0w9WM8HSxeYAcjhBXg0RSKdr9jy8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H5,RCVD_IN_MSPIKE_WL,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Mar 1, 2022 at 9:16 PM Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Tue, Mar 1, 2022 at 10:00 AM kernel test robot <lkp@intel.com> wrote:
> >
> > All warnings (new ones prefixed by >>):
> >
> > >> cc1: warning: result of '-117440512 << 16' requires 44 bits to represent, but 'int' only has 32 bits [-Wshift-overflow=]
>
> So that's potentially an interesting warning, but this email doesn't
> actually tell *where* that warning happens.
>
> I'm not entirely sure why this warning is new to this '-std=gnu11'
> change, but it's intriguing.
...
>
> Is there some place to actually see the full log (or some way to get a
> better pointer to just the new warning) to see that actual shift
> overflow thing?

gcc-11 only shows the one line warning here. The source is

/* PCI CFG04 status fields */
#define PCI_CFG04_STAT_BIT      16
#define PCI_CFG04_STAT          0xffff0000
#define PCI_CFG04_STAT_66_MHZ   (1 << 21)
#define PCI_CFG04_STAT_FBB      (1 << 23)
#define PCI_CFG04_STAT_MDPE     (1 << 24)
#define PCI_CFG04_STAT_DST      (1 << 25)
#define PCI_CFG04_STAT_STA      (1 << 27)
#define PCI_CFG04_STAT_RTA      (1 << 28)
#define PCI_CFG04_STAT_RMA      (1 << 29)
#define PCI_CFG04_STAT_SSE      (1 << 30)
#define PCI_CFG04_STAT_PE       (1 << 31)
#define KORINA_STAT             (PCI_CFG04_STAT_MDPE | \
                                 PCI_CFG04_STAT_STA | \
                                 PCI_CFG04_STAT_RTA | \
                                 PCI_CFG04_STAT_RMA | \
                                 PCI_CFG04_STAT_SSE | \
                                 PCI_CFG04_STAT_PE)
#define KORINA_CNFG1            ((KORINA_STAT<<16)|KORINA_CMD)

unsigned int korina_cnfg_regs[25] = {
        KORINA_CNFG1, /* ... */
};

This looks like an actual bug to me, the bits are shifted 16 bits twice
by accident, and it's been like this since rb532 was introduced in
2008.

         Arnd
