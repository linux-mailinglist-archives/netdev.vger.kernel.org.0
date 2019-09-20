Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 7889EB888F
	for <lists+netdev@lfdr.de>; Fri, 20 Sep 2019 02:29:31 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2391488AbfITA3a (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Thu, 19 Sep 2019 20:29:30 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55352 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S2388479AbfITA33 (ORCPT
        <rfc822;netdev@vger.kernel.org>); Thu, 19 Sep 2019 20:29:29 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=niNEa8hioPBRHKHXeP0WJHipV7HxoFz3VIrUjzU8XzE=; b=rNe71Abp9l2eYmu9it6Gyx8Sd
        y2ZGomB329CnP9aTUz68QO4+Qjgo7+RrLuZSq4nSk9zLJRRNIxPvnquGebBfQktTt5UlbmjOeNyqu
        RhmRJNugIsD7Yo0RqUJJ2lwCk5irdoBZFWwvt+ST4UkAhPRf8N+ftiZ83gjzAX52vao389l8pOKJ5
        U6L7uKBE/dp0ixgaf4Q4MYI6DjpXg4CrSqxBVUcio9zpYb6EuDpCLBZ5rEMi5D52zX+oIcTbuaem1
        krhBMun8HT3ESxYUFE9nO0MK6ezowSzQiCHkdIPSbyFcpttSwLF9Fhs0prjQafVZlrhEPkMp2kvs0
        vcra7LPGw==;
Received: from [2601:1c0:6280:3f0::9a1f]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.2 #3 (Red Hat Linux))
        id 1iB6ng-0001Gm-Uk; Fri, 20 Sep 2019 00:29:28 +0000
Subject: Re: ionic build issues?
To:     Jakub Kicinski <jakub.kicinski@netronome.com>,
        Shannon Nelson <snelson@pensando.io>
Cc:     netdev@vger.kernel.org
References: <20190919172739.0c6b4bc4@cakuba.netronome.com>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <a99cf2d8-2479-2003-ac0b-10d44363c872@infradead.org>
Date:   Thu, 19 Sep 2019 17:29:28 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:60.0) Gecko/20100101
 Thunderbird/60.8.0
MIME-Version: 1.0
In-Reply-To: <20190919172739.0c6b4bc4@cakuba.netronome.com>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 9/19/19 5:27 PM, Jakub Kicinski wrote:
> Hi Shannon!
> 
> I've enabled ionic to do some build testing before pushing patches
> today, and with my tree which I build with W=1 C=1 I run into this:
> 
> ../drivers/net/ethernet/pensando/ionic/ionic_main.c: In function ‘ionic_adminq_cb’:
> ../drivers/net/ethernet/pensando/ionic/ionic_main.c:229:2: error: implicit declaration of function ‘dynamic_hex_dump’ [-Werror=implicit-function-declaration]
>   229 |  dynamic_hex_dump("comp ", DUMP_PREFIX_OFFSET, 16, 1,
>       |  ^~~~~~~~~~~~~~~~
> ../drivers/net/ethernet/pensando/ionic/ionic_lif.c: In function ‘ionic_notifyq_service’:
> ../drivers/net/ethernet/pensando/ionic/ionic_lif.c:673:2: error: implicit declaration of function ‘dynamic_hex_dump’ [-Werror=implicit-function-declaration]
>   673 |  dynamic_hex_dump("event ", DUMP_PREFIX_OFFSET, 16, 1,
>       |  ^~~~~~~~~~~~~~~~
> cc1: some warnings being treated as errors
> 
> Config attached, could you please take a look?
> 

Patch is already posted.
See https://lore.kernel.org/netdev/20190918195607.2080036-1-arnd@arndb.de/

-- 
~Randy
