Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EDDDD6F8D2
	for <lists+netdev@lfdr.de>; Mon, 22 Jul 2019 07:22:56 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727021AbfGVFWt (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 22 Jul 2019 01:22:49 -0400
Received: from mail-wr1-f68.google.com ([209.85.221.68]:33141 "EHLO
        mail-wr1-f68.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725773AbfGVFWt (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 22 Jul 2019 01:22:49 -0400
Received: by mail-wr1-f68.google.com with SMTP id n9so37982795wru.0;
        Sun, 21 Jul 2019 22:22:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=ETeKDbjRetNIkG5OkDbxDTHMEmZYmQYCFw58W5ps8kI=;
        b=k6E+Jh8+h1HvEeKmiRMrOPlkvCdfNYHFktXRuqKSesuQRBdbAQahtbwYkCBsbvlssd
         Ki21VARXSUeW1E6NV3uN+Tr+VZ1e3HBgE+B44thY/Q8luHf5fXezsxWBaJFljn0abtYz
         FIOdJEEOh+JInSV+K2psDpY3EUjrsi2PttQH9nGuJEiEZlAzXtK9L7uwkMm3fSiDltR4
         OPOV8lO94YOtNpO43frxDEUPjkO19jS5Wd08jFhRFaGfsIYeaH3YkkYRdvYBgCea+Btl
         lHF5W1JKXhA5x0WxbDMoVqy/Xuz4N/wWXTtH3zar/fTifvkH9KIyv25jVTqkXGOOBaGj
         9SjA==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=ETeKDbjRetNIkG5OkDbxDTHMEmZYmQYCFw58W5ps8kI=;
        b=gL9X43rjPSSgaOuSyzPQE1nzNJJzgvFIImOMG9rIqmlj2M5L7mFDPcjmQTKZCYX/xB
         I8+9AWZ/T4Jrx+5B6GAk5EiQR0Eg0nFRTavVtN8EGGkIiAKeOUFzsE1lwBHiR5HvxiGU
         qUWFtNDfoi0Ves0o0wGmEcQPjOgkGvTeNFyRdP3CPGETGoDBqBWXnpZc3jUkrhOEDt5s
         F72KPk3vGmwBdk5ekXzgSugg078V7L41uy7cDsIRB+X3Do+ZEdcFd4wJjhbGvOyDbmca
         MyljOHGO7t5KAGw1/qVYD/7XKyG/AcISfq6vvOmFpo3XUOC2j5rkXOfo5g7TXUrIj2rq
         ksFA==
X-Gm-Message-State: APjAAAVmtepC+FEir/7f4HyuPlcL2w7ew17qDshIKr6bIceOwcbCmaWi
        DvWP+FROgNZQ+dRQo/hgHw==
X-Google-Smtp-Source: APXvYqwZycQryK2Tn4hJi8ISfIaaufeRjt02D9pQywPF25eDjRGRtDqC6cQS510Filgr4by3xYnYgA==
X-Received: by 2002:a5d:6b11:: with SMTP id v17mr22844937wrw.323.1563772967184;
        Sun, 21 Jul 2019 22:22:47 -0700 (PDT)
Received: from avx2 ([46.53.250.207])
        by smtp.gmail.com with ESMTPSA id z5sm27075540wmf.48.2019.07.21.22.22.46
        (version=TLS1_2 cipher=ECDHE-RSA-AES128-GCM-SHA256 bits=128/128);
        Sun, 21 Jul 2019 22:22:46 -0700 (PDT)
Date:   Mon, 22 Jul 2019 08:22:44 +0300
From:   Alexey Dobriyan <adobriyan@gmail.com>
To:     James Bottomley <James.Bottomley@HansenPartnership.com>
Cc:     akpm@linux-foundation.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org, axboe@kernel.dk, kvalo@codeaurora.org,
        john.johansen@canonical.com, linux-arch@vger.kernel.org
Subject: Re: [PATCH] unaligned: delete 1-byte accessors
Message-ID: <20190722052244.GA4235@avx2>
References: <20190721215253.GA18177@avx2>
 <1563750513.2898.4.camel@HansenPartnership.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1563750513.2898.4.camel@HansenPartnership.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, Jul 22, 2019 at 08:08:33AM +0900, James Bottomley wrote:
> On Mon, 2019-07-22 at 00:52 +0300, Alexey Dobriyan wrote:
> > Each and every 1-byte access is aligned!
> 
> The design idea of this is for parsing descriptors.  We simply chunk up
> the describing structure using get_unaligned for everything.  The
> reason is because a lot of these structures come with reserved areas
> which we may make use of later.  If we're using get_unaligned for
> everything we can simply change a u8 to a u16 in the structure
> absorbing the reserved padding.  With your change now I'd have to chase
> down every byte access and replace it with get_unaligned instead of
> simply changing the structure.
> 
> What's the significant advantage of this change that compensates for
> the problems the above causes?

HW descriptors have fixed endianness, you're supposed to use
get_unaligned_be32() and friends.

For that matter, drivers/scsi/ has exactly 2 get_unaligned() calls one of
which can be changed to get_unaligned_be32().
