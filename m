Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 32E9B39440F
	for <lists+netdev@lfdr.de>; Fri, 28 May 2021 16:19:36 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S233081AbhE1OVI (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 28 May 2021 10:21:08 -0400
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:59302 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S231366AbhE1OVC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Fri, 28 May 2021 10:21:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1622211565;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding;
        bh=fQ954OKfMIF6Nw6avV7DSUN3bCncege2EU7XQVy/Ai0=;
        b=FDTgAa/QpaiuczAGveLWv8tmuipw0ByHcec9yAWRF89na1eRdNdAeKGn9UhnCsJgE7dJiF
        uvY+ssN7PV4HxUZ0klmBARnDunPvsv8EwNzVLXisvNYYQyODbOjTTxy+z4auz2zFgyFpux
        L/cBU+Rg4gQUK9tJ3OAosAfQHbj+lNc=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-21-Hi-BMKgZNAWu7zMHjosl4w-1; Fri, 28 May 2021 10:19:23 -0400
X-MC-Unique: Hi-BMKgZNAWu7zMHjosl4w-1
Received: from smtp.corp.redhat.com (int-mx05.intmail.prod.int.phx2.redhat.com [10.5.11.15])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C8645107ACE4;
        Fri, 28 May 2021 14:19:22 +0000 (UTC)
Received: from carbon (unknown [10.36.110.39])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 7900B5D6A8;
        Fri, 28 May 2021 14:19:18 +0000 (UTC)
Date:   Fri, 28 May 2021 16:19:17 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     BPF-dev-list <bpf@vger.kernel.org>
Cc:     brouer@redhat.com,
        XDP-hints working-group <xdp-hints@xdp-project.net>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
Subject: XDP-hints working group mailing list is active
Message-ID: <20210528161917.0810d5ca@carbon>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.15
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Hi BPF-community,

We have created a mailing list for the XDP-hints working group (Cc'ed).
Some of you have already been subscribed. If you want to subscribe or
unsubscribe please visit the link[0] below:

 [0] https://lists.xdp-project.net/postorius/lists/xdp-hints.xdp-project.net/

Remember we prefer to keep the upstream discussion on bpf@vger.kernel.org.
This list should be Cc'ed for topics related to XDP-hints.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

