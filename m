Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7AAF03A4BDD
	for <lists+netdev@lfdr.de>; Sat, 12 Jun 2021 03:11:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230303AbhFLBND (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 11 Jun 2021 21:13:03 -0400
Received: from mail-ot1-f41.google.com ([209.85.210.41]:41757 "EHLO
        mail-ot1-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229622AbhFLBNC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 11 Jun 2021 21:13:02 -0400
Received: by mail-ot1-f41.google.com with SMTP id 36-20020a9d0ba70000b02902e0a0a8fe36so4913850oth.8;
        Fri, 11 Jun 2021 18:10:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=y76DfAWIbsHJBvFr8Z1m05HJjpmzk4f7Uj4bhjOHUsU=;
        b=g/8ih2OtStbvpmjy73zGroYeTLMJnWANKGrlckR/N6m5RGqG8//vrJCPtqpr71JIem
         7UDZBRolUgGP9K+AlYA/lHbpUHFTU7EP3aD4rbrlAS60iCcGRkDYTOAku1+sLAGVgCUo
         ETohHAFXCJ4xN+Co+58+o9/ZA2gOp6uQcXWPwDOtFATf7F1tgz7B3PIZ/iyW84FaCuj8
         cBJLFxlakHVyKpUogjn7lUQY0SU+WUY59fz25+RexEogxfSMiTPNpeQ2ZIDNpmTeSeMa
         3WcMZUuUBQZK4cJEf42gAvlGe3uCxLsjecYgpCNeaq6YSlZ2LZ28PBWFguGnxncyFVMf
         WInQ==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=y76DfAWIbsHJBvFr8Z1m05HJjpmzk4f7Uj4bhjOHUsU=;
        b=X37XMYu8/VVkmaLTkWzJS/d0+NIIBMAnG5wQgR6MBAV4w0loN4/M7HTn69xwVtEFID
         QcCkjloU1IiumBUDXvb/ek/NSEvbtGHqt+ucffkWnOtoai+c2yluoM8QYiU7Hpv9dekT
         zApPNJsDynedXBwKccWEN9TFPzK6xjas0yteV2xP4RhGc8pjNb2t/A0nb0T4FxRWUzc6
         GeuN54plBLfP8JKMaVHPWatJwJzD9Zp1FnlSlzTIwjirDdahRFAHBkRZUZjI0y1cVLSA
         XBSADrfqQ5wjRYzjYyFJHZ0Kh5E+vQY7MhXEypHObjBEy6capmw/QMZ/jWmvXxsWJ8K/
         2wag==
X-Gm-Message-State: AOAM533J48flzYNTks7gQ3GBtX1mMkJFpr3H8YFnbQ72gTu3hmhUs7Wb
        E71GVDsroDFgBGqb2Z3dIgaLbfT5wBNgTgl2IGepj/ujfQk=
X-Google-Smtp-Source: ABdhPJyCQFTmdgqlwqwGwopQTA2Uwlk/n+nVhAufF977TSrdqoE+WVUwhpU56qyj8OK34c3t+sYo3sPwxL+7WKjDJpc=
X-Received: by 2002:a9d:3e5:: with SMTP id f92mr5169344otf.181.1623460187315;
 Fri, 11 Jun 2021 18:09:47 -0700 (PDT)
MIME-Version: 1.0
References: <20210608170449.28031-1-m.chetan.kumar@intel.com> <20210608170449.28031-7-m.chetan.kumar@intel.com>
In-Reply-To: <20210608170449.28031-7-m.chetan.kumar@intel.com>
From:   Sergey Ryazanov <ryazanov.s.a@gmail.com>
Date:   Sat, 12 Jun 2021 04:09:37 +0300
Message-ID: <CAHNKnsR-CnCr6qmMwyWwiF6DNtkGBqfpA5nUrBqVxWk0Ezb70Q@mail.gmail.com>
Subject: Re: [PATCH V4 06/16] net: iosm: channel configuration
To:     M Chetan Kumar <m.chetan.kumar@intel.com>
Cc:     netdev@vger.kernel.org, linux-wireless@vger.kernel.org,
        Johannes Berg <johannes@sipsolutions.net>,
        krishna.c.sudi@intel.com, linuxwwan@intel.com
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hello Chetan,

On Tue, Jun 8, 2021 at 8:07 PM M Chetan Kumar <m.chetan.kumar@intel.com> wrote:

[skipped]

> +/* Modem channel configuration table
> + * Always reserve element zero for flash channel.
> + */
> +static struct ipc_chnl_cfg modem_cfg[] = {
> +       /* IP Mux */
> +       { IPC_MEM_IP_CHL_ID_0, IPC_MEM_PIPE_0, IPC_MEM_PIPE_1,
> +         IPC_MEM_MAX_TDS_MUX_LITE_UL, IPC_MEM_MAX_TDS_MUX_LITE_DL,
> +         IPC_MEM_MAX_DL_MUX_LITE_BUF_SIZE, WWAN_PORT_MAX },

Since commit b64d76b78226 ("net: wwan: make WWAN_PORT_MAX meaning less
surprised") WWAN_PORT_MAX really means a maximum valid port type id.
At the moment the max value is WWAN_PORT_FIREHOSE. If I understand the
driver code correctly, you ignore WWAN_PORT_MAX ports in the
ipc_imem_run_state_worker() function. So using WWAN_PORT_MAX in this
way should not actually break anything.

Just as a FYI, Loic introduced a special value WWAN_PORT_UNKNOWN that
could be used to indicate a port that should not be registered with
the WWAN core. Looks like WWAN_PORT_UNKNOWN would be a safer
alternative here.

-- 
Sergey
