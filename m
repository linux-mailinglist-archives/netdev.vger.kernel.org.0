Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 2771E1E6D5C
	for <lists+netdev@lfdr.de>; Thu, 28 May 2020 23:12:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728525AbgE1VMd (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 28 May 2020 17:12:33 -0400
Received: from us-smtp-delivery-1.mimecast.com ([205.139.110.120]:32641 "EHLO
        us-smtp-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
        with ESMTP id S1728629AbgE1VMa (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 28 May 2020 17:12:30 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1590700349;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=P9405VTs/PKi2/PNuNHJvo/bUH9roMM2ZKbMJomtQOM=;
        b=I/vFhpDiIl7u3Z2qXDG/N9WffpkzPO8W27h2FCEsQbl8L//Zuuw4nUvNFxh49Uh1c7ajbR
        X6dhtmVyibbFxJRxt3CmfgiDVWble8UPlXfSTFp6bagpFT1mTer/CiaN9aJWV+fYRHyJg6
        d2O6v6bwb1NlqNmCz7jbrPVF/03b9WA=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-100-yexD3gmNMC2B3RYhlTdADA-1; Thu, 28 May 2020 17:12:26 -0400
X-MC-Unique: yexD3gmNMC2B3RYhlTdADA-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 74F861009454;
        Thu, 28 May 2020 21:12:24 +0000 (UTC)
Received: from carbon (unknown [10.40.208.9])
        by smtp.corp.redhat.com (Postfix) with ESMTP id CBCD160C80;
        Thu, 28 May 2020 21:12:15 +0000 (UTC)
Date:   Thu, 28 May 2020 23:12:14 +0200
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     bpf@vger.kernel.org, netdev@vger.kernel.org, ast@kernel.org,
        davem@davemloft.net, daniel@iogearbox.net,
        lorenzo.bianconi@redhat.com, dsahern@kernel.org, brouer@redhat.com
Subject: Re: [PATCH v3 bpf-next 2/2] xdp: rename convert_to_xdp_frame in
 xdp_convert_buff_to_frame
Message-ID: <20200528231214.43832c20@carbon>
In-Reply-To: <6344f739be0d1a08ab2b9607584c4d5478c8c083.1590698295.git.lorenzo@kernel.org>
References: <cover.1590698295.git.lorenzo@kernel.org>
        <6344f739be0d1a08ab2b9607584c4d5478c8c083.1590698295.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, 28 May 2020 22:47:29 +0200
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> In order to use standard 'xdp' prefix, rename convert_to_xdp_frame
> utility routine in xdp_convert_buff_to_frame and replace all the
> occurrences
> 
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

Acked-by: Jesper Dangaard Brouer <brouer@redhat.com>

You even corrected a comment mentioning the function name :-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

