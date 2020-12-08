Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id F0E682D31FC
	for <lists+netdev@lfdr.de>; Tue,  8 Dec 2020 19:19:48 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730950AbgLHSTc (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Dec 2020 13:19:32 -0500
Received: from mail.kernel.org ([198.145.29.99]:49972 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1730231AbgLHSTc (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 8 Dec 2020 13:19:32 -0500
Date:   Tue, 8 Dec 2020 10:18:49 -0800
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=k20201202; t=1607451531;
        bh=rbe/rLwaT+iw+/a/kAhtCx9Bs+M3BMplKpLq931S3ik=;
        h=From:To:Cc:Subject:In-Reply-To:References:From;
        b=GYeuq0TVNdvP60qxpoB8pa6y7uf4ONnRgH/64Q80F7jlM8+qeUsJC84qjSdjV1/JY
         oicbiju9CG5bAGD++JD2DmXF3lCu8fgWwCfyWELsjRR0f0AsY3dH+CoXo/DuSbj5EY
         lXdXDInTQDZfUF0A83qPGyzivhowMA7xSLK7k6X7hCKFVL6U5Hj6B3gqMaiFTA7LJ4
         5kS8tDbsoWi/biWaj+W939ZAXyG5N7Fl9PCy15PoBg4Vvr2XTzRbr+7cptZ4cpfoc1
         KfpUsNhbT6xXNK4GWjJX7HGKzFJen9oBlCO9UoBFGn43io87nvV7HEuvKnrB9BzmVT
         xBFJfbcCbyDhg==
From:   Jakub Kicinski <kuba@kernel.org>
To:     Mario Limonciello <Mario.Limonciello@dell.com>
Cc:     Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org,
        David Miller <davem@davemloft.net>,
        linux-kernel@vger.kernel.org, Linux PM <linux-pm@vger.kernel.org>,
        Netdev <netdev@vger.kernel.org>,
        Alexander Duyck <alexander.duyck@gmail.com>,
        Sasha Netfin <sasha.neftin@intel.com>,
        Aaron Brown <aaron.f.brown@intel.com>,
        Stefan Assmann <sassmann@redhat.com>, darcari@redhat.com,
        Yijun.Shen@dell.com, Perry.Yuan@dell.com,
        anthony.wong@canonical.com,
        Vitaly Lifshits <vitaly.lifshits@intel.com>
Subject: Re: [PATCH v3 1/7] e1000e: fix S0ix flow to allow S0i3.2 subset
 entry
Message-ID: <20201208101849.5a17b469@kicinski-fedora-pc1c0hjn.DHCP.thefacebook.com>
In-Reply-To: <354075ae-f605-eb01-4cf9-a66e4eb7b192@dell.com>
References: <20201204200920.133780-1-mario.limonciello@dell.com>
        <20201204200920.133780-2-mario.limonciello@dell.com>
        <354075ae-f605-eb01-4cf9-a66e4eb7b192@dell.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 8 Dec 2020 11:24:17 -0600 Mario Limonciello wrote:
> On 12/4/20 2:09 PM, Mario Limonciello wrote:
> > From: Vitaly Lifshits <vitaly.lifshits@intel.com>
> >
> > Changed a configuration in the flows to align with
> > architecture requirements to achieve S0i3.2 substate.
> >
> > Also fixed a typo in the previous commit 632fbd5eb5b0
> > ("e1000e: fix S0ix flows for cable connected case").
> >
> > Signed-off-by: Vitaly Lifshits <vitaly.lifshits@intel.com>
> > Tested-by: Aaron Brown <aaron.f.brown@intel.com>
> > Signed-off-by: Tony Nguyen <anthony.l.nguyen@intel.com>
> > ---
> >   drivers/net/ethernet/intel/e1000e/netdev.c | 8 ++++----
> >   1 file changed, 4 insertions(+), 4 deletions(-) =20
>=20
> I realize that the series is still under discussion, but I intentionally=
=20
> moved this
> patch to the front of the series so it can be pulled in even if the=20
> others are still
> discussed.
>=20
> @David Miller:
> This particular patch is more important than the rest.=C2=A0 It actually=
=20
> fixes issues
> on the non-ME i219V as well.=C2=A0 Can this one be queued up and we can k=
eep
> discussing the rest?

Not sure Dave will notice this discussion, best if you repost this patch
separately. If it's a fix that should be backported to stable make sure
you add a Fixes tag.
