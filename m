Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 8D2AA2A289A
	for <lists+netdev@lfdr.de>; Mon,  2 Nov 2020 11:59:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728339AbgKBK7x (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 2 Nov 2020 05:59:53 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:51817 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1728253AbgKBK7x (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 2 Nov 2020 05:59:53 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1604314791;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type;
        bh=eKEJ52i3XHiIzCwHKWSh0hNFFgPU3jEJSM/4ne2hDYQ=;
        b=Zw/oUO7Tf07Cfly7KFIKXOkej1BIkpTTUGxgIfJxGf0bhON4CiLy+6FfzqsozWCeZt1hiM
        f+LgN/HWk5tJnUcKL5EfJjNtVULlANovnEnOzUE76Tfd4b/ByM2lSgF8q4L2i+Nu2it/IV
        hoG4Ptbr0hJljcmLjcyOzHOwxmdX+WE=
Received: from mail-wm1-f70.google.com (mail-wm1-f70.google.com
 [209.85.128.70]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-465-A1VTeZq9NBeJbj9imMkVog-1; Mon, 02 Nov 2020 05:59:50 -0500
X-MC-Unique: A1VTeZq9NBeJbj9imMkVog-1
Received: by mail-wm1-f70.google.com with SMTP id c204so3204329wmd.5
        for <netdev@vger.kernel.org>; Mon, 02 Nov 2020 02:59:50 -0800 (PST)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:mime-version
         :content-disposition;
        bh=eKEJ52i3XHiIzCwHKWSh0hNFFgPU3jEJSM/4ne2hDYQ=;
        b=a6yifzo6mqtCAnHM24Qf6H/5hOPj8BqfUtt/MiHbEVyhi3h1zflHAGWIrN2MuWBWyv
         D+ycxYilyIvWPf1Uf8yMP2iVVbKbdEFHNgd3Pt4PsLfUKOme6/GkESk7EuhIvT3KG87N
         n543kp0w7Y9j0PH/kaRzdldq0qgpvJmmYSfAfZG6Pmn1Ta/2L3HI+F/DgeIelpMRDI1j
         6MMGI/vyGyEh3Kh6VSn5dX6ioOylRo86UMbXm3xcJDFaKX7kl6ytVG6+fWzvQu5hJo2N
         McYRodsGT/QeN56v/pFoD4zzfOAUpu9bCI+vH7EfsDbD9/1b2TNY5t0/OUY3HWCaZH3t
         E06Q==
X-Gm-Message-State: AOAM533hNayXL17Nw4IaG0HoWXeYo1OrddP0yYPiAb8I9tMplQB+E1l/
        zZLZJfHRWh3sf6y+GH/x4yafiVanS5vnON0UpG32sMcPvghXu7eNAapjIBXJV0blPgIXhbXmSgr
        7OxvRMRywnj3D/Vkz
X-Received: by 2002:adf:f109:: with SMTP id r9mr19619980wro.100.1604314788866;
        Mon, 02 Nov 2020 02:59:48 -0800 (PST)
X-Google-Smtp-Source: ABdhPJymu7BD5bR8ek2ST88dzIKtjLTX082LaMOQGutuJ6hjeQ/lplHtJxTx+WlzMzCHziebH0EfNA==
X-Received: by 2002:adf:f109:: with SMTP id r9mr19619962wro.100.1604314788658;
        Mon, 02 Nov 2020 02:59:48 -0800 (PST)
Received: from linux.home (2a01cb058918ce00dd1a5a4f9908f2d5.ipv6.abo.wanadoo.fr. [2a01:cb05:8918:ce00:dd1a:5a4f:9908:f2d5])
        by smtp.gmail.com with ESMTPSA id i6sm8870863wma.42.2020.11.02.02.59.47
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 02 Nov 2020 02:59:48 -0800 (PST)
Date:   Mon, 2 Nov 2020 11:59:46 +0100
From:   Guillaume Nault <gnault@redhat.com>
To:     Stephen Hemminger <stephen@networkplumber.org>
Cc:     netdev@vger.kernel.org
Subject: [PATCH iproute2] tc-vlan: fix help and error message strings
Message-ID: <d135c4b67496e00dbb4ad91f5a38feee2d4ea075.1604314759.git.gnault@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

 * "vlan pop" can be followed by a CONTROL keyword.

 * Add missing space in error message.

Signed-off-by: Guillaume Nault <gnault@redhat.com>
---
 tc/m_vlan.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/tc/m_vlan.c b/tc/m_vlan.c
index e6b21330..57722b73 100644
--- a/tc/m_vlan.c
+++ b/tc/m_vlan.c
@@ -30,7 +30,7 @@ static const char * const action_names[] = {
 static void explain(void)
 {
 	fprintf(stderr,
-		"Usage: vlan pop\n"
+		"Usage: vlan pop [CONTROL]\n"
 		"       vlan push [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
 		"       vlan modify [ protocol VLANPROTO ] id VLANID [ priority VLANPRIO ] [CONTROL]\n"
 		"       vlan pop_eth [CONTROL]\n"
@@ -244,7 +244,7 @@ static int print_vlan(struct action_util *au, FILE *f, struct rtattr *arg)
 	parse_rtattr_nested(tb, TCA_VLAN_MAX, arg);
 
 	if (!tb[TCA_VLAN_PARMS]) {
-		fprintf(stderr, "Missing vlanparameters\n");
+		fprintf(stderr, "Missing vlan parameters\n");
 		return -1;
 	}
 	parm = RTA_DATA(tb[TCA_VLAN_PARMS]);
-- 
2.21.3

