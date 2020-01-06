Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBBA4131A6C
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:30:34 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727025AbgAFVa2 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:30:28 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:40540 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726760AbgAFVa2 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:30:28 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346227;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=D/sJ6L50es1DNshkAg63capa3J/f+Bkx05ifkp9iw50=;
        b=FirhrT/SMeIqqlw6Ni6QFE+7m/aJuWv1+7BN06OIqvp5sYojDuy6l0pL5gL5IvTEB6WFhC
        cqN3Q5Io9oqcyj+B1aOWM0HL6flKq/0ii/L2Sm7MurmsQDp0DHXIAN2+LxGMNsjn1siF2p
        BUabZyFf4wXKP5LU+tEa7gfzD6GpDiU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-393-CuQs2pORPmOIc0_uzyN9rA-1; Mon, 06 Jan 2020 16:30:23 -0500
X-MC-Unique: CuQs2pORPmOIc0_uzyN9rA-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 6D83D10054E3;
        Mon,  6 Jan 2020 21:30:22 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 3B2DA5C290;
        Mon,  6 Jan 2020 21:30:20 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:30:19 -0800 (PST)
Message-Id: <20200106.133019.1552234323489676036.davem@redhat.com>
To:     krzk@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: wan: sdla: Fix cast from pointer to integer of
 different size
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200104143143.6380-1-krzk@kernel.org>
References: <20200104143143.6380-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6a0BrZXJuZWwub3JnPg0KRGF0ZTogU2F0LCAg
NCBKYW4gMjAyMCAxNTozMTo0MyArMDEwMA0KDQo+IFNpbmNlIG5ldF9kZXZpY2UubWVtX3N0YXJ0
IGlzIHVuc2lnbmVkIGxvbmcsIGl0IHNob3VsZCBub3QgYmUgY2FzdCB0bw0KPiBpbnQgcmlnaHQg
YmVmb3JlIGNhc3RpbmcgdG8gcG9pbnRlci4gIFRoaXMgZml4ZXMgd2FybmluZyAoY29tcGlsZQ0K
PiB0ZXN0aW5nIG9uIGFscGhhIGFyY2hpdGVjdHVyZSk6DQo+IA0KPiAgICAgZHJpdmVycy9uZXQv
d2FuL3NkbGEuYzogSW4gZnVuY3Rpb24goXNkbGFfdHJhbnNtaXSiOg0KPiAgICAgZHJpdmVycy9u
ZXQvd2FuL3NkbGEuYzo3MTE6MTM6IHdhcm5pbmc6DQo+ICAgICAgICAgY2FzdCB0byBwb2ludGVy
IGZyb20gaW50ZWdlciBvZiBkaWZmZXJlbnQgc2l6ZSBbLVdpbnQtdG8tcG9pbnRlci1jYXN0XQ0K
PiANCj4gU2lnbmVkLW9mZi1ieTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6a0BrZXJuZWwub3Jn
Pg0KDQpBcHBsaWVkLg0K

