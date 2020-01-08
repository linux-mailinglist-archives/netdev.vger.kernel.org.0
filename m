Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 0D7AD134DC3
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 21:40:25 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726742AbgAHUkX (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 15:40:23 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:47574 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726426AbgAHUkX (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 15:40:23 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1c3::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 2FC621584BD21;
        Wed,  8 Jan 2020 12:40:22 -0800 (PST)
Date:   Wed, 08 Jan 2020 12:40:21 -0800 (PST)
Message-Id: <20200108.124021.2097001545081493183.davem@davemloft.net>
To:     yukuai3@huawei.com
Cc:     klassert@kernel.org, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, willy@infradead.org, netdev@vger.kernel.org,
        yi.zhang@huawei.com, zhengbin13@huawei.com
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200106125337.40297-1-yukuai3@huawei.com>
References: <20200106125337.40297-1-yukuai3@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 08 Jan 2020 12:40:22 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogeXUga3VhaSA8eXVrdWFpM0BodWF3ZWkuY29tPg0KRGF0ZTogTW9uLCA2IEphbiAyMDIw
IDIwOjUzOjM3ICswODAwDQoNCj4gRml4ZXMgZ2NjICctV3VudXNlZC1idXQtc2V0LXZhcmlhYmxl
JyB3YXJuaW5nOg0KPiANCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvM2NvbS8zYzU5eC5jOiBJbiBm
dW5jdGlvbiChdm9ydGV4X3VwojoNCj4gZHJpdmVycy9uZXQvZXRoZXJuZXQvM2NvbS8zYzU5eC5j
OjE1NTE6OTogd2FybmluZzogdmFyaWFibGUNCj4goW1paV9yZWcxoiBzZXQgYnV0IG5vdCB1c2Vk
IFstV3VudXNlZC1idXQtc2V0LXZhcmlhYmxlXQ0KPiANCj4gSXQgaXMgbmV2ZXIgdXNlZCwgYW5k
IHNvIGNhbiBiZSByZW1vdmVkLg0KPiANCj4gU2lnbmVkLW9mZi1ieTogeXUga3VhaSA8eXVrdWFp
M0BodWF3ZWkuY29tPg0KPiAtLS0NCj4gY2hhbmdlcyBpbiBWMg0KPiAtVGhlIHJlYWQgbWlnaHQg
aGF2ZSBzaWRlIGVmZmVjdHMsIGRvbid0IHJlbW92ZSBpdC4NCg0KQXBwbGllZCB0byBuZXQtbmV4
dCwgdGhhbmsgeW91Lg0K
