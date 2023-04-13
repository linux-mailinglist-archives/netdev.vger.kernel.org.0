Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id CB0F16E1727
	for <lists+netdev@lfdr.de>; Fri, 14 Apr 2023 00:05:34 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230073AbjDMWFc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 13 Apr 2023 18:05:32 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:36808 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229625AbjDMWFb (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 13 Apr 2023 18:05:31 -0400
Received: from dfw.source.kernel.org (dfw.source.kernel.org [IPv6:2604:1380:4641:c500::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 4D8DA4C32;
        Thu, 13 Apr 2023 15:05:30 -0700 (PDT)
Received: from smtp.kernel.org (relay.kernel.org [52.25.139.140])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by dfw.source.kernel.org (Postfix) with ESMTPS id C7C1C641B1;
        Thu, 13 Apr 2023 22:05:29 +0000 (UTC)
Received: by smtp.kernel.org (Postfix) with ESMTPSA id 06BC1C433D2;
        Thu, 13 Apr 2023 22:05:29 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1681423529;
        bh=X/8T9no8AB2J34rmBP2/hr8j3YKXCkaRcMGnKyfF67A=;
        h=In-Reply-To:References:Subject:From:Cc:To:Date:From;
        b=DrfQjiCgjHYtn0mYTcyhFbQMx+ZuYRnWl/7PLsb6EabQrRRyK3Fl6xI14TLLpS/Db
         PtqX/8XKeR+afQSl+3GXX0AV1kEb7CbC6oGcQWLr18QS/mZ5N3d+Yfa9894SuLbGUz
         VdCLT6q9bhX8aMwevU1SOrUrRSr6bmD/DzLkECNs/i+L22b7cztrWPKSgam67WR03e
         oaldKywwzia/opFZNfu/CddEunoQMzZLZO6FntIUNHfgjGVaUJxs5KD4ACWhaTgRXA
         GJ1p1laQiWg64eT/D0AVrHKhK4lX6CKhEKxQtZDIplsxdP6pWXEmeeZfZRI+lv/5UW
         QOyhz413QnTxQ==
Message-ID: <7b2b2eefb4b7b6ef8ac2a3176286a97b.sboyd@kernel.org>
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20230413210127.s5dkek6adp5ndern@halaney-x13s>
References: <20230413191541.1073027-1-ahalaney@redhat.com> <20230413191541.1073027-4-ahalaney@redhat.com> <a295939f0058373d1caf956749820c0d.sboyd@kernel.org> <20230413210127.s5dkek6adp5ndern@halaney-x13s>
Subject: Re: [PATCH v5 3/3] arm64: dts: qcom: sa8540p-ride: Add ethernet nodes
From:   Stephen Boyd <sboyd@kernel.org>
Cc:     linux-kernel@vger.kernel.org, agross@kernel.org,
        andersson@kernel.org, konrad.dybcio@linaro.org, robh+dt@kernel.org,
        krzysztof.kozlowski+dt@linaro.org, mturquette@baylibre.com,
        richardcochran@gmail.com, linux-arm-msm@vger.kernel.org,
        devicetree@vger.kernel.org, linux-clk@vger.kernel.org,
        netdev@vger.kernel.org, bmasney@redhat.com, echanude@redhat.com,
        ncai@quicinc.com, jsuraj@qti.qualcomm.com, hisunil@quicinc.com
To:     Andrew Halaney <ahalaney@redhat.com>
Date:   Thu, 13 Apr 2023 15:05:26 -0700
User-Agent: alot/0.10
X-Spam-Status: No, score=-4.4 required=5.0 tests=BAYES_00,DKIMWL_WL_HIGH,
        DKIM_SIGNED,DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,RCVD_IN_DNSWL_MED,
        SPF_HELO_NONE,SPF_PASS autolearn=ham autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Quoting Andrew Halaney (2023-04-13 14:01:27)
> On Thu, Apr 13, 2023 at 01:47:19PM -0700, Stephen Boyd wrote:
> > Quoting Andrew Halaney (2023-04-13 12:15:41)
> > >  arch/arm64/boot/dts/qcom/sa8540p-ride.dts | 179 ++++++++++++++++++++=
++
> > >  1 file changed, 179 insertions(+)
> > >=20
> > > diff --git a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts b/arch/arm64/b=
oot/dts/qcom/sa8540p-ride.dts
> > > index 40db5aa0803c..650cd54f418e 100644
> > > --- a/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> > > +++ b/arch/arm64/boot/dts/qcom/sa8540p-ride.dts
> > > @@ -28,6 +28,65 @@ aliases {
> > >         chosen {
> > >                 stdout-path =3D "serial0:115200n8";
> > >         };
> > > +
> > > +       mtl_rx_setup: rx-queues-config {
> >=20
> > Is there a reason why this isn't a child of an ethernet node?
> >=20
> >=20
>=20
> I debated if it was more appropriate to:
>=20
>     1. make a duplicate in each ethernet node (ethernet0/1)
>     2. Put it in one and reference from both
>     3. have it floating around independent like this, similar to what is
>        done in sa8155p-adp.dts[0]
>=20
> I chose 3 as it seemed cleanest, but if there's a good argument for a
> different approach I'm all ears!

I wonder if it allows the binding checker to catch bad properties by
having it under the ethernet node? That's the only thing I can think of
that may be improved, but I'll let binding reviewers comment here.
