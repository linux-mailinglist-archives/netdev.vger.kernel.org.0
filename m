Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id B1FAC67FAEC
	for <lists+netdev@lfdr.de>; Sat, 28 Jan 2023 21:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231376AbjA1Uaa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 28 Jan 2023 15:30:30 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:57328 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S233816AbjA1UaV (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sat, 28 Jan 2023 15:30:21 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51E9E1C305;
        Sat, 28 Jan 2023 12:30:19 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 3F85DB80BEC;
        Sat, 28 Jan 2023 20:30:18 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPS id AA46EC4339C;
        Sat, 28 Jan 2023 20:30:16 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1674937816;
        bh=NyfyYmvHuYCep7B9YHaipGsiO9fFZKxd2hw/3QQJwqQ=;
        h=Subject:From:Date:References:In-Reply-To:To:Cc:From;
        b=LEOdKD+xVK+ChdUeMYF7EWUBmGq14I7a4s4JCxsX0Z2pbDfy98ZnOQg9LaM70RuVC
         9xRu4+lF+DVHmBGVHpWV6C3DKQnB6htlyuiQ1J3mBpVE0Cta4vW2RE/BXmcJavx0so
         NpT9ZM/k0gp3REittQZbOAE5Pu2nnNW4ZzWWewKaFAFD3E6WwCsC+zOFh5CoV4HfQe
         lQLG294nW9w5VbGq5Yt6s9D6T/oia27mZXgUwJMw43HV8z7gJz+N1dbAJrJr5rDjld
         W58/LuDYy+LQisFZsbodjJ+lGQoGjrCfyPfOcghY/B7T6gUkoFPJyIGFHljP3NeW1j
         sFiy6/39HdTbA==
Received: from aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (localhost.localdomain [127.0.0.1])
        by aws-us-west-2-korg-oddjob-1.ci.codeaurora.org (Postfix) with ESMTP id 76D09E52504;
        Sat, 28 Jan 2023 20:30:16 +0000 (UTC)
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Subject: Re: [PATCH 00/35] Documentation: correct lots of spelling errors (series
 1)
From:   patchwork-bot+netdevbpf@kernel.org
Message-Id: <167493781647.31903.18128774325127042067.git-patchwork-notify@kernel.org>
Date:   Sat, 28 Jan 2023 20:30:16 +0000
References: <20230127064005.1558-1-rdunlap@infradead.org>
In-Reply-To: <20230127064005.1558-1-rdunlap@infradead.org>
To:     Randy Dunlap <rdunlap@infradead.org>
Cc:     linux-kernel@vger.kernel.org, corbet@lwn.net,
        catalin.marinas@arm.com, will@kernel.org, linux@armlinux.org.uk,
        axboe@kernel.dk, andrii@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, olteanv@gmail.com,
        steffen.klassert@secunet.com, daniel.m.jordan@oracle.com,
        akinobu.mita@gmail.com, deller@gmx.de, rafael@kernel.org,
        jikos@kernel.org, benjamin.tissoires@redhat.com,
        srinivas.pandruvada@linux.intel.com, wsa@kernel.org,
        dmitry.torokhov@gmail.com, rydberg@bitmath.org,
        isdn@linux-pingi.de, pavel@ucw.cz, lee@kernel.org,
        jpoimboe@kernel.org, mbenes@suse.cz, pmladek@suse.com,
        peterz@infradead.org, mingo@redhat.com, jglisse@redhat.com,
        naoya.horiguchi@nec.com, linmiaohe@huawei.com, jonas@southpole.se,
        stefan.kristiansson@saunalahti.fi, shorne@gmail.com,
        bhelgaas@google.com, lpieralisi@kernel.org, maz@kernel.org,
        mpe@ellerman.id.au, len.brown@intel.com, hca@linux.ibm.com,
        gor@linux.ibm.com, agordeev@linux.ibm.com, juri.lelli@redhat.com,
        vincent.guittot@linaro.org, dhowells@redhat.com, jarkko@kernel.org,
        paul@paul-moore.com, jmorris@namei.org, serge@hallyn.com,
        perex@perex.cz, tiwai@suse.com, broonie@kernel.org,
        martin.petersen@oracle.com, bristot@kernel.org,
        rostedt@goodmis.org, gregkh@linuxfoundation.org,
        mhiramat@kernel.org, mathieu.poirier@linaro.org,
        suzuki.poulose@arm.com, zbr@ioremap.net, fenghua.yu@intel.com,
        reinette.chatre@intel.com, tglx@linutronix.de, bp@alien8.de,
        chris@zankel.net, jcmvbkbc@gmail.com, alsa-devel@alsa-project.org,
        coresight@lists.linaro.org, bpf@vger.kernel.org,
        dri-devel@lists.freedesktop.org, isdn4linux@listserv.isdn4linux.de,
        keyrings@vger.kernel.org, linux-acpi@vger.kernel.org,
        linux-block@vger.kernel.org, linux-crypto@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-fbdev@vger.kernel.org,
        linux-i2c@vger.kernel.org, linux-input@vger.kernel.org,
        linux-leds@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-s390@vger.kernel.org, linux-scsi@vger.kernel.org,
        linux-sgx@vger.kernel.org, linux-spi@vger.kernel.org,
        linux-trace-devel@vger.kernel.org,
        linux-trace-kernel@vger.kernel.org, live-patching@vger.kernel.org,
        linux-pm@vger.kernel.org, linux-security-module@vger.kernel.org,
        linux-usb@vger.kernel.org, netdev@vger.kernel.org,
        target-devel@vger.kernel.org, linux-mm@kvack.org,
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

This series was applied to bpf/bpf-next.git (master)
by Alexei Starovoitov <ast@kernel.org>:

On Thu, 26 Jan 2023 22:39:30 -0800 you wrote:
> Correct many spelling errors in Documentation/ as reported by codespell.
> 
> Maintainers of specific kernel subsystems are only Cc-ed on their
> respective patches, not the entire series. [if all goes well]
> 
> These patches are based on linux-next-20230125.
> 
> [...]

Here is the summary with links:
  - [04/35] Documentation: bpf: correct spelling
    https://git.kernel.org/bpf/bpf-next/c/1d3cab43f4c7
  - [05/35] Documentation: core-api: correct spelling
    (no matching commit)
  - [13/35] Documentation: isdn: correct spelling
    (no matching commit)

You are awesome, thank you!
-- 
Deet-doot-dot, I am a bot.
https://korg.docs.kernel.org/patchwork/pwbot.html


