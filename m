Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 6A8D91D0424
	for <lists+netdev@lfdr.de>; Wed, 13 May 2020 03:03:04 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1731859AbgEMBDC (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 12 May 2020 21:03:02 -0400
Received: from us-smtp-2.mimecast.com ([205.139.110.61]:49927 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728131AbgEMBDC (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 12 May 2020 21:03:02 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1589331781;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Rtv6O7pr8DdHkygZD/6apr70RNgbpRPRvtCIz8c413A=;
        b=JE/choUFIBemu72Z7KGPwyOhifSh89YGLJS4NW/uQqy8HHhQgpuzRR42CBa6rW5i+zJXXC
        GebKIW2TcyioIcgM+81++Ed8V/6Fw+on7mZbotCUYrFMMPMRdVwoV+JoNwFaY4djKDVScW
        e05ErG+cqmwXNI5rPQyImCdL0ay5two=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-414-P-XmVjiHMsut_RmAUKzqcA-1; Tue, 12 May 2020 21:02:58 -0400
X-MC-Unique: P-XmVjiHMsut_RmAUKzqcA-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 8CA6E473;
        Wed, 13 May 2020 01:02:57 +0000 (UTC)
Received: from localhost (unknown [10.10.110.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id A368C38E;
        Wed, 13 May 2020 01:02:55 +0000 (UTC)
Date:   Tue, 12 May 2020 18:02:54 -0700 (PDT)
Message-Id: <20200512.180254.1087908389957071261.davem@redhat.com>
To:     olteanv@gmail.com
Cc:     andrew@lunn.ch, f.fainelli@gmail.com, vivien.didelot@gmail.com,
        netdev@vger.kernel.org
Subject: Re: [PATCH net-next] net: dsa: tag_sja1105: appease sparse checks
 for ethertype accessors
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200513002327.13637-1-olteanv@gmail.com>
References: <20200513002327.13637-1-olteanv@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Vladimir Oltean <olteanv@gmail.com>
Date: Wed, 13 May 2020 03:23:27 +0300

> A comparison between a value from the packet and an integer constant
> value needs to be done by converting the value from the packet from
> net->host, or the constant from host->net. Not the other way around.
> Even though it makes no practical difference, correct that.
> 
> Fixes: 38b5beeae7a4 ("net: dsa: sja1105: prepare tagger for handling DSA tags and VLAN simultaneously")
> Signed-off-by: Vladimir Oltean <olteanv@gmail.com>

Applied.

