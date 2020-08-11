Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 78CAC241536
	for <lists+netdev@lfdr.de>; Tue, 11 Aug 2020 05:27:41 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727922AbgHKD1L (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 10 Aug 2020 23:27:11 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33518 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727819AbgHKD1L (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 10 Aug 2020 23:27:11 -0400
Received: from mail-ej1-x641.google.com (mail-ej1-x641.google.com [IPv6:2a00:1450:4864:20::641])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B08E2C06174A;
        Mon, 10 Aug 2020 20:27:10 -0700 (PDT)
Received: by mail-ej1-x641.google.com with SMTP id l4so11489053ejd.13;
        Mon, 10 Aug 2020 20:27:10 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=N/gPAAuOqsPLV/DUOUsFW5pLvTbx148L2CF6kEAlD8U=;
        b=tQtzc/8yN61IyzYkeZzqokW7u9M0izGgXNJA70EiEK2AmYXCQFWNcvGlC4RZWVyDcz
         weOgdJ520/1tVL43aYbr7hwTaA5nsZ9VK7SFasmT4RRvG61SsCd0WXW8gBqqWslD4cHb
         ZPqZyGF7afdCgEkpdVBxqeqyziz3Peb1wjELsGkN1jCYOZ47iOSPk6pXXi75kkVh0rtr
         ekFmz6QZ051aYOT3u3BxS1zIiqKFaTZkKCoxrrkL4n89CbcrGSnAP6RoPeG30iYVvn/3
         64XwU5cToIPTLYMP6pPPqSjaego1v5DTOjNOaayHhShKAxuBCI1PNQeHAchWKZPeU8ph
         YShw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=N/gPAAuOqsPLV/DUOUsFW5pLvTbx148L2CF6kEAlD8U=;
        b=QwZVoxHb0mk0L1l+uRMW7cvBcyi+cAY2GyJKe6G03FXdFXnUbXwQ18Q/qzapXZ1ADQ
         sWK584yuxrKlZ5VodZGiSgrNkVwUtQSkN0Mm2LES5RGQK4u6I5H56xSNUuOt67OlrKSx
         aw+hCC8crzZL9GnJZS21BhOyd230UjCxMAdxYg3Krehlw9xEBpYI/yBzjbM9gwac4nnF
         zf3o5/pL7dHeMHE0O5DjmzCaPn+dlGwQjUH0q5hCRGG6DgiA+NZhf7TEjoHaoEJcz16T
         IaHB1xtSvFDHaFXUT36L5USWspMhlNbfN2jCQdOjifXMdPW4DFqmO6CjuponfNew++bc
         cogA==
X-Gm-Message-State: AOAM530cKGYhMb26yHsHENlUzVeCtvSif9/Fg9vgzPdQJ5JpcMSB0mlc
        iAfpF/z+SUpaodFHt8G/FKUMtgRByJjsEPLqNKY=
X-Google-Smtp-Source: ABdhPJxt571NfWcqIH9qei10JVl3lMHX0VtsOaZ/jw0TX5cCLVWtEjZrey3Xb4rEBO7HhCt0lIzrkVkwtfnVqsUzbQ4=
X-Received: by 2002:a17:906:c7d2:: with SMTP id dc18mr25442673ejb.135.1597116429338;
 Mon, 10 Aug 2020 20:27:09 -0700 (PDT)
MIME-Version: 1.0
References: <CA+Sh73MJhqs7PBk6OV2AhzVjYvE1foUQUnwP5DwWR44LHZRZ9w@mail.gmail.com>
 <58be64c5-9ae4-95ff-629e-f55e47ff020b@gmail.com> <CA+Sh73NeNr+UNZYDfD1nHUXCY-P8mT1vJdm0cEY4MPwo_0PtzQ@mail.gmail.com>
 <CAEXW_YSSL5+_DjtrYpFp35kGrem782nBF6HuVbgWJ_H3=jeX4A@mail.gmail.com>
 <20200807222015.GZ4295@paulmck-ThinkPad-P72> <20200810200859.GF2865655@google.com>
 <20200810202813.GP4295@paulmck-ThinkPad-P72> <CAMDZJNWrPf8AkZE8496g6v5GXvLUbQboXeAhHy=1U1Qhemo8bA@mail.gmail.com>
 <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com>
In-Reply-To: <CAM_iQpXBHSYdqb8Q3ifG8uwa1YfJmGBexHC2BusRoshU0M5X5g@mail.gmail.com>
From:   Tonghao Zhang <xiangxia.m.yue@gmail.com>
Date:   Tue, 11 Aug 2020 11:26:24 +0800
Message-ID: <CAMDZJNU5Cpkcrn5sy=7u_vTGcdMjDfCqzSCJ0WLk-3M5RROh=Q@mail.gmail.com>
Subject: Re: [ovs-discuss] Double free in recent kernels after memleak fix
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     "Paul E . McKenney" <paulmck@kernel.org>,
        Joel Fernandes <joel@joelfernandes.org>,
        =?UTF-8?B?Sm9oYW4gS27DtsO2cw==?= <jknoos@google.com>,
        Gregory Rose <gvrose8192@gmail.com>,
        bugs <bugs@openvswitch.org>, Netdev <netdev@vger.kernel.org>,
        "Uladzislau Rezki (Sony)" <urezki@gmail.com>,
        rcu <rcu@vger.kernel.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 11, 2020 at 10:24 AM Cong Wang <xiyou.wangcong@gmail.com> wrote:
>
> On Mon, Aug 10, 2020 at 6:16 PM Tonghao Zhang <xiangxia.m.yue@gmail.com> wrote:
> > Hi all, I send a patch to fix this. The rcu warnings disappear. I
> > don't reproduce the double free issue.
> > But I guess this patch may address this issue.
> >
> > http://patchwork.ozlabs.org/project/netdev/patch/20200811011001.75690-1-xiangxia.m.yue@gmail.com/
>
> I don't see how your patch address the double-free, as we still
> free mask array twice after your patch: once in tbl_mask_array_realloc()
> and once in ovs_flow_tbl_destroy().
Hi Cong.
Before my patch, we use the ovsl_dereference
(rcu_dereference_protected) in the rcu callback.
ovs_flow_tbl_destroy
->table_instance_destroy
->table_instance_flow_free
->flow_mask_remove
ASSERT_OVSL(will print warning)
->tbl_mask_array_del_mask
ovsl_dereference(rcu usage warning)

so we should invoke the table_instance_destroy or others under
ovs_lock to avoid (ASSERT_OVSL and rcu usage warning).
with this patch, we reallocate the mask_array under ovs_lock, and free
it in the rcu callback. Without it, we  reallocate and free it in the
rcu callback.
I think we may fix it with this patch.

> Have you tried my patch which is supposed to address this double-free?
I don't reproduce it. but your patch does not avoid ruc usage warning
and ASSERT_OVSL.
> It simply skips the reallocation as it makes no sense to trigger reallocation
> when destroying it.
>
> Thanks.



-- 
Best regards, Tonghao
