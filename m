Return-Path: <netdev-owner@vger.kernel.org>
X-Original-To: lists+netdev@lfdr.de
Delivered-To: lists+netdev@lfdr.de
Received: from vger.kernel.org (vger.kernel.org [209.132.180.67])
	by mail.lfdr.de (Postfix) with ESMTP id 69D3216B87A
	for <lists+netdev@lfdr.de>; Tue, 25 Feb 2020 05:19:14 +0100 (CET)
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
        id S1728888AbgBYETM (ORCPT <rfc822;lists+netdev@lfdr.de>);
        Mon, 24 Feb 2020 23:19:12 -0500
Received: from mail.kernel.org ([198.145.29.99]:46378 "EHLO mail.kernel.org"
        rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
        id S1728866AbgBYETM (ORCPT <rfc822;netdev@vger.kernel.org>);
        Mon, 24 Feb 2020 23:19:12 -0500
Received: from cakuba.hsd1.ca.comcast.net (c-67-180-217-166.hsd1.ca.comcast.net [67.180.217.166])
        (using TLSv1.2 with cipher ECDHE-RSA-AES256-GCM-SHA384 (256/256 bits))
        (No client certificate requested)
        by mail.kernel.org (Postfix) with ESMTPSA id ADDD024670;
        Tue, 25 Feb 2020 04:19:11 +0000 (UTC)
DKIM-Signature: v=1; a=rsa-sha256; c=relaxed/simple; d=kernel.org;
        s=default; t=1582604352;
        bh=d9j08WxmxDtiM6SClFanQC1aN+HpV0+3e4dMfPwqKEI=;
        h=Date:From:To:Cc:Subject:In-Reply-To:References:From;
        b=jJ9Oe8SPyIibznIYoYYKZb0BY3g1oRyH1gl0AHf4Wjb/pNRho0qN6aGs2pzJeZK8r
         mfjI35ngoP6VH6F4CM5xZaEEcx1O/hBfFpbLdWbzecNefMRismezZjw3MJb4lbF3uA
         SD9utNrMAmMkEiU/XEzNodQU60Jv1WT8aPNWNX/A=
Date:   Mon, 24 Feb 2020 20:19:10 -0800
From:   Jakub Kicinski <kuba@kernel.org>
To:     Jiri Pirko <jiri@resnulli.us>
Cc:     netdev@vger.kernel.org, davem@davemloft.net, nhorman@tuxdriver.com,
        jhs@mojatatu.com, xiyou.wangcong@gmail.com, idosch@mellanox.com,
        mlxsw@mellanox.com
Subject: Re: [patch net-next 03/10] drop_monitor: extend by passing cookie
 from driver
Message-ID: <20200224201910.281b80a5@cakuba.hsd1.ca.comcast.net>
In-Reply-To: <20200224210758.18481-4-jiri@resnulli.us>
References: <20200224210758.18481-1-jiri@resnulli.us>
        <20200224210758.18481-4-jiri@resnulli.us>
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: netdev-owner@vger.kernel.org
Precedence: bulk
List-ID: <netdev.vger.kernel.org>
X-Mailing-List: netdev@vger.kernel.org

On Mon, 24 Feb 2020 22:07:51 +0100, Jiri Pirko wrote:
> +		fa_cookie = kmemdup(hw_metadata->fa_cookie, cookie_size,
> +				    GFP_ATOMIC | __GFP_ZERO);

nit: kmemdup with GFP_ZERO seems like a strange combination
