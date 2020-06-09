Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 098561F323D
	for <lists+netdev@lfdr.de>; Tue,  9 Jun 2020 04:14:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726964AbgFICOm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jun 2020 22:14:42 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:38238 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726765AbgFICOm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jun 2020 22:14:42 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 39AA8C03E969
        for <netdev@vger.kernel.org>; Mon,  8 Jun 2020 19:14:42 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id EBFE3128A6AEC;
        Mon,  8 Jun 2020 19:14:41 -0700 (PDT)
Date:   Mon, 08 Jun 2020 19:14:41 -0700 (PDT)
Message-Id: <20200608.191441.2171626386019874510.davem@davemloft.net>
To:     tannerlove.kernel@gmail.com
Cc:     netdev@vger.kernel.org, tannerlove@google.com, willemb@google.com
Subject: Re: [PATCH net] selftests/net: in timestamping, strncpy needs to
 preserve null byte
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200608193715.122785-1-tannerlove.kernel@gmail.com>
References: <20200608193715.122785-1-tannerlove.kernel@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.3
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Mon, 08 Jun 2020 19:14:42 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogVGFubmVyIExvdmUgPHRhbm5lcmxvdmUua2VybmVsQGdtYWlsLmNvbT4NCkRhdGU6IE1v
biwgIDggSnVuIDIwMjAgMTU6Mzc6MTUgLTA0MDANCg0KPiBGcm9tOiB0YW5uZXJsb3ZlIDx0YW5u
ZXJsb3ZlQGdvb2dsZS5jb20+DQo+IA0KPiBJZiB1c2VyIHBhc3NlZCBhbiBpbnRlcmZhY2Ugb3B0
aW9uIGxvbmdlciB0aGFuIDE1IGNoYXJhY3RlcnMsIHRoZW4NCj4gZGV2aWNlLmlmcl9uYW1lIGFu
ZCBod3RzdGFtcC5pZnJfbmFtZSBiZWNhbWUgbm9uLW51bGwtdGVybWluYXRlZA0KPiBzdHJpbmdz
LiBUaGUgY29tcGlsZXIgd2FybmVkIGFib3V0IHRoaXM6DQo+IA0KPiB0aW1lc3RhbXBpbmcuYzoz
NTM6Mjogd2FybmluZzogoXN0cm5jcHmiIHNwZWNpZmllZCBib3VuZCAxNiBlcXVhbHMgXA0KPiBk
ZXN0aW5hdGlvbiBzaXplIFstV3N0cmluZ29wLXRydW5jYXRpb25dDQo+ICAgMzUzIHwgIHN0cm5j
cHkoZGV2aWNlLmlmcl9uYW1lLCBpbnRlcmZhY2UsIHNpemVvZihkZXZpY2UuaWZyX25hbWUpKTsN
Cj4gDQo+IEZpeGVzOiBjYjllZmYwOTc4MzEgKCJuZXQ6IG5ldyB1c2VyIHNwYWNlIEFQSSBmb3Ig
dGltZSBzdGFtcGluZyBvZiBpbmNvbWluZyBhbmQgb3V0Z29pbmcgcGFja2V0cyIpDQo+IFNpZ25l
ZC1vZmYtYnk6IFRhbm5lciBMb3ZlIDx0YW5uZXJsb3ZlQGdvb2dsZS5jb20+DQo+IEFja2VkLWJ5
OiBXaWxsZW0gZGUgQnJ1aWpuIDx3aWxsZW1iQGdvb2dsZS5jb20+DQoNCkFwcGxpZWQsIHRoYW5r
IHlvdS4NCg==
