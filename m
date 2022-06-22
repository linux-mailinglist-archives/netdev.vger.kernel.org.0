Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 624B6553F69
	for <lists+netdev@lfdr.de>; Wed, 22 Jun 2022 02:19:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1353956AbiFVATZ (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 21 Jun 2022 20:19:25 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35476 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231569AbiFVATX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 21 Jun 2022 20:19:23 -0400
Received: from sonic308-16.consmr.mail.ne1.yahoo.com (sonic308-16.consmr.mail.ne1.yahoo.com [66.163.187.39])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id D2D4825C59
        for <netdev@vger.kernel.org>; Tue, 21 Jun 2022 17:19:21 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655857161; bh=LduUrw3eVyp6mK0CVKmYw4M59cd6hwNqy8Oc641QJFE=; h=Date:Subject:To:Cc:References:From:In-Reply-To:From:Subject:Reply-To; b=ga1vDngwiwM55nMY03lGZvtii8Fm1eWiG/k66DEH4EXprwPWRsKfEucaq2MabOP5YL7GTW2rcVgSdjbqTI6dD0tl73j1vJJs53Qj3ffhvDbIDrqfPHo5UbP/Q7PMzDnlilXIEhhI4VCvKm+saTnT5xlBbJH9hXfhyZfIwJ75BC6UqYFfcDkGlfxadVK2XWJl4ZISomM2+5pyBoBpshDOL0ijN8eK7tCYZndKM3c/GZvQEW4io7YDf1rfBVQ2Z0alYjBFaaseYj0/o7nfwnplJCVMCqPmRn9XcjRtm/HcTkNPGEm98lqMiad7GmEcxCnnjF3rq5LkQKjtMJ0592uj6Q==
X-SONIC-DKIM-SIGN: v=1; a=rsa-sha256; c=relaxed/relaxed; d=yahoo.com; s=s2048; t=1655857161; bh=Damb/FchBMGqo36QVmZilqPN1InpZOwIXasJWXsBfIC=; h=X-Sonic-MF:Date:Subject:To:From:From:Subject; b=HM3rHxxAduejaYdLVdLUx0+EYZl9v32YVS53OF38jaQTHFH2Rv8iHdL5PRsGN0SbtGnoYL+P7jPkzyUccqKHJpSUz9G3s14kcBOrlvzbEIPY5DGC+O721X3v7otbjQ06lMK/21PWFJymUTL68MwM8Ymt+9OPKktLA1yZc0HbReQwd5jFur4bRROl1J94BYxg9FOy2g2i9iAaXqRFyOhqe+yqsiNLeWw6pfo8WKAOwSXpDCVkYz/qOzWK8D+yof81dh7nn1zbGZtXS7yRvdQpdqeUD6No7avSOOxACBW+EaI23OXB1j3s8TJHSttTd1JrGNx/wTSVoJa4innJRA6djw==
X-YMail-OSG: kTbEmRgVM1lycM4fN4Fo0k5USdwJrrQonPUOb9bDgKcBdzB.B1dR4UrLmmh4LNZ
 FHC1kjd2FCK_si76YkFdeNQDgCsUG1zYndHE.krl.4KOlp5P4Inkcs8haXpNeLoYSUB0Zj7Ok4.h
 0_bdRSaacplsY3sgOphvlxvlN_whPBQYbwNLRBe3Vr3405fuayHKp44Zdm8ATQ9jZxrAj2JNiumV
 npWlMRwWlFiN22DzHMUDTYXfJkxXchCbq5MVPlhp5Jf2dWJL9BCp8T_oZxlWK6emb4SQCFrOyIAx
 lzBncDVnZaOoOf46d2OtQgfbgpZbo8X788o0Qm3GgnDWFgsOfaz2oy4HmnfB5g2eBkVGMZnHHpma
 Zhb1nQsM9dctR3vd4fcJWtcmw241XXvwbL6Y32cMNybssfsrCE_kB_hyKAeWp8UwRPg6nZgqTPTh
 ETonSXR2NamGGnN2eDluWyyPa3xXHdUAOJt2BzMTR3u8ukTnZdtg1LDTuPZ2aQgUON653.3Xik_r
 9t_jY32JPfHKlOa5oPGQn2CyxXYX9sO09E4zc6yeelv6QZFk0.hwYANtPYnt8O1FF1MntLflrnN0
 yVmSWENGMaRagyI.Cs5wAG6Nt_f7R_z4a2xDU7o6Cwkt_CmHd131DZ53OUajshoSaf84X3ErqRhq
 5eDzAQDKXpoFfLnQPSVvhIZcZllxdUm6jPMD9cYWZGZISQvliX3bjAZZOL2aQtiUgLcCdVrEcFpc
 HDVnWMGH6i3X4rwb_OF6UQ0P0gCVON9mxUGD_41cSFFIYBC5r1DOvTAN6LlGCo04jwdPHwxu9TM6
 PO0AK4nckvxcZGZgLt701vOO_Ycuq1N7tGOu57D6nAm6DcfiGvAfPEB9CXZIE3K892rD5wM7KEpM
 bOosOIlIKcuhYsPjYG_9slhBuXwAzESat2TNqsXggjkV_H0n6r.cVtITZsPoT01JsaiPRV24vhkd
 yBo0_XOMfu89Zw_BEuwfJ23jB7Yh0xXoUymOEAAKe1xxGT4TANA1CL3z9I6fyI12iHJ5iwCo1Y.f
 .VWHHi2R2na0ZSXG_RFp42AttcMjRPqLqfraaUd.z89BCFNrn7NBk6D7FwX0LvjEfRKKJFbLO_0n
 XWOk55wmVrhNZTbr7EZaWF7pxQH5sRivoslQWdSIO4yNKyNzVy75SJskii7qIT0ZP8Dt.sCyLCNN
 ZmuQVZfskm8NiWznmAEDC_vRsbtsKux7.S1TZizyhuZVaRwWC4QWLy34CplRQno9_n96iWw6pCcE
 MtgbR34Otba5JiTL6kW4jG2amGCeHBtCjV3rrmZct1cMCg9ZKLNJKu_UD4ulFbc8j7gBpP3c9XUj
 CRkI1xSrW7SfelzTG.Y4BTSZjxHP2UxWWLyamAux4mEgnETm3Xd7FA.bw7451.Ptn6Gnck1SBn30
 vATtV1OyQ4ftbrfCc1FVh170v6xTcrJ7rITQ6ybLoOSuYb2HQsJ6KUAciCmjhGoRkbAfw.ABSMHS
 qsOAoZ0WMm54hEqq9XZDSdJifHUjMnx5qB9hzJp.11JkGY_nUdVeFKQr2lEFUOGZPvHXc9.1OXuV
 chitkUqWHTambDZMLkDDv4NGqAFNvAzhdPaEao8hE3eSS95pYA_hkD4CPmOAZQ3jjClZccu0xg0i
 lOcZLwaJEBVwUkPIWixfrMMU1Vkk0prmbyWXuWClAp5.upWmvQoE_2UBV3w6nooKuQC.N0UAFKHM
 pygv_D_MNOUSGRC6ZdnIlX0AedQ7ZePAoR4AOkDl2WPZxLUXCm2ZBykBtdtmnX06uq9836hXW.Fo
 TXUtkPHWewUXts9V5TPEEbmcIvlwPFLD2frYYDcwau3TydYXioaJibz6kv.0in5qjsdk2jdkSzNE
 Rmez0IZyxRR.iAL0je9GlPU8fI.bIYBpEfoWEZuHQ1uhaIwoCvMD0hP6AbKDc2Nk_.BA.P712Ekw
 VWO0zaWAazBDeedF5f2pH_n3yMI5wZnllUoJdtFsRGT9Vhii7nidn8EkxWGahXqQOahVOMvKkcXD
 a4lbu8Kvpcd_rp9d_.AnYhC1a.ICdvP6ZLqq96n3RPuLV0atC28qoRwEWfp1fdntKURaYXMB_lJe
 K.nYkp_zK4AUuy7hhgzo6YFMfcU3o0DPICJTijBHc.au9ADC_o4xl9Ny1Lwd11xag1_zqSoSHCsH
 QAYLxDBaVczxZQ1ZS12woM5wc9txPgaTF4ywnRg0ViSpHjSYb1rCAt5fVKd2fniRoGaoKXpjo9G8
 vo8ilkcltbfKMHuZKsBMs6pOPfr3rLi0XiBpZtSRiC_bCKMOgDprLfdkSa434FXtfCO.sxkwx4BM
 -
X-Sonic-MF: <casey@schaufler-ca.com>
Received: from sonic.gate.mail.ne1.yahoo.com by sonic308.consmr.mail.ne1.yahoo.com with HTTP; Wed, 22 Jun 2022 00:19:21 +0000
Received: by hermes--canary-production-bf1-8bb76d6cf-xkxwt (Yahoo Inc. Hermes SMTP Server) with ESMTPA ID caa03a9c3f5621a0acb91f535e7b9383;
          Wed, 22 Jun 2022 00:19:18 +0000 (UTC)
Message-ID: <ce1653b1-feb0-1a99-0e97-8dfb289eeb79@schaufler-ca.com>
Date:   Tue, 21 Jun 2022 17:19:15 -0700
MIME-Version: 1.0
User-Agent: Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:91.0) Gecko/20100101
 Thunderbird/91.10.0
Subject: Re: [PATCH 0/2] Introduce security_create_user_ns()
Content-Language: en-US
To:     Frederick Lawler <fred@cloudflare.com>, kpsingh@kernel.org,
        revest@chromium.org, jackmanb@chromium.org, ast@kernel.org,
        daniel@iogearbox.net, andrii@kernel.org, kafai@fb.com,
        songliubraving@fb.com, yhs@fb.com, john.fastabend@gmail.com,
        jmorris@namei.org, serge@hallyn.com, bpf@vger.kernel.org,
        linux-security-module@vger.kernel.org
Cc:     brauner@kernel.org, paul@paul-moore.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-team@cloudflare.com,
        Casey Schaufler <casey@schaufler-ca.com>
References: <20220621233939.993579-1-fred@cloudflare.com>
From:   Casey Schaufler <casey@schaufler-ca.com>
In-Reply-To: <20220621233939.993579-1-fred@cloudflare.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Mailer: WebService/1.1.20280 mail.backend.jedi.jws.acl:role.jedi.acl.token.atz.jws.hermes.yahoo
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,NICE_REPLY_A,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE,
        T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 6/21/2022 4:39 PM, Frederick Lawler wrote:
> While creating a LSM BPF MAC policy to block user namespace creation, we
> used the LSM cred_prepare hook because that is the closest hook to prevent
> a call to create_user_ns().
>
> The calls look something like this:
>
>      cred = prepare_creds()
>          security_prepare_creds()
>              call_int_hook(cred_prepare, ...
>      if (cred)
>          create_user_ns(cred)
>
> We noticed that error codes were not propagated from this hook and
> introduced a patch [1] to propagate those errors.
>
> The discussion notes that security_prepare_creds()
> is not appropriate for MAC policies, and instead the hook is
> meant for LSM authors to prepare credentials for mutation. [2]
>
> Ultimately, we concluded that a better course of action is to introduce
> a new security hook for LSM authors. [3]
>
> This patch set first introduces a new security_create_user_ns() function
> and create_user_ns LSM hook, then marks the hook as sleepable in BPF.

Why restrict this hook to user namespaces? It seems that an LSM that
chooses to preform controls on user namespaces may want to do so for
network namespaces as well. Also, the hook seems backwards. You should
decide if the creation of the namespace is allowed before you create it.
Passing the new namespace to a function that checks to see creating a
namespace is allowed doesn't make a lot off sense.

>
> Links:
> 1. https://lore.kernel.org/all/20220608150942.776446-1-fred@cloudflare.com/
> 2. https://lore.kernel.org/all/87y1xzyhub.fsf@email.froward.int.ebiederm.org/
> 3. https://lore.kernel.org/all/9fe9cd9f-1ded-a179-8ded-5fde8960a586@cloudflare.com/
>
> Frederick Lawler (2):
>    security, lsm: Introduce security_create_user_ns()
>    bpf-lsm: Make bpf_lsm_create_user_ns() sleepable
>
>   include/linux/lsm_hook_defs.h | 2 ++
>   include/linux/lsm_hooks.h     | 5 +++++
>   include/linux/security.h      | 8 ++++++++
>   kernel/bpf/bpf_lsm.c          | 1 +
>   kernel/user_namespace.c       | 5 +++++
>   security/security.c           | 6 ++++++
>   6 files changed, 27 insertions(+)
>
> --
> 2.30.2
>
