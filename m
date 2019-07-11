Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 15BC7652AA
	for <lists+netdev@lfdr.de>; Thu, 11 Jul 2019 09:54:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727796AbfGKHyN (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 11 Jul 2019 03:54:13 -0400
Received: from mail-wr1-f46.google.com ([209.85.221.46]:41837 "EHLO
        mail-wr1-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727680AbfGKHyN (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 11 Jul 2019 03:54:13 -0400
Received: by mail-wr1-f46.google.com with SMTP id c2so1942400wrm.8
        for <netdev@vger.kernel.org>; Thu, 11 Jul 2019 00:54:11 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=BPo3cjK8npmVh8660eyrorDvp4DwLTr07MhxaF7Dxhk=;
        b=cRDJ5LGXnxx6pyVv0WIOgsX68cAwfFvigUEOz+9UV1az05bGRz5sgMEhx1uXWomtq2
         NzgP58FDnYn7x6D8ZXqgRKG5LUSATovb8V6Ytq2vHUlLMTWj/za1B55okkchfhd5Cb+C
         qmMQahEU/LWCWcpIKTmgT//RNXoAq2Hg30D+wkj+ycvRMGjyBBnjYS3tKx/5LvgYDXiw
         s+I/MfSmh6CA1v4AsH0s4oqb6bSD96gLMKdNKYVojyK6lpjYu//h0hiYMeL6c6JQoXRh
         5MQHyxPHUq/5/b9f5YNTU80D51zy07DujpIQOjOS4KVeG5xqHB8toVPkkIxLuSiQSDRE
         X8hg==
X-Gm-Message-State: APjAAAV9EY3pmROzKETSiHrr+u26s+0mL5bVqK5OMFa7SWpiFR6ZlNp5
        A96CkASuQxCTZZ7TuDrm/O68XQ==
X-Google-Smtp-Source: APXvYqyFjCvf7o5WACFYuKytGb0wjEIgDQ0JHvOcd+UfkX4WLBbEChz6kCIXho4piQbskbajiDUsGw==
X-Received: by 2002:adf:fe4f:: with SMTP id m15mr3206088wrs.36.1562831651108;
        Thu, 11 Jul 2019 00:54:11 -0700 (PDT)
Received: from localhost.localdomain (nat-pool-mxp-t.redhat.com. [149.6.153.186])
        by smtp.gmail.com with ESMTPSA id 2sm5575734wrn.29.2019.07.11.00.54.07
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 11 Jul 2019 00:54:07 -0700 (PDT)
Date:   Thu, 11 Jul 2019 09:54:05 +0200
From:   Lorenzo Bianconi <lorenzo.bianconi@redhat.com>
To:     David Ahern <dsahern@gmail.com>
Cc:     Marek Majkowski <marek@cloudflare.com>,
        David Miller <davem@davemloft.net>, netdev@vger.kernel.org,
        kernel-team <kernel-team@cloudflare.com>
Subject: Re: NEIGH: BUG, double timer add, state is 8
Message-ID: <20190711075405.GA3452@localhost.localdomain>
References: <CAJPywTJWQ9ACrp0naDn0gikU4P5-xGcGrZ6ZOKUeeC3S-k9+MA@mail.gmail.com>
 <1f4be489-4369-01d1-41c6-1406006df9c5@gmail.com>
 <20190705173011.GA2882@localhost.localdomain>
 <c383ea93-4257-f31c-e259-f71169f7baef@gmail.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="9jxsPFA5p3P2qPhR"
Content-Disposition: inline
In-Reply-To: <c383ea93-4257-f31c-e259-f71169f7baef@gmail.com>
User-Agent: Mutt/1.12.0 (2019-05-25)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--9jxsPFA5p3P2qPhR
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: quoted-printable

> On 7/5/19 11:30 AM, Lorenzo Bianconi wrote:
> > looking at the reproducer it seems to me the issue is due to the use of
> > 'NTF_USE' from userspace.
> > Should we unschedule the neigh timer if we are in IN_TIMER receiving th=
is
> > flag from userspace? (taking appropriate locking)
>=20
> I think you are right. Do you want to send a patch?

Hi David,

thx for the feedback. Sure, I will post a patch soon.

Regards,
Lorenzo

--9jxsPFA5p3P2qPhR
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iHUEABYIAB0WIQTquNwa3Txd3rGGn7Y6cBh0uS2trAUCXSbrGgAKCRA6cBh0uS2t
rDomAQCxowJawzHH4smVKHtOQCJd/QOK+inbIIcFlO1+d/yccwD+ONQGOgGACMKr
zFbZIkpOK+9ELqQ+snsSXmW/FLvjVww=
=sSVo
-----END PGP SIGNATURE-----

--9jxsPFA5p3P2qPhR--
