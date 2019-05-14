Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 2E0381CA70
	for <lists+netdev@lfdr.de>; Tue, 14 May 2019 16:33:27 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726098AbfENOdY (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 14 May 2019 10:33:24 -0400
Received: from mx1.redhat.com ([209.132.183.28]:39036 "EHLO mx1.redhat.com"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1725928AbfENOdY (ORCPT <rfc822;netdev@vger.kernel.org>);
        Tue, 14 May 2019 10:33:24 -0400
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mx1.redhat.com (Postfix) with ESMTPS id 1351C307C94F;
        Tue, 14 May 2019 14:33:16 +0000 (UTC)
Received: from localhost (ovpn-200-27.brq.redhat.com [10.40.200.27])
        by smtp.corp.redhat.com (Postfix) with ESMTPS id E24155C5BB;
        Tue, 14 May 2019 14:33:12 +0000 (UTC)
Date:   Tue, 14 May 2019 16:33:08 +0200
From:   Stefano Brivio <sbrivio@redhat.com>
To:     Mikael Magnusson <mikael.kernel@lists.m7n.se>
Cc:     Wei Wang <weiwan@google.com>, David Ahern <dsahern@gmail.com>,
        Linux Kernel Network Developers <netdev@vger.kernel.org>,
        Martin KaFai Lau <kafai@fb.com>
Subject: Re: IPv6 PMTU discovery fails with source-specific routing
Message-ID: <20190514163308.2f870f27@redhat.com>
In-Reply-To: <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
References: <71e7331f-d528-430e-f880-e995ff53d362@lists.m7n.se>
        <2667a075-7a51-d1e0-c4e7-cf0d011784b9@gmail.com>
        <CAEA6p_AddQqy+v+LUT6gsqOC31RhMkVnZPLja8a4n9XQmK8TRA@mail.gmail.com>
Organization: Red Hat
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.16 (mx1.redhat.com [10.5.110.46]); Tue, 14 May 2019 14:33:24 +0000 (UTC)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 13 May 2019 23:12:31 -0700
Wei Wang <weiwan@google.com> wrote:

> Thanks Mikael for reporting this issue. And thanks David for the bisection.
> Let me spend some time to reproduce it and see what is going on.

Mikael, by the way, once this is sorted out, it would be nice if you
could add your test as a case in tools/testing/selftests/net/pmtu.sh --
you could probably reuse all the setup parts that are already
implemented there.

-- 
Stefano
