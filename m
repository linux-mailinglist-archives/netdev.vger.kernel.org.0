Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id DBC6B118121
	for <lists+netdev@lfdr.de>; Tue, 10 Dec 2019 08:13:41 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727194AbfLJHNg (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 10 Dec 2019 02:13:36 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:52078 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726819AbfLJHNg (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 10 Dec 2019 02:13:36 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=qJtZ/EZbba/tDj5kKsGUA8Y5CP3PwV30hOmaCOP3V18=; b=YeXg7xugCdWV9vouqSVt4pIjW
        wOe92YqAtHxamGr/YJJku53cGYbXY2W1lncxSFRxJazlx4XugtTrqBgJpizJIrawstQnznQJHMPhT
        iNoN/4kZ8iSeMq/9RE5rnmGOnB3t1zAsRaHPZhC+ezWFd6eS6ww/X5a+Ckhg116EaGgwNqHKdj9sq
        BJWA/amAsFYDdk/Nmb2SE1dIDseHFfd9Hqz0DbIKru8cZAhjXLRq/v49aJ7tUtMRwJ9Fl8cfubvdR
        QBAEyE5kMk8Gp3gu8LLNF7bggBBkvTrd0zKcnJBBk74RStoX00vZAM9m7fF9TFnH0Uvnqvp4+Bb39
        JdMCzsbUQ==;
Received: from [2601:1c0:6280:3f0::3deb]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ieZiB-0003bX-8B; Tue, 10 Dec 2019 07:13:35 +0000
Subject: Re: linux-next: Tree for Dec 10 (ethernet/8390/8390p.c)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>,
        David Miller <davem@davemloft.net>
References: <20191210140225.1aa0c90e@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ce89aa80-558c-1ccb-afbe-0af6bc4f3e19@infradead.org>
Date:   Mon, 9 Dec 2019 23:13:34 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191210140225.1aa0c90e@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/9/19 7:02 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20191209:
> 

on i386:

../drivers/net/ethernet/8390/8390p.c:44:6: error: conflicting types for ‘eip_tx_timeout’
 void eip_tx_timeout(struct net_device *dev, unsigned int txqueue)
      ^~~~~~~~~~~~~~
In file included from ../drivers/net/ethernet/8390/lib8390.c:75:0,
                 from ../drivers/net/ethernet/8390/8390p.c:12:
../drivers/net/ethernet/8390/8390.h:53:6: note: previous declaration of ‘eip_tx_timeout’ was here
 void eip_tx_timeout(struct net_device *dev);
      ^~~~~~~~~~~~~~


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
