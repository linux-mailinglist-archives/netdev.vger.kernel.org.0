Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 4321A1B4CE0
	for <lists+netdev@lfdr.de>; Wed, 22 Apr 2020 20:51:23 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726412AbgDVSvS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 22 Apr 2020 14:51:18 -0400
Received: from mga09.intel.com ([134.134.136.24]:46413 "EHLO mga09.intel.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725810AbgDVSvS (ORCPT <rfc822;netdev@vger.kernel.org>);
        Wed, 22 Apr 2020 14:51:18 -0400
IronPort-SDR: D6KacBdzTlj8G5VOh9aWCb6EOOvUUdni1RbstJ1IjBTU2IVEoHZUsxzQLOfTRPgyi+Gkjp3Sak
 fZs713zbNklA==
X-Amp-Result: SKIPPED(no attachment in message)
X-Amp-File-Uploaded: False
Received: from orsmga005.jf.intel.com ([10.7.209.41])
  by orsmga102.jf.intel.com with ESMTP/TLS/ECDHE-RSA-AES256-GCM-SHA384; 22 Apr 2020 11:51:16 -0700
IronPort-SDR: TKtdATS7yWGw2OCbole89FnH53XDXqkqleqAih3nQ+HB0LJ9y9DhecE8KRNAlLcYoZJSXnv28F
 eFTRptEjGCGw==
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.73,304,1583222400"; 
   d="scan'208";a="430025955"
Received: from fmsmsx107.amr.corp.intel.com ([10.18.124.205])
  by orsmga005.jf.intel.com with ESMTP; 22 Apr 2020 11:51:16 -0700
Received: from fmsmsx601.amr.corp.intel.com (10.18.126.81) by
 fmsmsx107.amr.corp.intel.com (10.18.124.205) with Microsoft SMTP Server (TLS)
 id 14.3.439.0; Wed, 22 Apr 2020 11:50:27 -0700
Received: from fmsmsx602.amr.corp.intel.com (10.18.126.82) by
 fmsmsx601.amr.corp.intel.com (10.18.126.81) with Microsoft SMTP Server
 (version=TLS1_2, cipher=TLS_ECDHE_RSA_WITH_AES_128_GCM_SHA256) id
 15.1.1713.5; Wed, 22 Apr 2020 11:50:26 -0700
Received: from fmsmsx602.amr.corp.intel.com ([10.18.126.82]) by
 fmsmsx602.amr.corp.intel.com ([10.18.126.82]) with mapi id 15.01.1713.004;
 Wed, 22 Apr 2020 11:50:26 -0700
From:   "Bowers, AndrewX" <andrewx.bowers@intel.com>
CC:     "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        "intel-wired-lan@lists.osuosl.org" <intel-wired-lan@lists.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [Intel-wired-lan] [PATCH] virtchnl: Add missing explicit padding
 to structures
Thread-Topic: [Intel-wired-lan] [PATCH] virtchnl: Add missing explicit padding
 to structures
Thread-Index: AQHWFAL0wDsVJ0rZrUijuL8oTIwLrKiFhYsA
Date:   Wed, 22 Apr 2020 18:50:26 +0000
Message-ID: <1e732391d4e94bbc87ab01ee80934fd3@intel.com>
References: <20200416095049.12917-1-geert@linux-m68k.org>
In-Reply-To: <20200416095049.12917-1-geert@linux-m68k.org>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
dlp-product: dlpe-windows
dlp-reaction: no-action
dlp-version: 11.2.0.6
x-originating-ip: [10.22.254.132]
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: base64
MIME-Version: 1.0
To:     unlisted-recipients:; (no To-header on input)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

LS0tLS1PcmlnaW5hbCBNZXNzYWdlLS0tLS0NCkZyb206IEludGVsLXdpcmVkLWxhbiA8aW50ZWwt
d2lyZWQtbGFuLWJvdW5jZXNAb3N1b3NsLm9yZz4gT24gQmVoYWxmIE9mIEdlZXJ0IFV5dHRlcmhv
ZXZlbg0KU2VudDogVGh1cnNkYXksIEFwcmlsIDE2LCAyMDIwIDI6NTEgQU0NClRvOiBLaXJzaGVy
LCBKZWZmcmV5IFQgPGplZmZyZXkudC5raXJzaGVyQGludGVsLmNvbT47IERhdmlkIFMgLiBNaWxs
ZXIgPGRhdmVtQGRhdmVtbG9mdC5uZXQ+DQpDYzogbmV0ZGV2QHZnZXIua2VybmVsLm9yZzsgaW50
ZWwtd2lyZWQtbGFuQGxpc3RzLm9zdW9zbC5vcmc7IGxpbnV4LWtlcm5lbEB2Z2VyLmtlcm5lbC5v
cmc7IEdlZXJ0IFV5dHRlcmhvZXZlbiA8Z2VlcnRAbGludXgtbTY4ay5vcmc+DQpTdWJqZWN0OiBb
SW50ZWwtd2lyZWQtbGFuXSBbUEFUQ0hdIHZpcnRjaG5sOiBBZGQgbWlzc2luZyBleHBsaWNpdCBw
YWRkaW5nIHRvIHN0cnVjdHVyZXMNCg0KT24gZS5nLiBtNjhrLCB0aGUgYWxpZ25tZW50IG9mIDMy
LWJpdCB2YWx1ZXMgaXMgb25seSAyIGJ5dGVzLCBsZWFkaW5nDQp0bzoNCg0KICAgIC4vaW5jbHVk
ZS9saW51eC9hdmYvdmlydGNobmwuaDoxNDc6MzY6IHdhcm5pbmc6IGRpdmlzaW9uIGJ5IHplcm8g
Wy1XZGl2LWJ5LXplcm9dDQogICAgICB7IHZpcnRjaG5sX3N0YXRpY19hc3NlcnRfIyNYID0gKG4p
Lygoc2l6ZW9mKHN0cnVjdCBYKSA9PSAobikpID8gMSA6IDApIH0NCgkJCQkJXg0KICAgIC4vaW5j
bHVkZS9saW51eC9hdmYvdmlydGNobmwuaDo1Nzc6MTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1h
Y3JvIOKAmFZJUlRDSE5MX0NIRUNLX1NUUlVDVF9MRU7igJkNCiAgICAgVklSVENITkxfQ0hFQ0tf
U1RSVUNUX0xFTigyNzIsIHZpcnRjaG5sX2ZpbHRlcik7DQogICAgIF5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+fn4NCiAgICAuL2luY2x1ZGUvbGludXgvYXZmL3ZpcnRjaG5sLmg6NTc3OjMyOiBlcnJv
cjogZW51bWVyYXRvciB2YWx1ZSBmb3Ig4oCYdmlydGNobmxfc3RhdGljX2Fzc2VydF92aXJ0Y2hu
bF9maWx0ZXLigJkgaXMgbm90IGFuIGludGVnZXIgY29uc3RhbnQNCiAgICAgVklSVENITkxfQ0hF
Q0tfU1RSVUNUX0xFTigyNzIsIHZpcnRjaG5sX2ZpbHRlcik7DQoJCQkJICAgIF5+fn5+fn5+fn5+
fn5+fg0KICAgIC4vaW5jbHVkZS9saW51eC9hdmYvdmlydGNobmwuaDoxNDc6NTM6IG5vdGU6IGlu
IGRlZmluaXRpb24gb2YgbWFjcm8g4oCYVklSVENITkxfQ0hFQ0tfU1RSVUNUX0xFTuKAmQ0KICAg
ICAgeyB2aXJ0Y2hubF9zdGF0aWNfYXNzZXJ0XyMjWCA9IChuKS8oKHNpemVvZihzdHJ1Y3QgWCkg
PT0gKG4pKSA/IDEgOiAwKSB9DQoJCQkJCQkJIF4NCiAgICAuL2luY2x1ZGUvbGludXgvYXZmL3Zp
cnRjaG5sLmg6MTQ3OjM2OiB3YXJuaW5nOiBkaXZpc2lvbiBieSB6ZXJvIFstV2Rpdi1ieS16ZXJv
XQ0KICAgICAgeyB2aXJ0Y2hubF9zdGF0aWNfYXNzZXJ0XyMjWCA9IChuKS8oKHNpemVvZihzdHJ1
Y3QgWCkgPT0gKG4pKSA/IDEgOiAwKSB9DQoJCQkJCV4NCiAgICAuL2luY2x1ZGUvbGludXgvYXZm
L3ZpcnRjaG5sLmg6NjE5OjE6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhWSVJUQ0hO
TF9DSEVDS19TVFJVQ1RfTEVO4oCZDQogICAgIFZJUlRDSE5MX0NIRUNLX1NUUlVDVF9MRU4oMTYs
IHZpcnRjaG5sX3BmX2V2ZW50KTsNCiAgICAgXn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fg0KICAg
IC4vaW5jbHVkZS9saW51eC9hdmYvdmlydGNobmwuaDo2MTk6MzE6IGVycm9yOiBlbnVtZXJhdG9y
IHZhbHVlIGZvciDigJh2aXJ0Y2hubF9zdGF0aWNfYXNzZXJ0X3ZpcnRjaG5sX3BmX2V2ZW504oCZ
IGlzIG5vdCBhbiBpbnRlZ2VyIGNvbnN0YW50DQogICAgIFZJUlRDSE5MX0NIRUNLX1NUUlVDVF9M
RU4oMTYsIHZpcnRjaG5sX3BmX2V2ZW50KTsNCgkJCQkgICBefn5+fn5+fn5+fn5+fn5+fg0KICAg
IC4vaW5jbHVkZS9saW51eC9hdmYvdmlydGNobmwuaDoxNDc6NTM6IG5vdGU6IGluIGRlZmluaXRp
b24gb2YgbWFjcm8g4oCYVklSVENITkxfQ0hFQ0tfU1RSVUNUX0xFTuKAmQ0KICAgICAgeyB2aXJ0
Y2hubF9zdGF0aWNfYXNzZXJ0XyMjWCA9IChuKS8oKHNpemVvZihzdHJ1Y3QgWCkgPT0gKG4pKSA/
IDEgOiAwKSB9DQoJCQkJCQkJIF4NCiAgICAuL2luY2x1ZGUvbGludXgvYXZmL3ZpcnRjaG5sLmg6
MTQ3OjM2OiB3YXJuaW5nOiBkaXZpc2lvbiBieSB6ZXJvIFstV2Rpdi1ieS16ZXJvXQ0KICAgICAg
eyB2aXJ0Y2hubF9zdGF0aWNfYXNzZXJ0XyMjWCA9IChuKS8oKHNpemVvZihzdHJ1Y3QgWCkgPT0g
KG4pKSA/IDEgOiAwKSB9DQoJCQkJCV4NCiAgICAuL2luY2x1ZGUvbGludXgvYXZmL3ZpcnRjaG5s
Lmg6NjQwOjE6IG5vdGU6IGluIGV4cGFuc2lvbiBvZiBtYWNybyDigJhWSVJUQ0hOTF9DSEVDS19T
VFJVQ1RfTEVO4oCZDQogICAgIFZJUlRDSE5MX0NIRUNLX1NUUlVDVF9MRU4oMTIsIHZpcnRjaG5s
X2l3YXJwX3F2X2luZm8pOw0KICAgICBefn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQogICAgLi9p
bmNsdWRlL2xpbnV4L2F2Zi92aXJ0Y2hubC5oOjY0MDozMTogZXJyb3I6IGVudW1lcmF0b3IgdmFs
dWUgZm9yIOKAmHZpcnRjaG5sX3N0YXRpY19hc3NlcnRfdmlydGNobmxfaXdhcnBfcXZfaW5mb+KA
mSBpcyBub3QgYW4gaW50ZWdlciBjb25zdGFudA0KICAgICBWSVJUQ0hOTF9DSEVDS19TVFJVQ1Rf
TEVOKDEyLCB2aXJ0Y2hubF9pd2FycF9xdl9pbmZvKTsNCgkJCQkgICBefn5+fn5+fn5+fn5+fn5+
fn5+fn5+DQogICAgLi9pbmNsdWRlL2xpbnV4L2F2Zi92aXJ0Y2hubC5oOjE0Nzo1Mzogbm90ZTog
aW4gZGVmaW5pdGlvbiBvZiBtYWNybyDigJhWSVJUQ0hOTF9DSEVDS19TVFJVQ1RfTEVO4oCZDQog
ICAgICB7IHZpcnRjaG5sX3N0YXRpY19hc3NlcnRfIyNYID0gKG4pLygoc2l6ZW9mKHN0cnVjdCBY
KSA9PSAobikpID8gMSA6IDApIH0NCgkJCQkJCQkgXg0KICAgIC4vaW5jbHVkZS9saW51eC9hdmYv
dmlydGNobmwuaDoxNDc6MzY6IHdhcm5pbmc6IGRpdmlzaW9uIGJ5IHplcm8gWy1XZGl2LWJ5LXpl
cm9dDQogICAgICB7IHZpcnRjaG5sX3N0YXRpY19hc3NlcnRfIyNYID0gKG4pLygoc2l6ZW9mKHN0
cnVjdCBYKSA9PSAobikpID8gMSA6IDApIH0NCgkJCQkJXg0KICAgIC4vaW5jbHVkZS9saW51eC9h
dmYvdmlydGNobmwuaDo2NDc6MTogbm90ZTogaW4gZXhwYW5zaW9uIG9mIG1hY3JvIOKAmFZJUlRD
SE5MX0NIRUNLX1NUUlVDVF9MRU7igJkNCiAgICAgVklSVENITkxfQ0hFQ0tfU1RSVUNUX0xFTigx
NiwgdmlydGNobmxfaXdhcnBfcXZsaXN0X2luZm8pOw0KICAgICBefn5+fn5+fn5+fn5+fn5+fn5+
fn5+fn5+DQogICAgLi9pbmNsdWRlL2xpbnV4L2F2Zi92aXJ0Y2hubC5oOjY0NzozMTogZXJyb3I6
IGVudW1lcmF0b3IgdmFsdWUgZm9yIOKAmHZpcnRjaG5sX3N0YXRpY19hc3NlcnRfdmlydGNobmxf
aXdhcnBfcXZsaXN0X2luZm/igJkgaXMgbm90IGFuIGludGVnZXIgY29uc3RhbnQNCiAgICAgVklS
VENITkxfQ0hFQ0tfU1RSVUNUX0xFTigxNiwgdmlydGNobmxfaXdhcnBfcXZsaXN0X2luZm8pOw0K
CQkJCSAgIF5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+fn5+DQogICAgLi9pbmNsdWRlL2xpbnV4L2F2
Zi92aXJ0Y2hubC5oOjE0Nzo1Mzogbm90ZTogaW4gZGVmaW5pdGlvbiBvZiBtYWNybyDigJhWSVJU
Q0hOTF9DSEVDS19TVFJVQ1RfTEVO4oCZDQogICAgICB7IHZpcnRjaG5sX3N0YXRpY19hc3NlcnRf
IyNYID0gKG4pLygoc2l6ZW9mKHN0cnVjdCBYKSA9PSAobikpID8gMSA6IDApIH0NCgkJCQkJCQkg
Xg0KDQpGaXggdGhpcyBieSBhZGRpbmcgZXhwbGljaXQgcGFkZGluZyB0byBzdHJ1Y3R1cmVzIHdp
dGggaG9sZXMuDQoNClJlcG9ydGVkLWJ5OiBub3JlcGx5QGVsbGVybWFuLmlkLmF1DQpTaWduZWQt
b2ZmLWJ5OiBHZWVydCBVeXR0ZXJob2V2ZW4gPGdlZXJ0QGxpbnV4LW02OGsub3JnPg0KLS0tDQpF
eHBvc2VkIGJ5IHRoZSAic2VsZWN0IFBDSSIgaW4gY29tbWl0IDRiZTVlODY0OGIwYzI4N2EgKCJt
ZWRpYTogbW92ZSBDRUMgcGxhdGZvcm0gZHJpdmVycyB0byBhIHNlcGFyYXRlIGRpcmVjdG9yeSIp
Lg0KLS0tDQogaW5jbHVkZS9saW51eC9hdmYvdmlydGNobmwuaCB8IDUgKysrKysNCiAxIGZpbGUg
Y2hhbmdlZCwgNSBpbnNlcnRpb25zKCspDQoNClRlc3RlZC1ieTogQW5kcmV3IEJvd2VycyA8YW5k
cmV3eC5ib3dlcnNAaW50ZWwuY29tPg0KDQoNCg0K
