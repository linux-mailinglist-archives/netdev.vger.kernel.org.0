Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id AD0743144C2
	for <lists+netdev@lfdr.de>; Tue,  9 Feb 2021 01:17:52 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S230063AbhBIARG (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Feb 2021 19:17:06 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56076 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S229526AbhBIARD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Feb 2021 19:17:03 -0500
Received: from mail-qv1-xf30.google.com (mail-qv1-xf30.google.com [IPv6:2607:f8b0:4864:20::f30])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id A8A17C061786;
        Mon,  8 Feb 2021 16:16:22 -0800 (PST)
Received: by mail-qv1-xf30.google.com with SMTP id es14so7895521qvb.3;
        Mon, 08 Feb 2021 16:16:22 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:mail-followup-to:references
         :mime-version:content-disposition:in-reply-to;
        bh=+8DFoL2EGSgg/sJHZEF0UfDorvx2ns9yfYdINvaslqw=;
        b=FhbkDxAjgvswwKsnbNXbwAW5btltZszOAwno23bs1Vzlx9BX4q6XP6erkz5Qi+a0bF
         mtQP2rND1gx2GByhLCsHQzFHFbtddjDCz0GN8a5thWAu+YwnT/PmKGKvhp77Aq7lBv4u
         u8zDIIMEWB2vdvf60A3ipfIlXc4ybH/8xZMymTn0gQ8jLyXLQAld0FCRfKPedzvSvR9C
         jHFOFD7jduyzrJcAjTB9ZX5kRG3xMLQ995coTvoebji9GJ9MaJEzrMblBRBQBt0+tu44
         08TTxOLgJGuY4A73ogtQFZA2kqNo2t08xBztPOMy1vBOjX/YWPdIWmtww7aXN6mGwOzb
         WCMw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id
         :mail-followup-to:references:mime-version:content-disposition
         :in-reply-to;
        bh=+8DFoL2EGSgg/sJHZEF0UfDorvx2ns9yfYdINvaslqw=;
        b=Si6JC1uhEeajBRFNzalleW8r2u9UpZtL0JCRtDmLSvpxKFloPt/DVQDHq+K22/XhD8
         6+BAeftrfdBleTgFR0Fa04R0O97S8smfQJ8USXnyFWjc8sQk1vXhmNjO50407BcYRIZu
         lIpxUPohFWA8uQeHZ+qPpsLjoHmJ0cvzzdwYK1C6ZJRib5syu0QNoCGsrxIsL6lglEHg
         arsqnqzJftCqfvW7UNLzck4oiIK4Yjb85qa9/FQXMOMj7aOUZt0zgovixsXBIoxqpPsc
         5eiGyY98ncZmmtIuRS2YhKji8oyYehH9aWxdO8zrHcyMM20YqdNZNAbQT8h5NSRgdvI7
         2amQ==
X-Gm-Message-State: AOAM531TxwaE1jRJP5+QOYrrTqRCP6xXLyKEZ9XZzst+XnGP4wdTDtIG
        M8UtTRE6H4aK9zJdr88pGwqx7LWA/GpKAvDC
X-Google-Smtp-Source: ABdhPJwTBxaDdWBhxnCzV3taXe6XWPA4AbMsXQicbAixsexK0BjZUeSmmK7jB0dNEKtdsmSDZAiyoA==
X-Received: by 2002:ad4:4ba6:: with SMTP id i6mr2725133qvw.50.1612829781910;
        Mon, 08 Feb 2021 16:16:21 -0800 (PST)
Received: from ArchLinux ([143.244.44.203])
        by smtp.gmail.com with ESMTPSA id 138sm17719328qkh.7.2021.02.08.16.16.17
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 08 Feb 2021 16:16:20 -0800 (PST)
Date:   Tue, 9 Feb 2021 05:46:12 +0530
From:   Bhaskar Chowdhury <unixbhaskar@gmail.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Edward Cree <ecree.xilinx@gmail.com>, davem@davemloft.net,
        rppt@kernel.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
Subject: Re: [PATCH] drivers: net: ethernet: sun: Fix couple of spells in the
 file sunhme.c
Message-ID: <YCHUTNQNqIzDhkH2@ArchLinux>
Mail-Followup-To: Bhaskar Chowdhury <unixbhaskar@gmail.com>,
        Jakub Kicinski <kuba@kernel.org>,
        Edward Cree <ecree.xilinx@gmail.com>, davem@davemloft.net,
        rppt@kernel.org, akpm@linux-foundation.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, rdunlap@infradead.org
References: <20210205124741.1397457-1-unixbhaskar@gmail.com>
 <4134afc4-31d6-1b49-9b73-195a6d559953@gmail.com>
 <20210208100427.4708e1e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: multipart/signed; micalg=pgp-sha256;
        protocol="application/pgp-signature"; boundary="jNB3eq/8J+nDvh4w"
Content-Disposition: inline
In-Reply-To: <20210208100427.4708e1e0@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org


--jNB3eq/8J+nDvh4w
Content-Type: text/plain; charset=us-ascii; format=flowed
Content-Disposition: inline

On 10:04 Mon 08 Feb 2021, Jakub Kicinski wrote:
>On Mon, 8 Feb 2021 15:00:01 +0000 Edward Cree wrote:
>> On 05/02/2021 12:47, Bhaskar Chowdhury wrote:
>> >
>> >
>> > s/fuck/mess/
>> > s/fucking/soooo/
>> >
>> > Signed-off-by: Bhaskar Chowdhury <unixbhaskar@gmail.com>
>>
>> Right or wrong, these are not "spelling fixes".
>> Please do not misrepresent your patch in your Subject: line.
>> (Also, subsystem prefix should probably just be "net: sunhme:".)
>
>I think Steven already explained on the printf patch that the "obscene"
>language rules apply to new code only, so I marked this as Rejected
>silently.

Alright! Accepted.

--jNB3eq/8J+nDvh4w
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAABCAAdFiEEnwF+nWawchZUPOuwsjqdtxFLKRUFAmAh1EkACgkQsjqdtxFL
KRWajwgAht/6bncoSkqaKPFyGEVSrbUYSSgCqt17fq+WVn3pPAqb0IVSnmwntsa1
RnMxNHuJ+zzeTi06QjbrBB7IiqhhyNIXghJVv8D3RHfD+IfkLo/24OTjL/yFZmIg
pDVfBmZb6xB5202bNmclsXNTYyJSt5or4nIM67LTGhSTjzj1zLSY6n3Tj2/HIXUq
vMdCQK5MR9jOtmwcR9RyKBZFwoSS+DXMwKni/ER+DdUidcg+qqtkWC8aAnmKbdxh
dZVNLoFyl4r0nNaQjrjXq5P1nPmD5wADdIvUlHaA9BHVIQaW1PHfaK2gYdXGNAZc
dKuPYbhQIMnIH72nJeGJaRMxFSxESg==
=1TKW
-----END PGP SIGNATURE-----

--jNB3eq/8J+nDvh4w--
