Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D083261A95
	for <lists+netdev@lfdr.de>; Tue,  8 Sep 2020 20:37:53 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731461AbgIHSgq (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 8 Sep 2020 14:36:46 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:56092 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1731348AbgIHQJH (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 8 Sep 2020 12:09:07 -0400
Received: from mail-wr1-x441.google.com (mail-wr1-x441.google.com [IPv6:2a00:1450:4864:20::441])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 68B40C061755
        for <netdev@vger.kernel.org>; Tue,  8 Sep 2020 09:09:05 -0700 (PDT)
Received: by mail-wr1-x441.google.com with SMTP id j2so19726914wrx.7
        for <netdev@vger.kernel.org>; Tue, 08 Sep 2020 09:09:05 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=cumulusnetworks.com; s=google;
        h=date:in-reply-to:references:mime-version:content-transfer-encoding
         :subject:to:cc:from:message-id;
        bh=PsiwkZQON6FfJdyRwqS8mjtO9geB0dvO3WZRBLu8TAc=;
        b=e6Nzhe4ppUzUeKAm7nJ4ZNyvpXyjvTBuIvI7+fFBlfF5tYI0En4TDqDeVslWD6QSRs
         pbl5ZoP4um5WShbWNv/va+rVcQRWB6PgZwBUzCOpxgyLez9u67J3cVC0cVbT7tSgtHn9
         5t1UK25DgwqU9D5aGL4PzBXMHMAxXmHPWaBPg=
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:in-reply-to:references:mime-version
         :content-transfer-encoding:subject:to:cc:from:message-id;
        bh=PsiwkZQON6FfJdyRwqS8mjtO9geB0dvO3WZRBLu8TAc=;
        b=XZhH+J1TazjcwIKp6owNCRT8FtAshamwWoFwNK3pcTsaq49OMYxq9RxtZCb2BCiFNn
         oRHUI/ZueJsTbCF1VcSu/Fq+hr3xdTjxsOXgnaO/hhPeWnxrTm/v4UNymqmE3vx7+igw
         av6Pg3Zaham0aCBQtg+W/pgTCPn+JiXAMgUSTEbWm+GasFkNcYLa/DR3IYlVOqKH2+M4
         Z1XWSRvFOQSShLwbOkjd1mZA1oabXiXJGEP2x5gKah0Qulr9ks5y2GxTTkde5ezQrqoy
         HMk/mfTTC2huGu+XGc8DqWuWCKFGOcYnUkMrWt1OV3Yq0ZtQWzpXhngaE4gm6EJSdMkb
         Bnbw==
X-Gm-Message-State: AOAM532z39fKOU6z7ET+q5kxs7h7ocfeUkpBnD26WF6IJDKuJTimN027
        lvNM9kvOFbR0gspAYjYsr3jmvw==
X-Google-Smtp-Source: ABdhPJyvw20x5KYz9j/VX+os4UV38ruxuevfH2sXfoKP2rhwceon6qZnXVsKkJOSFbhnyENkM//Bfg==
X-Received: by 2002:a5d:430d:: with SMTP id h13mr385546wrq.41.1599581344005;
        Tue, 08 Sep 2020 09:09:04 -0700 (PDT)
Received: from localhost ([149.62.205.110])
        by smtp.gmail.com with ESMTPSA id d190sm34519764wmd.23.2020.09.08.09.09.02
        (version=TLS1_3 cipher=TLS_AES_128_GCM_SHA256 bits=128/128);
        Tue, 08 Sep 2020 09:09:03 -0700 (PDT)
Date:   Tue, 08 Sep 2020 19:09:00 +0300
In-Reply-To: <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
References: <20200908130000.7d33d787@canb.auug.org.au> <20200908071713.916165-1-nikolay@cumulusnetworks.com> <20200908090049.7e528e7f@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH net-next] net: bridge: mcast: fix unused br var when lockdep isn't defined
To:     Jakub Kicinski <kuba@kernel.org>
CC:     netdev@vger.kernel.org, davem@davemloft.net, roopa@nvidia.com,
        Stephen Rothwell <sfr@canb.auug.org.au>
From:   nikolay@cumulusnetworks.com
Message-ID: <3DB9AD39-8B58-42C3-8C13-929C8B9F1719@cumulusnetworks.com>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 8 September 2020 19:00:49 EEST, Jakub Kicinski <kuba@kernel=2Eorg> wrote=
:
>On Tue,  8 Sep 2020 10:17:13 +0300 Nikolay Aleksandrov wrote:
>> Stephen reported the following warning:
>>  net/bridge/br_multicast=2Ec: In function 'br_multicast_find_port':
>>  net/bridge/br_multicast=2Ec:1818:21: warning: unused variable 'br'
>[-Wunused-variable]
>>   1818 |  struct net_bridge *br =3D mp->br;
>>        |                     ^~
>>=20
>> It happens due to bridge's mlock_dereference() when lockdep isn't
>defined=2E
>> Silence the warning by annotating the variable as __maybe_unused=2E
>>=20
>> Fixes: 0436862e417e ("net: bridge: mcast: support for IGMPv3/MLDv2
>ALLOW_NEW_SOURCES report")
>> Reported-by: Stephen Rothwell <sfr@canb=2Eauug=2Eorg=2Eau>
>> Signed-off-by: Nikolay Aleksandrov <nikolay@cumulusnetworks=2Ecom>
>> ---
>>  net/bridge/br_multicast=2Ec | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>>=20
>> diff --git a/net/bridge/br_multicast=2Ec b/net/bridge/br_multicast=2Ec
>> index b83f11228948=2E=2E33adf44ef7ec 100644
>> --- a/net/bridge/br_multicast=2Ec
>> +++ b/net/bridge/br_multicast=2Ec
>> @@ -1814,8 +1814,8 @@ br_multicast_find_port(struct
>net_bridge_mdb_entry *mp,
>>  		       struct net_bridge_port *p,
>>  		       const unsigned char *src)
>>  {
>> +	struct net_bridge *br __maybe_unused =3D mp->br;
>>  	struct net_bridge_port_group *pg;
>> -	struct net_bridge *br =3D mp->br;
>> =20
>>  	for (pg =3D mlock_dereference(mp->ports, br);
>>  	     pg;
>
>That's a lazy fix :( Is everyone using lockdep annotations going to
>sprinkle __maybe_unused throughout the code? Macros should also always
>evaluate their arguments=2E

When the local variable's only used for lockdep, I guess=2E :)=20
Here we don't actually need it at all, alternatively we can just drop it a=
nd use mp->br=2E=20

