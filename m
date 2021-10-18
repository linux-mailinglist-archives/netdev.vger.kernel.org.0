Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D75F8431F4D
	for <lists+netdev@lfdr.de>; Mon, 18 Oct 2021 16:17:16 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232369AbhJROT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 18 Oct 2021 10:19:26 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:44746 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232842AbhJROTX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 18 Oct 2021 10:19:23 -0400
Received: from mail-io1-xd2c.google.com (mail-io1-xd2c.google.com [IPv6:2607:f8b0:4864:20::d2c])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id DEA25C094268;
        Mon, 18 Oct 2021 07:05:47 -0700 (PDT)
Received: by mail-io1-xd2c.google.com with SMTP id i189so16438977ioa.1;
        Mon, 18 Oct 2021 07:05:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20210112;
        h=date:from:to:cc:message-id:in-reply-to:references:subject
         :mime-version:content-transfer-encoding;
        bh=Zg7ZOhohtZhCCy7y9pyI3V1BTITKPMF9LsGk4rxu3ME=;
        b=nWNyDok3ZmGoXBOCY7rCOH0ppd4gXK2vUtMNQkkv7frHeMXcrlianwSQCXCO8XHfcz
         3y8V7pEP1XpLmpJnkagiE5hUH0ZoZ6RxtvaZV6UUNXD9zHSR1ikashslErZRryq+/RoB
         x51k0yCMuqY5womdTVfwGUtijvkUI3gL4qE5q3LQV5gYGMOrvIuRLGGsyFdPcyx8e2Mt
         fzCx8+qg0UOaky5bIJACV5hKzdWWrDvFWaDn2p+Nqwz52iLhJwIeu+PuIDQP40iAStDn
         z2wbm0rzPI2Vny/ISUNKAOKof7A794b8TrwXVkYmrAVR1gI6P4d7CwXIYnuoX3oSIYwo
         6CKw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20210112;
        h=x-gm-message-state:date:from:to:cc:message-id:in-reply-to
         :references:subject:mime-version:content-transfer-encoding;
        bh=Zg7ZOhohtZhCCy7y9pyI3V1BTITKPMF9LsGk4rxu3ME=;
        b=5TYZK11lqjkpncD4VBREDErviYpNtz38JHdCGiCDtI9NoV0yq8imNw9M879a8pduXf
         UJlgPfFBfqcoZgaMZa3XQCSvxHl4K5xAwBtttO0BnkXRnYho3DhN/C1rcRz0OhK6ee67
         /qfnb4tfxEKoCJb339VZ5+uzS+ORT098jfKBLCNL0jaOggqdlOwYCGbndwmQFFgD0VgY
         89RBP3k44eq+uIchWjtXmGMChBZfun+Coc3Vbc0+D/PFqz+vLjdd46Lg97/wINGR3gdb
         XBCKQCa8miMeq/DcoWEQISx+Juri9yHEkOrWb5W9PF6OzblljX2iSa9RS1UO+p+JQyML
         otvw==
X-Gm-Message-State: AOAM530HA2W7PdVQsiUrJpCmwSVfJwlt049DctyaIROukmW9Nwxd13ry
        27gptYGM98o4n8zXCibu9JY=
X-Google-Smtp-Source: ABdhPJzFz3LOOcUrd20WZd2igSMrraNbJfSZMRIQa54AFozFR435NJccy3bCwPdMG49RTzIOq3jViA==
X-Received: by 2002:a02:c484:: with SMTP id t4mr18449727jam.37.1634565947280;
        Mon, 18 Oct 2021 07:05:47 -0700 (PDT)
Received: from localhost ([172.243.157.240])
        by smtp.gmail.com with ESMTPSA id g9sm3610257ila.20.2021.10.18.07.05.44
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 18 Oct 2021 07:05:46 -0700 (PDT)
Date:   Mon, 18 Oct 2021 07:05:38 -0700
From:   John Fastabend <john.fastabend@gmail.com>
To:     Quentin Monnet <quentin@isovalent.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org,
        Quentin Monnet <quentin@isovalent.com>
Message-ID: <616d7f32e2125_1eb12088b@john-XPS-13-9370.notmuch>
In-Reply-To: <20211009210341.6291-1-quentin@isovalent.com>
References: <20211009210341.6291-1-quentin@isovalent.com>
Subject: RE: [PATCH bpf-next 0/3] fixes for bpftool's Makefile
Mime-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quentin Monnet wrote:
> This set contains one fix for bpftool's Makefile, to make sure that the
> headers internal to libbpf are installed properly even if we add more
> headers to the relevant Makefile variable in the future (although we'd like
> to avoid that if possible).
> 
> The other patches aim at cleaning up the output from the Makefile, in
> particular when running the command "make" another time after bpftool is
> built.
> 
> Quentin Monnet (3):
>   bpftool: fix install for libbpf's internal header(s)
>   bpftool: do not FORCE-build libbpf
>   bpftool: turn check on zlib from a phony target into a conditional
>     error
> 
>  tools/bpf/bpftool/Makefile | 29 +++++++++++++++--------------
>  1 file changed, 15 insertions(+), 14 deletions(-)
> 
> -- 
> 2.30.2
> 

I'm not a Makefile expert, but from my side these look good. Thanks.

Acked-by: John Fastabend <john.fastabend@gmail.com>
