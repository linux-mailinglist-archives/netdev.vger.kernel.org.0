Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 83670131AAD
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:47:35 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727027AbgAFVr1 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:47:27 -0500
Received: from us-smtp-1.mimecast.com ([205.139.110.61]:43940 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726695AbgAFVr1 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:47:27 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578347246;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=6Vy5rJf3jDQC7AqDYWep0rmJuLYgMy0o4s+Esk5loC4=;
        b=ef/fcSoaNFRHOr2f+AG1oS63uG9q9iqBSFMdkUTQTqU5L4TRHVJpvgq4+Sf0TwXl36TlRk
        ngnfW7LVw0Zx1MvECqnT9iLbTJXUU4QYuSOj6S7JtC7ghUER+FpDhcuQFgYyt7QLm/M9h3
        iuW5qP+yml+kE4dpoXQAk9XOpp72QOA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-426-QNgoUuPDPAGraRB5vI7tmw-1; Mon, 06 Jan 2020 16:47:22 -0500
X-MC-Unique: QNgoUuPDPAGraRB5vI7tmw-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 67596107ACC4;
        Mon,  6 Jan 2020 21:47:21 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 0993585882;
        Mon,  6 Jan 2020 21:47:19 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:47:18 -0800 (PST)
Message-Id: <20200106.134718.1421984985726144048.davem@redhat.com>
To:     dsahern@kernel.org
Cc:     jakub.kicinski@netronome.com, netdev@vger.kernel.org,
        dsahern@gmail.com
Subject: Re: [PATCH net-next] fcnal-test: Fix vrf argument in local tcp
 tests
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200106040205.29291-1-dsahern@kernel.org>
References: <20200106040205.29291-1-dsahern@kernel.org>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: David Ahern <dsahern@kernel.org>
Date: Sun,  5 Jan 2020 20:02:05 -0800

> From: David Ahern <dsahern@gmail.com>
> 
> The recent MD5 tests added duplicate configuration in the default VRF.
> This change exposed a bug in existing tests designed to verify no
> connection when client and server are not in the same domain. The
> server should be running bound to the vrf device with the client run
> in the default VRF (the -2 option is meant for validating connection
> data). Fix the option for both tests.
> 
> While technically this is a bug in previous releases, the tests are
> properly failing since the default VRF does not have any routing
> configuration so there really is no need to backport to prior releases.
> 
> Signed-off-by: David Ahern <dsahern@gmail.com>

Applied.

