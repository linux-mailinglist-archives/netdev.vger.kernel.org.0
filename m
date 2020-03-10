Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 064C217F2A5
	for <lists+netdev@lfdr.de>; Tue, 10 Mar 2020 10:03:47 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726669AbgCJJDp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Mar 2020 05:03:45 -0400
Received: from us-smtp-2.mimecast.com ([207.211.31.81]:37377 "EHLO
        us-smtp-delivery-1.mimecast.com" rhost-flags-OK-OK-OK-FAIL)
        by vger.kernel.org with ESMTP id S1726389AbgCJJDp (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Mar 2020 05:03:45 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1583831024;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=w0AJeNx929FoMZPLqF2hB7+GO57h4OKuoB3HnKBr8qc=;
        b=DvHezEJytnMBsWE5Rxe38LTknMN7jylK4Ic4e3pIh6jwdY7of3hTgtJSrHvpwdtfhtXCmr
        5FbZsT3ktWSsvOzTsdc2PFRI5ammmnzO1fbVmxjwrshjAF+HQIlKEYZ4JtzGaX9J9mr295
        Xh1W5UTU430KgMLR57QY7pIhBTgc9RU=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-211-QkEtExp8P8qftf0UM7j44g-1; Tue, 10 Mar 2020 05:03:41 -0400
X-MC-Unique: QkEtExp8P8qftf0UM7j44g-1
Received: from smtp.corp.redhat.com (int-mx06.intmail.prod.int.phx2.redhat.com [10.5.11.16])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id C6138DB60;
        Tue, 10 Mar 2020 09:03:38 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id 85C9C5C28E;
        Tue, 10 Mar 2020 09:03:25 +0000 (UTC)
Date:   Tue, 10 Mar 2020 10:03:23 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     David Ahern <dahern@digitalocean.com>
Cc:     David Ahern <dsahern@kernel.org>, netdev@vger.kernel.org,
        davem@davemloft.net, kuba@kernel.org,
        prashantbhole.linux@gmail.com, jasowang@redhat.com,
        toke@redhat.com, mst@redhat.com, toshiaki.makita1@gmail.com,
        daniel@iogearbox.net, john.fastabend@gmail.com, ast@kernel.org,
        kafai@fb.com, songliubraving@fb.com, yhs@fb.com, andriin@fb.com,
        dsahern@gmail.com, brouer@redhat.com
Subject: Re: [PATCH RFC v4 bpf-next 09/11] tun: Support xdp in the Tx path
 for xdp_frames
Message-ID: <20200310100323.14a2a011@carbon>
In-Reply-To: <942c9efd-67e2-65d3-d311-bb4eba9fb747@digitalocean.com>
References: <20200227032013.12385-1-dsahern@kernel.org>
        <20200227032013.12385-10-dsahern@kernel.org>
        <20200303114044.2c7482d5@carbon>
        <14ef34c2-2fa6-f58c-6d63-e924d07e613f@digitalocean.com>
        <942c9efd-67e2-65d3-d311-bb4eba9fb747@digitalocean.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.16
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 9 Mar 2020 21:44:22 -0600
David Ahern <dahern@digitalocean.com> wrote:

> On 3/9/20 9:06 PM, David Ahern wrote:
> > Why do I need to make any adjustments beyond what is done by
> > bpf_xdp_adjust_head and bpf_xdp_adjust_tail?  
> 
> never mind. forgot the switch from xdp_frame to xdp_buff there so need
> to go back to frame.

Yes exactly, glad you realized this yourself ;-)

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

