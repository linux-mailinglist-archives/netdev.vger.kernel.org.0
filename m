Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 45C5D109C82
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:48:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727845AbfKZKsx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:48:53 -0500
Received: from sender4-of-o58.zoho.com ([136.143.188.58]:21885 "EHLO
        sender4-of-o58.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727793AbfKZKsx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:48:53 -0500
X-Greylist: delayed 904 seconds by postgrey-1.27 at vger.kernel.org; Tue, 26 Nov 2019 05:48:52 EST
ARC-Seal: i=1; a=rsa-sha256; t=1574764385; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=gKLimMF1PS9qx80R3iT/EnfAW+TENs/7KTaCr5ErsnSAC8nD0gEnvgaaLG8HinIHAOTzR1QMQ8WmQsZm9Rmb+WiZIbw3R42Pf0ly/hw2/rFr7F2D94XTAmjaM4LrlSU39/+WOB+ZNL/d63NIibVqwePhgy+FVgJu/emr0g3KebU=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574764385; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=4Hg+6acknztSxkk1XXynSdoyPl2trR0LMbBAHb1kRpQ=; 
        b=jN3T/UbGJ1zb0dJdigqExoPATgefE0GNleHewa1WdjINYbXNvPVvyg9qMExFr/GWLJpfaahvHhkPijwbaNOHvmH9Z0AQSvR1sWf+0IfPvURCzlL4wxZpc0cOWbPfYNPOSolJ/oDUxJnR4TWbhnrxVeylBuUDoALuJ71J9AhO7/k=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1574764383634138.33074800024394; Tue, 26 Nov 2019 02:33:03 -0800 (PST)
In-Reply-To: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [RFC 0/3] Qemu: virtio-net XDP offload
Message-ID: <157476438124.31055.4199785471534349367@37313f22b938>
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
From:   no-reply@patchew.org
To:     prashantbhole.linux@gmail.com
Cc:     mst@redhat.com, jasowang@redhat.com, qemu-devel@nongnu.org,
        songliubraving@fb.com, jakub.kicinski@netronome.com,
        hawk@kernel.org, daniel@iogearbox.net, netdev@vger.kernel.org,
        john.fastabend@gmail.com, ast@kernel.org, kafai@fb.com,
        prashantbhole.linux@gmail.com, kvm@vger.kernel.org, yhs@fb.com,
        andriin@fb.com, davem@davemloft.net
Date:   Tue, 26 Nov 2019 02:33:03 -0800 (PST)
X-ZohoMailClient: External
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDE5MTEyNjEwMDkxNC41MTUw
LTEtcHJhc2hhbnRiaG9sZS5saW51eEBnbWFpbC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFp
bGVkIHRoZSBkb2NrZXItcXVpY2tAY2VudG9zNyBidWlsZCB0ZXN0LiBQbGVhc2UgZmluZCB0aGUg
dGVzdGluZyBjb21tYW5kcyBhbmQKdGhlaXIgb3V0cHV0IGJlbG93LiBJZiB5b3UgaGF2ZSBEb2Nr
ZXIgaW5zdGFsbGVkLCB5b3UgY2FuIHByb2JhYmx5IHJlcHJvZHVjZSBpdApsb2NhbGx5LgoKPT09
IFRFU1QgU0NSSVBUIEJFR0lOID09PQojIS9iaW4vYmFzaAptYWtlIGRvY2tlci1pbWFnZS1jZW50
b3M3IFY9MSBORVRXT1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0LXF1aWNrQGNlbnRvczcgU0hP
V19FTlY9MSBKPTE0IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKICBDQyAgICAg
IHVpL2lucHV0LWtleW1hcC5vCiAgQ0MgICAgICB1aS9pbnB1dC1sZWdhY3kubwogIENDICAgICAg
dWkva2JkLXN0YXRlLm8KL3RtcC9xZW11LXRlc3Qvc3JjL25ldC90YXAtbGludXguYzozNDoyMTog
ZmF0YWwgZXJyb3I6IGJwZi9icGYuaDogTm8gc3VjaCBmaWxlIG9yIGRpcmVjdG9yeQogI2luY2x1
ZGUgPGJwZi9icGYuaD4KICAgICAgICAgICAgICAgICAgICAgXgpjb21waWxhdGlvbiB0ZXJtaW5h
dGVkLgotLS0KICBTSUdOICAgIHBjLWJpb3Mvb3B0aW9ucm9tL2xpbnV4Ym9vdC5iaW4KICBTSUdO
ICAgIHBjLWJpb3Mvb3B0aW9ucm9tL2t2bXZhcGljLmJpbgogIEJVSUxEICAgcGMtYmlvcy9vcHRp
b25yb20vbGludXhib290X2RtYS5pbWcKbWFrZTogKioqIFtuZXQvdGFwLWxpbnV4Lm9dIEVycm9y
IDEKbWFrZTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9icy4uLi4KICBCVUlMRCAgIHBj
LWJpb3Mvb3B0aW9ucm9tL3B2aC5pbWcKICBCVUlMRCAgIHBjLWJpb3Mvb3B0aW9ucm9tL2xpbnV4
Ym9vdF9kbWEucmF3Ci0tLQogICAgcmFpc2UgQ2FsbGVkUHJvY2Vzc0Vycm9yKHJldGNvZGUsIGNt
ZCkKc3VicHJvY2Vzcy5DYWxsZWRQcm9jZXNzRXJyb3I6IENvbW1hbmQgJ1snc3VkbycsICctbics
ICdkb2NrZXInLCAncnVuJywgJy0tbGFiZWwnLCAnY29tLnFlbXUuaW5zdGFuY2UudXVpZD1iZTg0
OWJmZWQwMmQ0ZWE3YjE5Zjc3NDZmZTAzN2JkNScsICctdScsICcxMDAxJywgJy0tc2VjdXJpdHkt
b3B0JywgJ3NlY2NvbXA9dW5jb25maW5lZCcsICctLXJtJywgJy1lJywgJ1RBUkdFVF9MSVNUPScs
ICctZScsICdFWFRSQV9DT05GSUdVUkVfT1BUUz0nLCAnLWUnLCAnVj0nLCAnLWUnLCAnSj0xNCcs
ICctZScsICdERUJVRz0nLCAnLWUnLCAnU0hPV19FTlY9MScsICctZScsICdDQ0FDSEVfRElSPS92
YXIvdG1wL2NjYWNoZScsICctdicsICcvaG9tZS9wYXRjaGV3Ly5jYWNoZS9xZW11LWRvY2tlci1j
Y2FjaGU6L3Zhci90bXAvY2NhY2hlOnonLCAnLXYnLCAnL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXIt
dG1wLTNkMnozd2wzL3NyYy9kb2NrZXItc3JjLjIwMTktMTEtMjYtMDUuMzEuMDUuMjE3MDg6L3Zh
ci90bXAvcWVtdTp6LHJvJywgJ3FlbXU6Y2VudG9zNycsICcvdmFyL3RtcC9xZW11L3J1bicsICd0
ZXN0LXF1aWNrJ10nIHJldHVybmVkIG5vbi16ZXJvIGV4aXQgc3RhdHVzIDIuCmZpbHRlcj0tLWZp
bHRlcj1sYWJlbD1jb20ucWVtdS5pbnN0YW5jZS51dWlkPWJlODQ5YmZlZDAyZDRlYTdiMTlmNzc0
NmZlMDM3YmQ1Cm1ha2VbMV06ICoqKiBbZG9ja2VyLXJ1bl0gRXJyb3IgMQptYWtlWzFdOiBMZWF2
aW5nIGRpcmVjdG9yeSBgL3Zhci90bXAvcGF0Y2hldy10ZXN0ZXItdG1wLTNkMnozd2wzL3NyYycK
bWFrZTogKioqIFtkb2NrZXItcnVuLXRlc3QtcXVpY2tAY2VudG9zN10gRXJyb3IgMgoKcmVhbCAg
ICAxbTU2LjQ0N3MKdXNlciAgICAwbTguNTE5cwoKClRoZSBmdWxsIGxvZyBpcyBhdmFpbGFibGUg
YXQKaHR0cDovL3BhdGNoZXcub3JnL2xvZ3MvMjAxOTExMjYxMDA5MTQuNTE1MC0xLXByYXNoYW50
YmhvbGUubGludXhAZ21haWwuY29tL3Rlc3RpbmcuZG9ja2VyLXF1aWNrQGNlbnRvczcvP3R5cGU9
bWVzc2FnZS4KLS0tCkVtYWlsIGdlbmVyYXRlZCBhdXRvbWF0aWNhbGx5IGJ5IFBhdGNoZXcgW2h0
dHBzOi8vcGF0Y2hldy5vcmcvXS4KUGxlYXNlIHNlbmQgeW91ciBmZWVkYmFjayB0byBwYXRjaGV3
LWRldmVsQHJlZGhhdC5jb20=

