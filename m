Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id EEF5261F2B
	for <lists+netdev@lfdr.de>; Mon,  8 Jul 2019 15:00:46 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729638AbfGHNAp (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 8 Jul 2019 09:00:45 -0400
Received: from mail-wm1-f65.google.com ([209.85.128.65]:55951 "EHLO
        mail-wm1-f65.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727601AbfGHNAo (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 8 Jul 2019 09:00:44 -0400
Received: by mail-wm1-f65.google.com with SMTP id a15so15701663wmj.5
        for <netdev@vger.kernel.org>; Mon, 08 Jul 2019 06:00:43 -0700 (PDT)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=resnulli-us.20150623.gappssmtp.com; s=20150623;
        h=date:from:to:cc:subject:message-id:references:mime-version
         :content-disposition:in-reply-to:user-agent;
        bh=HIqzuF4fztqUvFHyjSEOGIhZDL//Tque1V3TPG7rr5o=;
        b=FNSrRnLkxcisgxQltB6sxzRY+voLfflj+YlsyMnTCJVbwxFzRWK0U0QBNyumY2ozZr
         GmaCI5S2nZ/TP5IRYEpk2mgSmD2JZiuQ5vw6HjP14oFN4nuXbf1oqQ1TDb038Rs9Ck2Q
         wS8OJiP4a7sOu1dyfui4VJPQWZBBr3XytYccLFzMygDjp33+xdpnDrPu7Y+K7PKkc8Cp
         AixACu9L8oJOQbSlYjDQvnzQ0VhzQZACpqUuZZk1SUPieFMGWjwSZo6t8Qwnuh4HQGEJ
         mBLF33T5YRepTSRreNeFkyX3lk38pHhW9BaFmPYNii+75g7k9PR1dby08qDXT55MPg9T
         PVhg==
X-Google-DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/relaxed;
        d=1e100.net; s=20161025;
        h=x-gm-message-state:date:from:to:cc:subject:message-id:references
         :mime-version:content-disposition:in-reply-to:user-agent;
        bh=HIqzuF4fztqUvFHyjSEOGIhZDL//Tque1V3TPG7rr5o=;
        b=FfsURkojQ+rJOrI7+ZOH5B/eTk2NTPvNQ7OQk4+w57AXXoi6wRhjv0Y76o+H6MtSi1
         HtByrXkyicDEXVpBWJnDQf8Hyz3Co5yzPdJFnrDFDHNNWRVatGiwAbrEPiOWe+Nxz3I+
         5SgnchT3hZ/KzOyBGd+f2e8Degds0BOviHjJRBAEKqjltkEIYm18xShCSnMvzy0+Ihgu
         UVSz1Krjq2p1AYjQJsTXvl1F0WGxstooJb8doFcFhDYr7FpIwMqm9RND1/xLeewEP1m0
         fGqhfGExs+kOnFjFPcD4MWYPrBrkVG5DsUw5fSagGChd6jvCo5egCq9fDT/OVV8thzdG
         +TMw==
X-Gm-Message-State: APjAAAV0tQuNv+r41W0PvQHbCOREXnITKXOeIqPOUWYS+2KaSo5jU0lT
        b0MdqqlviNgJO6ywhTMj4RblIQ==
X-Google-Smtp-Source: APXvYqyt82sWvmf5acR69iQ5JhB9nbB0H9ulg13xB4lGf7bdKzJbiPkwLQgW1NOaiyQtCoAfj+4DvA==
X-Received: by 2002:a1c:a7c6:: with SMTP id q189mr17106806wme.146.1562590842519;
        Mon, 08 Jul 2019 06:00:42 -0700 (PDT)
Received: from localhost (mail.chocen-mesto.cz. [85.163.43.2])
        by smtp.gmail.com with ESMTPSA id o24sm20463796wmh.2.2019.07.08.06.00.42
        (version=TLS1_3 cipher=AEAD-AES256-GCM-SHA384 bits=256/256);
        Mon, 08 Jul 2019 06:00:42 -0700 (PDT)
Date:   Mon, 8 Jul 2019 15:00:41 +0200
From:   Jiri Pirko <jiri@resnulli.us>
To:     Tariq Toukan <tariqt@mellanox.com>
Cc:     "David S. Miller" <davem@davemloft.net>, netdev@vger.kernel.org,
        Eran Ben Elisha <eranbe@mellanox.com>, ayal@mellanox.com,
        jiri@mellanox.com, Saeed Mahameed <saeedm@mellanox.com>,
        moshe@mellanox.com
Subject: Re: [PATCH net-next 10/16] net/mlx5e: Add cq info to tx reporter
 diagnose
Message-ID: <20190708130041.GH2201@nanopsycho>
References: <1562500388-16847-1-git-send-email-tariqt@mellanox.com>
 <1562500388-16847-11-git-send-email-tariqt@mellanox.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1562500388-16847-11-git-send-email-tariqt@mellanox.com>
User-Agent: Mutt/1.11.4 (2019-03-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

Sun, Jul 07, 2019 at 01:53:02PM CEST, tariqt@mellanox.com wrote:
>From: Aya Levin <ayal@mellanox.com>
>
>Add cq information to general diagnose output: CQ size and stride size.
>Per SQ add information about the related CQ: cqn and CQ's HW status.
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter tx
>Common config:
>   SQ: stride size: 64 size: 1024
>   CQ: stride size: 64 size: 1024
> SQs:
>   channel ix: 0 sqn: 4283 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1030 HW status: 0

The nesting of "cqn" and "HW status" is not visible there. I know it is
comment to iproute2 patch, but still. Should be corrected in this patch
description too.

Other than this, the patch looks good.


>   channel ix: 1 sqn: 4288 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1034 HW status: 0
>   channel ix: 2 sqn: 4293 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1038 HW status: 0
>   channel ix: 3 sqn: 4298 HW state: 1 stopped: false cc: 0 pc: 0 CQ: cqn: 1042 HW status: 0
>
>$ devlink health diagnose pci/0000:00:0b.0 reporter tx -jp
>{
>    "Common config": [
>        "SQ": {
>            "stride size": 64,
>            "size": 1024
>        },
>        "CQ": {
>            "stride size": 64,
>            "size": 1024
>        } ],
>    "SQs": [ {
>            "channel ix": 0,
>            "sqn": 4283,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0,
>            "CQ": {
>                "cqn": 1030,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 1,
>            "sqn": 4288,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0,
>            "CQ": {
>                "cqn": 1034,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 2,
>            "sqn": 4293,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0,
>            "CQ": {
>                "cqn": 1038,
>                "HW status": 0
>            }
>        },{
>            "channel ix": 3,
>            "sqn": 4298,
>            "HW state": 1,
>            "stopped": false,
>            "cc": 0,
>            "pc": 0,
>            "CQ": {
>                "cqn": 1042,
>                "HW status": 0
>            }
>        } ]
>}
>
>Signed-off-by: Aya Levin <ayal@mellanox.com>
>Signed-off-by: Tariq Toukan <tariqt@mellanox.com>

[...]
