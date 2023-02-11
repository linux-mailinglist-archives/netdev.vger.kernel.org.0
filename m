Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id E6DEA692C13
	for <lists+netdev@lfdr.de>; Sat, 11 Feb 2023 01:30:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229640AbjBKAa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Feb 2023 19:30:28 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:52614 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229473AbjBKAaY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Feb 2023 19:30:24 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 30284FB;
        Fri, 10 Feb 2023 16:30:23 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id DA162B82654;
        Sat, 11 Feb 2023 00:30:21 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id A2D29C4339C;
        Sat, 11 Feb 2023 00:30:20 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676075420;
        bh=XEnPFOJ4CxMJH7vgfkFyQKY4s2/0EUC8Eknfpc5jk+s=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=ax5Fd5J1UIn8ED+GyB4f+E8hJ9LztVDn7UWC4mXnOgmf1KRe9qg37VcP6B98kKnsO
         LZzZNA4MyyMSEIeG7mqIPLuzuz9GmmbPPuWcsDH0Kn9CG/IJyeHa00w9d6VJpmGmI4
         NXRL4d9rj/vrxhHmcYkuvvsfAImKsX22nRKpEN6IZm/ArT43ezp69CpPKFWLzONl7c
         8gCOQZrkyi8vqNwPvy5MhnCJYm+ujIZHdOmgGLEGxaUbIkSFrVEqOIZ1FTpVoog4RF
         TTYadPmdXwwh9e6QDAyw5jGTuEaFaEB2cc1S76SGjrhSDxS3EsrNV3ZLEUNm5ahnDy
         xyu+Hg0HqKq8Q==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 740A6E21EC7;
        Sat, 11 Feb 2023 00:30:20 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/24 v2] Documentation: correct lots of spelling errors
 (series 1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167607542046.32477.11523239261636548840.git-patchwork-notify@kernel.org>
Date:   Sat, 11 Feb 2023 00:30:20 +0000
References: <20230209071400.31476-1-rdunlap@infradead.org>
In-Reply-To: <20230209071400.31476-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        linux@armlinux.org.uk, axboe@kernel.dk, olteanv@gmail.com,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        akinobu.mita@gmail.com, deller@gmx.de, dmitry.torokhov@gmail.com,
        rydberg@bitmath.org, isdn@linux-pingi.de, jikos@kernel.org,
        mbenes@suse.cz, pmladek@suse.com, jpoimboe@kernel.org,
        peterz@infradead.org, mingo@redhat.com, will@kernel.org,
        jglisse@redhat.com, naoya.horiguchi@nec.com, linmiaohe@huawei.com,
        jonas@southpole.se, stefan.kristiansson@saunalahti.fi,
        shorne@gmail.com, bhelgaas@google.com, lpieralisi@kernel.org,
        maz@kernel.org, mpe@ellerman.id.au, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dhowells@redhat.com, jarkko@kernel.org,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        bristot@kernel.org, rostedt@goodmis.org, mhiramat@kernel.org,
        mathieu.poirier@linaro.org, suzuki.poulose@arm.com,
        zbr@ioremap.net, fenghua.yu@intel.com, reinette.chatre@intel.com,
        tglx@linutronix.de, bp@alien8.de, chris@zankel.net,
        jcmvbkbc@gmail.com, coresight@lists.linaro.org,
        dri-devel@lists.freedesktop.org, keyrings@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-input@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-security-module@vger.kernel.org, linux-usb@vger.kernel.org,
        netdev@vger.kernel.org, linux-mm@kvack.org,
        openrisc@lists.librecores.org,
        linux-arm-kernel@lists.infradead.org,
        linux-xtensa@linux-xtensa.org, linuxppc-dev@lists.ozlabs.org,
        x86@kernel.org
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello:

This series was applied to netdev/net-next.git (master)
by Jakub Kicinski <kuba@kernel.org>:

On Wed,  8 Feb 2023 23:13:36 -0800 you wrote:
> Correct many spelling errors in Documentation/ as reported by codespell.
> 
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series.
> 
> These patches are based on linux-next-20230209.
> 
> [...]

Here is the summary with links:
  - [03/24] Documentation: core-api: correct spelling
    (no matching commit)
  - [08/24] Documentation: isdn: correct spelling
    https://git.kernel.org/netdev/net-next/c/d12f9ad02806

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


