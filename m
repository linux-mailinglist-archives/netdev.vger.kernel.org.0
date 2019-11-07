Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6958FF26C7
	for <lists+netdev@lfdr.de>; Thu,  7 Nov 2019 06:15:06 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1726200AbfKGFPE (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 7 Nov 2019 00:15:04 -0500
Received: from shards.monkeyblade.net ([23.128.96.9]:33600 "EHLO
        shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725870AbfKGFPE (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 7 Nov 2019 00:15:04 -0500
Received: from localhost (unknown [IPv6:2601:601:9f00:1e2::d71])
        (using TLSv1 with cipher AES256-SHA (256/256 bits))
        (Client did not present a certificate)
        (Authenticated sender: davem-davemloft)
        by shards.monkeyblade.net (Postfix) with ESMTPSA id A1ABC15108172;
        Wed,  6 Nov 2019 21:15:01 -0800 (PST)
Date:   Wed, 06 Nov 2019 21:14:59 -0800 (PST)
Message-Id: <20191106.211459.329583246222911896.davem@davemloft.net>
To:     lucien.xin@gmail.com
Cc:     netdev@vger.kernel.org, simon.horman@netronome.com,
        jbenc@redhat.com, tgraf@suug.ch, u9012063@gmail.com
Subject: Re: [PATCH net-next 0/5] lwtunnel: add ip and ip6 options setting
 and dumping
From:   David Miller <davem@davemloft.net>
In-Reply-To: <cover.1573030805.git.lucien.xin@gmail.com>
References: <cover.1573030805.git.lucien.xin@gmail.com>
X-Mailer: Mew version 6.8 on Emacs 26.1
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.12 (shards.monkeyblade.net [149.20.54.216]); Wed, 06 Nov 2019 21:15:01 -0800 (PST)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

From: Xin Long <lucien.xin@gmail.com>
Date: Wed,  6 Nov 2019 17:01:02 +0800

> With this patchset, users can configure options by ip route encap
> for geneve, vxlan and ersapn lwtunnel, like:
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 geneve class 0 type 0 \
>     data "1212121234567890" dst 10.1.0.2 dev geneve1
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 vxlan gbp 456 \
>     dst 10.1.0.2 dev erspan1
> 
>   # ip r a 1.1.1.0/24 encap ip id 1 erspan ver 1 idx 123 \
>     dst 10.1.0.2 dev erspan1
> 
> iproute side patch is attached on the reply of this mail.
> 
> Thank Simon for good advice.

Series applied, looks good.

Can you comment about how this code is using the deprecated nla
parsers for new options?

Thank you.
