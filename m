Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 6E5F91981F2
	for <lists+netdev@lfdr.de>; Mon, 30 Mar 2020 19:10:30 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729579AbgC3RKS (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 30 Mar 2020 13:10:18 -0400
Received: from bombadil.infradead.org ([198.137.202.133]:55376 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1728261AbgC3RKS (ORCPT
        <rfc822;netdev@vger.kernel.org>); Mon, 30 Mar 2020 13:10:18 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:To:
        Subject:Sender:Reply-To:Cc:Content-ID:Content-Description;
        bh=xvKGXN66IPdLhMLxi4EvBdyCAxhTtNLl8W+hr0uqsG4=; b=lmCcZn9Xgzfymb6KK6RMJ/n1oB
        iwCK982NruGPtJwy8npc/4q4+W+GglYbM4Hvxt+SUF7XbDNj0seTqkOiOnRiU02qAM8zNLjrak3im
        E8T3JkJo3nL47dlED1d0xwU79YxF7Bkjoue3R0kiIuslGIotw/uEvvH+4UWV9xsDKWViijpz2qPOd
        Gkb3QazG+2s8/1vQjWO0XZ+QbyyEfXZX3QJfwNZ0fOpL5ywkEmXeKl4J/XzdcSBldqtnvDgU2EP23
        MkIPYA2lbo75gr6xTIetNlOYALdbst23dHTdIucHvEuhQt5wTGKBLsexa6hWFvGWUqD5npnXcNVP0
        4Mh4NJfA==;
Received: from [2601:1c0:6280:3f0:897c:6038:c71d:ecac]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1jIxvV-0001Lq-Il; Mon, 30 Mar 2020 17:10:17 +0000
Subject: Re: 5.6: how to enable wireguard in "make menuconfig"
To:     Reindl Harald <h.reindl@thelounge.net>, netdev@vger.kernel.org
References: <439d7aec-3052-bbfc-94b9-2f85085e4976@thelounge.net>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <e8da71fe-cee8-77ac-ccbc-93478beaf998@infradead.org>
Date:   Mon, 30 Mar 2020 10:10:16 -0700
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.6.0
MIME-Version: 1.0
In-Reply-To: <439d7aec-3052-bbfc-94b9-2f85085e4976@thelounge.net>
Content-Type: text/plain; charset=utf-8
Content-Language: en-US
Content-Transfer-Encoding: 8bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 3/30/20 1:37 AM, Reindl Harald wrote:
> https://i.imgur.com/jcH9Xno.png
> https://www.wireguard.com/compilation/
> 
> crypto wise i have in the meantime enabled everything and the same in
> "networking options"
> 
> but "IP: WireGuard secure network tunnel" still don#t appear anywhere :-(
> 

In menuconfig, go to Device Drivers and then
Network Device support. It should look like this:

  │ │    --- Network device support                                       │ │  
  │ │    [*]   Network core driver support                                │ │  
  │ │    < >     Bonding driver support                                   │ │  
  │ │    < >     Dummy net driver support                                 │ │  
  │ │    < >     WireGuard secure network tunnel


but it requires Networking support and Network Devices and INET (TCP/IP).

-- 
~Randy

