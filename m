Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 119E63DF31B
	for <lists+netdev@lfdr.de>; Tue,  3 Aug 2021 18:46:57 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S234731AbhHCQrE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Aug 2021 12:47:04 -0400
Received: from new1-smtp.messagingengine.com ([66.111.4.221]:43487 "EHLO
        new1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S234108AbhHCQrD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Aug 2021 12:47:03 -0400
Received: from compute6.internal (compute6.nyi.internal [10.202.2.46])
        by mailnew.nyi.internal (Postfix) with ESMTP id AC6D0580A0A;
        Tue,  3 Aug 2021 12:46:49 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute6.internal (MEProxy); Tue, 03 Aug 2021 12:46:49 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-transfer-encoding:content-type
        :date:from:in-reply-to:message-id:mime-version:references
        :subject:to:x-me-proxy:x-me-proxy:x-me-sender:x-me-sender
        :x-sasl-enc; s=fm3; bh=zy6iG0gCp/0nHt5NgRcKlD7Cb32bGCDMBhQT+O39O
        K4=; b=StyDkM8xzytaeNaH95Dh5AvtSJ9QOVuukLclIYMi5Zv+PRq+6DgrtHb+u
        eaeMGzBx5vuYMi6fSLa2GNoSIT2aaR/y2Bz03nYHqy/YIay2dU6apd3/x3vThqJz
        3RmPji85gzJKP3sI8ILVSUgvvJZdgz2MommovnkgxOSw6O9BLn+gEHnWtNkDOSJx
        rKclu+TTtXnVubYxRerJZml4zMZ3xuLCNfR/WKPU1j7+Jh4lpD3WMEYs5fX9W09a
        6gKCaO1IpK0Rd6KP9ZuCJrshE74PNu6WcsYZJ6qYSsKnsxws3v6dmBfV0ZGa9Z93
        LiYqFO4X5Il0vs+h+UiaIR5meUmow==
X-ME-Sender: <xms:-HIJYcV4i4Yqe2AVbA-DUIxlcmjYoJRIiqJof5D2OnmADzqfqpiKyQ>
    <xme:-HIJYQmGdQs91KjYmoLheAwcZRE4wZfBnpfQ4p0x3hQ6bDYan1bDF7rqvje4M8_yf
    VdUyYFuLwcZFTA>
X-ME-Received: <xmr:-HIJYQaAIs2QD6Gg0pgrL6qZUEtoRuhLZ_dBuzI-83lgH6VEkoY9IvaWQ3WE-j2-vyrYoZ4oCZuBK6IVgyxkxeRHbVV0YA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrieeggddutdduucetufdoteggodetrfdotf
    fvucfrrhhofhhilhgvmecuhfgrshhtofgrihhlpdfqfgfvpdfurfetoffkrfgpnffqhgen
    uceurghilhhouhhtmecufedttdenucesvcftvggtihhpihgvnhhtshculddquddttddmne
    cujfgurhepfffhvffukfhfgggtugfgjgesthekredttddtudenucfhrhhomhepkfguohcu
    ufgthhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrth
    htvghrnhepvdffveekfeeiieeuieetudefkeevkeeuhfeuieduudetkeegleefvdegheej
    hefhnecuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepih
    guohhstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:-HIJYbVSIdWoN169mN-rUK3Kg5r0evje-PWPA6kAsJ-2UXYDICs2gA>
    <xmx:-HIJYWmZniBHPHCplgXUWJ3HXeFnbe5t4GQbPMNvi6fi97RighY6xg>
    <xmx:-HIJYQdEDl0PJc0KJjn8gPR0wJF-lHWuqYsMuM_kUpj6SJny181LiQ>
    <xmx:-XIJYckzbQi13uolv3WRpiAyokuNbvH7Fg9wjN_IhkITPtVuYaaXnA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Tue,
 3 Aug 2021 12:46:48 -0400 (EDT)
Date:   Tue, 3 Aug 2021 19:46:44 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     "Volodymyr Mytnyk [C]" <vmytnyk@marvell.com>
Cc:     Vadym Kochan <vadym.kochan@plvision.eu>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jamal Hadi Salim <jhs@mojatatu.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Lunn <andrew@lunn.ch>,
        Vladimir Oltean <olteanv@gmail.com>,
        Serhiy Boiko <serhiy.boiko@plvision.eu>,
        Volodymyr Mytnyk <volodymyr.mytnyk@plvision.eu>,
        Taras Chornyi <taras.chornyi@plvision.eu>,
        "Taras Chornyi [C]" <tchornyi@marvell.com>,
        Mickey Rachamim <mickeyr@marvell.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Vadym Kochan [C]" <vkochan@marvell.com>
Subject: Re: [PATCH net-next v2 4/4] net: marvell: prestera: Offload
 FLOW_ACTION_POLICE
Message-ID: <YQly9LnGStm2Ju0H@shredder>
References: <20210802140849.2050-1-vadym.kochan@plvision.eu>
 <20210802140849.2050-5-vadym.kochan@plvision.eu>
 <YQgN1djql6wOk8dc@shredder>
 <SJ0PR18MB4009243B42CB9A03C2C35647B2F09@SJ0PR18MB4009.namprd18.prod.outlook.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <SJ0PR18MB4009243B42CB9A03C2C35647B2F09@SJ0PR18MB4009.namprd18.prod.outlook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, Aug 03, 2021 at 04:19:03PM +0000, Volodymyr Mytnyk [C] wrote:
> > On Mon, Aug 02, 2021 at 05:08:49PM +0300, Vadym Kochan wrote:
> > It seems the implementation assumes that each rule has a different
> > policer, so an error should be returned in case the same policer is
> > shared between different rules.
> 
> Each rule has a different policer assigned by HW. Do you mean the police.index should be checked here ?

Yes. Checked to make sure each rule uses a different policer.

> 
> >
> > > +                     break;
> > >                default:
> > >                        NL_SET_ERR_MSG_MOD(extack, "Unsupported action");
> > >                        pr_err("Unsupported action\n");
> > > @@ -110,6 +117,17 @@ static int prestera_flower_parse(struct prestera_flow_block *block,
> > >                return -EOPNOTSUPP;
> > >        }
> > >
> > > +     if (f->classid) {
> > > +             int hw_tc = __tc_classid_to_hwtc(PRESTERA_HW_TC_NUM, f->classid);
> > > +
> > > +             if (hw_tc < 0) {
> > > +                     NL_SET_ERR_MSG_MOD(f->common.extack, "Unsupported HW TC");
> > > +                     return hw_tc;
> > > +             }
> > > +
> > > +             prestera_acl_rule_hw_tc_set(rule, hw_tc);
> > > +     }
> >
> > Not sure what this is. Can you show a command line example of how this
> > is used?
> 
> This is HW traffic class used for packets that are trapped to CPU port. The usage is as the following:
> 
> tc qdisc add dev DEV clsact
> tc filter add dev DEV ingress flower skip_sw dst_mac 00:AA:AA:AA:AA:00 hw_tc 1 action trap

You are not using any police action in this example and the changelogs
do not say anything about trap / CPU port so I fail to understand how
this hunk is related to the submission.

> 
> >
> > What about visibility regarding number of packets that were dropped by
> > the policer?
> 
> This is not support at this moment by the driver, so it is always zero now.

You plan to support it? I imagine the hardware policer is able to report
the number of packets it dropped.
