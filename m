Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DF5443F04F9
	for <lists+netdev@lfdr.de>; Wed, 18 Aug 2021 15:39:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S237783AbhHRNkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 18 Aug 2021 09:40:23 -0400
Received: from out4-smtp.messagingengine.com ([66.111.4.28]:35199 "EHLO
        out4-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S237666AbhHRNkS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 18 Aug 2021 09:40:18 -0400
Received: from compute5.internal (compute5.nyi.internal [10.202.2.45])
        by mailout.nyi.internal (Postfix) with ESMTP id E44545C0185;
        Wed, 18 Aug 2021 09:39:41 -0400 (EDT)
Received: from mailfrontend2 ([10.202.2.163])
  by compute5.internal (MEProxy); Wed, 18 Aug 2021 09:39:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=
        messagingengine.com; h=cc:content-type:date:from:in-reply-to
        :message-id:mime-version:references:subject:to:x-me-proxy
        :x-me-proxy:x-me-sender:x-me-sender:x-sasl-enc; s=fm3; bh=H5V+/6
        w875g2KsTJT9wfp6tsPpldI1cv4Bg3QhTd+vw=; b=qfSA10ZBj+LsrJq9CyGEOu
        rN3Qu0jnCnN3Mxl0SXQGxLuBJR6v/4bB2xqw93KxRT6IArk4eDdKL3OouiYGaXUJ
        5d7J4zsFA5OnJucZYMRNdwouaNvVptBe7ARbZsGwVdq6UlHuDzsw0yrq+1kHHFp5
        UN/F9T+VFty9pUo/RNZR/MmriDIVnwEOXlfsG0IxU1omItGI9cy9e3sGLPtPWaUm
        Ig55d4fDfPgYjT6xVV6vi5qJQ8re4qq0xq9jEFopejlk/uKciojrmxFTB/gXBKTl
        JjLY9QwvptopBXtGDe9OFx2Vjho2WSsfC0plYbcOpFeXJzWdhN0DjhaLzAe3gMzw
        ==
X-ME-Sender: <xms:nA0dYa1TIiAT1uvVNPiHhJUZICIzhlVARLZ2sPUfBiirJlBxBcw-Kw>
    <xme:nA0dYdEqPfetP8L6sbV5G6uI3ibtoseBOspT_6j3GpRQpFgpDwB0B-seoPkXReuM-
    geGU5A-lPu0Xc0>
X-ME-Received: <xmr:nA0dYS5Zj-c6NxePONMlUW2QrAcxcX_VjBhOSU2vKm7SreCRJZas9Kw6YJ4RDy8u6_WmBcxcvgJEyThg4RVOvNSiCEFEdA>
X-ME-Proxy-Cause: gggruggvucftvghtrhhoucdtuddrgedvtddrleehgdeiiecutefuodetggdotefrodftvf
    curfhrohhfihhlvgemucfhrghsthforghilhdpqfgfvfdpuffrtefokffrpgfnqfghnecu
    uegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmdenuc
    fjughrpeffhffvuffkfhggtggujgesthdtredttddtvdenucfhrhhomhepkfguohcuufgt
    hhhimhhmvghluceoihguohhstghhsehiughoshgthhdrohhrgheqnecuggftrfgrthhtvg
    hrnheptdffkeekfeduffevgeeujeffjefhtefgueeugfevtdeiheduueeukefhudehleet
    necuvehluhhsthgvrhfuihiivgeptdenucfrrghrrghmpehmrghilhhfrhhomhepihguoh
    hstghhsehiughoshgthhdrohhrgh
X-ME-Proxy: <xmx:nA0dYb24c8EmqDlNQ54SugErYNe4P9nmG94pwR6uqVZ5YOw3HvtoXQ>
    <xmx:nA0dYdE6v8YsDhgAJcD_wvfanZ3zKYrdTnTeeuMpFxvS5v4CtLGdRw>
    <xmx:nA0dYU9t1mWor1zi_ktaP_9oCgrdYkyZ6ABzlCa6RlxuvhtHI7UKZQ>
    <xmx:nQ0dYS7-L-OJiVNBCwfbVS-93tRPlVTBJXz-LQ1hoPzifooVoOgnlA>
Received: by mail.messagingengine.com (Postfix) with ESMTPA; Wed,
 18 Aug 2021 09:39:39 -0400 (EDT)
Date:   Wed, 18 Aug 2021 16:39:36 +0300
From:   Ido Schimmel <idosch@idosch.org>
To:     Jamal Hadi Salim <jhs@mojatatu.com>
Cc:     13145886936@163.com, davem@davemloft.net, kuba@kernel.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        gushengxian <gushengxian@yulong.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Jiri Pirko <jiri@resnulli.us>
Subject: Re: [PATCH] flow_offload: action should not be NULL when it is
 referenced
Message-ID: <YR0NmNZe05yRn3Vs@shredder>
References: <20210626115606.1243151-1-13145886936@163.com>
 <YRz1297sFSjG7/Cc@shredder>
 <d20577c8-e5df-a31d-8435-619994dd5855@mojatatu.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <d20577c8-e5df-a31d-8435-619994dd5855@mojatatu.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Aug 18, 2021 at 08:36:55AM -0400, Jamal Hadi Salim wrote:
> On 2021-08-18 7:58 a.m., Ido Schimmel wrote:
> > On Sat, Jun 26, 2021 at 04:56:06AM -0700, 13145886936@163.com wrote:
> > > From: gushengxian <gushengxian@yulong.com>
> > > 
> > > "action" should not be NULL when it is referenced.
> > > 
> > > Signed-off-by: gushengxian <13145886936@163.com>
> > > Signed-off-by: gushengxian <gushengxian@yulong.com>
> > > ---
> > >   include/net/flow_offload.h | 12 +++++++-----
> > >   1 file changed, 7 insertions(+), 5 deletions(-)
> > > 
> > > diff --git a/include/net/flow_offload.h b/include/net/flow_offload.h
> > > index dc5c1e69cd9f..69c9eabf8325 100644
> > > --- a/include/net/flow_offload.h
> > > +++ b/include/net/flow_offload.h
> > > @@ -319,12 +319,14 @@ flow_action_mixed_hw_stats_check(const struct flow_action *action,
> > >   	if (flow_offload_has_one_action(action))
> > >   		return true;
> > > -	flow_action_for_each(i, action_entry, action) {
> > > -		if (i && action_entry->hw_stats != last_hw_stats) {
> > > -			NL_SET_ERR_MSG_MOD(extack, "Mixing HW stats types for actions is not supported");
> > > -			return false;
> > > +	if (action) {
> > 
> > This patch generates a smatch warning:
> > 
> > include/net/flow_offload.h:322 flow_action_mixed_hw_stats_check() warn: variable dereferenced before check 'action' (see line 319)
> > 
> > Why the patch is needed? 'action' is already dereferenced in
> > flow_offload_has_one_action()
> > 
> 
> Yep, doesnt make sense at all.

Will send a revert
