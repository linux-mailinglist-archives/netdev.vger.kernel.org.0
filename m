Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 327DE534BD0
	for <lists+netdev@lfdr.de>; Thu, 26 May 2022 10:32:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1346703AbiEZIcs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 May 2022 04:32:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45730 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233597AbiEZIcq (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 May 2022 04:32:46 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [212.227.126.133])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 03C6E40A01;
        Thu, 26 May 2022 01:32:44 -0700 (PDT)
Received: from mail-yw1-f177.google.com ([209.85.128.177]) by
 mrelayeu.kundenserver.de (mreue012 [213.165.67.97]) with ESMTPSA (Nemesis) id
 1MREqy-1oF67j0SBw-00N8ei; Thu, 26 May 2022 10:32:43 +0200
Received: by mail-yw1-f177.google.com with SMTP id 00721157ae682-2ff7b90e635so7972107b3.5;
        Thu, 26 May 2022 01:32:42 -0700 (PDT)
X-Gm-Message-State: AOAM532n56ZQxMFT91DplnjI4UlxvMLpwX5cJfGthcRkihp19TE1VFPf
        WKymCUc/IyL8ZzF7Enfld3wx3kxFrVpsTOcxFJ4=
X-Google-Smtp-Source: ABdhPJzd1Td84PUKl1aMompoBi/CI7Ij8UKcDh3J33F17cieCWlpkBhuvBB90C07npKSjm4gZ1dqj3OUo1L9/csGNzA=
X-Received: by 2002:a81:488c:0:b0:302:549f:ffbc with SMTP id
 v134-20020a81488c000000b00302549fffbcmr1085051ywa.495.1653553961173; Thu, 26
 May 2022 01:32:41 -0700 (PDT)
MIME-Version: 1.0
References: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
In-Reply-To: <628ea118.wJYf60YnZco0hs9o%lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Thu, 26 May 2022 10:32:24 +0200
X-Gmail-Original-Message-ID: <CAK8P3a10aGYNr=nKZVzv+1n_DRibSCCkoCLuTDtmhZskBMWfyw@mail.gmail.com>
Message-ID: <CAK8P3a10aGYNr=nKZVzv+1n_DRibSCCkoCLuTDtmhZskBMWfyw@mail.gmail.com>
Subject: Re: [linux-next:master] BUILD REGRESSION 8cb8311e95e3bb58bd84d6350365f14a718faa6d
To:     kernel test robot <lkp@intel.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        "open list:DRM DRIVER FOR QEMU'S CIRRUS DEVICE" 
        <virtualization@lists.linux-foundation.org>,
        Networking <netdev@vger.kernel.org>,
        linux-staging@lists.linux.dev,
        linux-riscv <linux-riscv@lists.infradead.org>,
        linux-rdma <linux-rdma@vger.kernel.org>,
        linux-pci <linux-pci@vger.kernel.org>,
        linux-parport@lists.infradead.org,
        linux-omap <linux-omap@vger.kernel.org>,
        Linux Fbdev development list <linux-fbdev@vger.kernel.org>,
        Linux ARM <linux-arm-kernel@lists.infradead.org>,
        kvm list <kvm@vger.kernel.org>,
        dri-devel <dri-devel@lists.freedesktop.org>,
        bpf <bpf@vger.kernel.org>,
        amd-gfx list <amd-gfx@lists.freedesktop.org>,
        ALSA Development Mailing List <alsa-devel@alsa-project.org>,
        Linux Memory Management List <linux-mm@kvack.org>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:PCHqQe4zueVMpS9NgDF2gz9QeCCu3e6TGmy70qhxHLlI0l3tOil
 3TFtRnaqRaEZG2VsxMRL/BwWZliZgBFMDmDiMT3VIGVV7w/27RA/2CRb4zSjCOlvy6iPqM+
 Ix8rIUqF6hC1so72stcjY0PS4GOuwl3eoiB7/wGEVVCCs6sLXUBtn7f33ehfn9C/4yk3dDp
 HkxtbWvMftl4TNJsT/kdw==
X-UI-Out-Filterresults: notjunk:1;V03:K0:78dHAjsp8rs=:pc1R8fxbsnLyXZ+tRpGQOD
 uxA9TCI9qUoqcJMUd1AmSehehlkwp4lmW53FlY5vykKfLVp3l4Cy3SqmMT6B6mya5q5MRwxkf
 m7QZ+C8X14ZCcB5IxiTYJW206aHfgsPNJomi4dTa4Q0GBDu0G1YyyS+b444yzR6Ql+isnCXDE
 BaopH42n0dgogTvazQMff/ftjtr/9zyvzRmrYLJS4uFRWmD165Bs3C5cNRf1hJrB5k8ZzHeQy
 K1yMzV8yWnyEKKBtXjoiRqV8bMO7cAnNdGPS5fCO4ftcfO/cecWVCpVWndcEZ9x1nDJg1D8VE
 cvUIno1cSk0UgIfu2/5XqxpHIcXhPaLTHN/EmRDKT0KHfgLefREyf60nrRRa9uIuoGEMseFnY
 w7VUgrNB6qMgTvY207Bconmza5huJdYU/eYpERC/rZ5T0FCF5lwvGeIPKZ7ksIlc6ODVPg/ai
 tN+s/QUqu/oGnRgUX5rqVmFSDRC4Qymxdb5j7XnNsHNyvFnh3L8M/pVipBzZMit++nOOSwv8L
 lzke+HIGWue2uxhnXmS1o6EKaqH0QnE2h1YczeWOyQqNnaULvHKS9aTWf7jqBdaFw/sR9KtKO
 E5J/7/HBe64/yJ5lPlU61ObcoAwrtcuuQi3yvImA0w2+y5fJFLOqtRZmuu4Xx1oYJpap7uEYb
 fOwJXnqP6OLmpV1sQY574fdWBoCBdpIgasOipuT/zal3XqVMNt43wm8BNL4z+dJelXQ5B0e+6
 E9Ue+mya/1nF3I7PDdxpguLJHREPOu0X43OCAmh3V6MvGos2qozLOWy3Ak1zG17pRyum8eEOn
 G7OvNUUsj+nY1bIOD5ZJ0jYMjwxjBNBNkH6VJ8PZsuf1SZThl1aBB5NgcoDPH4OaSWZq215Ek
 FyaWh6mDmdGTBCUZfibUJlxkVMnc/NhNVZHsTg5L8=
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, May 25, 2022 at 11:35 PM kernel test robot <lkp@intel.com> wrote:
> .__mulsi3.o.cmd: No such file or directory
> Makefile:686: arch/h8300/Makefile: No such file or directory
> Makefile:765: arch/h8300/Makefile: No such file or directory
> arch/Kconfig:10: can't open file "arch/h8300/Kconfig"

Please stop building h8300  after the asm-generic tree is merged, the
architecture is getting removed.

        Arnd
