Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id 84FCE286F73
	for <lists+netdev@lfdr.de>; Thu,  8 Oct 2020 09:31:39 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726464AbgJHHbg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 8 Oct 2020 03:31:36 -0400
Received: from mail-lj1-f176.google.com ([209.85.208.176]:40229 "EHLO
        mail-lj1-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725849AbgJHHbf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 8 Oct 2020 03:31:35 -0400
Received: by mail-lj1-f176.google.com with SMTP id f21so4650809ljh.7;
        Thu, 08 Oct 2020 00:31:34 -0700 (PDT)
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to;
        bh=+1g36aKYcNrXZCi0eKfetb55THHV9Hf9K+OzdAh90uU=;
        b=lkNd0Kl9fFlfcFOESoSP/B36V+cDkRm+iejuSyJlSsd7O4zGWyIvSazfcUutaLalnB
         pPTXSPiXY1hqEcz6Zfy/msgQO6U3AShk24lBEVX376mg9hFMtKhS4YSjxGKn8xODN4K7
         rWBHhLMbqgvkPQU1PS+O/A0Ld8nhqPkTUI39YXpqaMX2wXn7wZDbVbL4rBmYJOKOTEH2
         6/UYpZ5Z4CN9LxPgF42MPrliYxam9hXC/pXmlPw0VujDgDWnE/nJlWNRNNQ0Blh+7LCV
         s/TFb3Crqa75+2Z5TdgTlrEa9F29ETErr5HqB/TU+3QSq9ja2ujwsE5+iO2rmaMfAggx
         UzGw==
X-Gm-Message-State: AOAM531sh7eFM6CXaGNX+R1q8z95WWrBrrXJKWLQU7c6/CMmWM1oQ9fN
        yxftY/+nunNBshBuK4QnRAA=
X-Google-Smtp-Source: ABdhPJyXd1soH2qzb3AiRG9NyrEwiO1y3XgoMYHfLNfkVS2YrpoVPo3s2hHaiuQIEZMBHNvrEAxWSg==
X-Received: by 2002:a2e:978f:: with SMTP id y15mr2476766lji.300.1602142293522;
        Thu, 08 Oct 2020 00:31:33 -0700 (PDT)
Received: from xi.terra (c-beaee455.07-184-6d6c6d4.bbcust.telenor.se. [85.228.174.190])
        by smtp.gmail.com with ESMTPSA id u23sm719491lfq.173.2020.10.08.00.31.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Thu, 08 Oct 2020 00:31:32 -0700 (PDT)
Received: from johan by xi.terra with local (Exim 4.93.0.4)
        (envelope-from <johan@kernel.org>)
        id 1kQQOd-0006eJ-Jo; Thu, 08 Oct 2020 09:31:27 +0200
Date:   Thu, 8 Oct 2020 09:31:27 +0200
From:   Johan Hovold <johan@kernel.org>
To:     Wilken Gottwalt <wilken.gottwalt@mailbox.org>
Cc:     linux-kernel@vger.kernel.org,
        =?iso-8859-1?Q?Bj=F8rn?= Mork <bjorn@mork.no>,
        "David S. Miller" <davem@davemloft.net>,
        Jakub Kicinski <kuba@kernel.org>,
        Johan Hovold <johan@kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        netdev@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [PATCH v2 2/2] usb: serial: option: add Cellient MPL200 card
Message-ID: <20201008073127.GH26280@localhost>
References: <cover.1602140720.git.wilken.gottwalt@mailbox.org>
 <be90904f21494eaa8235db962829a8842025b22e.1602140720.git.wilken.gottwalt@mailbox.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <be90904f21494eaa8235db962829a8842025b22e.1602140720.git.wilken.gottwalt@mailbox.org>
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Thu, Oct 08, 2020 at 09:22:19AM +0200, Wilken Gottwalt wrote:
> Add usb ids of the Cellient MPL200 card.
> 
> Signed-off-by: Wilken Gottwalt <wilken.gottwalt@mailbox.org>
> ---

So I had already applied this one (which didn't change since v1).

Thanks again.

Johan
