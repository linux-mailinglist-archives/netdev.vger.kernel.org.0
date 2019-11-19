Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 31C2D1027C9
	for <lists+netdev@lfdr.de>; Tue, 19 Nov 2019 16:13:21 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728300AbfKSPNO (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 19 Nov 2019 10:13:14 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:60410 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726637AbfKSPNO (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 19 Nov 2019 10:13:14 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=5qNH0rNiKvfJDdxRh+5cWf5BX5eczgkRcY4ZPO+/TwE=; b=AeSgyU6o4dXFLLWUZleLPkNoT
        eAzZI8/6uO1O9y77MQOs+XCcjHmi0zxAB9CrGV37e4tfw0e770USNb5cN+4i9hm+Fh3zQRkDV5lIX
        aranSHGIniwfHvdiburKsDj209T9LGjp7NOJWeOGcBRViKjJiwBZzHi4H1f9jYpXVdTkVQjoVFANa
        7farnFptcQCJwW4/gcij9/ORkWhAFYyof2raVQ/3R2B9E7BqeDx0GOlQLy+hlvFuNiUnnGS5jOtjL
        VLYI0VkXeAtT/AmBgHieLmigNhEoNWWvzSa4cus8tFr/NfLFVTvy/K+Y2SSlGwYFfjQOEy3xBu4Qf
        O6lqi5n6Q==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1iX5Bp-0003Nl-Mu; Tue, 19 Nov 2019 15:13:13 +0000
Subject: Re: linux-next: Tree for Nov 19 (bpf)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        bpf@vger.kernel.org,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191119194658.39af50d0@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <ac0b86e4-611b-81d1-ba09-e819218efe3f@infradead.org>
Date:   Tue, 19 Nov 2019 07:13:12 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.1.1
MIME-Version: 1.0
In-Reply-To: <20191119194658.39af50d0@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/19/19 12:46 AM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20191118:
> 

on i386 or x86_64:

../kernel/bpf/btf.c:3466:1: error: empty enum is invalid
 };
 ^

when CONFIG_NET is not set/enabled.


-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
