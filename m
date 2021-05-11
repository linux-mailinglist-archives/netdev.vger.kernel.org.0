Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56D2937AE6B
	for <lists+netdev@lfdr.de>; Tue, 11 May 2021 20:24:58 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S231951AbhEKS0B (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 11 May 2021 14:26:01 -0400
Received: from ms.lwn.net ([45.79.88.28]:35682 "EHLO ms.lwn.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S231329AbhEKS0A (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 11 May 2021 14:26:00 -0400
X-Greylist: delayed 5005 seconds by postgrey-1.27 at vger.kernel.org; Tue, 11 May 2021 14:26:00 EDT
Received: from localhost (unknown [IPv6:2601:281:8300:104d:444a:d152:279d:1dbb])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by ms.lwn.net (Postfix) with ESMTPSA id 505484BF;
        Tue, 11 May 2021 18:24:53 +0000 (UTC)
DKIM-Filter: OpenDKIM Filter v2.11.0 ms.lwn.net 505484BF
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=lwn.net; s=20201203;
        t=1620757493; bh=9sU3ahlIQ4NVEGbfN/aeZtX+52ui1CI9/vl021LPM1U=;
        h=From:To:Cc:Subject:In-Reply-To:References:Date:From;
        b=PD4SBIWrd2qF4jBts8tkLj+dOD8PeMpRMY6MQ2tW8mQ2JgUXHEEhZU+ekEzLQvPFs
         kYce01dJPs7PGlsbLAYPormV3zSabfNRxdZ+094RmneJy6cOXIOibiQ0Hnhy6nyX0o
         YybTFnADzTeyIbwqkBgXCM+lLRxTjrEwjbLGoesTo7x8nR4vCr9iHqNI9w/BPToEjQ
         6Buf1D6flDuONDV8rJZJ42hX0kVfFz0+FAYHlHz0ZS64O57rf6Jg2L/mQJalqCR+kQ
         omQrHuKO/XSfYpBj9D+JC/o25dIcYMFrhTncUqdIfDGY54ZeiVYqhUj7B/FKa0heIn
         qdQSDbPKtA9dQ==
From:   Jonathan Corbet <corbet@lwn.net>
To:     Andrew Lunn <andrew@lunn.ch>,
        Mauro Carvalho Chehab <mchehab+huawei@kernel.org>
Cc:     Linux Doc Mailing List <linux-doc@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Jesse Brandeburg <jesse.brandeburg@intel.com>,
        Tony Nguyen <anthony.l.nguyen@intel.com>,
        intel-wired-lan@lists.osuosl.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Subject: Re: [PATCH 5/5] docs: networking: device_drivers: fix bad usage of
 UTF-8 chars
In-Reply-To: <YJq9abOeuBla3Jiw@lunn.ch>
References: <cover.1620744606.git.mchehab+huawei@kernel.org>
 <95eb2a48d0ca3528780ce0dfce64359977fa8cb3.1620744606.git.mchehab+huawei@kernel.org>
 <YJq9abOeuBla3Jiw@lunn.ch>
Date:   Tue, 11 May 2021 12:24:52 -0600
Message-ID: <8735utdt6z.fsf@meer.lwn.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Andrew Lunn <andrew@lunn.ch> writes:

>> -monitoring tools such as ifstat or sar =E2=80=93n DEV [interval] [numbe=
r of samples]
>> +monitoring tools such as `ifstat` or `sar -n DEV [interval] [number of =
samples]`
>
> ...
>
>>  For example: min_rate 1Gbit 3Gbit: Verify bandwidth limit using network
>> -monitoring tools such as ifstat or sar =E2=80=93n DEV [interval] [numbe=
r of samples]
>> +monitoring tools such as ``ifstat`` or ``sar -n DEV [interval] [number =
of samples]``
>
> Is there a difference between ` and `` ? Does it make sense to be
> consistent?

This is `just weird quotes`
This is ``literal text`` set in monospace in processed output.

There is a certain tension between those who want to see liberal use of
literal-text markup, and those who would rather have less markup in the
text overall; certainly, it's better not to go totally nuts with it.

jon
