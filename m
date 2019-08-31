Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 347B4A4598
	for <lists+netdev@lfdr.de>; Sat, 31 Aug 2019 19:27:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728461AbfHaR1l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sat, 31 Aug 2019 13:27:41 -0400
Received: from mout.web.de ([212.227.17.11]:39731 "EHLO mout.web.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728274AbfHaR1l (ORCPT <rfc822;netdev@vger.kernel.org>);
        Sat, 31 Aug 2019 13:27:41 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=web.de;
        s=dbaedf251592; t=1567272409;
        bh=yQM2//yRNIKgrYfmnX/+7v7UH1bRgtDE8fxceDLJw/k=;
        h=X-UI-Sender-Class:Subject:To:Cc:References:From:Date:In-Reply-To;
        b=UkIS6ScHG/qq282SfeEUAdUONVKFj7prfUF8eSqrnN6DyDK62xc7SzB7c22BXhpGw
         hoAB7QU4wg2CRz7ANop+2kDZdkkyohT4GldaiAJC0qt8G6QJIe9Ju0HE2CsyUUkY86
         QdEM6a9xRIS9MNZmavk+JdGCFC49nUa0AncAvJlU=
X-UI-Sender-Class: c548c8c5-30a9-4db5-a2e7-cb6cb037b8f9
Received: from [192.168.1.2] ([93.132.129.60]) by smtp.web.de (mrweb101
 [213.165.67.124]) with ESMTPSA (Nemesis) id 0LnB1F-1igkgH456r-00hR0L; Sat, 31
 Aug 2019 19:26:49 +0200
Subject: Re: [PATCH v3 01/11] checkpatch: check for nested (un)?likely() calls
To:     Denis Efremov <efremov@linux.com>, Joe Perches <joe@perches.com>
Cc:     Andrew Morton <akpm@linux-foundation.org>,
        Anton Altaparmakov <anton@tuxera.com>,
        Andy Whitcroft <apw@canonical.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Boris Pismenny <borisp@mellanox.com>,
        "Darrick J. Wong" <darrick.wong@oracle.com>,
        "David S. Miller" <davem@davemloft.net>,
        Dennis Dalessandro <dennis.dalessandro@intel.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        dri-devel@lists.freedesktop.org,
        Inaky Perez-Gonzalez <inaky.perez-gonzalez@intel.com>,
        =?UTF-8?B?SsO8cmdlbiBHcm/Dnw==?= <jgross@suse.com>,
        Leon Romanovsky <leon@kernel.org>,
        linux-arm-msm@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-input@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-ntfs-dev@lists.sourceforge.net, linux-rdma@vger.kernel.org,
        linux-wimax@intel.com, linux-xfs@vger.kernel.org,
        Mike Marciniszyn <mike.marciniszyn@intel.com>,
        netdev@vger.kernel.org,
        =?UTF-8?Q?Pali_Roh=c3=a1r?= <pali.rohar@gmail.com>,
        Rob Clark <robdclark@gmail.com>,
        Saeed Mahameed <saeedm@mellanox.com>,
        Sean Paul <sean@poorly.run>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        xen-devel@lists.xenproject.org, Enrico Weigelt <lkml@metux.net>
References: <20190829165025.15750-1-efremov@linux.com>
 <0d9345ed-f16a-de0b-6125-1f663765eb46@web.de>
 <689c8baf-2298-f086-3461-5cd1cdd191c6@linux.com>
 <493a7377-2de9-1d44-cd8f-c658793d15db@web.de>
 <c5e4479d-2fb3-b5a5-00c3-b06e5177d869@linux.com>
From:   Markus Elfring <Markus.Elfring@web.de>
Autocrypt: addr=Markus.Elfring@web.de; prefer-encrypt=mutual; keydata=
 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 FEE=
Message-ID: <9de9fb8f-f13f-e9bb-c68d-0ba81010ae8b@web.de>
Date:   Sat, 31 Aug 2019 19:26:41 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.0
MIME-Version: 1.0
In-Reply-To: <c5e4479d-2fb3-b5a5-00c3-b06e5177d869@linux.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable
X-Provags-ID: V03:K1:Mb7grKXZ9pH+xlAXEQYPZYdNH7QN+E5OessgUl8uganJH5/1n3T
 faLtS9zrYMJ4tIvgnpUrhBwevqlLRu+WYUkqulrjatf/4Qkg3CHTrYI4KoDABcY7W0k2oNC
 45f3xjVsLioWf+xVr2GDUCLyytlCv1ng76ThWmrQYq56NZnwNTIvNq0PEAQm8/i4TXitEj+
 /ahFCq9RdntQV/9iWiPBA==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:qA2Afq3R9eE=:n56im/5XNmQSDU2whUsHZT
 JWxDOApUGiKyz+lhjRCHIfdg4n0FKbD6eqTLxIPtjRb7kqw+GdR5Gv5HaWC/LWRUri4LThy+e
 R14XMuFDdorTGQuJBlsEMRxbKEASNug2Z3mLBGScwQjiIyCgxf+lBQWEqYGZ3A+lirGuIRbPu
 lZueDm2OGgCWAI0pjQ9w0ncov1kxFrnNeCEJyUqtIniUjPK0PgybSPUASNFovplN5hkw34Ryo
 9UfbuVi7t171/ELkZs8lFG+8GHSq7udxuZLeDbzA1W3/9N8yyK4+NNEAGpLv3LDzZS33Q8r+b
 W53gtgzOiyeQJ/EQi/ZBR+RyOUDgC+cCgP4kk/Di9Zy22MYWVk4uwcWXYwZqwECE5zzivzt3O
 hMlR79MpYmgHsx1ZqYe5V7d/1J4X3QZDWxW6vVTQlu2a21n3NbPLANxvYjF6AppsWzPexPw4j
 pWbGoL8EQt09JDSb3HfmMwMnTcf2mN//SGzWrL39C2/Mn4mdePFg7YvGF3AY7P519jZh05ufI
 bV8Em6ZdVEHVELM02XSgFnrBzrE04EMX4jR0PjtEhK8QVYe/KPrAqX9WM260rTZEnOSHZtVDj
 L3BbuhArM3gfqNE4LGBqnZI4GmblM261L0r8wX3mDcj3gz61zRCUfOuiYMgbQ8C0nTNmey664
 P1QvpGTdR4iz9jWtxfnHkTZP26VBYflRVmvXxLV4j+CtxPB1H9t1aBqGQ4JaPWPIVZiEb87EP
 xFlDb4hVXB6YYEARImPfY0Dy+HQ4xXd1ojwiPe1HogoIEeNgxEBnTdklQH6UhpdZi6u2ijLFX
 X/uqZ5Ykw2+T1MdQEoA18itVy9q6hCDs9z77511E2ofAbiPTIioLIPZwRvJytbDCn/VyrY+t5
 Pt8v45FtuV2I1lxyEy5W7XRSuy0fHp7VcVtumo9NnSqY9it5k+3/h91IkuSy2c8t0qKYjm/38
 6PlXH2g/H9h4MY020bGg1TGmn3U9dehbdt9C94hGi3EWETi55LjjUDEDMF+Mma18lp8Vqz06b
 1PiVySlX5wkjKydt7erUI35M1ofg8Ag6Fx7MZCt9vOZVCgp6BXGB/cNtH5wbXLc5IdbExUyFD
 g5gYSgHm37PMmLyqoGMSAgjjdKfPttXkatanpSMaTKlfG4fU1Q7HP1P1zR1Gv6QeeZy5JTKmc
 CKqZUEQQza7L0tGVd5j/1MNOs3KwC1srew6rgnoI6tqkvyWQ==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>>>>> +# nested likely/unlikely calls
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 if ($line =3D~ /\b(?:(?:=
un)?likely)\s*\(\s*!?\s*(IS_ERR(?:_OR_NULL|_VALUE)?|WARN)/) {
>>>>> +=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0=C2=A0 =
WARN("LIKELY_MISUSE",
=E2=80=A6
>> \b(?:un)?likely\s*
>
> This pair of brackets is required to match "unlikely"
> and it's optional in order to match "likely".

I agree also to this view if you refer to the shortened regular expression=
 here.
But I got an other development opinion for an extra pair of non-capturing =
parentheses
at the front (from the version which you suggested).

Regards,
Markus
