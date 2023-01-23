Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A2F56678692
	for <lists+netdev@lfdr.de>; Mon, 23 Jan 2023 20:40:46 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232616AbjAWTkp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 Jan 2023 14:40:45 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47012 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232582AbjAWTkn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 Jan 2023 14:40:43 -0500
Received: from mail-yw1-x112c.google.com (mail-yw1-x112c.google.com [IPv6:2607:f8b0:4864:20::112c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 76AFAEFAD
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:40:41 -0800 (PST)
Received: by mail-yw1-x112c.google.com with SMTP id 00721157ae682-4ff07dae50dso142111667b3.2
        for <netdev@vger.kernel.org>; Mon, 23 Jan 2023 11:40:41 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=mojatatu-com.20210112.gappssmtp.com; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:from:to:cc:subject:date:message-id:reply-to;
        bh=34a4TCQC+hucVvU0QHhlwqtMefBbiCmDkLlzLb7LNI4=;
        b=hiz/TnB1Bso3VTInqNpPxmOtmBjC9PSp1MjZX0GdtS7bXbYKQ9cjdZudp/bhWqGx9C
         ZrStzcrHsctSD+uxI1Ss2mKlnTyZZMU4Bwxgzs1A9Am3TR5wzPQkzvhPnpuPxKMIM+gM
         +ranmIPBsyywzkyVewvgl5+Zc9w/OSmE6krYDWIOgEMlW8KBtAXKLuuTsWL2RJvLzaw0
         owcw2/VyD3POARDzwbr3cZ1t/2TA9J3ujfvYjeOG5Jt/A8wT/yVrGwzeVWYR0qGIDD89
         pLd7wySIS1zb3VfFexzoR5Y2zCNeN0gm3CGG1EeXV5h/7EKEu3Ak3DWx0PTfg0hQzqlA
         wQiw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=cc:to:subject:message-id:date:from:in-reply-to:references
         :mime-version:x-gm-message-state:from:to:cc:subject:date:message-id
         :reply-to;
        bh=34a4TCQC+hucVvU0QHhlwqtMefBbiCmDkLlzLb7LNI4=;
        b=wxZsi8SeBn67ebFFFzhZ5Sm6NgSXDxJm8xLahuoYAGm7e7a4AfL4MOIo6jFxlJC6+e
         Xz8FII+VpAZyvRI2YYpgDk3enfDP2KG1k3KqaTxZCfRvxmCVtlEYYpZ3MHvAsjVByoR3
         RtqIwm+aGnxaVSwmaATsnNQLm3Zx4TnF03tvyPdZU3XW/a56z/h5n53ldImQX56PH7zC
         ErFVSAu+NdqeCm/qJd/6W8RTLhfFzay6+Imn9zPH9hjkYIFauVaMIDjj1ctn1wyEgMMq
         SnK9dfiV4SN1VfArBjSEUlDmICwWXp1wVt0PAIuDxOCB5WhrEg3UjTV8au7LlplDVoIF
         N1zw==
X-Gm-Message-State: AO0yUKVP4RN6E6fPDNpjNIiXLU/Vsy0/HgAKrD4vM/WR9XSXbVKzAwkL
        AIiDreQSkQ5Mhfjw6nEfGGpb8Km8OJ8Lcj3Y8M545A==
X-Google-Smtp-Source: AK7set+uvEqJfy2cOtLp601m32aJLDkgUaRLR8tk6fz0hEmzS29CIPXj6+lzN6Dfoqye0sR/UF7k3/ssjnzrLI9t4a8=
X-Received: by 2002:a81:ab53:0:b0:506:3a16:693d with SMTP id
 d19-20020a81ab53000000b005063a16693dmr12711ywk.360.1674502840761; Mon, 23 Jan
 2023 11:40:40 -0800 (PST)
MIME-Version: 1.0
References: <cover.1674233458.git.dcaratti@redhat.com> <a59d4d9295e40fe6cfaa0803c5a7cc6e80e7b1a2.1674233458.git.dcaratti@redhat.com>
 <Y87CWGgHk8f0EWfA@t14s.localdomain>
In-Reply-To: <Y87CWGgHk8f0EWfA@t14s.localdomain>
From:   Jamal Hadi Salim <jhs@mojatatu.com>
Date:   Mon, 23 Jan 2023 14:40:29 -0500
Message-ID: <CAM0EoM=gzQ7w_22mVaG=GN4Sy-CHWROzA_4ahezvtckkutQVJA@mail.gmail.com>
Subject: Re: [PATCH net-next 1/2] net/sched: act_mirred: better wording on
 protection against excessive stack growth
To:     Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Cc:     Davide Caratti <dcaratti@redhat.com>, jiri@resnulli.us,
        lucien.xin@gmail.com, netdev@vger.kernel.org, pabeni@redhat.com,
        wizhao@redhat.com, xiyou.wangcong@gmail.com
Content-Type: text/plain; charset="UTF-8"
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_NONE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jan 23, 2023 at 12:22 PM Marcelo Ricardo Leitner
<marcelo.leitner@gmail.com> wrote:
>
> On Fri, Jan 20, 2023 at 06:01:39PM +0100, Davide Caratti wrote:
> > with commit e2ca070f89ec ("net: sched: protect against stack overflow in
> > TC act_mirred"), act_mirred protected itself against excessive stack growth
> > using per_cpu counter of nested calls to tcf_mirred_act(), and capping it
> > to MIRRED_RECURSION_LIMIT. However, such protection does not detect
> > recursion/loops in case the packet is enqueued to the backlog (for example,
> > when the mirred target device has RPS or skb timestamping enabled). Change
> > the wording from "recursion" to "nesting" to make it more clear to readers.
> >
> > CC: Jamal Hadi Salim <jhs@mojatatu.com>
> > Signed-off-by: Davide Caratti <dcaratti@redhat.com>
>
> Reviewed-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
Acked-by: Jamal Hadi Salim <jhs@mojatatu.com>

cheers,
jamal
