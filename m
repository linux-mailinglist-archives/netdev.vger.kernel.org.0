Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [23.128.96.18])
	by mail.lfdr.de (Postfix) with ESMTP id D66512A4F1D
	for <lists+netdev@lfdr.de>; Tue,  3 Nov 2020 19:42:18 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1729111AbgKCSmL (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Tue, 3 Nov 2020 13:42:11 -0500
Received: from lindbergh.monkeyblade.net ([23.128.96.19]:58952 "EHLO
        lindbergh.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
        with ESMTP id S1725892AbgKCSmL (ORCPT
        <rfc822;netdev@vger.kernel.org>); Tue, 3 Nov 2020 13:42:11 -0500
Received: from casper.infradead.org (casper.infradead.org [IPv6:2001:8b0:10b:1236::1])
        by lindbergh.monkeyblade.net (Postfix) with ESMTPS id 0313CC0613D1;
        Tue,  3 Nov 2020 10:42:10 -0800 (PST)
DKIM-Signature: v=1; a=rsa-sha256; q=dns/txt; c=relaxed/relaxed;
        d=infradead.org; s=casper.20170209; h=Content-Transfer-Encoding:Content-Type:
        In-Reply-To:MIME-Version:Date:Message-ID:From:References:Cc:To:Subject:Sender
        :Reply-To:Content-ID:Content-Description;
        bh=YXZpVNwL/dLpoF4pzz/IhdjtjMqDWoU1YThxJJXLyEE=; b=HcXUbLLe/5DD24k7gLkgoWtF47
        N/BdNAnK5efaY7Y4mTQRxUAVGgmp17qAjZz+J1FnU/GnBwU8E8LPPwVIm3zRqkkvIo3zV0wINOI4q
        XYFr5512GTutDblcNmsZ6eC24+eQznruWiVrjykYAOWO1voX0S84xH2I2tUndVapFWg4VCMQYWD/r
        tZiTvCtxTNEZAah+j+0aEduJ6WwVh2xSE0KBkcJDZ1gXWGLd0tIGhRJ/6Mt2ijjykyLbRpqSBbeHE
        tgQNfW907UpBY92lOHg4IYQB9+4wXiE8GBgjgSU/ou70BntuKLUbW0coUEU6jNF/WnDpPHl6FEV0y
        QTDfJhfw==;
Received: from [2601:1c0:6280:3f0::60d5]
        by casper.infradead.org with esmtpsa (Exim 4.92.3 #3 (Red Hat Linux))
        id 1ka1Fu-0004nl-Ky; Tue, 03 Nov 2020 18:42:07 +0000
Subject: Re: linux-next: Tree for Nov 3
 (drivers/net/ethernet/marvell/prestera/prestera_switchdev.o)
To:     Stephen Rothwell <sfr@canb.auug.org.au>,
        Linux Next Mailing List <linux-next@vger.kernel.org>
Cc:     Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Vadym Kochan <vadym.kochan@plvision.eu>,
        "netdev@vger.kernel.org" <netdev@vger.kernel.org>
References: <20201103181931.0ea86551@canb.auug.org.au>
From:   Randy Dunlap <rdunlap@infradead.org>
Message-ID: <0fcb653e-8a8c-350e-abf7-d802867ef0e9@infradead.org>
Date:   Tue, 3 Nov 2020 10:42:02 -0800
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:68.0) Gecko/20100101
 Thunderbird/68.12.0
MIME-Version: 1.0
In-Reply-To: <20201103181931.0ea86551@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Language: en-US
Content-Transfer-Encoding: 7bit
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On 11/2/20 11:19 PM, Stephen Rothwell wrote:
> Hi all,
> 
> Changes since 20201102:
> 

on x86_64:

when CONFIG_BRIDGE=m:

ld: drivers/net/ethernet/marvell/prestera/prestera_switchdev.o: in function `prestera_bridge_port_event':
prestera_switchdev.c:(.text+0x2ebd): undefined reference to `br_vlan_enabled'


Also please add drivers/net/ethernet/marvell/prestera/ to the
MAINTAINERS file.

thanks.
-- 
~Randy
Reported-by: Randy Dunlap <rdunlap@infradead.org>
