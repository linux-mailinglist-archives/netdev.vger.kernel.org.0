Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id DA8BC2ADB76
	for <lists+netdev@lfdr.de>; Tue, 10 Nov 2020 17:19:27 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726944AbgKJQT0 (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Nov 2020 11:19:26 -0500
Received: from us-smtp-delivery-124.mimecast.com ([216.205.24.124]:34415 "EHLO
        us-smtp-delivery-124.mimecast.com" rhost-flags-OK-OK-OK-OK)
        by vger.kernel.org with ESMTP id S1726688AbgKJQTZ (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Nov 2020 11:19:25 -0500
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed; d=redhat.com;
        s=mimecast20190719; t=1605025164;
        h=from:from:reply-to:subject:subject:date:date:message-id:message-id:
         to:to:cc:cc:mime-version:mime-version:content-type:content-type:
         content-transfer-encoding:content-transfer-encoding:
         in-reply-to:in-reply-to:references:references;
        bh=ex6TCsm+l+OMpVSxdKk20p/MJxan2qyl5QDlnj+iupc=;
        b=dsKAuUC+wkwxgBJA240dnsIa/JkqjJ5F7ZFCRRIwKCnoRU5oIQEQaklUBqcMFrffpFuho5
        VjK3LDMwnP3UAhqvwkWZr+72pQOfIu0q3f1rW/Ev/h5RNS4J/+9OUfkhNGpYBYIPvUlj64
        CsIbIHJXNypzeF5TZlod8dpKeBZEpJg=
Received: from mimecast-mx01.redhat.com (mimecast-mx01.redhat.com
 [209.132.183.4]) (Using TLS) by relay.mimecast.com with ESMTP id
 us-mta-275-VQJ4iT6oNfWv-_4Ulm_Vyg-1; Tue, 10 Nov 2020 11:19:20 -0500
X-MC-Unique: VQJ4iT6oNfWv-_4Ulm_Vyg-1
Received: from smtp.corp.redhat.com (int-mx08.intmail.prod.int.phx2.redhat.com [10.5.11.23])
        (using TLSv1.2 with cipher AECDH-AES256-SHA (256/256 bits))
        (No client certificate requested)
        by mimecast-mx01.redhat.com (Postfix) with ESMTPS id D2818186DD25;
        Tue, 10 Nov 2020 16:19:18 +0000 (UTC)
Received: from carbon (unknown [10.36.110.8])
        by smtp.corp.redhat.com (Postfix) with ESMTP id EC69F1A4D8;
        Tue, 10 Nov 2020 16:19:10 +0000 (UTC)
Date:   Tue, 10 Nov 2020 17:19:09 +0100
From:   Jesper Dangaard Brouer <brouer@redhat.com>
To:     Lorenzo Bianconi <lorenzo@kernel.org>
Cc:     netdev@vger.kernel.org, bpf@vger.kernel.org, davem@davemloft.net,
        kuba@kernel.org, lorenzo.bianconi@redhat.com,
        ilias.apalodimas@linaro.org, brouer@redhat.com
Subject: Re: [PATCH v5 net-nex 5/5] net: mlx5: add xdp tx return bulking
 support
Message-ID: <20201110171909.4fc9100c@carbon>
In-Reply-To: <0e898e7f201e65bdf4d9457f9ad4997d8e52dd4c.1605020963.git.lorenzo@kernel.org>
References: <cover.1605020963.git.lorenzo@kernel.org>
        <0e898e7f201e65bdf4d9457f9ad4997d8e52dd4c.1605020963.git.lorenzo@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Scanned-By: MIMEDefang 2.84 on 10.5.11.23
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Tue, 10 Nov 2020 16:38:00 +0100
Lorenzo Bianconi <lorenzo@kernel.org> wrote:

> Convert mlx5 driver to xdp_return_frame_bulk APIs.
> 
> XDP_REDIRECT (upstream codepath): 8.9Mpps
> XDP_REDIRECT (upstream codepath + bulking APIs): 10.2Mpps
> 
> Co-developed-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Signed-off-by: Lorenzo Bianconi <lorenzo@kernel.org>

I did most of my testing on this driver:

Tested-by: Jesper Dangaard Brouer <brouer@redhat.com>

-- 
Best regards,
  Jesper Dangaard Brouer
  MSc.CS, Principal Kernel Engineer at Red Hat
  LinkedIn: http://www.linkedin.com/in/brouer

