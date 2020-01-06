Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C4BCF131A73
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:32:04 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726794AbgAFVcC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:32:02 -0500
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24087 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726713AbgAFVcC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:32:02 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346320;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=XiXBOwIesFh04X7+/5jDrRr4txiFi4Mcnlwaam3kiKM=;
        b=XyiaIvA3y49vAu4ofMCXuGgqUvDqyGtu4QdKXeUVm6BXVcFAR7PvvrJKW5GmEbg83tpmlU
        s7NuKgeD1sFonQ0/iS4/B6i2jf+0VNmMcmLOHrE2jJ3LQWDJdmc/ZvJQ3SaCjsRWgIBIoH
        97yWXFubuwkEKqNVZY8o3P6/Y2yFmGA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-265-ajXQLeimMPKpFY-Ki2s9uw-1; Mon, 06 Jan 2020 16:31:59 -0500
X-MC-Unique: ajXQLeimMPKpFY-Ki2s9uw-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 4882D10054E3;
        Mon,  6 Jan 2020 21:31:58 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 2E9165D9CA;
        Mon,  6 Jan 2020 21:31:56 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:31:55 -0800 (PST)
Message-Id: <20200106.133155.1221137250116950495.davem@redhat.com>
To:     krzk@kernel.org
Cc:     netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] net: ethernet: 3c515: Fix cast from pointer to
 integer of different size
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200104143306.21210-1-krzk@kernel.org>
References: <20200104143306.21210-1-krzk@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=iso-8859-7
Content-Transfer-Encoding: base64
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

RnJvbTogS3J6eXN6dG9mIEtvemxvd3NraSA8a3J6a0BrZXJuZWwub3JnPg0KRGF0ZTogU2F0LCAg
NCBKYW4gMjAyMCAxNTozMzowNSArMDEwMA0KDQo+IFBvaW50ZXIgcGFzc2VkIGFzIGludGVnZXIg
c2hvdWxkIGJlIGNhc3QgdG8gdW5zaWduZWQgbG9uZyB0bw0KPiBhdm9pZCB3YXJuaW5nIChjb21w
aWxlIHRlc3Rpbmcgb24gYWxwaGEgYXJjaGl0ZWN0dXJlKToNCj4gDQo+ICAgICBkcml2ZXJzL25l
dC9ldGhlcm5ldC8zY29tLzNjNTE1LmM6IEluIGZ1bmN0aW9uIKFjb3Jrc2NyZXdfc3RhcnRfeG1p
dKI6DQo+ICAgICBkcml2ZXJzL25ldC9ldGhlcm5ldC8zY29tLzNjNTE1LmM6MTA2Njo4OiB3YXJu
aW5nOg0KPiAgICAgICAgIGNhc3QgZnJvbSBwb2ludGVyIHRvIGludGVnZXIgb2YgZGlmZmVyZW50
IHNpemUgWy1XcG9pbnRlci10by1pbnQtY2FzdF0NCj4gDQo+IFNpZ25lZC1vZmYtYnk6IEtyenlz
enRvZiBLb3psb3dza2kgPGtyemtAa2VybmVsLm9yZz4NCj4gDQo+IC0tLQ0KPiANCj4gT25seSBj
b21waWxlIHRlc3RlZA0KDQpTb3JyeSwgSSdtIG5vdCBhcHBseWluZyB0aGVzZSB0d28uDQoNCkl0
IGlzIGNsZWFyIHRoYXQgdGhlc2UgZHJpdmVycyBvbmx5IHdvcmsgcHJvcGVybHkgb24gMzItYml0
IGFyY2hpdGVjdHVyZXMNCndoZXJlIHZpcnR1YWwgYWRkcmVzcyBlcXVhbHMgdGhlIERNQSBhZGRy
ZXNzLg0KDQpNYWtpbmcgdGhpcyB3YXJuaW5nIGdvZXMgYXdheSBjcmVhdGVzIGEgZmFsc2Ugc2Vu
c2UgdGhhdCB0aGV5IGFyZSBpbg0KZmFjdCA2NC1iaXQgY2xlYW4gYW5kIGNhcGFibGUsIHRoZXkg
YXJlIG5vdC4NCg==

