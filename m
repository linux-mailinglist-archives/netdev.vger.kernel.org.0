Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7DA9114A20D
	for <lists+netdev@lfdr.de>; Mon, 27 Jan 2020 11:33:59 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729929AbgA0Kd5 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 27 Jan 2020 05:33:57 -0500
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:26466 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1729747AbgA0Kd5 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 27 Jan 2020 05:33:57 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1580121236;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=F0Hm7ss6kYkj54uX1OBqHRxkV2onI2wt308KHXeq7N0=;
        b=WkTrfJJvsPi1xMKlCH9Y3MHNhv5uTOdz5Q7RUiLcNuUKOx2BevnxHEhXbsYdH2b8O16Q8d
        8YVaKEeHsPi8Srgdt+67cn2E4WwIWAP/Ndu5WkysKc6vybrhey9bP7fFKqFPEOH1uJjCWq
        6UM2BABhYZQZ6F08cZ4S8hE3gsHdYj4=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-281-4CXON7BVM0a58o9Mauypjg-1; Mon, 27 Jan 2020 05:33:49 -0500
X-MC-Unique: 4CXON7BVM0a58o9Mauypjg-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 155BF107ACC9;
        Mon, 27 Jan 2020 10:33:48 +0000 (UTC)
Received: from localhost (ovpn-112-13.phx2.redhat.com [10.3.112.13])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 862F45C1D6;
        Mon, 27 Jan 2020 10:33:45 +0000 (UTC)
Date:   Mon, 27 Jan 2020 11:33:44 +0100 (CET)
Message-Id: <20200127.113344.201476041854846828.davem@redhat.com>
To:     michael.chan@broadcom.com
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH net-net v2 00/15] bnxt_en: Updates for net-next.
From:   David Miller <davem@redhat.com>
In-Reply-To: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
References: <1580118987-30052-1-git-send-email-michael.chan@broadcom.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Michael Chan <michael.chan@broadcom.com>
Date: Mon, 27 Jan 2020 04:56:12 -0500

> This patch-set includes link up and link initialization improvements,
> RSS and aRFS improvements, devlink refactoring and registration
> improvements, devlink info support including documentation.
> 
> v2: Removed the TC ingress rate limiting patch. The developer Harsha needs
> to rework some code.
>     Use fw.psid suggested by Jakub Kicinski.

Series applied, thanks Michael.

