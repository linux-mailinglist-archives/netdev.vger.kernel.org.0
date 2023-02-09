Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id D0A5F68FD0C
	for <lists+netdev@lfdr.de>; Thu,  9 Feb 2023 03:23:03 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231840AbjBICXC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Feb 2023 21:23:02 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:53172 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230368AbjBICXA (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Feb 2023 21:23:00 -0500
Received: from mail-ej1-x630.google.com (mail-ej1-x630.google.com [IPv6:2a00:1450:4864:20::630])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 51D2023C7A;
        Wed,  8 Feb 2023 18:22:59 -0800 (PST)
Received: by mail-ej1-x630.google.com with SMTP id qw12so2436873ejc.2;
        Wed, 08 Feb 2023 18:22:59 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=leuP8yKTp3aOhzWpWEwkgHZjeuEA988zNE5XLgEB/so=;
        b=STC9BSG74WRy2CJ0lOKy/cq0WnQPt0M1fWU6T3DIy4zcmrsWzaUSpLgckFebj07crB
         vRwGZagzqcxscD757/zI1xFocxXOV+2QhjoOtlnSB3E/A1Rl0H1b14kdHnOprxCjqSOu
         qDm2sx2F1dHKeRxzkYcbOS4rmifY2dfeNuoixFaFffEBmMgG+ROoSa77Rw4ny4Ok4P3q
         ltsfAmFjErMFYgqEtHhYPZvI3yf4H41KVbL/izEO4lETjN0nwW7NQTfT/y1VF1NdVFcl
         MCgfzn/Q7ITcX9AsP8NptN6O2WO0Z4FPOD5BKz1Ap4yFwMqz5kFvq3l9rDswTUqPCdsq
         FNnw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=leuP8yKTp3aOhzWpWEwkgHZjeuEA988zNE5XLgEB/so=;
        b=VKHxucbRqtZH43PEp6zJoLMSuArAUkXXpmTRMhhUjI7EyZnUxbq3xgOV4iBVh/YMxn
         GQ0xw7zBBfmK2dFOyYs+gnFyiAgjica/BoB3YooKhbvZoUjP1Vf7uTMopBvN7sej2Lmw
         C/ofEz1F+IDknCe4uUj7pMBw5suOoJOhma6hbyy02RkkrUKe7njsU1flY9l6hxF2THvG
         7H/rckIuIHjyQByGk11s3VulYykq/NP363TSLCutC+fcP7guIVyGozNIsiAGLa4pO5ih
         CRXz7IoL3DP4Z72eGVcDwKRhnX+hVSVJAcUlTtHl/AZr0mGU5XThTtiWUyxAyKuf4jLY
         AQoQ==
X-Gm-Message-State: AO0yUKVIg71uZSNPjWlxoheAWoiGqIGcVViob/8x0dF25EBCvSXo7Aj1
        sXOEECSjuDEHulABIMqlnTGvC61FFI0xVW7CNRg=
X-Google-Smtp-Source: AK7set/4KZ2LcrSiwi/BxXZmB2rIF+nIQeFkZYqrqhk6Msqj4/lIOf9JfPU+15yabUHY0Mp2clYxFyOL0ldkEU+Ccs8=
X-Received: by 2002:a17:906:2ed1:b0:882:177f:34bb with SMTP id
 s17-20020a1709062ed100b00882177f34bbmr2067833eji.16.1675909377887; Wed, 08
 Feb 2023 18:22:57 -0800 (PST)
MIME-Version: 1.0
References: <20230204133535.99921-1-kerneljasonxing@gmail.com>
 <20230204133535.99921-4-kerneljasonxing@gmail.com> <CAL+tcoD9nE-Ad7+XoshoQ8qp7C0H+McKX=F6xt2+UF1BeWXKbg@mail.gmail.com>
 <CAKgT0Uc7d5iomJnrvPdngt6u9ns7S1ismhH_C2R1YWarg04wWg@mail.gmail.com>
In-Reply-To: <CAKgT0Uc7d5iomJnrvPdngt6u9ns7S1ismhH_C2R1YWarg04wWg@mail.gmail.com>
From:   Jason Xing <kerneljasonxing@gmail.com>
Date:   Thu, 9 Feb 2023 10:22:19 +0800
Message-ID: <CAL+tcoBEv6tiAES-JPF4er_bkQWuqZ1m0ouVc19EARCOcaDidQ@mail.gmail.com>
Subject: Re: [PATCH net 3/3] ixgbe: add double of VLAN header when computing
 the max MTU
To:     Alexander Duyck <alexander.duyck@gmail.com>
Cc:     jesse.brandeburg@intel.com, anthony.l.nguyen@intel.com,
        davem@davemloft.net, edumazet@google.com, kuba@kernel.org,
        pabeni@redhat.com, richardcochran@gmail.com, ast@kernel.org,
        daniel@iogearbox.net, hawk@kernel.org, john.fastabend@gmail.com,
        alexandr.lobakin@intel.com, maciej.fijalkowski@intel.com,
        intel-wired-lan@lists.osuosl.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, bpf@vger.kernel.org,
        Jason Xing <kernelxing@tencent.com>
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-2.1 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FREEMAIL_FROM,
        RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Feb 9, 2023 at 9:08 AM Alexander Duyck
<alexander.duyck@gmail.com> wrote:
>
> On Wed, Feb 8, 2023 at 4:47 PM Jason Xing <kerneljasonxing@gmail.com> wrote:
> >
> > CC Alexander Duyck
> >
> > Hello Alexander, thanks for reviewing the other two patches of this
> > patchset last night. Would you mind reviewing the last one? :)
> >
> > Thanks,
> > Jason
>
> It looks like this patch isn't in the patch queue at:
> https://patchwork.kernel.org/project/netdevbpf/list/
>

I got it.

I have no clue on how patchwork works, I searched the current email,
see https://patchwork.kernel.org/project/netdevbpf/patch/20230204133535.99921-4-kerneljasonxing@gmail.com/.

> I believe you will need to resubmit it to get it accepted upstream.
>
> The patch itself looks fine. Feel free to add my reviewed by when you submit it.
>
> Reviewed-by: Alexander Duyck <alexanderduyck@fb.com>

Anyway, I'm going to send a v2 version with your reviewed-by label.

Thank you, Alexander :)

Jason
