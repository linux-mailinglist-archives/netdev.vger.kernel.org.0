Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 8630019FE7A
	for <lists+netdev@lfdr.de>; Mon,  6 Apr 2020 21:53:13 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbgDFTxG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Apr 2020 15:53:06 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:43010 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726220AbgDFTxF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Apr 2020 15:53:05 -0400
Received: by mail-wr1-f68.google.com with SMTP id w15so956340wrv.10;
        Mon, 06 Apr 2020 12:53:04 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:reply-to:from:date:message-id
         :subject:to:cc;
        bh=cLKnKuTpDDcnnvckRKd8EsE8Je/PkHgph1cfVvzxLuk=;
        b=jJMQ7+j0gvWZrDFhqYqsdxda6c9tMvnWSTCseMEXWqiglzwpm24miH2hSvj+JeP2+h
         3Yb1LEmu5SM/BQLHBJE7VtMJgDTnVmTpoZRf8YU/mObl+K3hO4TbqI4QU7wa2GpKD545
         xEx0513G3lXUeQsbCmMaV5ugfSHPW6cE47ruF/YsGdCFbMVJak9kuUjZZX/Dx4bhOHGT
         IEwrAf31+S9Wi7p7qNCacdxrkeYYiQI75tTiSmJYkjHKD6J7ygODrK/7f6P6Zb0nDMCh
         PrjS2o2ee4d8OU43dU0zKN5iO9rn91HrSnOM+QJ2WtO/vzb5lz8yZMGrLD1RBXPgE11P
         VkOQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:reply-to
         :from:date:message-id:subject:to:cc;
        bh=cLKnKuTpDDcnnvckRKd8EsE8Je/PkHgph1cfVvzxLuk=;
        b=lG6VohdD+cKWy3ANp8LcXbv07qKi/352ELN6sG9v4gF0LiPbvBYMYqAeuHCp/wk9Ba
         2FDv0To3D4+6Go0MaZx9+xscDVP82b2R1/7sEhyxamtRkmOIFwU34pcrbO7WOMHFPz7Q
         2lXdTcEIX92AvjkOs21MN2JoMOc6ZOluUkeYj3BOI46GybQ4/ql47e38l7lt1G+OC9Oa
         vT9z//bIhlLSBahYSFSa08PXnUrxIBiBPfbGkl3l/GrOtnhUcb193e722/Ieej2iij1u
         ZMj0kK01Gn1+J06xBFgBasU+dqUdXl4cBJMVJOBfCan05hsO7B8A87zYOSg13h6t0ewe
         /XVQ==
X-Gm-Message-State: AGi0PuZuRMgyXIEx7I3GtWrcADoR9xCXD6nQNsu0kgXm8zD0ZL3xCoHk
        NS7nyepja45qXZPknPY4vl5u8WClzXpB9RxOl6E9DuGqu4k=
X-Google-Smtp-Source: APiQypLSV1ZoyA8Vopu8CC9juJ2Xs3xUcrjwFHtw9Cr0w7PDYiUVKbIb1hV7mra2/vPb2XQ2ZWP2a6vk2SDoXpf01eI=
X-Received: by 2002:adf:b64f:: with SMTP id i15mr941499wre.351.1586202783518;
 Mon, 06 Apr 2020 12:53:03 -0700 (PDT)
MIME-Version: 1.0
References: <20200402050219.4842-1-chris@rorvick.com> <20200406141058.29895C43637@smtp.codeaurora.org>
In-Reply-To: <20200406141058.29895C43637@smtp.codeaurora.org>
Reply-To: sedat.dilek@gmail.com
From:   Sedat Dilek <sedat.dilek@gmail.com>
Date:   Mon, 6 Apr 2020 21:53:24 +0200
Message-ID: <CA+icZUUOQ0KTJM6w7yfj=g3BprQqJtTQjCjiXRb9dTTeoQL8KA@mail.gmail.com>
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

On Mon, Apr 6, 2020 at 4:11 PM Kalle Valo <kvalo@codeaurora.org> wrote:
>
> Chris Rorvick <chris@rorvick.com> wrote:
>
> > Commit 71bc0334a637 ("iwlwifi: check allocated pointer when allocating
> > conf_tlvs") attempted to fix a typoe introduced by commit 17b809c9b22e
> > ("iwlwifi: dbg: move debug data to a struct") but does not implement the
> > check correctly.
> >
> > This can happen in OOM situations and, when it does, we will potentially try to
> > dereference a NULL pointer.
> >
> > Tweeted-by: @grsecurity
> > Signed-off-by: Chris Rorvick <chris@rorvick.com>
>
> Fails to build, please rebase on top of wireless-drivers.
>
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c: In function 'iwl_req_fw_callback':
> drivers/net/wireless/intel/iwlwifi/iwl-drv.c:1470:16: error: 'struct iwl_fw' has no member named 'dbg_conf_tlv'
>     if (!drv->fw.dbg_conf_tlv[i])
>                 ^
> make[5]: *** [drivers/net/wireless/intel/iwlwifi/iwl-drv.o] Error 1
> make[5]: *** Waiting for unfinished jobs....
> make[4]: *** [drivers/net/wireless/intel/iwlwifi] Error 2
> make[3]: *** [drivers/net/wireless/intel] Error 2
> make[2]: *** [drivers/net/wireless] Error 2
> make[1]: *** [drivers/net] Error 2
> make[1]: *** Waiting for unfinished jobs....
> make: *** [drivers] Error 2
>

Should be:

$ git diff
diff --git a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
index 0481796f75bc..c24350222133 100644
--- a/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
+++ b/drivers/net/wireless/intel/iwlwifi/iwl-drv.c
@@ -1467,7 +1467,7 @@ static void iwl_req_fw_callback(const struct
firmware *ucode_raw, void *context)
                                kmemdup(pieces->dbg_conf_tlv[i],
                                        pieces->dbg_conf_tlv_len[i],
                                        GFP_KERNEL);
-                       if (!pieces->dbg_conf_tlv[i])
+                       if (!drv->fw.dbg.conf_tlv[i])
                                goto out_free_fw;
                }
        }

"fw.dbg.conf" with a dot not underscore.

- Sedat -



> Patch set to Changes Requested.
>
> --
> https://patchwork.kernel.org/patch/11470125/
>
> https://wireless.wiki.kernel.org/en/developers/documentation/submittingpatches
