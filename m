Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4EACF2498F5
	for <lists+netdev@lfdr.de>; Wed, 19 Aug 2020 11:01:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726903AbgHSJBo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 19 Aug 2020 05:01:44 -0400
Received: from mail.katalix.com ([3.9.82.81]:51246 "EHLO mail.katalix.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726825AbgHSJBm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 19 Aug 2020 05:01:42 -0400
X-Greylist: delayed 64204 seconds by postgrey-1.27 at vger.kernel.org; Wed, 19 Aug 2020 05:01:41 EDT
Received: from [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539] (unknown [IPv6:2a02:8010:6359:1:551f:34b6:cf72:2539])
        (Authenticated sender: james)
        by mail.katalix.com (Postfix) with ESMTPSA id 9792C86BC6;
        Wed, 19 Aug 2020 10:01:39 +0100 (BST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=katalix.com; s=mail;
        t=1597827699; bh=xd7Y2ZlLA8lOG6u60l9JFIMfqw5gUmTWut8nlZFlgKU=;
        h=Subject:To:Cc:References:From:Message-ID:Date:MIME-Version:
         In-Reply-To:From;
        z=Subject:=20Re:=20[PATCH=20net-next]=20Documentation/networking:=2
         0update=20l2tp=20docs|To:=20Jakub=20Kicinski=20<kuba@kernel.org>|C
         c:=20netdev@vger.kernel.org|References:=20<20200818151135.1943-1-j
         chapman@katalix.com>=0D=0A=20<20200818115700.6a8b05ef@kicinski-fed
         ora-pc1c0hjn.dhcp.thefacebook.com>|From:=20James=20Chapman=20<jcha
         pman@katalix.com>|Message-ID:=20<73712c27-7226-19f3-31be-2d61d2a8b
         c36@katalix.com>|Date:=20Wed,=2019=20Aug=202020=2010:01:39=20+0100
         |MIME-Version:=201.0|In-Reply-To:=20<20200818115700.6a8b05ef@kicin
         ski-fedora-pc1c0hjn.dhcp.thefacebook.com>;
        b=UnAV7oqSuG+qAs9XfpO+L7xDWcmrbCVteIg72DK7rCvmsKesQxHrltP5BS1MQLskm
         AlXDB4FBiBW5H1xWgdbghwnnAbJIGUtJr2NtwnPGjmY14IKf77SFSmISzIqZkcLeS0
         ueyQW858J+aEZz/dpECFK9ALsQg1f3XGDdaVLcxQdRVV5wPY+scKUm5Q+kwM24RQAw
         BTo2ypWjEG6FIzwFWBaCRWz/4RQ0cIPwf/ngDlkbk4mrabEbdM1EML1qpqpTVxxzJd
         lk3LATGe72xGbl6oR3HBFsasWjUq30fMgq7yXxHS5GpMI4Tan/usfcA7yTFu6skd8s
         tnDOakunh2FDA==
Subject: Re: [PATCH net-next] Documentation/networking: update l2tp docs
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     netdev@vger.kernel.org
References: <20200818151135.1943-1-jchapman@katalix.com>
 <20200818115700.6a8b05ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
From:   James Chapman <jchapman@katalix.com>
Autocrypt: addr=jchapman@katalix.com; prefer-encrypt=mutual; keydata=
 xsBNBFDmvq0BCACizu6XvQjeWZ1Mnal/oG9AkCs5Rl3GULpnH0mLvPZhU7oKbgx5MHaFDKVJ
 rQTbNEchbLDN6e5+UD98qa4ebvNx1ZkoOoNxxiuMQGWaLojDKBc9x+baW1CPtX55ikq2LwGr
 0glmtUF6Aolpw6GzDrzZEqH+Nb+L3hNTLBfVP+D1scd4R7w2Nw+BSQXPQYjnOEBDDq4fSWoI
 Cm2E18s3bOHDT9a4ZuB9xLS8ZuYGW6p2SMPFHQb09G82yidgxRIbKsJuOdRTIrQD/Z3mEuT/
 3iZsUFEcUN0T/YBN3a3i0P1uIad7XfdHy95oJTAMyrxnJlnAX3F7YGs80rnrKBLZ8rFfABEB
 AAHNJEphbWVzIENoYXBtYW4gPGpjaGFwbWFuQGthdGFsaXguY29tPsLAeAQTAQIAIgUCUOa+
 rQIbIwYLCQgHAwIGFQgCCQoLBBYCAwECHgECF4AACgkQINzVgFp/OkBr2gf7BA4jmtvUOGOO
 JFsj1fDmbAzyE6Q79H6qnkgYm7QNEw7o+5r7EjaUwsh0w13lNtKNS8g7ZWkiBmSOguJueKph
 GCdyY/KOHZ7NoJw39dTGVZrvJmyLDn/CQN0saRSJZXWtV31ccjfpJGQEn9Gb0Xci0KjrlH1A
 cqxzjwTmBUr4S2EHIzCcini1KTtjbtsE+dKP4zqR/T52SXVoYvqMmJOhUhXh62C0mu8FoDM0
 iFDEy4B0LcGAJt6zXy+YCqz7dOwhZBB4QX4F1N2BLF3Yd1pv8wBBZE7w70ds7rD7pnIaxXEK
 D6yCGrsZrdqAJfAgYL1lqkNffZ6uOSQPFOPod9UiZM7ATQRQ5r6tAQgAyROh3s0PyPx2L2Fb
 jC1mMi4cZSCpeX3zM9aM4aU8P16EDfzBgGv/Sme3JcrYSzIAJqxCvKpR+HoKhPk34HUR/AOk
 16pP3lU0rt6lKel2spD1gpMuCWjAaFs+dPyUAw13py4Y5Ej2ww38iKujHyT586U6skk9xixK
 1aHmGJx7IqqRXHgjb6ikUlx4PJdAUn2duqasQ8axjykIVK5xGwXnva/pnVprPSIKrydNmXUq
 BIDtFQ4Qz1PQVvK93KeCVQpxxisYNFRQ5TL6PtgVtK8uunABFdsRqlsw1Ob0+mD5fidITCIJ
 mYOL8K74RYU4LfhspS4JwT8nmKuJmJVZ5DjY2wARAQABwsBfBBgBAgAJBQJQ5r6tAhsMAAoJ
 ECDc1YBafzpA9CEH/jJ8Ye73Vgm38iMsxNYJ9Do9JvVJzq7TEduqWzAFew8Ft0F9tZAiY0J3
 U2i4vlVWK8Kbnh+44VAKXYzaddLXAxOcZ8YYy+sVfeVoJs3lAH+SuRwt0EplHWvCK5AkUhUN
 jjIvsQoNBVUP3AcswIqNOrtSkbuUkevNMyPtd0GLS9HVOW0e+7nFce7Ow9ahKA3iGg5Re9rD
 UlDluVylCCNnUD8Wxgve4K+thRL9T7kxkr7aX7WJ7A4a8ky+r3Daf7OhGN9S/Z/GMSs0E+1P
 Qm7kZ2e0J6PSfzy9xDtoRXRNigtN2o8DHf/quwckT5T6Z6WiKEaIKdgaXZVhphENThl7lp8=
Organization: Katalix Systems Ltd
Message-ID: <73712c27-7226-19f3-31be-2d61d2a8bc36@katalix.com>
Date:   Wed, 19 Aug 2020 10:01:39 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.10.0
MIME-Version: 1.0
In-Reply-To: <20200818115700.6a8b05ef@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Content-Language: en-US
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 18/08/2020 19:57, Jakub Kicinski wrote:
> On Tue, 18 Aug 2020 16:11:35 +0100 jchapman@katalix.com wrote:
>> From: James Chapman <jchapman@katalix.com>
>>
>> Kernel documentation of L2TP has not been kept up to date and lacks
>> coverage of some L2TP APIs. While addressing this, refactor to improve
>> readability, separating the parts which focus on user APIs and
>> internal implementation into sections.
>>
>> Signed-off-by: James Chapman <jchapman@katalix.com>
> Hi James, checkpatch --strict notices some trailing whitespace here:
>
> ERROR: trailing whitespace
> #301: FILE: Documentation/networking/l2tp.rst:177:
> +PW_TYPE            Y        Sets the pseudowire type. $
>
> ERROR: trailing whitespace
> #348: FILE: Documentation/networking/l2tp.rst:224:
> +CONN_ID            N        Identifies the tunnel id to be queried. Ignored for DUMP requests.    $
>
> total: 2 errors, 0 warnings, 0 checks, 927 lines checked
>
> Could you clean these up?

Ugh, I should have checked this. I'll spin a v2.


