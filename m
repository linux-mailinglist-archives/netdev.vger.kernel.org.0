Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id E232A1442A
	for <lists+netdev@lfdr.de>; Mon,  6 May 2019 06:49:44 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1725865AbfEFEtm (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 6 May 2019 00:49:42 -0400
Received: from shards.monkeyblade.net ([23.128.96.9]:59746 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725827AbfEFEtm (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 6 May 2019 00:49:42 -0400
Received: from localhost (unknown [IPv6:2601:601:9f80:35cd::3d8])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id 7624A12D8E1EF;
        Sun,  5 May 2019 21:49:41 -0700 (PDT)
Date:   Sun, 05 May 2019 21:49:40 -0700 (PDT)
Message-Id: <20190505.214940.508124612041892831.davem@davemloft.net>
To:     jakub.kicinski@netronome.com
Cc:     netdev@vger.kernel.org, oss-drivers@netronome.com,
        jiri@resnulli.us, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        f.fainelli@gmail.com, andrew@lunn.ch, vivien.didelot@gmail.com,
        gerlitz.or@gmail.com, simon.horman@netronome.com
Subject: Re: [PATCH net-next 00/13] net: act_police offload support
From:   David Miller <davem@davemloft.net>
In-Reply-To: <20190504114628.14755-1-jakub.kicinski@netronome.com>
References: <20190504114628.14755-1-jakub.kicinski@netronome.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Sun, 05 May 2019 21:49:41 -0700 (PDT)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Jakub Kicinski <jakub.kicinski@netronome.com>
Date: Sat,  4 May 2019 04:46:15 -0700

> this set starts by converting cls_matchall to the new flow offload
> infrastructure. It so happens that all drivers implementing cls_matchall
> offload today also offload cls_flower, so its a little easier for
> them to handle the actions in unified flow_rule format, even though
> in cls_matchall there is no flow to speak of. If a driver ever appears
> which would prefer the old, direct access to TC exts, we can add the
> pointer in the offload structure back and support both.
> 
> Next the act_police is added to actions supported by flow offload API.
> 
> NFP support for act_police offload is added as the final step.  The flower
> firmware is configured to perform TX rate limiting in a way which matches
> act_police's behaviour.  It does not use DMA.IN back pressure, and
> instead	drops packets after they had been already DMAed into the NIC.
> IOW it uses our standard traffic policing implementation, future patches
> will extend it to other ports and traffic directions.

Series applied.
