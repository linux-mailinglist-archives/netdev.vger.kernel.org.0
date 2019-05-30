Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7C92D30311
	for <lists+netdev@lfdr.de>; Thu, 30 May 2019 21:58:37 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726446AbfE3T6f (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 30 May 2019 15:58:35 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59346 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725897AbfE3T6e (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 30 May 2019 15:58:34 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d5])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id CB63714DAB306;
        Thu, 30 May 2019 12:58:33 -0700 (PDT)
Date:   Thu, 30 May 2019 12:58:33 -0700 (PDT)
Message-Id: <20190530.125833.1049383711116106790.davem@davemloft.net>
To:     richardcochran@gmail.com
Cc:     netdev@vger.kernel.org, devicetree@vger.kernel.org, andrew@lunn.ch,
        f.fainelli@gmail.com, jacob.e.keller@intel.com,
        mark.rutland@arm.com, mlichvar@redhat.com, robh+dt@kernel.org,
        willemb@google.com
Subject: Re: [PATCH V4 net-next 0/6] Peer to Peer One-Step time stamping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190530.115507.1344606945620280103.davem@davemloft.net>
References: <cover.1559109076.git.richardcochran@gmail.com>
        <20190530.115507.1344606945620280103.davem@davemloft.net>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Thu, 30 May 2019 12:58:34 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogRGF2aWQgTWlsbGVyIDxkYXZlbUBkYXZlbWxvZnQubmV0Pg0KRGF0ZTogVGh1LCAzMCBN
YXkgMjAxOSAxMTo1NTowNyAtMDcwMCAoUERUKQ0KDQo+IFNlcmllcyBhcHBsaWVkLCB0aGFua3Mg
UmljaGFyZC4NCg0KSSBoYWQgdG8gcmV2ZXJ0LCB0aGlzIGRvZXNuJ3QgYnVpbGQuDQoNCmRyaXZl
cnMvcHRwL3B0cF9pbmVzLmM6IEluIGZ1bmN0aW9uIKFpbmVzX3R4dHN0YW1wojoNCmRyaXZlcnMv
cHRwL3B0cF9pbmVzLmM6Njc0OjM6IHdhcm5pbmc6IKFvbGRfc2tioiBtYXkgYmUgdXNlZCB1bmlu
aXRpYWxpemVkIGluIHRoaXMgZnVuY3Rpb24gWy1XbWF5YmUtdW5pbml0aWFsaXplZF0NCiAgIGtm
cmVlX3NrYihvbGRfc2tiKTsNCiAgIF5+fn5+fn5+fn5+fn5+fn5+fg0KZHJpdmVycy9uZXQvbWFj
dmxhbi5jOiBJbiBmdW5jdGlvbiChbWFjdmxhbl9ldGh0b29sX2dldF90c19pbmZvojoNCmRyaXZl
cnMvbmV0L21hY3ZsYW4uYzoxMDU5OjQyOiBlcnJvcjogoXN0cnVjdCBwaHlfZHJpdmVyoiBoYXMg
bm8gbWVtYmVyIG5hbWVkIKF0c19pbmZvog0KICBpZiAocGh5ZGV2ICYmIHBoeWRldi0+ZHJ2ICYm
IHBoeWRldi0+ZHJ2LT50c19pbmZvKSB7DQogICAgICAgICAgICAgICAgICAgICAgICAgICAgICAg
ICAgICAgICAgICBefg0KZHJpdmVycy9uZXQvbWFjdmxhbi5jOjEwNjA6MjI6IGVycm9yOiChc3Ry
dWN0IHBoeV9kcml2ZXKiIGhhcyBubyBtZW1iZXIgbmFtZWQgoXRzX2luZm+iDQogICAgcmV0dXJu
IHBoeWRldi0+ZHJ2LT50c19pbmZvKHBoeWRldiwgaW5mbyk7DQogICAgICAgICAgICAgICAgICAg
ICAgXn4NCg==
