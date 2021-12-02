Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 9546C466B03
	for <lists+netdev@lfdr.de>; Thu,  2 Dec 2021 21:42:28 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1348940AbhLBUps (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 Dec 2021 15:45:48 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:37058 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1348860AbhLBUpr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 Dec 2021 15:45:47 -0500
Received: from mail-lf1-x134.google.com (mail-lf1-x134.google.com [IPv6:2a00:1450:4864:20::134])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E5149C06174A;
        Thu,  2 Dec 2021 12:42:24 -0800 (PST)
Received: by mail-lf1-x134.google.com with SMTP id m27so1287194lfj.12;
        Thu, 02 Dec 2021 12:42:24 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=cUvh13HZpUaevuhgeDEuFEt7T89gIOAoM6nVfIn7h50=;
        b=o374HYk6NupnItrAgwSkX8YMTUIFe9dLEs/aaSk6+tI2adulmXkZ/fecVuN+zhFONA
         7XIYjzAkuy0aiLhuGSsuA3Mqqm4RE9n7WLAocjzZ02phib1uh0DNr0vj6NJ7AqwUMln9
         lp80XERUo/5kIv6IZFOYkUODwuuSRLAFWIFPsflDXCsCzdcPLVhvtz+h4DVLwDygwMZ2
         8LOoxqYXyGRX7WG078jF/054WK+zSlQkhVV84GSpVGxya+BDpD2VljWuDBPi8cbLfGof
         Lr5+XM0qGLqk0Ft3HKMIdzDsuURtN0kJrxFFfsHUVqXQ4gfZFUiuD3vWzSuuY/ttmaDY
         C/Kg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=cUvh13HZpUaevuhgeDEuFEt7T89gIOAoM6nVfIn7h50=;
        b=mydOx5/qSN5cKz4TJxK6OD0H5RcHc9PvefyTkG0QG+6Ey9s1epxMrl9xJEtvlG2yWR
         Fnvq+TXbkjkmmena73utUJun0Z3Bb283pqvL/bOkSb662n76HQSjBlB3FiJvwNbjLsC5
         K3jQ7NJHEX7Ee2E7OEy6pMb9I6BeiBtrwqUEGDpyn0tshyP63q1dIF2r18BqD8lLBEPY
         JMzlkywdqh1B+Bj4pP2C2/iI811fNsigO8YzEikNne425Qucqigur+xlm0v3P+cRZ+eE
         ToSli6hxky3oHNkI1r0tJ0e1zH7IfTqJru4R3dQABsCxCiBLoitmmzeUhY27ZBRpJIWo
         xUSA==
X-Gm-Message-State: AOAM531GiOgTStUPAZKQo7ev+LV0uPsFa9zAXL9zFa1Hk7PFeGHYS/rw
        MqbHz0TEYKLd9IWzrPnVIuJI0btqCVpi8UJkcgc=
X-Google-Smtp-Source: ABdhPJx+fIKR3UDjkHZtlY+SJb4iK1fgxaYOznzZWoWwYQ52a6Ojgx/JNGyIDvTfStrnoSbzeEOufvz110wwWf8ODek=
X-Received: by 2002:ac2:4e98:: with SMTP id o24mr5224974lfr.639.1638477742845;
 Thu, 02 Dec 2021 12:42:22 -0800 (PST)
MIME-Version: 1.0
References: <PH0PR11MB479271060FA116D87B95E12DC5669@PH0PR11MB4792.namprd11.prod.outlook.com>
 <PH0PR11MB4792C2AC6C5185FBC95B9C21C5689@PH0PR11MB4792.namprd11.prod.outlook.com>
In-Reply-To: <PH0PR11MB4792C2AC6C5185FBC95B9C21C5689@PH0PR11MB4792.namprd11.prod.outlook.com>
From:   "sunyucong@gmail.com" <sunyucong@gmail.com>
Date:   Thu, 2 Dec 2021 12:41:56 -0800
Message-ID: <CAJygYd3mfjT0362D6XAqn5+aMn_YUs49YSEBapZqYxvVNs0RCg@mail.gmail.com>
Subject: Re: kernel-selftests: make run_tests -C bpf cost 5 hours
To:     "Zhou, Jie2X" <jie2x.zhou@intel.com>
Cc:     "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Li, ZhijianX" <zhijianx.li@intel.com>,
        "Ma, XinjianX" <xinjianx.ma@intel.com>, lkp <lkp@intel.com>,
        "Li, Philip" <philip.li@intel.com>
Content-Type: text/plain; charset="UTF-8"
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Zhou,

Not sure what exactly you were asking, can you clarify what the question is?

By the way, the recommend way to run bpf selftests are through :
`./tools/testing/selftests/bpf/vmtest.sh`. ,it will take care of
building image,  selftets and also run those in a qemu vm.

This test should finish within a minute or so,  (excluding building time)

Cheers.
