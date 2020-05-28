Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 299C91E6B9B
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 21:49:22 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2406753AbgE1TsP (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 15:48:15 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:44755 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1728698AbgE1TsD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 15:48:03 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590695282;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ukUKsMQtJQ/POklgv6hxv6yQhdAjZ+dAaodZMEeHyDI=;
        b=clk7qRmILRI/+p5spgmvnnTAxCvC6wwd4HkFztbgzULplAgk6cnFTlxX7b9Fn4dVGhl41c
        on1eQF/au/ChAvP6+rW+jNBos3Wg3WP7hujvP5oktroaffCs2UXq7og0wvQ817ErEOIMD6
        xPZrH3IRIGWqhOk+6+6uxh1Uz+IoZDY=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-257-FB6j3GvTObqL524yhdStPg-1; Thu, 28 May 2020 15:47:58 -0400
X-MC-Unique: FB6j3GvTObqL524yhdStPg-1
Received: from smtp.corp.redhat.com (int-mx03.intmail.prod.int.phx2.redhat.com [10.5.11.13])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D0759EC1A0;
        Thu, 28 May 2020 19:47:55 +0000 (UTC)
Received: from localhost (unknown [10.10.110.53])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 664A19F9BA;
        Thu, 28 May 2020 19:47:52 +0000 (UTC)
Date:   Thu, 28 May 2020 12:47:51 -0700 (PDT)
Message-Id: <20200528.124751.1622700747294014742.davem@redhat.com>
To:     jonas.falkevik@gmail.com
Cc:     marcelo.leitner@gmail.com, lucien.xin@gmail.com,
        nhorman@tuxdriver.com, vyasevich@gmail.com, kuba@kernel.org,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] sctp: check assoc before
 SCTP_ADDR_{MADE_PRIM,ADDED} event
From:   David Miller <davem@redhat.com>
In-Reply-To: <20200527095640.270986-1-jonas.falkevik@gmail.com>
References: <20200527095640.270986-1-jonas.falkevik@gmail.com>
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.13
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jonas Falkevik <jonas.falkevik@gmail.com>
Date: Wed, 27 May 2020 11:56:40 +0200

> Make sure SCTP_ADDR_{MADE_PRIM,ADDED} are sent only for associations
> that have been established.
> 
> These events are described in rfc6458#section-6.1
> SCTP_PEER_ADDR_CHANGE:
> This tag indicates that an address that is
> part of an existing association has experienced a change of
> state (e.g., a failure or return to service of the reachability
> of an endpoint via a specific transport address).
> 
> Signed-off-by: Jonas Falkevik <jonas.falkevik@gmail.com>
> ---
> Changes in v2:
>  - Check asoc state to be at least established.
>    Instead of associd being SCTP_FUTURE_ASSOC.
>  - Common check for all peer addr change event

Applied and queued up for -stable, thanks.

 

