Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 434042AFC27
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 02:33:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728556AbgKLBdO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Nov 2020 20:33:14 -0500
Received: from m176149.mail.qiye.163.com ([59.111.176.149]:35525 "EHLO
        m176149.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728238AbgKLBYU (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 20:24:20 -0500
X-Greylist: delayed 552 seconds by postgrey-1.27 at vger.kernel.org; Wed, 11 Nov 2020 20:24:20 EST
Received: from vivo.com (wm-9.qy.internal [127.0.0.1])
        by m176149.mail.qiye.163.com (Hmail) with ESMTP id 364D928269E;
        Thu, 12 Nov 2020 09:15:05 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AFoANwC7DUvmHhxeg4sBAapD.3.1605143705212.Hmail.wangqing@vivo.com>
To:     Jakub Kicinski <kuba@kernel.org>
Cc:     Richard Cochran <richardcochran@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        "David S. Miller" <davem@davemloft.net>,
        Samuel Zou <zou_wei@huawei.com>,
        Kurt Kanzenbach <kurt@linutronix.de>,
        Ivan Khoronzhuk <ivan.khoronzhuk@linaro.org>,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: =?UTF-8?B?UmU6UmU6IFtQQVRDSCBWNCBuZXQtYnVnZml4c10gbmV0L2V0aGVybmV0OiBVcGRhdGUgcmV0IHdoZW4gcHRwX2Nsb2NrIGlzIEVSUk9S?=
X-Priority: 3
X-Mailer: HMail Webmail Server V2.0 Copyright (c) 2016-163.com
X-Originating-IP: 58.213.83.156
In-Reply-To: <20201111080027.7830f756@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Received: from wangqing@vivo.com( [58.213.83.156) ] by ajax-webmail ( [127.0.0.1] ) ; Thu, 12 Nov 2020 09:15:05 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Date:   Thu, 12 Nov 2020 09:15:05 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZSR9KHkNKHU1MQxpPVkpNS05KT0hMS05JTUpVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kJHlYWEh9ZQU5CTUJKS09CSEtON1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6PRQ6NQw4TD8uDRYzEwMeHE8IOToaCz9VSFVKTUtOSk9ITEtOTUNNVTMWGhIXVQwaFRwKEhUc
        Ow0SDRRVGBQWRVlXWRILWUFZTkNVSUpIVUNIVUpOTVlXWQgBWUFIT0NONwY+
X-HM-Tid: 0a75ba0536899395kuws364d928269e
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pj4gT24gV2VkLCBOb3YgMTEsIDIwMjAgYXQgMDM6MjQ6MzNQTSArMDIwMCwgR3J5Z29yaWkgU3Ry
YXNoa28gd3JvdGU6Cj4+ID4gCj4+ID4gRm9sbG93aW5nIFJpY2hhcmQncyBjb21tZW50cyB2MSBv
ZiB0aGUgcGF0Y2ggaGFzIHRvIGJlIGFwcGxpZWQgWzFdLgo+PiA+IEkndmUgYWxzbyBhZGRlZCBt
eSBSZXZpZXdlZC1ieSB0aGVyZS4KPj4gPiAKPj4gPiBbMV0gaHR0cHM6Ly9sb3JlLmtlcm5lbC5v
cmcvcGF0Y2h3b3JrL3BhdGNoLzEzMzQwNjcvICAKPj4gCj4+ICsxCj4+IAo+PiBKYWt1YiwgY2Fu
IHlvdSBwbGVhc2UgdGFrZSB0aGUgb3JpZ2luYWwgdjEgb2YgdGhpcyBwYXRjaD8KPgo+SSBkb24n
dCB0aGluayB2MSBidWlsZHMgY2xlYW5seSBmb2xrcyAobm90IDEwMCUgc3VyZSwgY3B0cyBpcyBu
b3QKPmNvbXBpbGVkIG9uIHg4Nik6Cj4KPgkJcmV0ID0gY3B0cy0+cHRwX2Nsb2NrID8gY3B0cy0+
cHRwX2Nsb2NrIDogKC1FTk9ERVYpOwo+Cj5wdHBfY2xvY2sgaXMgYSBwb2ludGVyLCByZXQgaXMg
YW4gaW50ZWdlciwgcmlnaHQ/Cgp5ZWFoLCBJIHdpbGwgbW9kaWZ5IGxpa2U6IHJldCA9IGNwdHMt
PnB0cF9jbG9jayA/IFBUUl9FUlIoY3B0cy0+cHRwX2Nsb2NrKSA6IC1FTk9ERVY7Cgo+Cj5Hcnln
b3JpaSwgd291bGQgeW91IG1pbmQgc2VuZGluZyBhIGNvcnJlY3QgcGF0Y2ggaW4gc28gV2FuZyBR
aW5nIGNhbgo+c2VlIGhvdyBpdCdzIGRvbmU/IEkndmUgYmVlbiBhc2tpbmcgZm9yIGEgZml4ZXMg
dGFnIG11bHRpcGxlIHRpbWVzCj5hbHJlYWR5IDooCgpJIHN0aWxsIGRvbid0IHF1aXRlIHVuZGVy
c3RhbmQgd2hhdCBhIGZpeGVzIHRhZyBtZWFuc++8jApjYW4geW91IHRlbGwgbWUgaG93IHRvIGRv
IHRoaXMsIHRoYW5rcy4KCldhbmcgUWluZwoKDQoNCg==
