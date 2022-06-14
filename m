Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2C954B5E2
	for <lists+netdev@lfdr.de>; Tue, 14 Jun 2022 18:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237133AbiFNQUs (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Jun 2022 12:20:48 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35226 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230121AbiFNQUr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Jun 2022 12:20:47 -0400
Received: from mout.kundenserver.de (mout.kundenserver.de [217.72.192.73])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 396BE22295;
        Tue, 14 Jun 2022 09:20:45 -0700 (PDT)
Received: from mail-yb1-f179.google.com ([209.85.219.179]) by
 mrelayeu.kundenserver.de (mreue106 [213.165.67.113]) with ESMTPSA (Nemesis)
 id 1MadC8-1nQAtt3KHq-00c8na; Tue, 14 Jun 2022 18:20:44 +0200
Received: by mail-yb1-f179.google.com with SMTP id u99so15976759ybi.11;
        Tue, 14 Jun 2022 09:20:43 -0700 (PDT)
X-Gm-Message-State: AJIora/6g6EPvxslekopfsnoX6xFhapU42p83CqpLpLD8QH4wuuPffIP
        Lgn2GBkENdzz5jtxrW9kYGPFxIhi3qedfXVupN0=
X-Google-Smtp-Source: AGRyM1vL8YmZq2CJCAYY9lO5nRWLWOkqiKpTfzNi8RRXvdFTlfQo46XRqaiOQVYpttr+UTW5s4kkZ2oWrKpG9iJxDw0=
X-Received: by 2002:a25:7645:0:b0:664:70b9:b093 with SMTP id
 r66-20020a257645000000b0066470b9b093mr5733329ybc.480.1655223642290; Tue, 14
 Jun 2022 09:20:42 -0700 (PDT)
MIME-Version: 1.0
References: <202206120438.Un6Wq4N0-lkp@intel.com>
In-Reply-To: <202206120438.Un6Wq4N0-lkp@intel.com>
From:   Arnd Bergmann <arnd@arndb.de>
Date:   Tue, 14 Jun 2022 18:20:25 +0200
X-Gmail-Original-Message-ID: <CAK8P3a3dvzLhAGV8rdCpX__54vkL0=e5pACUY-es3xiJau=uwg@mail.gmail.com>
Message-ID: <CAK8P3a3dvzLhAGV8rdCpX__54vkL0=e5pACUY-es3xiJau=uwg@mail.gmail.com>
Subject: Re: arm-linux-gnueabi-ld: error: .btf.vmlinux.bin.o is already in
 final BE8 format
To:     kernel test robot <lkp@intel.com>
Cc:     Arnd Bergmann <arnd@arndb.de>, kbuild-all@lists.01.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf <bpf@vger.kernel.org>, Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        Networking <netdev@vger.kernel.org>,
        Ard Biesheuvel <ardb@kernel.org>,
        Russell King <rmk+kernel@armlinux.org.uk>
Content-Type: text/plain; charset="UTF-8"
X-Provags-ID: V03:K1:igAUm1LzDSLl29TXXz/+lQAUwgRNCk6eMol8eFWliL6moUdfvqg
 ZedgsqHBkdqYthWVHsqcekZlVk8i2lJX1jvFOG8tM/QGWI+VDaDrDfpO9+4I+OEYPcxGakO
 0kyCxNVykYiYSgvE0Wv1vwBFdLt5TX9IRWTULRGBkYWtEic2CbZCicWmawl+zvcqv1w6hF/
 eiyvc6n4BzZeDiwtNtvvQ==
X-UI-Out-Filterresults: notjunk:1;V03:K0:yHDEjxbyy+8=:Rw4wAtq/uqU2yJrfg/zEde
 Fns53zpACA3tdkPDsH0IMz4lOVcCd6sziz3TuYGmOFLHUZJx2BKOyhMGD0Ka6bJoNqgSuYdMA
 c+cG8c9XFXg7gyLfWhcKsWTmio7aFOFQd9PxJoK6t/kgo/K2C6AqCsT7FBcX46WS3BF7QlEsE
 0Dw9uoYEJZJ15jS4k6tV0SLC6IcSzC5DXDNra8BMSMKhKwIaaKh5IX6jPTS5TOPClWejFjV5W
 AFGWo5YG9fGbMO0191pSSp2W5w2M0gdrVPKFpRO+0+GsjrLYbYlEGpwb8iFLVedfPlenVmREw
 yBQrS/Jy2dJBmd4D3GsGXDuLzZkud6h4EiYH422yY8QRuscFp+CK9KRKNWX2983fInRcXTNtx
 4kb7b9nLi0EBmAo5nJSh5ZZeZEu0QHMouzhzAoftsJgeBzKaLwZ4smeldIPuC5j3aw1y/8GzS
 trCnKSbtefw1u0wsp4H4zuEXtIOZ2GBxZXBTDqoNfz2wvAfMr6uX6iMyLsnQDMtgSuHoGY6il
 pKhuZC4fZeSTqCNQoU5HWzWcTazsOU0bvr20JDzdfERQuajdX5sq0qVeX7C8GKnWlkQGL2oPH
 G8A/MFuUeYcAzhVIPOipBrLv2BST9jqGA58BhB9BO3Yniu37xjQts85oITlGRCU0WWg/zBux0
 0yhQtCm+tTItSiFkbZ9RrR0EAoEJFYEogd8cKCGBGnZs4sG2cMrqtskdm92HDgVAOYtBbvYmd
 dgNdJFkduWyOdKoO8RSOUmjGIO1lN+XXIanb+LGLvK7JgRZbNel5+9OjPMZfC6/wHWxX8dhS4
 j9J5MM0iaRZZ/KlQvA8qVhQfKvgtivSLu+O0vU4bNf8m9pNa/I6G4f45BJ6d+ThU29u5ukGBE
 CykbGr8y1Ok76xGKneNQ==
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,RCVD_IN_DNSWL_NONE,
        RCVD_IN_MSPIKE_H2,SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE
        autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Sat, Jun 11, 2022 at 11:00 PM kernel test robot <lkp@intel.com> wrote:
>
> tree:   https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git master
> head:   0678afa6055d14799c1dc1eee47c8025eba56cab
> commit: 5d6f52671e76ca2d55d74e676ac4c38ceb14a2d3 ARM: rework endianess selection
> date:   9 weeks ago
> configrong.a.chen@intel.com: arm-randconfig-r012-20220612 (https://download.01.org/0day-ci/archive/20220612/202206120438.Un6Wq4N0-lkp@intel.com/config)
> compiler: arm-linux-gnueabi-gcc (GCC) 11.3.0
> reproduce (this is a W=1 build):
>         wget https://raw.githubusercontent.com/intel/lkp-tests/master/sbin/make.cross -O ~/bin/make.cross
>         chmod +x ~/bin/make.cross
>         # https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git/commit/?id=5d6f52671e76ca2d55d74e676ac4c38ceb14a2d3
>         git remote add linus https://git.kernel.org/pub/scm/linux/kernel/git/torvalds/linux.git
>         git fetch --no-tags linus master
>         git checkout 5d6f52671e76ca2d55d74e676ac4c38ceb14a2d3
>         # save the config file
>         mkdir build_dir && cp config build_dir/.config
>         COMPILER_INSTALL_PATH=$HOME/0day COMPILER=gcc-11.3.0 make.cross W=1 O=build_dir ARCH=arm SHELL=/bin/bash
>
> If you fix the issue, kindly add following tag where applicable
> Reported-by: kernel test robot <lkp@intel.com>
>
> All errors (new ones prefixed by >>):
>
> >> arm-linux-gnueabi-ld: error: .btf.vmlinux.bin.o is already in final BE8 format
>    arm-linux-gnueabi-ld: failed to merge target specific data of file .btf.vmlinux.bin.o

I had a look at this bug, and found that this is not caused by my commit, but
rather is the result of CONFIG_CPU_BIG_ENDIAN with BE8 format being
incompatible with CONFIG_DEBUG_INFO_BTF.

I'm sure there is an easy fix but I have not found it. Should we just
add a Kconfig
dependency to prevent this, or does anyone have an idea for a proper fix?

          Arnd
