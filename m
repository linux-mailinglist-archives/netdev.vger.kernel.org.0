Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 0811E20A629
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 21:52:35 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406872AbgFYTwb (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 15:52:31 -0400
Received: from mail.avm.de ([212.42.244.119]:38236 "EHLO mail.avm.de"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2406838AbgFYTwa (ORCPT <rfc822;netdev@vger.kernel.org>);
        Thu, 25 Jun 2020 15:52:30 -0400
Received: from mail-notes.avm.de (mail-notes.avm.de [172.16.0.1])
        by mail.avm.de (Postfix) with ESMTP;
        Thu, 25 Jun 2020 21:51:57 +0200 (CEST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=avm.de; s=mail;
        t=1593114717; bh=BQJDjerrGotjzEPdCQoF+DD/UsuRHgzjh3ys8ELpxlA=;
        h=In-Reply-To:References:Subject:From:To:Cc:Date:From;
        b=GNyF+1wnZ/0XonaDE1R0wdrS3QqRJCKF/LQ9aBymayIiv0QX0jFfjYuzsqwL5zhvM
         uImGXBlTikVYs/nDLPQCIZaV+GUS4jD9CoNpTAWhmfJKKNeafj1XJbOyhYGyJVrXnF
         thCOn+dZ3F8BKPH3bTOVWncdLojtxkGtL008nnro=
MIME-Version: 1.0
X-Disclaimed: 1
Sensitivity: 
Importance: Normal
X-Priority: 3 (Normal)
In-Reply-To: <20200625.123810.272736267545607911.davem@davemloft.net>
References: <20200625.123810.272736267545607911.davem@davemloft.net>,
        <20200625065407.1196147-1-t.martitz@avm.de>        <20200625122602.2582222-1-t.martitz@avm.de>
Subject: Antwort: Re: [PATCH v2] net: bridge: enfore alignment for ethernet address
From:   t.martitz@avm.de
To:     "David Miller" <davem@davemloft.net>
Cc:     netdev@vger.kernel.org, roopa@cumulusnetworks.com,
        nikolay@cumulusnetworks.com, kuba@kernel.org, nbd@nbd.name,
        stable@vger.kernel.org
Date:   Thu, 25 Jun 2020 21:51:57 +0200
Message-ID: <OFB3DAEE48.90B85F69-ONC1258592.006D0CB5-C1258592.006D205A@avm.de>
X-Mailer: Lotus Domino Web Server Release 11.0.1HF27   June 16, 2020
X-MIMETrack: Serialize by http on ANIS1/AVM(Release 11.0.1HF27 | June 16, 2020) at
 25.06.2020 21:51:57,
        Serialize complete at 25.06.2020 21:51:57,
        Itemize by http on ANIS1/AVM(Release 11.0.1HF27 | June 16, 2020) at
 25.06.2020 21:51:57,
        Serialize by Router on ANIS1/AVM(Release 11.0.1HF27 | June 16, 2020) at
 25.06.2020 21:51:57
Content-Transfer-Encoding: quoted-printable
Content-Type: text/plain;
        charset=ISO-8859-1
X-purgate-ID: 149429::1593114717-00000547-C8408BC1/0/0
X-purgate-type: clean
X-purgate-size: 1619
X-purgate-Ad: Categorized by eleven eXpurgate (R) http://www.eleven.de
X-purgate: This mail is considered clean (visit http://www.eleven.de for further information)
X-purgate: clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



-----netdev-owner@vger.kernel.org schrieb: -----

>An: t.martitz@avm.de
>Von: "David Miller"=20
>Gesendet von: netdev-owner@vger.kernel.org
>Datum: 25.06.2020 21:38
>Kopie: netdev@vger.kernel.org, roopa@cumulusnetworks.com,
>nikolay@cumulusnetworks.com, kuba@kernel.org, nbd@nbd.name,
>stable@vger.kernel.org
>Betreff: Re: [PATCH v2] net: bridge: enfore alignment for ethernet
>address
>
>From: Thomas Martitz <t.martitz@avm.de>
>Date: Thu, 25 Jun 2020 14:26:03 +0200
>
>> The eth=5Faddr member is passed to ether=5Faddr functions that require
>> 2-byte alignment, therefore the member must be properly aligned
>> to avoid unaligned accesses.
>>=20
>> The problem is in place since the initial merge of multicast to
>unicast:
>> commit 6db6f0eae6052b70885562e1733896647ec1d807 bridge: multicast
>to unicast
>>=20
>> Fixes: 6db6f0eae605 ("bridge: multicast to unicast")
>> Cc: Roopa Prabhu <roopa@cumulusnetworks.com>
>> Cc: Nikolay Aleksandrov <nikolay@cumulusnetworks.com>
>> Cc: David S. Miller <davem@davemloft.net>
>> Cc: Jakub Kicinski <kuba@kernel.org>
>> Cc: Felix Fietkau <nbd@nbd.name>
>> Cc: stable@vger.kernel.org
>> Signed-off-by: Thomas Martitz <t.martitz@avm.de>
>
>Applied and queued up for -stable.

Awesome, thank you! I was about to resend the patch with the Nikolay's
Acked-By, but turns out that wasn't necessary.

>
>Please do not explicitly CC: stable for networking changes, I take
>care
>of those by hand.
>

Alright, I'll remeber that. This was my very first submission to the kernel,
everywhere it is suggested to Cc: stable.

Best regards.
