Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id D3B171102E9
	for <lists+netdev@lfdr.de>; Tue,  3 Dec 2019 17:52:55 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1727165AbfLCQwv (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Dec 2019 11:52:51 -0500
Received: from bombadil.infradead.org ([198.137.202.133]:59240 "EHLO
        bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1726422AbfLCQwv (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Dec 2019 11:52:51 -0500
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=bombadil.20170209; h=Content-Transfer-Encoding:
        Content-Type:In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:
        Subject:Sender:Reply-To:Content-ID:Content-Description:Resent-Date:
        Resent-From:Resent-Sender:Resent-To:Resent-Cc:Resent-Message-ID:List-Id:
        List-Help:List-Unsubscribe:List-Subscribe:List-Post:List-Owner:List-Archive;
         bh=v3BPQtD+QVqQIqdxUQrpB1wqZFcQ6To0I0TwFKS6Qgw=; b=Use9oDFlu/naXLYpQE8BPR6On
        HvtKfJXEnEQlrwblDGUpHPy4DwYrKclJNiE22yYsAw6NwQcxVX6WCsgmOoMe9KxLKX9lO5SktfwQZ
        RKOJxIbsx9ZfSab+MovPbeGgZ/36DJqiSgYOHfgKZF8Olnl1A8jWcON9zYRvq8c+lhgcs1wsW6XbP
        /FRmbHMR7uh9GQejg3MNKWUBIDPnvY8G/j7PWoiet0aQyTiGh6sjeFyphq0zTJZMwWGfndRr0kbfG
        t5hJnHUtey2TAXOYQsvi+mYvBJpc9tGZeNpY+M4hyC2I5Gdngb7D2du2jlUStSIi9h8nxKy4jc6G9
        WU5+8hyjA==;
Received: from [2601:1c0:6280:3f0::5a22]
        by bombadil.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1icBPt-0001Wg-Sj; Tue, 03 Dec 2019 16:52:49 +0000
Subject: Re: linux-next: Tree for Dec 3 (drivers/ptp/ptp_clockmatrix)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Richard Cochran <richardcochran@gmail.com>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20191203155405.31404722@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <f42a6d9b-bbce-15ee-c5e2-46057c65f1d4@infradead.org>
Date:   Tue, 3 Dec 2019 08:52:49 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.2.1
MIME-Version: 1.0
In-Reply-To: <20191203155405.31404722@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 12/2/19 8:54 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Please do not add any material for v5.6 to your linux-next included
> trees until after v5.5-rc1 has been released.
> 
> Changes since 20191202:
> 

on x86_64:
CONFIG_I2C=m

ld: drivers/ptp/ptp_clockmatrix.o: in function `idtcm_xfer':
ptp_clockmatrix.c:(.text+0x135): undefined reference to `i2c_transfer'
ld: drivers/ptp/ptp_clockmatrix.o: in function `idtcm_driver_init':
ptp_clockmatrix.c:(.init.text+0x14): undefined reference to `i2c_register_driver'
ld: drivers/ptp/ptp_clockmatrix.o: in function `idtcm_driver_exit':
ptp_clockmatrix.c:(.exit.text+0xd): undefined reference to `i2c_del_driver'



-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
