Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 62864B018B
	for <lists+netdev@lfdr.de>; Wed, 11 Sep 2019 18:24:12 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728998AbfIKQYE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 11 Sep 2019 12:24:04 -0400
Received: from mail-qt1-f195.google.com ([209.85.160.195]:38143 "EHLO
        mail-qt1-f195.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728878AbfIKQYE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 11 Sep 2019 12:24:04 -0400
Received: by mail-qt1-f195.google.com with SMTP id b2so25966870qtq.5;
        Wed, 11 Sep 2019 09:24:03 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=gmail.com; s=20161025;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=bnfqvKEw5aP7UOEOx3W9CaWGunUzL+uqs10GsHrVCfw=;
        b=NZwPECIkWJiT0fSn6+EXIFAJjvPXWFANy47Z7/MYkI02KbGTvRm6cQO4BMCfTXp/fi
         WnJsb19mf0JCzWKwvFLtpjZfyo3kOylT4miFCP/jblS1V9OHR5dy9Hu8ieAMlWTC6IR/
         1SJsZxTAowJCFmHI0Vn67zovAr1oC63WVsqe0RVBprZ5N7ToQcFkmfBdIoRdQPxCifUv
         2dC2NkXdBqxqWmTMzg0b2zwNdkkYOpeV03ITq3pvlCVD4Js9dd3Fb2nZBNIFs2IdFfmK
         F0KIN+utoFzEEypmv/aoXrabLJjn4FXndwkWffXkjoSsB+sxQSoizkNHlFlwj0L5/FR4
         Hqlg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=bnfqvKEw5aP7UOEOx3W9CaWGunUzL+uqs10GsHrVCfw=;
        b=rvZxhhrsBCwbhh3Sw7ZPkbSGW2xMF9MeDAcmVF55HfrNYsoytZUbqO4mj1h65SfQ5+
         2KDjAUi2eoaHdD/i7yezRNf0EqhQv1lqk61dA1OX9wRNa3KZAeBqS6TMgRUoaH2UBOQV
         NOCSUlnDBXSq+a19c3vZUJohaw8NJ27jyVs2Ym2i1IHgCdWlr5MMiKmwxKLBc9BDoNn5
         g610snLSwNQFMepr9gyaoM/lM36ah9iO2m8Naqz8f1MLfuzrnaf1BmItD/VEWfkBa9DI
         zZuFFHu+bPaa3V9Om06tDZ4/o12WotwCDedwuF4x+uQz1wygQLtc/LqGeeYlazHaV02P
         BtDQ==
X-Gm-Message-State: APjAAAWtDgI5+Kzk06fsTubSCYtuzV5SOReun1tU0r8oied2LfuoTUgY
        KX/3Bp2C+4hOs7N5uMLUSVo=
X-Google-Smtp-Source: APXvYqyOrMgmZtG9BR8En0nRXNNcI5IdgfImVx8JhPlqNuKJolWpipdRHV24z/lyq2y5BlMOuSsJIg==
X-Received: by 2002:ac8:2e58:: with SMTP id s24mr31750641qta.52.1568219043497;
        Wed, 11 Sep 2019 09:24:03 -0700 (PDT)
Received: from localhost.localdomain ([2001:1284:f016:e600:cd79:21fe:b069:7c04])
        by smtp.gmail.com with ESMTPSA id b192sm10268684qkg.39.2019.09.11.09.24.01
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Wed, 11 Sep 2019 09:24:01 -0700 (PDT)
Received: by localhost.localdomain (Postfix, from userid 1000)
        id 8B566C4A64; Wed, 11 Sep 2019 13:23:59 -0300 (-03)
Date:   Wed, 11 Sep 2019 13:23:59 -0300
From:   Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
To:     Christophe JAILLET <christophe.jaillet@wanadoo.fr>
Cc:     davem@davemloft.net, vyasevich@gmail.com, nhorman@tuxdriver.com,
        linux-sctp@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] sctp: Fix the link time qualifier of
 'sctp_ctrlsock_exit()'
Message-ID: <20190911162359.GJ3431@localhost.localdomain>
References: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190911160239.10734-1-christophe.jaillet@wanadoo.fr>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Sep 11, 2019 at 06:02:39PM +0200, Christophe JAILLET wrote:
> The '.exit' functions from 'pernet_operations' structure should be marked
> as __net_exit, not __net_init.
> 
> Fixes: 8e2d61e0aed2 ("sctp: fix race on protocol/netns initialization")
> Signed-off-by: Christophe JAILLET <christophe.jaillet@wanadoo.fr>

Acked-by: Marcelo Ricardo Leitner <marcelo.leitner@gmail.com>
