Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 28E2E344EB9
	for <lists+netdev@lfdr.de>; Mon, 22 Mar 2021 19:42:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S232224AbhCVSm2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Mar 2021 14:42:28 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:47650 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S231965AbhCVSmF (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Mar 2021 14:42:05 -0400
Received: from wp003.webpack.hosteurope.de (wp003.webpack.hosteurope.de [IPv6:2a01:488:42:1000:50ed:840a::])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 604D1C061574
        for <netdev@vger.kernel.org>; Mon, 22 Mar 2021 11:42:03 -0700 (PDT)
Received: from p548da928.dip0.t-ipconnect.de ([84.141.169.40] helo=kmk0); authenticated
        by wp003.webpack.hosteurope.de running ExIM with esmtpsa (TLS1.3:ECDHE_RSA_AES_256_GCM_SHA384:256)
        id 1lOPV0-0001l9-OK; Mon, 22 Mar 2021 19:41:58 +0100
From:   Kurt Kanzenbach <kurt@kmk-computers.de>
To:     Andrew Lunn <andrew@lunn.ch>
Cc:     Vivien Didelot <vivien.didelot@gmail.com>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Vladimir Oltean <olteanv@gmail.com>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>, netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: hellcreek: Report switch name and ID
In-Reply-To: <YFYFLiwnXBeXhqgj@lunn.ch>
References: <20210320112715.8667-1-kurt@kmk-computers.de>
 <YFYFLiwnXBeXhqgj@lunn.ch>
Date:   Mon, 22 Mar 2021 19:41:23 +0100
Message-ID: <8735wnf2uk.fsf@kmk-computers.de>
MIME-Version: 1.0
Content-Type: multipart/signed; boundary="=-=-=";
        micalg=pgp-sha256; protocol="application/pgp-signature"
X-bounce-key: webpack.hosteurope.de;kurt@kmk-computers.de;1616438523;7ca61be6;
X-HE-SMSGID: 1lOPV0-0001l9-OK
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

--=-=-=
Content-Type: text/plain

On Sat Mar 20 2021, Andrew Lunn wrote:
>> +static int hellcreek_devlink_info_get(struct dsa_switch *ds,
>> +				      struct devlink_info_req *req,
>> +				      struct netlink_ext_ack *extack)
>> +{
>> +	struct hellcreek *hellcreek = ds->priv;
>> +	int ret;
>> +
>> +	ret = devlink_info_driver_name_put(req, "hellcreek");
>> +	if (ret)
>> +		return ret;
>> +
>> +	return devlink_info_version_fixed_put(req,
>> +					      DEVLINK_INFO_VERSION_GENERIC_ASIC_ID,
>> +					      hellcreek->pdata->name);
>
>>  static const struct hellcreek_platform_data de1soc_r1_pdata = {
>> +	.name		 = "Hellcreek r4c30",
>
> Hi Kurt
>
> The two other DSA drivers which implement this keep the
> DEVLINK_INFO_VERSION_GENERIC_ASIC_ID just the model name, mv88e6390,
> SJA1105E for example. You have hellcreek in the driver name, so i
> don't see a need to repeat it.

I see, makes sense.

Thanks,
Kurt

--=-=-=
Content-Type: application/pgp-signature; name="signature.asc"

-----BEGIN PGP SIGNATURE-----

iQJKBAEBCAA0FiEEiQLjxJIQcNxwU7Bj249qgr3OILkFAmBY5NMWHGt1cnRAa21r
LWNvbXB1dGVycy5kZQAKCRDbj2qCvc4guaBjD/0Z9P7MqDVjj6OdPlkCdiPRrjDD
4cnSmtnGJ+q6cKGzeOl+8pnEtNwOfBGMIArAWM34yGRTJoA6tdeKGhFVRvBpwU2V
Z4BrTqafKMkDZBZ6bdLXf2+bxxRmbBgbDT2mX5votO0HVOEWftllpNKrYxnMxA+T
QSaLZKSD+zraNwdSlhkOapbyyVGROYNWGRVCPJOOnJD849GQclbiv6b8PPGVs+SM
muJ/Sl6yvbsPvaWH0YDiN1uEfK3vmUUQ/RkRRZbYcK8BmBY3lHY34tdd2BiL/nBP
Er2zB+ZDLHrTl3zVvaBaL+TNmSuqLp9MzZvEh4MRmO7Ag1hTYjnAN9CqMccnE2Pu
ImTDx/4I+6BlTnxFqADMVhwoRolOmzSXQsuaXqCRjUHZst8ZNkIj1I6SV2LVuUHE
umwzjz5rSyaK+rcmrn3/8GF0jPNrKEc4osRvrKu4AvG/U//RjDPTeyOcEmWZe6Tp
MNNSrIMRsSnh9lyRhy94/pR6imAzRYcLfJr+gR2NstlHQ4GqqZXrfuBRRJGsHJvF
Nj0kcNdM5bClRcVhEMRjlxYzyMoXcI37OqhJinya49XHIcGRAGD+Emui08btMues
q8RDIrb1C/KfVKQnshOs1cLlP/WUsj/8ENsUShUAox0goB4P6CmkeY4M4g6SIlxl
3+bJoR5jnJ8CHp25iw==
=7BXf
-----END PGP SIGNATURE-----
--=-=-=--
