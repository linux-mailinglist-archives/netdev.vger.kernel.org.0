Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id C8E70134F39
	for <lists+netdev@lfdr.de>; Wed,  8 Jan 2020 22:59:44 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727518AbgAHV7l (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Wed, 8 Jan 2020 16:59:41 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:53802 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1727392AbgAHV7i (ORCPT
        <rfc822;netdev@vger.kernel.org>); Wed, 8 Jan 2020 16:59:38 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=In-Reply-To:Content-Transfer-Encoding
        :Content-Type:MIME-Version:References:Message-ID:Subject:Cc:To:From:Date:
        Sender:Reply-To:Content-ID:Content-Description:Resent-Date:Resent-From:
        Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:List-Help:
        List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
        bh=fpLQMPlqsm+ctr9jMLLdhQwTELJKINmmXpMUEFwKJhY=; b=NKWbI2inFNNSnucVY4N58bq5MF
        zTeWOZwUNDS3BbaJMIpwvytUDmoKfwUdOAoEwGMFzHYtMbSnHcEWg4VTL4hr1QRE1WlizuOsMqFR/
        aOD5hfi1sNeBtI34begJz4NEKC8pPD0o0vPiJGPwynr9xSJUNYEVnlqcEB8vmL7F6WbjOGiSxFBwO
        h68dStYkkK17q5k6euPuNzghJULxUCxJYi7k/rT1Z8h3xPZqPw17QJlwN7CRvOLLrT6/CpsUmWwPA
        oTc9H+8efakkUoOcYcet8JjTL9U50C72WoaOyDIKdtzT0guygUX3MwcjsuyPmECYce+orHYB1VNMc
        YkKhDpxA==;
Received: from willy by bombadil.infradead.org with local (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ipJMP-0002Pt-6H; Wed, 08 Jan 2020 21:59:29 +0000
Date:   Wed, 8 Jan 2020 13:59:29 -0800
From:   Matthew Wilcox <willy@infradead.org>
To:     David Miller <davem@davemloft.net>
Cc:     yukuai3@huawei.com, klassert@kernel.org, hkallweit1@gmail.com,
        jakub.kicinski@netronome.com, hslester96@gmail.com, mst@redhat.com,
        yang.wei9@zte.com.cn, netdev@vger.kernel.org, yi.zhang@huawei.com,
        zhengbin13@huawei.com
Subject: Re: [PATCH V2] net: 3com: 3c59x: remove set but not used variable
 'mii_reg1'
Message-ID: <20200108215929.GM6788@bombadil.infradead.org>
References: <20200106125337.40297-1-yukuai3@huawei.com>
 <20200108.124021.2097001545081493183.davem@davemloft.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20200108.124021.2097001545081493183.davem@davemloft.net>
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Wed, Jan 08, 2020 at 12:40:21PM -0800, David Miller wrote:
> From: yu kuai <yukuai3@huawei.com>
> Date: Mon, 6 Jan 2020 20:53:37 +0800
> 
> > Fixes gcc '-Wunused-but-set-variable' warning:
> > 
> > drivers/net/ethernet/3com/3c59x.c: In function ‘vortex_up’:
> > drivers/net/ethernet/3com/3c59x.c:1551:9: warning: variable
> > ‘mii_reg1’ set but not used [-Wunused-but-set-variable]
> > 
> > It is never used, and so can be removed.
> > 
> > Signed-off-by: yu kuai <yukuai3@huawei.com>
> > ---
> > changes in V2
> > -The read might have side effects, don't remove it.
> 
> Applied to net-next, thank you.

This waas a mistaken version; please revert and apply v3 instead.
