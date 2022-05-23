Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 23AAC531032
	for <lists+netdev@lfdr.de>; Mon, 23 May 2022 15:19:47 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S235626AbiEWMm6 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 23 May 2022 08:42:58 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:33186 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235586AbiEWMm5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 23 May 2022 08:42:57 -0400
Received: from mga07.intel.com (mga07.intel.com [134.134.136.100])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id AB82E20F70;
        Mon, 23 May 2022 05:42:56 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple;
  d=intel.com; i=@intel.com; q=dns/txt; s=Intel;
  t=1653309776; x=1684845776;
  h=date:from:to:cc:subject:message-id:references:
   mime-version:content-transfer-encoding:in-reply-to;
  bh=CYBlt4HV9JNO/N88R6DDSsOe+zvHqFJW0VyNiGAZBvU=;
  b=iD3CNxtMPuSS7sTCf9qEh54+j5w7vU8kNEfOiM9uji6u/kew/HsdJ5lf
   vKX7hohv1CACvWwwVTlD7yic204nO5IlYAcj1MMESlOWinbaApdiKd/RM
   o0NOgsd6IofN/XaVKnJmyZ/+57xHng8IKq1B5auuqu3alnJDFjcz1jUfN
   NEognW8BeVMn8rdwWAaNgjCpp/AlXTqStgeWurrv2NPn1EhOgpfESMY+C
   izHvSWbVvTop4x8IXJsOkhdtAVaf6egWqudFRLaMdEcKBRRCuAobHay5i
   iEJ4oBBtYL3TE7MbPWQqsYZmnkF0p39+ysk235cF6dFgwCXLWsqTBCAsW
   A==;
X-IronPort-AV: E=McAfee;i="6400,9594,10355"; a="336268135"
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="336268135"
Received: from orsmga007.jf.intel.com ([10.7.209.58])
  by orsmga105.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 23 May 2022 05:42:56 -0700
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.91,246,1647327600"; 
   d="scan'208";a="572081945"
Received: from boxer.igk.intel.com (HELO boxer) ([10.102.20.173])
  by orsmga007.jf.intel.com with ESMTP; 23 May 2022 05:42:52 -0700
Date:   Mon, 23 May 2022 14:42:51 +0200
From:   Maciej Fijalkowski <maciej.fijalkowski@intel.com>
To:     =?iso-8859-1?Q?Bj=F6rn_T=F6pel?= <bjorn.topel@gmail.com>
Cc:     Magnus Karlsson <magnus.karlsson@gmail.com>,
        "Karlsson, Magnus" <magnus.karlsson@intel.com>,
        Alexei Starovoitov <ast@kernel.org>,
        Daniel Borkmann <daniel@iogearbox.net>,
        Netdev <netdev@vger.kernel.org>,
        Jonathan Lemon <jonathan.lemon@gmail.com>,
        bpf <bpf@vger.kernel.org>, David Miller <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        KP Singh <kpsingh@kernel.org>,
        John Fastabend <john.fastabend@gmail.com>,
        Yonghong Song <yhs@fb.com>,
        Andrii Nakryiko <andrii@kernel.org>,
        Song Liu <songliubraving@fb.com>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: [PATCH bpf-next] MAINTAINERS: add maintainer to AF_XDP
Message-ID: <YouBSxZWZEsCLfIl@boxer>
References: <20220523083254.32285-1-magnus.karlsson@gmail.com>
 <CAJ+HfNghrcajNC=m_hJAtKSRX906NARB4f6LWeginirZhuyg+Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CAJ+HfNghrcajNC=m_hJAtKSRX906NARB4f6LWeginirZhuyg+Q@mail.gmail.com>
X-Spam-Status: No, score=-5.1 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_NONE,T_SCC_BODY_TEXT_LINE autolearn=ham
        autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, May 23, 2022 at 12:25:47PM +0200, Björn Töpel wrote:
> On Mon, 23 May 2022 at 10:33, Magnus Karlsson <magnus.karlsson@gmail.com> wrote:
> >
> > Maciej Fijalkowski has gracefully accepted to become the third
> > maintainer for the AF_XDP code. Thank you Maciej!
> >
> 
> Awesome, and thanks for helping out, Maciej!

It is my pleasure, thanks!

Acked-by: Maciej Fijalkowski <maciej.fijalkowski@intel.com>

> 
> Acked-by: Björn Töpel <bjorn@kernel.org>
> 
> > Signed-off-by: Magnus Karlsson <magnus.karlsson@gmail.com>
> > ---
> >  MAINTAINERS | 1 +
> >  1 file changed, 1 insertion(+)
> >
> > diff --git a/MAINTAINERS b/MAINTAINERS
> > index 359afc617b92..adc63e18e601 100644
> > --- a/MAINTAINERS
> > +++ b/MAINTAINERS
> > @@ -21507,6 +21507,7 @@ K:      (?:\b|_)xdp(?:\b|_)
> >  XDP SOCKETS (AF_XDP)
> >  M:     Björn Töpel <bjorn@kernel.org>
> >  M:     Magnus Karlsson <magnus.karlsson@intel.com>
> > +M:     Maciej Fijalkowski <maciej.fijalkowski@intel.com>
> >  R:     Jonathan Lemon <jonathan.lemon@gmail.com>
> >  L:     netdev@vger.kernel.org
> >  L:     bpf@vger.kernel.org
> >
> > base-commit: c272e259116973b4c2d5c5ae7b6a4181aeeb38c7
> > --
> > 2.34.1
> >
