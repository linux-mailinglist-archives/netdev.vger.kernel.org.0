Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 3ADA1D6F62
	for <lists+netdev@lfdr.de>; Tue, 15 Oct 2019 08:05:49 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727116AbfJOGFf (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 15 Oct 2019 02:05:35 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:43926 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726118AbfJOGFf (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 15 Oct 2019 02:05:35 -0400
Received: by mail-wr1-f65.google.com with SMTP id j18so22181553wrq.10
        for <netdev@vger.kernel.org>; Mon, 14 Oct 2019 23:05:34 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=RX/0WlRnLie8nc00maGTLlElJyVLretH5t1EwCBi6yQ=;
        b=GrUUroDHZcx5miQbAFag6xz92nI0cLIl5rk+R3g1wX/5W9D11BrGt175qRQMQz4sdU
         Z/VSOsDk3shgI3UauWNw3dWtJYec3AJ1ORB4IxacWWokYGdhf3Zf1t7GmFQIyNTu/Fw8
         ghFePxQ5WBts+vvQ+OZ0i4p4Oqk6Kav+q+xhp2Q7KngBDXRDYU7ylzZr7SScJe28t69X
         88cN8YlgGEiHbRAxFtFXt9b9h/+2uuvr20gOJJEpzujyhL/Zt3gUu2ZN4/lQpm8tZsb3
         ccg3BXUnWkwe+0gwbd3nLhGiQ2Y339kCN5w8cYQHww0TAOlWDASIGQrOYElnzmZ9B2bT
         G96g==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=RX/0WlRnLie8nc00maGTLlElJyVLretH5t1EwCBi6yQ=;
        b=P44nyLSWZ/JNgLHaeVibVSGbHDCS+1qUwxLaYL6WIV1ioVsZ6NHLtiu23UrdCLDDKm
         cQMapvDDcpNI2TgtehCJmE+9jO5AlX57Ug0LmaaGvSQHRNo7ozhdGh4sAgCHDaVQZXAE
         RXsuFuSiwSRcexRHoASotuzIWBsmQoufsluY+sbB4sEvSbEhKeXZTADvwK6qZl78dRZL
         iw7sfmjl3IZ5x1qt5JSCyTGeBBY1TR7WYFqDC93btGQfYeM0bgd02qG0PAMLUS69mxke
         TAGdkpxA2UVnDh1tJq0YHGMthHzb1JX3ev2dVT0rj2HyiiqFaGRsm5v0xYt/YwzCD+nc
         odRA==
X-Gm-Message-State: APjAAAVHJc3ZGu3DFbj6b6i8CgmPwUAKPiIE7RMumXShaw/wqwzwQO7e
        sSaFm2qk5OhhnSSz/NI5Z2Gd+w==
X-Google-Smtp-Source: APXvYqz0PjvYI9x4nvoVkn96vBeaRX6h9jYu5qLUxzQNkmLB3kDrDb8R72hQMk3AYY0SKbUL0C+sdQ==
X-Received: by 2002:adf:b69f:: with SMTP id j31mr28498627wre.277.1571119533683;
        Mon, 14 Oct 2019 23:05:33 -0700 (PDT)
Received: from localhost (ip-89-177-225-135.net.upcbroadband.cz. [89.177.225.135])
        by smtp.gmail.com with ESMTPSA id e18sm28357956wrv.63.2019.10.14.23.05.32
        (version=TLS1_3 cipher=TLS_AES_256_GCM_SHA384 bits=256/256);
        Mon, 14 Oct 2019 23:05:33 -0700 (PDT)
Date:   Tue, 15 Oct 2019 08:05:32 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Pablo Neira Ayuso <pablo@netfilter.org>
Cc:     netfilter-devel@vger.kernel.org, davem@davemloft.net,
        netdev@vger.kernel.org, jakub.kicinski@netronome.com,
        saeedm@mellanox.com, vishal@chelsio.com, vladbu@mellanox.com,
        ecree@solarflare.com
Subject: Re: [PATCH net-next,v5 1/4] net: flow_offload: flip mangle action
 mask
Message-ID: <20191015060532.GD2314@nanopsycho>
References: <20191014221051.8084-1-pablo@netfilter.org>
 <20191014221051.8084-2-pablo@netfilter.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20191014221051.8084-2-pablo@netfilter.org>
User-Agent: Mutt/1.12.1 (2019-06-15)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Tue, Oct 15, 2019 at 12:10:48AM CEST, pablo@netfilter.org wrote:
>Userspace tc pedit action performs a bitwise NOT operation on the mask.
>All of the existing drivers in the tree undo this operation. Prepare the
>mangle mask in the way the drivers expect from the
>tc_setup_flow_action() function.
>
>Signed-off-by: Pablo Neira Ayuso <pablo@netfilter.org>

Acked-by: Jiri Pirko <jiri@mellanox.com>
