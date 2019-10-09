Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E6954D05C0
	for <lists+netdev@lfdr.de>; Wed,  9 Oct 2019 05:01:48 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1730026AbfJIDBk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Oct 2019 23:01:40 -0400
Received: from mail-pf1-f194.google.com ([209.85.210.194]:45865 "EHLO
        mail-pf1-f194.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726109AbfJIDBk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Oct 2019 23:01:40 -0400
Received: by mail-pf1-f194.google.com with SMTP id y72so610042pfb.12;
        Tue, 08 Oct 2019 20:01:39 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:subject:to:cc:references:from:autocrypt
         :message-id:date:user-agent:mime-version:in-reply-to;
        bh=S7QLYAiYMoh1m0ZCXLjV7cfkEVQU+Yf86q0eubmHeEg=;
        b=QHYsOCCE7Cl1og8BtSPHCqmk257HJBFW26qEIxbM4NG66gqQosPSPh6V1Gma9RcABq
         SY8guJd4AZ9PQQPRmarH6Jni/AvFgozZbEB89d0Noo5pSlD8j4yxDfEergOv61i39y2R
         /NZ60INTRzz81iuvyWsLmo09MhvOuwt1SR8LJ/RZ9VtbQZCXi2eNrpmnhFUPFdru1ZX4
         2EhigJglwjUaVKnGp57k7pWj0Ye/2VidpfgZ1bszCM1h5Tubm3vLrrutGaATFJS7X/No
         IBhnIKnN0u183S5n3KQ/IYg9f+CDao9cVPRyKf/FeNOOZo3KIK4j4O+5ahnb46QfhyFb
         dtiQ==
X-Gm-Message-State: APjAAAXkWVwac1awpXEZmYCWw2Nm02JDmm3zVltdWC8ZgzVoFGt8ifSH
        FX5B9hdHCiQ0VKZ8SKUrnlpJ0EMwMPU=
X-Google-Smtp-Source: APXvYqwbOdu45NBlYeCnB8/NnmR3zaoI3kFo/h5ig04SdQhsNZQu806TFtX1Dpqo+S90x0LstxMSsQ==
X-Received: by 2002:a65:4907:: with SMTP id p7mr1880351pgs.429.1570590098399;
        Tue, 08 Oct 2019 20:01:38 -0700 (PDT)
Received: from [10.101.46.68] (61-220-137-37.HINET-IP.hinet.net. [61.220.137.37])
        by smtp.gmail.com with ESMTPSA id 199sm446022pfv.152.2019.10.08.20.01.34
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Oct 2019 20:01:37 -0700 (PDT)
Subject: Re: [PATCH] iwlwifi: fw: don't send GEO_TX_POWER_LIMIT command to FW
 version 29
To:     Luciano Coelho <luciano.coelho@intel.com>
Cc:     Johannes Berg <johannes.berg@intel.com>,
        Emmanuel Grumbach <emmanuel.grumbach@intel.com>,
        Intel Linux Wireless <linuxwifi@intel.com>,
        Kalle Valo <kvalo@codeaurora.org>,
        "David S . Miller" <davem@davemloft.net>,
        Shahar S Matityahu <shahar.s.matityahu@intel.com>,
        Sara Sharon <sara.sharon@intel.com>,
        Gil Adam <gil.adam@intel.com>,
        Mordechay Goodstein <mordechay.goodstein@intel.com>,
        Haim Dreyfuss <haim.dreyfuss@intel.com>,
        linux-wireless@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
References: <20191008060511.18474-1-vicamo.yang@canonical.com>
 <b1c63efd883452ccb5e57e107c6a0aa74bf25d49.camel@intel.com>
From:   You-Sheng Yang <vicamo.yang@canonical.com>
Autocrypt: addr=vicamo.yang@canonical.com; keydata=
 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
 suzL+d2CSm1cCUYQeOxX/7MpmAIm
Message-ID: <55bac139-3b89-dbe0-fe2a-b919d60e86e3@canonical.com>
Date:   Wed, 9 Oct 2019 11:01:25 +0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <b1c63efd883452ccb5e57e107c6a0aa74bf25d49.camel@intel.com>
Content-Type: multipart/signed; micalg=pgp-sha512;
 protocol="application/pgp-signature";
 boundary="VtZyD2COvFqC4vCS2LLGN8erGJGF1TwXW"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

This is an OpenPGP/MIME signed message (RFC 4880 and 3156)
--VtZyD2COvFqC4vCS2LLGN8erGJGF1TwXW
Content-Type: multipart/mixed; boundary="kVlcLqGwnVfaqzBUShtMDphOVR2H8OARz"

--kVlcLqGwnVfaqzBUShtMDphOVR2H8OARz
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: quoted-printable

Tested and commented on the issue page. Thank you for the correction.

--
Cheers,
You-Sheng Yang

On 2019-10-08 15:17, Luciano Coelho wrote:
> On Tue, 2019-10-08 at 14:05 +0800, You-Sheng Yang wrote:
>> Follow-up for commit fddbfeece9c7 ("iwlwifi: fw: don't send
>> GEO_TX_POWER_LIMIT command to FW version 36"). There is no
>> GEO_TX_POWER_LIMIT command support for all revisions of FW version
>> 29, either.
>>
>> Bugzilla: https://bugzilla.kernel.org/show_bug.cgi?id=3D204151
>> Signed-off-by: You-Sheng Yang <vicamo.yang@canonical.com>
>> ---
>>  drivers/net/wireless/intel/iwlwifi/mvm/fw.c | 6 +++---
>>  1 file changed, 3 insertions(+), 3 deletions(-)
>>
>> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c b/drivers/net=
/wireless/intel/iwlwifi/mvm/fw.c
>> index 32a5e4e5461f..dbba616c19de 100644
>> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
>> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
>> @@ -889,14 +889,14 @@ static bool iwl_mvm_sar_geo_support(struct iwl_m=
vm *mvm)
>>  	 * firmware versions.  Unfortunately, we don't have a TLV API
>>  	 * flag to rely on, so rely on the major version which is in
>>  	 * the first byte of ucode_ver.  This was implemented
>> -	 * initially on version 38 and then backported to29 and 17.
>> +	 * initially on version 38 and then backported to 29 and 17.
>>  	 * The intention was to have it in 36 as well, but not all
>>  	 * 8000 family got this feature enabled.  The 8000 family is
>>  	 * the only one using version 36, so skip this version
>> -	 * entirely.
>> +	 * entirely. All revisions of -29 fw still don't have
>> +	 * GEO_TX_POWER_LIMIT supported yet.
>>  	 */
>>  	return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >=3D 38 ||
>> -	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 29 ||
>>  	       IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 17;
>>  }
>=20
> Thanks for the patch!
>=20
> But I have investigated this (even) further and now I see that 3168
> doesn't have this command, but 7265D does.  The latter also uses -29,
> so we can't blindly disable all -29 versions.
>=20
> Can you try this instead?
>=20
> diff --git a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> index 0d2229319261..38d89ee9bd28 100644
> --- a/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> +++ b/drivers/net/wireless/intel/iwlwifi/mvm/fw.c
> @@ -906,8 +906,10 @@ static bool iwl_mvm_sar_geo_support(struct iwl_mvm=

> *mvm)
>          * entirely.
>          */
>         return IWL_UCODE_SERIAL(mvm->fw->ucode_ver) >=3D 38 ||
> -              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 29 ||
> -              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 17;
> +              IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 17 ||
> +              (IWL_UCODE_SERIAL(mvm->fw->ucode_ver) =3D=3D 29 &&
> +               (mvm->trans->hw_rev &
> +                CSR_HW_REV_TYPE_MSK) =3D=3D CSR_HW_REV_TYPE_7265D);
>  }
> =20
>  int iwl_mvm_get_sar_geo_profile(struct iwl_mvm *mvm)
>=20
>=20
> --
> Cheers,
> Luca.
>=20


--kVlcLqGwnVfaqzBUShtMDphOVR2H8OARz--

--VtZyD2COvFqC4vCS2LLGN8erGJGF1TwXW
Content-Type: application/pgp-signature; name="signature.asc"
Content-Description: OpenPGP digital signature
Content-Disposition: attachment; filename="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQEzBAEBCgAdFiEEVhtdp+wXuXuqVL95S6BJ+2O0nE8FAl2dTY0ACgkQS6BJ+2O0
nE8XDgf/Rr289Xvy75xhciC7VyJTWuSq3z+qgau9ZhxQOj/YkCyN0momL79s2uvw
HldTwc4uqO52kdSvo/S5SFf4ZkDsbHCc7vXvaNzNLw7JZUyo8F5CeSkR3QvW3Vk5
mCXsrzLnY6wmvJGx5WjuVLoCjEAFmjIhjo27dFx4uAs2gOgMB52mYqz4P6DBoF6x
cm6wqVyy2baSe8Y4ndjy4I4aJ48LfljNfEBFSt/kPE59lVdetyo/NHcSnTCT67c+
P3lZ0p7+Qg6UtrbgJClSqrXVkH0R6VB9AM3zECNhvop5g0CxC7wmA6Bh5VmslUIB
Lxuf2d0t7lloN0dzHAeV+hum2Pg6EA==
=QQpd
-----END PGP SIGNATURE-----

--VtZyD2COvFqC4vCS2LLGN8erGJGF1TwXW--
