Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7165D109C91
	for <lists+netdev@lfdr.de>; Tue, 26 Nov 2019 11:51:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727891AbfKZKvd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 26 Nov 2019 05:51:33 -0500
Received: from sender4-of-o58.zoho.com ([136.143.188.58]:21850 "EHLO
        sender4-of-o58.zoho.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727825AbfKZKvd (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 26 Nov 2019 05:51:33 -0500
ARC-Seal: i=1; a=rsa-sha256; t=1574764565; cv=none; 
        d=zohomail.com; s=zohoarc; 
        b=KSgbP/SaLhDXQJUQjdEUcPeGhxe0CYtNcs4Bq0Y9ODob+Je/UrLu98rxvpfYIWXsZtPCVR3E+zfsijfAM2DwvCGVxZLJQPP6aBpYLuTasHSq1wXTtzYqtpYstqIFXX05/hxEFEZWd3IE/EwzvtAR+rLUWr+tXzeEYfM5g0ob0O4=
ARC-Message-Signature: i=1; a=rsa-sha256; c=relaxed/relaxed; d=zohomail.com; s=zohoarc; 
        t=1574764565; h=Content-Type:Content-Transfer-Encoding:Cc:Date:From:In-Reply-To:MIME-Version:Message-ID:Reply-To:Subject:To; 
        bh=c/3dqYrZaGnc4tGwwSDhNLs/aSCK3LS7JS9Z5nKVpVQ=; 
        b=cqGrFulyhlNmpspgekpi8My0kjBFvNpBm58ST6wK/w4QISPFLOzeq4ohsUAlN3wb1h0ofM+Qq/3Hea0l05x4w5gmES3qhZIIQ6utNA58cpj462vST8nx3Rk83JilkPIkxPCmlI3e6zYXON7fW5+x6xBz8vtHnZGw6X5HUVj1VPk=
ARC-Authentication-Results: i=1; mx.zohomail.com;
        dkim=pass  header.i=patchew.org;
        spf=pass  smtp.mailfrom=no-reply@patchew.org;
        dmarc=pass header.from=<no-reply@patchew.org> header.from=<no-reply@patchew.org>
Received: from [172.17.0.3] (23.253.156.214 [23.253.156.214]) by mx.zohomail.com
        with SMTPS id 1574764563537255.54649937131023; Tue, 26 Nov 2019 02:36:03 -0800 (PST)
In-Reply-To: <20191126100914.5150-1-prashantbhole.linux@gmail.com>
Reply-To: <qemu-devel@nongnu.org>
Subject: Re: [RFC 0/3] Qemu: virtio-net XDP offload
Message-ID: <157476456132.31055.15214499348148879084@37313f22b938>
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
Date:   Tue, 26 Nov 2019 02:36:03 -0800 (PST)
X-ZohoMailClient: External
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

UGF0Y2hldyBVUkw6IGh0dHBzOi8vcGF0Y2hldy5vcmcvUUVNVS8yMDE5MTEyNjEwMDkxNC41MTUw
LTEtcHJhc2hhbnRiaG9sZS5saW51eEBnbWFpbC5jb20vCgoKCkhpLAoKVGhpcyBzZXJpZXMgZmFp
bGVkIHRoZSBkb2NrZXItbWluZ3dAZmVkb3JhIGJ1aWxkIHRlc3QuIFBsZWFzZSBmaW5kIHRoZSB0
ZXN0aW5nIGNvbW1hbmRzIGFuZAp0aGVpciBvdXRwdXQgYmVsb3cuIElmIHlvdSBoYXZlIERvY2tl
ciBpbnN0YWxsZWQsIHlvdSBjYW4gcHJvYmFibHkgcmVwcm9kdWNlIGl0CmxvY2FsbHkuCgo9PT0g
VEVTVCBTQ1JJUFQgQkVHSU4gPT09CiMhIC9iaW4vYmFzaApleHBvcnQgQVJDSD14ODZfNjQKbWFr
ZSBkb2NrZXItaW1hZ2UtZmVkb3JhIFY9MSBORVRXT1JLPTEKdGltZSBtYWtlIGRvY2tlci10ZXN0
LW1pbmd3QGZlZG9yYSBKPTE0IE5FVFdPUks9MQo9PT0gVEVTVCBTQ1JJUFQgRU5EID09PQoKICBD
QyAgICAgIGFhcmNoNjQtc29mdG1tdS9ody9hcm0vbXVzaWNwYWwubwogIENDICAgICAgYWFyY2g2
NC1zb2Z0bW11L2h3L2FybS9uZXRkdWlubzIubwogIENDICAgICAgYWFyY2g2NC1zb2Z0bW11L2h3
L2FybS9uc2VyaWVzLm8KL3RtcC9xZW11LXRlc3Qvc3JjL2h3L25ldC92aXJ0aW8tbmV0LmM6NjM2
OjEyOiBlcnJvcjogJ3BlZXJfYXR0YWNoX2VicGYnIGRlZmluZWQgYnV0IG5vdCB1c2VkIFstV2Vy
cm9yPXVudXNlZC1mdW5jdGlvbl0KIHN0YXRpYyBpbnQgcGVlcl9hdHRhY2hfZWJwZihWaXJ0SU9O
ZXQgKm4sIGludCBsZW4sIHZvaWQgKmluc25zLCB1aW50OF90IGdwbCkKICAgICAgICAgICAgXn5+
fn5+fn5+fn5+fn5+fgpjYzE6IGFsbCB3YXJuaW5ncyBiZWluZyB0cmVhdGVkIGFzIGVycm9ycwpt
YWtlWzFdOiAqKiogWy90bXAvcWVtdS10ZXN0L3NyYy9ydWxlcy5tYWs6Njk6IGh3L25ldC92aXJ0
aW8tbmV0Lm9dIEVycm9yIDEKbWFrZVsxXTogKioqIFdhaXRpbmcgZm9yIHVuZmluaXNoZWQgam9i
cy4uLi4KICBDQyAgICAgIGFhcmNoNjQtc29mdG1tdS9ody9hcm0vb21hcF9zeDEubwogIENDICAg
ICAgYWFyY2g2NC1zb2Z0bW11L2h3L2FybS9wYWxtLm8KbWFrZTogKioqIFtNYWtlZmlsZTo0OTE6
IHg4Nl82NC1zb2Z0bW11L2FsbF0gRXJyb3IgMgptYWtlOiAqKiogV2FpdGluZyBmb3IgdW5maW5p
c2hlZCBqb2JzLi4uLgogIENDICAgICAgYWFyY2g2NC1zb2Z0bW11L2h3L2FybS9ndW1zdGl4Lm8K
ICBDQyAgICAgIGFhcmNoNjQtc29mdG1tdS9ody9hcm0vc3BpdHoubwotLS0KICBDQyAgICAgIGFh
cmNoNjQtc29mdG1tdS9nZGJzdHViLXhtbC5vCiAgQ0MgICAgICBhYXJjaDY0LXNvZnRtbXUvdHJh
Y2UvZ2VuZXJhdGVkLWhlbHBlcnMubwogIENDICAgICAgYWFyY2g2NC1zb2Z0bW11L3RhcmdldC9h
cm0vdHJhbnNsYXRlLXN2ZS5vCi90bXAvcWVtdS10ZXN0L3NyYy9ody9uZXQvdmlydGlvLW5ldC5j
OjYzNjoxMjogZXJyb3I6ICdwZWVyX2F0dGFjaF9lYnBmJyBkZWZpbmVkIGJ1dCBub3QgdXNlZCBb
LVdlcnJvcj11bnVzZWQtZnVuY3Rpb25dCiBzdGF0aWMgaW50IHBlZXJfYXR0YWNoX2VicGYoVmly
dElPTmV0ICpuLCBpbnQgbGVuLCB2b2lkICppbnNucywgdWludDhfdCBncGwpCiAgICAgICAgICAg
IF5+fn5+fn5+fn5+fn5+fn4KY2MxOiBhbGwgd2FybmluZ3MgYmVpbmcgdHJlYXRlZCBhcyBlcnJv
cnMKbWFrZVsxXTogKioqIFsvdG1wL3FlbXUtdGVzdC9zcmMvcnVsZXMubWFrOjY5OiBody9uZXQv
dmlydGlvLW5ldC5vXSBFcnJvciAxCm1ha2U6ICoqKiBbTWFrZWZpbGU6NDkxOiBhYXJjaDY0LXNv
ZnRtbXUvYWxsXSBFcnJvciAyClRyYWNlYmFjayAobW9zdCByZWNlbnQgY2FsbCBsYXN0KToKICBG
aWxlICIuL3Rlc3RzL2RvY2tlci9kb2NrZXIucHkiLCBsaW5lIDY2MiwgaW4gPG1vZHVsZT4KICAg
IHN5cy5leGl0KG1haW4oKSkKLS0tCiAgICByYWlzZSBDYWxsZWRQcm9jZXNzRXJyb3IocmV0Y29k
ZSwgY21kKQpzdWJwcm9jZXNzLkNhbGxlZFByb2Nlc3NFcnJvcjogQ29tbWFuZCAnWydzdWRvJywg
Jy1uJywgJ2RvY2tlcicsICdydW4nLCAnLS1sYWJlbCcsICdjb20ucWVtdS5pbnN0YW5jZS51dWlk
PTViNmFjYzJhYzc0OTRhZDZiNTk3MDZjOWRkMjZjM2NkJywgJy11JywgJzEwMDEnLCAnLS1zZWN1
cml0eS1vcHQnLCAnc2VjY29tcD11bmNvbmZpbmVkJywgJy0tcm0nLCAnLWUnLCAnVEFSR0VUX0xJ
U1Q9JywgJy1lJywgJ0VYVFJBX0NPTkZJR1VSRV9PUFRTPScsICctZScsICdWPScsICctZScsICdK
PTE0JywgJy1lJywgJ0RFQlVHPScsICctZScsICdTSE9XX0VOVj0nLCAnLWUnLCAnQ0NBQ0hFX0RJ
Uj0vdmFyL3RtcC9jY2FjaGUnLCAnLXYnLCAnL2hvbWUvcGF0Y2hldy8uY2FjaGUvcWVtdS1kb2Nr
ZXItY2NhY2hlOi92YXIvdG1wL2NjYWNoZTp6JywgJy12JywgJy92YXIvdG1wL3BhdGNoZXctdGVz
dGVyLXRtcC00ZTJobm5kNS9zcmMvZG9ja2VyLXNyYy4yMDE5LTExLTI2LTA1LjMzLjM3LjMzMjov
dmFyL3RtcC9xZW11Onoscm8nLCAncWVtdTpmZWRvcmEnLCAnL3Zhci90bXAvcWVtdS9ydW4nLCAn
dGVzdC1taW5ndyddJyByZXR1cm5lZCBub24temVybyBleGl0IHN0YXR1cyAyLgpmaWx0ZXI9LS1m
aWx0ZXI9bGFiZWw9Y29tLnFlbXUuaW5zdGFuY2UudXVpZD01YjZhY2MyYWM3NDk0YWQ2YjU5NzA2
YzlkZDI2YzNjZAptYWtlWzFdOiAqKiogW2RvY2tlci1ydW5dIEVycm9yIDEKbWFrZVsxXTogTGVh
dmluZyBkaXJlY3RvcnkgYC92YXIvdG1wL3BhdGNoZXctdGVzdGVyLXRtcC00ZTJobm5kNS9zcmMn
Cm1ha2U6ICoqKiBbZG9ja2VyLXJ1bi10ZXN0LW1pbmd3QGZlZG9yYV0gRXJyb3IgMgoKcmVhbCAg
ICAybTI0Ljk2N3MKdXNlciAgICAwbTguOTk5cwoKClRoZSBmdWxsIGxvZyBpcyBhdmFpbGFibGUg
YXQKaHR0cDovL3BhdGNoZXcub3JnL2xvZ3MvMjAxOTExMjYxMDA5MTQuNTE1MC0xLXByYXNoYW50
YmhvbGUubGludXhAZ21haWwuY29tL3Rlc3RpbmcuZG9ja2VyLW1pbmd3QGZlZG9yYS8/dHlwZT1t
ZXNzYWdlLgotLS0KRW1haWwgZ2VuZXJhdGVkIGF1dG9tYXRpY2FsbHkgYnkgUGF0Y2hldyBbaHR0
cHM6Ly9wYXRjaGV3Lm9yZy9dLgpQbGVhc2Ugc2VuZCB5b3VyIGZlZWRiYWNrIHRvIHBhdGNoZXct
ZGV2ZWxAcmVkaGF0LmNvbQ==

