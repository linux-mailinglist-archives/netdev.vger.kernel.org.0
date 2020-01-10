Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id BA8D2136AF1
	for <lists+netdev@lfdr.de>; Fri, 10 Jan 2020 11:19:58 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727435AbgAJKT4 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 10 Jan 2020 05:19:56 -0500
Received: from mout.gmx.net ([212.227.17.21]:44321 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1727240AbgAJKT4 (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 10 Jan 2020 05:19:56 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1578651592;
        bh=zwI9dnvSOR5y9LoVneyGje58BDpJVMSBKLefIgrZs14=;
        h=X-UI-Sender-Class:Reply-To:Subject:From:To:Cc:References:Date:
         In-Reply-To;
        b=A0qmFvNsC72lJxq7g8S0LzdsR3iNSxIzkkgJm0VdUNWSHKhM2P+MyYEo195iPBy8a
         QhwBan5G5ZAC8W8VIeQZ0nTA/u4JJdHNFjIkLlfayRwu3B9XRpWdt0ak2I0XHPX+EG
         mZd71sWkrp7l66NIEtIlXEEHCZWBkopqaf8tqFRo=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [192.168.84.205] ([134.101.143.177]) by mail.gmx.com (mrgmx105
 [212.227.17.168]) with ESMTPSA (Nemesis) id 1MHGCu-1iuJNv3bVo-00DIVw; Fri, 10
 Jan 2020 11:19:52 +0100
Reply-To: vtol@gmx.net
Subject: Re: [drivers/net/phy/sfp] intermittent failure in state machine
 checks
From:   =?UTF-8?B?0b3SieG2rOG4s+KEoA==?= <vtol@gmx.net>
To:     Russell King - ARM Linux admin <linux@armlinux.org.uk>
Cc:     Andrew Lunn <andrew@lunn.ch>, netdev@vger.kernel.org
References: <513d6fe7-65b2-733b-1d17-b3a40b8161cf@gmx.net>
 <20200109155809.GQ25745@shell.armlinux.org.uk>
 <bb2c2eed-5efa-00f6-0e52-1326669c1b0d@gmx.net>
 <20200109174322.GR25745@shell.armlinux.org.uk>
 <acd4d7e4-7f8e-d578-c9c9-b45f062f4fe2@gmx.net>
 <7ebee7c5-4bf3-134d-bc57-ea71e0bdfc60@gmx.net>
 <20200109215903.GV25745@shell.armlinux.org.uk>
 <c7b4bec1-3f1f-8a34-cf22-8fb1f68914f3@gmx.net>
 <20200109231034.GW25745@shell.armlinux.org.uk>
 <727cea4e-9bff-efd2-3939-437038a322ad@gmx.net>
 <20200110092700.GX25745@shell.armlinux.org.uk>
 <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
Message-ID: <5c3aabb9-dae4-0ca2-72e9-50f8aa7b9ec4@gmx.net>
Date:   Fri, 10 Jan 2020 10:19:47 +0000
User-Agent: Mozilla/5.0 (Windows NT 10.0; rv:68.0) Gecko/20100101 Firefox/68.0
MIME-Version: 1.0
In-Reply-To: <18687669-e6f5-79f1-6cf9-d62d65f195db@gmx.net>
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: quoted-printable
Content-Language: en-GB
X-Provags-ID: V03:K1:JkqlKPVxVl8SWvkqPxRbGTKrXOtG4vhC4yWLhxGUDdqi/LGTOEt
 f3P2bNNScvg/uPpKXqTaANVtU71tdFvKN60bx9IcoPiRytpsEasYowhAQNFZeafPvV/tCLl
 6iu5ZptGlypCljLxyuLU1AsE5f/SdWwc61oJ0tHCJoV70rruyDb45CM3SMa1rMSp+wUPu4v
 EoMtH5/Wrt9CIWt8QigzQ==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:jm1AoqNjBp8=:YancPoHynMholSFf2WfdwG
 otqIkLvo6YyISolSHRlWbY9SuPaHtAhFIXYrbJ11Uih9SjtABTsamJmSEg9jLS1ZWE0TzRhe4
 5GSpCJDI2B8nkfY90uIXVj+FoWMBs6g0GkyYXGTrd34JxCs476xPVXLWiGqfjsvoWpv85oZHj
 83d8zbVa5jV/7n3x2t6JPv0PkYYNCsYT4t0E4V+4YCqnaE6k3p7BzsJNHP+QGY3GglTIDZICr
 DTwNVl7pFPKJqHd3Sen4nLh/RJOWCgduO7rzrIQ+N6DhY+wYA7Xueamf0yyYWHnJ8urrrvjeh
 Eog/zPhRPVYMhK501r85NmpP1rbvcX6q9wVtnwnoKOUxgctWF9iMxr1mR2cPjFn2Bf4liTR17
 9eetZlddv3ErfGh3wxw+GOYq9yyfs93CKkSQezF1rz2kvmD8j4GM0O8IomBZm5sxKvNxwip6J
 fxEtLdRtoIUgjvCLmZudkwGDVZFXvlN5j5Cm68vJxuDoDPEaiMCKgl5YMWRExpTZzKwrkgl9f
 dq8g/wDIVPTx7T0FLPj0diqjO8QdrSPe5RvYnnflkX2AsLnBR6hA7Nf5KaWKIQZa9SR7xLktQ
 PCVIbOu0/Ty1pkXjRBGEFr6F3Vki+FrMMpfdMtisHXvWTpSsb8JeW7CX6YPYJJb2RBTWd3kKG
 ur9H2KstwmI6EW0nReOfWCmx9JE79Eoj73czLT4S/884bYhFT+R06LrbNNTUm5AQ2VlTw33On
 Q89l7vfwomt4hdvPAAgrRAuo0868NUKpwDhJJrnNyf/NH/pTLcfgHoCoDql4OAZw5Blqgh1tL
 ljSj0XdBZVQqUhgg+hDhL3W2brlrnDE7DH5xXpYZLAntOCz6mmF05YvQAB7sxxk6n7WX/3VAC
 8EvAQQ/peJ9CEE8EAZL0RauaBXK1H/TRKpPq8DrC5TPXlRf3zuq3yY4qkw6dFijSCGcG7Lyb4
 MEftkgqP25v2Dpkz/pXYC4iApsqpcREopvqYM2B0IOQotjbd8I4vqYwjysYlk7ZjPwNRxe1fx
 rKpdB0rzGtscRjxlShFu9YQi18Ew/XOHNO0wp2hKpciMlcsSKpHbnL2z3cwu3lKvfmYHfagRE
 dWebs8BWSgUPG9jvb3H/kNHCC+cEsCzucQxhJLHb4XQ5INpLkthBtAOJQxwo3L2/EC8cI/NP4
 dW/cyVdDy5bOvRHObK+ikC2WomRXoaBfewA3/YnZQyNb3TEBULgLnbqash0SUcCGPEPuEJsHx
 IiWkVAjOUdj3R9qFm/JVHq+uVw5dDgNC8Zxn8Jw==
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

I just came across this=20
http://edgemax5.rssing.com/chan-66822975/all_p1715.html#item34298

and albeit for a SFP g.fast module it indicates/implies that Metanoia=20
provides own Linux drivers (supposedly GPL licensed), plus some bits=20
pertaining to the EBM (Ethernet Boot Management protocol).

Has Metanoia submitted any SFP drivers to upstream kernel development?

