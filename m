Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 7E13E22C7BA
	for <lists+netdev@lfdr.de>; Fri, 24 Jul 2020 16:18:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726702AbgGXOSY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 24 Jul 2020 10:18:24 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:45244 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726317AbgGXOSY (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 24 Jul 2020 10:18:24 -0400
Received: from canardo.mork.no (canardo.mork.no [IPv6:2001:4641::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id B082BC0619D3;
        Fri, 24 Jul 2020 07:18:23 -0700 (PDT)
Received: from [IPv6:2a02:2121:283:8d02:15d6:da5b:427d:49dc] ([IPv6:2a02:2121:283:8d02:15d6:da5b:427d:49dc])
        (authenticated bits=0)
        by canardo.mork.no (8.15.2/8.15.2) with ESMTPSA id 06OEIFZg003614
        (version=TLSv1.2 cipher=ECDHE-RSA-AES256-GCM-SHA384 bits=256 verify=NO);
        Fri, 24 Jul 2020 16:18:16 +0200
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=mork.no; s=b;
        t=1595600297; bh=TrUfVBoeJkZ1QmlO5khT5aTGpRfHV2YfkpfBwbBHIlE=;
        h=Date:References:Subject:To:CC:From:Message-ID:From;
        b=S9jDUszaBm3VkJHVhbAl6i1F2/AsVuFYR6c9NRkn/IeBkaKpruw9vEb2ME+eVd2+u
         L0FXhHIVT0JB5+c7rTbtmzdKduducZxbT+jXBCKPdD/833x9up6U6HQ20G7bC/dCwE
         /WjAKA5JuiEI0SKNzsAt5iT7xWMUkY8+E2f6+1ec=
Date:   Fri, 24 Jul 2020 16:18:08 +0200
User-Agent: K-9 Mail for Android
In-Reply-To: <1595322008.29149.5.camel@suse.de>
References: <20200715184100.109349-1-bjorn@mork.no> <20200715184100.109349-3-bjorn@mork.no> <1595322008.29149.5.camel@suse.de>
MIME-Version: 1.0
Content-Type: text/plain;
 charset=utf-8
Content-Transfer-Encoding: quoted-printable
Subject: Re: [PATCH v5 net-next 2/5] net: cdc_ether: export usbnet_cdc_update_filter
To:     Oliver Neukum <oneukum@suse.de>, netdev@vger.kernel.org
CC:     linux-usb@vger.kernel.org, wxcafe@wxcafe.net,
        =?ISO-8859-1?Q?Miguel=09Rodr=EDguez_P=E9rez?= 
        <miguel@det.uvigo.gal>
From:   =?ISO-8859-1?Q?Bj=F8rn_Mork?= <bjorn@mork.no>
Message-ID: <2B227F47-F76D-45EF-85D6-8A5A85AE19A1@mork.no>
X-Virus-Scanned: clamav-milter 0.102.2 at canardo
X-Virus-Status: Clean
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org



On July 21, 2020 11:00:08 AM GMT+02:00, Oliver Neukum <oneukum@suse=2Ede> =
wrote:
>Am Mittwoch, den 15=2E07=2E2020, 20:40 +0200 schrieb Bj=C3=B8rn Mork:
>>=20
>> @@ -90,6 +90,7 @@ static void usbnet_cdc_update_filter(struct usbnet
>*dev)
>>  			USB_CTRL_SET_TIMEOUT
>>  		);
>>  }
>> +EXPORT_SYMBOL_GPL(usbnet_cdc_update_filter);
>
>Hi,
>
>this function is pretty primitive=2E In fact it more or less
>is a straight take from the spec=2E Can this justify the _GPL
>version?

Maybe not? I must admit I didn't put much thought into it=2E=20

I will not object to changing it=2E And you're the boss anyway :-)


Bj=C3=B8rn 
