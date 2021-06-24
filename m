Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EC3D23B3152
	for <lists+netdev@lfdr.de>; Thu, 24 Jun 2021 16:28:42 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231225AbhFXObA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 24 Jun 2021 10:31:00 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44204 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230008AbhFXOa7 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 24 Jun 2021 10:30:59 -0400
Received: from mail-io1-xd2e.google.com (mail-io1-xd2e.google.com [IPv6:2607:f8b0:4864:20::d2e])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 9C84DC061574;
        Thu, 24 Jun 2021 07:28:39 -0700 (PDT)
Received: by mail-io1-xd2e.google.com with SMTP id o5so8440448iob.4;
        Thu, 24 Jun 2021 07:28:39 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=58c/kEfPGM7eo+DwySZzk3eJ3sXDxuIrRbqL+hypr44=;
        b=dBDmnvYDh1q99UfATEv3TZ1H+fgzJtNInkfw4GpJRRNgEEE3XUQ+9U5XFIb1qpXVdg
         smMHWBiU1sZcmru2eAIfqW7RDAAYF1spjXwVqfoAYntVmHTwYiXse8KExGDQFGZLLQiy
         I2S/f7zxw5eri1UyCyVdy88zCp2WZCuaQ4myf+8SiZGf2wED2WbHlUV2SOszWSjMv7Er
         6Sh4BWsw7rSWo3iOUv2HyFIS6HA4W4lgq5x6QXFilAB5ikOa2wwCan2qoeYJwyeUhfCr
         wop4q10y+4BAVpddW8mlwbH8MMWKJlQ5ohvPZ+85wH5n+s1ZHUXifGETnH1f4DkYZAiN
         JDOg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=58c/kEfPGM7eo+DwySZzk3eJ3sXDxuIrRbqL+hypr44=;
        b=iiUG+JZdlgxEMhwiiscoq4M00xrsMdJvxqgmLB3y849ZY8ZxWqsImNd5rs8p2Rdbsr
         o6Cceonc+v4yPluNAWJL/Z4UJDDFeLHGolcQamjLk/MhAlXA14irwbTwiYmHX0OQRnNy
         qB7fkqwFa5EbSvPlLKGsz5/mPMDTMgFoh57cqGH6+QyRpWXiBfeqZzC8DqOcuynUrMpC
         iWSLaVl3/ElYwIwntnj5vWDXKs02cvktGGcZca3dP1OqRBEFIasElhOSdUiBjhec2+Ul
         drqAWaiS8hMjqjXjfNvc9x0RzXeP7ETV1wsN2B9kRH+nURs0m7nOWViOd7gK2PFYBM8q
         n99g==
X-Gm-Message-State: AOAM533xZyZ5nsGcgWeTBDkI/7o5EuBTIO/WdfXzJOlznCyVeovN2dlC
        rggfcX04qwly3aLl2QaCzjI=
X-Google-Smtp-Source: ABdhPJxjMLXitfryZDvN2eiy/3UeT/GGiDoL2ZkXPII0bjV70dgbIEfeYsytc7jZz0kPLwqvRkHPow==
X-Received: by 2002:a02:c808:: with SMTP id p8mr4946126jao.109.1624544919142;
        Thu, 24 Jun 2021 07:28:39 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id r20sm1834269ilj.56.2021.06.24.07.28.37
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 24 Jun 2021 07:28:38 -0700 (PDT)
Date:   Thu, 24 Jun 2021 07:28:32 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Eelco Chaudron <echaudro@redhat.com>,
        John Fastabend <john.fastabend@gmail.com>
Cc:     Lorenzo Bianconi <lorenzo@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org, lorenzo.bianconi@redhat.com,
        davem@davemloft.net, kuba@kernel.org, ast@kernel.org,
        daniel@iogearbox.net, shayagr@amazon.com, sameehj@amazon.com,
        dsahern@kernel.org, brouer@redhat.com, jasowang@redhat.com,
        alexander.duyck@gmail.com, saeed@kernel.org,
        maciej.fijalkowski@intel.com, magnus.karlsson@intel.com,
        tirthendu.sarkar@intel.com
Message-ID: <60d49690a87ae_2e84a2082c@john-XPS-13-9370.notmuch>
In-Reply-To: <34E2BF41-03E0-4DEC-ABF3-72C8FF7B4E4A@redhat.com>
References: <cover.1623674025.git.lorenzo@kernel.org>
 <4d2a74f7389eb51e2b43c63df76d9cd76f57384c.1623674025.git.lorenzo@kernel.org>
 <60d27716b5a5a_1342e208d5@john-XPS-13-9370.notmuch>
 <34E2BF41-03E0-4DEC-ABF3-72C8FF7B4E4A@redhat.com>
Subject: Re: [PATCH v9 bpf-next 10/14] bpf: add multi-buffer support to xdp
 copy helpers
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Eelco Chaudron wrote:
> 
> 
> On 23 Jun 2021, at 1:49, John Fastabend wrote:
> 
> > Lorenzo Bianconi wrote:
> >> From: Eelco Chaudron <echaudro@redhat.com>
> >>
> >> This patch adds support for multi-buffer for the following helpers:
> >>   - bpf_xdp_output()
> >>   - bpf_perf_event_output()
> >>
> >> Signed-off-by: Eelco Chaudron <echaudro@redhat.com>
> >> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> >> ---
> >
> > Ah ok so at least xdp_output will work with all bytes. But this is
> > getting close to having access into the frags so I think doing
> > the last bit shouldn't be too hard?
> 
> 
> Guess you are talking about multi-buffer access in the XDP program?
> 
> I did suggest an API a while back, https://lore.kernel.org/bpf/FD3E6E08-DE78-4FBA-96F6-646C93E88631@redhat.com/ but I had/have not time to work on it. Guess the difficult part is to convince the verifier to allow the data to be accessed.

Ah great I think we had the same idea I called it xdp_pull_data()
though.

Whats the complication though it looks like it can be done by simply
moving the data and data_end pointers around then marking them
invalidated. This way the verifier knows the program needs to
rewrite them. I can probably look more into next week.

From my first glance it looks relatively straight forward to do
now. I really would like to avoid yet another iteration of
programs features I have to discover and somehow work around
if we can get the helper into this series. If you really don't
have time I can probably take a look early next week on an
RFC for something like above helper.


.John
