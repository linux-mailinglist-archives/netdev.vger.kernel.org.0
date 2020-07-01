Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 242322115D7
	for <lists+netdev@lfdr.de>; Thu,  2 Jul 2020 00:23:54 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727997AbgGAWXu (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 1 Jul 2020 18:23:50 -0400
Received: from dispatch1-us1.ppe-hosted.com ([148.163.129.52]:60322 "EHLO
        dispatch1-us1.ppe-hosted.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726235AbgGAWXt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 1 Jul 2020 18:23:49 -0400
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.62])
        by dispatch1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 582AB60064;
        Wed,  1 Jul 2020 22:23:49 +0000 (UTC)
Received: from us4-mdac16-42.ut7.mdlocal (unknown [10.7.64.24])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTP id 561A7800A7;
        Wed,  1 Jul 2020 22:23:49 +0000 (UTC)
X-Virus-Scanned: Proofpoint Essentials engine
Received: from mx1-us1.ppe-hosted.com (unknown [10.7.65.197])
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id E7CE028005C;
        Wed,  1 Jul 2020 22:23:48 +0000 (UTC)
Received: from webmail.solarflare.com (uk.solarflare.com [193.34.186.16])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-SHA384 (256/256 bits))
        (No client certificate requested)
        by mx1-us1.ppe-hosted.com (PPE Hosted ESMTP Server) with ESMTPS id 99B02A40063;
        Wed,  1 Jul 2020 22:23:48 +0000 (UTC)
Received: from [10.17.20.203] (10.17.20.203) by ukex01.SolarFlarecom.com
 (10.17.10.4) with Microsoft SMTP Server (TLS) id 15.0.1497.2; Wed, 1 Jul 2020
 23:23:43 +0100
Subject: Re: [PATCH net-next 12/15] sfc_ef100: add EF100 to NIC-revision
 enumeration
To:     David Miller <davem@davemloft.net>, <kuba@kernel.org>
CC:     <linux-net-drivers@solarflare.com>, <netdev@vger.kernel.org>
References: <3fa88508-024e-2d33-0629-bf63b558b515@solarflare.com>
 <f03e0e84-4c8f-8e1e-a0c4-d8454daf9813@solarflare.com>
 <20200701121131.56e456c3@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
 <20200701.124422.999920966272100417.davem@davemloft.net>
From:   Edward Cree <ecree@solarflare.com>
Message-ID: <44dabf26-0d49-c577-5991-20d76fb4ccb6@solarflare.com>
Date:   Wed, 1 Jul 2020 23:23:40 +0100
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.2
MIME-Version: 1.0
In-Reply-To: <20200701.124422.999920966272100417.davem@davemloft.net>
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 8bit
Content-Language: en-GB
X-Originating-IP: [10.17.20.203]
X-ClientProxiedBy: ocex03.SolarFlarecom.com (10.20.40.36) To
 ukex01.SolarFlarecom.com (10.17.10.4)
X-TM-AS-Product-Ver: SMEX-12.5.0.1300-8.6.1012-25514.003
X-TM-AS-Result: No-2.584500-8.000000-10
X-TMASE-MatchedRID: nVQUmLJJeybmLzc6AOD8DfHkpkyUphL98t+pfhBMObxjLp8Cm8vwF2ly
        s1PDhWLo3gYRJJy72hx4zRiY9YYLzhTOvWmMwr3dt0cS/uxH87CytgTwfkaifThdESD0qLXT2aN
        pX9oFsVJX5t7w06f3W06BPtjxzOZHRBvTx4d8VQW0pXj1GkAfe30tCKdnhB58ZYJ9vPJ1vSDefx
        4FmMaZTOTCMddcL/gjro1URZJFbJtQfLIM/SfyxM2nrB0Xp0dn1YtrpwZG51KVPbgBAjzlIyBjT
        Gz+/FDP8/9N8BL5xdVWlOwCnCxJH6GdecHppIrmapzhjzu5IvCFcgJc+QNMwu8bJovJYm8FYupx
        0XjSQPLDOFVmKqGJ4bPn3tFon6UK
X-TM-AS-User-Approved-Sender: Yes
X-TM-AS-User-Blocked-Sender: No
X-TMASE-Result: 10--2.584500-8.000000
X-TMASE-Version: SMEX-12.5.0.1300-8.6.1012-25514.003
X-MDID: 1593642229-fMYr9sNinkmL
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 01/07/2020 20:44, David Miller wrote:
> Or is this code used as a library by two "drivers"?
Yes, it is; there will be a second module 'sfc_ef100.ko'which this
 file will be linked into and which will set efx->type to one with
 an EF100 revision.

Although tbh I have been wondering about another approach to
 ethtool_get_drvinfo: we could have a const char [] in each driver's
 non-common parts, holding KBUILD_MODNAME, which ethtool_common.c
 could just reference, rather than looking at efx->type->revision
 and relying on the rest of the driver to set it up right.
Since it looks like I'll need to respin this series anyway, I'll try
 that and see if it works — it seems cleaner to me.

-ed
