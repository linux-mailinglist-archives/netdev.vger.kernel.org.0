Return-Path: <netdev+bounces-1175-lists+netdev=lfdr.de@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from sv.mirrors.kernel.org (sv.mirrors.kernel.org [IPv6:2604:1380:45e3:2400::1])
	by mail.lfdr.de (Postfix) with ESMTPS id 9C2526FC80A
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 15:36:55 +0200 (CEST)
Received: from smtp.subspace.kernel.org (wormhole.subspace.kernel.org [52.25.139.140])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by sv.mirrors.kernel.org (Postfix) with ESMTPS id 6D10028128E
	for <lists+netdev@lfdr.de>; Tue,  9 May 2023 13:36:54 +0000 (UTC)
Received: from localhost.localdomain (localhost.localdomain [127.0.0.1])
	by smtp.subspace.kernel.org (Postfix) with ESMTP id 05E26182D1;
	Tue,  9 May 2023 13:36:44 +0000 (UTC)
X-Original-To: netdev@vger.kernel.org
Received: from lindbergh.monkeyblade.net (lindbergh.monkeyblade.net [23.128.96.19])
	(using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
	(No client certificate requested)
	by smtp.subspace.kernel.org (Postfix) with ESMTPS id EB67E182CF
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 13:36:43 +0000 (UTC)
Received: from mail-qt1-x829.google.com (mail-qt1-x829.google.com [IPv6:2607:f8b0:4864:20::829])
	by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7F1FD3A97
	for <netdev@vger.kernel.org>; Tue,  9 May 2023 06:36:30 -0700 (PDT)
Received: by mail-qt1-x829.google.com with SMTP id d75a77b69052e-3f38824a025so185381cf.0
        for <netdev@vger.kernel.org>; Tue, 09 May 2023 06:36:30 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=google.com; s=20221208; t=1683639389; x=1686231389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:from:to:cc:subject:date
         :message-id:reply-to;
        bh=XJBnFQ6Tfrxr+YA1sFSIlL1wjP2AsS1jhQgV6FTePM4=;
        b=OQvPIXpalFZGXYope6sTcVrfD6BP33s+w4P8IkxPFAU2eJgx1/IASY1aOAepqKzXDF
         n6a/1c6MYhHgTFSCNc01Uu4Riabu+Fw4MjkdqCHLsNQsru7v9PYYlhosEPcBnt9JmIJ7
         AS9Pvsfo8m/qSdY67UOaavKBGseKlfLmqdUtoqni9WXLZ+3wPMxFexLVb9VcRfhU8G33
         /ZMEI5ITGhA48k6RwPM5apNZwz3qpHjkkGsexKc0VdB9qu2zyoy3bNg3x9iJLYCTNShC
         3OFcS4YZICag0gTtOPER/8ZlWKPqYeoC4cbGkZ5NiVUb0GMO97UCkpVO/W1K5rBSt21Y
         4kfA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20221208; t=1683639389; x=1686231389;
        h=content-transfer-encoding:cc:to:subject:message-id:date:from
         :in-reply-to:references:mime-version:x-gm-message-state:from:to:cc
         :subject:date:message-id:reply-to;
        bh=XJBnFQ6Tfrxr+YA1sFSIlL1wjP2AsS1jhQgV6FTePM4=;
        b=RLT27HFHCeH10TrZ0u5kssCupgbW78cdFyAJqSxHyHPVFXrEgfh6ojr5PfN8vMxfLr
         dB1pFB+Ly0tuxo8r7eSUi4NX9MIhDoGaDHD2LZWVeDnrV8gioS8nQmWKZxPwmWY03Uwj
         QdC8OfxB3bA5aXUYEPKNgIi9CBkvZPgjMW9E4vPjDBu3LstdHuWwFd+23WR+1IqnajQY
         bx+3RI/qKdHgwgK7MFAbKTQcJQiiCXUK09atwCeMe38ohOegu6iL3swISBXYrxyxgPb7
         Z8zSdkM5WSnGaHuEj5gb5POGfKn5SYgauTCRvZd/F57oDE4/5xOp8SiYZbsMXoBcJ5QO
         67uw==
X-Gm-Message-State: AC+VfDxgnJqXF8Geb//QF/itnz898O+3+84MUGijfkw/NLMP3UP2lWJR
	cFql3zV/eGo0jPPAZZFnV21AzGQCZKYyUSkj4XkqAg==
X-Google-Smtp-Source: ACHHUZ6iaYUwMFVchoCFiPl/6MxyNAUM5cBjzMacGdJ9tHM06tVAKNQ9c6Uu/CePem86FstWr8NXVPBOuBEI7ZxAyW4=
X-Received: by 2002:a05:622a:1056:b0:3ed:6bde:9681 with SMTP id
 f22-20020a05622a105600b003ed6bde9681mr460239qte.0.1683639389332; Tue, 09 May
 2023 06:36:29 -0700 (PDT)
Precedence: bulk
X-Mailing-List: netdev@vger.kernel.org
List-Id: <netdev.vger.kernel.org>
List-Subscribe: <mailto:netdev+subscribe@vger.kernel.org>
List-Unsubscribe: <mailto:netdev+unsubscribe@vger.kernel.org>
MIME-Version: 1.0
References: <20230508020801.10702-1-cathy.zhang@intel.com> <20230508020801.10702-3-cathy.zhang@intel.com>
In-Reply-To: <20230508020801.10702-3-cathy.zhang@intel.com>
From: Eric Dumazet <edumazet@google.com>
Date: Tue, 9 May 2023 15:36:15 +0200
Message-ID: <CANn89i+c_N=-FPfRa5e=qZXbQFHSW1fhdZoqgBGq6VdAzdAJZA@mail.gmail.com>
Subject: Re: [PATCH net-next 2/2] net: Add sysctl_reclaim_threshold
To: Cathy Zhang <cathy.zhang@intel.com>
Cc: davem@davemloft.net, kuba@kernel.org, pabeni@redhat.com, 
	jesse.brandeburg@intel.com, suresh.srinivas@intel.com, tim.c.chen@intel.com, 
	lizhen.you@intel.com, eric.dumazet@gmail.com, netdev@vger.kernel.org
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-17.6 required=5.0 tests=BAYES_00,DKIMWL_WL_MED,
	DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,
	ENV_AND_HDR_SPF_MATCH,RCVD_IN_DNSWL_NONE,SPF_HELO_NONE,SPF_PASS,
	T_SCC_BODY_TEXT_LINE,USER_IN_DEF_DKIM_WL,USER_IN_DEF_SPF_WL
	autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
	lindbergh.monkeyblade.net

On Mon, May 8, 2023 at 4:08=E2=80=AFAM Cathy Zhang <cathy.zhang@intel.com> =
wrote:
>
> Add a new ABI /proc/sys/net/core/reclaim_threshold which allows to
> change the size of reserved memory from reclaiming in sk_mem_uncharge.
> It allows to keep sk->sk_forward_alloc as small as possible when
> system is under memory pressure, it also allows to change it larger to
> avoid memcg charge overhead and improve performance when system is not
> under memory pressure. The original reclaim threshold for reserved
> memory per-socket is 2MB, it's selected as the max value, while the
> default value is 64KB which is closer to the maximum size of sk_buff.
>
> Issue the following command as root to change the default value:
>
>         echo 16384 > /proc/sys/net/core/reclaim_threshold

So, when the system is under pressure, who is going to reduce this sysctl ?

I am sorry, but if you really need good performance numbers for benchmarks,
maybe add a static key to completely disable memory accounting for UDP
and TCP...

