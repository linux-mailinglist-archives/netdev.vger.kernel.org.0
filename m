Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id EEC62235715
	for <lists+netdev@lfdr.de>; Sun,  2 Aug 2020 15:23:07 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728401AbgHBNVx (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Sun, 2 Aug 2020 09:21:53 -0400
Received: from mail-m127107.qiye.163.com ([115.236.127.107]:27654 "EHLO
        mail-m127107.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728057AbgHBNVx (ORCPT
        <rfc822;netdev@vger.kernel.org>); Sun, 2 Aug 2020 09:21:53 -0400
X-Greylist: delayed 400 seconds by postgrey-1.27 at vger.kernel.org; Sun, 02 Aug 2020 09:21:44 EDT
Received: from vivo.com (wm-12.qy.internal [127.0.0.1])
        by mail-m127107.qiye.163.com (Hmail) with ESMTP id 99F0281725;
        Sun,  2 Aug 2020 21:14:48 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <ADUAnwD8DVByMMSsrG-r3Kri.3.1596374087585.Hmail.wenhu.wang@vivo.com>
To:     Bjorn Andersson <bjorn.andersson@linaro.org>
Cc:     elder@kernel.org, davem@davemloft.net, kuba@kernel.org,
        kvalo@codeaurora.org, agross@kernel.org, ohad@wizery.com,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-remoteproc@vger.kernel.org, alsa-devel@alsa-project.org,
        ath11k@lists.infradead.org, netdev@vger.kernel.org,
        ath10k@lists.infradead.org, linux-wireless@vger.kernel.org,
        srinivas.kandagatla@linaro.org, sibis@codeaurora.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSF0gc29jOiBxbWk6IGFsbG93IHVzZXIgdG8gc2V0IGhhbmRsZSB3cSB0byBoaXByaW8=?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com
X-Originating-IP: 58.251.74.226
In-Reply-To: <20200727204521.GB229995@builder.lan>
MIME-Version: 1.0
Received: from wenhu.wang@vivo.com( [58.251.74.226) ] by ajax-webmail ( [127.0.0.1] ) ; Sun, 2 Aug 2020 21:14:47 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5paH6JmO?= <wenhu.wang@vivo.com>
Date:   Sun, 2 Aug 2020 21:14:47 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUpXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZTR1KTktOSx4aQkpOVkpOQk1ITE9LQ0JLSE5VEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVKS0tZBg++
X-HM-Sender-Digest: e1kJHlYWEh9ZQU5MTU1OSEpOS0tJN1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6Py46FQw*Qz8tOQI2NigICTxWCUgwCRJVSFVKTkJNSExPS0NCQ0lDVTMWGhIXVQweFRMOVQwa
        FRw7DRINFFUYFBZFWVdZEgtZQVlOQ1VJTkpVTE9VSUlNWVdZCAFZQU5LS0I3Bg++
X-HM-Tid: 0a73af4f7bbb986bkuuu99f0281725
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Cj4+IEN1cnJlbnRseSB0aGUgcW1pX2hhbmRsZSBpcyBpbml0aWFsaXplZCBzaW5nbGUgdGhyZWFk
ZWQgYW5kIHN0cmljdGx5Cj4+IG9yZGVyZWQgd2l0aCB0aGUgYWN0aXZlIHNldCB0byAxLiBUaGlz
IGlzIHByZXR0eSBzaW1wbGUgYW5kIHNhZmUgYnV0Cj4+IHNvbWV0aW1lcyBpbmVmZmVuY3kuIFNv
IGl0IGlzIGJldHRlciB0byBhbGxvdyB1c2VyIHRvIGRlY2lkZSB3aGV0aGVyCj4+IGEgaGlnaCBw
cmlvcml0eSB3b3JrcXVldWUgc2hvdWxkIGJlIHVzZWQuCj4KPkNhbiB5b3UgcGxlYXNlIGRlc2Ny
aWJlIGEgc2NlbmFyaW8gd2hlcmUgdGhpcyBpcyBuZWVkZWQvZGVzaXJlZCBhbmQKPnBlcmhhcHMg
YWxzbyBjb21tZW50IG9uIHdoeSB0aGlzIGlzIG5vdCBhbHdheXMgZGVzaXJlZD8KPgoKV2VsbCwg
b25lIHNjZW5hcmlvIGlzIHRoYXQgd2hlbiB0aGUgQVAgd2FudHMgdG8gY2hlY2sgdGhlIHN0YXR1
cyBvZiB0aGUKc3Vic3lzdGVtcyBhbmQgdGhlIHdob2xlIFFNSSBkYXRhIHBhdGguIEl0IGZpcnN0
IHNlbmRzIG91dCBhbiBpbmRpY2F0aW9uCndoaWNoIGFza3MgdGhlIHN1YnN5c3RlbXMgdG8gcmVw
b3J0IHRoZWlyIHN0YXR1cy4gQWZ0ZXIgdGhlIHN1YnN5c3RlbXMgc2VuZApyZXNwb25zZXMgdG8g
dGhlIEFQLCB0aGUgcmVzcG9uc2VzIHRoZW4gYXJlIHF1ZXVlZCBvbiB0aGUgd29ya3F1ZXVlIG9m
CnRoZSBRTUkgaGFuZGxlci4gQWN0dWFsbHkgdGhlIEFQIGlzIGNvbmZpZ3VyZWQgdG8gZG8gdGhl
IGNoZWNrIGluIGEgc3BlY2lmaWMKaW50ZXJ2YWwgcmVndWxhcmx5LiBBbmQgaXQgY2hlY2sgdGhl
IHJlcG9ydCBjb3VudHMgd2l0aGluIGEgc3BlY2lmaWMgZGVsYXkgYWZ0ZXIKaXQgc2VuZHMgb3V0
IHRoZSByZWxhdGVkIGluZGljYXRpb24uIFdoZW4gdGhlIEFQIGhhcyBiZWVuIHVuZGVyIGEgaGVh
dnkKbG9hZCBmb3IgbG9uZywgdGhlIHJlcG9ydHMgYXJlIHF1ZXVlIHRoZWlyIHdpdGhvdXQgQ1BV
IHJlc291cmNlIHRvIHVwZGF0ZQp0aGUgcmVwb3J0IGNvdW50cyB3aXRoaW4gdGhlIHNwZWNpZmlj
IGRlbGF5LiBBcyBhIHJlc3VsdCwgdGhlIHRocmVhZCB0aGF0IGNoZWNrcwp0aGUgcmVwb3J0IGNv
dW50cyB0YWtlcyBpdCBtaXNsZWFkaW5nbHkgdGhhdCB0aGUgUU1JIGRhdGEgcGF0aCBvciB0aGUg
c3Vic3lzdGVtcwphcmUgY3Jhc2hlZC4KClRoZSBwYXRjaCBjYW4gcmVhbGx5IHJlc29sdmUgdGhl
IHByb2JsZW0gbWVudGlvbmVkIGFib2x2ZS4KCkZvciBuYXJtYWwgc2l0dWF0aW9ucywgaXQgaXMg
ZW5vdWdoIHRvIGp1c3QgdXNlIG5vcm1hbCBwcmlvcml0eSBRTUkgd29ya3F1ZXVlLgoKPlJlZ2Fy
ZHMsCj5Cam9ybgo+Cj4+IAo+PiBTaWduZWQtb2ZmLWJ5OiBXYW5nIFdlbmh1IDx3ZW5odS53YW5n
QHZpdm8uY29tPgo+PiAtLS0KPj4gIGRyaXZlcnMvbmV0L2lwYS9pcGFfcW1pLmMgICAgICAgICAg
ICAgfCA0ICsrLS0KPj4gIGRyaXZlcnMvbmV0L3dpcmVsZXNzL2F0aC9hdGgxMGsvcW1pLmMgfCAy
ICstCj4+ICBkcml2ZXJzL25ldC93aXJlbGVzcy9hdGgvYXRoMTFrL3FtaS5jIHwgMiArLQo+PiAg
ZHJpdmVycy9yZW1vdGVwcm9jL3Fjb21fc3lzbW9uLmMgICAgICB8IDIgKy0KPj4gIGRyaXZlcnMv
c2xpbWJ1cy9xY29tLW5nZC1jdHJsLmMgICAgICAgfCA0ICsrLS0KPj4gIGRyaXZlcnMvc29jL3Fj
b20vcGRyX2ludGVyZmFjZS5jICAgICAgfCA0ICsrLS0KPj4gIGRyaXZlcnMvc29jL3Fjb20vcW1p
X2ludGVyZmFjZS5jICAgICAgfCA5ICsrKysrKystLQo+PiAgaW5jbHVkZS9saW51eC9zb2MvcWNv
bS9xbWkuaCAgICAgICAgICB8IDMgKystCj4+ICBzYW1wbGVzL3FtaS9xbWlfc2FtcGxlX2NsaWVu
dC5jICAgICAgIHwgNCArKy0tCj4+ICA5IGZpbGVzIGNoYW5nZWQsIDIwIGluc2VydGlvbnMoKyks
IDE0IGRlbGV0aW9ucygtKQ0KDQo=
