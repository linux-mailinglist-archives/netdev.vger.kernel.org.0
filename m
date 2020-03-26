Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 4887719466E
	for <lists+netdev@lfdr.de>; Thu, 26 Mar 2020 19:22:45 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727977AbgCZSWj (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 26 Mar 2020 14:22:39 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:52348 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727026AbgCZSWj (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 26 Mar 2020 14:22:39 -0400
Received: from localhost (unknown [IPv6:2601:601:9f00:477::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id B9F8715CBB858;
        Thu, 26 Mar 2020 11:22:38 -0700 (PDT)
Date:   Thu, 26 Mar 2020 11:22:38 -0700 (PDT)
Message-Id: <20200326.112238.2304866533436838495.davem@davemloft.net>
To:     yuehaibing@huawei.com
Cc:     jcliburn@gmail.com, chris.snook@gmail.com, hkallweit1@gmail.com,
        mhabets@solarflare.com, huangfq.daxian@gmail.com, leon@kernel.org,
        colin.king@canonical.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next] atl2: remove unused variable
 'atl2_driver_string'
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20200326032150.15568-1-yuehaibing@huawei.com>
References: <20200326032150.15568-1-yuehaibing@huawei.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 26 Mar 2020 11:22:39 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogWXVlSGFpYmluZyA8eXVlaGFpYmluZ0BodWF3ZWkuY29tPg0KRGF0ZTogVGh1LCAyNiBN
YXIgMjAyMCAxMToyMTo1MCArMDgwMA0KDQo+IGRyaXZlcnMvbmV0L2V0aGVybmV0L2F0aGVyb3Mv
YXRseC9hdGwyLmM6NDA6MTk6IHdhcm5pbmc6IKFhdGwyX2RyaXZlcl9zdHJpbmeiIGRlZmluZWQg
YnV0IG5vdCB1c2VkIFstV3VudXNlZC1jb25zdC12YXJpYWJsZT1dDQo+ICBzdGF0aWMgY29uc3Qg
Y2hhciBhdGwyX2RyaXZlcl9zdHJpbmdbXSA9ICJBdGhlcm9zKFIpIEwyIEV0aGVybmV0IERyaXZl
ciI7DQo+ICAgICAgICAgICAgICAgICAgICBefn5+fn5+fn5+fn5+fn5+fn4NCj4gDQo+IGNvbW1p
dCBlYTk3Mzc0MjE0MGIgKCJuZXQvYXRoZXJvczogQ2xlYW4gYXRoZXJvcyBjb2RlIGZyb20gZHJp
dmVyIHZlcnNpb24iKQ0KPiBsZWZ0IGJlaGluZCB0aGlzLCByZW1vdmUgaXQuDQo+IA0KPiBSZXBv
cnRlZC1ieTogSHVsayBSb2JvdCA8aHVsa2NpQGh1YXdlaS5jb20+DQo+IFNpZ25lZC1vZmYtYnk6
IFl1ZUhhaWJpbmcgPHl1ZWhhaWJpbmdAaHVhd2VpLmNvbT4NCg0KQXBwbGllZC4NCg==
