Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2CDFA2AFF5A
	for <lists+netdev@lfdr.de>; Thu, 12 Nov 2020 06:46:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727256AbgKLFcY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 12 Nov 2020 00:32:24 -0500
Received: from m176149.mail.qiye.163.com ([59.111.176.149]:25513 "EHLO
        m176149.mail.qiye.163.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727985AbgKLCsn (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Nov 2020 21:48:43 -0500
Received: from vivo.com (wm-9.qy.internal [127.0.0.1])
        by m176149.mail.qiye.163.com (Hmail) with ESMTP id C7B74282E88;
        Thu, 12 Nov 2020 10:48:37 +0800 (CST)
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: base64
Message-ID: <AN*A-ACtDVzmm*z9RWHEvaqz.3.1605149317799.Hmail.wangqing@vivo.com>
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
In-Reply-To: <20201111173218.25f89965@kicinski-fedora-pc1c0hjn.dhcp.thefacebook.com>
MIME-Version: 1.0
Received: from wangqing@vivo.com( [58.213.83.156) ] by ajax-webmail ( [127.0.0.1] ) ; Thu, 12 Nov 2020 10:48:37 +0800 (GMT+08:00)
From:   =?UTF-8?B?546L5pOO?= <wangqing@vivo.com>
Date:   Thu, 12 Nov 2020 10:48:37 +0800 (GMT+08:00)
X-HM-Spam-Status: e1kfGhgUHx5ZQUtXWQgYFAkeWUFZS1VLWVdZKFlBSE83V1ktWUFJV1kPCR
        oVCBIfWUFZGUMZSxkZTE5KSxpOVkpNS05KT0JISkxDSEhVEwETFhoSFyQUDg9ZV1kWGg8SFR0UWU
        FZT0tIVUpKS0hKTFVLWQY+
X-HM-Sender-Digest: e1kJHlYWEh9ZQU5CTUJNT05LSEpNN1dZDB4ZWUEPCQ4eV1kSHx4VD1lB
        WUc6NVE6Vjo4Dz8tARYWUQFCKSwzPg0aCgFVSFVKTUtOSk9CSEpDSUJLVTMWGhIXVQwaFRwKEhUc
        Ow0SDRRVGBQWRVlXWRILWUFZTkNVSUpIVUNIVUpOTVlXWQgBWUFISkpONwY+
X-HM-Tid: 0a75ba5adabd9395kuwsc7b74282e88
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Pk9uIFRodSwgMTIgTm92IDIwMjAgMDk6MTU6MDUgKzA4MDAgKEdNVCswODowMCkg546L5pOOIHdy
b3RlOgo+PiA+R3J5Z29yaWksIHdvdWxkIHlvdSBtaW5kIHNlbmRpbmcgYSBjb3JyZWN0IHBhdGNo
IGluIHNvIFdhbmcgUWluZyBjYW4KPj4gPnNlZSBob3cgaXQncyBkb25lPyBJJ3ZlIGJlZW4gYXNr
aW5nIGZvciBhIGZpeGVzIHRhZyBtdWx0aXBsZSB0aW1lcwo+PiA+YWxyZWFkeSA6KCAgCj4+IAo+
PiBJIHN0aWxsIGRvbid0IHF1aXRlIHVuZGVyc3RhbmQgd2hhdCBhIGZpeGVzIHRhZyBtZWFuc++8
jAo+PiBjYW4geW91IHRlbGwgbWUgaG93IHRvIGRvIHRoaXMsIHRoYW5rcy4KPgo+UGxlYXNlIHJl
YWQ6IERvY3VtZW50YXRpb24vcHJvY2Vzcy9zdWJtaXR0aW5nLXBhdGNoZXMucnN0Cj4KPllvdSBj
YW4gc2VhcmNoIGZvciAiRml4ZXM6IgoKSSBzZWUsIGJ1dCB0aGlzIGJ1ZyBpcyBub3QgY2F1c2Vk
IGJ5IGEgc3BlY2lmaWMgcGF0Y2gsIGl0IGV4aXN0cyBhdCB0aGUgYmVnaW5uaW5nLCBzbyAKdGhl
cmUgaXMgbm8gbmVlZCB0byBhZGQgYSBmaXhlcyB0YWcuIFBsZWFzZSBwb2ludCBvdXQgaWYgSSB1
bmRlcnN0YW5kIGl0IGluY29ycmVjdGx5LHRoYW5rcyEKCldhbmcgUWluZwoNCg0K
