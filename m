Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from out1.vger.email (out1.vger.email [IPv6:2620:137:e000::1:20])
	by mail.lfdr.de (Postfix) with ESMTP id 3B2E34C4F88
	for <lists+netdev@lfdr.de>; Fri, 25 Feb 2022 21:20:30 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236273AbiBYUUA (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 25 Feb 2022 15:20:00 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38290 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S235385AbiBYUT6 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 25 Feb 2022 15:19:58 -0500
Received: from mail.z3ntu.xyz (mail.z3ntu.xyz [128.199.32.197])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 7CC701DAC68;
        Fri, 25 Feb 2022 12:19:25 -0800 (PST)
Received: from g550jk.localnet (ip-213-127-118-180.ip.prioritytelecom.net [213.127.118.180])
        by mail.z3ntu.xyz (Postfix) with ESMTPSA id 92CA5C85F5;
        Fri, 25 Feb 2022 20:19:23 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=simple/simple; d=z3ntu.xyz; s=z3ntu;
        t=1645820363; bh=GnyUUiNHpUn3QnisFNkFdrmk5sr7MjhAKDiPsbgu4M8=;
        h=From:To:Cc:Subject:Date:In-Reply-To:References;
        b=ib18iXolVkkvwEM7reE5uHeb8mdqqho5kueaWEP+Fx99qfBhb9c1ShwqpbLdj/L82
         08o12yhNliPUJI/QNTj0hRei2PgjVYOYm8RMORMKEpHODc9cby5wY2SqwKM/ZlRh1F
         NCWtlGERvfPkQvR2ApvKaLIEGWSXtzZ2yO8zrBD8=
From:   Luca Weiss <luca@z3ntu.xyz>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     linux-arm-msm@vger.kernel.org,
        ~postmarketos/upstreaming@lists.sr.ht, phone-devel@vger.kernel.org,
        Linus Walleij <linus.walleij@linaro.org>,
        devicetree@vger.kernel.org, linux-bluetooth@vger.kernel.org,
        linux-kernel@vger.kernel.org, netdev@vger.kernel.org,
        Marcel Holtmann <marcel@holtmann.org>
Subject: Re: [PATCH 0/5] Wifi & Bluetooth on LG G Watch R
Date:   Fri, 25 Feb 2022 21:19:23 +0100
Message-ID: <4379033.LvFx2qVVIh@g550jk>
In-Reply-To: <YhcGSmd5M3W+fI6c@builder.lan>
References: <20220216212433.1373903-1-luca@z3ntu.xyz> <YhcGSmd5M3W+fI6c@builder.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Spam-Status: No, score=0.4 required=5.0 tests=BAYES_00,DKIM_SIGNED,
        DKIM_VALID,DKIM_VALID_AU,DKIM_VALID_EF,FROM_SUSPICIOUS_NTLD,
        PDS_OTHER_BAD_TLD,SPF_HELO_NONE,SPF_PASS,T_SCC_BODY_TEXT_LINE
        autolearn=no autolearn_force=no version=3.4.6
X-Spam-Checker-Version: SpamAssassin 3.4.6 (2021-04-09) on
        lindbergh.monkeyblade.net
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi Bjorn

On Donnerstag, 24. Februar 2022 05:15:06 CET Bjorn Andersson wrote:
> On Wed 16 Feb 15:24 CST 2022, Luca Weiss wrote:
> > This series adds the BCM43430A0 chip providing Bluetooth & Wifi on the
> > LG G Watch R.
> 
> I picked the dts changes, but would prefer that the other two changes
> goes through the BT tree. I see that you haven't copied Marcel on the
> dt-binding change though, so please resubmit those two patches together.

Thank you, will resubmit the first two!

Just to be clear, as far as I understand each patch gets sent based on its own 
get_maintainer.pl, and the cover letter gets sent to the superset of all 
individual patch recipients?
I'm using this script that's largely based on something I found online a while 
ago
https://github.com/z3ntu/dotfiles/blob/master/scripts/usr/local/bin/cocci_cc

Also just checked and Marcel isn't listed as maintainer of the relevant dt 
bindings in MAINTAINERS, maybe they should get added there?

(also CCed Marcel on this email)

Regards
Luca

> 
> Thanks,
> Bjorn
> 
> > Luca Weiss (5):
> >   dt-bindings: bluetooth: broadcom: add BCM43430A0
> >   Bluetooth: hci_bcm: add BCM43430A0
> >   ARM: dts: qcom: msm8226: Add pinctrl for sdhci nodes
> >   ARM: dts: qcom: apq8026-lg-lenok: Add Wifi
> >   ARM: dts: qcom: apq8026-lg-lenok: Add Bluetooth
> >  
> >  .../bindings/net/broadcom-bluetooth.yaml      |  1 +
> >  arch/arm/boot/dts/qcom-apq8026-lg-lenok.dts   | 98 ++++++++++++++++---
> >  arch/arm/boot/dts/qcom-msm8226.dtsi           | 57 +++++++++++
> >  drivers/bluetooth/hci_bcm.c                   |  1 +
> >  4 files changed, 144 insertions(+), 13 deletions(-)




