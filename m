Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 91FD0117BFB
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 01:02:22 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727320AbfLJACU (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 9 Dec 2019 19:02:20 -0500
Received: from mail-vs1-f65.google.com ([209.85.217.65]:42143 "EHLO
        mail-vs1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726592AbfLJACU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 9 Dec 2019 19:02:20 -0500
Received: by mail-vs1-f65.google.com with SMTP id b79so6678219vsd.9
        for <netdev@vger.kernel.org>; Mon, 09 Dec 2019 16:02:19 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=mime-version:references:in-reply-to:from:date:message-id:subject:to
         :cc;
        bh=Wphls3SzJx5+aTzGoiV39CkydXm7yCTwQM/h0lD+QLE=;
        b=nbnNST0R/B3VIVT7bOmpa/0OtHv2Ee+2ifQQq4F5FwddiZRPrcgMpCnyM1kBIlrWaW
         s6jP3fuerktGXcP7Y7qRAVl7blMV2IgpTnuE832xy7h0ZxqvLD1Sox3WKErfQI54dWb3
         jJFuJFuxJxsv1PDPyCm/mrjqTvNYg2sGU1prl9qBI+oBAI2SoY4n8z/LiR2L+h+1aSrQ
         OdTlpnqENwS1DbGOYdeWW3UDo7s7ci1rVE2TKoT+acKwOshdkzRxhz6yiaZNj6T40F3V
         K5Jy+YorqlUVpqi0R2gkuihy9uEJXIX3yaZLlo4SrML/ob5IHxko3JtcmAtBRkM4LPUM
         icLw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:mime-version:references:in-reply-to:from:date
         :message-id:subject:to:cc;
        bh=Wphls3SzJx5+aTzGoiV39CkydXm7yCTwQM/h0lD+QLE=;
        b=KzTGOXashpqD7/mogETw+FWf46/19t3UNmCY1Wsd8H9Ckcol//H2q6DeQmpsfpXQgU
         gxn4M1q2BhnNE5hcPN4e0O1uFX6DJhBEJLD/f8yoaWNo+tBYepFo+9RsoxR4iHdxlujp
         hnHfUP3G2jkUsa7Av2C4XXviD5dkTPdZs+KJwun64LzcMt2DDFOEHva97+dwAW9VbDGK
         aqfjmtHMm9ULqMC0FX2IMnonKfxAbEaVISAD0QQ2oGx9rOy/djqRsIpli8xS+lhuDko/
         Ni7gRkIwa0k9kJiQpQY+6jG9fvVlG42d3FDaKVIX+mWUKODf6EvE3lkWGPLIot2vO9Ua
         au0Q==
X-Gm-Message-State: APjAAAXeeg75yG4zYQI4H/VnE7ZR5+40im+taxqnaUN74WYH4ka+NjqA
        UYjbwwkIN6dhLFxO4Vi9GCLJ5tTpVVdqoXNbqUWr/syk
X-Google-Smtp-Source: APXvYqwjT1cCnH40UKFDwHU9qHvfiioixe0zYm6UgIhw3qNNR2TZWfRw+z034Wg2jSHJafDcDMq9kfxmnAbMpaFRB8o=
X-Received: by 2002:a05:6102:2332:: with SMTP id b18mr22668936vsa.231.1575936138928;
 Mon, 09 Dec 2019 16:02:18 -0800 (PST)
MIME-Version: 1.0
References: <CAHo-OowKQPQj9UhjCND5SmTOergBXMHtEctJA_T0SKLO5yebSg@mail.gmail.com>
 <20191209224530.156283-1-zenczykowski@gmail.com> <20191209154216.7e19e0c0@cakuba.netronome.com>
In-Reply-To: <20191209154216.7e19e0c0@cakuba.netronome.com>
From:   =?UTF-8?Q?Maciej_=C5=BBenczykowski?= <zenczykowski@gmail.com>
Date:   Tue, 10 Dec 2019 01:02:08 +0100
Message-ID: <CANP3RGe8zqa2V-PBjvACAJa2Hrd8z7BXUkks0KCrAtyeDjbsYw@mail.gmail.com>
Subject: Re: [PATCH v2] net: introduce ip_local_unbindable_ports sysctl
To:     Jakub Kicinski <jakub.kicinski@netronome.com>
Cc:     "David S . Miller" <davem@davemloft.net>,
        Linux Network Development Mailing List 
        <netdev@vger.kernel.org>,
        Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>,
        Sean Tranchetti <stranche@codeaurora.org>,
        Eric Dumazet <edumazet@google.com>,
        Linux SCTP <linux-sctp@vger.kernel.org>,
        Subash Abhinov Kasiviswanathan <subashab@codeaurora.org>
Content-Type: text/plain; charset="UTF-8"
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

> Could you elaborate what protocols and products are in need of this
> functionality?

The ones I'm aware of are:
(a) Google's servers
(b) Android on at least some chipsets (Qualcomm at the bare minimum,
but I think it's pretty standard a solution) where there's a complex
port sharing scheme between the Linux kernel on the Application
Processor and the Firmware running on the modem (for ipv4 we only get
one ip address from the cellular carrier).  It's basically required
for things like wifi calling to work.

> Why can't the NIC just get its own IP like it usually does with NCSI?

Because often these nics are deployed as in place upgrades in
environments where there's a limited number of IPs.
Say a rack with a /27 ipv4 subnet (2**5 = 32 -> 29 usable ips, since
network/broadcast/gateway are burned) and 15+ pre-existing machines.
This means there's not enough IPs to assign separate ones for the nics.
Renumbering the rack, would imply renumbering the datacenter, etc...
And ipv4 - even RFC1918 - has long run out - so even in new
deployments there's not enough IPv4 ips to give to nics, and IPv6
isn't yet deployed *everywhere*.
