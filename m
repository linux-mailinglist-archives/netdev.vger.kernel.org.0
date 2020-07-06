Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 5D605215DE0
	for <lists+netdev@lfdr.de>; Mon,  6 Jul 2020 20:01:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729701AbgGFSBr (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 Jul 2020 14:01:47 -0400
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:60662 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1729657AbgGFSBr (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 Jul 2020 14:01:47 -0400
Received: from mail-pg1-x544.google.com (mail-pg1-x544.google.com [IPv6:2607:f8b0:4864:20::544])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 2AB0BC061755
        for <netdev@vger.kernel.org>; Mon,  6 Jul 2020 11:01:47 -0700 (PDT)
Received: by mail-pg1-x544.google.com with SMTP id e8so18745799pgc.5
        for <netdev@vger.kernel.org>; Mon, 06 Jul 2020 11:01:47 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=networkplumber-org.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:in-reply-to:references
         :mime-version:content-transfer-encoding;
        bh=c1BP4kkd5mQvXLT6gvyFMq5KFfU0a9HUZV4HI0V2JgM=;
        b=z0SDURRPP8pIwoHLsHJiywXVTwGBEha7/eRi66zb/rmkCTtpdxfwSvoCP9+N//CZHh
         0TQvDcuCjARu0CQq/sjVee3UPylTXExh8NQH4R5OHujWUbwWsnANTjg/Bs2zlYSiDVUm
         TuroqJODFE5QF66HvqLRdLdq8slVdzTRVIzvUJRRyalzdFvfLFe6PfkSXJLumUsLjKVj
         Cnwx7VIAOwieYVG9UhSM2JTIM2IRDa+WGIVC3Pioa2s8uiVDKtOof3tOqNSJhqsY537r
         0yFuvlOB9kkfE7KAjAHqrv8jBUNGC40I+wRL5COoU6hxZ+ZGlFGXEgqIEtcSXmk8shpu
         swbw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:in-reply-to
         :references:mime-version:content-transfer-encoding;
        bh=c1BP4kkd5mQvXLT6gvyFMq5KFfU0a9HUZV4HI0V2JgM=;
        b=gx33AzykhvSoS8PWOIewoWuj8BEIJgnBOPJAgjBmDqjcax954b2S7CDQELBQd/eLbf
         HCvLrnQpmYvBl34p2ajaNvnBJo61/Rdm9VYKBidJ08WrvNA83HRJBICz7+kQj+shhEc6
         Mo0PibkJpskTd5FcrG5oAK5emMpLBksWsYzMgg/sUOO3+4S4il+3abE5Y92tVdISTT2E
         xc1hwbETmPpeZ1A1hQCYrp5EzzhCv9K6zafrS/2xrQNaH1Ln/ubFzPjJ5u3W9fDz39DB
         XGZQwvg4SIxZ9OgY09W95aLpl+6i3WAZz9ABOv3kqLPo5PqPkFH3qLsqpPxCFXsy5lnv
         vz/A==
X-Gm-Message-State: AOAM533FiCISaD700klqQhXXileyi19Edk5i/zX5UW2hWqV/jEW1lUly
        edjCAXeoICFcID3Y4EuFnhr0IA==
X-Google-Smtp-Source: ABdhPJysJMsIJO6XZlGH3CAQJZCDHxIBnjZ0jz1oW0/MDIVyY2ByG/LI673VFDedgfJ4xq1EsD8o5Q==
X-Received: by 2002:a65:6916:: with SMTP id s22mr42369299pgq.128.1594058506639;
        Mon, 06 Jul 2020 11:01:46 -0700 (PDT)
Received: from hermes.lan (204-195-22-127.wavecable.com. [204.195.22.127])
        by smtp.gmail.com with ESMTPSA id n15sm19887455pgs.25.2020.07.06.11.01.46
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 06 Jul 2020 11:01:46 -0700 (PDT)
Date:   Mon, 6 Jul 2020 11:01:38 -0700
From:   Stephen Hemminger <stephen@networkplumber.org>
To:     Anton Danilov <littlesmilingcloud@gmail.com>
Cc:     netdev@vger.kernel.org
Subject: Re: [PATCH iproute2 v3] tc: improve the qdisc show command
Message-ID: <20200706110138.36a1528c@hermes.lan>
In-Reply-To: <20200703153921.9312-1-littlesmilingcloud@gmail.com>
References: <20200618151702.24c33261@hermes.lan>
        <20200703153921.9312-1-littlesmilingcloud@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri,  3 Jul 2020 18:39:22 +0300
Anton Danilov <littlesmilingcloud@gmail.com> wrote:

> Before can be possible show only all qeueue disciplines on an interface.
> There wasn't a way to get the qdisc info by handle or parent, only full
> dump of the disciplines with a following grep/sed usage.
> 
> Now new and old options work as expected to filter a qdisc by handle or
> parent.
> 
> Full syntax of the qdisc show command:
> 
> tc qdisc { show | list } [ dev STRING ] [ QDISC_ID ] [ invisible ]
>   QDISC_ID := { root | ingress | handle QHANDLE | parent CLASSID }
> 
> This change doesn't require any changes in the kernel.
> 
> Signed-off-by: Anton Danilov <littlesmilingcloud@gmail.com>
> ---
> v2:
> - Fix the coding style
> v3:
> - Make the parameters checking more simple

Applied, thanks
