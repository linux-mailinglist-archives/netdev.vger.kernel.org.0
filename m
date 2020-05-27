Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id A7EB51E3EA3
	for <lists+netdev@lfdr.de>; Wed, 27 May 2020 12:08:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729425AbgE0KIa (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 27 May 2020 06:08:30 -0400
Received: from us-smtp-1.mimecast.com ([207.211.31.81]:24910 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1727888AbgE0KI3 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 27 May 2020 06:08:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590574109;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=/pDmMX+qjUrBerXvv05Q4HiW8gwQv2m7btG8CnNotbc=;
        b=XgGB31XSZWckAtamU+o4d7IHrseFxAkNFUFR2PzkditIpZufGysucnaIWkBCMNDgYOvpcD
        odlpSgTtBnOVUsWhqStQyX/8MBpyvUcRr6Mragc1JUJauqAWEIEOogB8zYSLBlWUCvE2eS
        uGnCfRr/M1k1rwoXQA4bo7TpA7ill58=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-195-h-pncdU-P8aH_e06pKZMsw-1; Wed, 27 May 2020 06:08:26 -0400
X-MC-Unique: h-pncdU-P8aH_e06pKZMsw-1
Received: from smtp.corp.redhat.com (int-mx01.intmail.prod.int.phx2.redhat.com [10.5.11.11])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 50A68835B41;
        Wed, 27 May 2020 10:08:25 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 038187A1E1;
        Wed, 27 May 2020 10:08:16 +0000 (UTC)
Date:   Wed, 27 May 2020 12:08:15 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org,
        toshiaki.makita1@gmail.com, brouer@redhat.com
Subject: Re: [PATCH v2 bpf-next] xdp: introduce convert_to_xdp_buff utility
 routine
Message-ID: <20200527120815.4222e00d@carbon>
In-Reply-To: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
References: <80a0128d78f6c77210a8cccf7c5a78f53c45e7d3.1590571528.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.11
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, 27 May 2020 11:28:03 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Introduce convert_to_xdp_buff utility routine to initialize xdp_buff
> fields from xdp_frames ones. Rely on convert_to_xdp_buff in veth xdp
> code
> 
> Suggested-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>
> ---
> Changes since v1:
> - rely on frame->data pointer to compute xdp->data_hard_start one

LGTM

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

