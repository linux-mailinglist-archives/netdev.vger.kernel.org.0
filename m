Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 1BEB020A45D
	for <lists+netdev@lfdr.de>; Thu, 25 Jun 2020 20:01:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2405853AbgFYSBB (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 25 Jun 2020 14:01:01 -0400
Received: from serv108.segi.ulg.ac.be ([139.165.32.111]:60630 "EHLO
        serv108.segi.ulg.ac.be" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2405552AbgFYSBB (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 25 Jun 2020 14:01:01 -0400
Received: from mbx12-zne.ulg.ac.be (serv470.segi.ulg.ac.be [139.165.32.199])
        by serv108.segi.ulg.ac.be (Postfix) with ESMTP id 3DA71200F4B3;
        Thu, 25 Jun 2020 20:00:47 +0200 (CEST)
DKIM-Filter: OpenDKIM Filter v2.11.0 serv108.segi.ulg.ac.be 3DA71200F4B3
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=uliege.be;
        s=ulg20190529; t=1593108047;
        bh=eKhGDz61Yk3KV5WSs9ojcEyzHAR/XPfI2eHtQWKkyq8=;
        h=Date:From:Reply-To:To:Cc:In-Reply-To:References:Subject:From;
        b=F7u8k27l9vlpS3pqertP6eWvL2Ck/5gyTJQPWGytbSfaCUbVKe7ypd5tKmL0tW+6Y
         JzpNOzlpm4wVdQzEgvpxh/W2NhEhrvB5Tyu/WtkiUNEiIo+w/gJBkUggxfPqAJYynQ
         KAB7I3XfiIMFFkGZsYblVjsV6+XYwOiyGP9HhfB2QzucUJSNx26Bp7idtVT8r6ANGi
         yLRWrjEcf1mJPhH43xKxYLD7tlvJlKDTeLmhwLGaUGmXUzdhfjshkKPMsujKf2EGaW
         JwBMO7NtiAKl5W8KQzUFO/lYSkqBoC431KtaPkRexiSNauvGyk0RyBbC/GOtF/IxDG
         J7NTBrLz7jTHg==
Received: from localhost (localhost.localdomain [127.0.0.1])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 2916F129ED8C;
        Thu, 25 Jun 2020 20:00:47 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be ([127.0.0.1])
        by localhost (mbx12-zne.ulg.ac.be [127.0.0.1]) (amavisd-new, port 10026)
        with ESMTP id wpOMGCxmcOo5; Thu, 25 Jun 2020 20:00:47 +0200 (CEST)
Received: from mbx12-zne.ulg.ac.be (mbx12-zne.ulg.ac.be [139.165.32.199])
        by mbx12-zne.ulg.ac.be (Postfix) with ESMTP id 00806129ED8B;
        Thu, 25 Jun 2020 20:00:46 +0200 (CEST)
Date:   Thu, 25 Jun 2020 20:00:46 +0200 (CEST)
From:   Justin Iurman <justin.iurman@uliege.be>
Reply-To: Justin Iurman <justin.iurman@uliege.be>
To:     Tom Herbert <tom@herbertland.com>
Cc:     Linux Kernel Network Developers <netdev@vger.kernel.org>,
        "David S. Miller" <davem@davemloft.net>
Message-ID: <1640372169.36580750.1593108046851.JavaMail.zimbra@uliege.be>
In-Reply-To: <CALx6S37UFbABwHs4t_f5w1vT6HtFURRWkOD5Ci9f-LH083QVmA@mail.gmail.com>
References: <20200624192310.16923-1-justin.iurman@uliege.be> <20200624192310.16923-6-justin.iurman@uliege.be> <CALx6S37UFbABwHs4t_f5w1vT6HtFURRWkOD5Ci9f-LH083QVmA@mail.gmail.com>
Subject: Re: [PATCH net-next 5/5] ipv6: ioam: Documentation for new IOAM
 sysctls
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: quoted-printable
X-Originating-IP: [109.129.49.166]
X-Mailer: Zimbra 8.8.15_GA_3901 (ZimbraWebClient - FF77 (Linux)/8.8.15_GA_3895)
Thread-Topic: ipv6: ioam: Documentation for new IOAM sysctls
Thread-Index: Jb/ym3iO9022B4Wp2bYI3aeVe7i/Vw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

>> Add documentation for new IOAM sysctls:
>>  - ioam6_id: a namespace sysctl
>>  - ioam6_enabled and ioam6_id: two per-interface sysctls
>>
> Are you planning add a more detailed description of the feature and
> how to use it (would be nice I think :-) )

Of course, will do that ASAP!

Justin

>> Signed-off-by: Justin Iurman <justin.iurman@uliege.be>
>> ---
>>  Documentation/networking/ioam6-sysctl.rst | 20 ++++++++++++++++++++
>>  Documentation/networking/ip-sysctl.rst    |  5 +++++
>>  2 files changed, 25 insertions(+)
>>  create mode 100644 Documentation/networking/ioam6-sysctl.rst
>>
>> diff --git a/Documentation/networking/ioam6-sysctl.rst
>> b/Documentation/networking/ioam6-sysctl.rst
>> new file mode 100644
>> index 000000000000..bad6c64907bc
>> --- /dev/null
>> +++ b/Documentation/networking/ioam6-sysctl.rst
>> @@ -0,0 +1,20 @@
>> +.. SPDX-License-Identifier: GPL-2.0
>> +
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +IOAM6 Sysfs variables
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +
>> +/proc/sys/net/conf/<iface>/ioam6_* variables:
>> +=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=
=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D=3D
>> +
>> +ioam6_enabled - BOOL
>> +       Enable (accept) or disable (drop) IPv6 IOAM packets on this inte=
rface.
>> +
>> +       * 0 - disabled (default)
>> +       * not 0 - enabled
>> +
>> +ioam6_id - INTEGER
>> +       Define the IOAM id of this interface.
>> +
>> +       Default is 0.
>> diff --git a/Documentation/networking/ip-sysctl.rst
>> b/Documentation/networking/ip-sysctl.rst
>> index b72f89d5694c..5ba11f2766bd 100644
>> --- a/Documentation/networking/ip-sysctl.rst
>> +++ b/Documentation/networking/ip-sysctl.rst
>> @@ -1770,6 +1770,11 @@ nexthop_compat_mode - BOOLEAN
>>         and extraneous notifications.
>>         Default: true (backward compat mode)
>>
>> +ioam6_id - INTEGER
>> +       Define the IOAM id of this node.
>> +
>> +       Default: 0
>> +
>>  IPv6 Fragmentation:
>>
>>  ip6frag_high_thresh - INTEGER
>> --
>> 2.17.1

--=20
Justin Iurman
Universit=C3=A9 de Li=C3=A8ge (ULg)
B=C3=A2t. B28  Algorithmique des Grands Syst=C3=A8mes
Quartier Polytech 1
All=C3=A9e de la D=C3=A9couverte 10
4000 Li=C3=A8ge
Phone: +32 4 366 28 09
