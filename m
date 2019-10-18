Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 24EE1DCEFE
	for <lists+netdev@lfdr.de>; Fri, 18 Oct 2019 21:04:50 +0200 (CEST)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S2443238AbfJRTEo (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Fri, 18 Oct 2019 15:04:44 -0400
Received: from vps0.lunn.ch ([185.16.172.187]:53204 "EHLO vps0.lunn.ch"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S2443231AbfJRTEo (ORCPT <rfc822;netdev@vger.kernel.org>);
        Fri, 18 Oct 2019 15:04:44 -0400
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed; d=lunn.ch;
        s=20171124; h=In-Reply-To:Content-Type:MIME-Version:References:Message-ID:
        Subject:Cc:To:From:Date:Sender:Reply-To:Content-Transfer-Encoding:Content-ID:
        Content-Description:Resent-Date:Resent-From:Resent-Sender:Resent-To:Resent-Cc
        :Resent-Message-ID:List-Id:List-Help:List-Unsubscribe:List-Subscribe:
        List-Post:List-Owner:List-Archive;
        bh=gChMufF7pDlsTELG5XA6EwZSwB7D7Bj07q+bOG1oGb4=; b=IGyKEOZxoCUxnUeBCWOSJG2WA1
        pwJZL0JfM1HnI+xcXSvrTouBqKE3Mc7qzDHniX8gNfhsM2muWm6BjYSAn1xIqqVE3EXORzkqF1y5C
        XOJvSFQxejNpDcR5xhWrLVoezqOGDnZrYxYswo7rAkTvoiDzEtyWq7LjfIYxen+XJk08=;
Received: from andrew by vps0.lunn.ch with local (Exim 4.92.2)
        (envelope-from <andrew@lunn.ch>)
        id 1iLXYA-0002oW-Fo; Fri, 18 Oct 2019 21:04:34 +0200
Date:   Fri, 18 Oct 2019 21:04:34 +0200
From:   Andrew Lunn <andrew@lunn.ch>
To:     Chen Wandun <chenwandun@huawei.com>
Cc:     igor.russkikh@aquantia.com, davem@davemloft.net,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] net: aquantia: add an error handling in
 aq_nic_set_multicast_list
Message-ID: <20191018190434.GG24810@lunn.ch>
References: <1571394037-19978-1-git-send-email-chenwandun@huawei.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1571394037-19978-1-git-send-email-chenwandun@huawei.com>
User-Agent: Mutt/1.10.1 (2018-07-13)
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Fri, Oct 18, 2019 at 06:20:37PM +0800, Chen Wandun wrote:
> From: Chenwandun <chenwandun@huawei.com>
> 
> add an error handling in aq_nic_set_multicast_list, it may not
> work when hw_multicast_list_set error; and at the same time
> it will remove gcc Wunused-but-set-variable warning.
> 
> Signed-off-by: Chenwandun <chenwandun@huawei.com>

Reviewed-by: Andrew Lunn <andrew@lunn.ch>

    Andrew
