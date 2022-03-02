Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id A83FF4CA049
	for <lists+netdev@lfdr.de>; Wed,  2 Mar 2022 10:06:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S240307AbiCBJHN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 2 Mar 2022 04:07:13 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:48660 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S230023AbiCBJHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 2 Mar 2022 04:07:12 -0500
Received: from chinatelecom.cn (prt-mail.chinatelecom.cn [42.123.76.219])
        by lindbergh.monkeyblade.net (Postfix) with ESMTP id 522D3BABB3;
        Wed,  2 Mar 2022 01:06:29 -0800 (PST)
HMM_SOURCE_IP: 172.18.0.188:38952.203715849
HMM_ATTACHE_NUM: 0001
HMM_SOURCE_TYPE: SMTP
Received: from clientip-182.150.57.243 (unknown [172.18.0.188])
        by chinatelecom.cn (HERMES) with SMTP id ED8AA2800F0;
        Wed,  2 Mar 2022 17:06:12 +0800 (CST)
X-189-SAVE-TO-SEND: lic121@chinatelecom.cn
Received: from  ([172.18.0.188])
        by app0023 with ESMTP id 181652b5ea4943a88621de3d88cb3aa5 for bjorn.topel@gmail.com;
        Wed, 02 Mar 2022 17:06:20 CST
X-Transaction-ID: 181652b5ea4943a88621de3d88cb3aa5
X-Real-From: lic121@chinatelecom.cn
X-Receive-IP: 172.18.0.188
X-MEDUSA-Status: 0
Sender: lic121@chinatelecom.cn
Date:   Wed, 2 Mar 2022 09:06:03 +0000
From:   lic121 <lic121@chinatelecom.cn>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        bpf <bpf@vger.kernel.org>,
        Magnus Karlsson <magnus.karlsson@intel.com>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Andrii Nakryiko <andrii@kernel.org>,
        Martin KaFai Lau <kafai@fb.com>,
        Song Liu <songliubraving@fb.com>, Yonghong Song <yhs@fb.com>,
        John Fastabend <john.fastabend@gmail.com>,
        KP Singh <kpsingh@kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesper Dangaard Brouer <hawk@kernel.org>,
        Network Development <netdev@vger.kernel.org>,
        open list <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH bpf] libbpf: unmap rings when umem deleted
Message-ID: <20220302090603.GA12386@vscode>
References: <20220301132623.GA19995@vscode.7~>
 <CAJ8uoz2y2r1wS3_sSgZ8jC2fkiyNCW_q4oQdc_JYe2bKO4NoJA@mail.gmail.com>
 <CAJ+HfNiXD_T4qdA7hMep0ncTDnPCNdtV74F8P_oTWb=2ZVoG+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNiXD_T4qdA7hMep0ncTDnPCNdtV74F8P_oTWb=2ZVoG+Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Spam-Status: No, score=-1.9 required=5.0 tests=BAYES_00,SPF_HELO_PASS,
        SPF_PASS,T_SCC_BODY_TEXT_LINE autolearn=ham autolearn_force=no
        version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Mar 02, 2022 at 09:48:33AM +0100, Björn Töpel wrote:
> On Wed, 2 Mar 2022 at 08:29, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> > On Tue, Mar 1, 2022 at 6:57 PM lic121 <lic121@chinatelecom.cn> wrote:
> [...]
> > > Signed-off-by: lic121 <lic121@chinatelecom.cn>
> 
> In addition to Magnus' comments; Please use your full name, as
> outlined in Documentation/process/5.Posting.rst.

Thanks for the review Björn.
Magnus, please let me know if you can correct the full name when you
apply the patch? Otherwise I can create a MR in libxdp repo. Thanks

full name: Cheng Li

> 
> Cheers!
> Björn
