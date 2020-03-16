Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 1931C186F5B
	for <lists+netdev@lfdr.de>; Mon, 16 Mar 2020 16:52:43 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1732038AbgCPPwk (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 16 Mar 2020 11:52:40 -0400
Received: from us-smtp-delivery-74.mimecast.com ([216.205.24.74]:56113 "EHLO
        us-smtp-delivery-74.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1731970AbgCPPwk (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 16 Mar 2020 11:52:40 -0400
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1584373959;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=EKh6zEjhsb01RXnny+1OmoGhV67J5tVQ++UiZ5QhWQw=;
        b=Ewq6FFcod7TITEzCPJyuZycIUqDz/Lor1KaUIW1Mm3JQIwBDGRyz9sknuUa2uOubhT/AIg
        v25w3HQjJ5ci7keVh9BGbzZPGefy+JpEx1AeY4CbYnUXLp1bS2bn9TiPXJGL2G2pFLb3ea
        bfKKnzzLEXH1cJnuQiBpSZsbZ/8Td98=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-481-a6heLy2-Nkqd9hBOwwOpcg-1; Mon, 16 Mar 2020 11:52:37 -0400
X-MC-Unique: a6heLy2-Nkqd9hBOwwOpcg-1
Received: from smtp.corp.redhat.com (int-mx02.intmail.prod.int.phx2.redhat.com [10.5.11.12])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id 13133144339;
        Mon, 16 Mar 2020 15:52:36 +0000 (UTC)
Received: from carbon (ovpn-200-32.brq.redhat.com [10.40.200.32])
        by smtp.corp.redhat.com (Postfix) with ESMTP id C3DDA60CD3;
        Mon, 16 Mar 2020 15:52:30 +0000 (UTC)
Date:   Mon, 16 Mar 2020 16:52:29 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Denis Kirjanov <kda@linux-powerpc.org>
Cc:     brouer@redhat.com, netdev@vger.kernel.org, jgross@suse.com,
        ilias.apalodimas@linaro.org, wei.liu@kernel.org, paul@xen.org
Subject: Re: [PATCH net-next v4] xen networking: add basic XDP support for
 xen-netfront
Message-ID: <20200316165215.1c9efb3b@carbon>
In-Reply-To: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
References: <1584364176-23346-1-git-send-email-kda@linux-powerpc.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.79 on 10.5.11.12
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 16 Mar 2020 16:09:36 +0300
Denis Kirjanov <kda@linux-powerpc.org> wrote:

> v3:
> - added XDP_TX support (tested with xdping echoserver)
> - added XDP_REDIRECT support (tested with modified xdp_redirect_kern)

Please test XDP_REDIRECT with xdp_redirect_cpu from samples/bpf/.

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

