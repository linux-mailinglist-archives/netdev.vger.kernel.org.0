Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 24CE646FD8A
	for <lists+netdev@lfdr.de>; Fri, 10 Dec 2021 10:17:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S236578AbhLJJUo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Dec 2021 04:20:44 -0500
Received: from Galois.linutronix.de ([193.142.43.55]:45150 "EHLO
        galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S236566AbhLJJUn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 10 Dec 2021 04:20:43 -0500
Date:   Fri, 10 Dec 2021 10:17:05 +0100
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020; t=1639127827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrrpWGgf9+uiO2sWCKmxPg4yAkYkNCS2DX3oLevhhdU=;
        b=0+M5HkZ7rRvSfUvB3nU20IFpYjn5c5hh5759XiX1qFmZ5EAHBTHFBrClVCTVX/5KjeU0RW
        Jq/Ms1g4hQm/H6o/RR1qzT7tdzcE/TGdgANNFfF7SfXT1lHNnpmE0TGISlzq/NPKmEubff
        IfgLEiBsk4a1EitchxCXu3p27ZZc9m6Xf8mkOVnls9NL1i17rajXgNDlo8eP7I57RLXEOs
        rAVZTRj8ktfXFSFVyLvGBrbmhqrMcO/4X3ApgDy/hmiAr8SZdMkwylE5PA8ljvgAbSAkaj
        Dq0Fl54faONo8zr2cduIK+tJcv8r0AHytzHQrSh59IVe7RerqnVsT6yTKpSr0w==
DKIM-Signature: v=1; a=ed25519-sha256; c=relaxed/relaxed; d=linutronix.de;
        s=2020e; t=1639127827;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=SrrpWGgf9+uiO2sWCKmxPg4yAkYkNCS2DX3oLevhhdU=;
        b=0saKW2xNPpi+A5De4Ui8UB9vBldZR0H8mbo0Pi8XxsFQckrvMx2ZrQ5xNMlTacICe8gx4c
        NVlKV0UkzScyW2DA==
From:   Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To:     Ong Boon Leong <boon.leong.ong@intel.com>
Cc:     Giuseppe Cavallaro <peppe.cavallaro@st.com>,
        Alexandre Torgue <alexandre.torgue@st.com>,
        Jose Abreu <joabreu@synopsys.com>,
        "David S . Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Maxime Coquelin <mcoquelin.stm32@gmail.com>,
        alexandre.torgue@foss.st.com, Kurt Kanzenbach <kurt@linutronix.de>,
        netdev@vger.kernel.org, linux-stm32@st-md-mailman.stormreply.com,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH net 1/1] net: stmmac: fix tc flower deletion for VLAN
 priority Rx steering
Message-ID: <YbMbEclmABxiozb/@linutronix.de>
References: <20211209130335.81114-1-boon.leong.ong@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable
In-Reply-To: <20211209130335.81114-1-boon.leong.ong@intel.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 2021-12-09 21:03:35 [+0800], Ong Boon Leong wrote:
=E2=80=A6
> From dmesg, we will observe kernel NULL pointer ooops
>=20
> [  197.170464] BUG: kernel NULL pointer dereference, address: 00000000000=
00000
=E2=80=A6
> [  197.171367] ---[ end trace 8b8d1c617c39093d ]---

Could the huge amount of backtrace be parsed and converted into the
needed information. That could be why is the NULL pointer happening. The
notation of the call chain makes sense if important to the issue and not
obvious. Also a nice follow-up how the issue is addressed.

Sebastian
