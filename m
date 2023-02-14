Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 7E26C695F71
	for <lists+netdev@lfdr.de>; Tue, 14 Feb 2023 10:41:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S229647AbjBNJlM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 Feb 2023 04:41:12 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:50852 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229528AbjBNJlL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 14 Feb 2023 04:41:11 -0500
Received: from ams.source.kernel.org (ams.source.kernel.org [IPv6:2604:1380:4601:e00::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id E234C421B;
        Tue, 14 Feb 2023 01:41:07 -0800 (PST)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 8FD37B81C9D;
        Tue, 14 Feb 2023 09:41:06 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id B3B5CC433EF;
        Tue, 14 Feb 2023 09:41:04 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1676367665;
        bh=Y+pSaTFKlpQz78IlTtVvBCLvoo3rr6AowCczYCwKzx4=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=FXBin5I3Lii+BnX58DuP7Gmc2wOOdhFFhQQh9GDTK0v682XKLRRT+Z7rsVel3+OVJ
         AySRa7uM9iFs/5B0zPSAdC9TbEEYQgbkptuiDonHPOZRjYRlfEbSszhrQMsu7QYdjo
         DVAK8JLO6ZVggJfTq5PmP1hDen/firjbQ3ZJWg1grofjEiLplpXLK+Iw4fEMbEqcs8
         T+8jRC9eCAKniFgqNStPS/QSNhbM4+jyXtMAIlKw9BetlZOcjsU8841AScztR6pKdv
         aCiPCkc4RLhaMv/su/vtTBW2/0goVncjXB2BepW6mxqc3p+QHwxyOjrT3hFuE2jIEj
         AfIFVXD43oyrQ==
From:   =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@kernel.org>
To:     Zachary Leaf <zachary.leaf@arm.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>, bpf@vger.kernel.org,
        netdev@vger.kernel.org
Cc:     =?utf-8?B?QmrDtnJuIFTDtnBlbA==?= <bjorn@rivosinc.com>,
        Jean-Philippe Brucker <jean-philippe@linaro.org>,
        linux-kselftest@vger.kernel.org,
        Anders Roxell <anders.roxell@linaro.org>,
        linux-morello@op-lists.linaro.org,
        Quentin Monnet <quentin@isovalent.com>
Subject: Re: [PATCH bpf-next] selftests/bpf: Cross-compile bpftool
In-Reply-To: <88a5c080-b5fc-f78a-af9e-eb8af66149ec@arm.com>
References: <20230210084326.1802597-1-bjorn@kernel.org>
 <88a5c080-b5fc-f78a-af9e-eb8af66149ec@arm.com>
Date:   Tue, 14 Feb 2023 10:41:02 +0100
Message-ID: <874jroa8k1.fsf@all.your.base.are.belong.to.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Zachary Leaf <zachary.leaf@arm.com> writes:

> Hi Bjorn,
>
> Thanks for the patch, I've tested it and it works for me.

Good!

> I have a minor suggestion but otherwise happy to see this getting fixed.
>
> ...
>
>
> -TEST_GEN_PROGS_EXTENDED +=3D $(DEFAULT_BPFTOOL)
> +TEST_GEN_PROGS_EXTENDED +=3D $(TRUNNER_BPFTOOL)
>
> Ensure the target arch bpftool is copied into the kselftest_bpf_install
> dir by selftests/lib.mk instead of always the default/host version.

Good one. I'll spin a v2, and also fix Quentin's "double-slash".


Bj=C3=B6rn
