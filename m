Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 84FF9113A7
	for <lists+netdev@lfdr.de>; Thu,  2 May 2019 09:06:06 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726209AbfEBHGD (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 2 May 2019 03:06:03 -0400
Received: from mail-wr1-f65.google.com ([209.85.221.65]:40145 "EHLO
        mail-wr1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725795AbfEBHGD (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 2 May 2019 03:06:03 -0400
Received: by mail-wr1-f65.google.com with SMTP id h4so1709286wre.7
        for <netdev@vger.kernel.org>; Thu, 02 May 2019 00:06:02 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=9nuAm33drpfdpA1x3+NK73mmXriKTzSgcblLqhQ29Pw=;
        b=Kdm/coQh9bq5j1DRKQX40+S++ifLmi+eRj42FU865wlxEYU/zNEmB+bP6mgH1TVnvh
         MO5ci2j9qdjzhHd28jr85xd/VlUSARhWYu1Lao1/5Ef8fdOHkS6RV7ft06q5ZhvnHOhW
         xebcbwGacASGkOil2CfC2yw7RfHLFV/tlPromqUp+f6fK5yJ02BvZsz2p5JsXHtqAbv+
         t0FuZ9HJc6SdNGU6VOaSdFlbu+0jCwzZIXtOGbKf7L9UslG/GoiDLDybEuG48obm3bQi
         NNM2ob5Anu4vzJUdZrroZ4E6qX9C+F1+vXnkfMeJf/tKANsu+XElHjPPJnLMZ3v+HnrH
         yquw==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=9nuAm33drpfdpA1x3+NK73mmXriKTzSgcblLqhQ29Pw=;
        b=JTYyhKKK59lDZ8HgOYNTs75j5lSZE4R7XzcmY3v+hxYGFmDLx1JLf+uf6kFN4ENHum
         5mfdNXjgkbWLOSAfvSHIK+atjQHnyrp8xot94l65XhY7HmHM426aZn+GxH4AH+7+JFbr
         hs+7i5f4lO5aN5H1iyHTW2NfM1o334DXcl3M4wYTlbnytbIQQvp/AX57lFFRynytBvuN
         nzDLuHBPAiKj5OwJPFimptPGsp/Bu4qMmlZYCQeIOHVfW4Xj9CMugctZ0vJSpw8PH5j/
         s3FNK9KXNnoqsQxuo/n0MAeVGE1HX6dLDvSGlu9h8wfn4ZkRO/L5HP8fxB7vrWVOT2To
         0nMg==
X-Gm-Message-State: APjAAAW4QzqJQtSGQWOhSiQVBzQ9jeU13AYHeJ1rQShaA16ln6nvS0BO
        B8T9Y9K6d+RdNndbcdChoshx4fctvPk=
X-Google-Smtp-Source: APXvYqzBVvWGxy0TAtxRLATgIakbd6igIHh9RQK3an6oQRnq8oPIUQlrP2CZIH+ExSlSmvd97JCigQ==
X-Received: by 2002:adf:f588:: with SMTP id f8mr1003330wro.282.1556780761957;
        Thu, 02 May 2019 00:06:01 -0700 (PDT)
Received: from localhost (ip-89-177-126-50.net.upcbroadband.cz. [89.177.126.50])
        by smtp.gmail.com with ESMTPSA id h16sm28084677wrb.31.2019.05.02.00.06.01
        (version=TLS1_2 cipher=ECDHE-RSA-CHACHA20-POLY1305 bits=256/256);
        Thu, 02 May 2019 00:06:01 -0700 (PDT)
Date:   Thu, 2 May 2019 09:06:01 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Cong Wang <xiyou.wangcong@gmail.com>
Cc:     netdev@vger.kernel.org, Eran Ben Elisha <eranbe@mellanox.com>,
        Jiri Pirko <jiri@mellanox.com>
Subject: Re: [Patch net-next v2] net: add a generic tracepoint for TX queue
 timeout
Message-ID: <20190502070601.GD2251@nanopsycho>
References: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20190502025659.30351-1-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.11.3 (2019-02-01)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Thu, May 02, 2019 at 04:56:59AM CEST, xiyou.wangcong@gmail.com wrote:
>Although devlink health report does a nice job on reporting TX
>timeout and other NIC errors, unfortunately it requires drivers
>to support it but currently only mlx5 has implemented it.
>Before other drivers could catch up, it is useful to have a
>generic tracepoint to monitor this kind of TX timeout. We have
>been suffering TX timeout with different drivers, we plan to
>start to monitor it with rasdaemon which just needs a new tracepoint.
>
>Sample output:
>
>  ksoftirqd/1-16    [001] ..s2   144.043173: net_dev_xmit_timeout: dev=ens3 driver=e1000 queue=0
>
>Cc: Eran Ben Elisha <eranbe@mellanox.com>
>Cc: Jiri Pirko <jiri@mellanox.com>
>Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

Useful. Thanks!

Acked-by: Jiri Pirko <jiri@mellanox.com>
