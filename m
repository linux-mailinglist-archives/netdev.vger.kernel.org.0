Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id DDB3551FA99
	for <lists+netdev@lfdr.de>; Mon,  9 May 2022 12:56:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230143AbiEIK7k (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 May 2022 06:59:40 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:35458 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230140AbiEIK7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 May 2022 06:59:38 -0400
Received: from ams.source.kernel.org (ams.source.kernel.org [145.40.68.75])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 6B7231FC2C7;
        Mon,  9 May 2022 03:55:35 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ams.source.kernel.org (Postfix) with ESMTPS id 162F8B81145;
        Mon,  9 May 2022 10:55:34 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id A1AB9C385AF;
        Mon,  9 May 2022 10:55:32 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1652093732;
        bh=Snp0YM5oY+98yO5f1lRrD5u5TGRXMawbpEE91gZIEBQ=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=hhc0x8srpP5R7CMbkRuvVnQimzoWoUVt94wgD6dfEgEbs/DvIGFJRgdhImGQIRNJ8
         etnjv14VTj8EbNy+vAoOx4lPeKAhoACCYSlbayzgsIy/UvqHafuZ9jnlMb+V+P0jVN
         zCXVnQSsLH7QW+/PXbgf4HJ0R7tfRRqrMaQDqVmcrJa0ukG3ait5xOuRBTy64Li9iG
         dZoJme+mqrS0V66HKBckNmcwmiDJNPe2j8+33jUR+1wx4WVkJh1Jx27FM3IFEYPhCh
         J8SAnKvy9dHL+ccXsoYUF0SUmGFpBZVu+l8ChYS/OWW3JJaSOn4Fle3LzWLS2d1KDu
         urqM5Y0P/EcWQ==
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 8DD5C34DD39; Mon,  9 May 2022 12:55:29 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@kernel.org>
To:     shaozhengchao <shaozhengchao@huawei.com>,
        "bpf@vger.kernel.org" <bpf@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "ast@kernel.org" <ast@kernel.org>,
        "daniel@iogearbox.net" <daniel@iogearbox.net>,
        "davem@davemloft.net" <davem@davemloft.net>,
        "kuba@kernel.org" <kuba@kernel.org>,
        "hawk@kernel.org" <hawk@kernel.org>,
        "john.fastabend@gmail.com" <john.fastabend@gmail.com>,
        "andrii@kernel.org" <andrii@kernel.org>,
        "kafai@fb.com" <kafai@fb.com>,
        "songliubraving@fb.com" <songliubraving@fb.com>,
        "yhs@fb.com" <yhs@fb.com>,
        "kpsingh@kernel.org" <kpsingh@kernel.org>
Cc:     "weiyongjun (A)" <weiyongjun1@huawei.com>,
        yuehaibing <yuehaibing@huawei.com>
Subject: Re: =?utf-8?B?562U5aSNOg==?= [PATCH bpf-next] samples/bpf: check
 detach prog exist or
 not in xdp_fwd
In-Reply-To: <f9c85578b94a4a38b3f7b9c796810a30@huawei.com>
References: <20220509005105.271089-1-shaozhengchao@huawei.com>
 <87pmknyr6b.fsf@toke.dk> <f9c85578b94a4a38b3f7b9c796810a30@huawei.com>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Mon, 09 May 2022 12:55:29 +0200
Message-ID: <87h75zynz2.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Spam-Status: No, score=-7.7 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_HI,
        SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

shaozhengchao <shaozhengchao@huawei.com> writes:

> -----=E9=82=AE=E4=BB=B6=E5=8E=9F=E4=BB=B6-----
> =E5=8F=91=E4=BB=B6=E4=BA=BA: Toke H=C3=B8iland-J=C3=B8rgensen [mailto:tok=
e@kernel.org]=20
> =E5=8F=91=E9=80=81=E6=97=B6=E9=97=B4: 2022=E5=B9=B45=E6=9C=889=E6=97=A5 1=
7:46
> =E6=94=B6=E4=BB=B6=E4=BA=BA: shaozhengchao <shaozhengchao@huawei.com>; bp=
f@vger.kernel.org; netdev@vger.kernel.org; linux-kernel@vger.kernel.org; as=
t@kernel.org; daniel@iogearbox.net; davem@davemloft.net; kuba@kernel.org; h=
awk@kernel.org; john.fastabend@gmail.com; andrii@kernel.org; kafai@fb.com; =
songliubraving@fb.com; yhs@fb.com; kpsingh@kernel.org
> =E6=8A=84=E9=80=81: weiyongjun (A) <weiyongjun1@huawei.com>; shaozhengcha=
o <shaozhengchao@huawei.com>; yuehaibing <yuehaibing@huawei.com>
> =E4=B8=BB=E9=A2=98: Re: [PATCH bpf-next] samples/bpf: check detach prog e=
xist or not in xdp_fwd
>
> Zhengchao Shao <shaozhengchao@huawei.com> writes:
>
>> Before detach the prog, we should check detach prog exist or not.
>
> If we're adding such a check we should also check that it's the *right* p=
rogram. I.e., query the ID for the program name and check that it matches w=
hat the program attached, then obtain an fd and pass that as XDP_EXPECTED_F=
D on detach to make sure it wasn't swapped out in the meantime...
>
> -Toke
>
> Thank you for your reply. When finish running xdp_fwd to attatch prog,
> the program will exit and can't store fd as XDP_EXPECTED_FD.
>
> I think the sample xdp_fwd -d is just detach prog and don't care if
> the fd is expected.

So why are you adding the check? Either keep it the way it is, or add a
proper check that examines the program type; you're right that it
doesn't store the prog FD, but you can still check the program name and
see if it matches to get some idea that it's not a totally separate
program that's loaded. I think doing so would be an improvement to the
sample, but just adding a check if a program is loaded is not, really...

-Toke
