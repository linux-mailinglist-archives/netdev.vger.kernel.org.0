Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 537CA2B140A
	for <lists+netdev@lfdr.de>; Fri, 13 Nov 2020 02:53:11 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726187AbgKMBxE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 20:53:04 -0500
Received: from mail.kernel.org ([198.145.29.99]:47646 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725972AbgKMBxD (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 12 Nov 2020 20:53:03 -0500
Received: from kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com (unknown [163.114.132.4])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id 7304820791;
        Fri, 13 Nov 2020 01:53:02 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1605232383;
        bh=DjyNIg5N1WPSkeeifOBONgzsegthHILogdziWb/Oj0g=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=AF+L0XCv+yA+89tbNvn+RldVj7wJvFdmb4UIMs7SZ1L6Rgr9TBc3xPamdp04iXiBn
         ci3gye+hhJcpbC4y3cARIbDIJy9B2YaxCcVdzrb/bPg/K9Lk00+6D/UPLozPsPDq3a
         tsY70xiRShN7UBTntdo1e/N8f/UVLGAq9WBKwa24=
Date:   Thu, 12 Nov 2020 17:53:01 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Dave Hansen <dave.hansen@intel.com>
Cc:     kernel test robot <lkp@intel.com>,
        Dmytro Shytyi <dmytro@shytyi.net>,
        kuznet <kuznet@ms2.inr.ac.ru>,
        yoshfuji <yoshfuji@linux-ipv6.org>,
        liuhangbin <liuhangbin@gmail.com>, davem <davem@davemloft.net>,
        netdev <netdev@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        kbuild-all@lists.01.org
Subject: Re: [PATCH net-next] net: Variable SLAAC: SLAAC with prefixes of
 arbitrary length in PIO
Message-ID: <20201112175301.481f80c2@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
In-Reply-To: <8b05710f-5718-986d-659c-916e2b85c892@intel.com>
References: <175b3433a4c.aea7c06513321.4158329434310691736@shytyi.net>
        <202011110944.7zNVZmvB-lkp@intel.com>
        <20201112162423.6b4de8d1@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
        <8b05710f-5718-986d-659c-916e2b85c892@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 12 Nov 2020 17:43:56 -0800 Dave Hansen wrote:
> On 11/12/20 4:24 PM, Jakub Kicinski wrote:
> > On Wed, 11 Nov 2020 09:34:24 +0800 kernel test robot wrote: =20
> >> If you fix the issue, kindly add following tag as appropriate
> >> Reported-by: kernel test robot <lkp@intel.com> =20
> > Good people of kernel test robot, could you please rephrase this to say
> > that the tag is only appropriate if someone is sending a fix up/follow
> > up patch?
> >=20
> > Folks keep adding those tags on the next revisions of the their patches
> > which is quite misleading. =20
>=20
> I think it's still fair for the lkp folks to get *some* credit for
> reporting these bugs.=C2=A0 I mean, the stated reason[1] for it existing =
is:
>=20
> 	The Reported-by tag gives credit to people who find bugs and
> 	report them and it hopefully inspires them to help us again in
> 	the future.
>=20
> I do agree, though, that it's confusing *what* they reported, especially
> if the patch in question is fixing something *else*.  Rather than invent
> a new tag, maybe a comment would suffice:
>=20
> Reported-by: kernel test robot <lkp@intel.com> # bug in earlier revision

Fine by me, although its not common to add Reported-by tags for people
who point out issues in review, so why add a tag for the bot?
