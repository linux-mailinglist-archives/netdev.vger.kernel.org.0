Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 63387131A92
	for <lists+netdev@lfdr.de>; Mon,  6 Jan 2020 22:36:13 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726774AbgAFVgK (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jan 2020 16:36:10 -0500
Received: from us-smtp-delivery-1.mimecast.com ([207.211.31.120]:39816 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1726713AbgAFVgK (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jan 2020 16:36:10 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1578346569;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=emzzafBpSFz6uRW0DN5iJAM0+UGzONZS2zNxagu73Qw=;
        b=E0Nk94AY02rgomdf7X0Wd52ZCqtmrS0JaJt3iDOUis4MgP6oB4FbMXgmZkv65UPOOCtGaI
        lqsYBdTlqtHaPOeuPdFQhdJciiyLuA8t6fkqSIo64hTQLg2gNT/3IqnVopwR9bqQdIvYun
        MB+Vi+QHgKI5K/+YhJmbMmEZ2vLRHQM=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-313-dyQyQsQ8NZurwYpIFEJdlQ-1; Mon, 06 Jan 2020 16:36:05 -0500
X-MC-Unique: dyQyQsQ8NZurwYpIFEJdlQ-1
Received: from smtp.corp.redhat.com (int-mx04.intmail.prod.int.phx2.redhat.com [10.5.11.14])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id A24CE107ACC9;
        Mon,  6 Jan 2020 21:36:04 +0000 (UTC)
Received: from localhost (ovpn-112-4.rdu2.redhat.com [10.10.112.4])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 27A1A5D9CA;
        Mon,  6 Jan 2020 21:36:02 +0000 (UTC)
Date:   Mon, 06 Jan 2020 13:36:01 -0800 (PST)
Message-Id: <20200106.133601.272741948830304328.davem@redhat.com>
To:     andrew@lunn.ch
Cc:     netdev@vger.kernel.org, vivien.didelot@gmail.com, cphealy@gmail.com
Subject: Re: [PATCH net v2] net: dsa: mv88e6xxx: Preserve priority when
 setting CPU port.
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200104221451.10379-1-andrew@lunn.ch>
References: <20200104221451.10379-1-andrew@lunn.ch>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.14
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Andrew Lunn <andrew@lunn.ch>
Date: Sat,  4 Jan 2020 23:14:51 +0100

> The 6390 family uses an extended register to set the port connected to
> the CPU. The lower 5 bits indicate the port, the upper three bits are
> the priority of the frames as they pass through the switch, what
> egress queue they should use, etc. Since frames being set to the CPU
> are typically management frames, BPDU, IGMP, ARP, etc set the priority
> to 7, the reset default, and the highest.
> 
> Fixes: 33641994a676 ("net: dsa: mv88e6xxx: Monitor and Management tables")
> Signed-off-by: Andrew Lunn <andrew@lunn.ch>
> 
> ---
> v2: Fix a couple of spelling errors.

Applied and queued up for -stable, thanks Andrew.

