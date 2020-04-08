Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id AB7471A1DE0
	for <lists+netdev@lfdr.de>; Wed,  8 Apr 2020 11:07:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727847AbgDHJHf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Apr 2020 05:07:35 -0400
Received: from mail-wr1-f66.google.com ([209.85.221.66]:33427 "EHLO
        mail-wr1-f66.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726775AbgDHJHf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Apr 2020 05:07:35 -0400
Received: by mail-wr1-f66.google.com with SMTP id a25so6950952wrd.0;
        Wed, 08 Apr 2020 02:07:31 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=tDqXfOMMU1aiMxNa6ojUxPMtJdc9yDWPtU8wKO19sy8=;
        b=T5U7THsUxJ6ZuuPi9pDRbPPmm+vSXjD+chynu68DULjkmf4Ijl5WDG930A+jfwScyE
         cHK2YIEFshNZ8XVTShn/l0OchkLGExiKP/+utKuQchKCt1ZUaRiaqko0M7gHpBqKMp78
         ALncTk314XAIoZ0yr2R4e9wO7bIJNlthy0pavCQ3hwIx552OaMmaYTZ8XfZH0IYs+I5y
         tK8gVAOjCb7tjoJltjkXunryR+5DuxODi7VSMsI34v2iYktll2wPrP6ilwva+ec0yD62
         VKpWKhPRayB6yIBt9HhpCWEZJplzPFqX1iOXLxZ6zdONtLphGdO24xF9lb1U1vTE9vOq
         oLvQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=tDqXfOMMU1aiMxNa6ojUxPMtJdc9yDWPtU8wKO19sy8=;
        b=hmL7bZNg4fXN/RLUcHcbFxeBWqJnnPR211PdlBP1LrhmyQhnLRnIM1bJTUim42U661
         qRSc5j7ZuqIh8tjebf0K+ijJr8yt6lB/rbdlMjaYW4IJIreg2LCCVmKCaF1IvSKhuyU3
         65f1E2/YPZEJvdvJsjpe+lBpBItuhALdySXycn38gkZbMnUkT0GHH2isMKVY2BwQ59sV
         mdvPsKcYZf7KyL1uBfsXkEOSXYsyR6nKM0Sdj3Tl2nSnKOT/n2eF6StyIezli3XvZzR3
         K1+SWYhkmyuP3hzJivm8biEGLsVatnHKnMBcqYUM7Gt1gB5Wswd0bfdXBuP67h5FmPOZ
         wVrw==
X-Gm-Message-State: AGi0PubAxq1xEqa7mBLBupHlJkmXA0gRU56jZCVEGOPBJFkOnN3nc7jP
        Uor1zOcmwM3e5cPiQ1vZdM55adv4SO0xH028Q/o=
X-Google-Smtp-Source: APiQypI2jffggddQs3H73E0fGZHKav2Zl9+DI3ND4AUGi8hLuvcj2nJAqi9tNj7kjAduovm2mQMyvi+oEVtnN1YlUkE=
X-Received: by 2002:a05:6000:4c:: with SMTP id k12mr964994wrx.179.1586336850824;
 Wed, 08 Apr 2020 02:07:30 -0700 (PDT)
MIME-Version: 1.0
References: <20200402050219.4842-1-chris@rorvick.com> <20200406141058.29895C43637@smtp.codeaurora.org>
 <CA+icZUUOQ0KTJM6w7yfj=g3BprQqJtTQjCjiXRb9dTTeoQL8KA@mail.gmail.com>
In-Reply-To: <CA+icZUUOQ0KTJM6w7yfj=g3BprQqJtTQjCjiXRb9dTTeoQL8KA@mail.gmail.com>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Wed, 8 Apr 2020 11:07:19 +0200
Message-ID: <CA+icZUUiY5tjxgY58383mtXGGiwsRU+t6SX+CtVUN_0cjcLJTQ@mail.gmail.com>
Subject: Re: [PATCH] iwlwifi: actually check allocated conf_tlv pointer
To:     Kalle Valo <kvalo@codeaurora.org>
Cc:     Chris Rorvick <chris@rorvick.com>, linux-wireless@vger.kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Luca Coelho <luciano.coelho@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        "David S. Miller" <davem@davemloft.net>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Apr 6, 2020 at 9:53 PM Sedat Dilek <sedat.dilek@gmail.com> wrote:
>
> On Mon, Apr 6, 2020 at 4:11 PM Kalle Valo <kvalo@codeaurora.org> wrote:
> >
> > Chris Rorvick <chris@rorvick.com> wrote:
> >
> > > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> > > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> > > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> > > check correctly.
> > >
> > > This can happen in OOM situations and, when it does, we will potentially try to
> > > dereference a NULL pointer.
> > >
> > > Tweeted-by: @grsecurity
> > > Signed-off-by: Chris Rorvick <chris@rorvick.com>
> >
> > Fails to build, please rebase on top of wireless-drivers.
> >
> > drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_req_fw_callback':
> > drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1470:16: error: 'struct iwl_fw' has no member named 'dbg_conf_tlv'
> >     if (!drv->fw.dbg_conf_tlv[i])
> >                 ^
> > make[5]: *** [drivers/net/wireless/intel/iwlwifi/iwl-drv.o] Error 1
> > make[5]: *** Waiting for unfinished jobs....
> > make[4]: *** [drivers/net/wireless/intel/iwlwifi] Error 2
> > make[3]: *** [drivers/net/wireless/intel] Error 2
> > make[2]: *** [drivers/net/wireless] Error 2
> > make[1]: *** [drivers/net] Error 2
> > make[1]: *** Waiting for unfinished jobs....
> > make: *** [drivers] Error 2
> >
>
> Should be:
>
> $ git diff
> diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> index 0481796f75bc..c24350222133 100644
> --- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> +++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
> @@ -1467,7 +1467,7 @@ static void iwl_req_fw_callback(const struct
> firmware *ucode_raw, void *context)
>                                 kmemdup(pieces->dbg_conf_tlv[i],
>                                         pieces->dbg_conf_tlv_len[i],
>                                         GFP_KERNEL);

Maybe this diff is clearer:

$ diff iwlwifi-actually-check-allocated-conf_tlv-pointer.patch
iwlwifi-actually-check-allocated-conf_tlv-pointer-v2-dileks.patch
95a96
> Fixes: 71bc0334a637 ("iwlwifi: check allocated pointer when allocating conf_tlvs")
99c100,104
< In this wasn't picked up?
---
>
> [ v1->v2:
>   - Fix typo s/fw.dbg_conf_tlv/fw.dbg.conf_tlv
>   - Add Fixes tag as suggested by Kalle
> -dileks ]
115c120
< +                     if (!drv->fw.dbg_conf_tlv[i])
---
> +                     if (!drv->fw.dbg.conf_tlv[i])

Tested on top of Linux v5.6.3.

- Sedat -
