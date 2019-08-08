Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 39E0186A6F
	for <lists+netdev@lfdr.de>; Thu,  8 Aug 2019 21:17:02 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2404491AbfHHTQs convert rfc822-to-8bit (ORCPT
        <rfc822;lists+netdev@lfdr.de>); Thu, 8 Aug 2019 15:16:48 -0400
Received: from mail-ed1-f68.google.com ([209.85.208.68]:44275 "EHLO
        mail-ed1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2404458AbfHHTQs (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Aug 2019 15:16:48 -0400
Received: by mail-ed1-f68.google.com with SMTP id k8so91990096edr.11
        for <netdev@vger.kernel.org>; Thu, 08 Aug 2019 12:16:47 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:from:to:cc:subject:in-reply-to:references:date
         :message-id:mime-version:content-transfer-encoding;
        bh=EB017sgirwqykGPzu5H2VFxlNlbnyUS6sjojl+iVwTU=;
        b=cn4uGtL8IyUjwzo57HYoOzBNvDmCrHdJ9wzOznEr56Ewx/CXzMYxw7tClk8Gkgh4Dk
         U5SkLBLOQ7Yz8fux+i+C+eOWv4275Tdm2UdLoBrgbcN7wPG4FhKHAD9VJSUPlZSCzSOm
         UOBisgOrMD1ia3TBBgkuXcEtuySgGtsmYQYznhFKfTd2v68t0PmQLe2UbUVjqvmB3ZZV
         8zOzncZAYbAllQJoc5fIsPl80MQ+iRi/rWNeXq8JWo5tCyvDrtrFzZhmG3/uMqS+wyk/
         1TE52VDS04dJY1bTQNwgkSDb9Jd6BH3xofIEOORbE1SDNh3eGIcWgJ0BU5pTHeSyQzk9
         UACw==
X-Gm-Message-State: APjAAAVQvhX7sW8d+z3/rtioFvPcZwO63cEU37CRSiICUPdmBVVtwtXU
        oTscdnUvmlOS5okK2WXvIU9P1A==
X-Google-Smtp-Source: APXvYqzNDxB4uLYsx3Xl1v4wAJtjjGk9Cv9WMB5GQQS50l7xTlwdNj++Dv/ATD7nimuDx0FfWj+SoA==
X-Received: by 2002:a50:f5f5:: with SMTP id x50mr17391659edm.89.1565291806703;
        Thu, 08 Aug 2019 12:16:46 -0700 (PDT)
Received: from alrua-x1.borgediget.toke.dk ([2a00:7660:6da:443::2])
        by smtp.gmail.com with ESMTPSA id f24sm22114630edf.30.2019.08.08.12.16.45
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Thu, 08 Aug 2019 12:16:46 -0700 (PDT)
Received: by alrua-x1.borgediget.toke.dk (Postfix, from userid 1000)
        id 74B721804B2; Thu,  8 Aug 2019 21:16:45 +0200 (CEST)
From:   Toke =?utf-8?Q?H=C3=B8iland-J=C3=B8rgensen?= <toke@redhat.com>
To:     Jesper Dangaard Brouer <brouer@redhat.com>, netdev@vger.kernel.org,
        Daniel Borkmann <borkmann@iogearbox.net>,
        Alexei Starovoitov <alexei.starovoitov@gmail.com>
Cc:     a.s.protopopov@gmail.com, dsahern@gmail.com, ys114321@gmail.com,
        Jesper Dangaard Brouer <brouer@redhat.com>
Subject: Re: [bpf-next v3 PATCH 1/3] samples/bpf: xdp_fwd rename devmap name to be xdp_tx_ports
In-Reply-To: <156528105763.22124.16079929264188823516.stgit@firesoul>
References: <156528102557.22124.261409336813472418.stgit@firesoul> <156528105763.22124.16079929264188823516.stgit@firesoul>
X-Clacks-Overhead: GNU Terry Pratchett
Date:   Thu, 08 Aug 2019 21:16:45 +0200
Message-ID: <87y303sc0y.fsf@toke.dk>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Jesper Dangaard Brouer <brouer@redhat.com> writes:

> The devmap name 'tx_port' came from a copy-paste from xdp_redirect_map
> which only have a single TX port. Change name to xdp_tx_ports
> to make it more descriptive.
>
> Signed-off-by: Jesper Dangaard Brouer <brouer@redhat.com>
> Reviewed-by: David Ahern <dsahern@gmail.com>
> Acked-by: Yonghong Song <yhs@fb.com>


Reviewed-by: Toke Høiland-Jørgensen <toke@redhat.com>
