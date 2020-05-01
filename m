Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id CAF231C0CEA
	for <lists+netdev@lfdr.de>; Fri,  1 May 2020 05:57:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728226AbgEAD5O (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 Apr 2020 23:57:14 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:46146 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727889AbgEAD5O (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 Apr 2020 23:57:14 -0400
Received: from shards.monkeyblade.net (shards.monkeyblade.net [IPv6:2620:137:e000::1:9])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 83586C035494
        for <netdev@vger.kernel.org>; Thu, 30 Apr 2020 20:57:10 -0700 (PDT)
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 3EC921277C5B0;
        Thu, 30 Apr 2020 20:57:10 -0700 (PDT)
Date:   Thu, 30 Apr 2020 20:57:09 -0700 (PDT)
Message-Id: <20200430.205709.487917711279767086.davem@davemloft.net>
To:     zhengbin13@huawei.com
Cc:     aviad.krawczyk@huawei.com, netdev@vger.kernel.org
Subject: Re: [PATCH -next] hinic: remove set but not used variable 'func_id'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200429012358.30007-1-zhengbin13@huawei.com>
References: <20200429012358.30007-1-zhengbin13@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 Apr 2020 20:57:10 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWmhlbmcgQmluIDx6aGVuZ2JpbjEzQGh1YXdlaS5jb20+DQpEYXRlOiBXZWQsIDI5IEFw
ciAyMDIwIDA5OjIzOjU3ICswODAwDQoNCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZh
cmlhYmxlJyB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvaHVhd2VpL2hpbmlj
L2hpbmljX3NyaW92LmM6NzkyOjY6IHdhcm5pbmc6IHZhcmlhYmxlIKFmdW5jX2lkoiBzZXQgYnV0
IG5vdCB1c2VkIFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gSXQgaXMgaW50cm9k
dWNlZCBieSBjb21taXQgN2RkMjllZTEyODY1ICgiaGluaWM6DQo+IGFkZCBzcmlvdiBmZWF0dXJl
IHN1cHBvcnQiKSwgYnV0IG5ldmVyIHVzZWQsDQo+IHNvIHJlbW92ZSBpdC4NCj4gDQo+IFJlcG9y
dGVkLWJ5OiBIdWxrIFJvYm90IDxodWxrY2lAaHVhd2VpLmNvbT4NCj4gU2lnbmVkLW9mZi1ieTog
WmhlbmcgQmluIDx6aGVuZ2JpbjEzQGh1YXdlaS5jb20+DQoNClRoaXMgZG9lcyBub3QgYXBwbHkg
Y2xlYW5seSB0byB0aGUgbmV0LW5leHQgdHJlZS4NCg==
