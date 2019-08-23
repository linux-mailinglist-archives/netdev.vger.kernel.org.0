Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id B3EA89B8C3
	for <lists+netdev@lfdr.de>; Sat, 24 Aug 2019 01:22:51 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726844AbfHWXRm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 23 Aug 2019 19:17:42 -0400
Received: from mout.gmx.net ([212.227.17.21]:58043 "EHLO mout.gmx.net"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1726387AbfHWXRm (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 23 Aug 2019 19:17:42 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=gmx.net;
        s=badeba3b8450; t=1566602249;
        bh=1P2oQyCplWxRnncu1NEoeVe5YLAJYiH0xLdNai1s/OM=;
        h=X-UI-Sender-Class:To:Cc:References:Subject:From:Date:In-Reply-To;
        b=bL1Zst1xQUCWMFxhXHxmnENZ1bRWPd2Ut9HCVYkS9gZkM8fWRM+ZRIZ2SQPQW1szZ
         wvEP4HITlhod9XzggSK6tB8EwBkB1iWAQzfyzq/dg053BThjWG31m8tP97w7NGQFZz
         PRuBBGzonuPHzYXn2kgduBqLwQnhzLzquIH3fP6g=
X-UI-Sender-Class: 01bb95c1-4bf8-414a-932a-4f6e2808ef9c
Received: from [172.16.252.112] ([2.244.50.110]) by mail.gmx.com (mrgmx102
 [212.227.17.168]) with ESMTPSA (Nemesis) id 0LZlZ2-1iV6n71b0W-00lT17; Sat, 24
 Aug 2019 01:17:29 +0200
To:     Sabrina Dubroca <sd@queasysnail.net>
Cc:     herbert@gondor.apana.org.au, netdev@vger.kernel.org,
        steffen.klassert@secunet.com
References: <cover.1566395202.git.sd@queasysnail.net>
Subject: Re: [PATCH ipsec-next 0/7] ipsec: add TCP encapsulation support (RFC
 8229)
From:   Carl-Daniel Hailfinger <c-d.hailfinger.devel.2006@gmx.net>
Message-ID: <87c6bbfb-854b-7a7d-c88d-5c5730a8dc54@gmx.net>
Date:   Sat, 24 Aug 2019 01:17:27 +0200
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <cover.1566395202.git.sd@queasysnail.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 7bit
X-Provags-ID: V03:K1:23hBoQGf72OQo8NkQExmzrcoSuAkwjApp6qaa//RjYpOBvDPSeD
 JxZFJ8eau5iYwXeScieNI2HHg0fDrj3CDysKQk1cE30KVh1nwWLA2dnn+C/iQklVatfvh/s
 +AStI2hs223YxFkUZsPO3bKw2V1qYw0xDfRbkHjD0Dj7k48BeKT3L/kKud+j9+nzG3mAFAl
 RcT+4lcsaysNKhIAcQJVg==
X-Spam-Flag: NO
X-UI-Out-Filterresults: notjunk:1;V03:K0:o4+Q9cRcvnc=:LBU7kxGiSbDgyhnOzOKghT
 zNrHj0xrD+NRZr1V8ZvwkTDPdaYhxaPSF1iGIRrKb3KZqn1us2CkSDz019za1DOnPqCH9SaNy
 jZgavm7hilVDTGeOIWU4wV8k44M7AAjBm6F5/ZQN51BVMk4tjH5DgIn6p8hpBQZedNUyHWvVB
 XEiZ+DLLXoPosjU6iofmcnIHXxM7Nj0rj9ixQyrsqWuWNZwsTTtCx9ecwuD0sfxlIA6yJjPWL
 2FUkQWPe0A05HhmjiBxA2+NSlVyw0epg+g/VIIheFUGfq+NNnM3Ukc1JEfjl9TOwtEapv7UZd
 xwiS1CK5Bh5C0+d2h0kxCkvzFTQMfFpaIpg5kGt2v0BHSoWKN8eAwdIVa43NEFUPf+xvYeW5t
 B5PhVMDRvDt/YnaHjLFtev+Xh3a1YR/e+xHcLpmF7j21ieDofALbPXE+IjdFAv5uFMyHm+Irw
 XcAachuWozlq/Q8uGojjqxPxWIwppNwul5WQwe229INeadUTM5o97Vnt/zOOHiNZ7ECVgqYCR
 Jif6AcJvuRIOW7FMAm/AKBEsZP4flY5cEjdkEtl4WsGFDdr3DMsIOgRqPG5XC6iAEru/cBXqL
 ZZVqU0oO6CoOuV6FODUotNI3WnS2ncgB5oZe+UNF6Rgsl8Ifv5nFD2P9Y92nvKlbSgOTNuiS3
 tlohlkdCsaMEYPuzV/1UcXDMH+oUawP1HudY6UhBRjI5NaLXR/BKsKJ66B+FE71VT3HoVZYKl
 RtRK1MRkmabI4VNx0T6SLZEDTDbeAhpTLLMY5K0FxO6mXF18JxDT4fxQL+45zYYQq45g0S3hE
 /auTGbUMCqGdVHUDWglt1iQJwWoTpybNgnnlWeKQCT1kwYTx+m0sshLKtNXFtSUBOyRyM58rO
 lywurmX23DISsTkZasUN5O0bhsmQs3O7Adqq+zxiQJxntpndC9LaO+syiA/4wiq4CjVBX4EeZ
 N3iSeoQmSBL/6SsaltMP/fI7q3q53zi9XZ+lWlh2IVsgwb88mLBQSNlA3jWwOEqyxRztNbysG
 h0lP0VbZHFyaoVInSo3Yaz7LTjl1stZAh7G49k11GLwJzxb7BsTF9ob5grO5X29FT9SRIUucB
 Dc6x93WXPXW3/Ew52cbs17tgt+4FkHdUFKUbXe4En7zk2QejRzce9dw08+UON0S/kLgwlrmvs
 TmIn1W/w12sHJ6FrThUWQGHLfS
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi!

On Wed, 21 Aug 2019 23:46:18 +0200, Sabrina Dubroca wrote:
> This patchset introduces support for TCP encapsulation of IKE and ESP
> messages, as defined by RFC 8229 [0]. It is an evolution of what
> Herbert Xu proposed in January 2018 [1] that addresses the main
> criticism against it, by not interfering with the TCP implementation
> at all. The networking stack now has infrastructure for this: TCP ULPs
> and Stream Parsers.
> [...]

Thank you very much for the patchset. Where I live, a substantial amount
of free and paid Wifi networks restrict UDP to port 53. TCP ports are
usually unaffected by such restrictions.
Running IKE/ESP over TCP is sometimes the only remaining option, and
this patch makes that option available.


> The main omission in this submission is IPv6 support. ESP
> encapsulation over UDP with IPv6 is currently not supported in the
> kernel either, as UDP encapsulation is aimed at NAT traversal, and NAT
> is not frequently used with IPv6.

Side note: The lack of support for ESP over UDP with IPv6 is the reason
why third-party Android IPsec management apps (e.g. the strongswan app)
can't connect to IPv6-only remote endpoints. AFAIK Android apps do not
have permission to send ESP packets directly, whereas establishing TCP
connections and sending UDP datagrams is permitted. But even without
IPv6 support, this patch is a great step forward.

Regards,
Carl-Daniel
