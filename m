Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 509AC4E1CF9
	for <lists+netdev@lfdr.de>; Sun, 20 Mar 2022 17:58:17 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237719AbiCTQ7h (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 20 Mar 2022 12:59:37 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:39096 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S232215AbiCTQ7g (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 20 Mar 2022 12:59:36 -0400
Received: from out0.migadu.com (out0.migadu.com [IPv6:2001:41d0:2:267::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 3DC1140E4D;
        Sun, 20 Mar 2022 09:58:11 -0700 (PDT)
Content-Type: text/plain; charset=utf-8
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linux.dev; s=key1;
        t=1647795489;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=8yxvIMUdY2qwFmHKgzJa1uSWi7H1KqmGW2atkpT4NJs=;
        b=RYI9ql1aSTaB2enHciW3zESm+zC0c1hEXzC2ztwchF4oIfpluW02asoES568D3e2xYNi8L
        SasrsMyntWyhcQcI3Sv6EQZ1pGQO3eSSc7KR5F4OYdGC0snA2DtrjoOUgeLW9z9GuSWrW+
        gKzCpj10B6IK6LR9jxVM/wRH+rUiGcU=
Content-Transfer-Encoding: quoted-printable
MIME-Version: 1.0
Subject: Re: [PATCH] bpf: selftests: cleanup RLIMIT_MEMLOCK
X-Report-Abuse: Please report any abuse attempt to abuse@migadu.com and include these headers.
From:   Roman Gushchin <roman.gushchin@linux.dev>
In-Reply-To: <20220320060815.7716-2-laoar.shao@gmail.com>
Date:   Sun, 20 Mar 2022 09:58:06 -0700
Cc:     ast@kernel.org, daniel@iogearbox.net, andrii@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com,
        john.fastabend@gmail.com, kpsingh@kernel.org,
        netdev@vger.kernel.org, bpf@vger.kernel.org
Message-Id: <0D674EA5-3626-4885-9ADC-5B7847CC967D@linux.dev>
References: <20220320060815.7716-2-laoar.shao@gmail.com>
To:     Yafang Shao <laoar.shao@gmail.com>
X-Migadu-Flow: FLOW_OUT
X-Migadu-Auth-User: linux.dev
X-Spam-Status: No, score=-2.8 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_LOW,SPF_HELO_NONE,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


> On Mar 19, 2022, at 11:08 PM, Yafang Shao <laoar.shao@gmail.com> wrote:
>=20
> =EF=BB=BFSince we have alread switched to memcg-based memory accouting and=
 control,
> we don't need RLIMIT_MEMLOCK any more.
>=20
> Signed-off-by: Yafang Shao <laoar.shao@gmail.com>
> Cc: Roman Gushchin <roman.gushchin@linux.dev>
>=20
> ---
> RLIMIT_MEMLOCK is still used in bpftool and libbpf, but it may be useful
> for backward compatibility, so I don't cleanup them.

Hi Yafang!

As I remember, we haven=E2=80=99t cleaned selftests up with the same logic: i=
t=E2=80=99s nice to be able to run the same version of tests on older kernel=
s.

Thanks!=
