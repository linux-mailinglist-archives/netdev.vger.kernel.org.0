Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 56B6E206E9C
	for <lists+netdev@lfdr.de>; Wed, 24 Jun 2020 10:07:14 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2390285AbgFXIHM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 24 Jun 2020 04:07:12 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:60271 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S2389022AbgFXIHM (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 24 Jun 2020 04:07:12 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1592986031;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=Ss5NVTkBdepnWqRKDwI/TRxHk9OHYS3Y1jWbknW/W5k=;
        b=dN7TtV+3RorYxMpWC22zAJ4D2T+O8fhtGbAOGE1lRH07DlIer5dCnD2otfs+AleWBQztEA
        M0xuqX3dTNnPIM6/MpnTqobPYevx4Df/DwXUw70Iz8zma+xfeGp64V17nEgczN18IGKL/8
        0Q8TvFoNW5Fcbrjgg3lPhrq7nuCyd1c=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-59-6-8ItMA1OkWJSUYDmI6TrQ-1; Wed, 24 Jun 2020 04:07:07 -0400
X-MC-Unique: 6-8ItMA1OkWJSUYDmI6TrQ-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D55FA8015F7;
        Wed, 24 Jun 2020 08:07:05 +0000 (UTC)
Received: from carbon (unknown [10.40.208.36])
        by smtp.corp.redhat.com (Postfix) with ESMTP id D933760F89;
        Wed, 24 Jun 2020 08:06:53 +0000 (UTC)
Date:   Wed, 24 Jun 2020 10:06:52 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        ast@kernel.org, daniel@iogearbox.net, toke@redhat.com,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        andrii.nakryiko@gmail.com, David Ahern <dahern@digitalocean.com>,
        brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 2/9] net: Refactor xdp_convert_buff_to_frame
Message-ID: <20200624100652.0f57212f@carbon>
In-Reply-To: <0f32f3dd1787f050b41ab1d32490b838544fe3e2.1592947694.git.lorenzo@kernel.org>
References: <cover.1592947694.git.lorenzo@kernel.org>
        <0f32f3dd1787f050b41ab1d32490b838544fe3e2.1592947694.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 23 Jun 2020 23:39:27 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> From: David Ahern <dahern@digitalocean.com>
> 
> Move the guts of xdp_convert_buff_to_frame to a new helper,
> xdp_update_frame_from_buff so it can be reused removing code duplication
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Co-developed-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> Signed-off-by: David Ahern <dahern@digitalocean.com>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

